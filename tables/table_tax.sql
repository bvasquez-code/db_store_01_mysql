DROP PROCEDURE IF EXISTS `p_manage_tax`;

DELIMITER $$

CREATE PROCEDURE `p_manage_tax`()
BEGIN
    DECLARE v_table_exists INT DEFAULT 0;

    -- 1. Verificamos si la tabla existe
    SELECT COUNT(*) INTO v_table_exists
    FROM information_schema.tables 
    WHERE table_schema = DATABASE() 
    AND table_name = 'tax';

    IF v_table_exists = 0 THEN
        -- =============================================
        -- CASO: LA TABLA NO EXISTE -> CREARLA COMPLETA
        -- =============================================
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tax` (
  `TaxCod` varchar(8) NOT NULL COMMENT 'codigo de impuesto',
  `TaxRateValue` decimal(16,4) NOT NULL COMMENT 'valor porcentual sobre 100 del impuesto',
  `Name` varchar(32) NOT NULL COMMENT 'nombre del impuesto',
  `Description` varchar(64) NOT NULL COMMENT 'descripcion del impuesto',
  `CreationUser` varchar(16) NOT NULL,
  `CreationDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ModifyUser` varchar(16) DEFAULT NULL,
  `ModifyDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `Status` char(1) NOT NULL DEFAULT 'A',
  PRIMARY KEY (`TaxCod`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `trx_payments`
--

        SELECT 'Tabla tax creada desde cero.' AS Mensaje;

    ELSE
        -- =============================================
        -- CASO: LA TABLA YA EXISTE -> APLICAR ALTERS
        -- =============================================
        
        -- Aqui puedes agregar bloques IF NOT EXISTS para futuros ALTERs
        
        SELECT 'Tabla tax ya existe. No se realizaron cambios estructurales.' AS Mensaje;

    END IF;

END $$

DELIMITER ;

-- Ejecutar y limpiar
CALL `p_manage_tax`();
DROP PROCEDURE `p_manage_tax`;
