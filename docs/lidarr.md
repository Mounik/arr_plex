## Lidarr

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