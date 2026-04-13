# Traefik

Traefik agit comme reverse proxy pour toute la stack ARR. Il gère automatiquement les certificats SSL via Let's Encrypt.

## URLs d'accès

Une fois configuré, chaque service est accessible via son sous-domaine :

| Service | URL |
|---|---|
| Traefik Dashboard | `https://traefik.<votre-domaine>` |
| Jellyfin | `https://jellyfin.<votre-domaine>` |
| Radarr | `https://radarr.<votre-domaine>` |
| Sonarr | `https://sonarr.<votre-domaine>` |
| Lidarr | `https://lidarr.<votre-domaine>` |
| Bazarr | `https://bazarr.<votre-domaine>` |
| Prowlarr | `https://prowlarr.<votre-domaine>` |
| qBittorrent | `https://qbittorrent.<votre-domaine>` |
| Overseerr | `https://overseerr.<votre-domaine>` |

## Prérequis DNS

Pour que Let's Encrypt fonctionne, vous devez :

1. Posséder un nom de domaine
2. Créer des enregistrements DNS (A ou CNAME) pointant vers l'IP de votre serveur pour chaque sous-domaine :
   - `*.votre-domaine` (wildcard) ou individuellement `radarr.votre-domaine`, `sonarr.votre-domaine`, etc.
3. Attendre la propagation DNS (quelques minutes à quelques heures)

## Variables d'environnement requises

Créez un fichier `.env` à la racine du projet :

```env
DOMAIN=votre-domaine.com
ACME_EMAIL=votre@email.com
```

## Dashboard Traefik

Le dashboard est accessible à `https://traefik.<votre-domaine>`. Il permet de :
- Voir tous les routeurs, services et middlewares configurés
- Vérifier l'état des certificats
- Diagnostiquer les problèmes de routage

## Dépannage

### Certificat non émis

Vérifiez que :
- Le port 80 est accessible depuis Internet (nécessaire pour le challenge TLS)
- Les enregistrements DNS pointent bien vers votre serveur
- Les logs Traefik : `docker logs traefik`

### Service inaccessible via le domaine

1. Vérifiez que le conteneur est sur le réseau `traefik`
2. Vérifiez les labels du conteneur : `docker inspect <conteneur> | grep -A 20 Labels`
3. Vérifiez le dashboard Traefik pour voir si le routeur existe

### Contourner Traefik (accès local uniquement)

Si vous n'avez pas de domaine, vous pouvez supprimer le service Traefik et changer les ports de `127.0.0.1:port:port` vers `port:port` pour accéder directement aux services via `http://<ip>:<port>`.