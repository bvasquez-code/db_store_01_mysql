DROP TABLE IF EXISTS `business_config_table`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `business_config_table` (
  `GroupId` int NOT NULL,
  `GroupCod` varchar(64) NOT NULL,
  `ConfiTable` varchar(64) NOT NULL,
  `ReferenceColumn` varchar(64) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `category`
--
