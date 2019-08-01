04 Trigger.pdf
可以在欄位的預設值設current_timestamp()	，類型是datetime

Trigger : 讓資料庫的異動產生連鎖反應，通常Trigger用於log，看誰動了某個資料表的某筆資料，把動作的時間記錄在log資料表中
建Trigger一定要有文件!!!才知道動了哪幾個資料表(Trigger做了什麼事情)，才好追資料流動(資料庫第三個重要文件，前兩個是ER圖、資料字典)

CREATE TRIGGER trigger_name
AFTER/BEFORE INSERT/DELETE/UPDATE
ON 資料表名 FOR EACH ROW BEGIN -- trigger 觸發後要做的事情寫這裡 
END $$
  

很多的獨立sql command一起執行時，把分號(;)換成$$(任意符號也可以)，結束時再換回分號
DELIMITER $$   --開頭
...            --好幾個程式區段
DELIMITER ;    --結尾
--------------------------------------------------------------------
TRIGGER的insert範例，建一次就會起反應 :
delimiter $$ 
create trigger tr_log_userinfo_insert after insert 
on userinfo for each row 
begin 
set @body = concat( '將 [', new.uid, ', ', new.cname, '] 加到userinfo資料表中');
insert into log (body) values (@body);
end
delimiter ;

上面程式碼輸入後，更新userinfo的結果: 
將 [, 朱小花] 加到userinfo資料表中
2019-08-01 09:31:06
---------------------------------------------------------------------
TRIGGER的delete範例，建一次就會起反應 :
delimiter //
create trigger tr_log_userinfo_delete AFTER DELETE
on userinfo for each row 
begin 
set @body = concat( '將 [', old.uid, ', ', old.cname, '] 從userinfo資料表中刪除');
insert into log (body) values (@body);
end; //
delimiter ;

上面程式碼輸入後，刪除userinfo的結果:
將 [, 朱小小] 從userinfo資料表中刪除
2019-08-01 09:48:30
----------------------------------------------------------------------
TRIGGER的update失敗
delimiter //
create TRIGGER tr_log_userinfo_update after update
on userinfo for each row 
begin
	update userinfo.cname 
    set userinfo.cname = cname + old.cname - new.cname
	where userinfo.uid = new.uid;
end; //
delimiter ;
------------------------------------------------------------------
中斷TRIGGER，擋住一次兩筆以上的資料異動，錯誤在哪??
https://www.yiibai.com/mysql/signal-resignal.html
https://blog.csdn.net/qinyibut/article/details/89395302

delimiter #
create trigger tr_update BEFORE update
on userinfo for each row
begin
    set @count = if(@count is null, 1,@count+1);
    if (@count > 1) then
        SIGNAL SQLSTATE '45000'
        set MESSAGE_TEXTt = 'stop!';
        end if;
end #
delimiter ;
-------------------------------------------------------------------
MYSQL的變數名稱前要加上@符號
參數(function帶的值)不能加@


保留字NEW 表示新增的資料 
保留字OLD 表示刪除的資料 


TRIGGER要避免遞迴情況發生
--------------------------------------------------------------------
暫存表，如果查詢結果過程太長，會動態產生很多資料庫沒有的表，就需要暫存表
sql command和一般建表相差一個temporary保留字。
暫存表用來增加執行效率，在一段時間後系統會自動刪除暫存表。
別存太多資料在暫存表中，超過空間上限，會將多餘資料存到實體硬碟中，會降低資料庫的效率!!
------------------------------------------------------------------------------
預存程序 : 把程式碼(例如商業邏輯)存在資料庫，以函式的方式存在
商業邏輯的程式碼，可寫在資料庫中，商業邏輯最好寫在一個地方就好
sql command不是程式語言。
-----------------------------------------------------------
DELIMITER $$
CREATE PROCEDURE double_value(v int,out res int)
BEGIN
	SET res = v * 2;
END $$
DELIMITER ;

SET @res = 0;
CALL double_value(20,@res);
SELECT @res;

執行結果 : @res = 40
--------------------------------------------------------------
PROCEDURE沒有回傳值，而function有return
使用call呼叫PROCEDURE
使用select呼叫function

CREATE FUNCTION f_add(v1 float,v2 float) RETURNS float
RETURN v1+v2;

SELECT f_add(4.14,6.87);

執行結果 : f_add(4.14,6.87) = 11.01
-----------------------------------------------------------------
mysql宣告變數就要加@ : SET @n = 10;

使用(查詢)變數時用select : 
SET @n = (SELECT COUNT(*) FROM userinfo);
SELECT @n;

執行結果 : @n = 9
------------------------------------------------------------------
loop迴圈(不建議用)
label:loop
    ......
end loop;

while迴圈(用這個就好)
while 判斷式 do
    ......
