<#
.SYNOPSIS
    Tradutor PT-BR para Black Ops 2 (Plutonium T6)

.DESCRIPTION
    Instalador completo de traducao PT-BR para Call of Duty: Black Ops II
    no client Plutonium T6. Traduz textos, menus e HUD para portugues.
    
    Usage: irm https://github.com/CoelhoFZ/BO2-PTBR/releases/latest/download/install.ps1 | iex

.NOTES
    Author: CoelhoFZ
    Version: 1.0.0
    Repository: https://github.com/CoelhoFZ/BO2-PTBR
#>

$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'

# ============================================================================
# Configuration
# ============================================================================
$Script:Version   = "1.0.0"
$Script:RepoOwner = "CoelhoFZ"
$Script:RepoName  = "BO2-PTBR"
$Script:BaseUrl   = "https://github.com/$RepoOwner/$RepoName/releases/latest/download"
$Script:DiscordUrl = "https://discord.gg/bfFdyJ3gEj"

# ============================================================================
# Language Detection
# ============================================================================
$Script:Lang = "pt"

function Detect-Language {
    try {
        $culture = (Get-Culture).Name
        switch -Wildcard ($culture) {
            "pt-*"  { $Script:Lang = "pt" }
            "es-*"  { $Script:Lang = "es" }
            default { $Script:Lang = "en" }
        }
    } catch {
        $Script:Lang = "pt"
    }
}

