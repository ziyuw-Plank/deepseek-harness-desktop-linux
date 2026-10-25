# Flatpak packaging (community)

App ID: **`io.github.ziyuw_Plank.deepseek-harness-desktop-linux`**  
Display name: **DSH Desktop (Community)**

## Read first

1. `NOTICE.md` — Flathub Generative AI policy (no agent-authored Flathub manifests/PRs)
2. `FLATHUB-ASSESSMENT.md` — why Flathub is unlikely to accept this now
3. `HUMAN-SUBMISSION-STEPS.md` — if a human still wants to try Flathub later

## What this tree is

**Local / self-hosted Flatpak draft** using Electron BaseApp + `extra-data` unsigned `.deb` from our GitHub Release (`v0.2.1-rc.3-linux-x64.2`).

It is **not** a green light to open a Flathub PR.

## Local build (when flatpak-builder is available)

```bash
cd flatpak
flatpak remote-add --if-not-exists --user flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak install -y --user flathub \
  org.freedesktop.Platform//25.08 \
  org.freedesktop.Sdk//25.08 \
  org.electronjs.Electron2.BaseApp//25.08

flatpak-builder --user --force-clean --repo=repo build-dir \
  io.github.ziyuw_Plank.deepseek-harness-desktop-linux.yaml

# extra-data apps: install from the OSTree repo after build
flatpak --user remote-add --no-gpg-verify dsh-local repo
flatpak install -y --user dsh-local io.github.ziyuw_Plank.deepseek-harness-desktop-linux
flatpak run io.github.ziyuw_Plank.deepseek-harness-desktop-linux
```

Or bundle:

```bash
flatpak build-bundle repo DSH-Desktop-Community.flatpak \
  io.github.ziyuw_Plank.deepseek-harness-desktop-linux
```

## Files

| Path | Role |
| --- | --- |
| `io.github.ziyuw_Plank.deepseek-harness-desktop-linux.yaml` | Draft manifest (extra-data `.deb`) |
| `*.desktop` / `*.metainfo.xml` | Desktop + AppStream draft |
| `icons/*.svg` | Distinct community mark (not official DeepSeek art) |
| `scripts/run.sh` / `apply_extra.sh` | zypak launch + deb extract (`ar`/`tar`) |
| `flathub.json` | x86_64-only hint |

## Branding

Per upstream brand guidelines: avoid “DeepSeek Harness” as the product name; use **DSH** for community naming. Do not imply official affiliation.
