DROP PROCEDURE IF EXISTS `p_manage_system_document`;

DELIMITER $$

CREATE PROCEDURE `p_manage_system_document`()
BEGIN
    DECLARE v_table_exists INT DEFAULT 0;

    -- 1. Verificamos si la tabla existe
    SELECT COUNT(*) INTO v_table_exists
    FROM information_schema.tables 
    WHERE table_schema = DATABASE() 
    AND table_name = 'system_document';

    IF v_table_exists = 0 THEN
        -- =============================================
        -- CASO: LA TABLA NO EXISTE -> CREARLA COMPLETA
        -- =============================================
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `system_document` (
  `DocumentCod` varchar(36) NOT NULL COMMENT 'UUID o identificador del documento',
  `DocumentType` varchar(32) NOT NULL COMMENT 'Tipo de documento, ej: JSON_DATA, EXCEL_TEMPLATE',
  `ReferenceCod` varchar(36) DEFAULT NULL COMMENT 'Codigo de referencia opcional',
  `Content` longtext NOT NULL COMMENT 'Contenido en formato texto, json o base64',
  `CreationUser` varchar(16) NOT NULL,
  `CreationDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ModifyUser` varchar(16) DEFAULT NULL,
  `ModifyDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `Status` char(1) NOT NULL DEFAULT 'A',
  PRIMARY KEY (`DocumentCod`),
  KEY `idx_system_document_type` (`DocumentType`),
  KEY `idx_system_document_ref` (`ReferenceCod`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

        SELECT 'Tabla system_document creada desde cero.' AS Mensaje;

    ELSE
        -- =============================================
        -- CASO: LA TABLA YA EXISTE -> APLICAR ALTERS
        -- =============================================
        
        -- Aqui puedes agregar bloques IF NOT EXISTS para futuros ALTERs
        
        SELECT 'Tabla system_document ya existe. No se realizaron cambios estructurales.' AS Mensaje;

    END IF;

END $$

DELIMITER ;

-- Ejecutar y limpiar
CALL `p_manage_system_document`();
DROP PROCEDURE `p_manage_system_document`;
