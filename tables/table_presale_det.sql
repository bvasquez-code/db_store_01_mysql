DROP PROCEDURE IF EXISTS `p_manage_presale_det`;

DELIMITER $$

CREATE PROCEDURE `p_manage_presale_det`()
BEGIN
    DECLARE v_table_exists INT DEFAULT 0;

    -- 1. Verificamos si la tabla existe
    SELECT COUNT(*) INTO v_table_exists
    FROM information_schema.tables 
    WHERE table_schema = DATABASE() 
    AND table_name = 'presale_det';

    IF v_table_exists = 0 THEN
        -- =============================================
        -- CASO: LA TABLA NO EXISTE -> CREARLA COMPLETA
        -- =============================================
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `presale_det` (
  `PresaleCod` varchar(16) NOT NULL COMMENT 'codigo de preventa',
  `ItemNumber` int NOT NULL COMMENT 'Número de ítem/secuencia dentro de la preventa',
  `ProductCod` varchar(20) NOT NULL COMMENT 'codigo de producto',
  `Variant` varchar(4) NOT NULL DEFAULT (_utf8mb4'0000') COMMENT 'codigo de variante',
  `NumUnit` int DEFAULT NULL COMMENT 'Numero de unidades',
  `NumUnitPrice` decimal(16,2) DEFAULT NULL COMMENT 'Precio unitario',
  `NumDiscount` decimal(16,2) DEFAULT NULL COMMENT 'descuento',
  `NumUnitPriceSale` decimal(16,2) DEFAULT NULL COMMENT 'Precio unitario de venta final',
  `NumTotalPrice` decimal(16,2) DEFAULT NULL COMMENT 'Precio Total',
  `CreationUser` varchar(16) NOT NULL,
  `CreationDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ModifyUser` varchar(16) DEFAULT NULL,
  `ModifyDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `Status` char(1) NOT NULL DEFAULT 'A',
  `LotNumber` varchar(32) DEFAULT NULL COMMENT 'Número de lote del producto (si aplica)',
  `ExpirationDate` date DEFAULT NULL COMMENT 'Fecha de vencimiento (si aplica)',
  PRIMARY KEY (`PresaleCod`,`ItemNumber`),
  KEY `idx_presale_det_old_pk` (`PresaleCod`,`ProductCod`,`Variant`),
  KEY `fk_presale_det_variant` (`ProductCod`,`Variant`),
  CONSTRAINT `fk_presale_det_presale_head` FOREIGN KEY (`PresaleCod`) REFERENCES `presale_head` (`PresaleCod`),
  CONSTRAINT `fk_presale_det_product` FOREIGN KEY (`ProductCod`) REFERENCES `product` (`ProductCod`),
  CONSTRAINT `fk_presale_det_variant` FOREIGN KEY (`ProductCod`, `Variant`) REFERENCES `product_variant` (`ProductCod`, `Variant`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `presale_det_warehouse`
--

        SELECT 'Tabla presale_det creada desde cero.' AS Mensaje;

    ELSE
        -- =============================================
        -- CASO: LA TABLA YA EXISTE -> APLICAR ALTERS
        -- =============================================
        
        -- AGREGANDO COLUMNA ItemNumber
        IF NOT EXISTS (
            SELECT * FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'presale_det'
            AND column_name = 'ItemNumber'
        ) THEN
            ALTER TABLE `presale_det` ADD COLUMN `ItemNumber` int NOT NULL DEFAULT 0 COMMENT 'Número de ítem/secuencia dentro de la preventa' AFTER `PresaleCod`;
            UPDATE `presale_det` t
            JOIN (
                SELECT x.`PresaleCod`, x.`ProductCod`, x.`Variant`,
                       @item_number := IF(@parent_cod = x.`PresaleCod`, @item_number + 1, 1) AS NewItemNumber,
                       @parent_cod := x.`PresaleCod`
                FROM (
                    SELECT `PresaleCod`, `ProductCod`, `Variant`
                    FROM `presale_det`
                    ORDER BY `PresaleCod`, `ProductCod`, `Variant`
                ) x
                CROSS JOIN (SELECT @parent_cod := '', @item_number := 0) vars
            ) n ON n.`PresaleCod` = t.`PresaleCod`
                AND n.`ProductCod` = t.`ProductCod`
                AND n.`Variant` = t.`Variant`
            SET t.`ItemNumber` = n.NewItemNumber;
            SELECT 'Columna ItemNumber agregada exitosamente.' AS Mensaje;
        END IF;

        -- AGREGANDO COLUMNA LotNumber
        IF NOT EXISTS (
            SELECT * FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'presale_det'
            AND column_name = 'LotNumber'
        ) THEN
            ALTER TABLE `presale_det` ADD COLUMN `LotNumber` varchar(32) DEFAULT NULL COMMENT 'Número de lote del producto (si aplica)' AFTER `Status`;
            SELECT 'Columna LotNumber agregada exitosamente.' AS Mensaje;
        END IF;

        -- AGREGANDO COLUMNA ExpirationDate
        IF NOT EXISTS (
            SELECT * FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'presale_det'
            AND column_name = 'ExpirationDate'
        ) THEN
            ALTER TABLE `presale_det` ADD COLUMN `ExpirationDate` date DEFAULT NULL COMMENT 'Fecha de vencimiento (si aplica)' AFTER `LotNumber`;
            SELECT 'Columna ExpirationDate agregada exitosamente.' AS Mensaje;
        END IF;

        -- ACTUALIZANDO PRIMARY KEY SI ES NECESARIO
        IF NOT EXISTS (
            SELECT * FROM information_schema.statistics WHERE table_schema = DATABASE() AND table_name = 'presale_det'
            AND index_name = 'PRIMARY' AND column_name = 'PresaleCod' AND seq_in_index = 1
        ) OR NOT EXISTS (
            SELECT * FROM information_schema.statistics WHERE table_schema = DATABASE() AND table_name = 'presale_det'
            AND index_name = 'PRIMARY' AND column_name = 'ItemNumber' AND seq_in_index = 2
        ) OR EXISTS (
            SELECT * FROM information_schema.statistics WHERE table_schema = DATABASE() AND table_name = 'presale_det'
            AND index_name = 'PRIMARY' AND seq_in_index > 2
        ) THEN
            IF NOT EXISTS (
                SELECT * FROM information_schema.statistics WHERE table_schema = DATABASE() AND table_name = 'presale_det'
                AND index_name = 'idx_presale_det_old_pk'
            ) THEN
                ALTER TABLE `presale_det` ADD KEY `idx_presale_det_old_pk` (`PresaleCod`,`ProductCod`,`Variant`);
                SELECT 'Índice idx_presale_det_old_pk agregado exitosamente.' AS Mensaje;
            END IF;

            IF EXISTS (
                SELECT * FROM information_schema.table_constraints WHERE table_schema = DATABASE() AND table_name = 'presale_det'
                AND constraint_type = 'PRIMARY KEY'
            ) THEN
                ALTER TABLE `presale_det` DROP PRIMARY KEY;
            END IF;

            ALTER TABLE `presale_det` ADD PRIMARY KEY (`PresaleCod`,`ItemNumber`);
            SELECT 'Primary key de presale_det actualizada exitosamente.' AS Mensaje;
        END IF;

    END IF;

END $$

DELIMITER ;

-- Ejecutar y limpiar
CALL `p_manage_presale_det`();
DROP PROCEDURE `p_manage_presale_det`;