function T {
    param([string]$Key)

    $translations = @{
        "admin_required" = @{
            en = "Administrator privileges required!"
            pt = "Privilegios de Administrador necessarios!"
            es = "Se requieren privilegios de Administrador!"
        }
        "admin_elevating" = @{
            en = "Requesting elevation..."
            pt = "Solicitando elevacao..."
            es = "Solicitando elevacion..."
        }
        "admin_ok" = @{
            en = "Running with Administrator privileges"
            pt = "Executando com privilegios de Administrador"
            es = "Ejecutando con privilegios de Administrador"
        }
        "menu_title" = @{
            en = "Available Options"
            pt = "Opcoes Disponiveis"
            es = "Opciones Disponibles"
        }
        "menu_1" = @{
            en = "Install Zombies"
            pt = "Instalar Zombies"
            es = "Instalar Zombies"
        }
        "menu_2" = @{
            en = "Install Multiplayer [Coming Soon]"
            pt = "Instalar Multiplayer [Em Breve]"
            es = "Instalar Multiplayer [Proximamente]"
        }
        "menu_3" = @{
            en = "Install Campaign [Coming Soon]"
            pt = "Instalar Campanha [Em Breve]"
            es = "Instalar Campana [Proximamente]"
        }
        "menu_4" = @{
            en = "Uninstall"
            pt = "Desinstalar"
            es = "Desinstalar"
        }
        "menu_5" = @{
            en = "Check Status"
            pt = "Verificar Status"
            es = "Verificar Estado"
        }
        "menu_0" = @{
            en = "Exit"
            pt = "Sair"
            es = "Salir"
        }
        "sub_title" = @{
            en = "Installation Type"
            pt = "Tipo de Instalacao"
            es = "Tipo de Instalacion"
        }
        "sub_1" = @{
            en = "Dubbing + Text [Coming Soon]"
            pt = "Dublagem + Textos [Em Breve]"
            es = "Doblaje + Textos [Proximamente]"
        }
        "sub_2" = @{
            en = "Only Dubbing [Coming Soon]"
            pt = "Somente Dublagem [Em Breve]"
            es = "Solo Doblaje [Proximamente]"
        }
        "sub_3" = @{
            en = "Only Text"
            pt = "Somente Textos"
            es = "Solo Textos"
        }
        "sub_0" = @{
            en = "Back"
            pt = "Voltar"
            es = "Volver"
        }
        "choose" = @{
            en = "Choose an option"
            pt = "Escolha uma opcao"
            es = "Elija una opcion"
        }
        "invalid" = @{
            en = "Invalid option!"
            pt = "Opcao invalida!"
            es = "Opcion invalida!"
        }
        "coming_soon" = @{
            en = "This feature is coming soon!"
            pt = "Esta funcionalidade estara disponivel em breve!"
            es = "Esta funcionalidad estara disponible pronto!"
        }
        "pluto_not_found" = @{
            en = "Plutonium NOT FOUND!"
            pt = "Plutonium NAO ENCONTRADO!"
            es = "Plutonium NO ENCONTRADO!"
        }
        "pluto_found" = @{
            en = "Plutonium found"
            pt = "Plutonium encontrado"
            es = "Plutonium encontrado"
        }
        "t6_not_found" = @{
            en = "Black Ops 2 (T6) storage not found in Plutonium!"
            pt = "Armazenamento do Black Ops 2 (T6) nao encontrado no Plutonium!"
            es = "Almacenamiento de Black Ops 2 (T6) no encontrado en Plutonium!"
        }
        "installing" = @{
            en = "Installing translation..."
            pt = "Instalando traducao..."
            es = "Instalando traduccion..."
        }
        "downloading" = @{
            en = "Downloading"
            pt = "Baixando"
            es = "Descargando"
        }
        "download_ok" = @{
            en = "Downloaded successfully"
            pt = "Baixado com sucesso"
            es = "Descargado exitosamente"
        }
        "download_fail" = @{
            en = "Download FAILED"
            pt = "Download FALHOU"
            es = "Descarga FALLO"
        }
        "extracting" = @{
            en = "Extracting files..."
            pt = "Extraindo arquivos..."
            es = "Extrayendo archivos..."
        }
        "install_ok" = @{
            en = "Translation installed successfully!"
            pt = "Traducao instalada com sucesso!"
            es = "Traduccion instalada exitosamente!"
        }
        "install_fail" = @{
            en = "Installation failed"
            pt = "Instalacao falhou"
            es = "Instalacion fallo"
        }
        "launcher_patched" = @{
            en = "Launcher configured for auto-load"
            pt = "Launcher configurado para auto-carregamento"
            es = "Launcher configurado para carga automatica"
        }
        "launcher_patch_fail" = @{
            en = "Could not patch launcher (you can load the mod manually)"
            pt = "Nao foi possivel configurar o launcher (voce pode carregar o mod manualmente)"
            es = "No se pudo configurar el launcher (puede cargar el mod manualmente)"
        }
        "launcher_restored" = @{
            en = "Launcher restored to original"
            pt = "Launcher restaurado ao original"
            es = "Launcher restaurado al original"
        }
        "removing" = @{
            en = "Removing translation files..."
            pt = "Removendo arquivos de traducao..."
            es = "Eliminando archivos de traduccion..."
        }
        "removed_ok" = @{
            en = "Translation removed successfully!"
            pt = "Traducao removida com sucesso!"
            es = "Traduccion eliminada exitosamente!"
        }
        "status_title" = @{
            en = "INSTALLATION STATUS"
            pt = "STATUS DA INSTALACAO"
            es = "ESTADO DE LA INSTALACION"
        }
        "status_pluto" = @{
            en = "Plutonium"
            pt = "Plutonium"
            es = "Plutonium"
        }
        "status_t6" = @{
            en = "Black Ops 2 (T6)"
            pt = "Black Ops 2 (T6)"
            es = "Black Ops 2 (T6)"
        }
        "status_text_zm" = @{
            en = "Zombies Text"
            pt = "Textos Zombies"
            es = "Textos Zombies"
        }
        "status_dub_zm" = @{
            en = "Zombies Dubbing"
            pt = "Dublagem Zombies"
            es = "Doblaje Zombies"
        }
        "status_launcher" = @{
            en = "Auto-load"
            pt = "Auto-carregamento"
            es = "Carga automatica"
        }
        "status_installed" = @{
            en = "INSTALLED"
            pt = "INSTALADO"
            es = "INSTALADO"
        }
        "status_not_installed" = @{
            en = "NOT INSTALLED"
            pt = "NAO INSTALADO"
            es = "NO INSTALADO"
        }
        "press_enter" = @{
            en = "Press Enter to continue..."
            pt = "Pressione Enter para continuar..."
            es = "Presione Enter para continuar..."
        }
        "exiting" = @{
            en = "Exiting... Goodbye!"
            pt = "Saindo... Ate mais!"
            es = "Saliendo... Hasta luego!"
        }
        "confirm_uninstall" = @{
            en = "Are you sure? This will remove all translation files. [Y/N]"
            pt = "Tem certeza? Isso vai remover todos os arquivos de traducao. [S/N]"
            es = "Esta seguro? Esto eliminara todos los archivos de traduccion. [S/N]"
        }
        "uninstall_cancelled" = @{
            en = "Uninstall cancelled."
            pt = "Desinstalacao cancelada."
            es = "Desinstalacion cancelada."
        }
        "install_pluto_hint" = @{
            en = "Install Plutonium from https://plutonium.pw"
            pt = "Instale o Plutonium em https://plutonium.pw"
            es = "Instale Plutonium desde https://plutonium.pw"
        }
        "backup_created" = @{
            en = "Backup created"
            pt = "Backup criado"
            es = "Backup creado"
        }
        "already_installed" = @{
            en = "Translation already installed. Reinstall? [Y/N]"
            pt = "Traducao ja instalada. Reinstalar? [S/N]"
            es = "Traduccion ya instalada. Reinstalar? [S/N]"
        }
        "close_pluto" = @{
            en = "Please close the Plutonium Launcher before continuing!"
            pt = "Feche o Plutonium Launcher antes de continuar!"
            es = "Cierre el Plutonium Launcher antes de continuar!"
        }
        "done_open" = @{
            en = "Done! Open Plutonium and start a Zombies game."
            pt = "Pronto! Abra o Plutonium e inicie um jogo Zombies."
            es = "Listo! Abra Plutonium e inicie un juego Zombies."
        }
        "done_auto" = @{
            en = "The translation will load automatically."
            pt = "A traducao sera carregada automaticamente."
            es = "La traduccion se cargara automaticamente."
        }
        "manual_load" = @{
            en = "To load manually: +set fs_game mods/zm_ptbr"
            pt = "Para carregar manualmente: +set fs_game mods/zm_ptbr"
            es = "Para cargar manualmente: +set fs_game mods/zm_ptbr"
        }
        "dub_not_ready" = @{
            en = "Dubbing is not yet available. Install text only? [Y/N]"
            pt = "A dublagem ainda nao esta disponivel. Instalar somente textos? [S/N]"
            es = "El doblaje aun no esta disponible. Instalar solo textos? [S/N]"
        }
        "connection_hint" = @{
            en = "Check your internet connection."
            pt = "Verifique sua conexao com a internet."
            es = "Verifique su conexion a internet."
        }
        "pluto_running" = @{
            en = "Plutonium Launcher is running. Closing it..."
            pt = "Plutonium Launcher esta rodando. Fechando..."
            es = "Plutonium Launcher esta ejecutandose. Cerrando..."
        }
    }

    $entry = $translations[$Key]
    if ($entry -and $entry[$Script:Lang]) {
        return $entry[$Script:Lang]
    } elseif ($entry -and $entry["en"]) {
        return $entry["en"]
    }
    return $Key
}

