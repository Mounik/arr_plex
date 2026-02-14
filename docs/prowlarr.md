# Prowlarr

Maintenant configurez le service Prowlarr (chacun de ces services nécessitera de configurer utilisateur/mot de passe)  
Utilisez `Form (login page) authentication` et définissez votre utilisateur et mot de passe pour tous.

```bash
http://<host_ip>:9696
```

Allez à `Settings - Download Clients` - symbole `+` - Add download client - choisissez `qBittorrent` (sauf si vous avez décidé d'utiliser un client de téléchargement différent)

Décochez `Use SSL` (sauf si vous avez SSL configuré dans `qBittorrent - Tools - Options -WebUI` mais par défaut il n'est pas utilisé)

Host - utilisez `qbittorrent` et port - mettez l'id de port correspondant au WebUI dans docker-compose pour qBittorrent (par défaut `8080`).

nom d'utilisateur et mot de passe - utilisez celui que vous avez configuré pour qBittorrent à l'étape précédente.

Cliquez sur le petit bouton `Test` en bas, assurez-vous d'obtenir un `tick` vert puis `Save`.
