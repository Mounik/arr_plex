# Stack ARR  
Ci-dessous les instructions pour les systèmes d'exploitation Debian / Ubuntu, mais docker peut être exécuté nativement sur n'importe quelle distribution linux   
et si vous avez Windows ou Mac - vous pouvez utiliser des outils comme [Docker Desktop](https://docs.docker.com/desktop/) pour exécuter des conteneurs docker.   

### Installation de docker compose et préparation de l'environnement   

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
`docker compose version`

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

*(Si vous utilisez torrents + un client Usenet comme NZBGet ou SABnzbd alors vous devez utiliser :  
```bash
mkdir -p /data/{usenet/{incomplete,complete}/{tv,movies,music},media/{tv,movies,music}}
```
à la place de la première ligne)*


Vous pouvez trouver plus d'informations sur [SERVARR](https://wiki.servarr.com/radarr/installation/docker)

Vous pouvez utiliser une commande comme
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

# Premier lancement :

Vous devriez pouvoir lancer tous les services maintenant avec un simple
```bash
docker compose up -d
```
Le fichier compose crée un réseau dédié nommé `arr_plex` pour que tous les services communiquent entre eux.

---

# Configuration des services :

Maintenant vous devez vous assurer que les paramètres internes de vos applications correspondent, par exemple :
 - Radarr : Dans l'interface web, votre "Dossier Racine" pour votre bibliothèque doit être `/data/media/movies` (`/data/media/tv` pour Sonarr, `/data/media/music` pour Lidarr.
 - qBittorrent : Votre chemin de téléchargement doit être défini sur `/data/torrents`
 - car les deux chemins sont sur le même montage (`/data`), le système d'exploitation les traite comme le même système de fichiers, permettant des liens durs instantanés (aussi connus comme déplacements atomiques).

Configurons tout cela :

---

## qBittorrent :
Vérifiez les logs du conteneur qbittorrent :   
```bash
docker logs qbittorrent
```
Vous verrez dans les logs quelque chose comme :
```txt
*Le nom d'utilisateur administrateur de l'WebUI est : admin
Le mot de passe administrateur de l'WebUI n'a pas été défini.  
Un mot de passe temporaire est fourni pour cette session : <votre-mot-de-passe-sera-ici>
```
Maintenant vous pouvez aller à l'URL :  
Si vous êtes sur l'hôte :
```bash
http://localhost:8080
```
Depuis un autre appareil sur votre réseau : `http://<adresse ip de l'hôte>:8080` et connectez-vous en utilisant les détails fournis dans les logs du conteneur.  
Allez à `Tools - Options - WebUI` - vous pouvez changer l'utilisateur et le mot de passe ici mais n'oubliez pas de descendre et de sauvegarder.

Dans le panneau de gauche allez à `Categories - All - clic droit` et 'ajouter une catégorie' :

Pour Radarr :  
`Category: movies`  
`Save Path: movies`  
(ceci sera ajouté à '/data/torrents/ Chemin de Sauvegarde par Défaut que vous avez défini ci-dessus)  
Pour Sonarr :  
`Category: tv`  
`Save Path: tv`  
Pour Lidarr :  
`Category: music`  
`Save Path: music`  

Créez d'abord les catégories puis seulement configurez les étapes ci-dessous, car faire l'inverse a causé la disparition des Catégories.

Une fois les catégories créées - allez à `Tools - Options - Downloads` et dans `Saving Management` assurez-vous que vos paramètres correspondent à ce qui suit :  
`Default Torrent Management Mode - Automatic`  
`When Torrent Category changed - Relocate torrent`  
`When Default Save Path Changed - Switch affected torrents to Manual Mode`  
`When Category Save Path Changed - Switch affected torrents to Manual Mode`  
Cochez LES DEUX CASES pour `Use Subcategories` et `Use Category paths in Manual Mode`  
Default Save Path: - définissez sur `/data/torrents` (pour correspondre à votre structure de dossiers) - puis descendez tout en bas et `Save`.  


Si vous avez encore des problèmes avec l'ajout de catégories, vous pouvez utiliser une image différente comme celle ci-dessous:
```yml
  qbittorrent:
    <<: *common-keys
    container_name: qbittorrent
    image: ghcr.io/qbittorrent/docker-qbittorrent-nox:latest
    ports:
      - 8080:8080
      - 6881:6881
      - 6881:6881/udp
    environment:
      - QBT_LEGAL_NOTICE=confirm
      - WEBUI_PORT=8080
      - TORRENTING_PORT=6881
    volumes:
      - /etc/localtime:/etc/localtime:ro
      - /docker/appdata/qbittorrent:/config
      - /data:/data
```

C'est tout pour qBittorrent.

---

Maintenant configurez le service Prowlarr (chacun de ces services nécessitera de configurer utilisateur/mot de passe)  
Utilisez `Form (login page) authentication` et définissez votre utilisateur et mot de passe pour tous.

## Prowlarr:
```bash
http://<host_ip>:9696
```

Allez à `Settings - Download Clients` - symbole `+` - Add download client - choisissez `qBittorrent` (sauf si vous avez décidé d'utiliser un client de téléchargement différent)  

Décochez `Use SSL` (sauf si vous avez SSL configuré dans `qBittorrent - Tools - Options -WebUI` mais par défaut il n'est pas utilisé)  

Host - utilisez `qbittorrent` et port - mettez l'id de port correspondant au WebUI dans docker-compose pour qBittorrent (par défaut `8080`).  

nom d'utilisateur et mot de passe - utilisez celui que vous avez configuré pour qBittorrent à l'étape précédente.  

Cliquez sur le petit bouton `Test` en bas, assurez-vous d'obtenir un `tick` vert puis `Save`.

---

## Radarr:

```bash
http://<host_ip>:7878
```

Allez à `Settings - Media Management - Add Root Folder` (descendez en bas) - définissez `/data/media/movies` comme votre dossier racine.  

Toujours dans `Settings - Media Management` - cliquez sur `Show Advanced` - `Importing - Use Hardlinks instead of Copy` - assurez-vous qu'il est 'coché'  

Optionnel - vous pouvez aussi cocher `Rename Movies` et `Delete empty movie folders`, et dans `Import Extra Files` - assurez-vous que cette case est cochée
cocher le champ `Import Extra files` tapez `srt,sub,nfo` (ces 3 changements sont tous optionnels).

Rmonter tout en haut et click `Save`  

Puis `Settings- Download clients` - cliquez sur le symbole `plus`, choisissez `qBittorrent` etc - fondamentalement les mêmes étapes que pour Prowlarr.  

donc Host `qbittorrent`, port `8080`, assurez-vous que SSL est décoché, nom d'utilisateur admin et mot de passe - celui que vous avez configuré pour qBittorrent et changez la Category en `movies` (doit correspondre à la catégorie qbittorrent)  

Maintenant cliquez sur `Test` et si vous avez un 'tick' vert - `Save`.  

Maintenant allez à `Settings - General` - descendez à API key - Copiez API key - retournez à `Prowlarr - Settings - Apps` - cliquez sur `+` - Radarr - collez API key.  
Puis changez `Prowlarr Server` en `http://prowlarr:9696` et `Radarr Server` en `http://radarr:7878`  

Cliquez sur `Test` et si Vert - `Save`

Au fait - Vous devez configurer SABnzbd / qbittorrent et tous les autres services que vous exécutez aussi, pas seulement Radarr ou Sonarr.

---

## Sonarr:
```bash
http://<host_ip>:8989
```

Allez à `Settings - Media Management - Add Root Folder` - définissez `/data/media/tv` comme votre dossier racine.  
Toujours dans `Settings - Media Management` - `Show Advanced - Importing - Use Hardlinks instead of Copy` - assurez-vous qu'il est 'coché'  

Optionnel - vous pouvez aussi cocher `Rename Episodes` et `Delete empty Folders - delete empty series and season folders during disk scan`  
Puis dans `Import Extra Files` - assurez-vous que cette case est cochée et dans le champ `Import Extra files` tapez `srt,sub,nfo` (ces 3 changements sont tous optionnels)  
Remonter tout en haut et cliquer sur `Save`

Puis `Settings- Download clients` - cliquez sur le symbole `plus`, choisissez `qBittorrent` etc - fondamentalement les mêmes étapes que pour les services précédents  
Host `qbittorrent`, port `8080`, assurez-vous que SSL est décoché, nom d'utilisateur admin et mot de passe - celui que vous avez configuré pour qBittorrent et changez la Category en `tv` (par défaut c'est `tv-sonarr`, mais vous devez correspondre à la catégorie qbittorrent)  

Maintenant cliquez sur `Test` et si vous avez un `tick` vert - `Save`.  

Maintenant allez à `Settings - General` - descendez à API key - Copiez API key - retournez sur `Prowlarr` dans `Settings - Apps` - cliquez sur `+` - `Sonarr` - collez API key.  
Puis changez `Prowlarr Server` en `http://prowlarr:9696` et `Sonarr Server` en `http://sonarr:8989`  

Cliquez sur `Test` et si Vert - `Save`  

---

## Lidarr:
```bash
http://<host_ip>:8686
```

Allez dans `Settings` - `Media Management` - `Add Root Folder` - définissez le chemin vers `/data/media/music` comme votre dossier racine, définissez le nom en Music ou autre et sauvegardez.  

Puis dans `Settings` - `Download clients` - cliquez sur le symbole `plus`, choisissez qBittorrent etc - fondamentalement les mêmes étapes que pour les services précédents.  
Host `qbittorrent`, port `8080`, assurez-vous que SSL est décoché, nom d'utilisateur admin et mot de passe - celui que vous avez configuré pour qBittorrent.  
Ensuite changez la Category en `music` (par défaut c'est `lidarr`, mais vous devez correspondre à la catégorie qbittorrent)  

Maintenant cliquez sur `Test` et si vous avez un `tick` vert - `Save`.  

Maintenant allez à `Settings` - `General` - descendez à API key - Copiez API key - retournez sur `Prowlarr` - `Settings` - `Apps` - cliquez sur `+` - `Lidarr` - collez API key.  

Puis changez `Prowlarr Server` en `http://prowlarr:9696` et `Lidarr Server` en `http://lidarr:8686`  

Cliquez sur `Test` et si Vert - `Save`

---

## Bazarr:
```bash
http://<host_ip>:6767
```

Langues : Allez à `Settings` > `Languages`.

Dans le filtre `Languages Filter` taper `French` ou `English` ou les 2, ou n'importe quel autres langue qui vous convienne. Enregistrer, ensuite dans `Source` cliquer sur `Add Equal`. Enregistrer

Dans `Languages Profile` - `Add New Profile`.
Créer un prfil par langages que vous aurez choisi.

N'oubliez pas d'enregistrer.

Fournisseurs : Allez à `Settings` > `Providers` et ajoutez vos sources de sous-titres avec `Enable Providers` - `+` (OpenSubtitles.org, Subscene, etc.). La plupart nécessitent un compte gratuit.  

Synchronisation : Après avoir connecté Radarr/Sonarr, allez à l'onglet Series ou Movies et cliquez sur `Update` pour importer votre bibliothèque existante.  

Note : Bazarr utilise le chemin `/data/media` au lieu de `/data` pour l'accès aux médias, comme configuré dans le fichier compose.  

---

## Redémarrage des services :   
Il pourrait être judicieux de redémarrer tous les services et voir s'ils se lancent comme attendu :   

```bash
sudo docker compose down
sudo docker compose up -d
```
   
Si la première ligne dit :   
`WARN[0000] No services to build`  - ce message est en fait attendu ici.    

---

## Configuration restante :   
Ça devrait être tout, il vous suffit d'ajouter quelques indexeurs à Prowlarr.   
Vous pouvez ajouter plus d'indexeurs - cherchez simplement sur google quelque chose comme 'what are the best legal indexers for Prowlarr' ou similaire.   

C'est une idée fausse commune que la stack "Arr" est uniquement pour du contenu piraté.   
En réalité, ce sont des outils d'automatisation puissants pour gérer les médias, et il y a une richesse de contenu légal, libre de droits et open-source que vous pouvez utiliser avec.   
Dans Radarr, vous pouvez télécharger des films qui sont entrés dans le Domaine Public ou sont publiés sous licences Creative Commons.   
Classiques du Domaine Public : Ce sont des films "Golden Age" où le copyright n'a pas été renouvelé comme :   
Night of the Living Dead (1968), His Girl Friday (1940), Charade (1963), et The General (1926).   
Configurez Prowlarr avec l'Indexeur "Gold Standard" pour les médias légaux comme The Internet Archive (Archive.org).   
Ils hébergent des milliers de films du domaine public.   

---

## Overseerr

---

## Jellyfin
<!-- ## Plex   
`http://<host ip address>:32400`   
Pour regarder vos films, connectez-vous simplement à Plex, créez un utilisateur et un mot de passe et vous pouvez `Add Media Library`.   
Pour Content Type - choisissez `Movies` et trouvez le dossier `/data/media/movies`.   
Ajoutez plus de types de contenu comme TV ou Music en conséquence, en les liant aux bons dossiers médias.    -->

---

# Dépannage :   
### Vérification DNS :
Testez si vos conteneurs utilisent le DNS CloudFlare (configuré dans le fichier docker-compose.yml) :   
`sudo docker exec -it radarr cat /etc/resolv.conf`   

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

### FlareSolverr:   
Vous pourriez vouloir ajouter FlareSolverr si vous trouvez que Prowlarr échoue à indexer certains sites à cause des blocs "Cloudflare" :   
```
###################################
# FLARESOLVERR - Cloudflare Bypass
###################################

  flaresolverr:
    <<: *common-keys
    container_name: flaresolverr
    image: ghcr.io/flaresolverr/flaresolverr:latest
    ports:
      - 8191:8191
    environment:
      - LOG_LEVEL=info
```

 Une fois le conteneur en cours d'exécution, vous devez dire à Prowlarr de l'utiliser :   
 - Ouvrez votre Prowlarr Web UI (http://localhost:9696)   
 - Allez à Settings > Indexers.   
 - Cliquez sur le + (Add) sous Indexer Proxies et sélectionnez FlareSolverr.   
 - Remplissez les détails :   
 - Name: FlareSolverr   
 - Host: http://flaresolverr:8191 (Note : Utiliser le nom de service flaresolverr fonctionne car ils sont sur le même réseau Docker).   
 - Tags: Donnez-lui un tag comme cf (ceci est important).   
 - Sauvegardez le proxy      


### Accélération matérielle Plex :   
Pour l'accélération matérielle de Plex vous pourriez vouloir ajouter les 2 lignes du bas :    

```
plex:
    <<: *common-keys
    <...snip...>
    devices:
      - /dev/dri:/dev/dri # << paramètre de conteneur pour passer le GPU (ceci nécessite plus d'étapes en dehors de docker compose cependant)
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

