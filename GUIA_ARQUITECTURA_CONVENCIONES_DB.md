# Guía de arquitectura y convenciones - Base de Datos

## 1. Resumen general

Este proyecto contiene scripts SQL para una base de datos MySQL orientada a tienda, inventario, ventas, preventas, compras, transferencias, pagos, usuarios, archivos, ubicaciones y configuracion de negocio.

El estilo principal no es un dump plano de `CREATE TABLE`. La mayoria de scripts de tablas estan encapsulados en un procedimiento temporal `p_manage_<tabla>` que:

1. elimina cualquier version previa del procedure temporal;
2. verifica si la tabla existe en `information_schema.tables`;
3. crea la tabla completa si no existe;
4. aplica `ALTER TABLE` idempotentes si ya existe;
5. ejecuta el procedure con `CALL`;
6. elimina el procedure temporal.

La arquitectura favorece scripts rerunnable para evolucionar el esquema. No se identifico un script maestro que ejecute todo el proyecto en orden.

## 2. Estructura del proyecto

Carpetas identificadas:

- `tables/`: scripts de creacion y mantenimiento de tablas. Es la carpeta principal del proyecto.
- `procedures/`: procedimientos y funciones persistentes de negocio o utilitarias.
- `trigger/`: triggers persistentes.

Archivos auxiliares:

- `tables/refactor_tables.py`: helper para convertir scripts de tabla planos al patron `p_manage_<tabla>`.
- `tables/remove_drop_table.py`: helper para remover `DROP TABLE IF EXISTS` de scripts de tabla.

Separacion logica observada:

- Seguridad/aplicacion: `app_user`, `app_profile`, `app_menu`, `profile_menu`, `user_profile`, `user_store`, `app_session`, `app_session_history`.
- Maestros: `brand`, `category`, `currency`, `payment_method`, `tax`, `carrier`, `company`, `person`, `client`, `supplier`, `store`, `warehouse`.
- Producto e inventario: `product`, `product_variant`, `product_config`, `product_barcode`, `product_picture`, `product_info`, `product_info_warehouse`, `product_search`, `product_ranking`, `kardex`.
- Documentos y correlativos: `counterfoil`, `counterfoil_store`, `system_document`, `table_sequence`, `store_sequence`.
- Transaccionales: `presale_*`, `sale_*`, `pucharse_*`, `transfer_*`, `transfer_request_*`, `credit_note_*`, `trx_payments`.
- Ubigeo: `ubigeo_department`, `ubigeo_province`, `ubigeo_district`.
- Configuracion: `business_config`, `business_config_group`, `business_config_table`.

Orden logico de ejecucion deducido:

1. Tablas base sin dependencias: maestros simples, ubicacion, configuracion, documentos, secuencias.
2. Tablas padre: `person`, `company`, `store`, `product`, `period`, `currency`, `payment_method`.
3. Tablas dependientes de maestros: usuarios, clientes, proveedores, almacenes, variantes, configuraciones de producto.
4. Tablas cabecera transaccional: `presale_head`, `sale_head`, `pucharse_head`, `transfer_head`, `transfer_request_head`, `credit_note_head`.
5. Tablas detalle/documento/pagos/almacen relacionadas con cabeceras.
6. Procedures y funciones persistentes.
7. Triggers que invocan procedures persistentes.

No identificado en el proyecto analizado: un orquestador oficial de ejecucion, numeracion de scripts, carpeta de migraciones por version, carpeta de rollback, carpeta separada de inserts iniciales.

## 3. Convenciones de nombres

Tablas:

- Se nombran en minusculas con `snake_case`: `sale_head`, `sale_det`, `product_info_warehouse`, `business_config_group`.
- Los archivos siguen el patron `tables/table_<nombre_tabla>.sql`.
- Las tablas cabecera usan normalmente sufijo `_head`.
- Las tablas detalle usan normalmente sufijo `_det`.
- Las tablas documento usan normalmente sufijo `_document`.
- Las tablas puente o relacion combinan nombres: `user_profile`, `user_store`, `promotion_product`, `counterfoil_store`.

