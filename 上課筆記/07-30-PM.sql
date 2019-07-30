-- https://www.w3school.com.cn/sql/func_date_format.asp

-- now()傳回本地的目前時間日期
SELECT now()

-- adddate(,5)加上5個小時;-5是減上5個小時
SELECT adddate(now(), 5)

-- datediff()帶兩個時間參數，會計算這兩個時間相差多少天
SELECT datediff(now(), '2017/3/2')  -- 時間格式'西元年/幾月/幾日'

-- date_format()後面的參數可查pdf的表，看要什麼格式
SELECT date_format(now(), '%T')    -- hr:min:second
SELECT quarter(now())              -- 計算目前第幾季
SELECT date_format(now(), '西元%Y年%m月%e日%k點%i分%s秒星期%W')

-- mySQL字串相加用concat(,)
SELECT concat('a','b')
SELECT concat(date_format(now(),'西元%Y'),'第',quarter(now()),'季')

-- 查詢指定時間
SELECT * FROM bill WHERE year(dd) = 2019 and month(dd) = 1
SELECT * FROM bill WHERE date_format(dd,'%Y/%m') = '2019/04'   -- 學著用date_format函式就好，不用學前面那個

-- 查某個時間段的資料，用Between...And...;NOT Between是以外的資料
SELECT * FROM bill WHERE dd Between '2019/1/1' And '2019/3/1'


-- 算出六個月前的時間
SELECT DATE_SUB(DATE(NOW()), INTERVAL 6 MONTH)
-- 算出bill dd中六個月前的所有資料
SELECT * FROM bill WHERE dd NOT Between adddate(NOW(), INTERVAL -6 MONTH) And now()

-- 從生日計算今年幾歲
SELECT year(from_days(datediff(now(), a.birthday)))
FROM(
    SELECT * FROM userinfo WHERE uid = 'A01'
)as a


-- 大部分資料庫儲存的是unixtime(epoch time)
-- 要在平台上轉換epoch time成人看的懂的格式 看這裡 https://www.epochconverter.com/