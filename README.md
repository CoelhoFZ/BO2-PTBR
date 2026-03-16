# Black Ops 2 — PT-BR Translation (Plutonium T6)

<p align="center">
  <a href="https://github.com/CoelhoFZ/BO2-PTBR/releases/latest">
    <img src="https://img.shields.io/github/v/release/CoelhoFZ/BO2-PTBR?style=for-the-badge&color=brightgreen&label=LATEST+VERSION" alt="Latest Version"/>
  </a>
  <a href="https://github.com/CoelhoFZ/BO2-PTBR/stargazers">
    <img src="https://img.shields.io/github/stars/CoelhoFZ/BO2-PTBR?style=for-the-badge&color=yellow" alt="Stars"/>
  </a>
  <a href="https://discord.gg/bfFdyJ3gEj">
    <img src="https://img.shields.io/badge/DISCORD-JOIN-7289da?style=for-the-badge&logo=discord&logoColor=white" alt="Discord"/>
  </a>
  <a href="README_PT-BR.md">
    <img src="https://img.shields.io/badge/lang-PT--BR-009c3b?style=for-the-badge" alt="Português"/>
  </a>
</p>

> **🌍 Complete PT-BR translation for Call of Duty: Black Ops II on Plutonium T6!**

**Black Ops 2 PT-BR** | **BO2 translation** | **Plutonium T6 Portuguese** | **BO2 tradução** | **Black Ops 2 português**

Full Brazilian Portuguese translation for Black Ops II Zombies on [Plutonium T6](https://plutonium.pw). Translates menus, HUD, loading screens, hints, and in-game text — over **1,000 translated strings**.

> ⚠️ **Disclaimer**: This project is a fan-made translation mod. It only modifies text/UI elements. Please support the developers by purchasing the original game.

---

## ⬇️ Download

> **PowerShell one-liner** *(recommended, nothing to download manually)*
> Open **PowerShell as Administrator** and run:
> ```powershell
> irm https://github.com/CoelhoFZ/BO2-PTBR/releases/latest/download/install.ps1 | iex
> ```

> If blocked by your network/DNS, try:
> ```powershell
> iex (curl.exe -s https://github.com/CoelhoFZ/BO2-PTBR/releases/latest/download/install.ps1 | Out-String)
> ```

👉 [View all releases and changelogs](https://github.com/CoelhoFZ/BO2-PTBR/releases)

---

## Requirements

- Windows 10/11 (64-bit)
- [Plutonium T6](https://plutonium.pw) client installed
- Call of Duty: Black Ops II game files (Steam or any source)
- Internet connection (for download)

## What It Does

The installer:
1. Detects your language automatically (PT-BR, EN, ES)
2. Requests Administrator privileges if needed
3. Finds your Plutonium installation
4. Downloads and installs translation files
5. Configures the Plutonium Launcher for auto-load
6. Provides easy uninstall

## Interactive Menu

```
  ============================================================
   _____              _       _
  |_   _| __ __ _  __| |_   _| |_ ___  _ __
    | || '__/ _' |/ _' | | | | __/ _ \| '__|
    | || | | (_| | (_| | |_| | || (_) | |
    |_||_|  \__,_|\__,_|\__,_|\__\___/|_|
   ____  _            _        ___              ____
  | __ )| | __ _  ___| | __   / _ \ _ __  ___  |___ \
  |  _ \| |/ _' |/ __| |/ /  | | | | '_ \/ __|   __) |
  | |_) | | (_| | (__|   <   | |_| | |_) \__ \  / __/
  |____/|_|\__,_|\___|_|\_\   \___/| .__/|___/ |_____|
                                    |_|
                  PT-BR by CoelhoFZ (Plutonium)
  ============================================================

[1] Install Zombies
[2] Install Multiplayer [Coming Soon]
[3] Install Campaign [Coming Soon]
[4] Uninstall
[5] Check Status
[0] Exit
```

## Features

- 🌍 **Multi-language**: Auto-detects EN, PT-BR, ES
- 🎮 **1,000+ strings**: Menus, HUD, loading screens, hints, perks, weapons
- 🔧 **Auto-load**: Configures Plutonium Launcher automatically
- 📦 **Easy install**: One PowerShell command, interactive menus
- 🗑️ **Clean uninstall**: Removes all files and restores launcher
- 🔄 **Reinstall support**: Detects existing installation

## Translation Coverage

### Zombies Mode
| Category | Status |
|----------|--------|
| Menus & UI | ✅ Translated |
| Loading screens | ✅ Translated |
| HUD elements | ✅ Translated |
| Perk names & descriptions | ✅ Translated |
| Weapon names | ✅ Translated |
| Barrier/door hints | ✅ Translated |
| Power-ups | ✅ Translated |
| Game over / end screens | ✅ Translated |

### Multiplayer
🚧 Coming soon

### Campaign
🚧 Coming soon

## Manual Installation

If you prefer to install manually:

1. Download `textos_zm.zip` from the [latest release](https://github.com/CoelhoFZ/BO2-PTBR/releases/latest)
2. Extract to `%LOCALAPPDATA%\Plutonium\storage\t6\`
3. Add `+set fs_game mods/zm_ptbr` to your Plutonium T6 Zombies launch parameters

## Troubleshooting

| Problem | Solution |
|---------|----------|
| "Plutonium NOT FOUND" | Make sure Plutonium T6 is installed. Run the launcher at least once. |
| Translation not loading | Check if `+set fs_game mods/zm_ptbr` is in your launch params |
| Some text still in English | A few engine-level strings cannot be overridden |
| Script won't run | Run `Set-ExecutionPolicy Bypass -Scope Process` first |

## Community

Join our Discord: https://discord.gg/bfFdyJ3gEj

## Credits

- **CoelhoFZ** — Translation & tool development
- **Plutonium Team** — T6 client
- **Treyarch / Activision** — Call of Duty: Black Ops II

## License

GPLv3 — See [LICENSE](LICENSE)
