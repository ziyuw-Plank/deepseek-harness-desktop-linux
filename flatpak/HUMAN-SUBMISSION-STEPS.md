# Human-only Flathub submission steps (ziyuw-Plank)

**Do not ask an agent to open this PR or write the PR description.**  
Policy: https://docs.flathub.org/docs/for-app-authors/requirements (Generative AI policy)  
Process: https://docs.flathub.org/docs/for-app-authors/submission

Read `FLATHUB-ASSESSMENT.md` first. Opening a PR while the app is still an RC third-party agent desktop is likely a quick reject (see Cursor flathub#6566).

## Prerequisites before you spend reviewer time

- [ ] Prefer waiting for a **stable** upstream desktop tag (not `rc.*`).
- [ ] Prefer **DeepSeek official** Flatpak ownership, or written upstream commitment to support Flatpak.
- [ ] You personally **wrote** the Flathub manifest + metainfo + desktop (do not paste agent drafts unchanged).
- [ ] Local build + `flatpak-builder-lint` clean on your machine.
- [ ] Distinct **DSH Community** name/icon (no official DeepSeek Harness trademark confusion).
- [ ] Honest PR checklist answers; disclose any AI-generated **application** material (manifests themselves must not be AI-generated).

## Author files for Flathub (human)

Create (yourself) at minimum:

1. `io.github.ziyuw_Plank.deepseek-harness-desktop-linux.yaml` (or `.json`) — top-level in the submission branch
2. Metainfo / desktop / icons as required (upstream-integrated preferred; extra-data apps may ship metadata in the Flathub repo)
3. `flathub.json` if x86_64-only: `{ "only-arches": ["x86_64"] }`
4. Dependency / generated sources if building from source

Use this repo’s `flatpak/` tree only as **research notes**, not as copy-paste for flathub/flathub.

## Open the PR (github.com UI or your own CLI)

```bash
gh repo fork --clone flathub/flathub
cd flathub
git checkout --track origin/new-pr
git checkout -b add-dsh-desktop-community new-pr
# add YOUR human-authored files
git add -A
git commit -m "Add io.github.ziyuw_Plank.deepseek-harness-desktop-linux"
git push -u origin HEAD
```

Then on GitHub: open a PR **against base branch `new-pr`** (never `master`).  
Title: `Add io.github.ziyuw_Plank.deepseek-harness-desktop-linux`

Keep the Flathub PR template intact. Answer every checkbox yourself. Do not use an agent to draft replies to reviewers.

After reviewers are happy, comment `bot, build` on the PR (you, not an agent).

## If rejected

Keep shipping GitHub Releases + AUR (`deepseek-harness-desktop-portable` when AUR registration reopens). Optional: self-hosted Flatpak from `flatpak/` local drafts.