Columnas:

- Se usa principalmente PascalCase o camel/Pascal mixto, no `snake_case`: `SaleCod`, `ProductCod`, `CreationUser`, `ModifyDate`, `NumTotalPrice`, `IsPaid`.
- Los codigos funcionales usan sufijo `Cod`: `StoreCod`, `ProductCod`, `CurrencyCod`.
- Algunos IDs numericos usan sufijo `Id` o `ID`: `PeriodId`, `TrxPaymentId`, `SessionID`, `ErrorID`.
- Importes y cantidades suelen iniciar con `Num`: `NumUnit`, `NumDiscount`, `NumTotalPrice`, `NumExchangevalue`.
- Indicadores booleanos/logicos suelen iniciar con `Is` o `Has`: `IsPaid`, `IsAppliedTax`, `HasCreditNote`.
- Estados de proceso usan nombres especificos: `SaleStatus`, `TransferStatus`, `ReceiveStatus`, `PaymentStatus`, `SunatStatus`.
- Estado logico comun: `Status`.

Primary keys:

- No se nombra explicitamente la constraint de PK; se usa `PRIMARY KEY (...)`.
- PK simple frecuente: `<Entidad>Cod`, por ejemplo `PaymentMethodCod`, `StoreCod`, `ProductCod`.
- PK compuesta frecuente en detalles o relaciones: `SaleCod, ItemNumber`; `UserCod, StoreCod`; `PaymentNumber, SaleCod, TrxPaymentId`.
- Existen PK con `AUTO_INCREMENT` en casos puntuales: `SessionID`, `ErrorID`, `TrxPaymentId`.

Foreign keys:

- Se usa el prefijo `fk_`.
- Patron comun: `fk_<tabla>_<referencia>`: `fk_sale_head_client`, `fk_sale_det_product`, `fk_user_store_store`.
- En varios casos el mismo nombre se usa para el indice y para la constraint FK.

Indices:

- Se usa el prefijo `idx_` para indices de busqueda o soporte: `idx_sale_det_old_pk`, `idx_transfer_head_status`, `idx_trx_payments_reversal_of`.
- Se usa `fk_` como nombre de indice cuando el indice soporta una FK.
- Se usa `uk_` o `uq_` para unicos en algunos casos: `uk_business_config_group_gcid`, `uq_company_taxid`.
- Hay excepciones donde un `UNIQUE KEY` usa prefijo `idx_`, como `idx_business_config_cfcrcd`.

Procedures:

- Procedures temporales de tabla: `p_manage_<tabla>`.
- Procedures persistentes utilitarios: `get_cod_seq`, `get_cod_trx`, `sp_initalize_store_automation`.
- Parametros de entrada: prefijo `p_`, por ejemplo `p_StoreCod`, `p_SequenceTableType`.
- Variables locales: prefijo `v_` o `l_`, por ejemplo `v_table_exists`, `v_PeriodId`, `l_cod_trx`.

Functions:

- Se identifico `get_ubigeo_full_name`.
- Parametros tambien usan `p_`.

Triggers:

- Se usa prefijo `trg_`: `trg_after_insert_store`.
- El nombre describe evento y tabla.

Secuencias:

- No existen objetos `CREATE SEQUENCE`.
- La secuencia se modela con tablas: `table_sequence` y `store_sequence`.

Packages:

- No identificado en el proyecto analizado. MySQL no maneja packages como Oracle.

## 4. Diseño de tablas

Patron general de tabla:

- Motor: `ENGINE=InnoDB`.
- Charset/collation: `DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci`.
- Identificadores SQL encerrados con backticks.
- Comentarios en columnas cuando aplica.
- Auditoria logica repetida en la mayoria de tablas:
  - `CreationUser varchar(16) NOT NULL`
  - `CreationDate datetime NOT NULL DEFAULT CURRENT_TIMESTAMP`
  - `ModifyUser varchar(16) DEFAULT NULL`
  - `ModifyDate datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP`
  - `Status char(1) NOT NULL DEFAULT 'A'`

