DROP TABLE IF EXISTS `ubigeo_district`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ubigeo_district` (
  `DistrictCod` varchar(6) NOT NULL COMMENT 'CÃ³digo de distrito (6 dÃ­gitos), p.ej. 150101=Cercado de Lima.',
  `Name` varchar(120) NOT NULL COMMENT 'Nombre oficial del distrito.',
  `ProvinceCod` varchar(4) NOT NULL COMMENT 'CÃ³digo de provincia (4 dÃ­gitos) al que pertenece.',
  `DepartmentCod` varchar(2) NOT NULL COMMENT 'CÃ³digo de departamento (2 dÃ­gitos) al que pertenece.',
  PRIMARY KEY (`DistrictCod`),
  KEY `fk_district_province` (`ProvinceCod`),
  KEY `fk_district_department` (`DepartmentCod`),
  CONSTRAINT `fk_district_department` FOREIGN KEY (`DepartmentCod`) REFERENCES `ubigeo_department` (`DepartmentCod`),
  CONSTRAINT `fk_district_province` FOREIGN KEY (`ProvinceCod`) REFERENCES `ubigeo_province` (`ProvinceCod`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='CatÃ¡logo estÃ¡tico de distritos del PerÃº (UBIGEO nivel 3).';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ubigeo_province`
--
