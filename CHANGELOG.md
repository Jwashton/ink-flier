# Changelog

## 2024-11-26
Updated docker config

Source: https://stackoverflow.com/a/40537078/1421642

> [!WARNING]
> Breaking change: Anyone who's already git cloned this project on a windows computer will need to run

```
git rm --cached -r .
git reset --hard
docker compose build
```
