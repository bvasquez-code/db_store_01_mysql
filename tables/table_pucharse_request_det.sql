DROP PROCEDURE IF EXISTS `p_manage_pucharse_request_det`;

DELIMITER $$

CREATE PROCEDURE `p_manage_pucharse_request_det`()
BEGIN
    DECLARE v_table_exists INT DEFAULT 0;

    -- 1. Verificamos si la tabla existe
    SELECT COUNT(*) INTO v_table_exists
    FROM information_schema.tables 
    WHERE table_schema = DATABASE() 
    AND table_name = 'pucharse_request_det';

    IF v_table_exists = 0 THEN
        -- =============================================
        -- CASO: LA TABLA NO EXISTE -> CREARLA COMPLETA
        -- =============================================
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pucharse_request_det` (
  `PucharseReqCod` varchar(16) NOT NULL,
  `ProductCod` varchar(20) NOT NULL,
  `Variant` varchar(4) NOT NULL DEFAULT (_utf8mb4'0000'),
  `NumUnit` int DEFAULT NULL,
  `NumUnitPrice` decimal(16,2) DEFAULT NULL,
  `NumTotalPrice` decimal(16,2) DEFAULT NULL,
  `CreationUser` varchar(16) NOT NULL,
  `CreationDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ModifyUser` varchar(16) DEFAULT NULL,
  `ModifyDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `Status` char(1) NOT NULL DEFAULT 'A',
  PRIMARY KEY (`PucharseReqCod`,`ProductCod`,`Variant`),
  KEY `fk_pucharse_request_det_variant` (`ProductCod`,`Variant`),
  CONSTRAINT `fk_pucharse_request_det_product` FOREIGN KEY (`ProductCod`) REFERENCES `product` (`ProductCod`),
  CONSTRAINT `fk_pucharse_request_det_pucharse_request_head` FOREIGN KEY (`PucharseReqCod`) REFERENCES `pucharse_request_head` (`PucharseReqCod`),
  CONSTRAINT `fk_pucharse_request_det_variant` FOREIGN KEY (`ProductCod`, `Variant`) REFERENCES `product_variant` (`ProductCod`, `Variant`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pucharse_request_head`
--

        SELECT 'Tabla pucharse_request_det creada desde cero.' AS Mensaje;

    ELSE
        -- =============================================
        -- CASO: LA TABLA YA EXISTE -> APLICAR ALTERS
        -- =============================================
        
        -- Aqui puedes agregar bloques IF NOT EXISTS para futuros ALTERs
        
        SELECT 'Tabla pucharse_request_det ya existe. No se realizaron cambios estructurales.' AS Mensaje;

    END IF;

END $$

DELIMITER ;

-- Ejecutar y limpiar
CALL `p_manage_pucharse_request_det`();
DROP PROCEDURE `p_manage_pucharse_request_det`;
