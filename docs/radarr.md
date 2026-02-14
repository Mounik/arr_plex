# Radarr

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