-- 查詢每筆電話的總金額，這張表可查詢極端值!!!
SELECT tel,sum(fee) as 金額加總   --'平均金額'有無''都可以
FROM bill
group by tel


-- 把上面的sum(fee)的查詢結果當成資料庫的資料表
SELECT *  
FROM (
    SELECT tel,sum(fee) as 金額加總   --巢狀查詢(select中還有select)，但還是算一個SQL command
    FROM bill
    group by tel
) as a      -- 把查詢結果當成 a 資料表
where 金額加總 >= 1000


--列出金額加總最多的那筆資料，但...是錯的!如果有兩筆1350，那只會顯示第一筆
SELECT tel,max(金額加總)
FROM (
    SELECT tel,sum(fee) as 金額加總
    FROM bill
    group by tel
) as a      -- 把查詢結果當成 a 資料表


--正確做法，用內部join，會找出是否有相同的極端值(就能找到兩筆以上的)
SELECT tel,max_金額加總
FROM(                   --from兩張表，這兩張表先找出來，才可使用內部合併
    SELECT max(金額加總) as max_金額加總   --先找出第一筆的極端值
    FROM (
        SELECT tel,sum(fee) as 金額加總
        FROM bill
        group by tel
    ) as a
) as aa,(
    select tel,sum(fee) as 金額加總    --再拿第一筆極端值去找有無其他相同的極端值
    FROM bill
    group by tel
) as bb
where aa.max_金額加總 = bb.金額加總     --內部join，找出相同的值




--找出哪個人擁有最多支電話
--自己的寫法
-- select uid,max(幾支電話)
-- FROM(
--     select live.uid,count(phone.tel) as 幾支電話
--     FROM live left join phone on phone.hid = live.hid
--     group by live.uid
-- ) as a

--找出哪個人擁有最多支電話
--老師的寫法
select uid,max_n
FROM(
    select max(n) as max_n
    FROM(
        select userinfo.uid, count(tel) as n 
        FROM userinfo left join live on userinfo.uid = live.uid
            left join phone on live.hid = phone.hid
        group by userinfo.uid
    ) as a
) as aa,(
    select userinfo.uid, count(tel) as n
    FROM userinfo left join live on userinfo.uid = live.uid
        left join phone on live.hid = phone.hid
    group by userinfo.uid
) as bb
where aa.max_n = bb.n



-- union all :合併多個一模一樣(格式、資料型態)的查詢結果，常用在補幾筆缺漏資料時(救命、人工debug用的)
SELECT * 
FROM userinfo 
WHERE uid= 'A01' 
UNION ALL SELECT 'TTT', '測試員'


-- 列出前幾筆資料，MySQL用limit方法  (只取top 1資料就 limit 1)
SELECT tel,aa.金額加總
FROM(                   -- from兩張表，這兩張表先找出來，才可使用內部合併
    SELECT sum(fee) as 金額加總   -- 先找出第一筆的極端值
    FROM bill
    group by tel
    order by 金額加總 desc
    limit 1
) as aa,(
    select tel,sum(fee) as 金額加總    -- 再拿第一筆極端值去找有無其他相同的極端值
    FROM bill
    group by tel
) as bb
where aa.金額加總 = bb.金額加總



-- having和where是一樣做條件的，只是having放在group by的後面(所以先做group by再做having)
-- 而通常where放在group by的前面，所以pdf中where要做兩層，而having做一層(一行就好了)



-- 建立view，好用!且執行效率較好，還可以隱藏資料庫的資料結構(對外人的權限只限於select view)
-- 所以能夠建view盡量建
create view vw_name as
SELECT *                           --as後面接select語法
FROM userinfo 
WHERE uid= 'A01' 
UNION ALL SELECT 'TTT', '測試員'    -- 先打完這些，建立了view

select * FROM vw_name              --再執行這一行，簡潔有力





-- 插入INSERT INTO，一次只針對一個資料表(可指定其中幾個欄位) 
INSERT INTO userinfo VALUES ( 'A03', '王小毛' )
INSERT INTO userinfo (uid) VALUES ( 'A08' )     -- 針對uid這個欄位新增值

-- 複製資料(當new_table不存在時)(感覺較好用)
create table new_table select * from userinfo
-- 複製資料(當new_table存在時)(注意欄位格式要一致)
INSERT INTO new_table (uid, cname) SELECT uid, cname FROM userinfo


-- 修改資料
UPDATE userinfo 
SET cname = '孫小毛', uid = 'B01' 
WHERE uid = 'A03'

-- 刪除資料
DELETE FROM bill   -- DELETE刪了後有可能救回來
TRUNCATE TABLE bill   -- (大量資料時)效率比DELETE快很多，但是完全刪除




START TRANSACTION   -- 宣布交易開始
DELETE from live    -- 交易的動作    (把該資料表刪掉?)
-- 宣告交易開始後，要記得下commit或者是rollback!!才能將交易結束，不然資料庫被修改的資料庫屬於唯讀狀態，其他使用者無法寫入、修改
-- 所以交易的開始到結束時間要越短越好
-- ATM的交易開始是從使用者選完要提多少錢之後，才正式開始交易
rollback            -- 恢復到交易開始前(就不回TRUNCATE)
commit              -- 下了commit就沒救了(一般沒宣告交易，都會auto commit)


-- 先做出ER圖和資料字典，做了後再開始建資料庫
-- W3作業(SQL指令)
-- 建立三個資料表(自己思考欄位名稱)
-- 客戶資料表包含大頭照的欄位              blob的資料型態，可以存照片
-- 商品資料表，每個商品要有8個影像資料
-- 交易資料表，包括交易時間的紀錄
-- 用BASE64編碼，將二進位資料轉成文字型態(用text資料型態存圖片)，再用BASE64解碼還原成jpeg