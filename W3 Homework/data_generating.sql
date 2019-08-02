https://blog.csdn.net/qq_37107280/article/details/77542127

亂數產生-365~0
SELECT round(RAND() * -365)

亂數產生一定範圍內的時間
SET @a = round(RAND() * -365);
SELECT DATE_ADD("2017-06-15", INTERVAL @a DAY);

試圖INSERT
SET @a = round(RAND() * -365);
INSERT INTO transaction (transaction_time) VALUES( DATE_ADD("2017-06-15", INTERVAL @a DAY));