# ============================================================================
# Console Appearance
# ============================================================================
function Set-ConsoleAppearance {
    try {
        $Host.UI.RawUI.BackgroundColor = 'Black'
        $Host.UI.RawUI.ForegroundColor = 'Gray'
        $Host.UI.RawUI.WindowTitle = "Tradutor PT-BR Black Ops 2 v$Script:Version"

        $screenW = 1920; $screenH = 1080
        try {
            Add-Type -AssemblyName System.Windows.Forms -ErrorAction SilentlyContinue
            $screen = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds
            $screenW = $screen.Width; $screenH = $screen.Height
        } catch { }

        $targetWidth  = [Math]::Max(80,  [Math]::Min(120, [int]($screenW * 0.70 / 8)))
        $targetHeight = [Math]::Max(30,  [Math]::Min(45,  [int]($screenH * 0.70 / 16)))

        $maxSize = $Host.UI.RawUI.MaxPhysicalWindowSize
        $w = [Math]::Min($targetWidth,  $maxSize.Width)
        $h = [Math]::Min($targetHeight, $maxSize.Height)

        $curBuf = $Host.UI.RawUI.BufferSize
        $newBuf = New-Object System.Management.Automation.Host.Size($w, 1000)
        $newWin = New-Object System.Management.Automation.Host.Size($w, $h)

        if ($curBuf.Width -gt $w) {
            $Host.UI.RawUI.WindowSize = $newWin
            $Host.UI.RawUI.BufferSize = $newBuf
        } else {
            $Host.UI.RawUI.BufferSize = $newBuf
            $Host.UI.RawUI.WindowSize = $newWin
        }

        try {
            Add-Type -AssemblyName System.Windows.Forms -ErrorAction SilentlyContinue
            $charW = 8; $charH = 16
            $winPixW = $w * $charW; $winPixH = $h * $charH
            $posX = [Math]::Max(0, [int](($screenW - $winPixW) / 2))
            $posY = [Math]::Max(0, [int](($screenH - $winPixH) / 2))
            $Host.UI.RawUI.WindowPosition = New-Object System.Management.Automation.Host.Coordinates($posX / $charW, 0)
        } catch { }

        Clear-Host
    } catch {
        try { Clear-Host } catch { }
    }
}