Excepciones:

- Algunas tablas usan longitudes distintas para auditoria, por ejemplo `company` usa `CreationUser varchar(50)` y `ModifyUser varchar(50)`.
- `store_sequence` y `table_sequence` no siguen completamente el bloque comun de auditoria.

Tipos de clave primaria:

- Codigo funcional simple: comun en maestros (`BrandCod`, `CategoryCod`, `PaymentMethodCod`, `CurrencyCod`).
- Clave compuesta de relacion: comun en tablas intermedias (`UserCod, StoreCod`, `UserCod, ProfileCod`).
- Cabecera/detalle transaccional: la cabecera usa codigo funcional y el detalle usa codigo de cabecera + `ItemNumber`.
- ID autoincremental: usado solo en algunas tablas tecnicas o de transaccion (`TrxPaymentId`, `SessionID`, `ErrorID`).

Cabecera/detalle/documento:

- Cabeceras transaccionales terminan en `_head` y concentran totales, estados, moneda, tienda, cliente/proveedor y auditoria.
- Detalles terminan en `_det` y referencian el codigo de cabecera.
- Documentos terminan en `_document` y asocian codigos documentarios con la cabecera.
- Detalles por almacen terminan en `_det_warehouse` y agregan `WarehouseCod`.

Campos repetidos de negocio:

- Moneda: `CurrencyCod`, `CurrencyCodSys`, `NumExchangevalue`.
- Totales: `NumPriceSubTotal`, `NumTotalPrice`, `NumTotalTax`, `NumDiscount`.
- Producto: `ProductCod`, `Variant`, `LotNumber`, `ExpirationDate`.
- Tienda/almacen: `StoreCod`, `WarehouseCod`.
- Estados de proceso: `P`, `C`, `R`, `X`, `A`, `D`, `F` segun tabla y comentario.
- Estado logico: `Status` con default `A`; por comentarios recientes se interpreta `A=Activo`, `I=Inactivo` cuando esta documentado.

## 5. Relaciones y restricciones

Restricciones identificadas:

- PK fisicas con `PRIMARY KEY`.
- FK fisicas con `CONSTRAINT ... FOREIGN KEY ... REFERENCES`.
- Indices auxiliares para FK y busquedas.
- UNIQUE KEY en algunos maestros/configuraciones.
- CHECK en algunos casos, por ejemplo tipo de nota de credito.

FK fisicas:

- El proyecto si define FK fisicas en muchas tablas.
- Algunas tablas tambien agregan indices `KEY` con el mismo nombre que la FK antes de declarar la constraint.
- No se identifico una politica de cascadas `ON DELETE` / `ON UPDATE`; la mayoria de FK no declaran cascada.

Relaciones principales deducidas:

- `sale_head` depende de `presale_head`, `client`, `period`, `store`, `currency`.
- `sale_det` depende de `sale_head`, `product`, `product_variant`.
- `sale_payments` depende de `sale_head`, `trx_payments`, `currency`.
- `trx_payments` depende de `payment_method`.
- `credit_note_head` depende de `sale_head`, `client`, `period`, `store`, `currency`.
- `transfer_head` y `transfer_request_head` dependen de tiendas.
- Detalles de transferencia dependen de cabecera, producto y almacenes.
- `warehouse` depende de `store`.
- `product_variant`, `product_info`, `product_info_warehouse`, `product_search` conectan producto, variante, tienda, almacen y configuracion.

Reglas de migracion de restricciones:

- Cuando una PK se cambia, el script debe verificar la forma actual de la PK en `information_schema.statistics`.
- Si una FK depende de la PK anterior, primero se crea un indice secundario que soporte la relacion anterior.
- Despues se hace `DROP PRIMARY KEY` solo si existe y solo si la forma actual no coincide con la esperada.
- Finalmente se agrega la nueva PK.

