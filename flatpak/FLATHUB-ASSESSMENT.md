# Flathub feasibility assessment (2026-10-25)

Sources: [Flathub Requirements](https://docs.flathub.org/docs/for-app-authors/requirements), [Submission](https://docs.flathub.org/docs/for-app-authors/submission), [Electron Flatpak guide](https://docs.flatpak.org/en/latest/electron.html), Cursor third-party PR [flathub/flathub#6566](https://github.com/flathub/flathub/pull/6566) (closed, not merged), DeepSeek Harness [BRAND_GUIDELINES.md](https://github.com/deepseek-ai/deepseek-harness/blob/main/BRAND_GUIDELINES.md).

## Verdict

**Flathub acceptance is unlikely in this phase.** Shipping via GitHub Releases (AppImage/deb) remains the reliable path. A local/self-hosted Flatpak (or single-file `.flatpak`) can still be useful for users who prefer Flatpak outside Flathub.

## Blocking / high-risk policy hits

| Risk | Policy cite | Why it applies |
| --- | --- | --- |
| Broad-scope IDE / agent desktop | “Submissions incompatible or restricted by Flatpak sandbox” — third-party IDEs/dev tools rejected unless upstream officially submits or commits to Flatpak | DSH Desktop is an Electron agent host with plugins, project FS access, and Host tooling — same class as Cursor. Cursor third-party Flatpak was rejected citing this rule. |
| Not upstream-official | Same + “Conflicting submissions” / trust | We are community packaging of `deepseek-ai/deepseek-harness`; DeepSeek has not published Linux desktop or committed to Flatpak. |
| Build entirely from source + no network at build | “Building from source”, “No network access during build” | App ≈1.1 GB unpacked: Electron + `resources/dsh` + primary-runtime (Node/Python). Offline from-source rebuild of the monorepo + primary-runtime inside flatpak-builder is not practical today. |
| extra-data binaries | Allowed for non-redistributable; vendor exceptions case-by-case | MIT upstream is redistributable → Flathub expects from-source. VS Code / Discord style `extra-data` works because they are well-known vendors / official. Third-party community AppImage/`extra-data` is unlikely to get an exception. |
| Stable channel only | “Stable releases” | Current ship is `dsh-v0.2.1-rc.3` (release candidate). Stable Flathub rejects RC/nightly as the first submission. |
| Trademark / naming | “No trademark violations”; DeepSeek brand guidelines | Project names should avoid full “DeepSeek Harness”; prefer **DSH**. Official icons/artwork must not imply official endorsement. Draft uses community name + distinct SVG. |
| Insufficient development history | “Insufficient development history” | Packaging repo is new; reviewers may ask to wait for upstream Linux or longer history. |
| Generative AI policy | Manifests must not be AI-generated; agents must not open Flathub PRs | Any agent-written YAML cannot be copied into flathub/flathub. Human must author Flathub files and open the PR. |

## Strategy options (ranked)

### A — Recommended now: do not open Flathub PR

Keep GitHub Release AppImage/deb (+ AUR when registration reopens). Optionally publish a **self-hosted** Flatpak repo or `.flatpak` bundle from this tree for Flatpak users without Flathub review.

### B — Local / self-hosted Flatpak via `extra-data` (practical packaging)

Use `org.electronjs.Electron2.BaseApp` + download our Release AppImage/deb as `extra-data`, wrap with `zypak-wrapper`. Good for local testing and optional self-host. **Not** Flathub-aligned for a third-party MIT app (from-source expected).

Draft files in this directory follow strategy B for local experiments.

### C — Flathub-preferred from-source (long path)

Rebuild with Freedesktop Platform + Electron BaseApp + Node SDK extension, `flatpak-node-generator` / pnpm offline sources for the whole monorepo, and a from-source primary-runtime. Months of work; still blocked by the IDE/third-party rule unless DeepSeek co-maintains.

### D — Ask DeepSeek upstream to own Flatpak

Best long-term Flathub path: official `deepseek-ai` submission after a stable Linux desktop release.

## Chosen app-id

`io.github.ziyuw_Plank.deepseek-harness-desktop-linux`

- GitHub: `https://github.com/ziyuw-Plank/deepseek-harness-desktop-linux`
- Username `ziyuw-Plank` → component `ziyuw_Plank` (hyphen → underscore)
- Last component keeps hyphens (allowed only in final component) and matches the repo name as-is per Flathub code-hosting rules

## Suggested Flathub-facing name (if ever submitted)

**DSH Desktop (Community)** — not “DeepSeek Harness”, per upstream brand guidelines.

## Sandbox notes (if packaging)

Minimum useful `finish-args` (still broad for an agent desktop):

- `--share=network` (API)
- `--share=ipc`
- `--socket=x11` (Electron default; Wayland still experimental per Flatpak Electron docs)
- `--device=dri`
- `--filesystem=home` or at least `xdg-config/dsh:create`, home `.dsh`, plus project directories — portals alone are usually insufficient for Host/plugins

Broad host filesystem is exactly why Flathub dislikes third-party IDEs.
