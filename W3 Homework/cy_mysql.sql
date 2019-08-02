-- phpMyAdmin SQL Dump
-- version 4.9.0.1
-- https://www.phpmyadmin.net/
--
-- 主機： 127.0.0.1
-- 產生時間： 2019 年 08 月 02 日 11:47
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
-- 資料庫： `cy_mysql`
--

-- --------------------------------------------------------

--
-- 資料表結構 `customer_info`
--

CREATE TABLE `customer_info` (
  `customer_id` int(10) NOT NULL COMMENT '客戶ID',
  `customer_name` varchar(20) NOT NULL COMMENT '客戶名稱',
  `headshot` blob DEFAULT NULL COMMENT '大頭照',
  `created_at` datetime NOT NULL COMMENT '註冊時間',
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() COMMENT '更新時間'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- 傾印資料表的資料 `customer_info`
--

INSERT INTO `customer_info` (`customer_id`, `customer_name`, `headshot`, `created_at`, `updated_at`) VALUES
(1, 'test', NULL, '2019-07-30 00:00:00', '2019-07-31 09:02:07'),
(2, 'test2', NULL, '2019-07-30 00:00:00', '2019-07-31 09:05:10');

-- --------------------------------------------------------

--
-- 資料表結構 `product_info`
--

CREATE TABLE `product_info` (
  `product_id` int(11) NOT NULL COMMENT '產品id',
  `product_name` varchar(30) NOT NULL COMMENT '產品名稱',
  `photo1` blob DEFAULT NULL COMMENT '影像資料1',
  `photo2` blob DEFAULT NULL COMMENT '影像資料2',
  `photo3` blob DEFAULT NULL COMMENT '影像資料3',
  `photo4` blob DEFAULT NULL COMMENT '影像資料4',
  `photo5` blob DEFAULT NULL COMMENT '影像資料5',
  `photo6` blob DEFAULT NULL COMMENT '影像資料6',
  `photo7` blob DEFAULT NULL COMMENT '影像資料7',
  `photo8` blob DEFAULT NULL COMMENT '影像資料8'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- 資料表結構 `transaction`
--

CREATE TABLE `transaction` (
  `transaction_id` int(100) UNSIGNED NOT NULL COMMENT '交易記錄id',
  `product_id` int(100) NOT NULL COMMENT '產品id',
  `customer_id` int(100) NOT NULL COMMENT '客戶id',
  `transaction_time` datetime NOT NULL COMMENT '交易時間'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- 已傾印資料表的索引
--

--
-- 資料表索引 `customer_info`
--
ALTER TABLE `customer_info`
  ADD PRIMARY KEY (`customer_id`);

--
-- 資料表索引 `product_info`
--
ALTER TABLE `product_info`
  ADD PRIMARY KEY (`product_id`);

--
-- 資料表索引 `transaction`
--
ALTER TABLE `transaction`
  ADD PRIMARY KEY (`transaction_id`),
  ADD KEY `FK_customer_id` (`customer_id`),
  ADD KEY `FK_product_id` (`product_id`);

--
-- 在傾印的資料表使用自動遞增(AUTO_INCREMENT)
--

--
-- 使用資料表自動遞增(AUTO_INCREMENT) `customer_info`
--
ALTER TABLE `customer_info`
  MODIFY `customer_id` int(10) NOT NULL AUTO_INCREMENT COMMENT '客戶ID', AUTO_INCREMENT=3;

--
-- 使用資料表自動遞增(AUTO_INCREMENT) `product_info`
--
ALTER TABLE `product_info`
  MODIFY `product_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '產品id';

--
-- 使用資料表自動遞增(AUTO_INCREMENT) `transaction`
--
ALTER TABLE `transaction`
  MODIFY `transaction_id` int(100) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '交易記錄id', AUTO_INCREMENT=2;

--
-- 已傾印資料表的限制式
--

--
-- 資料表的限制式 `transaction`
--
ALTER TABLE `transaction`
  ADD CONSTRAINT `FK_customer_id` FOREIGN KEY (`customer_id`) REFERENCES `customer_info` (`customer_id`),
  ADD CONSTRAINT `FK_product_id` FOREIGN KEY (`product_id`) REFERENCES `product_info` (`product_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