# ============================================================================
# UI Functions
# ============================================================================
function Write-C {
    param([string]$Text, [ConsoleColor]$Color = 'White', [switch]$NoNewline)
    if ($NoNewline) {
        Write-Host $Text -ForegroundColor $Color -NoNewline
    } else {
        Write-Host $Text -ForegroundColor $Color
    }
}

function Write-OK   { param([string]$Msg) Write-C "  [OK] $Msg" Green }
function Write-Err  { param([string]$Msg) Write-C "  [ERRO] $Msg" Red }
function Write-Warn { param([string]$Msg) Write-C "  [!] $Msg" Yellow }
function Write-Info { param([string]$Msg) Write-C "  [*] $Msg" Cyan }
function Write-Line { Write-C "  ============================================================" DarkGray }

function Show-Banner {
    Clear-Host
    Write-C ""
    Write-C "  ============================================================" Cyan
    Write-C "   _____              _       _              " Cyan
    Write-C "  |_   _| __ __ _  __| |_   _| |_ ___  _ __ " Cyan
    Write-C "    | || '__/ _' |/ _' | | | | __/ _ \| '__|" Cyan
    Write-C "    | || | | (_| | (_| | |_| | || (_) | |   " Cyan
    Write-C "    |_||_|  \__,_|\__,_|\__,_|\__\___/|_|   " Cyan
    Write-C "   ____  _            _        ___              ____  " Cyan
    Write-C "  | __ )| | __ _  ___| | __   / _ \ _ __  ___  |___ \ " Cyan
    Write-C "  |  _ \| |/ _' |/ __| |/ /  | | | | '_ \/ __|   __) |" Cyan
    Write-C "  | |_) | | (_| | (__|   <   | |_| | |_) \__ \  / __/ " Cyan
    Write-C "  |____/|_|\__,_|\___|_|\_\   \___/| .__/|___/ |_____|" Cyan
    Write-C "                                    |_|                " Cyan
    Write-C "                  PT-BR by CoelhoFZ (Plutonium)        " Cyan
    Write-C "  ============================================================" Cyan
    Write-C "                         v$Script:Version (PowerShell)" DarkGray
    Write-C ""
}

function Show-MainMenu {
    $zmInstalled = Test-ZombiesTextInstalled
    $zmTag = if ($zmInstalled) { " [$(T 'status_installed')]" } else { "" }

    Write-C ""
    Write-C "    $(T 'menu_title')" Green
    Write-C ""
    Write-C "    " -NoNewline; Write-C "[1]" Green   -NoNewline; Write-C " $(T 'menu_1')$zmTag"
    Write-C "    " -NoNewline; Write-C "[2]" DarkGray -NoNewline; Write-C " $(T 'menu_2')" DarkGray
    Write-C "    " -NoNewline; Write-C "[3]" DarkGray -NoNewline; Write-C " $(T 'menu_3')" DarkGray
    Write-C "    " -NoNewline; Write-C "[4]" Yellow  -NoNewline; Write-C " $(T 'menu_4')"
    Write-C "    " -NoNewline; Write-C "[5]" Cyan    -NoNewline; Write-C " $(T 'menu_5')"
    Write-C "    " -NoNewline; Write-C "[0]" Red     -NoNewline; Write-C " $(T 'menu_0')"
    Write-C ""
    Write-Line
    Write-C ""
}

