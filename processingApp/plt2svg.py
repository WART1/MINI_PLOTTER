import matplotlib.pyplot as plt


import argparse

parser = argparse.ArgumentParser()
parser.add_argument('file', help='Path to the input file')
args = parser.parse_args()


segments = []
current_x = []
current_y = []

with open(args.file, 'r') as f:
    for i, line in enumerate(f):
        if i == 0:
            continue  # Ignore l'en-tête
            
        line = line.strip()
        if not line or line.startswith('#'):
            continue
            
        parts = line.split(',')
        if len(parts) >= 4:
            x = float(parts[1])
            y = float(parts[2])
            pen_status = int(parts[3])  # 1 = Début de trait, 255 = Suite de trait
            
            # Si on rencontre un '1', c'est qu'on commence un nouveau segment
            if pen_status == 1:
                if current_x:
                    segments.append((current_x, current_y))
                    current_x, current_y = [], []
            
            # On ajoute le point au segment en cours
            current_x.append(x)
            current_y.append(y)

# Ajout du dernier segment
if current_x:
    segments.append((current_x, current_y))

# Création de la figure
fig, ax = plt.subplots(figsize=(8, 6))

# Tracé de chaque segment de manière indépendante
for seg_x, seg_y in segments:
    ax.plot(seg_x, seg_y, color='blue', linewidth=6)

# Redressement de l'axe Y
ax.set_ylim(ax.get_ylim()[::-1])

# Suppression totale des cadres, axes et marges
ax.axis('off')

# Sauvegarde finale propre en SVG et PNG transparent
plt.savefig('save_final.svg', bbox_inches='tight', pad_inches=0)
plt.savefig('save_final.png', dpi=300, bbox_inches='tight', pad_inches=0, transparent=True)

print("Conversion parfaite obtenue !")