## 6. Procedures, functions y packages

Procedures temporales de tablas:

- Se crean dentro de cada `table_<tabla>.sql`.
- No son parte del modelo persistente: se ejecutan y se eliminan al final del archivo.
- Contienen una variable `v_table_exists`.
- Usan `information_schema.tables`, `information_schema.columns`, `information_schema.statistics` y `information_schema.table_constraints` para hacer cambios idempotentes.
- Emiten mensajes con `SELECT '...' AS Mensaje`.

Procedures persistentes:

- `get_cod_seq`: incrementa `table_sequence` y devuelve `cod_trx`.
- `get_cod_trx`: incrementa `store_sequence` para la tienda y periodo activo, y devuelve `cod_trx`.
- `sp_initalize_store_automation`: inicializa almacen, stock, busqueda de producto y secuencias de tienda al crear una tienda.

Functions:

- `get_ubigeo_full_name`: retorna nombre completo de distrito, provincia y departamento; si no encuentra el codigo, retorna el codigo original.

Triggers:

- `trg_after_insert_store`: `AFTER INSERT ON store`; invoca `sp_initalize_store_automation`.

Manejo de errores:

- `sp_initalize_store_automation` usa `DECLARE EXIT HANDLER FOR SQLEXCEPTION` y `RESIGNAL`.
- `get_ubigeo_full_name` usa `DECLARE CONTINUE HANDLER FOR NOT FOUND`.
- No identificado en el proyecto analizado: `RAISE_APPLICATION_ERROR`, porque no corresponde a MySQL.
- No identificado en el proyecto analizado: rollback explicito dentro de procedures.

Transacciones:

- `get_cod_seq` y `get_cod_trx` ejecutan `SET @@autocommit = 1`.
- No se identificaron `COMMIT` o `ROLLBACK` explicitos.

Cursores y tipos:

- No identificado en el proyecto analizado: cursores declarados.
- No identificado en el proyecto analizado: `SYS_REFCURSOR` o tipos personalizados.
- No identificado en el proyecto analizado: packages.

## 7. Indices y performance

Patrones de indices:

- PK para acceso por codigo funcional o clave compuesta.
- Indices para columnas FK, frecuentemente nombrados igual que la FK.
- Indices `idx_` para busquedas funcionales o soporte de migracion.
- Indices `uk_` / `uq_` para unicidad cuando el nombre expresa constraint unica.

Columnas normalmente indexadas:

- Codigos de relacion: `StoreCod`, `ClientCod`, `ProductCod`, `Variant`, `CurrencyCod`, `PeriodId`.
- Estados de proceso: `TransferStatus`, `SunatStatus`.
- Relaciones de reversa o pago: `ReversalOfTrxPaymentId`, `TrxPaymentId`.
- Claves de configuracion: `GroupId`, `GroupCod`, `ConfigCod`.

Patrones de busqueda frecuentes deducidos:

- Busqueda por cabecera transaccional y detalle.
- Busqueda por tienda y periodo activo.
- Busqueda por producto/variante/almacen.
- Busqueda por estado de proceso.
- Busqueda por configuracion de negocio.

No identificado en el proyecto analizado:

- Analisis de planes de ejecucion.
- Estadisticas, particiones o hints.
- Indices fulltext.
- Politica formal de naming unica para todos los indices; existen variantes `idx_`, `fk_`, `uk_`, `uq_`.

## 8. Scripts de configuracion

Tablas de configuracion identificadas:

- `business_config_group`: grupos de configuracion.
- `business_config`: valores de configuracion por grupo.
- `business_config_table`: tabla auxiliar de configuracion.
- `table_sequence`: secuencias globales por tipo de tabla.
- `store_sequence`: secuencias por tienda y periodo.
- `system_document`: documentos del sistema.
- `counterfoil` y `counterfoil_store`: correlativos/talonarios por tienda.

