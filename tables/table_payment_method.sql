DROP PROCEDURE IF EXISTS `p_manage_payment_method`;

DELIMITER $$

CREATE PROCEDURE `p_manage_payment_method`()
BEGIN
    DECLARE v_table_exists INT DEFAULT 0;

    -- 1. Verificamos si la tabla existe
    SELECT COUNT(*) INTO v_table_exists
    FROM information_schema.tables 
    WHERE table_schema = DATABASE() 
    AND table_name = 'payment_method';

    IF v_table_exists = 0 THEN
        -- =============================================
        -- CASO: LA TABLA NO EXISTE -> CREARLA COMPLETA
        -- =============================================
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `payment_method` (
  `PaymentMethodCod` varchar(8) NOT NULL,
  `Name` varchar(32) NOT NULL COMMENT 'nombre del metodo de pago',
  `Description` varchar(64) NOT NULL COMMENT 'descripcion del metodo de pago',
  `FileCod` varchar(20) NULL COMMENT 'Código de archivo de imagen del medio de pago',
  `Route` varchar(500) NULL COMMENT 'Ruta de archivo de imagen del medio de pago',
  `CreationUser` varchar(16) NOT NULL,
  `CreationDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ModifyUser` varchar(16) DEFAULT NULL,
  `ModifyDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `Status` char(1) NOT NULL DEFAULT 'A',
  `PaymentMethodType` char(4) DEFAULT NULL COMMENT 'Tipo de medio de pago',
  PRIMARY KEY (`PaymentMethodCod`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `period`
--

        SELECT 'Tabla payment_method creada desde cero.' AS Mensaje;

    ELSE
        -- =============================================
        -- CASO: LA TABLA YA EXISTE -> APLICAR ALTERS
        -- =============================================
        
        -- Aqui puedes agregar bloques IF NOT EXISTS para futuros ALTERs
        
        IF NOT EXISTS (
            SELECT * FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'payment_method'
            AND column_name = 'FileCod'
        ) THEN
            ALTER TABLE `payment_method` ADD COLUMN `FileCod` varchar(20) DEFAULT NULL COMMENT 'Código de archivo de imagen del medio de pago' AFTER `Description`;
            SELECT 'Columna FileCod agregada exitosamente.' AS Mensaje;
        END IF;

        IF NOT EXISTS (
            SELECT * FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'payment_method'
            AND column_name = 'Route'
        ) THEN
            ALTER TABLE `payment_method` ADD COLUMN `Route` varchar(500) DEFAULT NULL COMMENT 'Ruta de archivo de imagen del medio de pago' AFTER `Description`;
            SELECT 'Columna Route agregada exitosamente.' AS Mensaje;
        END IF;

        

    END IF;



END $$

DELIMITER ;

-- Ejecutar y limpiar
CALL `p_manage_payment_method`();
DROP PROCEDURE `p_manage_payment_method`;
