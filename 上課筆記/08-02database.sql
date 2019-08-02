-- phpMyAdmin SQL Dump
-- version 4.9.0.1
-- https://www.phpmyadmin.net/
--
-- 主機： 127.0.0.1
-- 產生時間： 2019 年 08 月 02 日 09:52
-- 伺服器版本： 10.3.16-MariaDB
-- PHP 版本： 7.1.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- 資料庫： `aaa`
--

DELIMITER $$
--
-- 程序
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `pro_maxsale` ()  begin
    SELECT MAX(`SUM(I_quantity)`) AS '最大總購買數' FROM vw_max;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `pro_table` ()  begin
    SELECT * FROM vw_TABLE;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sumprice` (`v` INT, `t` INT)  BEGIN
	SET @res = v * t;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- 資料表結構 `buy`
--

CREATE TABLE `buy` (
  `p_id` varchar(11) NOT NULL,
  `I_id` varchar(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- 傾印資料表的資料 `buy`
--

INSERT INTO `buy` (`p_id`, `I_id`) VALUES
('1', '0001'),
('1', '0002');

-- --------------------------------------------------------

--
-- 資料表結構 `customer`
--

CREATE TABLE `customer` (
  `c_id` char(10) NOT NULL,
  `c_name` varchar(20) CHARACTER SET utf8 NOT NULL,
  `c_address` varchar(40) CHARACTER SET utf8 NOT NULL,
  `c_tel` varchar(40) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- 傾印資料表的資料 `customer`
--

INSERT INTO `customer` (`c_id`, `c_name`, `c_address`, `c_tel`) VALUES
('123', '陳七七', '台北市南京東路1號', '0977-321-654'),
('456', '李誠誠', '新竹市光復北路1號', '0988-123-456');

-- --------------------------------------------------------

--
-- 資料表結構 `order`
--

CREATE TABLE `order` (
  `I_id` varchar(11) NOT NULL,
  `c_id` varchar(11) NOT NULL,
  `order_in_out` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- 傾印資料表的資料 `order`
--

INSERT INTO `order` (`I_id`, `c_id`, `order_in_out`) VALUES
('0001', '123', 1),
('0002', '123', 0),
('0003', '456', 1);

-- --------------------------------------------------------

--
-- 資料表結構 `order_list`
--

CREATE TABLE `order_list` (
  `l_id` char(10) NOT NULL,
  `l_time` datetime NOT NULL,
  `I_quantity` int(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- 傾印資料表的資料 `order_list`
--

INSERT INTO `order_list` (`l_id`, `l_time`, `I_quantity`) VALUES
('0001', '2019-08-02 12:35:00', 5),
('0002', '2019-08-01 11:46:00', 10),
('0003', '2019-07-31 17:00:00', 4);

-- --------------------------------------------------------

--
-- 資料表結構 `product`
--

CREATE TABLE `product` (
  `p_id` varchar(20) NOT NULL,
  `p_name` varchar(20) CHARACTER SET utf8 NOT NULL,
  `quantity` int(11) NOT NULL,
  `price` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- 傾印資料表的資料 `product`
--

INSERT INTO `product` (`p_id`, `p_name`, `quantity`, `price`) VALUES
('1', '鹽烤天使紅蝦便當', 0, 149);

-- --------------------------------------------------------

--
-- 替換檢視表以便查看 `vw_2`
-- (請參考以下實際畫面)
--
CREATE TABLE `vw_2` (
`品項` varchar(20)
,`價格` bigint(30)
);

-- --------------------------------------------------------

--
-- 替換檢視表以便查看 `vw_max`
-- (請參考以下實際畫面)
--
CREATE TABLE `vw_max` (
`SUM(I_quantity)` decimal(41,0)
);

-- --------------------------------------------------------

--
-- 替換檢視表以便查看 `vw_price`
-- (請參考以下實際畫面)
--
CREATE TABLE `vw_price` (
`p_id` varchar(20)
,`p_name` varchar(20)
,`quantity` int(11)
,`price` int(11)
,`l_id` char(10)
,`l_time` datetime
,`I_quantity` int(20)
,`價格` bigint(30)
);

-- --------------------------------------------------------

--
-- 替換檢視表以便查看 `vw_table`
-- (請參考以下實際畫面)
--
CREATE TABLE `vw_table` (
`品名` varchar(20)
,`價格` bigint(30)
,`數量` int(20)
,`是否送` varchar(2)
,`地址` varchar(40)
,`電話` varchar(40)
,`訂購人` varchar(20)
);

-- --------------------------------------------------------

--
-- 檢視表結構 `vw_2`
--
DROP TABLE IF EXISTS `vw_2`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_2`  AS  select `product`.`p_name` AS `品項`,`vw_price`.`價格` AS `價格` from (`product` join `vw_price`) ;