Datos iniciales:

- No se identifico una carpeta o archivo dedicado a inserts iniciales.
- Se identifican inserts operativos dentro de `sp_initalize_store_automation`, ejecutados indirectamente al insertar una tienda mediante trigger.
- Esos inserts usan patron `INSERT INTO ... SELECT ... WHERE NOT EXISTS` para evitar duplicados.

Catalogos:

- Tablas maestras como `currency`, `payment_method`, `tax`, `brand`, `category`, `carrier` funcionan como catalogos.
- No se identifico un script central de carga de catalogos.

## 9. Scripts de reversion

No identificado en el proyecto analizado: carpeta de rollback, scripts `rollback`, convencion de reversion por version o scripts reversibles separados.

Lo que si existe:

- Los scripts de tabla son rerunnable hacia adelante.
- Cada script temporal elimina su procedure temporal al inicio y al final.
- Algunos scripts agregan columnas o PK solo si no existen o si la forma actual difiere.
- No se eliminan tablas como mecanismo normal de actualizacion; de hecho existe un helper para remover `DROP TABLE IF EXISTS`.

Para revertir cambios actualmente habria que escribir scripts manuales especificos para:

- eliminar columnas agregadas;
- restaurar PK anteriores;
- eliminar indices nuevos;
- eliminar constraints nuevas;
- revertir datos insertados por procedures.

Esa convencion de rollback manual no esta formalizada en el proyecto.

## 10. Version y compatibilidad

Motor deducido:

- MySQL.

Evidencia tecnica:

- `DELIMITER`.
- `ENGINE=InnoDB`.
- `AUTO_INCREMENT`.
- `DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci`.
- `information_schema`.
- `CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP`.
- `RESIGNAL`.
- `CHECK`.
- Backticks para identificadores.

Version objetivo:

- No identificado explicitamente en el proyecto analizado.
- La collation `utf8mb4_0900_ai_ci` apunta a MySQL 8.x.
- El uso de `CHECK` tambien requiere considerar compatibilidad con MySQL 8.0.16+ si se espera enforcement real.

Limitaciones importantes:

- No usar sintaxis Oracle como packages, `RAISE_APPLICATION_ERROR`, `SYS_REFCURSOR` o sequences nativas.
- Si se apunta a MariaDB o MySQL 5.7, validar compatibilidad de `utf8mb4_0900_ai_ci`, `CHECK` y algunas expresiones default.
- Los scripts dependen de `DATABASE()`; deben ejecutarse con el schema correcto seleccionado.
- Algunas rutinas usan nombre de schema fijo `db_store_01`; al clonar a otro proyecto se debe revisar ese calificador.

## 11. Reglas para nuevos desarrollos de Base de Datos

