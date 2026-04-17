DROP PROCEDURE IF EXISTS `p_manage_business_config`;

DELIMITER $$

CREATE PROCEDURE `p_manage_business_config`()
BEGIN
    DECLARE v_table_exists INT DEFAULT 0;

    -- 1. Verificamos si la tabla existe
    SELECT COUNT(*) INTO v_table_exists
    FROM information_schema.tables 
    WHERE table_schema = DATABASE() 
    AND table_name = 'business_config';

    IF v_table_exists = 0 THEN
        -- =============================================
        -- CASO: LA TABLA NO EXISTE -> CREARLA COMPLETA
        -- =============================================
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `business_config` (
  `GroupId` int NOT NULL,
  `GroupCod` varchar(64) NOT NULL,
  `ConfigCorr` int NOT NULL,
  `ConfigCod` varchar(64) NOT NULL,
  `ConfigVal` varchar(128) DEFAULT NULL,
  `ConfigName` varchar(128) DEFAULT NULL,
  `ConfigDesc` varchar(500) DEFAULT NULL,
  `Str1Config` varchar(16) DEFAULT NULL,
  `Str2Config` varchar(16) DEFAULT NULL,
  `Str3Config` varchar(256) DEFAULT NULL,
  `Str4Config` varchar(256) DEFAULT NULL,
  `Num1Config` int DEFAULT NULL,
  `Num2Config` int DEFAULT NULL,
  `Num3Config` int DEFAULT NULL,
  `Num4Config` int DEFAULT NULL,
  `Dcm1Config` decimal(16,4) DEFAULT NULL,
  `Dcm2Config` decimal(16,4) DEFAULT NULL,
  `Dcm3Config` decimal(16,4) DEFAULT NULL,
  `Dcm4Config` decimal(16,4) DEFAULT NULL,
  `Sta1Config` char(1) DEFAULT NULL,
  `Sta2Config` char(1) DEFAULT NULL,
  `Sta3Config` char(1) DEFAULT NULL,
  `Sta4Config` char(1) DEFAULT NULL,
  `CreationUser` varchar(16) NOT NULL,
  `CreationDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ModifyUser` varchar(16) DEFAULT NULL,
  `ModifyDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `Status` char(1) NOT NULL DEFAULT 'A',
  PRIMARY KEY (`GroupCod`,`ConfigCorr`),
  UNIQUE KEY `idx_business_config_cfcrcd` (`ConfigCod`),
  KEY `idx_business_config_gccc` (`GroupCod`),
  KEY `idx_business_config_gcid` (`GroupId`),
  KEY `idx_business_config_table_gcid` (`GroupId`,`GroupCod`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `business_config_table`
--

        SELECT 'Tabla business_config creada desde cero.' AS Mensaje;

    ELSE
        -- =============================================
        -- CASO: LA TABLA YA EXISTE -> APLICAR ALTERS
        -- =============================================
        
        -- Aqui puedes agregar bloques IF NOT EXISTS para futuros ALTERs
        
        SELECT 'Tabla business_config ya existe. No se realizaron cambios estructurales.' AS Mensaje;

    END IF;

END $$

DELIMITER ;

-- Ejecutar y limpiar
CALL `p_manage_business_config`();
DROP PROCEDURE `p_manage_business_config`;
