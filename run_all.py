import subprocess

def run(dept):
    print(f">>> Département {dept}")
    subprocess.run(["python3", "main.py", str(dept)], check=True)

print("=== Lancement pour toute la France ===")

# Métropole 01 → 95
for d in range(1, 96):
    run(f"{d:02d}")   # format 01, 02, 03...

# Corse
run("2A")
run("2B")

# DOM-TOM
for d in [971, 972, 973, 974, 975, 976]:
    run(d)

# Départements spéciaux
for d in [977, 978, 984, 986, 987, 988]:
    run(d)

print("=== Fin du run_all ===")
