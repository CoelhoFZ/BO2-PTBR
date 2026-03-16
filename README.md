# Black Ops 2 — Tradução PT-BR (Plutonium T6)

<p align="center">
  <a href="https://github.com/CoelhoFZ/BO2-PTBR/releases/latest">
    <img src="https://img.shields.io/github/v/release/CoelhoFZ/BO2-PTBR?style=for-the-badge&color=brightgreen&label=%C3%9ALTIMA+VERS%C3%83O" alt="Última Versão"/>
  </a>
  <a href="https://github.com/CoelhoFZ/BO2-PTBR/stargazers">
    <img src="https://img.shields.io/github/stars/CoelhoFZ/BO2-PTBR?style=for-the-badge&color=yellow" alt="Stars"/>
  </a>
  <a href="https://discord.gg/bfFdyJ3gEj">
    <img src="https://img.shields.io/badge/DISCORD-ENTRAR-7289da?style=for-the-badge&logo=discord&logoColor=white" alt="Discord"/>
  </a>
  <a href="https://github.com/CoelhoFZ/BO2-PTBR/blob/main/LICENSE">
    <img src="https://img.shields.io/badge/licen%C3%A7a-GPLv3-blue?style=for-the-badge" alt="Licença GPLv3"/>
  </a>
</p>

> **�🇷 Tradução completa PT-BR para Call of Duty: Black Ops II no Plutonium T6!**

**Black Ops 2 PT-BR** | **BO2 tradução** | **Plutonium T6 português** | **BO2 em português** | **Black Ops 2 traduzido** | **Como traduzir BO2**

Tradução completa para Português Brasileiro do Black Ops II Zombies no [Plutonium T6](https://plutonium.pw). Traduz menus, HUD, telas de carregamento, dicas e textos do jogo — mais de **1.000 strings traduzidas**.

> ⚠️ **Aviso**: Este projeto é um mod de tradução feito por fãs. Ele modifica apenas elementos de texto/UI. Por favor, apoie os desenvolvedores comprando o jogo original.

---

## ⬇️ Download

> **Linha de comando PowerShell** *(recomendado, nada para baixar manualmente)*
> Abra o **PowerShell como Administrador** e execute:
> ```powershell
> irm https://github.com/CoelhoFZ/BO2-PTBR/releases/latest/download/install.ps1 | iex
> ```

> Se bloqueado pelo provedor/DNS, tente:
> ```powershell
> iex (curl.exe -s https://github.com/CoelhoFZ/BO2-PTBR/releases/latest/download/install.ps1 | Out-String)
> ```

👉 [Ver todos os releases e changelogs](https://github.com/CoelhoFZ/BO2-PTBR/releases)

---

## Requisitos

- Windows 10/11 (64-bit)
- Client [Plutonium T6](https://plutonium.pw) instalado
- Arquivos do jogo Call of Duty: Black Ops II (Steam ou qualquer fonte)
- Conexão com a internet (para download)

## O que o Script Faz

O instalador:
1. Solicita privilégios de Administrador se necessário
2. Encontra sua instalação do Plutonium automaticamente
3. Baixa e instala os arquivos de tradução
4. Configura o Plutonium Launcher para carregar o mod automaticamente ao iniciar Zombies
5. Oferece opção de desinstalação completa

## Menu Interativo

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

[1] Instalar Zombies
[2] Instalar Multiplayer [Em Breve]
[3] Instalar Campanha [Em Breve]
[4] Remover Tradução PT-BR
[5] Verificar Status
[0] Sair
```

## Funcionalidades

- 🎮 **1.000+ strings**: Menus, HUD, telas de carregamento, dicas, perks, armas
- 🔧 **Auto-carregamento**: Configura o Plutonium Launcher para iniciar Zombies já com PT-BR
- 📦 **Fácil de instalar**: Um único comando PowerShell, menu interativo
- 🗑️ **Remoção limpa**: Remove todos os arquivos e restaura o launcher ao estado original

## Cobertura da Tradução

### Modo Zombies
| Categoria | Status |
|-----------|--------|
| Menus & UI | ✅ Traduzido |
| Telas de carregamento | ✅ Traduzido |
| Elementos do HUD | ✅ Traduzido |
| Nomes e descrições de perks | ✅ Traduzido |
| Nomes de armas | ✅ Traduzido |
| Dicas de barreiras/portas | ✅ Traduzido |
| Power-ups | ✅ Traduzido |
| Game over / telas finais | ✅ Traduzido |

### Multiplayer
🚧 Em breve

### Campanha
🚧 Em breve

## Instalação Manual

Se preferir instalar manualmente:

1. Baixe o `textos_zm.zip` do [último release](https://github.com/CoelhoFZ/BO2-PTBR/releases/latest)
2. Extraia em `%LOCALAPPDATA%\Plutonium\storage\t6\`
3. Adicione `+set fs_game mods/zm_ptbr` nos parâmetros de lançamento do Plutonium T6 Zombies

## Solução de Problemas

| Problema | Solução |
|----------|---------|
| "Plutonium NAO ENCONTRADO" | Certifique-se que o Plutonium T6 está instalado. Execute o launcher pelo menos uma vez. |
| Tradução não carrega | Verifique se `+set fs_game mods/zm_ptbr` está nos parâmetros de lançamento |
| Alguns textos ainda em inglês | Algumas strings do engine não podem ser sobrescritas |
| Script não executa | Execute `Set-ExecutionPolicy Bypass -Scope Process` primeiro |

## Comunidade

Entre no nosso Discord: https://discord.gg/bfFdyJ3gEj

## Créditos

- **CoelhoFZ** — Tradução e desenvolvimento da ferramenta
- **Equipe Plutonium** — Client T6
- **Treyarch / Activision** — Call of Duty: Black Ops II

## Licença

GPLv3 — Veja [LICENSE](LICENSE)
