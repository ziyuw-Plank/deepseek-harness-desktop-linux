# Submit to AUR

Package name is free. Files are ready. Push is blocked until an AUR SSH key works.

## One-time setup (on Arch machine)

1. Create AUR account: https://aur.archlinux.org/register/
2. Generate a dedicated key (recommended):

```bash
ssh-keygen -t ed25519 -C "aur-ziyuw-Plank" -f ~/.ssh/id_ed25519_aur -N ""
cat ~/.ssh/id_ed25519_aur.pub
```

3. Paste the pubkey into https://aur.archlinux.org/account/ → SSH Public Key
4. Add SSH config:

```
Host aur.archlinux.org
  IdentityFile ~/.ssh/id_ed25519_aur
  IdentitiesOnly yes
```

5. Verify: `ssh -T aur@aur.archlinux.org`  → should greet your AUR username

## Push

```bash
git clone ssh://aur@aur.archlinux.org/deepseek-harness-desktop-portable.git
cd deepseek-harness-desktop-portable
cp /path/to/PKGBUILD /path/to/.SRCINFO .
git add PKGBUILD .SRCINFO
git config user.name 'ziyuw-Plank'
git config user.email '236070466+ziyuw-Plank@users.noreply.github.com'
git commit -m 'Initial import: deepseek-harness-desktop-portable 0.2.1rc3'
git push origin master
```

AUR still uses `master` as default branch.

Install once live:

```bash
yay -S deepseek-harness-desktop-portable
# or: paru -S deepseek-harness-desktop-portable
```
