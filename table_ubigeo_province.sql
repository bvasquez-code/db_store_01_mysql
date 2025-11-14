DROP TABLE IF EXISTS `ubigeo_province`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ubigeo_province` (
  `ProvinceCod` varchar(4) NOT NULL COMMENT 'CÃ³digo de provincia (4 dÃ­gitos), p.ej. 1501=Lima.',
  `Name` varchar(100) NOT NULL COMMENT 'Nombre oficial de la provincia.',
  `DepartmentCod` varchar(2) NOT NULL COMMENT 'CÃ³digo de departamento (2 dÃ­gitos) al que pertenece.',
  PRIMARY KEY (`ProvinceCod`),
  KEY `fk_province_department` (`DepartmentCod`),
  CONSTRAINT `fk_province_department` FOREIGN KEY (`DepartmentCod`) REFERENCES `ubigeo_department` (`DepartmentCod`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='CatÃ¡logo estÃ¡tico de provincias del PerÃº (UBIGEO nivel 2).';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_profile`
--
