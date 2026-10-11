# TODO : COmprendre matplotlib et ecrire un code fonctionnel soi meme

import matplotlib.pyplot as plt

import argparse

parser = argparse.ArgumentParser()
parser.add_argument('file', help='Path to the input file')
args = parser.parse_args()

x_coords = []
y_coords = []

with open(args.file, 'r') as f:
    for line in f:
        line = line.strip()
        if not line or line.startswith('#'):
            continue
            
        # Supprime les guillemets s'il y en a au début/fin, puis sépare par la virgule
        line = line.replace('"', '')
        parts = line.split(',')
        
        # On vérifie qu'on a bien au moins 3 colonnes (index 0, 1, 2)
        if len(parts) >= 3:
            # parts[1] correspond à '048' (x) et parts[2] à '014' (y)
            x_coords.append(float(parts[1]))
            y_coords.append(float(parts[2]))

# Création du graphique et sauvegarde
plt.figure(figsize=(8, 6))
# plt.plot(x_coords, y_coords, marker='o', linestyle='-', color='b')
plt.plot(x_coords, y_coords)

#plt.title("Visualisation des coordonnées")
#plt.xlabel("Axe X")
#plt.ylabel("Axe Y")
#plt.grid(True)

#plt.savefig('mon_image.png', dpi=300)
plt.savefig('mon_image.svg')

print("Conversion réussie avec extraction des colonnes !")