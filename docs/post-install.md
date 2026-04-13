# Post-installation

Après avoir configuré chaque service individuellement, voici les étapes de vérification et d'optimisation.

## Vérification de la stack

### 1. Vérifier que tous les conteneurs tournent

```bash
docker compose ps
```

Tous les services doivent afficher le statut `Up`. Si un service a quitté, vérifiez les logs :

```bash
docker logs <nom_du_conteneur>
```

### 2. Vérifier les connexions entre services

Testez les connexions critiques dans l'interface de chaque service :
- **Prowlarr** > Settings > Apps : testez la connexion à Radarr, Sonarr, Lidarr
- **Radarr** > Settings > Download Clients : testez la connexion à qBittorrent
- **Sonarr** > Settings > Download Clients : testez la connexion à qBittorrent
- **Lidarr** > Settings > Download Clients : testez la connexion à qBittorrent

### 3. Vérifier les hardlinks

Suivez les instructions dans le README pour vérifier que les hardlinks fonctionnent (inode identique entre `/data/torrents/` et `/data/media/`).

## Ajout des indexeurs

1. Ouvrez Prowlarr (`http://localhost:9696`)
2. Allez dans `Indexers` > `Add Indexer`
3. Recherchez et ajoutez les indexeurs souhaités
4. Pour les indexeurs protégés par Cloudflare, ajoutez le tag `cf` (voir [Flaresolverr](flaresolverr.md))

## Configuration de base de Radarr / Sonarr

### Profils de qualité

1. Allez dans `Settings` > `Profiles`
2. Vérifiez que le profil de qualité correspond à vos attentes (ex : HD-1080p pour les films)
3. Vous pouvez créer des profils personnalisés

### Critères de recherche

Dans `Settings` > `Media Management` > `Show Advanced` :
- Assurez-vous que `Use Hardlinks instead of Copy` est coché
- Activez `Import Extra Files` avec `srt,sub,nfo` pour importer les sous-titres automatiquement

## Première demande de média

1. Allez sur Seerr (`http://localhost:5055`)
2. Cherchez un film ou une série
3. Faites une demande
4. Vérifiez que la demande apparaît dans Radarr/Sonarr
5. Vérifiez que le téléchargement démarre dans qBittorrent
6. Vérifiez que le fichier est correctement déplacé dans `/data/media/`
7. Vérifiez que Bazarr télécharge les sous-titres
8. Vérifiez que le média apparaît dans Jellyfin

## Sécurité

### Changer les mots de passe par défaut

Assurez-vous d'avoir changé les mots de passe par défaut de :
- qBittorrent (voir [docs/qbittorrent.md](qbittorrent.md))
- Prowlarr (authentication)
- Radarr, Sonarr, Lidarr (authentication)
- Jellyfin (compte admin)

## Maintenance régulière

### Mise à jour des conteneurs

```bash
docker compose pull
docker compose up -d
```

### Nettoyage des images inutilisées

```bash
docker image prune -f
```

### Sauvegarde

Voir le script de backup dans `scripts/backup.sh`.