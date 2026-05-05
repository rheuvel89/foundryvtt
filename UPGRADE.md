# FoundryVTT Docker Upgrade Runbook

## Overview

This runbook describes how to upgrade FoundryVTT running in Docker while preserving all user data. The application binaries are stored in a shared volume (`/usr/share/foundryvtt`) separate from each user's data volumes, so upgrading only touches the app files.

---

## Volume layout

| Host path | Container path | Contents |
|---|---|---|
| `/usr/share/foundryvtt` | `/app/foundryvtt` | App binaries (replaced during upgrade) |
| `/usr/share/foundryshare` | `/app/foundryshare` | Shared assets (never touched) |
| `/usr/share/foundrydata_lex` | `/app/foundrydata` | Lex's worlds & data (never touched) |
| `/usr/share/foundrydata_douwe` | `/app/foundrydata` | Douwe's worlds & data (never touched) |
| `/usr/share/foundrydata_gudo` | `/app/foundrydata` | Gudo's worlds & data (never touched) |
| `/usr/share/foundrydata_extra1` | `/app/foundrydata` | Extra1's worlds & data (never touched) |
| `/usr/share/foundrydata_extra2` | `/app/foundrydata` | Extra2's worlds & data (never touched) |

---

## Pre-upgrade: backup data

> ⚠️ **Always back up before a major version upgrade** (e.g. v11 → v12). Foundry may migrate world data on first launch, which is a one-way operation.

```bash
sudo tar -czf foundrydata_backup_$(date +%Y%m%d).tar.gz \
  /usr/share/foundrydata_lex \
  /usr/share/foundrydata_douwe \
  /usr/share/foundrydata_gudo \
  /usr/share/foundrydata_extra1 \
  /usr/share/foundrydata_extra2
```

Verify the archive was created:

```bash
ls -lh foundrydata_backup_*.tar.gz
```

---

## Upgrade steps

### 1. Get a new timed download URL

Log in to [https://foundryvtt.com](https://foundryvtt.com), navigate to your licenses, and generate a new timed download URL for the target version. Pick Linux as the operating system.

### 2. Update the `.env` file

```bash
nano .env
# Update:
# TIMED_URL=<your-new-timed-download-url>
```

### 3. Stop all containers

```bash
docker compose --env-file default.env down
```

### 4. Wipe the old app binaries

This removes the app files and the `done` sentinel so the entrypoint re-downloads and re-unzips on next start. **Do not touch the `foundrydata_*` directories.**

```bash
sudo rm -rf /usr/share/foundryvtt/*
```

### 5. Start the containers

```bash
docker compose --env-file default.env up -d
```

On startup, each container will:
1. Download the new `foundryvtt.zip` from the timed URL
2. Unzip it into `/usr/share/foundryvtt` (shared by all instances)
3. Start Foundry pointing at the existing user data volume

### 6. Verify

```bash
# Check containers are running
docker compose ps

# Tail logs of one instance to confirm the new version started cleanly
docker compose logs -f foundryvtt_lex
```

Look for the Foundry version number in the startup log output to confirm the upgrade succeeded.

---

## Restore from backup

Use this procedure if a data migration goes wrong or you need to roll back user data.

### 1. Stop all containers

```bash
docker compose --env-file default.env down
```

### 2. Wipe current data volumes

> ⚠️ This permanently deletes current data. Only do this if you intend to fully restore from the backup.

```bash
sudo rm -rf \
  /usr/share/foundrydata_lex \
  /usr/share/foundrydata_douwe \
  /usr/share/foundrydata_gudo \
  /usr/share/foundrydata_extra1 \
  /usr/share/foundrydata_extra2
```

### 3. Restore from the backup archive

```bash
sudo tar -xzf foundrydata_backup_<YYYYMMDD>.tar.gz -C /
```

The `-C /` flag restores files to their original absolute paths.

### 4. Verify the restore

```bash
ls /usr/share/foundrydata_lex/Data/
ls /usr/share/foundrydata_douwe/Data/
# etc.
```

### 5. Optionally roll back the app version

If you also need to downgrade the app binaries, wipe the app dir and update `TIMED_URL` to a previous version's download link before restarting:

```bash
sudo rm -rf /usr/share/foundryvtt/*
# Update TIMED_URL in .env to the old version's link
nano .env
```

### 6. Start the containers

```bash
docker compose --env-file default.env up -d
```

---

## Notes

- The `foundryvtt.zip` download path (`/app/foundryvtt.zip`) is **not** volume-mapped, so the zip always re-downloads fresh on container start.
- All five Foundry instances share the same app binaries via `/usr/share/foundryvtt`. Wiping it once upgrades all instances simultaneously.
- The `shared` symlink (`/app/foundrydata/Data/shared → /app/foundryshare`) is recreated automatically by the entrypoint on each start.