-- --------------------------------------------------------

--
-- 檢視表結構 `vw_max`
--
DROP TABLE IF EXISTS `vw_max`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_max`  AS  select sum(`vw_price`.`I_quantity`) AS `SUM(I_quantity)` from (`vw_price` left join `order` on(`vw_price`.`l_id` = `order`.`I_id`)) group by `order`.`c_id` ;

-- --------------------------------------------------------

--
-- 檢視表結構 `vw_price`
--
DROP TABLE IF EXISTS `vw_price`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_price`  AS  select `product`.`p_id` AS `p_id`,`product`.`p_name` AS `p_name`,`product`.`quantity` AS `quantity`,`product`.`price` AS `price`,`order_list`.`l_id` AS `l_id`,`order_list`.`l_time` AS `l_time`,`order_list`.`I_quantity` AS `I_quantity`,`product`.`price` * `order_list`.`I_quantity` AS `價格` from (`product` join `order_list`) ;

-- --------------------------------------------------------

--
-- 檢視表結構 `vw_table`
--
DROP TABLE IF EXISTS `vw_table`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_table`  AS  select `vw_price`.`p_name` AS `品名`,`vw_price`.`價格` AS `價格`,`vw_price`.`I_quantity` AS `數量`,if(`order`.`order_in_out` = 1,'是','自取') AS `是否送`,`customer`.`c_address` AS `地址`,`customer`.`c_tel` AS `電話`,`customer`.`c_name` AS `訂購人` from ((`vw_price` left join `order` on(`vw_price`.`l_id` = `order`.`I_id`)) left join `customer` on(`order`.`c_id` = `customer`.`c_id`)) ;

--
-- 已傾印資料表的索引
--

--
-- 資料表索引 `buy`
--
ALTER TABLE `buy`
  ADD KEY `FK_pid` (`p_id`),
  ADD KEY `FK_Iid` (`I_id`);

--
-- 資料表索引 `customer`
--
ALTER TABLE `customer`
  ADD PRIMARY KEY (`c_id`);

--
-- 資料表索引 `order`
--
ALTER TABLE `order`
  ADD KEY `FK_o1` (`c_id`),
  ADD KEY `FK_o2` (`I_id`);

--
-- 資料表索引 `order_list`
--
ALTER TABLE `order_list`
  ADD PRIMARY KEY (`l_id`);

--
-- 資料表索引 `product`
--
ALTER TABLE `product`
  ADD PRIMARY KEY (`p_id`);

--
-- 已傾印資料表的限制式
--

--
-- 資料表的限制式 `buy`
--
ALTER TABLE `buy`
  ADD CONSTRAINT `FK_Iid` FOREIGN KEY (`I_id`) REFERENCES `order_list` (`l_id`),
  ADD CONSTRAINT `FK_pid` FOREIGN KEY (`p_id`) REFERENCES `product` (`p_id`);

--
-- 資料表的限制式 `order`
--
ALTER TABLE `order`
  ADD CONSTRAINT `FK_o1` FOREIGN KEY (`c_id`) REFERENCES `customer` (`c_id`),
  ADD CONSTRAINT `FK_o2` FOREIGN KEY (`I_id`) REFERENCES `order_list` (`l_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
