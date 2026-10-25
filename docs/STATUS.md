# DeepSeek Harness Linux x64 desktop — status

**Latest: SUCCESS** — Release **`v0.2.1-rc.3-linux-x64.1`** (2026-10-25 Asia/Manila UTC+8)

- **Base tag:** `dsh-v0.2.1-rc.3` (`1f81c047`)
- **Branch tip:** `linux-x64-desktop` @ `7dd70618`
- **Repo:** https://github.com/ziyuw-Plank/deepseek-harness-desktop-linux

## v0.2.1-rc.3-linux-x64.1 (this rebuild)

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
