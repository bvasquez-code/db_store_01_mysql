DROP PROCEDURE IF EXISTS `p_manage_promotion`;

DELIMITER $$

CREATE PROCEDURE `p_manage_promotion`()
BEGIN
    DECLARE v_table_exists INT DEFAULT 0;

    -- 1. Verificamos si la tabla existe
    SELECT COUNT(*) INTO v_table_exists
    FROM information_schema.tables 
    WHERE table_schema = DATABASE() 
    AND table_name = 'promotion';

    IF v_table_exists = 0 THEN
        -- =============================================
        -- CASO: LA TABLA NO EXISTE -> CREARLA COMPLETA
        -- =============================================
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `promotion` (
  `PromotionCod` char(6) NOT NULL,
  `Name` varchar(100) NOT NULL,
  `Description` varchar(200) NOT NULL,
  `DescriptionLong` varchar(800) NOT NULL,
  `InitialDate` datetime NOT NULL,
  `FinalDate` datetime NOT NULL,
  `InitialUseDate` datetime NOT NULL,
  `FinalUseDate` datetime NOT NULL,
  `TypePromotion` char(1) NOT NULL COMMENT '(C:CUPON)(L:LIBRE USO)',
  `CreationUser` varchar(16) NOT NULL,
  `CreationDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ModifyUser` varchar(16) DEFAULT NULL,
  `ModifyDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `Status` char(1) NOT NULL DEFAULT 'A',
  `WayOfUse` varchar(30) DEFAULT NULL COMMENT 'Simple | Dos_X_Uno | Tres_X_Uno | Tres_X_Dos',
  PRIMARY KEY (`PromotionCod`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `promotion_coupon`
--

        SELECT 'Tabla promotion creada desde cero.' AS Mensaje;

    ELSE
        -- =============================================
        -- CASO: LA TABLA YA EXISTE -> APLICAR ALTERS
        -- =============================================
        
        -- Aqui puedes agregar bloques IF NOT EXISTS para futuros ALTERs
        
        SELECT 'Tabla promotion ya existe. No se realizaron cambios estructurales.' AS Mensaje;

    END IF;

END $$

DELIMITER ;

-- Ejecutar y limpiar
CALL `p_manage_promotion`();
DROP PROCEDURE `p_manage_promotion`;
