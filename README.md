## dot(files)

All my dotfiles managed with [GNU stow](https://www.gnu.org/software/stow/manual/stow.html).

Use `stow package_name` to activate a package's symlink. 

- **OS**: Arch Linux
- **Editor**: neovim
- **Shell**: bash
- **Terminal**: alacritty
- **WM**: i3

Create package list:
```
pacman -Qqe > pkglist.txt
```

Install from package list:
```
pacman -S --needed - < pkglist.txt
```
