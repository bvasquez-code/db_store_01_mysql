DROP TABLE IF EXISTS `credit_note_document`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `credit_note_document` (
  `DocumentCod` varchar(32) NOT NULL COMMENT 'codigo de documento',
  `CounterfoilCod` char(6) NOT NULL COMMENT 'codigo talonario',
  `CreditNoteCod` varchar(16) NOT NULL COMMENT 'codigo de nota de credito',
  `CreationUser` varchar(16) NOT NULL,
  `CreationDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ModifyUser` varchar(16) DEFAULT NULL,
  `ModifyDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `Status` char(1) NOT NULL DEFAULT 'A',
  PRIMARY KEY (`DocumentCod`,`CreditNoteCod`),
  KEY `fk_sale_document_sale` (`CreditNoteCod`),
  CONSTRAINT `fk_credit_note_head` FOREIGN KEY (`CreditNoteCod`) REFERENCES `credit_note_head` (`CreditNoteCod`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `credit_note_head`
--
