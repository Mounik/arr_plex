# qBittorrent

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
