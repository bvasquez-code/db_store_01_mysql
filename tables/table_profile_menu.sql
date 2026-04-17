DROP PROCEDURE IF EXISTS `p_manage_profile_menu`;

DELIMITER $$

CREATE PROCEDURE `p_manage_profile_menu`()
BEGIN
    DECLARE v_table_exists INT DEFAULT 0;

    -- 1. Verificamos si la tabla existe
    SELECT COUNT(*) INTO v_table_exists
    FROM information_schema.tables 
    WHERE table_schema = DATABASE() 
    AND table_name = 'profile_menu';

    IF v_table_exists = 0 THEN
        -- =============================================
        -- CASO: LA TABLA NO EXISTE -> CREARLA COMPLETA
        -- =============================================
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `profile_menu` (
  `ProfileCod` varchar(8) NOT NULL,
  `MenuCod` varchar(8) NOT NULL,
  `CreationUser` varchar(16) NOT NULL,
  `CreationDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ModifyUser` varchar(16) DEFAULT NULL,
  `ModifyDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `Status` char(1) NOT NULL DEFAULT 'A',
  PRIMARY KEY (`ProfileCod`,`MenuCod`),
  KEY `fk_product_search_menu` (`MenuCod`),
  CONSTRAINT `fk_product_search_menu` FOREIGN KEY (`MenuCod`) REFERENCES `app_menu` (`MenuCod`),
  CONSTRAINT `fk_profile_menu_profile` FOREIGN KEY (`ProfileCod`) REFERENCES `app_profile` (`ProfileCod`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `promotion`
--

        SELECT 'Tabla profile_menu creada desde cero.' AS Mensaje;

    ELSE
        -- =============================================
        -- CASO: LA TABLA YA EXISTE -> APLICAR ALTERS
        -- =============================================
        
        -- Aqui puedes agregar bloques IF NOT EXISTS para futuros ALTERs
        
        SELECT 'Tabla profile_menu ya existe. No se realizaron cambios estructurales.' AS Mensaje;

    END IF;

END $$

DELIMITER ;

-- Ejecutar y limpiar
CALL `p_manage_profile_menu`();
DROP PROCEDURE `p_manage_profile_menu`;
