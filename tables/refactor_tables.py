import glob
import os
import re

def refactor_file(filepath):
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()

    if "CREATE PROCEDURE" in content:
        print(f"Skipping {filepath} (already has procedure)")
        return

    # Find table name
    match = re.search(r'CREATE\s+TABLE\s+[`"]?(\w+)[`"]?', content, re.IGNORECASE)
    if not match:
        print(f"Skipping {filepath} (could not find CREATE TABLE)")
        return

    table_name = match.group(1)
    print(f"Refactoring {filepath} for table {table_name}...")

    # Template
    new_content = f"""DROP PROCEDURE IF EXISTS `p_manage_{table_name}`;

DELIMITER $$

CREATE PROCEDURE `p_manage_{table_name}`()
BEGIN
    DECLARE v_table_exists INT DEFAULT 0;

    -- 1. Verificamos si la tabla existe
    SELECT COUNT(*) INTO v_table_exists
    FROM information_schema.tables 
    WHERE table_schema = DATABASE() 
    AND table_name = '{table_name}';

    IF v_table_exists = 0 THEN
        -- =============================================
        -- CASO: LA TABLA NO EXISTE -> CREARLA COMPLETA
        -- =============================================
        {content.strip()}

        SELECT 'Tabla {table_name} creada desde cero.' AS Mensaje;

    ELSE
        -- =============================================
        -- CASO: LA TABLA YA EXISTE -> APLICAR ALTERS
        -- =============================================
        
        -- Aqui puedes agregar bloques IF NOT EXISTS para futuros ALTERs
        
        SELECT 'Tabla {table_name} ya existe. No se realizaron cambios estructurales.' AS Mensaje;

    END IF;

END $$

DELIMITER ;

-- Ejecutar y limpiar
CALL `p_manage_{table_name}`();
DROP PROCEDURE `p_manage_{table_name}`;
"""

    with open(filepath, 'w', encoding='utf-8') as f:
        f.write(new_content)

def main():
    files = glob.glob("*.sql")
    for file in files:
        refactor_file(file)

if __name__ == "__main__":
    main()
