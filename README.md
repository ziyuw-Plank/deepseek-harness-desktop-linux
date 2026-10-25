# DeepSeek Harness Desktop — Linux x64 (community)

Unofficial **Linux x64** builds of the official Electron desktop from [`deepseek-ai/deepseek-harness`](https://github.com/deepseek-ai/deepseek-harness) (`apps/desktop`).

> Not affiliated with DeepSeek. Builds are **unsigned**. Upstream still does not ship Linux desktop releases.

## Try it (recommended)

Download the latest **Release** assets (do not use GitHub’s auto “Source code” zip as the app):

| File | Notes |
| --- | --- |
| `*-linux-amd64-unsigned.deb` | Debian/Ubuntu/Arch (`dpkg` / `debtap` / extract) |
| `*-linux-x86_64-unsigned.AppImage` | Portable; `chmod +x` then run. No FUSE? `./….AppImage --appimage-extract-and-run` |

Current target: **`dsh-v0.2.1-rc.3`**. Latest packaging Release: **[`v0.2.1-rc.3-linux-x64.2`](https://github.com/ziyuw-Plank/deepseek-harness-desktop-linux/releases/tag/v0.2.1-rc.3-linux-x64.2)** (API-key UX, `/opt/deepseek-harness`, Win-matched Platform i18n).

Download size is ~275 MB (deb) / ~344 MB (AppImage). Installed footprint is ~1.1 GB (Electron + bundled dsh + primary-runtime Node) — same shape as official Win/mac.

### Quick AppImage

```bash
chmod +x deepseek-harness-*-linux-x86_64-unsigned.AppImage
./deepseek-harness-*-linux-x86_64-unsigned.AppImage
# if needed:
./deepseek-harness-*-linux-x86_64-unsigned.AppImage --appimage-extract-and-run
```

### Quick deb (Debian/Ubuntu)

```bash
sudo apt install ./deepseek-harness-*-linux-amd64-unsigned.deb
```

> **Upgrade from .1:** install path moved from `/opt/DeepSeek Harness` to `/opt/deepseek-harness`. Remove the old package first if the deb upgrade leaves both trees. User data stays in `~/.dsh` (credentials + plugins).


## What’s in this repo

- `patches/` — commits on top of official tag `dsh-v0.2.1-rc.3` (linux-x64 packaging, tray/close-to-hide, Linux window drag, terminal SIGINT/SIGTERM clean exit, API-key UX + `/opt/deepseek-harness` + Win Platform i18n)
- `aur/deepseek-harness-desktop-bin/` — draft AUR `-bin` package (not submitted yet)
- `aur/deepseek-harness-desktop-portable/` — AppImage AUR draft (blocked on AUR registration)
- `flatpak/` — local/self-host Flatpak **draft** + Flathub risk notes (**no Flathub PR opened**; see `flatpak/FLATHUB-ASSESSMENT.md`)
- `docs/STATUS.md` — build/smoke notes from the packager machine

## Rebuild from source

Needs Linux **x86_64**, Node `^22.19 || >=24`, lots of disk/network.

```bash
git clone https://github.com/deepseek-ai/deepseek-harness.git
cd deepseek-harness
git checkout dsh-v0.2.1-rc.3
git am /path/to/this-repo/patches/*.patch
# copy apps/desktop/.env.linux.example → .env.linux
pnpm install --frozen-lockfile
pnpm --filter @deepseek-ai/dsh-desktop run package:linux:x64:unsigned
```

## License

Upstream DeepSeek Harness is MIT. This packaging layer is provided under the same terms for the patch/scripts here; bundled third-party notices ship inside the app.
