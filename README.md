# Stack ARR

Ci-dessous les instructions pour les systèmes d'exploitation Debian / Ubuntu, mais docker peut être exécuté nativement sur n'importe quelle distribution linux  
Si vous avez Windows ou Mac - vous pouvez utiliser des outils comme [Docker Desktop](https://docs.docker.com/desktop/) pour exécuter des conteneurs docker.

## La suite complète qui va être utilisé ici est la suivante

- qBittorrent (Downloader) : client BitTorrent qui télécharge automatiquement les fichiers trouvés par les autres outils.
- Prowlarr (Indexer Manager) : centralise et gère les indexeurs (sites de recherche) pour les partager avec Sonarr, Radarr, etc.
- Sonarr (TV Shows) : automatise la recherche, le téléchargement et l’organisation des séries TV.
- Radarr (Movies) : fait la même chose que Sonarr mais pour les films.
- Lidarr (Music) : gère la recherche et l’organisation automatique de la musique par artiste/album.
- Bazarr (Subtitles) : télécharge et synchronise automatiquement les sous-titres pour tes médias.
- Flaresolverr (Cloudflare Bypass) : aide les applications à accéder aux sites protégés par Cloudflare en résolvant les protections anti-bot.
- Overseerr (Request Manager) : interface pour que les utilisateurs demandent facilement des films ou séries à ajouter.
- Jellyfin (Media Server) : serveur multimédia qui organise et diffuse tes contenus (films, séries, musique) sur tes appareils.

En clair :  
- Overseerr reçoit les demandes.  
- Sonarr / Radarr / Lidarr cherchent le contenu.  
- Prowlarr fournit les indexeurs (avec Flaresolverr si protection).  
- qBittorrent télécharge.  
- Les fichiers sont rangés, Bazarr ajoute les sous-titres.  
- Jellyfin diffuse le tout.

## Installation de docker compose et préparation de l'environnement

Nous allons installer docker et docker compose en utilisant ces commandes :

```bash
# Add Docker's official GPG key:
sudo apt update
sudo apt install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
sudo tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/debian
Suites: $(. /etc/os-release && echo "${VERSION_CODENAME}")
Components: stable
Signed-By: /etc/apt/keyrings/docker.asc
EOF

sudo apt update
```

Puis exécutez :

```bash
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo systemctl status docker
sudo docker run hello-world
```

Pour éviter la commande sudo au début de chaque commande :

```bash
sudo usermod -aG docker $USER
newgrp docker
```

Vérifier avec :

```bash
docker images
```

Vous devriez voir l'images hello-world téléchargé précédemment

Pour tester si docker compose a été installé, exécutez :

```
docker compose version
```

Cela montrera que tout fonctionne comme attendu.

Créez maintenant la structure des dossiers selon ce plan et donner lui les droits :

```txt
/data
├── media
│   ├── movies
│   ├── music
│   └── tv
└── torrents
  ├── movies
  ├── music
  └── tv
```

```bash
sudo mkdir -p /data/{torrents/{tv,movies,music},media/{tv,movies,music}}
sudo apt install tree
tree /data
sudo chown -R 1000:1000 /data
sudo chmod -R 775 /data
ls -ln /data
```

Si vous utilisez torrents + un client Usenet comme NZBGet ou SABnzbd alors vous devez utiliser :

```bash
mkdir -p /data/{usenet/{incomplete,complete}/{tv,movies,music},media/{tv,movies,music}}
```

à la place de la première ligne


Vous pouvez trouver plus d'informations sur [SERVARR](https://wiki.servarr.com/radarr/installation/docker)

Vous pouvez utiliser une commande comme :

```bash
git clone https://github.com/automation-avenue/arr-new.git
```

ou simplement copier le fichier compose.yml depuis ce dépôt :

```
nano compose.yml
```

et collez le

Notez que les noms d'hôte ne sont pas nécessaires ici car nous avons un réseau dédié `arr_plex` pour nos conteneurs, ce qui permet aux services de communiquer en utilisant les noms des conteneurs comme noms d'hôte.

---

## Premier lancement :

Vous devriez pouvoir lancer tous les services maintenant avec un simple

```bash
docker compose up -d
```

Le fichier compose crée un réseau dédié nommé `arr_plex` pour que tous les services communiquent entre eux.

---

## Configuration des services :

Maintenant vous devez vous assurer que les paramètres internes de vos applications correspondent, par exemple :
 - Radarr : Dans l'interface web, votre "Dossier Racine" pour votre bibliothèque doit être `/data/media/movies` (`/data/media/tv` pour Sonarr, `/data/media/music` pour Lidarr.  
 - qBittorrent : Votre chemin de téléchargement doit être défini sur `/data/torrents`  
 - car les deux chemins sont sur le même montage (`/data`), le système d'exploitation les traite comme le même système de fichiers, permettant des liens durs instantanés (aussi connus comme déplacements atomiques).

Configurons tout cela dans le bon ordre :

---

[Qbittorrent](docs/qbittorrent.md)

[Prowlarr](docs/prowlarr.md)

[Radarr](docs/radarr.md)

[Sonarr](docs/sonarr.md)

[Lidarr](docs/lidarr.md)

[Bazarr](docs/bazarr.md)

[Jellyfin](docs/jellyfin.md)

[Overseerr](docs/overseerr.md)

[Flaresolverr](docs/flaresolverr.md)

---

## Redémarrage des services :

Il pourrait être judicieux de redémarrer tous les services et voir s'ils se lancent comme attendu :

```bash
sudo docker compose down
sudo docker compose up -d
```

---

## Configuration restante :

Ça devrait être tout, il vous suffit d'ajouter quelques indexeurs à Prowlarr.  
Vous pouvez ajouter plus d'indexeurs - cherchez simplement sur google quelque chose comme 'what are the best legal indexers for Prowlarr' ou similaire.  

C'est une fausse idée commune que la stack "Arr" est uniquement pour du contenu piraté.  
En réalité, ce sont des outils d'automatisation puissants pour gérer les médias, et il y a une richesse de contenu légal, libre de droits et open-source que vous pouvez utiliser avec.  
Dans Radarr, vous pouvez télécharger des films qui sont entrés dans le Domaine Public ou sont publiés sous licences Creative Commons.  
Classiques du Domaine Public : Ce sont des films "Golden Age" où le copyright n'a pas été renouvelé comme :  
Night of the Living Dead (1968), His Girl Friday (1940), Charade (1963), et The General (1926).  
Configurez Prowlarr avec l'Indexeur "Gold Standard" pour les médias légaux comme The Internet Archive (Archive.org).  
Ils hébergent des milliers de films du domaine public.  

---

## Dépannage

### Vérification DNS :

Testez si vos conteneurs utilisent le DNS CloudFlare (configuré dans le fichier docker-compose.yml) :

```bash
sudo docker exec -it radarr cat /etc/resolv.conf
```

### Vérification des hardlinks :

Vérifiez si les hardlinks fonctionnent comme attendu :  
Allez dans le dossier `/data` sur votre hôte et exécutez les commandes `tree` et `du -sch *` pour voir la structure des dossiers.  
Trouvez le même fichier dans torrents et media que vous venez de télécharger et exécutez les commandes :  
`ls -i /data/media/movies/<votre vidéo>` et vérifiez son id inode (dans la première colonne, comme 3881112)  
Puis exécutez à nouveau la même commande mais pour le dossier torrent :  
`ls -i /data/torrents/movies/<votre vidéo>` et voyez si l'id inode est le même que ci-dessus.  
Si c'est le cas - vos hardlinks fonctionnent comme attendu.  
Si ce n'est pas le cas - allez d'abord dans les logs pour voir quel est le problème (pour Radarr/Sonarr allez à System - Log Files)  
Si vous avez un problème où le fichier est copié plutôt que hardlinké, alors la cause la plus probable  
est les permissions de lecture/écriture sur la source ou la destination, mais tout cela peut être trouvé dans ces logs donc commencez par là.

### Les fichiers ne bougent pas du dossier torrents vers media :

Si la vidéo ne bouge pas automatiquement de torrents vers media, alors vérifiez Activity - Queue.  
Vous pourriez avoir un drapeau disant : 'Downloaded - Unable to Import Automatically'  
Cliquez sur Manual Import (icône qui ressemble à une tête humaine tout à droite de la ligne de l'élément)  
Confirmez le Film : Dans la popup, assurez-vous que le bon film est sélectionné dans le menu déroulant. Si c'est correct, cliquez sur 'Import'

---

### Accélération matérielle

Pour l'accélération matérielle vous pourriez vouloir ajouter les 2 lignes du bas :

```
jellyfin:
  <<: *common-keys
  <...snip...>
  devices:
    - /dev/dri:/dev/dri # << paramètre de conteneur pour passer le GPU (ceci nécessite plus d'étapes en dehors de docker compose)
```

### Client Usenet SABnzbd

Si vous utilisez SABnzbd au lieu de qBittorrent alors vous devez l'ajouter à votre fichier yml :

```
  sabnzbd:
  container_name: sabnzbd
  image: ghcr.io/hotio/sabnzbd:latest
  ports:
   - 8080:8080
   - 9090:9090
  volumes:
   - /etc/localtime:/etc/localtime:ro
   - /docker/appdata/sabnzbd:/config
   - /data:/data
```

Notez que si vous voulez exécuter les deux - qBittorrent ET sabnzbd - alors vous aurez un conflit pour le port 8080  
car ce port est aussi utilisé par qBittorrent.  
Vous devrez changer le port externe pour l'un des services vers quelque chose qui n'est pas utilisé, par exemple :  

```
  ports:
   - 8081:8080
```

Pour sabnzbd vous pouvez utiliser la structure de dossiers montrée [ICI](https://trash-guides.info/File-and-Folder-Structure/How-to-set-up/Docker/)  
puis assigner des catégories (similaire à ce que nous avons fait dans qbittorrent) en suivant [CE GUIDE](https://trash-guides.info/Downloaders/SABnzbd/Basic-Setup/)  

