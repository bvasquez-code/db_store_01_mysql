DROP TABLE IF EXISTS `store_sequence`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `store_sequence` (
  `StoreCod` varchar(4) NOT NULL COMMENT 'codigo de tienda',
  `PeriodId` int NOT NULL COMMENT 'periodo actual',
  `SequenceTrx` bigint NOT NULL DEFAULT '0' COMMENT 'secuencia actual',
  `Prefix` varchar(2) NOT NULL,
  `SequenceTableType` varchar(32) NOT NULL,
  KEY `fk_pstore_sequence_store` (`StoreCod`),
  KEY `fk_pstore_sequence_period` (`PeriodId`),
  CONSTRAINT `fk_pstore_sequence_period` FOREIGN KEY (`PeriodId`) REFERENCES `period` (`PeriodId`),
  CONSTRAINT `fk_pstore_sequence_store` FOREIGN KEY (`StoreCod`) REFERENCES `store` (`StoreCod`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `table_sequence`
--
