DROP TABLE IF EXISTS `counterfoil`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `counterfoil` (
  `CounterfoilCod` char(6) NOT NULL,
  `DocumentType` char(2) DEFAULT NULL,
  `Series` char(4) DEFAULT NULL,
  `Correlative` int DEFAULT NULL,
  `IsAutomatic` char(1) DEFAULT NULL,
  `CreationUser` varchar(16) NOT NULL,
  `CreationDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ModifyUser` varchar(16) DEFAULT NULL,
  `ModifyDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `Status` char(1) NOT NULL DEFAULT 'A',
  `GroupDocument` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  PRIMARY KEY (`CounterfoilCod`),
  KEY `idx_counterfoil_docser` (`DocumentType`,`Series`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `counterfoil_store`
--
