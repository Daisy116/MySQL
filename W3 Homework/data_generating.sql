https://blog.csdn.net/qq_37107280/article/details/77542127  取整数或小数或精确位数
https://justdo2008.iteye.com/blog/1141609   字串處理
http://www.codedata.com.tw/database/mysql-tutorial-4-expression-function/   日期時間格式

為何create_at欄位的預設值一開始是null??
Google 搜: 知名品牌名字、mysql blob

亂數產生-365~0
SELECT round(RAND() * -365)

亂數產生一定範圍內的時間
SET @a = round(RAND() * -365);
SELECT DATE_ADD("2017-06-15", INTERVAL @a DAY);

試圖INSERT
SET @a = round(RAND() * -365);
INSERT INTO transaction (transaction_time) VALUES( DATE_ADD("2017-06-15", INTERVAL @a DAY));
---------------------------------------------------------------------------------------
產生交易資料的一筆(成功版)
SET @min = round(RAND() * -10000000);
SET @pID = round(RAND() * 100);
SET @cID = round(RAND() * 1002);
INSERT INTO transaction (product_id,customer_id,transaction_time) VALUES(@pID ,@cID ,DATE_ADD("2018-12-01 12:00:00", INTERVAL @min MINUTE));

寫成PROCEDURE
delimiter //
CREATE PROCEDURE createTransaction()
BEGIN
	SET @i = 1;
	WHILE @i<=10 DO
		SET @min = round(RAND() * -10000000);
		SET @pID = 1 + round(RAND() * 99);   -- 因為round(RAND() * 99)會產生0~99的亂數，所以前面+1
		SET @cID = 1 + round(RAND() * 1001);
		INSERT INTO transaction (product_id,customer_id,transaction_time) VALUES(@pID ,@cID ,DATE_ADD("2018-12-01 12:00:00", INTERVAL @min MINUTE));
		SET @i = @i + 1;
	END WHILE;
END//
delimiter ;
------------------------------------------------------------------------------------------
產生客戶資料的一筆(成功版)
SET @str1 = '王李張劉陳楊黃趙吳周徐孫馬朱胡郭何高林鄭謝羅梁宋唐許韓馮鄧曹彭曾蕭田董袁潘於蔣蔡余杜葉程蘇魏呂丁任沈姚盧姜崔鍾譚陸汪范金石廖賈夏韋付方白鄒孟熊秦邱江尹薛閆段雷侯龍史陶黎賀顧毛郝龔邵萬錢嚴覃武戴莫孔向湯';
SET @a1 = round(RAND() * 100);
SET @str2 = '玫怡佩宜慧淑惠雅彥美婉姿佳文孟姵麗曉家志俊士書子建人文哲君世國柏偉仁嘉彥智健';
SET @a2 = round(RAND() * 38);
SET @str3 = '君伶芳如玲樺吟蓉秀均萱菁婷蓁瑾靜琪臻儀豪瑋銘榮宏維偉慧慶齊華弘祥賢綺琪欣瑩緯書';
SET @a3 = round(RAND() * 39);
SET @result = concat(substring(@str1, @a1, 1),substring(@str2, @a2, 1),substring(@str3, @a3, 1));
INSERT INTO customer_info (customer_name) VALUES(@result);

寫成PROCEDURE
delimiter //
CREATE PROCEDURE createCustomer()
BEGIN
	SET @str1 = '王李張劉陳楊黃趙吳周徐孫馬朱胡郭何高林鄭謝羅梁宋唐許韓馮鄧曹彭曾蕭田董袁潘於蔣蔡余杜葉程蘇魏呂丁任沈姚盧姜崔鍾譚陸汪范金石廖賈夏韋付方白鄒孟熊秦邱江尹薛閆段雷侯龍史陶黎賀顧毛郝龔邵萬錢嚴覃武戴莫孔向湯';
	SET @str2 = '玫怡佩宜慧淑惠雅彥美婉姿佳文孟姵麗曉家志俊士書子建人文哲君世國柏偉仁嘉彥智健';
	SET @str3 = '君伶芳如玲樺吟蓉秀均萱菁婷蓁瑾靜琪臻儀豪瑋銘榮宏維偉慧慶齊華弘祥賢綺琪欣瑩緯書';
	SET @i = 1;
	WHILE @i<=10 DO
    	SET @a1 = round(RAND() * 100);
        SET @a2 = round(RAND() * 38);
        SET @a3 = round(RAND() * 39);
        SET @result = concat(substring(@str1, @a1, 1),substring(@str2, @a2, 1),substring(@str3, @a3, 1));
		INSERT INTO customer_info (customer_name) VALUES(@result);
		SET @i = @i + 1;
	END WHILE;
END//
delimiter ;
-------------------------------------------------------------------------------------


