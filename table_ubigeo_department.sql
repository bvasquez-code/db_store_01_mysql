DROP TABLE IF EXISTS `ubigeo_department`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ubigeo_department` (
  `DepartmentCod` varchar(2) NOT NULL COMMENT 'CÃ³digo de departamento (2 dÃ­gitos), p.ej. 15=Lima.',
  `Name` varchar(100) NOT NULL COMMENT 'Nombre oficial del departamento.',
  PRIMARY KEY (`DepartmentCod`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='CatÃ¡logo estÃ¡tico de departamentos del PerÃº (UBIGEO nivel 1).';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ubigeo_district`
--
