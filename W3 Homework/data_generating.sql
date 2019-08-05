https://blog.csdn.net/qq_37107280/article/details/77542127

亂數產生-365~0
SELECT round(RAND() * -365)

亂數產生一定範圍內的時間
SET @a = round(RAND() * -365);
SELECT DATE_ADD("2017-06-15", INTERVAL @a DAY);

試圖INSERT
SET @a = round(RAND() * -365);
INSERT INTO transaction (transaction_time) VALUES( DATE_ADD("2017-06-15", INTERVAL @a DAY));




SET @a = round(RAND() * -365);
INSERT INTO transaction (product_id,customer_id,transaction_time) VALUES(1 ,1 ,DATE_ADD("2017-06-15", INTERVAL @a DAY));




有錯誤...
SET @Num = 0;
WHILE @Num <= 10  -- 當目前次數小於等於執行次數
BEGIN
    SET @a = round(RAND() * -365);
    INSERT INTO transaction (product_id,customer_id,transaction_time) VALUES(1 ,1 ,DATE_ADD("2017-06-15", INTERVAL @a DAY));
    -- 設定目前次數+1
    SET @Num = @Num + 1
END
