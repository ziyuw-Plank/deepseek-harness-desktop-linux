# DeepSeek Harness Linux x64 desktop — status

**Latest: SUCCESS** — Release **`v0.2.1-rc.3-linux-x64.2`** (2026-10-25 Asia/Manila UTC+8)

- **Base tag:** `dsh-v0.2.1-rc.3` (`1f81c047`)
- **Branch tip:** `linux-x64-desktop` @ `26990198`
- **Repo:** https://github.com/ziyuw-Plank/deepseek-harness-desktop-linux

## v0.2.1-rc.3-linux-x64.2 (this rebuild)

| Fix | Commit / patch | Notes |
| --- | --- | --- |
| Welcome API-key save vs workspace entry | `26990198` / `0005-…` | After credentials write succeeds, `enterWorkspace` errors no longer surface as “could not save” |
| Linux prefers Add API Key CTAs | same | Bottom-left + welcome use official `addApiKey` / `welcomeApiKey` i18n (same en/zh as Windows); no invented Linux-only strings |
| Platform headers match Windows | same | `desktopPlatform` → `win32` on Linux (schema has no `linux`; was `null` → web) |
| Install prefix `/opt/deepseek-harness` | same | Linux `productName` = `deepseek-harness`; desktop Name remains “DeepSeek Harness”. Credentials/plugins stay under `~/.dsh` |
| Plugins | docs | Host tree under `resources/dsh` (read-only in packages); third-party installs via cordis/pnpm into writable `~/.dsh/profiles/desktop` |

### sha256sums

```
976053d1c9da0e5eecce46023299a409461327bd1e8f1f46921fe0124d81831c  deepseek-harness-0.2.1-rc.3-linux-amd64-unsigned.deb
080ff624833d41728c141cecc7b32f19090420bf4b0755ecfc1fbbb0c216cfb7  deepseek-harness-0.2.1-rc.3-linux-x86_64-unsigned.AppImage
```

### Verification

- Deb installs under `/opt/deepseek-harness/` (no spaces); `.desktop` Name=`DeepSeek Harness`, Exec=`/opt/deepseek-harness/deepseek-harness`.
- Packed `app.asar` `lib/main.js`: `saveApiKey` try/catch around `enterWorkspace` after successful credential write.
- Welcome renderer: Linux entry prefers official `welcomeApiKey` as primary.
- `dsh-client-ui-settings-account`: signed-out Linux menu uses official `addApiKey` → `openOnboarding('deepseek-official')`.
- `dsh-base/cordis.patch.yml`: `desktopPlatform` → `win32` on Linux (match Windows Platform headers / i18n path).
- Credentials remain in `~/.dsh/.credentials.yaml`; third-party plugins install under writable `~/.dsh/profiles/desktop` (Host tree under `resources/dsh` is read-only in packages).


### AUR

- **Target package:** `deepseek-harness-desktop-portable` (AppImage → `/opt/deepseek-harness/deepseek-harness.AppImage`)
- Draft files: `aur/deepseek-harness-desktop-portable/{PKGBUILD,.SRCINFO}` (also in publish-repo)
- Older deb draft kept at `aur/deepseek-harness-desktop-bin/` (not submitted)
- **AUR push blocked:** no SSH key registered with aur.archlinux.org on user machine or box (all tried keys: Permission denied publickey). Need AUR account + upload SSH pubkey at https://aur.archlinux.org/account/ then `git push ssh://aur@aur.archlinux.org/deepseek-harness-desktop-portable.git`

## Prior: v0.2.1-rc.3-linux-x64.1

## v0.2.1-rc.3-linux-x64.1

| Fix | Commit / patch | Notes |
| --- | --- | --- |
| Linux Wayland/X11 window drag | `373f7c26` / `0003-…webkit-app-region.patch` | `-webkit-app-region` drag/no-drag enabled for **linux** (was darwin-only) |
| Terminal Ctrl+C clean exit | `7dd70618` / `0004-…SIGINT-SIGTERM….patch` | Host exit 130/143 + SIGINT/SIGTERM → intentional shutdown; shell `quitWithoutConfirmation` on SIGINT/SIGTERM — no “unavailable” crash dialog |

### sha256sums

```
816bdc6ac2cf6c789db3f88c83362973b6bdfe9fb8b4dee6ffc56f3f6b3c724f  deepseek-harness-0.2.1-rc.3-linux-amd64-unsigned.deb
fb84616c1693b7cab26a2cba10214c5f9f232b0bd4e2457afe734a238f555b08  deepseek-harness-0.2.1-rc.3-linux-x86_64-unsigned.AppImage
```

### Verification

- Packed `app.asar` `lib/main.js`: `isIntentionalHostShutdown` (130/143/SIGINT/SIGTERM) + `process.on(SIGINT/SIGTERM → quitWithoutConfirmation)`.
- Packed CSS includes linux `-webkit-app-region` drag rules.
- Headless SIGINT smoke: no `dsh desktop host exited with 130` failure path; quit logs `Host is stopping`.

### AUR draft

`aur/deepseek-harness-desktop-bin/` — `pkgrel=2`, source URL → this Release. **Do not submit** to AUR yet.

## Prior: v0.2.1-rc.3-linux-x64

Tray + close-to-hide (`36ae2c53`), linux-x64 packaging (`5802390e`). Install footprint ~1.1 GB unpacked; downloads ~275 MB deb / ~344 MB AppImage. GLIBC target Ubuntu 20.04+ / Debian 11+.

## Rebuild

```bash
git clone https://github.com/deepseek-ai/deepseek-harness.git
cd deepseek-harness && git checkout dsh-v0.2.1-rc.3
git am /path/to/deepseek-harness-desktop-linux/patches/*.patch
cp -n apps/desktop/.env.linux.example apps/desktop/.env.linux
pnpm install --frozen-lockfile
pnpm --filter @deepseek-ai/dsh-desktop run package:linux:x64:unsigned
```


## Flatpak / Flathub (2026-10-25)

- Draft tree: `flatpak/` (app-id `io.github.ziyuw_Plank.deepseek-harness-desktop-linux`, display **DSH Desktop (Community)**)
- Strategy for local packaging: Electron BaseApp + `extra-data` AppImage from Release `.2`
- **Flathub PR: not opened** (policy: agents must not open Flathub PRs; manifests must not be AI-generated). See `flatpak/NOTICE.md` + `HUMAN-SUBMISSION-STEPS.md`
- **Acceptance risk: high reject** — third-party broad-scope agent/IDE desktop (Cursor flathub#6566 precedent), RC not stable, from-source impractical for ~1.1GB primary-runtime, trademark/naming constraints (use DSH not DeepSeek Harness)
- Recommended: keep GitHub Releases; optional self-hosted Flatpak; wait for upstream stable + official Flatpak for Flathub
- Local build (box, 2026-10-25 Asia/Manila): `flatpak-builder` **succeeded** with Electron2.BaseApp 25.08 + extra-data `.deb`; system install from local OSTree repo **succeeded** (payload under `/app/extra/deepseek-harness`). User-session BaseApp install failed on this headless box (parental-controls/DBus socket). GUI smoke not run here.
