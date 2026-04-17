DROP PROCEDURE IF EXISTS `p_manage_product_config`;

DELIMITER $$

CREATE PROCEDURE `p_manage_product_config`()
BEGIN
    DECLARE v_table_exists INT DEFAULT 0;

    -- 1. Verificamos si la tabla existe
    SELECT COUNT(*) INTO v_table_exists
    FROM information_schema.tables 
    WHERE table_schema = DATABASE() 
    AND table_name = 'product_config';

    IF v_table_exists = 0 THEN
        -- =============================================
        -- CASO: LA TABLA NO EXISTE -> CREARLA COMPLETA
        -- =============================================
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_config` (
  `ProductCod` varchar(20) NOT NULL,
  `NumPrice` decimal(16,2) DEFAULT '0.00',
  `NumMaxStock` int DEFAULT '0',
  `NumMinStock` int DEFAULT '0',
  `IsDiscontable` char(1) DEFAULT 'N',
  `DiscountType` char(2) DEFAULT NULL,
  `NumDiscountMax` decimal(16,2) DEFAULT '0.00',
  `Version` varchar(8) DEFAULT NULL,
  `CreationUser` varchar(16) NOT NULL,
  `CreationDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ModifyUser` varchar(16) DEFAULT NULL,
  `ModifyDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `Status` char(1) NOT NULL DEFAULT 'A',
  PRIMARY KEY (`ProductCod`),
  CONSTRAINT `fk_product_config_product` FOREIGN KEY (`ProductCod`) REFERENCES `product` (`ProductCod`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_info`
--

        SELECT 'Tabla product_config creada desde cero.' AS Mensaje;

    ELSE
        -- =============================================
        -- CASO: LA TABLA YA EXISTE -> APLICAR ALTERS
        -- =============================================
        
        -- Aqui puedes agregar bloques IF NOT EXISTS para futuros ALTERs
        
        SELECT 'Tabla product_config ya existe. No se realizaron cambios estructurales.' AS Mensaje;

    END IF;

END $$

DELIMITER ;

-- Ejecutar y limpiar
CALL `p_manage_product_config`();
DROP PROCEDURE `p_manage_product_config`;
