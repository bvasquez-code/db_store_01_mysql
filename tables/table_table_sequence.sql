DROP PROCEDURE IF EXISTS `p_manage_table_sequence`;

DELIMITER $$

CREATE PROCEDURE `p_manage_table_sequence`()
BEGIN
    DECLARE v_table_exists INT DEFAULT 0;
    
    -- 1. Verificamos si la tabla existe
    SELECT COUNT(*) INTO v_table_exists
    FROM information_schema.tables 
    WHERE table_schema = DATABASE() 
    AND table_name = 'table_sequence';

    IF v_table_exists = 0 THEN
        -- =============================================
        -- CASO: LA TABLA NO EXISTE -> CREARLA COMPLETA
        -- =============================================
        CREATE TABLE `table_sequence` (
          `SequenceTrx` bigint NOT NULL DEFAULT '0' COMMENT 'secuencia actual',
          `Prefix` varchar(2) NOT NULL,
          `SequenceTableType` varchar(32) NOT NULL,
          `length` int NOT NULL,

          -- Nueva columna solicitada
          `UsePrefix` char(1) NOT NULL DEFAULT 'S' COMMENT 'Usar prefijo (S/N)',

          PRIMARY KEY (`SequenceTrx`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
        
        SELECT 'Tabla table_sequence creada desde cero con UsePrefix.' AS Mensaje;

    ELSE
        -- =============================================
        -- CASO: LA TABLA YA EXISTE -> APLICAR ALTERS
        -- =============================================
        
        -- Verificamos si existe la columna UsePrefix
        IF NOT EXISTS (
            SELECT * FROM information_schema.columns 
            WHERE table_schema = DATABASE() 
            AND table_name = 'table_sequence' 
            AND column_name = 'UsePrefix'
        ) THEN
            ALTER TABLE `table_sequence` ADD COLUMN `UsePrefix` CHAR(1) NOT NULL DEFAULT 'S' COMMENT 'Usar prefijo (S/N)';
            SELECT 'Columna UsePrefix agregada exitosamente.' AS Mensaje;
        END IF;

    END IF;

END $$

DELIMITER ;

-- Ejecutar y limpiar
CALL `p_manage_table_sequence`();
DROP PROCEDURE `p_manage_table_sequence`;
