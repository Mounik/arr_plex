# Flaresolverr

Accédez à l'interface web : `http://localhost:8191`

### FlareSolverr :
Vous pourriez vouloir ajouter FlareSolverr si vous trouvez que Prowlarr échoue à indexer certains sites à cause des blocs "Cloudflare".

Une fois le conteneur en cours d'exécution, vous devez dire à Prowlarr de l'utiliser :
- Ouvrez votre Prowlarr Web UI (`http://localhost:9696`)
- Allez à Settings > Indexers.
- Cliquez sur le + (Add) sous Indexer Proxies et sélectionnez FlareSolverr.
- Remplissez les détails :
  - Name: FlareSolverr
  - Host: `http://flaresolverr:8191` (Le nom de service `flaresolverr` fonctionne car ils sont sur le même réseau Docker `arr_plex`).
  - Request Timeout: 90 (certaines requêtes sont un peu longues parfois)
  - Tags: Donnez-lui un tag comme `cf` (ceci est important).
- Sauvegardez le proxy

Lorsque vous ajouterez des indexeurs dans Prowlarr qui auront besoin de passer par ce proxy, ajoutez-leur le tag `cf`.