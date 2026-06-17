DROP PROCEDURE IF EXISTS `p_manage_person`;

DELIMITER $$

CREATE PROCEDURE `p_manage_person`()
BEGIN
    DECLARE v_table_exists INT DEFAULT 0;

    -- 1. Verificamos si la tabla existe
    SELECT COUNT(*) INTO v_table_exists
    FROM information_schema.tables 
    WHERE table_schema = DATABASE() 
    AND table_name = 'person';

    IF v_table_exists = 0 THEN
        -- =============================================
        -- CASO: LA TABLA NO EXISTE -> CREARLA COMPLETA
        -- =============================================
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `person` (
  `PersonCod` varchar(16) NOT NULL COMMENT 'codigo de persona',
  `PersonType` char(2) NOT NULL COMMENT 'tipo de persona',
  `DocumentType` char(2) NOT NULL COMMENT 'tipo de documento',
  `DocumentNum` varchar(16) NOT NULL COMMENT 'Numero de documento de identidad',
  `Names` varchar(128) NOT NULL COMMENT 'Nombres',
  `LastNames` varchar(128) NOT NULL COMMENT 'Apellidos',
  `CommercialName` varchar(128) DEFAULT NULL COMMENT 'Nombre comercial',
  `BusinessName` varchar(128) DEFAULT NULL COMMENT 'Razon social',
  `Address` varchar(256) DEFAULT NULL COMMENT 'Direccion',
  `UbigeoCod` varchar(12) DEFAULT NULL COMMENT 'codigo de ubigeo',
  `Phone` varchar(20) DEFAULT NULL COMMENT 'Telefono',
  `CellPhone` varchar(20) DEFAULT NULL COMMENT 'Telefono celular',
  `Email` varchar(32) DEFAULT NULL COMMENT 'Email',
  `CreationUser` varchar(16) NOT NULL,
  `CreationDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ModifyUser` varchar(16) DEFAULT NULL,
  `ModifyDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `Status` char(1) NOT NULL DEFAULT 'A',
  PRIMARY KEY (`PersonCod`),
  UNIQUE KEY `idx_person_uniqper` (`DocumentType`,`DocumentNum`),
  KEY `idx_person_docnum` (`DocumentNum`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `presale_det`
--

        SELECT 'Tabla person creada desde cero.' AS Mensaje;

    ELSE
        -- =============================================
        -- CASO: LA TABLA YA EXISTE -> APLICAR ALTERS
        -- =============================================
        
        -- Aqui puedes agregar bloques IF NOT EXISTS para futuros ALTERs
        IF NOT EXISTS (
            SELECT 1
            FROM information_schema.columns
            WHERE table_schema = DATABASE()
            AND table_name = 'person'
            AND column_name = 'CommercialName'
        ) THEN
            ALTER TABLE `person`
            ADD COLUMN `CommercialName` varchar(128) DEFAULT NULL COMMENT 'Nombre comercial'
            AFTER `LastNames`;
        END IF;

        IF NOT EXISTS (
            SELECT 1
            FROM information_schema.columns
            WHERE table_schema = DATABASE()
            AND table_name = 'person'
            AND column_name = 'BusinessName'
        ) THEN
            ALTER TABLE `person`
            ADD COLUMN `BusinessName` varchar(128) DEFAULT NULL COMMENT 'Razon social'
            AFTER `CommercialName`;
        END IF;

        IF NOT EXISTS (
            SELECT 1
            FROM information_schema.columns
            WHERE table_schema = DATABASE()
            AND table_name = 'person'
            AND column_name = 'Address'
        ) THEN
            ALTER TABLE `person`
            ADD COLUMN `Address` varchar(256) DEFAULT NULL COMMENT 'Direccion'
            AFTER `BusinessName`;
        END IF;
        
        SELECT 'Tabla person ya existe. Alteraciones aplicadas si eran necesarias.' AS Mensaje;

    END IF;

END $$

DELIMITER ;

-- Ejecutar y limpiar
CALL `p_manage_person`();
DROP PROCEDURE `p_manage_person`;
