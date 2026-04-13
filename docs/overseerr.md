# Overseerr

Accédez à l'interface web : `http://<host_ip>:5055` (ou `https://overseerr.<votre-domaine>` via Traefik)

## Première configuration

1. Lors du premier lancement, Overseerr vous guidera pour configurer :
   - **Jellyfin** : sélectionnez Jellyfin (pas Plex) comme serveur multimédia
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