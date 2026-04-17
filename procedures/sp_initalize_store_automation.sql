DELIMITER $$

DROP PROCEDURE IF EXISTS sp_initalize_store_automation$$

CREATE PROCEDURE sp_initalize_store_automation(
    IN p_StoreCod VARCHAR(4),
    IN p_Name VARCHAR(32),
    IN p_Description VARCHAR(128)
)
BEGIN
    DECLARE v_WarehouseCod VARCHAR(8);
    DECLARE v_WarehouseName VARCHAR(32);
    DECLARE v_WarehouseDesc VARCHAR(128);
    DECLARE v_PeriodId INT;

    -- Error handling to propagate errors
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        RESIGNAL;
    END;

    -- 3.1 Crear almacén por defecto (warehouse)
    SET v_WarehouseCod = CONCAT(p_StoreCod, '0001');
    SET v_WarehouseName = CONCAT('Almacen ', p_Name);
    SET v_WarehouseDesc = CONCAT('Almacen ', IFNULL(p_Description, ''));

    INSERT INTO warehouse (
        WarehouseCod, StoreCod, WarehouseName, WarehouseDesc, CreationUser, CreationDate, Status
    )
    SELECT 
        v_WarehouseCod, p_StoreCod, v_WarehouseName, v_WarehouseDesc, 'SYSTEM', NOW(), 'A'
    WHERE NOT EXISTS (
        SELECT 1 FROM warehouse WHERE WarehouseCod = v_WarehouseCod
    );

    -- 3.2 Inicializar stock por tienda (product_info)
    INSERT INTO product_info (
        ProductCod, Variant, StoreCod, NumDigitalStock, NumPhysicalStock, CreationUser, CreationDate, Status
    )
    SELECT 
        pv.ProductCod, pv.Variant, p_StoreCod, 0, 0, 'SYSTEM', NOW(), 'A'
    FROM product_variant pv
    WHERE NOT EXISTS (
        SELECT 1 FROM product_info pi 
        WHERE pi.ProductCod = pv.ProductCod 
        AND pi.StoreCod = p_StoreCod
        AND pi.Variant = pv.Variant
    );

    -- 3.3 Inicializar stock por almacén (product_info_warehouse)
    INSERT INTO product_info_warehouse (
        ProductCod, Variant, WarehouseCod, NumDigitalStock, NumPhysicalStock, CreationUser, CreationDate, Status
    )
    SELECT 
        pv.ProductCod, pv.Variant, v_WarehouseCod, 0, 0, 'SYSTEM', NOW(), 'A'
    FROM product_variant pv
    WHERE NOT EXISTS (
        SELECT 1 FROM product_info_warehouse piw 
        WHERE piw.ProductCod = pv.ProductCod 
        AND piw.WarehouseCod = v_WarehouseCod
        AND piw.Variant = pv.Variant
    );

    -- 3.4 Inicializar información de búsqueda (product_search)
    INSERT INTO product_search (
        ProductCod, StoreCod, ProductName, ProductDesc,
        NumDigitalStock, NumPhysicalStock, NumPrice,
        NumMaxStock, NumMinStock, IsDiscontable,
        DiscountType, NumDiscountMax,
        BrandCod, BrandName,
        CategoryCod, CategoryName, CategoryDadCod, CategoryDadName,
        CurrencyCod, CurrencySymbol,
        FileCod, FileRoute,
        NumTrend,
        CreationUser, CreationDate, Status
    )
    SELECT 
        p.ProductCod,
        p_StoreCod,
        p.ProductName,
        p.ProductDesc,
        0, -- NumDigitalStock
        0, -- NumPhysicalStock
        pc.NumPrice,
        pc.NumMaxStock,
        pc.NumMinStock,
        pc.IsDiscontable,
        pc.DiscountType,
        pc.NumDiscountMax,
        b.BrandCod,
        b.BrandName,
        c.CategoryCod,
        c.CategoryName,
        COALESCE(d.CategoryCod, c.CategoryCod) AS CategoryDadCod,
        COALESCE(d.CategoryName, c.CategoryName) AS CategoryDadName,
        cur.CurrencyCod,
        cur.CurrencySymbol,
        pp.FileCod,
        ap.Route,
        1, -- NumTrend
        'SYSTEM',
        NOW(),
        'A'
    FROM product p
    JOIN brand b ON p.BrandCod = b.BrandCod
    JOIN category c ON p.CategoryCod = c.CategoryCod
    LEFT JOIN category d ON c.CategoryDadCod = d.CategoryCod
    JOIN product_config pc ON p.ProductCod = pc.ProductCod
    LEFT JOIN product_picture pp ON p.ProductCod = pp.ProductCod AND pp.IsPrincipal = 'S' AND pp.Status = 'A'
    LEFT JOIN app_file ap ON ap.FileCod = pp.FileCod 
    CROSS JOIN currency cur
    WHERE cur.IsMonedaSystem = 'S'
    AND NOT EXISTS (
        SELECT 1 FROM product_search ps 
        WHERE ps.ProductCod = p.ProductCod 
        AND ps.StoreCod = p_StoreCod
    );

    -- 3.5 Inicializar secuencias por tienda (store_sequence)
    SELECT PeriodId INTO v_PeriodId FROM period 
    WHERE Status = 'A' LIMIT 1;

    IF v_PeriodId IS NOT NULL THEN
        
        INSERT INTO store_sequence (
            StoreCod, PeriodId, SequenceTrx, Prefix, SequenceTableType, SequenceLength
        )
        SELECT  
            p_StoreCod as StoreCod, 
            v_PeriodId as PeriodId, 
            0 as SequenceTrx, 
            tmp.Prefix, 
            tmp.SequenceTableType, 
            7 as SequenceLength
        from 
        (
            select distinct st.SequenceTableType,st.Prefix from store_sequence st
        ) tmp where tmp.SequenceTableType not in (
            select SequenceTableType from store_sequence where StoreCod = p_StoreCod
        );
        

    END IF;

END$$