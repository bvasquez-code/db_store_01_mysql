DROP PROCEDURE IF EXISTS `p_manage_store_sequence`;

DELIMITER $$

CREATE PROCEDURE `p_manage_store_sequence`()
BEGIN
    DECLARE v_table_exists INT DEFAULT 0;
    
    -- 1. Verificamos si la tabla existe
    SELECT COUNT(*) INTO v_table_exists
    FROM information_schema.tables 
    WHERE table_schema = DATABASE() 
    AND table_name = 'store_sequence';

    IF v_table_exists = 0 THEN
        -- =============================================
        -- CASO: LA TABLA NO EXISTE -> CREARLA COMPLETA
        -- =============================================
        CREATE TABLE `store_sequence` (
          `StoreCod` varchar(4) NOT NULL COMMENT 'codigo de tienda',
          `PeriodId` int NOT NULL COMMENT 'periodo actual',
          `SequenceTrx` bigint NOT NULL DEFAULT '0' COMMENT 'secuencia actual',
          `Prefix` varchar(2) NOT NULL,
          `SequenceTableType` varchar(32) NOT NULL,
          `SequenceLength` int NOT NULL DEFAULT 7 COMMENT 'Longitud del secuencial para relleno',
          KEY `fk_pstore_sequence_store` (`StoreCod`),
          KEY `fk_pstore_sequence_period` (`PeriodId`),
          CONSTRAINT `fk_pstore_sequence_period` FOREIGN KEY (`PeriodId`) REFERENCES `period` (`PeriodId`),
          CONSTRAINT `fk_pstore_sequence_store` FOREIGN KEY (`StoreCod`) REFERENCES `store` (`StoreCod`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
        
        SELECT 'Tabla store_sequence creada desde cero con SequenceLength.' AS Mensaje;

    ELSE
        -- =============================================
        -- CASO: LA TABLA YA EXISTE -> APLICAR ALTERS
        -- =============================================
        
        -- Verificamos si existe la columna SequenceLength
        IF NOT EXISTS (
            SELECT * FROM information_schema.columns 
            WHERE table_schema = DATABASE() 
            AND table_name = 'store_sequence' 
            AND column_name = 'SequenceLength'
        ) THEN
            ALTER TABLE `store_sequence` ADD COLUMN `SequenceLength` INT NOT NULL DEFAULT 7 COMMENT 'Longitud del secuencial para relleno';
            SELECT 'Columna SequenceLength agregada exitosamente.' AS Mensaje;
        END IF;

    END IF;

END $$

DELIMITER ;

-- Ejecutar y limpiar
CALL `p_manage_store_sequence`();
DROP PROCEDURE `p_manage_store_sequence`;
