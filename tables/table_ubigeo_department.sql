DROP PROCEDURE IF EXISTS `p_manage_ubigeo_department`;

DELIMITER $$

CREATE PROCEDURE `p_manage_ubigeo_department`()
BEGIN
    DECLARE v_table_exists INT DEFAULT 0;

    -- 1. Verificamos si la tabla existe
    SELECT COUNT(*) INTO v_table_exists
    FROM information_schema.tables 
    WHERE table_schema = DATABASE() 
    AND table_name = 'ubigeo_department';

    IF v_table_exists = 0 THEN
        -- =============================================
        -- CASO: LA TABLA NO EXISTE -> CREARLA COMPLETA
        -- =============================================
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ubigeo_department` (
  `DepartmentCod` varchar(2) NOT NULL COMMENT 'CÃ³digo de departamento (2 dÃ­gitos), p.ej. 15=Lima.',
  `Name` varchar(100) NOT NULL COMMENT 'Nombre oficial del departamento.',
  PRIMARY KEY (`DepartmentCod`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='CatÃ¡logo estÃ¡tico de departamentos del PerÃº (UBIGEO nivel 1).';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ubigeo_district`
--

        SELECT 'Tabla ubigeo_department creada desde cero.' AS Mensaje;

    ELSE
        -- =============================================
        -- CASO: LA TABLA YA EXISTE -> APLICAR ALTERS
        -- =============================================
        
        -- Aqui puedes agregar bloques IF NOT EXISTS para futuros ALTERs
        
        SELECT 'Tabla ubigeo_department ya existe. No se realizaron cambios estructurales.' AS Mensaje;

    END IF;

END $$

DELIMITER ;

-- Ejecutar y limpiar
CALL `p_manage_ubigeo_department`();
DROP PROCEDURE `p_manage_ubigeo_department`;
