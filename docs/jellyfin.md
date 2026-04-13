# Jellyfin

Accédez à l'interface web : `http://<host_ip>:8096` (ou `https://jellyfin.<votre-domaine>` via Traefik)

## Première configuration

1. Lors du premier lancement, Jellyfin vous guidera via l'assistant de configuration
2. Créez votre compte administrateur (utilisateur + mot de passe)
3. Choisissez votre langue préférée

## Ajout des bibliothèques

Allez dans `Tableau de bord` > `Bibliothèques` > `Ajouter une bibliothèque` :

| Type de contenu | Nom | Dossier |
|---|---|---|
| Films | Films | `/data/media/movies` |
| Séries | Séries TV | `/data/media/tv` |
| Musique | Musique | `/data/media/music` |

## Accélération matérielle (optionnel)

Si votre serveur dispose d'un GPU, vous pouvez activer le transcodage matériel :

1. Allez dans `Tableau de bord` > `Lecture`
2. Section `Accélération matérielle` : sélectionnez votre type de GPU (VAAPI, NVENC, QSV, etc.)
3. Cochez les formats que votre GPU supporte
4. Décommentez la ligne `devices` dans le fichier compose.yml :

```yaml
  jellyfin:
    <<: *common-keys
    container_name: jellyfin
    devices:
      - /dev/dri:/dev/dri
    volumes:
      - /etc/localtime:/etc/localtime:ro
      - /docker/appdata/jellyfin:/config
      - /data/media:/data/media:ro
    ports:
      - 127.0.0.1:8096:8096
```

## Autorisation des clients distants

Par défaut Jellyfin n'autorise que les connexions locales. Pour autoriser les connexions distantes :
1. Allez dans `Tableau de bord` > `Réseau`
2. Décochez `Activer le mode hors ligne` si activé
3. Vérifiez que les réseaux distants sont autorisés