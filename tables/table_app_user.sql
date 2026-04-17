DROP PROCEDURE IF EXISTS `p_manage_app_user`;

DELIMITER $$

CREATE PROCEDURE `p_manage_app_user`()
BEGIN
    DECLARE v_table_exists INT DEFAULT 0;

    -- 1. Verificamos si la tabla existe
    SELECT COUNT(*) INTO v_table_exists
    FROM information_schema.tables 
    WHERE table_schema = DATABASE() 
    AND table_name = 'app_user';

    IF v_table_exists = 0 THEN
        -- =============================================
        -- CASO: LA TABLA NO EXISTE -> CREARLA COMPLETA
        -- =============================================
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `app_user` (
  `UserCod` varchar(16) NOT NULL COMMENT 'Codigo de usuario',
  `PersonCod` varchar(16) NOT NULL COMMENT 'Codigo de persona',
  `Password` varchar(256) NOT NULL COMMENT 'ContraseÃ±a del usuario',
  `Email` varchar(32) NOT NULL COMMENT 'Correo electronico',
  `CreationCode` varchar(8) NOT NULL COMMENT 'Codigo de reversion del usuario',
  `DateExpire` datetime NOT NULL COMMENT 'Fecha de expiracion del usuario',
  `RecoveryCod` varchar(256) DEFAULT NULL COMMENT 'Codigo de recuperacion de cuenta',
  `CreationUser` varchar(16) NOT NULL,
  `CreationDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ModifyUser` varchar(16) DEFAULT NULL,
  `ModifyDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `Status` char(1) NOT NULL DEFAULT 'A',
  `PasswordDecoded` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`UserCod`),
  KEY `idx_app_user_Email` (`Email`),
  KEY `fk_app_user_person` (`PersonCod`),
  CONSTRAINT `fk_app_user_person` FOREIGN KEY (`PersonCod`) REFERENCES `person` (`PersonCod`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `brand`
--

        SELECT 'Tabla app_user creada desde cero.' AS Mensaje;

    ELSE
        -- =============================================
        -- CASO: LA TABLA YA EXISTE -> APLICAR ALTERS
        -- =============================================
        
        -- Aqui puedes agregar bloques IF NOT EXISTS para futuros ALTERs
        
        SELECT 'Tabla app_user ya existe. No se realizaron cambios estructurales.' AS Mensaje;

    END IF;

END $$

DELIMITER ;

-- Ejecutar y limpiar
CALL `p_manage_app_user`();
DROP PROCEDURE `p_manage_app_user`;
