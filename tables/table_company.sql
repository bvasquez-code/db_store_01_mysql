DROP TABLE IF EXISTS `company`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `company` (
  `CompanyCod` varchar(4) NOT NULL COMMENT 'CÃ³digo legible de la empresa (4 A-Z0-9). PK y referencia desde store.',
  `TaxId` char(11) NOT NULL COMMENT 'RUC de la empresa (11 dÃ­gitos).',
  `LegalName` varchar(200) NOT NULL COMMENT 'RazÃ³n Social registrada ante SUNAT.',
  `TradeName` varchar(200) DEFAULT NULL COMMENT 'Nombre Comercial.',
  `FiscalAddress` varchar(300) NOT NULL COMMENT 'Domicilio fiscal.',
  `Address` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT 'DirecciÃ³n comercial corta para impresiÃ³n/etiquetas',
  `UbigeoCod` varchar(6) NOT NULL COMMENT 'CÃ³digo UBIGEO (6 dÃ­gitos) del distrito del domicilio fiscal.',
  `CountryCode` char(2) NOT NULL DEFAULT 'PE' COMMENT 'CÃ³digo de paÃ­s ISO-3166-1 alfa-2 (p.ej. PE).',
  `Phone` varchar(30) DEFAULT NULL COMMENT 'TelÃ©fono corporativo.',
  `Email` varchar(150) DEFAULT NULL COMMENT 'Correo corporativo.',
  `Website` varchar(150) DEFAULT NULL COMMENT 'Sitio web corporativo.',
  `LogoPath` varchar(500) DEFAULT NULL COMMENT 'Ruta/URL del logo corporativo.',
  `Status` char(1) NOT NULL DEFAULT 'A',
  `CreationUser` varchar(50) NOT NULL,
  `CreationDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ModifyUser` varchar(50) DEFAULT NULL,
  `ModifyDate` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`CompanyCod`),
  UNIQUE KEY `uq_company_taxid` (`TaxId`),
  KEY `idx_company_legalname` (`LegalName`),
  KEY `idx_company_ubigeo` (`UbigeoCod`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Datos empresariales (identidad, RUC, domicilio y contacto). PK legible; UBIGEO a nivel distrito.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `counterfoil`
--
