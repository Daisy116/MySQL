小組作業。建立網頁訂便當所需的資料
匯入08-02database.sql，建立資料庫，寫兩個procedure，讓前端可以直接call
PS:學習cy_mysql.sql中的東西!!
-------------------------------------------------------------------
第一個procedure : (產生網頁顯示表格)
CREATE VIEW vw_TABLE AS
SELECT p_name AS 品名,價格,I_quantity AS 數量,if(order.order_in_out=1,"是","自取") as 是否外送,c_address AS 地址,c_tel AS 電話,c_name AS 訂購人
FROM `vw_price` left join `order` on `vw_price`.l_id = `order`.`I_id`
		left join customer ON `order`.`c_id` = customer.c_id


delimiter $$
create PROCEDURE pro_table()
begin
    SELECT * FROM vw_TABLE;
END$$
delimiter ;

CALL pro_table()
-----------------------------------------------------------------------
第二個procedure : 
製造VIEW
CREATE VIEW vw_max AS
SELECT SUM(I_quantity) 
FROM `vw_price` left join `order` on `vw_price`.l_id = `order`.`I_id`
GROUP BY `order`.`c_id`

查詢最大總購買數
SELECT MAX(`SUM(I_quantity)`) AS '最大總購買數' FROM vw_max

delimiter $$
create PROCEDURE pro_maxsale()
begin
    SELECT MAX(`SUM(I_quantity)`) AS '最大總購買數' FROM vw_max;
END$$
delimiter ;

call pro_maxsale();
----------------------------------------------------------------------
其他張view : 
CREATE VIEW vw_price AS
SELECT *,product.price*order_list.I_quantity as 價格 FROM product,order_list

CREATE VIEW vw_2 AS
SELECT product.p_name AS 品項,vw_price.價格
FROM product,vw_price
SELECT * FROM vw_2