function Show-SubMenu {
    Write-C ""
    Write-C "    $(T 'sub_title')" Green
    Write-C ""
    Write-C "    " -NoNewline; Write-C "[1]" DarkGray -NoNewline; Write-C " $(T 'sub_1')" DarkGray
    Write-C "    " -NoNewline; Write-C "[2]" DarkGray -NoNewline; Write-C " $(T 'sub_2')" DarkGray
    Write-C "    " -NoNewline; Write-C "[3]" Green    -NoNewline; Write-C " $(T 'sub_3')"
    Write-C "    " -NoNewline; Write-C "[0]" Red      -NoNewline; Write-C " $(T 'sub_0')"
    Write-C ""
    Write-Line
    Write-C ""
}

function Wait-Enter {
    Write-C ""
    Write-C "  $(T 'press_enter')" DarkGray
    $null = Read-Host
}

# ============================================================================
# Core Functions
# ============================================================================
function Test-Admin {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Request-Elevation {
    Write-Warn (T 'admin_required')
    Write-Info (T 'admin_elevating')

    try {
        $scriptUrl = "$Script:BaseUrl/install.ps1"
        $cmd = "Set-ExecutionPolicy Bypass -Scope Process -Force; [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; iex (irm '$scriptUrl')"
        Start-Process powershell.exe -ArgumentList "-NoProfile -ExecutionPolicy Bypass -Command `"$cmd`"" -Verb RunAs

        Write-OK "Elevated window opened. This window will close..."
        Start-Sleep -Seconds 2
        exit
    }
    catch {
        Write-Err "Failed to elevate. Please run PowerShell as Administrator."
        Write-Warn "  Right-click PowerShell -> Run as administrator"
        Wait-Enter
    }
}

function Find-PlutoniumPath {
    $default = Join-Path $env:LOCALAPPDATA "Plutonium"
    if (Test-Path $default) { return $default }

    try {
        $regPath = "HKCU:\Software\Plutonium"
        if (Test-Path $regPath) {
            $path = (Get-ItemProperty $regPath -ErrorAction SilentlyContinue).InstallPath
            if ($path -and (Test-Path $path)) { return $path }
        }
    } catch { }

    return $null
}

function Get-T6StoragePath {
    $plutoPath = Find-PlutoniumPath
    if (-not $plutoPath) { return $null }

    $t6Storage = Join-Path $plutoPath "storage\t6"
    if (Test-Path $t6Storage) { return $t6Storage }

    return $null
}

function Get-LauncherJsPath {
    $plutoPath = Find-PlutoniumPath
    if (-not $plutoPath) { return $null }

    $resourcesDir = Join-Path $plutoPath "bin\resources\app"
    if (-not (Test-Path $resourcesDir)) { return $null }

    $jsFiles = Get-ChildItem $resourcesDir -Filter "games.*.js" -ErrorAction SilentlyContinue
    if ($jsFiles.Count -gt 0) {
        return $jsFiles[0].FullName
    }

    return $null
}

function Test-ZombiesTextInstalled {
    $t6Path = Get-T6StoragePath
    if (-not $t6Path) { return $false }

    $modFf = Join-Path $t6Path "mods\zm_ptbr\mod.ff"
    return (Test-Path $modFf)
}

function Test-LauncherPatched {
    $jsPath = Get-LauncherJsPath
    if (-not $jsPath) { return $false }

    try {
        $content = [System.IO.File]::ReadAllText($jsPath)
        return ($content -match 'fs_game mods/zm_ptbr')
    } catch {
        return $false
    }
}

function Test-PlutoniumRunning {
    $procs = Get-Process -Name "plutonium-launcher*" -ErrorAction SilentlyContinue
    return ($null -ne $procs)
}

function Stop-PlutoniumLauncher {
    Write-Warn (T 'pluto_running')
    Get-Process -Name "plutonium-launcher*" -ErrorAction SilentlyContinue | Stop-Process -Force
    Start-Sleep -Seconds 2
}

# ============================================================================
# Install Functions
# ============================================================================
function Install-ZombiesText {
    $t6Path = Get-T6StoragePath

    if (-not $t6Path) {
        Write-Err (T 'pluto_not_found')
        Write-C ""
        Write-Info (T 'install_pluto_hint')
        Wait-Enter
        return
    }

    Write-OK "$(T 'pluto_found'): $t6Path"
    Write-C ""

    # Check if already installed
    if (Test-ZombiesTextInstalled) {
        Write-Warn (T 'already_installed')
        Write-C "  " -NoNewline
        $confirm = Read-Host
        if ($confirm -notmatch '^[SsYy]') { return }
        Write-C ""
    }

    Write-Info (T 'installing')
    Write-C ""

    # Download zip
    $zipName = "textos_zm.zip"
    $zipUrl  = "$Script:BaseUrl/$zipName"
    $tempZip = Join-Path $env:TEMP "bo2ptbr_$zipName"

    Write-Info "$(T 'downloading') $zipName..."

    try {
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        $webClient = New-Object System.Net.WebClient
        $webClient.Headers.Add("User-Agent", "Mozilla/5.0")
        $webClient.DownloadFile($zipUrl, $tempZip)
    } catch {
        # Fallback download method
        try {
            Add-Type -AssemblyName System.Net.Http -ErrorAction SilentlyContinue
            $httpClient = New-Object System.Net.Http.HttpClient
            $httpClient.Timeout = [TimeSpan]::FromSeconds(120)
            $bytes = $httpClient.GetByteArrayAsync($zipUrl).Result
            [System.IO.File]::WriteAllBytes($tempZip, $bytes)
        } catch {
            Write-Err "$(T 'download_fail'): $zipName"
            Write-Warn "  URL: $zipUrl"
            Write-Warn "  $(T 'connection_hint')"
            Write-C ""
            Write-Info "Discord: $Script:DiscordUrl"
            Wait-Enter
            return
        }
    }

    if (-not (Test-Path $tempZip) -or (Get-Item $tempZip).Length -eq 0) {
        Write-Err (T 'download_fail')
        Wait-Enter
        return
    }

    Write-OK (T 'download_ok')

    # Extract
    Write-Info (T 'extracting')

    try {
        $tempExtract = Join-Path $env:TEMP "bo2ptbr_extract"
        if (Test-Path $tempExtract) {
            Remove-Item $tempExtract -Recurse -Force -ErrorAction SilentlyContinue
        }

        Expand-Archive -Path $tempZip -DestinationPath $tempExtract -Force

        # Ensure target directories exist
        $modsDir = Join-Path $t6Path "mods\zm_ptbr"
        if (-not (Test-Path $modsDir)) {
            New-Item -Path $modsDir -ItemType Directory -Force | Out-Null
        }
        $rawDir = Join-Path $t6Path "raw"
        if (-not (Test-Path $rawDir)) {
            New-Item -Path $rawDir -ItemType Directory -Force | Out-Null
        }

        # Copy all extracted contents preserving structure
        if (Test-Path (Join-Path $tempExtract "mods")) {
            Copy-Item -Path (Join-Path $tempExtract "mods\*") -Destination (Join-Path $t6Path "mods") -Recurse -Force
            Write-OK "mods\zm_ptbr\"
        }
        if (Test-Path (Join-Path $tempExtract "raw")) {
            Copy-Item -Path (Join-Path $tempExtract "raw\*") -Destination $rawDir -Recurse -Force
            Write-OK "raw\ (Lua + .str)"
        }

        # Cleanup temp
        Remove-Item $tempZip -Force -ErrorAction SilentlyContinue
        Remove-Item $tempExtract -Recurse -Force -ErrorAction SilentlyContinue

    } catch {
        Write-Err "$(T 'install_fail'): $_"
        # Cleanup on failure
        Remove-Item $tempZip -Force -ErrorAction SilentlyContinue
        if (Test-Path (Join-Path $env:TEMP "bo2ptbr_extract")) {
            Remove-Item (Join-Path $env:TEMP "bo2ptbr_extract") -Recurse -Force -ErrorAction SilentlyContinue
        }
        Wait-Enter
        return
    }

    # Verify
    if (Test-ZombiesTextInstalled) {
        Write-OK (T 'install_ok')
    } else {
        Write-Err (T 'install_fail')
        Wait-Enter
        return
    }

    # Patch launcher for auto-load
    Write-C ""
    if (Test-PlutoniumRunning) {
        Stop-PlutoniumLauncher
    }

    $patched = Patch-Launcher
    if ($patched) {
        Write-OK (T 'launcher_patched')
    } else {
        Write-Warn (T 'launcher_patch_fail')
        Write-Info (T 'manual_load')
    }

    Write-C ""
    Write-OK (T 'done_open')
    Write-Info (T 'done_auto')

    Wait-Enter
}

function Patch-Launcher {
    $jsPath = Get-LauncherJsPath
    if (-not $jsPath) { return $false }

    try {
        $content = [System.IO.File]::ReadAllText($jsPath)

        # Already patched?
        if ($content -match 'fs_game mods/zm_ptbr') { return $true }

        # Create backup
        $bakPath = "$jsPath.bak"
        if (-not (Test-Path $bakPath)) {
            [System.IO.File]::Copy($jsPath, $bakPath)
            Write-OK (T 'backup_created')
        }

        # Patch: inject +set fs_game mods/zm_ptbr into T6ZM launch params
        # Known pattern: "t6zm"===this.game.tag?(t.lanMode?"-lan":""):""
        $original = '"t6zm"===this.game.tag?(t.lanMode?"-lan":""):""'
        $replacement = '"t6zm"===this.game.tag?(t.lanMode?"-lan +set fs_game mods/zm_ptbr":"+set fs_game mods/zm_ptbr"):(t.lanMode?"-lan":"")'

        if ($content.Contains($original)) {
            $content = $content.Replace($original, $replacement)
            [System.IO.File]::WriteAllText($jsPath, $content)
            return $true
        }

        # Fallback: try regex for slight variations
        $pattern = '"t6zm"\s*===\s*this\.game\.tag\s*\?\s*\(\s*t\.lanMode\s*\?\s*"-lan"\s*:\s*""\s*\)\s*:\s*""'
        if ($content -match $pattern) {
            $content = $content -replace $pattern, $replacement
            [System.IO.File]::WriteAllText($jsPath, $content)
            return $true
        }

        return $false
    } catch {
        return $false
    }
}

function Restore-Launcher {
    $jsPath = Get-LauncherJsPath
    if (-not $jsPath) { return $false }

    # Try backup restore first
    $bakPath = "$jsPath.bak"
    if (Test-Path $bakPath) {
        try {
            Copy-Item -Path $bakPath -Destination $jsPath -Force
            return $true
        } catch { }
    }

    # No backup — remove our patch from the content
    try {
        $content = [System.IO.File]::ReadAllText($jsPath)
        # Restore the replacement back to original
        $patched = '"t6zm"===this.game.tag?(t.lanMode?"-lan +set fs_game mods/zm_ptbr":"+set fs_game mods/zm_ptbr"):(t.lanMode?"-lan":"")'
        $original = '"t6zm"===this.game.tag?(t.lanMode?"-lan":""):""'

        if ($content.Contains($patched)) {
            $content = $content.Replace($patched, $original)
            [System.IO.File]::WriteAllText($jsPath, $content)
            return $true
        }
    } catch { }

    return $false
}

# ============================================================================
# Uninstall
# ============================================================================
function Uninstall-Mod {
    $t6Path = Get-T6StoragePath

    if (-not $t6Path) {
        Write-Err (T 'pluto_not_found')
        Wait-Enter
        return
    }

    if (-not (Test-ZombiesTextInstalled) -and -not (Test-LauncherPatched)) {
        Write-Info (T 'status_not_installed')
        Wait-Enter
        return
    }

    # Confirm
    Write-C ""
    Write-Warn (T 'confirm_uninstall')
    Write-C "  " -NoNewline
    $confirm = Read-Host
    if ($confirm -notmatch '^[SsYy]') {
        Write-Info (T 'uninstall_cancelled')
        Wait-Enter
        return
    }

    Write-C ""
    Write-Info (T 'removing')
    Write-C ""

    # Remove mod directory
    $modDir = Join-Path $t6Path "mods\zm_ptbr"
    if (Test-Path $modDir) {
        try {
            Remove-Item $modDir -Recurse -Force
            Write-OK "mods\zm_ptbr\"
        } catch {
            Write-Warn "Failed: mods\zm_ptbr\"
        }
    }

    # Remove Lua files
    $luaPaths = @(
        "raw\ui\t6\PTBR.lua",
        "raw\ui_mp\t6\PTBR.lua",
        "raw\ui_mp\t6\hud\PTBR.lua"
    )
    foreach ($luaRel in $luaPaths) {
        $luaFull = Join-Path $t6Path $luaRel
        if (Test-Path $luaFull) {
            try {
                Remove-Item $luaFull -Force
                Write-OK $luaRel
            } catch {
                Write-Warn "Failed: $luaRel"
            }
        }
    }

    # Remove raw .str file
    $strPath = Join-Path $t6Path "raw\english\localizedstrings\ptbr_mod.str"
    if (Test-Path $strPath) {
        try {
            Remove-Item $strPath -Force
            Write-OK "raw\english\localizedstrings\ptbr_mod.str"
        } catch {
            Write-Warn "Failed: ptbr_mod.str"
        }
    }

    # Restore launcher
    if (Test-PlutoniumRunning) {
        Stop-PlutoniumLauncher
    }
    $restored = Restore-Launcher
    if ($restored) {
        Write-OK (T 'launcher_restored')
    }

    Write-C ""
    Write-OK (T 'removed_ok')
    Wait-Enter
}

# ============================================================================
# Status
# ============================================================================
function Show-Status {
    Write-Line
    Write-C "  $(T 'status_title')" Cyan
    Write-Line
    Write-C ""

    # Plutonium
    $plutoPath = Find-PlutoniumPath
    Write-C "  $(T 'status_pluto'):          " -NoNewline
    if ($plutoPath) {
        Write-C (T 'status_installed') Green
        Write-C "                         $plutoPath" DarkGray
    } else {
        Write-C (T 'status_not_installed') Red
    }

    # T6 Storage
    $t6Path = Get-T6StoragePath
    Write-C "  $(T 'status_t6'):     " -NoNewline
    if ($t6Path) {
        Write-C (T 'status_installed') Green
    } else {
        Write-C (T 'status_not_installed') Red
    }

    Write-C ""

    # Zombies Text
    Write-C "  $(T 'status_text_zm'):    " -NoNewline
    if (Test-ZombiesTextInstalled) {
        Write-C (T 'status_installed') Green
    } else {
        Write-C (T 'status_not_installed') DarkGray
    }

    # Zombies Dubbing
    Write-C "  $(T 'status_dub_zm'):  " -NoNewline
    Write-C (T 'status_not_installed') DarkGray

    # Auto-load
    Write-C "  $(T 'status_launcher'):   " -NoNewline
    if (Test-LauncherPatched) {
        Write-C (T 'status_installed') Green
    } else {
        Write-C (T 'status_not_installed') DarkGray
    }

    Write-C ""
    Write-Line
    Wait-Enter
}

# ============================================================================
# Main Loop
# ============================================================================
function Start-MainLoop {
    Detect-Language
    Set-ConsoleAppearance
    Show-Banner

    # Check admin
    if (-not (Test-Admin)) {
        Request-Elevation
        return
    }

    Write-OK (T 'admin_ok')

    while ($true) {
        Show-MainMenu

        Write-C "  $(T 'choose'): " Cyan -NoNewline
        $choice = Read-Host

        Show-Banner

        switch ($choice.Trim()) {
            "1" {
                # Zombies sub-menu
                Show-SubMenu
                Write-C "  $(T 'choose'): " Cyan -NoNewline
                $sub = Read-Host

                Show-Banner

                switch ($sub.Trim()) {
                    "1" {
                        # Dublagem + Textos (dubbing coming soon)
                        Write-Warn (T 'coming_soon')
                        Write-C ""
                        Write-Info (T 'dub_not_ready')
                        Write-C "  " -NoNewline
                        $fallback = Read-Host
                        if ($fallback -match '^[SsYy]') {
                            Show-Banner
                            Install-ZombiesText
                        }
                    }
                    "2" {
                        Write-Warn (T 'coming_soon')
                        Wait-Enter
                    }
                    "3" {
                        Install-ZombiesText
                    }
                    "0" { }
                    default { Write-Warn (T 'invalid') }
                }
            }
            "2" {
                Write-Warn (T 'coming_soon')
                Wait-Enter
            }
            "3" {
                Write-Warn (T 'coming_soon')
                Wait-Enter
            }
            "4" { Uninstall-Mod }
            "5" { Show-Status }
            "0" {
                Write-C ""
                Write-Info (T 'exiting')
                Start-Sleep -Seconds 1
                return
            }
            default { Write-Warn (T 'invalid') }
        }
    }
}

# ============================================================================
# Entry Point
# ============================================================================
Start-MainLoop
