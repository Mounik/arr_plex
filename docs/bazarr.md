# Bazarr

```bash
http://<host_ip>:6767
```

Langues : Allez à `Settings` > `Languages`.

Dans le filtre `Languages Filter` taper `French` ou `English` ou les 2, ou n'importe quel autres langue qui vous convienne. Enregistrer, ensuite dans `Source` cliquer sur `Add Equal`. Enregistrer

Dans `Languages Profile` - `Add New Profile`.
Créer un prfil par langages que vous aurez choisi.

N'oubliez pas d'enregistrer.

Fournisseurs : Allez à `Settings` > `Providers` et ajoutez vos sources de sous-titres avec `Enable Providers` - `+` (OpenSubtitles.org, Subscene, etc.). La plupart nécessitent un compte gratuit.  

Synchronisation : Après avoir connecté Radarr/Sonarr, allez à l'onglet Series ou Movies et cliquez sur `Update` pour importer votre bibliothèque existante.  

Note : Bazarr utilise le chemin `/data/media` au lieu de `/data` pour l'accès aux médias, comme configuré dans le fichier compose.  