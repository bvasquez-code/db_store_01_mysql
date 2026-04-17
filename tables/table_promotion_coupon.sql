DROP PROCEDURE IF EXISTS `p_manage_promotion_coupon`;

DELIMITER $$

CREATE PROCEDURE `p_manage_promotion_coupon`()
BEGIN
    DECLARE v_table_exists INT DEFAULT 0;

    -- 1. Verificamos si la tabla existe
    SELECT COUNT(*) INTO v_table_exists
    FROM information_schema.tables 
    WHERE table_schema = DATABASE() 
    AND table_name = 'promotion_coupon';

    IF v_table_exists = 0 THEN
        -- =============================================
        -- CASO: LA TABLA NO EXISTE -> CREARLA COMPLETA
        -- =============================================
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `promotion_coupon` (
  `PromotionCod` char(6) NOT NULL COMMENT 'codigo de promocion',
  `CodCoupon` varchar(20) NOT NULL COMMENT 'codigo de cupon',
  `InitialUseDate` datetime NOT NULL,
  `FinalUseDate` datetime NOT NULL,
  `IsFree` char(1) NOT NULL COMMENT '(S:Si es libre)(N:No es libre)',
  `ClientCod` varchar(16) DEFAULT NULL COMMENT 'codigo de cliente',
  `CreationUser` varchar(16) NOT NULL,
  `CreationDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ModifyUser` varchar(16) DEFAULT NULL,
  `ModifyDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `Status` char(1) NOT NULL DEFAULT 'A',
  PRIMARY KEY (`CodCoupon`),
  KEY `fk_promotion_coupon_promotion` (`PromotionCod`),
  CONSTRAINT `fk_promotion_coupon_promotion` FOREIGN KEY (`PromotionCod`) REFERENCES `promotion` (`PromotionCod`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `promotion_product`
--

        SELECT 'Tabla promotion_coupon creada desde cero.' AS Mensaje;

    ELSE
        -- =============================================
        -- CASO: LA TABLA YA EXISTE -> APLICAR ALTERS
        -- =============================================
        
        -- Aqui puedes agregar bloques IF NOT EXISTS para futuros ALTERs
        
        SELECT 'Tabla promotion_coupon ya existe. No se realizaron cambios estructurales.' AS Mensaje;

    END IF;

END $$

DELIMITER ;

-- Ejecutar y limpiar
CALL `p_manage_promotion_coupon`();
DROP PROCEDURE `p_manage_promotion_coupon`;
