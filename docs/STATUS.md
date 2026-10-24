# DeepSeek Harness Linux x64 desktop — Phase 2 status

**Result: SUCCESS** (`.deb` + AppImage + tray/close-to-hide smoke)

- **When:** 2026-10-24 ~13:17–13:27 Asia/Manila (UTC+8)
- **Base tag:** `dsh-v0.2.1-rc.3` (`1f81c047`)
- **Local branch:** `linux-x64-desktop` @ `36ae2c53` (tray on top of `5802390e` packaging)
- **Work root:** `/workspace/deepseek-harness-linux/`

## Size answer (1.1 GB unpacked — is it too large?)

**Unpacked on disk is large; the installable downloads are much smaller.** This is normal for an Electron + full primary-runtime (Node + pnpm + CPython/office) isomorphic desktop — same shape as macOS/Windows releases. Do **not** switch to Tauri or strip `primary-runtime` / `dsh` to “fix” size; those are required for feature parity and sharp/Host stability.

| Form | Size | Notes |
| --- | --- | --- |
| **linux-unpacked** (install footprint) | **~1.1 GB** (1 096 334 532 bytes) | What lands under `/opt/DeepSeek Harness/` after `.deb` install |
| **`.deb` (download)** | **~275 MB** (288 092 872 bytes) | `deepseek-harness-0.2.1-rc.3-linux-amd64-unsigned.deb` |
| **AppImage (download)** | **~344 MB** (360 172 014 bytes) | `deepseek-harness-0.2.1-rc.3-linux-x86_64-unsigned.AppImage` |

Unpacked breakdown (approx):

| Component | ~Size | Role |
| --- | --- | --- |
| `deepseek-harness` (Electron) | 219 MB | Shell binary |
| `resources/dsh` | 428 MB | Host + plugins (`node_modules` ~425 MB) |
| `resources/runtime/primary-runtime` | 403 MB | Node ~121 MB, Python ~259 MB, pnpm ~24 MB |
| `app.asar` + chrome bits + locales | remainder | UI + Chromium assets |
| `LICENSES.chromium.html` | ~20 MB | Chromium license dump |

**GLIBC floor:** Electron binary needs **≤2.25**; bundled Node needs **≤2.28** → target **Ubuntu 20.04+ / Debian 11+**-class glibc (this box and modern Arch OK).

### Safe size reductions (no feature drop; not applied yet)

These shrink download and/or disk **without** removing primary-runtime, dsh, sharp, office, or switching frameworks:

1. **electron-builder `compression: "maximum"`** on linux/deb/AppImage — currently default (`normal`). Expect smaller `.deb`/AppImage; rebuild cost ↑; no runtime feature loss.
2. **`strip --strip-unneeded` on bundled Node** — Electron binary already stripped; Node `126 MB → ~108 MB` (~18 MB) in a local test copy. AUR source package uses `options=('!strip')`; a post-pack strip of `…/node/bin/node` only is the conservative win.
3. **Exclude docs/noise from pack** (afterPack / files filter):  
   - `LICENSES.chromium.html` ~20 MB (keep a stub or omit from linux pack if policy allows)  
   - `*.md` / README under `resources/` ~13–18 MB  
   - Python `include/` (~1.8 MB) + `share/man`+terminfo (~12 MB) if no compile-from-source need at runtime  
4. **No `*.map` source maps** found in current tree — nothing to strip there.

**Out of scope / rejected:** Tauri rewrite; deleting primary-runtime or dsh; dropping CPython/office skills; sharp-electron instead of standalone Node.

## Phase 2 deliverables

### 1. Installable artifacts

| Item | Path |
| --- | --- |
| `.deb` | `/workspace/deepseek-harness-linux/artifacts/deepseek-harness-0.2.1-rc.3-linux-amd64-unsigned.deb` |
| AppImage | `/workspace/deepseek-harness-linux/artifacts/deepseek-harness-0.2.1-rc.3-linux-x86_64-unsigned.AppImage` |
| sha256sums | `/workspace/deepseek-harness-linux/artifacts/sha256sums.txt` |
| Unpacked (symlink) | `/workspace/deepseek-harness-linux/artifacts/linux-unpacked` → build tree |
| Build log | `/workspace/deepseek-harness-linux/logs-package-unsigned.txt` |

