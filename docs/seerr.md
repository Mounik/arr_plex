# Seerr

Accédez à l'interface web : `http://localhost:5055`

Seerr est le successeur d'Overseerr (et de Jellyseerr). Il est maintenu activement et gère les demandes de médias pour Jellyfin et Plex.

## Première configuration

1. Lors du premier lancement, Seerr vous guidera pour configurer :
   - **Jellyfin** : sélectionnez Jellyfin comme serveur multimédia
     - Host : `jellyfin` (nom du conteneur Docker)
     - Port : `8096`
     - Connectez-vous avec votre compte Jellyfin
   - **Radarr** :
     - Host : `radarr`
     - Port : `7878`
     - API Key : copiez-la depuis Radarr > Settings > General
   - **Sonarr** :
     - Host : `sonarr`
     - Port : `8989`
     - API Key : copiez-la depuis Sonarr > Settings > General

2. Configurez les chemins de mappage si demandé :
   - Radarr : `/data/media/movies`
   - Sonarr : `/data/media/tv`

## Migration depuis Overseerr

Si vous utilisiez précédemment Overseerr, la migration est automatique :

1. **Sauvegardez** vos données Overseerr existantes :
   ```bash
   cp -a /docker/appdata/overseerr /docker/appdata/seerr
   ```
2. Assurez-vous que le dossier appartient à l'utilisateur `node` (UID 1000) :
   ```bash
   chown -R 1000:1000 /docker/appdata/seerr
   ```
3. Lancez le conteneur Seerr - la migration se fera automatiquement au premier démarrage
4. Vérifiez les logs pour confirmer que la migration est terminée :
   ```bash
   docker logs seerr
   ```
5. Une fois confirmé, vous pouvez supprimer l'ancien conteneur Overseerr et son appdata

## Utilisation

- Les utilisateurs peuvent naviguer le catalogue et faire des demandes de films/séries
- Les demandes sont automatiquement envoyées à Radarr ou Sonarr
- Vous pouvez configurer des règles d'approbation automatique ou manuelle dans les paramètres

## Configuration des notifications (optionnel)

Allez dans `Settings` > `Notifications` pour configurer des alertes via :
- Discord
- Telegram
- Slack
- Email
- Et bien d'autres

Cela permet de recevoir une notification quand une demande est approuvée ou quand un média est disponible.

## Notes spécifiques

- Seerr tourne en tant qu'utilisateur UID 1000 par défaut (pas besoin de PUID/PGID)
- Ne pas ajouter `init: true` : l'image hotio utilise s6-overlay qui doit être PID 1. Avec `init: true`, le conteneur crashe en boucle (`s6-overlay-suexec: fatal: can only run as pid 1`)
- Le healthcheck utilise `curl -f` sur l'endpoint `/api/v1/settings/public` (requête GET). Éviter `wget --spider` : Seerr ne gère pas les requêtes HEAD
- La configuration est montée sur `/config` (et non `/app/config`, qui est un simple lien symbolique vers `/config` dans l'image)
- **Permissions du dossier** : le dossier `/docker/appdata/seerr` doit appartenir à l'utilisateur UID 1000 :
  ```bash
  sudo chown -R 1000:1000 /docker/appdata/seerr
  ```
  Si cette commande n'est pas exécutée, Seerr ne pourra pas démarrer (erreur `EACCES: permission denied`)