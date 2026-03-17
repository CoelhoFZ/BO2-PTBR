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

> **🌍 Tradução completa PT-BR para Call of Duty: Black Ops II no Plutonium T6!**

**Black Ops 2 PT-BR** | **BO2 tradução** | **Plutonium T6 português** | **BO2 em português** | **Black Ops 2 traduzido** | **Como traduzir BO2**

Tradução completa para Português Brasileiro do Black Ops II Zombies no [Plutonium T6](https://plutonium.pw). Traduz menus, HUD, telas de carregamento, dicas e textos do jogo — mais de **2.300 strings traduzidas**.

> ⚠️ **Aviso**: Este projeto é um mod de tradução feito por fãs. Ele modifica apenas elementos de texto/UI. Por favor, apoie os desenvolvedores comprando o jogo original.

---

## ⬇️ Download

> **Linha de comando PowerShell** *(recomendado, nada para baixar manualmente)*
> Abra o **PowerShell como Administrador** e execute:
> ```powershell
> iex (curl.exe -fsSL "https://github.com/CoelhoFZ/BO2-PTBR/releases/latest/download/install.ps1?ts=$((Get-Date).Ticks)" | Out-String)
> ```

> Se preferir usar `irm`, use esta versao reforcada:
> ```powershell
> powershell -NoProfile -ExecutionPolicy Bypass -Command "[Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12; irm https://github.com/CoelhoFZ/BO2-PTBR/releases/latest/download/install.ps1 | iex"
> ```

> Se bloqueado pelo provedor/DNS, tente:
> ```powershell
> iex (curl.exe -s https://github.com/CoelhoFZ/BO2-PTBR/releases/latest/download/install.ps1 | Out-String)
> ```

> Se sua rede oscila, rode novamente (o instalador agora faz tentativas automaticas de download).
> Em alguns provedores, `latest/download` pode ficar em cache por alguns minutos; o `?ts=...` evita receber script antigo.

👉 [Ver todos os releases e changelogs](https://github.com/CoelhoFZ/BO2-PTBR/releases)

### Modo Automacao (sem menu)

Para suporte remoto, scripts ou reinstalacao rapida, voce pode executar o instalador em modo direto:

```powershell
# Instalar textos
powershell -NoProfile -ExecutionPolicy Bypass -Command "$s = curl.exe -fsSL https://github.com/CoelhoFZ/BO2-PTBR/releases/latest/download/install.ps1 | Out-String; & ([ScriptBlock]::Create($s)) -Action InstallText -Silent -Force"

# Instalar dublagem
powershell -NoProfile -ExecutionPolicy Bypass -Command "$s = curl.exe -fsSL https://github.com/CoelhoFZ/BO2-PTBR/releases/latest/download/install.ps1 | Out-String; & ([ScriptBlock]::Create($s)) -Action InstallDubbing -Silent -Force"

# Instalar textos + dublagem
powershell -NoProfile -ExecutionPolicy Bypass -Command "$s = curl.exe -fsSL https://github.com/CoelhoFZ/BO2-PTBR/releases/latest/download/install.ps1 | Out-String; & ([ScriptBlock]::Create($s)) -Action InstallBoth -Silent -Force"

# Ver status
powershell -NoProfile -ExecutionPolicy Bypass -Command "$s = curl.exe -fsSL https://github.com/CoelhoFZ/BO2-PTBR/releases/latest/download/install.ps1 | Out-String; & ([ScriptBlock]::Create($s)) -Action Status -Silent"
```

Opcoes de `-Action`: `InstallText`, `InstallDubbing`, `InstallBoth`, `UninstallText`, `UninstallDubbing`, `UninstallAll`, `Status`.

---

## Requisitos

- Windows 10/11 (64-bit)
- Client [Plutonium T6](https://plutonium.pw) instalado
- Arquivos do jogo Call of Duty: Black Ops II (Steam ou qualquer fonte)
- Conexão com a internet (para download)

## O que o Script Faz

O instalador:
1. Detecta seu idioma automaticamente (PT-BR, EN, ES)
2. Solicita privilégios de Administrador se necessário
3. Encontra sua instalação do Plutonium
4. Baixa e instala os arquivos de tradução
5. Configura o Plutonium Launcher para auto-carregamento do mod
6. Oferece desinstalação limpa

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

- 🌐 **Multi-idioma**: Instalador detecta automaticamente EN, PT-BR, ES
- 🎮 **2.300+ strings**: Menus, HUD, telas de carregamento, dicas, perks, armas
- 🔧 **Auto-carregamento**: Configura o Plutonium Launcher automaticamente
- 📦 **Fácil de instalar**: Um único comando PowerShell, menus interativos
- 🗑️ **Desinstalação limpa**: Remove todos os arquivos e restaura o launcher
- 🔄 **Suporte a reinstalação**: Detecta instalação existente

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
2. Extraia o arquivo. O zip contém as pastas `mods/` e `raw/`:
  - Copie o conteúdo de `mods/` para `%LOCALAPPDATA%\Plutonium\storage\t6\mods\`
  - Copie o conteúdo de `raw/` para `%LOCALAPPDATA%\Plutonium\storage\t6\mods\zm_ptbr\raw\`
  - Copie também `raw\ui\` para `%LOCALAPPDATA%\Plutonium\storage\t6\mods\zm_ptbr\ui\`
  - Copie também `raw\ui_mp\` para `%LOCALAPPDATA%\Plutonium\storage\t6\mods\zm_ptbr\ui_mp\`
  > **Atenção:** não extraia `raw/` direto na raiz do storage. Os arquivos de tradução devem ficar dentro de `mods\zm_ptbr\raw\`, e os Lua de UI tambem precisam estar espelhados em `mods\zm_ptbr\ui\` e `mods\zm_ptbr\ui_mp\` para o loader do Plutonium resolver `require("T6.PTBR")` corretamente.
3. Adicione `+set fs_game mods/zm_ptbr` nos parâmetros de lançamento do Plutonium T6 Zombies

## Solução de Problemas

| Problema | Solução |
|----------|---------|
| "Plutonium NAO ENCONTRADO" | Certifique-se que o Plutonium T6 está instalado. Execute o launcher pelo menos uma vez. |
| Tradução não carrega | Verifique se `+set fs_game mods/zm_ptbr` está nos parâmetros de lançamento |
| Alguns textos ainda em inglês | Algumas strings do engine não podem ser sobrescritas |
| Script não executa | Execute `Set-ExecutionPolicy Bypass -Scope Process` primeiro |
| `irm` falha com "conexao foi fechada" | Tente o comando com TLS 1.2 acima ou o fallback com `curl.exe` |

## Notas

- Toda a tradução é carregada **exclusivamente via mod** (`+set fs_game mods/zm_ptbr`). Sem o mod ativo, nenhum texto PT-BR é aplicado — comportamento 100% vanilla.
- Os arquivos de texto ficam dentro de `mods\zm_ptbr`. O instalador tambem espelha os Lua de `raw\ui` e `raw\ui_mp` para `ui` e `ui_mp` na raiz do mod, porque o loader do frontend resolve esses modulos por esse caminho.
- O instalador tambem remove overrides globais legados em `storage\t6\raw`, para garantir que nenhum texto PT-BR apareca fora do mod carregado.
- A dublagem e independente dos textos. Se voce remover **somente os textos**, a dublagem PT-BR continua instalada.
- Para voltar a dublagem para ingles, execute o instalador novamente e escolha **Remover Traducao PT-BR** > **Somente Dublagem**, ou use a acao `UninstallDubbing`.
- O instalador detecta automaticamente o idioma do sistema (PT-BR, EN, ES).
- As traduções em espanhol do instalador não utilizam acentos propositalmente, para compatibilidade máxima com consoles e terminais que não suportam caracteres especiais.
- O script verifica automaticamente se há atualizações disponíveis ao iniciar.
- Downloads usam retries automaticos e fallback de transporte (WebClient/BITS/HttpClient).
- Downloads sao verificados via SHA256. Se checksums estiverem indisponiveis, o instalador pede confirmacao antes de continuar.

## Comunidade

Entre no nosso Discord: https://discord.gg/bfFdyJ3gEj

## Créditos

- **CoelhoFZ** — Tradução e desenvolvimento da ferramenta
- **Equipe Plutonium** — Client T6
- **Treyarch / Activision** — Call of Duty: Black Ops II

## Licença

GPLv3 — Veja [LICENSE](LICENSE)