end while;

repeat迴圈保證至少最一次
-------------------------------------------------------------------
做一個PROCEDURE，更改其中一筆的cname欄位。
如果begin後的第一行有錯誤，在呼叫這個PROCEDURE時會卡在第一行。

delimiter $$
create PROCEDURE pro_name()
begin
    update userinfo set cname = '豬小弟' where uid = 'A04';
END$$
delimiter ;

call pro_name();
-------------------------------------------------------------------
卡在第一行的解決方法-當錯誤發生就離開 : 
begin
    declare exit handler for sqlexception select 'ERROR';    --加上這一行，當有錯誤發生時，會離開函式，且在select 'ERROR'這一段可以做些處理(例如可call另一個procedure等等)
    update userinfo set cname = '豬小弟' where uid = 'A04';
END$$
------------------------------------------------------------------
卡在第一行的解決方法-當錯誤發生繼續執行 : 
delimiter $$
create PROCEDURE pro_name()
begin
    declare _rollback bool default false;
    declare continue handler for sqlexception set _rollback = true;

    start transaction;
        insert into userinfo (uid) values ('B09');
        if _rollback then
            select 'rollback'
            rollback;
        else
            select 'commit'
            commit;
        end if;
END$$
delimiter ;

call pro_name();

執行結果 : rollback : rollback
怎麼不會commit?
--------------------------------------------------------------------
CURSOR 為指標，指向查詢的一筆資料。CURSOR一次只會處理一筆資料

DECLARE name CURSOR FOR 查詢結果      --宣告CURSOR
open name;              --開始CURSOR動作
fetch name into 變數;    --將第一筆資料抓出來，放到變數中
close name;
------------------------------------------------------------------
CURSOR的範例 :
DELIMITER $$
CREATE PROCEDURE pro_test()
BEGIN
	DECLARE done int DEFAULT FAlse;
    DECLARE tmp_fee INT;
    DECLARE total int DEFAULT 0;
    DECLARE curs CURSOR for SELECT fee FROM bill;
    DECLARE CONTINUE handler for not FOUND set done = true;
    
    OPEN curs;
    FETCH curs INTO tmp_fee;
    
    WHILE not done do
    	SET total = total + tmp_fee;
        FETCH curs INTO tmp_fee;
    END WHILE;
    
    CLOSE curs;
    SELECT total;
END $$
DELIMITER ;

call pro_test()

執行結果 : total = 4050
--------------------------------------------------------------------
參考網址 : https://www.itread01.com/content/1545090511.html
將bill fee中的每一筆數字轉成國字數字。
DELIMITER $$
CREATE FUNCTION `mathToChar`(`str` INT) RETURNS VARCHAR(100) character set gbk
BEGIN 
DECLARE str1 VARCHAR(1) character set gbk DEFAULT  '' ; 
    DECLARE return_str VARCHAR(255) character set gbk DEFAULT '' ; 
    DECLARE i INT DEFAULT 1; 
    WHILE i < CHAR_LENGTH(str) + 1  DO 
     SET str1 = SUBSTRING(str,i,1);         
    CASE str1 
    WHEN '1' THEN SET str1 ="一"; 
    WHEN '2' THEN SET str1 ="二"; 
    WHEN '3' THEN SET str1 ="三"; 
    WHEN '4' THEN SET str1 ="四"; 
    WHEN '5' THEN SET str1 ="五"; 
    WHEN '6' THEN SET str1 ="六"; 
    WHEN '7' THEN SET str1 ="七"; 
    WHEN '8' THEN SET str1 ="八"; 
    WHEN '9' THEN SET str1 ="九"; 
	WHEN '0' THEN SET str1 ="零";
    END CASE;         
        SET return_str = CONCAT(return_str,str1); 
        SET i = i + 1 ; 
	END WHILE; 
    RETURN return_str; 
END $$
DELIMITER ;
UPDATE bill set fee2 =  mathToChar(fee);
-- SELECT mathToChar(213123) AS mathTochar;
-------------------------------------------------------------------
刪除procedure : drop procedure if exists bill_fee
UPDATE bill set fee2 =  mathToChar(fee)
-------------------------------------------------------------------
mysql的備份就是匯出成sql檔即可，還原就是匯入

更多 -> 權限 -> 新增使用者帳號
外包商的權限只開show view這個權限

一般都在系統後端做權限控制，不太會在資料庫做。
-------------------------------------------------------------------
鎖定 : 同一時間，只能有一個人更改資料，等他改好了才能換其他人做事
要對資料庫下鎖定

儲存引擎 
舊的(MYSQL5)格式 : MYISAM
MYSQL8用的是INNODB引擎，這個是正規的



作業 : 
用PROCEDURE做random的函式產生資料