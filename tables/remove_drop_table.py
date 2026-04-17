import glob
import os

def clean_file(filepath):
    with open(filepath, 'r', encoding='utf-8') as f:
        lines = f.readlines()

    new_lines = []
    modified = False
    for line in lines:
        if "DROP TABLE IF EXISTS" in line and "CREATE PROCEDURE" not in line: 
            # We want to remove the DROP TABLE inside the procedure, 
            # but NOT the DROP PROCEDURE IF EXISTS at the top.
            # The user specifically said "quita el DROP TABLE IF EXISTS".
            # The check `and "CREATE PROCEDURE" not in line` is redundant for DROP TABLE but good for safety.
            # Wait, the line is explicitly `DROP TABLE IF EXISTS ...`. 
            # The stored procedure drop is `DROP PROCEDURE IF EXISTS ...`.
            # So looking for `DROP TABLE IF EXISTS` is safe.
            modified = True
            continue 
        new_lines.append(line)

    if modified:
        print(f"Cleaning {filepath}...")
        with open(filepath, 'w', encoding='utf-8') as f:
            f.writelines(new_lines)

def main():
    files = glob.glob("*.sql")
    for file in files:
        clean_file(file)

if __name__ == "__main__":
    main()
