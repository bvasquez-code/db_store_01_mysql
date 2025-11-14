DELIMITER ;;
CREATE FUNCTION `db_store_01`.`get_ubigeo_full_name`(p_district_cod VARCHAR(6)) RETURNS varchar(350) CHARSET utf8mb4
    READS SQL DATA
    SQL SECURITY INVOKER
BEGIN
  DECLARE v_dist VARCHAR(120);
  DECLARE v_prov VARCHAR(100);
  DECLARE v_dept VARCHAR(100);

  -- Manejo de "no encontrado"
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_dist = NULL, v_prov = NULL, v_dept = NULL;

  SELECT d.Name, p.Name, dep.Name
    INTO v_dist, v_prov, v_dept
  FROM ubigeo_district   d
  JOIN ubigeo_province   p   ON p.ProvinceCod     = d.ProvinceCod
  JOIN ubigeo_department dep ON dep.DepartmentCod = d.DepartmentCod
  WHERE d.DistrictCod = p_district_cod
  LIMIT 1;

  IF v_dist IS NULL THEN
    RETURN p_district_cod; -- fallback si el código no existe
  END IF;

  RETURN CONCAT(v_dist, ' - ', v_prov, ' - ', v_dept);
END ;;
DELIMITER ;