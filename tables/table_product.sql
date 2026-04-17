DROP PROCEDURE IF EXISTS `p_manage_product`;

DELIMITER $$

CREATE PROCEDURE `p_manage_product`()
BEGIN
    DECLARE v_table_exists INT DEFAULT 0;

    -- 1. Verificamos si la tabla existe
    SELECT COUNT(*) INTO v_table_exists
    FROM information_schema.tables 
    WHERE table_schema = DATABASE() 
    AND table_name = 'product';

    IF v_table_exists = 0 THEN
        -- =============================================
        -- CASO: LA TABLA NO EXISTE -> CREARLA COMPLETA
        -- =============================================
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product` (
  `ProductCod` varchar(20) NOT NULL,
  `CategoryCod` varchar(10) NOT NULL,
  `BrandCod` varchar(10) NOT NULL,
  `ProductName` varchar(128) NOT NULL,
  `ProductDesc` varchar(256) DEFAULT NULL,
  `CreationUser` varchar(16) NOT NULL,
  `CreationDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ModifyUser` varchar(16) DEFAULT NULL,
  `ModifyDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `Status` char(1) NOT NULL DEFAULT 'A',
  PRIMARY KEY (`ProductCod`),
  KEY `fk_product_category` (`CategoryCod`),
  KEY `fk_product_brand` (`BrandCod`),
  CONSTRAINT `fk_product_brand` FOREIGN KEY (`BrandCod`) REFERENCES `brand` (`BrandCod`),
  CONSTRAINT `fk_product_category` FOREIGN KEY (`CategoryCod`) REFERENCES `category` (`CategoryCod`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_barcode`
--

        SELECT 'Tabla product creada desde cero.' AS Mensaje;

    ELSE
        -- =============================================
        -- CASO: LA TABLA YA EXISTE -> APLICAR ALTERS
        -- =============================================
        
        -- Aqui puedes agregar bloques IF NOT EXISTS para futuros ALTERs
        
        SELECT 'Tabla product ya existe. No se realizaron cambios estructurales.' AS Mensaje;

    END IF;

END $$

DELIMITER ;

-- Ejecutar y limpiar
CALL `p_manage_product`();
DROP PROCEDURE `p_manage_product`;
