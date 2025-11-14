DROP TABLE IF EXISTS `payment_method`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `payment_method` (
  `PaymentMethodCod` varchar(8) NOT NULL,
  `Name` varchar(32) NOT NULL COMMENT 'nombre del metodo de pago',
  `Description` varchar(64) NOT NULL COMMENT 'descripcion del metodo de pago',
  `CreationUser` varchar(16) NOT NULL,
  `CreationDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ModifyUser` varchar(16) DEFAULT NULL,
  `ModifyDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `Status` char(1) NOT NULL DEFAULT 'A',
  `PaymentMethodType` char(4) DEFAULT NULL COMMENT 'Tipo de medio de pago',
  PRIMARY KEY (`PaymentMethodCod`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `period`
--
