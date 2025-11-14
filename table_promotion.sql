DROP TABLE IF EXISTS `promotion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `promotion` (
  `PromotionCod` char(6) NOT NULL,
  `Name` varchar(100) NOT NULL,
  `Description` varchar(200) NOT NULL,
  `DescriptionLong` varchar(800) NOT NULL,
  `InitialDate` datetime NOT NULL,
  `FinalDate` datetime NOT NULL,
  `InitialUseDate` datetime NOT NULL,
  `FinalUseDate` datetime NOT NULL,
  `TypePromotion` char(1) NOT NULL COMMENT '(C:CUPON)(L:LIBRE USO)',
  `CreationUser` varchar(16) NOT NULL,
  `CreationDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ModifyUser` varchar(16) DEFAULT NULL,
  `ModifyDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `Status` char(1) NOT NULL DEFAULT 'A',
  `WayOfUse` varchar(30) DEFAULT NULL COMMENT 'Simple | Dos_X_Uno | Tres_X_Uno | Tres_X_Dos',
  PRIMARY KEY (`PromotionCod`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `promotion_coupon`
--
