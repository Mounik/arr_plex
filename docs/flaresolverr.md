# Flaresolverr

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
- Host: http://flaresolverr:8191 (Note : Le nom de service flaresolverr fonctionne car ils sont sur le même réseau Docker).
- Request Timeout: 90 (certaines requêtes sont un peu longues parfois)
- Tags: Donnez-lui un tag comme `cf` (ceci est important).
- Sauvegardez le proxy

Lorsque vous ajouterez des indexeurs dans Prowlarr qui auront besoin de passer par ce proxy ajouter le tag `cf`