1. Crear nuevas tablas en `tables/table_<nombre_tabla>.sql`.
2. Nombrar la tabla en minusculas con `snake_case`.
3. Encapsular el script en un procedure temporal `p_manage_<nombre_tabla>`.
4. Al inicio usar `DROP PROCEDURE IF EXISTS p_manage_<nombre_tabla>`.
5. Dentro del procedure validar existencia con `information_schema.tables` y `DATABASE()`.
6. Si la tabla no existe, crearla completa con `ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci`.
7. Si la tabla existe, aplicar cambios con bloques idempotentes `IF NOT EXISTS` sobre `information_schema.columns`, `information_schema.statistics` o `information_schema.table_constraints`.
8. Al final ejecutar `CALL p_manage_<nombre_tabla>();` y luego `DROP PROCEDURE p_manage_<nombre_tabla>;`.
9. Usar columnas de negocio en PascalCase/camel-Pascal como el resto del proyecto: `EntidadCod`, `Num...`, `Is...`, `Has...`, `...Status`.
10. Incluir auditoria comun salvo excepcion justificada: `CreationUser`, `CreationDate`, `ModifyUser`, `ModifyDate`, `Status`.
11. Para maestros, preferir codigo funcional `<Entidad>Cod` como PK si el modulo existente relacionado sigue ese patron.
12. Para cabeceras transaccionales, usar `<Entidad>Cod` como PK y sufijo `_head`.
13. Para detalles transaccionales, usar sufijo `_det` y PK `CodigoCabecera + ItemNumber` cuando se trate de lineas repetibles.
14. Para tablas puente, usar PK compuesta con los codigos relacionados.
15. Usar `AUTO_INCREMENT` solo cuando el modulo existente lo justifique, como pagos tecnicos, sesiones o errores.
16. Nombrar FK como `fk_<tabla>_<referencia>`.
17. Crear indices para FK o busquedas frecuentes; usar `fk_` cuando el indice soporta directamente una FK y `idx_` para busquedas funcionales.
18. Usar `uk_` o `uq_` para indices unicos nuevos; evitar crear nuevos `UNIQUE KEY idx_...` aunque exista una excepcion historica.
19. Si se cambia una PK existente, validar primero la forma actual en `information_schema.statistics`.
20. Antes de dropear una PK usada por FK, crear un indice secundario que preserve las columnas antiguas necesarias.
21. No usar `DROP TABLE` como actualizacion normal.
22. No asumir que existe rollback: si el cambio es riesgoso, crear un script de reversion explicito y documentar que es una extension nueva de la convencion.
23. Para procedures persistentes, colocarlos en `procedures/`, usar parametros `p_`, variables `v_` o `l_`, y `DELIMITER`.
24. Para functions persistentes, colocarlas en `procedures/` si se mantiene la estructura actual.
25. Para triggers, colocarlos en `trigger/` y nombrarlos `trg_<evento>_<tabla>`.
26. Manejar errores con handlers MySQL (`DECLARE ... HANDLER`, `RESIGNAL`) cuando aplique.
27. No introducir packages, `SYS_REFCURSOR`, `RAISE_APPLICATION_ERROR` ni sequences nativas.
28. Si se agregan datos iniciales, preferir inserts idempotentes con `WHERE NOT EXISTS`; no hay carpeta formal de seeds, por lo que debe acordarse ubicacion antes de ampliar ese frente.
29. Revisar dependencias FK antes de definir orden de ejecucion.
30. Mantener mensajes `SELECT '...' AS Mensaje` en scripts de mantenimiento para trazabilidad durante ejecucion manual.

## 12. Ejemplo de estructura recomendada para un nuevo modulo

Supongamos un modulo transaccional `adjustment`.

Archivos recomendados:

```text
tables/
  table_adjustment_head.sql
  table_adjustment_det.sql
  table_adjustment_document.sql
procedures/
  sp_<nombre_operacion_adjustment>.sql
trigger/
  trg_<evento>_adjustment.sql
```

Tabla cabecera:

```sql
DROP PROCEDURE IF EXISTS `p_manage_adjustment_head`;

DELIMITER $$

CREATE PROCEDURE `p_manage_adjustment_head`()
BEGIN
    DECLARE v_table_exists INT DEFAULT 0;

    SELECT COUNT(*) INTO v_table_exists
    FROM information_schema.tables
    WHERE table_schema = DATABASE()
      AND table_name = 'adjustment_head';

    IF v_table_exists = 0 THEN
        CREATE TABLE `adjustment_head` (
          `AdjustmentCod` varchar(16) NOT NULL,
          `StoreCod` varchar(4) NOT NULL,
          `PeriodId` int NOT NULL,
          `AdjustmentStatus` char(1) NOT NULL DEFAULT 'P',
          `Commenter` varchar(128) DEFAULT NULL,
          `CreationUser` varchar(16) NOT NULL,
          `CreationDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
          `ModifyUser` varchar(16) DEFAULT NULL,
          `ModifyDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
          `Status` char(1) NOT NULL DEFAULT 'A',
          PRIMARY KEY (`AdjustmentCod`),
          KEY `fk_adjustment_head_store` (`StoreCod`),
          KEY `fk_adjustment_head_period` (`PeriodId`),
          CONSTRAINT `fk_adjustment_head_store` FOREIGN KEY (`StoreCod`) REFERENCES `store` (`StoreCod`),
          CONSTRAINT `fk_adjustment_head_period` FOREIGN KEY (`PeriodId`) REFERENCES `period` (`PeriodId`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

        SELECT 'Tabla adjustment_head creada desde cero.' AS Mensaje;
    ELSE
        SELECT 'Tabla adjustment_head ya existe. No se realizaron cambios estructurales.' AS Mensaje;
    END IF;
END $$

DELIMITER ;

CALL `p_manage_adjustment_head`();
DROP PROCEDURE `p_manage_adjustment_head`;
```