```
cca4948643a4d35e0f554b27958baaefe4c64e446475431e58ab55dd907748b8  deepseek-harness-0.2.1-rc.3-linux-amd64-unsigned.deb
dba9e4342dd44875c6508306a73e563ec5975055f5d1fb45d3d42b22ac6a23e2  deepseek-harness-0.2.1-rc.3-linux-x86_64-unsigned.AppImage
```

`.deb` layout: `/opt/DeepSeek Harness/`, `/usr/share/applications/deepseek-harness.desktop`, hicolor icons. No `/usr/bin` symlink in the `.deb` itself (AUR draft adds `deepseek-harness-desktop`).

### 2. Tray + close-to-hide

- Commit `36ae2c53` — Linux tray via `resources/icon.png`; window close hides when tray exists; `window-all-closed` keeps process alive with tray.
- Smoke (xvfb + `dbus-run-session`, Asia/Manila ~13:26):
  - Host: `…/primary-runtime/…/node …/dsh-desktop-host/lib/index.js`
  - `dsh web: http://127.0.0.1:37465/?token=…`
  - `xdotool windowclose` on all app windows → **main + Host stayed alive** (`CLOSE_TO_HIDE_OK`)
  - Tray icon windows present (16×16); no tray-related crashes in stderr (login1 Inhibit noise expected)

Logs: `artifacts/smoke2-stdout.txt`, `artifacts/smoke2-stderr.txt`

### 3. AUR draft (do **not** submit)

`/workspace/deepseek-harness-linux/aur/deepseek-harness-desktop-bin/`

- `PKGBUILD` + `.SRCINFO` + README
- `provides=('deepseek-harness-desktop')`
- `conflicts=('deepseek-harness-desktop' 'dsh-tauri-desktop-bin')`
- Source URL still **PLACEHOLDER** (`OWNER/REPO`); sha256 of local `.deb` already filled
- Installs from prebuilt `.deb` via `bsdtar` on `data.tar.*`

## Phase 1 carry-forward (still true)

- Sharp strategy: Host under standalone primary-runtime Node (not Electron-as-Node).
- Packaging transplant from kgpche onto rc.3; AUR sharp-electron approach not used.
- Not pushed to GitHub; no AUR submit; no community auto-update feed.

## Remaining gaps

1. Publish release URLs + refresh AUR `source=` (needs credentials — user deferred).
2. Optional: apply safe compress/strip/doc exclusions above and rebuild.
3. Community auto-update for unsigned linux — deferred.
4. `dsh://` open-url still mac-leaning; account platform header may label Linux as darwin (cosmetic).

## Key commands

```bash
source /workspace/deepseek-harness-linux/env.sh
cd /workspace/deepseek-harness-linux/upstream
cp -n apps/desktop/.env.linux.example apps/desktop/.env.linux
export NODE_DISABLE_COMPILE_CACHE=1
pnpm --filter @deepseek-ai/dsh-desktop run package:linux:x64:unsigned

# Smoke with tray session bus
APP=/workspace/deepseek-harness-linux/artifacts/linux-unpacked
dbus-run-session -- xvfb-run -a "$APP/deepseek-harness" --no-sandbox
```

## Success criteria checklist

- [x] Phase 1: linux-unpacked + Host smoke
- [x] Tray + close-without-quit (min)
- [x] `.deb` + AppImage under `artifacts/`
- [x] sha256 recorded
- [x] AUR draft with provides/conflicts + placeholder URL
- [x] STATUS size narrative (compressed vs unpacked + safe reductions)
- [ ] AUR submit / GitHub push — explicitly deferred
- [ ] Auto-update feed — deferred
