# Sonarr

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