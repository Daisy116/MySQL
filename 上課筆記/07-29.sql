-- 找出王大明的身分證字號、住址、電話
SELECT live.uid,cname,address,tel    -- 再下select指令
FROM userinfo,live,house,phone
WHERE userinfo.uid = live.uid AND    -- 先下where指令
		live.hid = house.hid AND
        house.hid = phone.hid AND
        cname = '王大明'


-- 用inner join的語法下在from之中(不建議用這種，建議用上面的)
SELECT live.uid,cname,address,tel
FROM userinfo inner join live on userinfo.uid = live.uid
    inner join house on live.hid = house.hid
    inner join phone on house.hid = phone.hid
WHERE cname = '王大明'



-- userinfo.uid = live.uid 是inner join(內部連結)，相同值的資料(種類)才會合併，
-- 所以合併時資料量會減少
-- 當要where全部時(沒條件)，用外部連結!
-- 顯示出所有人的身分證字號、住址、電話
SELECT userinfo.uid,cname,address,tel   -- 必須用userinfo.uid，才沒有null值
FROM userinfo left join live on userinfo.uid = live.uid   -- left join為左側外部連結
    left join house on live.hid = house.hid    -- 因為左邊的表種類比較多(有null)所以left join
    left join phone on house.hid = phone.hid




--限用右側外部連結，列出所有屋子的住戶清單，存成文字檔，上傳github
SELECT live.uid,cname,house.hid,address
FROM userinfo right join live on live.uid = userinfo.uid
    right join house on live.hid = house.hid


-- 交叉連結cross join，userinfo的n筆資料，乘上house的m筆資料
-- 通常都不會用到交叉連結，用到時通常是錯的
SELECT *
FROM userinfo,house    --這兩個資料表完全沒關聯，彼此獨立


--對資料表取別名
SELECT live.uid,cname,address,tel    -- 再下select指令
FROM userinfo as a,live as b,house as c,phone as d
WHERE a.uid = b.uid AND    -- 先下where指令
		b.hid = c.hid AND
        c.hid = d.hid


--對欄位取別名，方便直接丟往前端，因為表格顯示的是'帳號'、'姓名'......
SELECT a.uid as '帳號',cname as '姓名',address as '住址',tel as '電話'
FROM userinfo as a,live as b,house as c,phone as d
WHERE a.uid = b.uid AND
		b.hid = c.hid AND
        c.hid = d.hid


--下distinct(一定接在select後面)，讓顯示出來的資料唯一，不然把電話(tel拿掉，不select)，顯示的資料會錯誤
SELECT distinct a.uid as '帳號',cname as '姓名',address as '住址'
FROM userinfo as a,live as b,house as c,phone as d
WHERE a.uid = b.uid AND
		b.hid = c.hid AND
        c.hid = d.hid



--SUM()加總數字用的函式;avg()計算平均
SELECT SUM(fee) FROM bill

--用group by來分群做計算
SELECT tel,SUM(fee) FROM bill group by tel

--round(,0)處理小數，後面數字代表四捨五入到小數點後零位(等於沒有小數)
SELECT tel,round(avg(fee),0) as '平均金額'
FROM bill group by tel




--錯誤寫法，因為bill.tel是圈出來的結果、round(avg(fee),0)是算出來的結果，所以phone.hid也要經過計算，才能一起select
SELECT bill.tel,round(avg(fee),0) as '平均金額',phone.hid
FROM bill,phone
WHERE bill.hid = phone.hid 
group by bill.tel

--正確寫法，phone.hid也要經過group by的計算
SELECT bill.tel,round(avg(fee),0) as '平均金額',phone.hid
FROM bill,phone
WHERE bill.hid = phone.hid 
group by bill.tel,phone.hid   --先圈出tel相同的一群，再圈出hid相同的一群，
                                --如果前後完全一樣，雖然結果一樣，但過程中圈了兩次，這才是正確作法!



--找出電話對應的地址
SELECT bill.tel,round(avg(fee),0) as '平均金額',address  --SELECT除了公式計算的欄位，其他欄位有多少，就都加再GROUP BY之中!!
FROM bill,phone,house
WHERE bill.hid = phone.hid AND phone.hid = house.hid 
group by bill.tel,address