DROP TABLE IF EXISTS `table_sequence`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `table_sequence` (
  `SequenceTrx` bigint NOT NULL DEFAULT '0' COMMENT 'secuencia actual',
  `Prefix` varchar(2) NOT NULL,
  `SequenceTableType` varchar(32) NOT NULL,
  `length` int NOT NULL,
  PRIMARY KEY (`SequenceTrx`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tax`
--