Tabla detalle:

```sql
DROP PROCEDURE IF EXISTS `p_manage_adjustment_det`;

DELIMITER $$

CREATE PROCEDURE `p_manage_adjustment_det`()
BEGIN
    DECLARE v_table_exists INT DEFAULT 0;

    SELECT COUNT(*) INTO v_table_exists
    FROM information_schema.tables
    WHERE table_schema = DATABASE()
      AND table_name = 'adjustment_det';

    IF v_table_exists = 0 THEN
        CREATE TABLE `adjustment_det` (
          `AdjustmentCod` varchar(16) NOT NULL,
          `ItemNumber` int NOT NULL,
          `ProductCod` varchar(20) NOT NULL,
          `Variant` varchar(4) NOT NULL DEFAULT '0000',
          `WarehouseCod` varchar(8) NOT NULL,
          `NumUnit` int DEFAULT NULL,
          `LotNumber` varchar(32) DEFAULT NULL,
          `ExpirationDate` date DEFAULT NULL,
          `CreationUser` varchar(16) NOT NULL,
          `CreationDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
          `ModifyUser` varchar(16) DEFAULT NULL,
          `ModifyDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
          `Status` char(1) NOT NULL DEFAULT 'A',
          PRIMARY KEY (`AdjustmentCod`, `ItemNumber`),
          KEY `fk_adjustment_det_product` (`ProductCod`),
          KEY `fk_adjustment_det_variant` (`ProductCod`, `Variant`),
          KEY `fk_adjustment_det_warehouse` (`WarehouseCod`),
          CONSTRAINT `fk_adjustment_det_head` FOREIGN KEY (`AdjustmentCod`) REFERENCES `adjustment_head` (`AdjustmentCod`),
          CONSTRAINT `fk_adjustment_det_product` FOREIGN KEY (`ProductCod`) REFERENCES `product` (`ProductCod`),
          CONSTRAINT `fk_adjustment_det_variant` FOREIGN KEY (`ProductCod`, `Variant`) REFERENCES `product_variant` (`ProductCod`, `Variant`),
          CONSTRAINT `fk_adjustment_det_warehouse` FOREIGN KEY (`WarehouseCod`) REFERENCES `warehouse` (`WarehouseCod`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

        SELECT 'Tabla adjustment_det creada desde cero.' AS Mensaje;
    ELSE
        SELECT 'Tabla adjustment_det ya existe. No se realizaron cambios estructurales.' AS Mensaje;
    END IF;
END $$

DELIMITER ;

CALL `p_manage_adjustment_det`();
DROP PROCEDURE `p_manage_adjustment_det`;
```

Notas del ejemplo:

- `adjustment` es solo un ejemplo estructural, no un modulo identificado en el proyecto.
- Si se agregan cambios futuros sobre estas tablas, deben ir en el bloque `ELSE` con validaciones `information_schema`.
- Si una PK o FK cambia, debe agregarse migracion idempotente y soporte para dependencias antes de alterar constraints.
