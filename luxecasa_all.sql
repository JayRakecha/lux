
--
-- Host: localhost    Database: luxecasa_db
-- ------------------------------------------------------
-- Server version	8.0.45-0ubuntu0.24.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `active_users`
--

DROP TABLE IF EXISTS `active_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `active_users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `active_users`
--

LOCK TABLES `active_users` WRITE;
/*!40000 ALTER TABLE `active_users` DISABLE KEYS */;
INSERT INTO `active_users` VALUES (1,'123 123','abc@gmail.com','1dZtx^LIGy7*dMn4','2026-05-11 05:29:28');
/*!40000 ALTER TABLE `active_users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `admin_activity_logs`
--

DROP TABLE IF EXISTS `admin_activity_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `admin_activity_logs` (
  `id` int NOT NULL AUTO_INCREMENT,
  `admin_id` int NOT NULL,
  `action` varchar(100) NOT NULL,
  `entity_type` varchar(50) DEFAULT NULL,
  `entity_id` int DEFAULT NULL,
  `old_values` text COMMENT 'JSON',
  `new_values` text COMMENT 'JSON',
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `admin_id` (`admin_id`),
  CONSTRAINT `admin_activity_logs_ibfk_1` FOREIGN KEY (`admin_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `admin_activity_logs`
--

LOCK TABLES `admin_activity_logs` WRITE;
/*!40000 ALTER TABLE `admin_activity_logs` DISABLE KEYS */;
/*!40000 ALTER TABLE `admin_activity_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `banners`
--

DROP TABLE IF EXISTS `banners`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `banners` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(200) NOT NULL,
  `subtitle` varchar(400) DEFAULT NULL,
  `description` text,
  `image_url` varchar(500) NOT NULL,
  `mobile_image_url` varchar(500) DEFAULT NULL,
  `link` varchar(300) DEFAULT NULL,
  `button_text` varchar(50) DEFAULT NULL,
  `button_color` varchar(20) DEFAULT '#C8A96E',
  `text_color` varchar(20) DEFAULT '#FFFFFF',
  `position` enum('hero','promotional','sidebar','popup') DEFAULT 'hero',
  `sort_order` int DEFAULT '0',
  `is_active` tinyint(1) DEFAULT '1',
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `banners`
--

LOCK TABLES `banners` WRITE;
/*!40000 ALTER TABLE `banners` DISABLE KEYS */;
/*!40000 ALTER TABLE `banners` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cart`
--

DROP TABLE IF EXISTS `cart`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cart` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `product_id` int NOT NULL,
  `quantity` int DEFAULT '1',
  `color_selected` varchar(50) DEFAULT NULL,
  `finish_selected` varchar(50) DEFAULT NULL,
  `added_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_cart` (`user_id`,`product_id`,`color_selected`),
  KEY `product_id` (`product_id`),
  KEY `idx_cart_user` (`user_id`),
  CONSTRAINT `cart_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `cart_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cart`
--

LOCK TABLES `cart` WRITE;
/*!40000 ALTER TABLE `cart` DISABLE KEYS */;
/*!40000 ALTER TABLE `cart` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `catalog_products`
--

DROP TABLE IF EXISTS `catalog_products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `catalog_products` (
  `id` int NOT NULL,
  `name` varchar(255) NOT NULL,
  `cat` varchar(50) NOT NULL,
  `price` int NOT NULL,
  `oldPrice` int DEFAULT NULL,
  `rating` int DEFAULT '5',
  `reviews` int DEFAULT '0',
  `badge` varchar(50) DEFAULT NULL,
  `description` text,
  `productImage` varchar(255) DEFAULT NULL,
  `isSystemProduct` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `catalog_products`
--

LOCK TABLES `catalog_products` WRITE;
/*!40000 ALTER TABLE `catalog_products` DISABLE KEYS */;
INSERT INTO `catalog_products` VALUES (1,'Majestic 3-Seater Velvet Sofa','sofas',20000,30000,5,247,'bestseller','Midnight blue velvet with solid teak wood frame. Feather-soft cushioning for ultimate comfort.','/image/photo-1555041469-a586c61ea9bc.2.jpeg',1),(2,'L-Shape Sectional Sofa','sofas',32000,40000,4,178,'hot','Spacious L-shape sectional in warm beige fabric. Perfect for large family rooms.','/image/photo-1493663284031-b7e3aefcae8e.2.jpeg',1),(3,'Chesterfield 2-Seater Sofa','sofas',20000,30000,5,312,'bestseller','Classic Chesterfield design in premium caramel leather. Handtufted buttoned back.','/image/photo-1759722665623-c4c1075c0a6b.1.jpg',1),(4,'Nordic Minimalist Sofa','sofas',30000,40000,4,201,'new','Clean Scandinavian lines in oatmeal fabric on solid oak legs.','/image/img1.1.jpg',1),(5,'Royal Chaise Longue','sofas',32999,42999,5,89,'sale','Luxurious emerald velvet chaise with gold-finish feet. A true statement piece.','/image/image_2026-05-09_221433724.1.png',1),(6,'Modular Sectional 5-Seater','sofas',24000,30000,5,134,'bestseller','Reconfigurable 5-seater modular sofa in soft grey. USB charging ports included.','/image/photo-1512212621149-107ffe572d2f.jpeg',1),(9,'Camel Leather Loveseat','sofas',39999,59999,5,198,'bestseller','Compact 2-seater in rich caramel genuine leather. Perfect for intimate corners.','/image/photo-1560448204-603b3fc33ddc.jpeg',1),(12,'Japandi Minimalist Sofa','sofas',32999,47999,4,88,'new','Japanese-Scandinavian design with low profile and natural linen upholstery.','/image/photo-1616486338812-3dadae4b4ace.1.jpeg',1),(26,'Royal Emperor King Bed','beds',30000,40000,5,389,'bestseller','Handcrafted sheesham wood king bed with plush upholstered headboard. Includes slat base.','/image/img3.1.jpg',1),(27,'Floating Platform Bed','beds',14999,24999,5,234,'hot','Modern floating platform bed with LED under-glow and teak wood frame.','/image/img4.1.jpg',1),(29,'Storage Ottoman Bed','beds',19000,24000,4,298,'bestseller','Hydraulic storage bed with deep bottom drawer. Grey fabric upholstery.','/image/img2.1.jpg',1),(31,'Velvet Tufted Headboard Bed','beds',32000,40000,5,267,'sale','Floor-to-ceiling tufted velvet headboard in sapphire blue. Gold stud detailing.','/image/photo-1631049307264-da0ec9d70304.jpeg',1),(51,'Luxe Wingback Accent Chair','chairs',12999,20999,5,203,'sale','Mid-century modern wingback in caramel leather with solid brass tapered legs.','/image/photo-1586158291800-2665f07bba79.jpeg',1),(52,'Egg Chair with Ottoman','chairs',10000,15000,5,312,'bestseller','Iconic egg-shape swivel chair with matching ottoman in charcoal grey fabric.','/image/photo-1612372606404-0ab33e7187ee.jpeg',1),(53,'Peacock Chair','chairs',9999,19999,4,178,'hot','Bohemian peacock throne chair in natural rattan with oversized woven back.','/image/photo-1571624436279-b272aff752b5.jpeg',1),(54,'Velvet Armchair','chairs',13999,24999,5,267,'bestseller','Deep-button tufted armchair in emerald velvet. Gold frame finish.','/image/premium_photo-1678074057896-eee996d4a23e.jpeg',1),(55,'Eames-Style Lounge Chair','chairs',13000,20000,5,189,'new','Premium full-grain leather lounge chair with rosewood veneer shell. Includes ottoman.','/image/photo-1580480055273-228ff5388ef8.jpeg',1),(56,'Nordic Rocking Chair','chairs',14999,24999,4,134,'sale','Gentle-curve solid beech wood rocking chair with wool seat pad. Calming and timeless.','/image/photo-1506439773649-6e0eb8cfb237.2.jpeg',1),(57,'Barcelona-Style Chair','chairs',12999,22999,5,156,'hot','Clean geometric Mies van der Rohe-inspired chair in ivory leather with steel frame.','/image/photo-1505843490538-5133c6c7d0e1.jpeg',1),(76,'Calacatta Marble Dining Table 8-Seater','dining',49999,69999,4,156,'new','Italian Calacatta marble top with brushed stainless steel base. Seats 8 comfortably.','/image/photo-1583845112239-97ef1341b271.2.jpeg',1),(77,'Sheesham Wood Dining Table 6-Seater','dining',40000,60000,5,234,'bestseller','Solid sheesham wood live-edge dining table. Natural grain finish, each unique.','/image/photo-1616486886892-ff366aa67ba4.jpeg',1),(78,'Glass Top Dining Table','dining',54999,74999,4,178,'hot','10mm tempered glass top on chrome steel pedestal base. Sleek and modern.','/image/photo-1602872030490-4a484a7b3ba6.1.jpeg',1),(79,'Extendable Dining Table','dining',64999,84999,5,289,'bestseller','Solid oak extendable table that seats 4 to 8. Hidden butterfly leaf mechanism.','/image/photo-1615066390971-03e4e1c36ddf.jpeg',1),(80,'Round Marble Pedestal Table 4-Seater','dining',44999,59999,5,134,'new','Elegant round Nero marble top on solid brass tulip pedestal. Seats 4.','/image/premium_photo-1684445034959-b3faeb4597d2.jpeg',1),(81,'Farmhouse Trestle Table','dining',67999,89999,4,198,'sale','Rustic farmhouse dining table in natural mango wood with trestle base. Very sturdy.','/image/photo-1657524398377-567034729507.jpeg',1),(82,'Industrial Steel & Wood Table','dining',49999,67999,4,156,'hot','Raw industrial aesthetic with reclaimed elm top and matte black steel I-frame legs.','/image/photo-1604578762246-41134e37f9cc.jpeg',1),(101,'Moroccan Carved Wardrobe 4-Door','wardrobes',30000,40000,5,92,'bestseller','Intricately hand-carved mango wood wardrobe with 4 mirrored sliding doors.','https://images.unsplash.com/photo-1558997519-83ea9252edf8?w=600&q=80',1),(102,'White Gloss Sliding Wardrobe','wardrobes',20999,30000,4,234,'hot','Modern high-gloss white wardrobe with 4 sliding mirror doors. Full interior fit.','https://images.unsplash.com/photo-1600422086908-72be2c8f5f3f?w=600',1),(103,'Walk-In Wardrobe System','wardrobes',24999,33999,5,89,'new','Complete walk-in wardrobe system with drawers, rails, shelves and LED lighting.','https://images.unsplash.com/photo-1706734463726-0ed0e7de3e4e?w=600',1),(104,'Antique Armoire','wardrobes',17999,22999,5,67,'limited','French-style antique armoire in distressed teak with original iron hardware.','https://plus.unsplash.com/premium_photo-1676321688603-f0b84694036b?w=6003D',1),(105,'Loft Wardrobe with Ladder','wardrobes',30000,50000,4,145,'hot','Tall open loft wardrobe with rolling library ladder. Industrial oak and steel.','https://images.unsplash.com/photo-1721739224993-f6fcdec51d1d?w=600',1),(106,'3-Door Sheesham Wardrobe','wardrobes',17000,22000,4,198,'sale','Solid sheesham 3-door wardrobe with full-length mirror on centre door.','https://plus.unsplash.com/premium_photo-1674773520192-cec460924db7?w=600',1),(126,'Marble Oval Coffee Table','coffee-tables',7999,10999,5,198,'bestseller','White Carrara marble oval top on gold-brushed metal frame. Timeless elegance.','https://images.unsplash.com/photo-1619911013257-8f1fbc919fc9?w=600',1),(127,'Reclaimed Wood Trunk Table','coffee-tables',22999,34999,4,167,'hot','Vintage trunk-style coffee table in reclaimed elm. Each piece tells a story.','https://images.unsplash.com/photo-1542372147193-a7aca54189cd?w=600',1),(128,'Brass & Glass Nesting Tables','coffee-tables',19999,31999,5,234,'new','Set of 3 nesting coffee tables with smoked glass tops and brushed brass legs.','https://plus.unsplash.com/premium_photo-1680546330888-f995d2d64571?w=600',1),(129,'Drum Coffee Table','coffee-tables',11999,18999,4,145,'sale','Large drum-shaped mango wood coffee table. Doubles as extra seating when needed.','https://images.unsplash.com/photo-1534201569625-ed4662d8be97?w=600',1),(151,'Floating Wall Cabinet 200cm','cabinets',44999,61999,5,234,'bestseller','Premium walnut wood cabinet with elegant matte finish. Designed for modern homes with spacious compartments and smooth soft-close doors.','/image/photo-1631048835473-73c7aaf86096.jpeg',1),(152,'Solid Wood Cabinet','cabinets',34999,47999,4,189,'hot',' Perfect for showcasing decor, crockery, or collectibles in a stylish and modern way.','/image/premium_photo-1661963167025-ca61fd6b36d8.jpeg',1),(153,'3-Drawer Wood Cabinet','cabinets',27999,38999,4,267,'new','Smart storage cabinet crafted for office use. Features lockable drawers, clean design, and durable engineered wood finish.','https://images.unsplash.com/photo-1701421047855-d7bafd8d6f69?w=600',1),(154,'High Gloss ceramic Cabinet','cabinets',22999,31999,4,312,'sale','Combines open shelves and closed storage with a premium oak finish for a classy look.','https://images.unsplash.com/photo-1631048498692-af6262577031?w=600',1);
/*!40000 ALTER TABLE `catalog_products` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `categories`
--

DROP TABLE IF EXISTS `categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `categories` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `slug` varchar(100) NOT NULL,
  `description` text,
  `image` varchar(255) DEFAULT NULL,
  `icon` varchar(100) DEFAULT NULL,
  `parent_id` int DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT '1',
  `sort_order` int DEFAULT '0',
  `meta_title` varchar(200) DEFAULT NULL,
  `meta_description` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `slug` (`slug`),
  KEY `parent_id` (`parent_id`),
  CONSTRAINT `categories_ibfk_1` FOREIGN KEY (`parent_id`) REFERENCES `categories` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categories`
--

LOCK TABLES `categories` WRITE;
/*!40000 ALTER TABLE `categories` DISABLE KEYS */;
INSERT INTO `categories` VALUES (1,'Sofas & Sectionals','sofas-sectionals','Luxurious sofas, loveseats, sectionals and sofa sets for your living room',NULL,'',NULL,1,1,NULL,NULL,'2026-05-08 14:51:50'),(2,'Beds & Bedroom','beds-bedroom','King, Queen and Single beds, headboards, bed frames and complete bedroom sets',NULL,'',NULL,1,2,NULL,NULL,'2026-05-08 14:51:50'),(3,'Dining Tables','dining-tables','Elegant dining tables, extendable tables, round and rectangular dining sets',NULL,'',NULL,1,3,NULL,NULL,'2026-05-08 14:51:50'),(4,'Chairs','chairs','Accent chairs, dining chairs, recliners, office chairs and bar stools',NULL,'',NULL,1,4,NULL,NULL,'2026-05-08 14:51:50'),(5,'Wardrobes','wardrobes','Sliding door wardrobes, hinged wardrobes, walk-in closets and almirahs',NULL,'',NULL,1,5,NULL,NULL,'2026-05-08 14:51:50'),(6,'Coffee Tables','coffee-tables','Center tables, side tables, nested tables and console tables',NULL,'',NULL,1,6,NULL,NULL,'2026-05-08 14:51:50'),(7,'TV Units','tv-units','Television cabinets, entertainment units and media consoles',NULL,'',NULL,1,7,NULL,NULL,'2026-05-08 14:51:50'),(8,'Outdoor','outdoor','Garden sets, patio furniture, outdoor swings and poolside loungers',NULL,'',NULL,1,8,NULL,NULL,'2026-05-08 14:51:50'),(9,'Office Furniture','office-furniture','Work from home desks, ergonomic chairs and office storage',NULL,'',NULL,1,9,NULL,NULL,'2026-05-08 14:51:50'),(10,'Kids Furniture','kids-furniture','Bunk beds, study tables, toy storage and kids room sets',NULL,'',NULL,1,10,NULL,NULL,'2026-05-08 14:51:50'),(11,'Shoe Racks','shoe-racks','Wooden shoe racks, metal shoe stands and entryway storage benches',NULL,'',NULL,1,11,NULL,NULL,'2026-05-08 14:51:50'),(12,'Bookshelves','bookshelves','Wall shelves, free-standing bookshelves, modular storage units',NULL,'',NULL,1,12,NULL,NULL,'2026-05-08 14:51:50');
/*!40000 ALTER TABLE `categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `contact_messages`
--

DROP TABLE IF EXISTS `contact_messages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `contact_messages` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `email` varchar(150) NOT NULL,
  `phone` varchar(15) DEFAULT NULL,
  `subject` varchar(200) DEFAULT NULL,
  `message` text NOT NULL,
  `attachment` varchar(300) DEFAULT NULL,
  `is_read` tinyint(1) DEFAULT '0',
  `is_replied` tinyint(1) DEFAULT '0',
  `reply_message` text,
  `replied_at` datetime DEFAULT NULL,
  `replied_by` int DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `replied_by` (`replied_by`),
  CONSTRAINT `contact_messages_ibfk_1` FOREIGN KEY (`replied_by`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `contact_messages`
--

LOCK TABLES `contact_messages` WRITE;
/*!40000 ALTER TABLE `contact_messages` DISABLE KEYS */;
/*!40000 ALTER TABLE `contact_messages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `coupons`
--

DROP TABLE IF EXISTS `coupons`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `coupons` (
  `id` int NOT NULL AUTO_INCREMENT,
  `code` varchar(50) NOT NULL,
  `description` varchar(300) DEFAULT NULL,
  `discount_type` enum('percentage','fixed') NOT NULL,
  `discount_value` decimal(10,2) NOT NULL,
  `min_order_amount` decimal(10,2) DEFAULT '0.00',
  `max_discount_amount` decimal(10,2) DEFAULT NULL,
  `usage_limit` int DEFAULT NULL,
  `used_count` int DEFAULT '0',
  `user_specific` int DEFAULT NULL,
  `valid_from` date NOT NULL,
  `valid_until` date NOT NULL,
  `is_active` tinyint(1) DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`),
  KEY `user_specific` (`user_specific`),
  CONSTRAINT `coupons_ibfk_1` FOREIGN KEY (`user_specific`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `coupons`
--

LOCK TABLES `coupons` WRITE;
/*!40000 ALTER TABLE `coupons` DISABLE KEYS */;
INSERT INTO `coupons` VALUES (1,'WELCOME10','Welcome discount - 10% off on first order','percentage',10.00,5000.00,2000.00,1000,0,NULL,'2024-01-01','2025-12-31',1,'2026-05-08 14:51:50'),(2,'FLAT500','Flat ₹500 off on orders above ₹15000','fixed',500.00,15000.00,NULL,500,0,NULL,'2024-01-01','2025-12-31',1,'2026-05-08 14:51:50'),(3,'SUMMER20','Summer Sale - 20% off on all products','percentage',20.00,8000.00,5000.00,200,0,NULL,'2024-04-01','2024-06-30',1,'2026-05-08 14:51:50'),(4,'FESTIVE15','Festival Special - 15% off','percentage',15.00,10000.00,3000.00,300,0,NULL,'2024-10-01','2025-01-31',1,'2026-05-08 14:51:50');
/*!40000 ALTER TABLE `coupons` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `curr_order_items`
--

DROP TABLE IF EXISTS `curr_order_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `curr_order_items` (
  `id` int NOT NULL AUTO_INCREMENT,
  `order_id` int NOT NULL,
  `product_id` int NOT NULL,
  `product_name` varchar(255) NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `quantity` int DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `order_id` (`order_id`),
  CONSTRAINT `curr_order_items_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `current_orders` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `curr_order_items`
--

LOCK TABLES `curr_order_items` WRITE;
/*!40000 ALTER TABLE `curr_order_items` DISABLE KEYS */;
INSERT INTO `curr_order_items` VALUES (1,5,1,'Majestic 3-Seater Velvet Sofa',50000.00,5),(2,6,1,'Majestic 3-Seater Velvet Sofa',50000.00,4);
/*!40000 ALTER TABLE `curr_order_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `current_orders`
--

DROP TABLE IF EXISTS `current_orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `current_orders` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `total_amount` decimal(10,2) NOT NULL,
  `discount_amount` decimal(10,2) DEFAULT '0.00',
  `final_amount` decimal(10,2) NOT NULL,
  `offer_code` varchar(50) DEFAULT NULL,
  `shipping_address` text NOT NULL,
  `payment_method` varchar(50) DEFAULT 'COD',
  `status` varchar(50) DEFAULT 'Pending',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `current_orders_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `current_orders`
--

LOCK TABLES `current_orders` WRITE;

/*!40000 ALTER TABLE `current_orders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `newsletter_subscribers`
--

DROP TABLE IF EXISTS `newsletter_subscribers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `newsletter_subscribers` (
  `id` int NOT NULL AUTO_INCREMENT,
  `email` varchar(150) NOT NULL,
  `subscribed_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `newsletter_subscribers`
--

LOCK TABLES `newsletter_subscribers` WRITE;
/*!40000 ALTER TABLE `newsletter_subscribers` DISABLE KEYS */;
/*!40000 ALTER TABLE `newsletter_subscribers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `offers`
--

DROP TABLE IF EXISTS `offers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `offers` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `discount_code` varchar(50) NOT NULL,
  `discount_percent` int NOT NULL,
  `isSystemOffer` tinyint(1) DEFAULT '0',
  `max_uses` int DEFAULT NULL,
  `current_uses` int DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `discount_code` (`discount_code`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `offers`
--

LOCK TABLES `offers` WRITE;
/*!40000 ALTER TABLE `offers` DISABLE KEYS */;
INSERT INTO `offers` VALUES (1,'Newsletter Welcome Discount','WELCOME10',10,1,NULL,1),(2,'test','test20',20,0,50,0);
/*!40000 ALTER TABLE `offers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_items`
--

DROP TABLE IF EXISTS `order_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_items` (
  `id` int NOT NULL AUTO_INCREMENT,
  `order_id` int NOT NULL,
  `product_id` int DEFAULT NULL,
  `product_name` varchar(200) NOT NULL,
  `product_sku` varchar(100) DEFAULT NULL,
  `product_image` varchar(500) DEFAULT NULL,
  `quantity` int NOT NULL,
  `unit_price` decimal(10,2) NOT NULL,
  `sale_price` decimal(10,2) DEFAULT NULL,
  `total_price` decimal(10,2) NOT NULL,
  `color_selected` varchar(50) DEFAULT NULL,
  `finish_selected` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `order_id` (`order_id`),
  KEY `product_id` (`product_id`),
  CONSTRAINT `order_items_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE,
  CONSTRAINT `order_items_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_items`
--

LOCK TABLES `order_items` WRITE;
/*!40000 ALTER TABLE `order_items` DISABLE KEYS */;
/*!40000 ALTER TABLE `order_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `order_summary`
--

DROP TABLE IF EXISTS `order_summary`;
/*!50001 DROP VIEW IF EXISTS `order_summary`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `order_summary` AS SELECT 
 1 AS `id`,
 1 AS `order_number`,
 1 AS `total_amount`,
 1 AS `payment_method`,
 1 AS `payment_status`,
 1 AS `order_status`,
 1 AS `created_at`,
 1 AS `customer_name`,
 1 AS `customer_email`,
 1 AS `item_count`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orders` (
  `id` int NOT NULL AUTO_INCREMENT,
  `order_number` varchar(50) NOT NULL,
  `user_id` int NOT NULL,
  `subtotal` decimal(10,2) NOT NULL,
  `discount_amount` decimal(10,2) DEFAULT '0.00',
  `tax_amount` decimal(10,2) DEFAULT '0.00',
  `shipping_amount` decimal(10,2) DEFAULT '0.00',
  `total_amount` decimal(10,2) NOT NULL,
  `coupon_code` varchar(50) DEFAULT NULL,
  `payment_method` enum('razorpay','cod','bank_transfer','upi','credit_card','debit_card') NOT NULL,
  `payment_status` enum('pending','paid','failed','refunded','partially_refunded') DEFAULT 'pending',
  `payment_id` varchar(200) DEFAULT NULL,
  `razorpay_order_id` varchar(200) DEFAULT NULL,
  `razorpay_signature` varchar(500) DEFAULT NULL,
  `order_status` enum('placed','confirmed','processing','shipped','out_for_delivery','delivered','cancelled','returned','return_requested') DEFAULT 'placed',
  `shipping_name` varchar(100) NOT NULL,
  `shipping_email` varchar(150) NOT NULL,
  `shipping_phone` varchar(15) NOT NULL,
  `shipping_address` text NOT NULL,
  `shipping_city` varchar(50) NOT NULL,
  `shipping_state` varchar(50) NOT NULL,
  `shipping_pincode` varchar(10) NOT NULL,
  `shipping_country` varchar(50) DEFAULT 'India',
  `billing_same_as_shipping` tinyint(1) DEFAULT '1',
  `billing_name` varchar(100) DEFAULT NULL,
  `billing_address` text,
  `notes` text,
  `tracking_number` varchar(100) DEFAULT NULL,
  `tracking_url` varchar(300) DEFAULT NULL,
  `estimated_delivery` date DEFAULT NULL,
  `shipped_at` datetime DEFAULT NULL,
  `delivered_at` datetime DEFAULT NULL,
  `cancelled_at` datetime DEFAULT NULL,
  `cancel_reason` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `order_number` (`order_number`),
  KEY `idx_orders_user` (`user_id`),
  KEY `idx_orders_status` (`order_status`),
  CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders`
--

LOCK TABLES `orders` WRITE;
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
/*!40000 ALTER TABLE `orders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `payment_logs`
--

DROP TABLE IF EXISTS `payment_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `payment_logs` (
  `id` int NOT NULL AUTO_INCREMENT,
  `order_id` int DEFAULT NULL,
  `user_id` int DEFAULT NULL,
  `payment_gateway` varchar(50) DEFAULT NULL,
  `gateway_order_id` varchar(200) DEFAULT NULL,
  `gateway_payment_id` varchar(200) DEFAULT NULL,
  `amount` decimal(10,2) DEFAULT NULL,
  `currency` varchar(10) DEFAULT 'INR',
  `status` varchar(50) DEFAULT NULL,
  `gateway_response` text COMMENT 'Full JSON response',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `order_id` (`order_id`),
  CONSTRAINT `payment_logs_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payment_logs`
--

LOCK TABLES `payment_logs` WRITE;
/*!40000 ALTER TABLE `payment_logs` DISABLE KEYS */;
/*!40000 ALTER TABLE `payment_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product_images`
--

DROP TABLE IF EXISTS `product_images`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_images` (
  `id` int NOT NULL AUTO_INCREMENT,
  `product_id` int NOT NULL,
  `image_url` varchar(500) NOT NULL,
  `alt_text` varchar(200) DEFAULT NULL,
  `is_primary` tinyint(1) DEFAULT '0',
  `sort_order` int DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `product_id` (`product_id`),
  CONSTRAINT `product_images_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_images`
--

LOCK TABLES `product_images` WRITE;
/*!40000 ALTER TABLE `product_images` DISABLE KEYS */;
/*!40000 ALTER TABLE `product_images` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `product_listing`
--

DROP TABLE IF EXISTS `product_listing`;
/*!50001 DROP VIEW IF EXISTS `product_listing`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `product_listing` AS SELECT 
 1 AS `id`,
 1 AS `name`,
 1 AS `slug`,
 1 AS `short_description`,
 1 AS `price`,
 1 AS `sale_price`,
 1 AS `sku`,
 1 AS `stock`,
 1 AS `rating`,
 1 AS `review_count`,
 1 AS `view_count`,
 1 AS `sale_count`,
 1 AS `is_featured`,
 1 AS `is_bestseller`,
 1 AS `is_new_arrival`,
 1 AS `is_on_sale`,
 1 AS `category_name`,
 1 AS `category_slug`,
 1 AS `primary_image`,
 1 AS `discount_percent`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `products`
--

DROP TABLE IF EXISTS `products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `products` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(200) NOT NULL,
  `slug` varchar(200) NOT NULL,
  `description` text NOT NULL,
  `short_description` varchar(600) DEFAULT NULL,
  `features` text,
  `price` decimal(10,2) NOT NULL,
  `sale_price` decimal(10,2) DEFAULT NULL,
  `cost_price` decimal(10,2) DEFAULT NULL,
  `sku` varchar(100) NOT NULL,
  `stock` int DEFAULT '0',
  `min_stock_alert` int DEFAULT '5',
  `category_id` int DEFAULT NULL,
  `brand` varchar(100) DEFAULT NULL,
  `material` varchar(200) DEFAULT NULL,
  `dimensions` varchar(200) DEFAULT NULL,
  `weight` decimal(8,2) DEFAULT NULL,
  `color_options` text COMMENT 'JSON array of colors',
  `finish_options` text COMMENT 'JSON array of finishes',
  `warranty` varchar(100) DEFAULT NULL,
  `assembly_required` tinyint(1) DEFAULT '0',
  `rating` decimal(3,2) DEFAULT '0.00',
  `review_count` int DEFAULT '0',
  `view_count` int DEFAULT '0',
  `sale_count` int DEFAULT '0',
  `is_featured` tinyint(1) DEFAULT '0',
  `is_bestseller` tinyint(1) DEFAULT '0',
  `is_new_arrival` tinyint(1) DEFAULT '0',
  `is_on_sale` tinyint(1) DEFAULT '0',
  `is_active` tinyint(1) DEFAULT '1',
  `tags` text,
  `meta_title` varchar(200) DEFAULT NULL,
  `meta_description` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `slug` (`slug`),
  UNIQUE KEY `sku` (`sku`),
  KEY `idx_products_category` (`category_id`),
  KEY `idx_products_featured` (`is_featured`),
  KEY `idx_products_active` (`is_active`),
  CONSTRAINT `products_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `products`
--

LOCK TABLES `products` WRITE;
/*!40000 ALTER TABLE `products` DISABLE KEYS */;
/*!40000 ALTER TABLE `products` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reviews`
--

DROP TABLE IF EXISTS `reviews`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reviews` (
  `id` int NOT NULL AUTO_INCREMENT,
  `product_id` int NOT NULL,
  `user_id` int NOT NULL,
  `order_id` int DEFAULT NULL,
  `rating` int NOT NULL,
  `title` varchar(200) DEFAULT NULL,
  `comment` text NOT NULL,
  `pros` text,
  `cons` text,
  `images` text COMMENT 'JSON array of image URLs',
  `is_verified_purchase` tinyint(1) DEFAULT '0',
  `is_approved` tinyint(1) DEFAULT '0',
  `helpful_count` int DEFAULT '0',
  `reported_count` int DEFAULT '0',
  `admin_reply` text,
  `admin_replied_at` datetime DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `idx_reviews_product` (`product_id`),
  CONSTRAINT `reviews_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE,
  CONSTRAINT `reviews_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `reviews_chk_1` CHECK ((`rating` between 1 and 5))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reviews`
--

LOCK TABLES `reviews` WRITE;
/*!40000 ALTER TABLE `reviews` DISABLE KEYS */;
/*!40000 ALTER TABLE `reviews` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `shipping_methods`
--

DROP TABLE IF EXISTS `shipping_methods`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `shipping_methods` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `description` varchar(300) DEFAULT NULL,
  `estimated_days` varchar(50) DEFAULT NULL,
  `base_cost` decimal(8,2) NOT NULL,
  `free_above` decimal(10,2) DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `shipping_methods`
--

LOCK TABLES `shipping_methods` WRITE;
/*!40000 ALTER TABLE `shipping_methods` DISABLE KEYS */;
INSERT INTO `shipping_methods` VALUES (1,'Standard Delivery','Regular delivery to your doorstep','5-7 business days',299.00,10000.00,1,'2026-05-08 14:51:50'),(2,'Express Delivery','Fast priority delivery','2-3 business days',699.00,25000.00,1,'2026-05-08 14:51:50'),(3,'White Glove Delivery','Delivery with assembly and room placement','7-10 business days',1499.00,NULL,1,'2026-05-08 14:51:50');
/*!40000 ALTER TABLE `shipping_methods` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `site_enquiries`
--

DROP TABLE IF EXISTS `site_enquiries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `site_enquiries` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `message` text NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `site_enquiries`
--

LOCK TABLES `site_enquiries` WRITE;
/*!40000 ALTER TABLE `site_enquiries` DISABLE KEYS */;
INSERT INTO `site_enquiries` VALUES (1,'sdfaewf','abc@gmail.com','vsdzfasefdsV','2026-05-11 12:52:20');
/*!40000 ALTER TABLE `site_enquiries` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `site_settings`
--

DROP TABLE IF EXISTS `site_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `site_settings` (
  `id` int NOT NULL AUTO_INCREMENT,
  `setting_key` varchar(100) NOT NULL,
  `setting_value` text,
  `setting_type` enum('text','number','boolean','json','image') DEFAULT 'text',
  `description` varchar(300) DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `setting_key` (`setting_key`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `site_settings`
--

LOCK TABLES `site_settings` WRITE;
/*!40000 ALTER TABLE `site_settings` DISABLE KEYS */;
INSERT INTO `site_settings` VALUES (1,'site_name','LuxeCasa Furniture','text','Website name','2026-05-08 14:51:50'),(2,'site_tagline','Where Luxury Meets Comfort','text','Website tagline','2026-05-08 14:51:50'),(3,'site_email','info@luxecasa.com','text','Contact email','2026-05-08 14:51:50'),(4,'site_phone','+91 98765 43210','text','Contact phone','2026-05-08 14:51:50'),(5,'site_address','42, Design District, Connaught Place, New Delhi - 110001','text','Office address','2026-05-08 14:51:50'),(6,'currency','INR','text','Currency code','2026-05-08 14:51:50'),(7,'currency_symbol','₹','text','Currency symbol','2026-05-08 14:51:50'),(8,'tax_rate','18','number','GST percentage','2026-05-08 14:51:50'),(9,'razorpay_key_id','rzp_test_YOUR_KEY_HERE','text','Razorpay Key ID','2026-05-08 14:51:50'),(10,'free_shipping_above','10000','number','Free shipping above this amount','2026-05-08 14:51:50'),(11,'max_cart_quantity','10','number','Max quantity per product in cart','2026-05-08 14:51:50'),(12,'maintenance_mode','false','boolean','Enable/disable maintenance mode','2026-05-08 14:51:50'),(13,'social_facebook','https://facebook.com/luxecasa','text','Facebook URL','2026-05-08 14:51:50'),(14,'social_instagram','https://instagram.com/luxecasa','text','Instagram URL','2026-05-08 14:51:50'),(15,'social_twitter','https://twitter.com/luxecasa','text','Twitter URL','2026-05-08 14:51:50'),(16,'social_youtube','https://youtube.com/luxecasa','text','YouTube URL','2026-05-08 14:51:50');
/*!40000 ALTER TABLE `site_settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `full_name` varchar(100) NOT NULL,
  `email` varchar(150) NOT NULL,
  `password` varchar(255) NOT NULL,
  `phone` varchar(15) DEFAULT NULL,
  `address` text,
  `city` varchar(50) DEFAULT NULL,
  `state` varchar(50) DEFAULT NULL,
  `pincode` varchar(10) DEFAULT NULL,
  `country` varchar(50) DEFAULT 'India',
  `profile_pic` varchar(255) DEFAULT 'default-avatar.jpg',
  `role` enum('customer','admin','moderator') DEFAULT 'customer',
  `is_verified` tinyint(1) DEFAULT '0',
  `verification_token` varchar(255) DEFAULT NULL,
  `reset_token` varchar(255) DEFAULT NULL,
  `reset_token_expiry` datetime DEFAULT NULL,
  `last_login` datetime DEFAULT NULL,
  `login_count` int DEFAULT '0',
  `is_active` tinyint(1) DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'LuxeCasa Admin','admin@luxecasa.com','$2b$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lHFy',NULL,NULL,NULL,NULL,NULL,'India','default-avatar.jpg','admin',1,NULL,NULL,NULL,NULL,0,1,'2026-05-08 14:51:50','2026-05-08 14:51:50'),(2,'Rahul Sharma','rahul@example.com','$2b$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lHFy',NULL,NULL,NULL,NULL,NULL,'India','default-avatar.jpg','customer',1,NULL,NULL,NULL,NULL,0,1,'2026-05-08 14:51:50','2026-05-08 14:51:50'),(3,'Priya Verma','priya@example.com','$2b$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lHFy',NULL,NULL,NULL,NULL,NULL,'India','default-avatar.jpg','customer',1,NULL,NULL,NULL,NULL,0,1,'2026-05-08 14:51:50','2026-05-08 14:51:50');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wishlist`
--

DROP TABLE IF EXISTS `wishlist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `wishlist` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `product_id` int NOT NULL,
  `added_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_wishlist` (`user_id`,`product_id`),
  KEY `product_id` (`product_id`),
  CONSTRAINT `wishlist_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `wishlist_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wishlist`
--

LOCK TABLES `wishlist` WRITE;
/*!40000 ALTER TABLE `wishlist` DISABLE KEYS */;
/*!40000 ALTER TABLE `wishlist` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Final view structure for view `order_summary`
--

/*!50001 DROP VIEW IF EXISTS `order_summary`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `order_summary` AS select `o`.`id` AS `id`,`o`.`order_number` AS `order_number`,`o`.`total_amount` AS `total_amount`,`o`.`payment_method` AS `payment_method`,`o`.`payment_status` AS `payment_status`,`o`.`order_status` AS `order_status`,`o`.`created_at` AS `created_at`,`u`.`full_name` AS `customer_name`,`u`.`email` AS `customer_email`,count(`oi`.`id`) AS `item_count` from ((`orders` `o` join `users` `u` on((`o`.`user_id` = `u`.`id`))) join `order_items` `oi` on((`o`.`id` = `oi`.`order_id`))) group by `o`.`id` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `product_listing`
--

/*!50001 DROP VIEW IF EXISTS `product_listing`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `product_listing` AS select `p`.`id` AS `id`,`p`.`name` AS `name`,`p`.`slug` AS `slug`,`p`.`short_description` AS `short_description`,`p`.`price` AS `price`,`p`.`sale_price` AS `sale_price`,`p`.`sku` AS `sku`,`p`.`stock` AS `stock`,`p`.`rating` AS `rating`,`p`.`review_count` AS `review_count`,`p`.`view_count` AS `view_count`,`p`.`sale_count` AS `sale_count`,`p`.`is_featured` AS `is_featured`,`p`.`is_bestseller` AS `is_bestseller`,`p`.`is_new_arrival` AS `is_new_arrival`,`p`.`is_on_sale` AS `is_on_sale`,`c`.`name` AS `category_name`,`c`.`slug` AS `category_slug`,`pi`.`image_url` AS `primary_image`,(case when (`p`.`sale_price` is not null) then round((((`p`.`price` - `p`.`sale_price`) / `p`.`price`) * 100),0) else 0 end) AS `discount_percent` from ((`products` `p` left join `categories` `c` on((`p`.`category_id` = `c`.`id`))) left join `product_images` `pi` on(((`pi`.`product_id` = `p`.`id`) and (`pi`.`is_primary` = true)))) where (`p`.`is_active` = true) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-05-13 10:59:43
