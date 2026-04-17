DROP PROCEDURE IF EXISTS `p_manage_app_session_history`;

DELIMITER $$

CREATE PROCEDURE `p_manage_app_session_history`()
BEGIN
    DECLARE v_table_exists INT DEFAULT 0;

    -- 1. Verificamos si la tabla existe
    SELECT COUNT(*) INTO v_table_exists
    FROM information_schema.tables 
    WHERE table_schema = DATABASE() 
    AND table_name = 'app_session_history';

    IF v_table_exists = 0 THEN
        -- =============================================
        -- CASO: LA TABLA NO EXISTE -> CREARLA COMPLETA
        -- =============================================
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `app_session_history` (
  `SessionID` bigint NOT NULL AUTO_INCREMENT,
  `UserCod` varchar(16) NOT NULL,
  `Token` varchar(256) NOT NULL,
  `SessionOjb` text,
  `DeleteDate` datetime DEFAULT NULL,
  `CreationUser` varchar(16) NOT NULL,
  `CreationDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ModifyUser` varchar(16) DEFAULT NULL,
  `ModifyDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `Status` char(1) NOT NULL DEFAULT 'A',
  PRIMARY KEY (`SessionID`),
  KEY `fk_app_session_his_app_user` (`UserCod`),
  KEY `idx_app_session_his_Token` (`Token`)
) ENGINE=InnoDB AUTO_INCREMENT=177 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `app_user`
--

        SELECT 'Tabla app_session_history creada desde cero.' AS Mensaje;

    ELSE
        -- =============================================
        -- CASO: LA TABLA YA EXISTE -> APLICAR ALTERS
        -- =============================================
        
        -- Aqui puedes agregar bloques IF NOT EXISTS para futuros ALTERs
        
        SELECT 'Tabla app_session_history ya existe. No se realizaron cambios estructurales.' AS Mensaje;

    END IF;

END $$

DELIMITER ;

-- Ejecutar y limpiar
CALL `p_manage_app_session_history`();
DROP PROCEDURE `p_manage_app_session_history`;
