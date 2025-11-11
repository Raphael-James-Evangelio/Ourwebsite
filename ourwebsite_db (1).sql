-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 11, 2025 at 12:08 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `ourwebsite_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `gallery_images`
--

CREATE TABLE `gallery_images` (
  `id` int(10) UNSIGNED NOT NULL,
  `original_name` varchar(255) NOT NULL,
  `file_name` varchar(255) NOT NULL,
  `file_path` varchar(255) NOT NULL,
  `uploaded_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `gallery_images`
--

INSERT INTO `gallery_images` (`id`, `original_name`, `file_name`, `file_path`, `uploaded_at`) VALUES
(2, 'photo_6070870195280395724_y.jpg', 'a37921f4810f44c679196dc25450e73d.jpg', 'uploads/a37921f4810f44c679196dc25450e73d.jpg', '2025-11-09 13:11:16'),
(3, 'photo_6086673007754983453_y.jpg', '1c2c61bea2de06e747323a063261b0b4.jpg', 'uploads/1c2c61bea2de06e747323a063261b0b4.jpg', '2025-11-09 13:11:16'),
(4, 'photo_6086764761141327213_y.jpg', '31213e034198f71037fc306b3fcd94f6.jpg', 'uploads/31213e034198f71037fc306b3fcd94f6.jpg', '2025-11-09 13:11:16'),
(5, 'photo_6089016560955012665_y.jpg', '68c3fd27259771b280200d64bac55cc9.jpg', 'uploads/68c3fd27259771b280200d64bac55cc9.jpg', '2025-11-09 13:11:16'),
(6, 'photo_6109277386274094194_y.jpg', '982bff20f91f79f0b9e9fd6cb1c3efa0.jpg', 'uploads/982bff20f91f79f0b9e9fd6cb1c3efa0.jpg', '2025-11-09 13:11:17'),
(7, 'photo_6109277386274094213_y.jpg', '5c7b270b5c6373457668b50a4229bb3a.jpg', 'uploads/5c7b270b5c6373457668b50a4229bb3a.jpg', '2025-11-09 13:11:17'),
(8, 'photo_6109277386274094215_y.jpg', '0718468fdf9c25ac3c537e6a2655ceb4.jpg', 'uploads/0718468fdf9c25ac3c537e6a2655ceb4.jpg', '2025-11-09 13:11:17'),
(9, 'photo_6125367665204770896_y.jpg', '2ad1bd12e8c0e8fdaf48a2858b71e5bd.jpg', 'uploads/2ad1bd12e8c0e8fdaf48a2858b71e5bd.jpg', '2025-11-09 13:11:17'),
(10, 'photo_6154493470526521117_y.jpg', 'a433d942c34cf104061b24588e83d546.jpg', 'uploads/a433d942c34cf104061b24588e83d546.jpg', '2025-11-09 13:11:17'),
(11, 'photo_6154493470526521118_y.jpg', 'dd7bb130d7b268013a4a5bc6c9b49a63.jpg', 'uploads/dd7bb130d7b268013a4a5bc6c9b49a63.jpg', '2025-11-09 13:11:17'),
(12, 'photo_6154493470526521119_y.jpg', '51334e6e367dc33aea74b1d5a946b5cf.jpg', 'uploads/51334e6e367dc33aea74b1d5a946b5cf.jpg', '2025-11-09 13:11:17'),
(13, 'photo_6156887949153780145_y.jpg', '3e32e5f0a90fc421878149d6ea2a50fa.jpg', 'uploads/3e32e5f0a90fc421878149d6ea2a50fa.jpg', '2025-11-09 13:11:17'),
(14, 'photo_6156887949153780151_y.jpg', '41df0524f7aa4623d0c3a6ce005fc696.jpg', 'uploads/41df0524f7aa4623d0c3a6ce005fc696.jpg', '2025-11-09 13:11:17'),
(15, 'photo_6165477484313820920_y.jpg', 'f9dafc203e816ddc5857d5be86253566.jpg', 'uploads/f9dafc203e816ddc5857d5be86253566.jpg', '2025-11-09 13:11:17'),
(16, 'photo_6165477484313820924_y.jpg', 'cf503943c9cad85ab583176f21132691.jpg', 'uploads/cf503943c9cad85ab583176f21132691.jpg', '2025-11-09 13:11:17'),
(17, 'photo_6179477686129377438_y.jpg', '7052903406ca31d186e4dedb4c92a1ae.jpg', 'uploads/7052903406ca31d186e4dedb4c92a1ae.jpg', '2025-11-09 13:11:17'),
(18, 'photo_6188073582135983567_y.jpg', 'a6a11f78542b06e4f9f7a20596d69a16.jpg', 'uploads/a6a11f78542b06e4f9f7a20596d69a16.jpg', '2025-11-09 13:11:17'),
(19, 'photo_6197070945915618395_y.jpg', '4dfaa226e85c625eae901fa53d541769.jpg', 'uploads/4dfaa226e85c625eae901fa53d541769.jpg', '2025-11-09 13:11:17'),
(20, 'photo_6197070945915618410_y.jpg', '16f5731b11686366d309e554bc8805fc.jpg', 'uploads/16f5731b11686366d309e554bc8805fc.jpg', '2025-11-09 13:11:17'),
(21, 'photo_6219609955032481058_y.jpg', 'e02f42bef3a124d74096acd3f78de39f.jpg', 'uploads/e02f42bef3a124d74096acd3f78de39f.jpg', '2025-11-09 13:11:17');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(10) UNSIGNED NOT NULL,
  `email` varchar(190) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `first_name` varchar(100) DEFAULT NULL,
  `last_name` varchar(100) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `email`, `password_hash`, `first_name`, `last_name`, `created_at`, `updated_at`) VALUES
(1, 'raphaeljamesevangelio', 'admin123', 'admin', 'admin', '2025-11-09 12:22:58', '2025-11-09 12:44:09');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `gallery_images`
--
ALTER TABLE `gallery_images`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_users_email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `gallery_images`
--
ALTER TABLE `gallery_images`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
