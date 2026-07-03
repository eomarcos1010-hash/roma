#Requires -RunAsAdministrator
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# ============================================================
#                        R O M A
#   Utilitario de Otimizacao, Debloat e Performance Windows
#        (inspirado no ChrisTitusTech WinUtil)
# ============================================================

[System.Windows.Forms.Application]::EnableVisualStyles()

# ---------- Paleta de cores (tema azul) ----------
$corFundo      = [System.Drawing.Color]::FromArgb(10, 14, 22)
$corPainel     = [System.Drawing.Color]::FromArgb(17, 24, 38)
$corPainel2    = [System.Drawing.Color]::FromArgb(23, 32, 50)
$corAzul       = [System.Drawing.Color]::FromArgb(35, 105, 225)
$corAzulEscuro = [System.Drawing.Color]::FromArgb(22, 70, 160)
$corAzulClaro  = [System.Drawing.Color]::FromArgb(90, 170, 255)
$corCiano      = [System.Drawing.Color]::FromArgb(70, 210, 235)
$corVerde      = [System.Drawing.Color]::FromArgb(60, 190, 120)
$corVermelho   = [System.Drawing.Color]::FromArgb(220, 70, 70)
$corTexto      = [System.Drawing.Color]::FromArgb(230, 238, 248)
$corTextoMuted = [System.Drawing.Color]::FromArgb(140, 160, 190)
$fonteTitulo   = New-Object System.Drawing.Font("Segoe UI", 22, [System.Drawing.FontStyle]::Bold)
$fonteSub      = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Italic)
$fonteNormal   = New-Object System.Drawing.Font("Segoe UI", 9)
$fonteSecao    = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$fonteBotao    = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)

# ---------- Janela principal ----------
$form = New-Object System.Windows.Forms.Form
$form.Text = "ROMA - Otimizador e Debloat Windows"
$form.Size = New-Object System.Drawing.Size(1150, 800)
$form.StartPosition = "CenterScreen"
$form.BackColor = $corFundo
$form.ForeColor = $corTexto
$form.FormBorderStyle = "FixedSingle"
$form.MaximizeBox = $false

# ---------- Cabecalho ----------
$header = New-Object System.Windows.Forms.Panel
$header.Size = New-Object System.Drawing.Size(1150, 84)
$header.Location = New-Object System.Drawing.Point(0, 0)
$header.BackColor = $corPainel
$form.Controls.Add($header)

$faixa = New-Object System.Windows.Forms.Panel
$faixa.Size = New-Object System.Drawing.Size(1150, 3)
$faixa.Location = New-Object System.Drawing.Point(0, 81)
$faixa.BackColor = $corAzul
$header.Controls.Add($faixa)

$titulo = New-Object System.Windows.Forms.Label
$titulo.Text = "ROMA"
$titulo.Font = $fonteTitulo
$titulo.ForeColor = $corCiano
$titulo.Location = New-Object System.Drawing.Point(20, 12)
$titulo.AutoSize = $true
$header.Controls.Add($titulo)

$subtitulo = New-Object System.Windows.Forms.Label
$subtitulo.Text = "Otimizacao, debloat, tweaks, rede e prioridade de jogos"
$subtitulo.Font = $fonteSub
$subtitulo.ForeColor = $corTextoMuted
$subtitulo.Location = New-Object System.Drawing.Point(24, 50)
$subtitulo.AutoSize = $true
$header.Controls.Add($subtitulo)

$lblStatus = New-Object System.Windows.Forms.Label
$lblStatus.Text = "Pronto."
$lblStatus.ForeColor = $corAzulClaro
$lblStatus.Font = $fonteNormal
$lblStatus.Location = New-Object System.Drawing.Point(650, 14)
$lblStatus.Size = New-Object System.Drawing.Size(480, 20)
$lblStatus.TextAlign = "MiddleRight"
$header.Controls.Add($lblStatus)

$barraProgresso = New-Object System.Windows.Forms.ProgressBar
$barraProgresso.Location = New-Object System.Drawing.Point(650, 40)
$barraProgresso.Size = New-Object System.Drawing.Size(480, 18)
$barraProgresso.Style = "Continuous"
$header.Controls.Add($barraProgresso)

function Set-Status($texto) {
    $lblStatus.Text = $texto
    $form.Refresh()
}

# ---------- Abas ----------
$tabs = New-Object System.Windows.Forms.TabControl
$tabs.Location = New-Object System.Drawing.Point(10, 94)
$tabs.Size = New-Object System.Drawing.Size(1130, 660)
$tabs.Font = $fonteNormal
$form.Controls.Add($tabs)

$tabApps     = New-Object System.Windows.Forms.TabPage; $tabApps.Text     = "  Instalar Apps  "
$tabTweaks   = New-Object System.Windows.Forms.TabPage; $tabTweaks.Text   = "  Tweaks  "
$tabDebloat  = New-Object System.Windows.Forms.TabPage; $tabDebloat.Text  = "  Debloat  "
$tabServicos = New-Object System.Windows.Forms.TabPage; $tabServicos.Text = "  Servicos  "
$tabGames    = New-Object System.Windows.Forms.TabPage; $tabGames.Text    = "  Prioridade de Jogos  "
$tabRede     = New-Object System.Windows.Forms.TabPage; $tabRede.Text     = "  Rede  "
$tabSistema  = New-Object System.Windows.Forms.TabPage; $tabSistema.Text  = "  Sistema  "
$tabLimpeza  = New-Object System.Windows.Forms.TabPage; $tabLimpeza.Text  = "  Limpeza  "
$tabLog      = New-Object System.Windows.Forms.TabPage; $tabLog.Text      = "  Log  "
foreach ($t in @($tabApps, $tabTweaks, $tabDebloat, $tabServicos, $tabGames, $tabRede, $tabSistema, $tabLimpeza, $tabLog)) {
    $t.BackColor = $corFundo
    $t.ForeColor = $corTexto
    $tabs.Controls.Add($t)
}

# ---------- Caixa de log (compartilhada) ----------
$txtLog = New-Object System.Windows.Forms.TextBox
$txtLog.Multiline = $true
$txtLog.ScrollBars = "Vertical"
$txtLog.ReadOnly = $true
$txtLog.BackColor = [System.Drawing.Color]::FromArgb(6, 9, 14)
$txtLog.ForeColor = $corCiano
$txtLog.Font = New-Object System.Drawing.Font("Consolas", 9)
$txtLog.Location = New-Object System.Drawing.Point(10, 10)
$txtLog.Size = New-Object System.Drawing.Size(1100, 600)
$tabLog.Controls.Add($txtLog)

function Write-Log($texto) {
    $hora = Get-Date -Format "HH:mm:ss"
    $txtLog.AppendText("[$hora] $texto`r`n")
    $txtLog.SelectionStart = $txtLog.Text.Length
    $txtLog.ScrollToCaret()
}

# ==============================================================
#  FUNCAO AUXILIAR: cria um checklist com scroll dentro de um painel
# ==============================================================
function New-CheckList {
    param($parent, $x, $y, $w, $h, $itens)
    $panel = New-Object System.Windows.Forms.Panel
    $panel.Location = New-Object System.Drawing.Point($x, $y)
    $panel.Size = New-Object System.Drawing.Size($w, $h)
    $panel.AutoScroll = $true
    $panel.BackColor = $corPainel
    $parent.Controls.Add($panel)

    $checks = @()
    $colWidth = 270
    $colCount = [Math]::Max(1, [Math]::Floor($w / $colWidth))
    $i = 0
    foreach ($item in $itens) {
        $col = $i % $colCount
        $row = [Math]::Floor($i / $colCount)
        $cb = New-Object System.Windows.Forms.CheckBox
        $cb.Text = $item.Nome
        $cb.Tag = $item
        $cb.ForeColor = $corTexto
        $cb.Font = $fonteNormal
        $cb.Location = New-Object System.Drawing.Point((10 + $col * $colWidth), (8 + $row * 26))
        $cb.Size = New-Object System.Drawing.Size(($colWidth - 15), 22)
        $panel.Controls.Add($cb)
        $checks += $cb
        $i++
    }
    return @{ Panel = $panel; Checks = $checks }
}

function Select-All($checks, $valor) {
    foreach ($c in $checks) { $c.Checked = $valor }
}

function New-BotaoPadrao($parent, $texto, $x, $y, $w, $h, $corFundoBtn, $corTextoBtn) {
    $btn = New-Object System.Windows.Forms.Button
    $btn.Text = $texto
    $btn.Location = New-Object System.Drawing.Point($x, $y)
    $btn.Size = New-Object System.Drawing.Size($w, $h)
    $btn.BackColor = $corFundoBtn
    $btn.ForeColor = $corTextoBtn
    $btn.FlatStyle = "Flat"
    $btn.FlatAppearance.BorderSize = 0
    $btn.Font = $fonteNormal
    $parent.Controls.Add($btn)
    return $btn
}

# ==============================================================
#  ABA 1 - INSTALAR APPS (via winget)
# ==============================================================
$appsList = @(
    @{ Nome = "Google Chrome";        Id = "Google.Chrome" }
    @{ Nome = "Mozilla Firefox";      Id = "Mozilla.Firefox" }
    @{ Nome = "Brave Browser";        Id = "Brave.Brave" }
    @{ Nome = "Discord";              Id = "Discord.Discord" }
    @{ Nome = "Telegram";             Id = "Telegram.TelegramDesktop" }
    @{ Nome = "Zoom";                 Id = "Zoom.Zoom" }
    @{ Nome = "Steam";                Id = "Valve.Steam" }
    @{ Nome = "Epic Games Launcher";  Id = "EpicGames.EpicGamesLauncher" }
    @{ Nome = "Battle.net";           Id = "Blizzard.BattleNet" }
    @{ Nome = "Ubisoft Connect";      Id = "Ubisoft.Connect" }
    @{ Nome = "EA App";               Id = "ElectronicArts.EADesktop" }
    @{ Nome = "GOG Galaxy";           Id = "GOG.Galaxy" }
    @{ Nome = "VLC Media Player";     Id = "VideoLAN.VLC" }
    @{ Nome = "7-Zip";                Id = "7zip.7zip" }
    @{ Nome = "WinRAR";               Id = "RARLab.WinRAR" }
    @{ Nome = "Spotify";              Id = "Spotify.Spotify" }
    @{ Nome = "Visual Studio Code";   Id = "Microsoft.VisualStudioCode" }
    @{ Nome = "Notepad++";            Id = "Notepad++.Notepad++" }
    @{ Nome = "Git";                  Id = "Git.Git" }
    @{ Nome = "Python 3";             Id = "Python.Python.3.12" }
    @{ Nome = "Node.js LTS";          Id = "OpenJS.NodeJS.LTS" }
    @{ Nome = "Docker Desktop";       Id = "Docker.DockerDesktop" }
    @{ Nome = "OBS Studio";           Id = "OBSProject.OBSStudio" }
    @{ Nome = "MSI Afterburner";      Id = "Guru3D.Afterburner" }
    @{ Nome = "GeForce Experience";   Id = "Nvidia.GeForceExperience" }
    @{ Nome = "HWiNFO";               Id = "REALiX.HWiNFO" }
    @{ Nome = "CPU-Z";                Id = "CPUID.CPU-Z" }
    @{ Nome = "CrystalDiskInfo";      Id = "CrystalDewWorld.CrystalDiskInfo" }
    @{ Nome = "PowerToys";            Id = "Microsoft.PowerToys" }
    @{ Nome = "Rufus";                Id = "Rufus.Rufus" }
    @{ Nome = "TeamViewer";           Id = "TeamViewer.TeamViewer" }
    @{ Nome = "AnyDesk";              Id = "AnyDeskSoftwareGmbH.AnyDesk" }
    @{ Nome = "qBittorrent";          Id = "qBittorrent.qBittorrent" }
    @{ Nome = "WhatsApp Desktop";     Id = "9NKSQGP7F2NH" }
    @{ Nome = "Malwarebytes";         Id = "Malwarebytes.Malwarebytes" }
)

$lblApps = New-Object System.Windows.Forms.Label
$lblApps.Text = "Selecione os programas para instalar (via winget):"
$lblApps.ForeColor = $corAzulClaro
$lblApps.Font = $fonteSecao
$lblApps.Location = New-Object System.Drawing.Point(10, 10)
$lblApps.AutoSize = $true
$tabApps.Controls.Add($lblApps)

$appsCL = New-CheckList -parent $tabApps -x 10 -y 40 -w 1100 -h 500 -itens $appsList

$btnAppsTodos = New-BotaoPadrao $tabApps "Marcar todos" 10 550 150 34 $corPainel2 $corTexto
$btnAppsTodos.Add_Click({ Select-All $appsCL.Checks $true })

$btnAppsNenhum = New-BotaoPadrao $tabApps "Desmarcar todos" 170 550 150 34 $corPainel2 $corTexto
$btnAppsNenhum.Add_Click({ Select-All $appsCL.Checks $false })

$btnAppsInstalar = New-BotaoPadrao $tabApps "INSTALAR SELECIONADOS" 850 550 260 42 $corAzul ([System.Drawing.Color]::White)
$btnAppsInstalar.Font = $fonteBotao
$btnAppsInstalar.Add_Click({
    $selecionados = $appsCL.Checks | Where-Object { $_.Checked }
    if ($selecionados.Count -eq 0) {
        [System.Windows.Forms.MessageBox]::Show("Nenhum programa selecionado.", "ROMA")
        return
    }
    $tabs.SelectedTab = $tabLog
    $barraProgresso.Maximum = $selecionados.Count
    $barraProgresso.Value = 0
    foreach ($cb in $selecionados) {
        $item = $cb.Tag
        Set-Status "Instalando $($item.Nome)..."
        Write-Log "Instalando $($item.Nome) ($($item.Id))..."
        try {
            Start-Process -FilePath "winget" -ArgumentList "install --id $($item.Id) -e --accept-package-agreements --accept-source-agreements -h" -Wait -NoNewWindow
            Write-Log "  -> $($item.Nome) concluido."
        } catch {
            Write-Log "  -> ERRO ao instalar $($item.Nome): $_"
        }
        $barraProgresso.Value += 1
    }
    Set-Status "Instalacao finalizada."
    Write-Log "=== Instalacao de apps finalizada ==="
})

# ==============================================================
#  ABA 2 - TWEAKS DE SISTEMA
# ==============================================================
$tweaksList = @(
    @{ Nome = "Desativar telemetria do Windows";        Acao = {
        reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f
    }}
    @{ Nome = "Desativar Cortana";                       Acao = {
        reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v AllowCortana /t REG_DWORD /d 0 /f
    }}
    @{ Nome = "Desativar sugestoes/anuncios no menu Iniciar"; Acao = {
        reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SubscribedContent-338388Enabled /t REG_DWORD /d 0 /f
    }}
    @{ Nome = "Desativar Bing na pesquisa do Windows";   Acao = {
        reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v BingSearchEnabled /t REG_DWORD /d 0 /f
    }}
    @{ Nome = "Mostrar extensoes de arquivo";            Acao = {
        reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v HideFileExt /t REG_DWORD /d 0 /f
    }}
    @{ Nome = "Mostrar arquivos e pastas ocultos";       Acao = {
        reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v Hidden /t REG_DWORD /d 1 /f
    }}
    @{ Nome = "Ativar plano de energia Alto Desempenho";  Acao = {
        powercfg -setactive SCHEME_MIN
    }}
    @{ Nome = "Desativar Game DVR / Xbox Game Bar";       Acao = {
        reg add "HKCU\System\GameConfigStore" /v GameDVR_Enabled /t REG_DWORD /d 0 /f
        reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /v AllowGameDVR /t REG_DWORD /d 0 /f
    }}
    @{ Nome = "Desativar efeitos visuais (melhor performance)"; Acao = {
        reg add "HKCU\Control Panel\Desktop" /v UserPreferencesMask /t REG_BINARY /d 9012038010000000 /f
    }}
    @{ Nome = "Desativar notificacoes de dicas do Windows"; Acao = {
        reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SoftLandingEnabled /t REG_DWORD /d 0 /f
    }}
    @{ Nome = "Reduzir delay do menu Iniciar";            Acao = {
        reg add "HKCU\Control Panel\Desktop" /v MenuShowDelay /t REG_SZ /d 0 /f
    }}
    @{ Nome = "Desativar hibernacao";                     Acao = {
        powercfg -hibernate off
    }}
    @{ Nome = "Desativar inicializacao rapida (Fast Startup)"; Acao = {
        reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Power" /v HiberbootEnabled /t REG_DWORD /d 0 /f
    }}
    @{ Nome = "Desativar Historico de Atividades";        Acao = {
        reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v EnableActivityFeed /t REG_DWORD /d 0 /f
        reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v PublishUserActivities /t REG_DWORD /d 0 /f
    }}
    @{ Nome = "Desativar rastreamento de localizacao";    Acao = {
        reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" /v Value /t REG_SZ /d Deny /f
    }}
    @{ Nome = "Desativar aceleracao do ponteiro do mouse"; Acao = {
        reg add "HKCU\Control Panel\Mouse" /v MouseSpeed /t REG_SZ /d 0 /f
        reg add "HKCU\Control Panel\Mouse" /v MouseThreshold1 /t REG_SZ /d 0 /f
        reg add "HKCU\Control Panel\Mouse" /v MouseThreshold2 /t REG_SZ /d 0 /f
    }}
    @{ Nome = "Ativar modo escuro (apps e sistema)";      Acao = {
        reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v AppsUseLightTheme /t REG_DWORD /d 0 /f
        reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v SystemUsesLightTheme /t REG_DWORD /d 0 /f
    }}
    @{ Nome = "Desativar apps em segundo plano";          Acao = {
        reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v GlobalUserDisabled /t REG_DWORD /d 1 /f
    }}
    @{ Nome = "Desativar Widgets (Windows 11)";           Acao = {
        reg add "HKLM\SOFTWARE\Policies\Microsoft\Dsh" /v AllowNewsAndInterests /t REG_DWORD /d 0 /f
    }}
    @{ Nome = "Desativar teclas de aderencia (Sticky Keys)"; Acao = {
        reg add "HKCU\Control Panel\Accessibility\StickyKeys" /v Flags /t REG_SZ /d 506 /f
    }}
    @{ Nome = "Limpar arquivos temporarios";              Acao = {
        Remove-Item -Path "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue
    }}
)

$lblTweaks = New-Object System.Windows.Forms.Label
$lblTweaks.Text = "Selecione os tweaks que deseja aplicar:"
$lblTweaks.ForeColor = $corAzulClaro
$lblTweaks.Font = $fonteSecao
$lblTweaks.Location = New-Object System.Drawing.Point(10, 10)
$lblTweaks.AutoSize = $true
$tabTweaks.Controls.Add($lblTweaks)

$tweaksCL = New-CheckList -parent $tabTweaks -x 10 -y 40 -w 1100 -h 500 -itens $tweaksList

$btnTweaksTodos = New-BotaoPadrao $tabTweaks "Marcar todos" 10 550 150 34 $corPainel2 $corTexto
$btnTweaksTodos.Add_Click({ Select-All $tweaksCL.Checks $true })

$btnTweaksNenhum = New-BotaoPadrao $tabTweaks "Desmarcar todos" 170 550 150 34 $corPainel2 $corTexto
$btnTweaksNenhum.Add_Click({ Select-All $tweaksCL.Checks $false })

$btnTweaksAplicar = New-BotaoPadrao $tabTweaks "APLICAR TWEAKS" 850 550 260 42 $corAzul ([System.Drawing.Color]::White)
$btnTweaksAplicar.Font = $fonteBotao
$btnTweaksAplicar.Add_Click({
    $selecionados = $tweaksCL.Checks | Where-Object { $_.Checked }
    if ($selecionados.Count -eq 0) {
        [System.Windows.Forms.MessageBox]::Show("Nenhum tweak selecionado.", "ROMA")
        return
    }
    $tabs.SelectedTab = $tabLog
    $barraProgresso.Maximum = $selecionados.Count
    $barraProgresso.Value = 0
    foreach ($cb in $selecionados) {
        $item = $cb.Tag
        Set-Status "Aplicando: $($item.Nome)..."
        Write-Log "Aplicando: $($item.Nome)"
        try {
            & $item.Acao
            Write-Log "  -> OK"
        } catch {
            Write-Log "  -> ERRO: $_"
        }
        $barraProgresso.Value += 1
    }
    Set-Status "Tweaks aplicados."
    Write-Log "=== Tweaks finalizados ==="
})

# ==============================================================
#  ABA 3 - DEBLOAT (remover apps pre-instalados)
# ==============================================================
$debloatList = @(
    @{ Nome = "3D Builder";              Id = "Microsoft.3DBuilder" }
    @{ Nome = "Clima (BingWeather)";     Id = "Microsoft.BingWeather" }
    @{ Nome = "Obter Ajuda";             Id = "Microsoft.GetHelp" }
    @{ Nome = "Introducao (Getstarted)"; Id = "Microsoft.Getstarted" }
    @{ Nome = "Mensagens (Messaging)";   Id = "Microsoft.Messaging" }
    @{ Nome = "Visualizador 3D";         Id = "Microsoft.Microsoft3DViewer" }
    @{ Nome = "Office Hub";              Id = "Microsoft.MicrosoftOfficeHub" }
    @{ Nome = "Solitaire Collection";    Id = "Microsoft.MicrosoftSolitaireCollection" }
    @{ Nome = "Mixed Reality Portal";    Id = "Microsoft.MixedReality.Portal" }
    @{ Nome = "OneConnect";              Id = "Microsoft.OneConnect" }
    @{ Nome = "Pessoas (People)";        Id = "Microsoft.People" }
    @{ Nome = "Print 3D";                Id = "Microsoft.Print3D" }
    @{ Nome = "Skype";                   Id = "Microsoft.SkypeApp" }
    @{ Nome = "Microsoft Teams (pessoal)"; Id = "MicrosoftTeams" }
    @{ Nome = "Carteira (Wallet)";       Id = "Microsoft.Wallet" }
    @{ Nome = "Alarmes e Relogio";       Id = "Microsoft.WindowsAlarms" }
    @{ Nome = "Camera";                  Id = "Microsoft.WindowsCamera" }
    @{ Nome = "Correio e Calendario";    Id = "microsoft.windowscommunicationsapps" }
    @{ Nome = "Feedback Hub";            Id = "Microsoft.WindowsFeedbackHub" }
    @{ Nome = "Mapas";                   Id = "Microsoft.WindowsMaps" }
    @{ Nome = "Gravador de Som";         Id = "Microsoft.WindowsSoundRecorder" }
    @{ Nome = "Xbox TCUI";               Id = "Microsoft.Xbox.TCUI" }
    @{ Nome = "Xbox App";                Id = "Microsoft.XboxApp" }
    @{ Nome = "Xbox Game Overlay";       Id = "Microsoft.XboxGameOverlay" }
    @{ Nome = "Xbox Gaming Overlay";     Id = "Microsoft.XboxGamingOverlay" }
    @{ Nome = "Xbox Identity Provider";  Id = "Microsoft.XboxIdentityProvider" }
    @{ Nome = "Xbox Speech To Text";     Id = "Microsoft.XboxSpeechToTextOverlay" }
    @{ Nome = "Seu Telefone (YourPhone)"; Id = "Microsoft.YourPhone" }
    @{ Nome = "Groove Musica (ZuneMusic)"; Id = "Microsoft.ZuneMusic" }
    @{ Nome = "Filmes e TV (ZuneVideo)"; Id = "Microsoft.ZuneVideo" }
    @{ Nome = "Clipchamp";               Id = "Clipchamp.Clipchamp" }
)

$lblDebloat = New-Object System.Windows.Forms.Label
$lblDebloat.Text = "Selecione os aplicativos pre-instalados para remover:"
$lblDebloat.ForeColor = $corAzulClaro
$lblDebloat.Font = $fonteSecao
$lblDebloat.Location = New-Object System.Drawing.Point(10, 10)
$lblDebloat.AutoSize = $true
$tabDebloat.Controls.Add($lblDebloat)

$debloatCL = New-CheckList -parent $tabDebloat -x 10 -y 40 -w 1100 -h 500 -itens $debloatList

$btnDebloatTodos = New-BotaoPadrao $tabDebloat "Marcar todos" 10 550 150 34 $corPainel2 $corTexto
$btnDebloatTodos.Add_Click({ Select-All $debloatCL.Checks $true })

$btnDebloatNenhum = New-BotaoPadrao $tabDebloat "Desmarcar todos" 170 550 150 34 $corPainel2 $corTexto
$btnDebloatNenhum.Add_Click({ Select-All $debloatCL.Checks $false })

$btnDebloatRemover = New-BotaoPadrao $tabDebloat "REMOVER SELECIONADOS" 850 550 260 42 $corVermelho ([System.Drawing.Color]::White)
$btnDebloatRemover.Font = $fonteBotao
$btnDebloatRemover.Add_Click({
    $selecionados = $debloatCL.Checks | Where-Object { $_.Checked }
    if ($selecionados.Count -eq 0) {
        [System.Windows.Forms.MessageBox]::Show("Nenhum aplicativo selecionado.", "ROMA")
        return
    }
    $confirmar = [System.Windows.Forms.MessageBox]::Show("Remover $($selecionados.Count) aplicativo(s) pre-instalado(s)?", "ROMA", "YesNo", "Warning")
    if ($confirmar -ne "Yes") { return }
    $tabs.SelectedTab = $tabLog
    $barraProgresso.Maximum = $selecionados.Count
    $barraProgresso.Value = 0
    foreach ($cb in $selecionados) {
        $item = $cb.Tag
        Set-Status "Removendo $($item.Nome)..."
        Write-Log "Removendo $($item.Nome) ($($item.Id))..."
        try {
            Get-AppxPackage -Name $item.Id -AllUsers -ErrorAction SilentlyContinue | Remove-AppxPackage -ErrorAction SilentlyContinue
            Get-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue | Where-Object { $_.DisplayName -eq $item.Id } | Remove-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue | Out-Null
            Write-Log "  -> $($item.Nome) removido."
        } catch {
            Write-Log "  -> ERRO ao remover $($item.Nome): $_"
        }
        $barraProgresso.Value += 1
    }
    Set-Status "Debloat finalizado."
    Write-Log "=== Debloat finalizado ==="
})

# ==============================================================
#  ABA 4 - SERVICOS (desativar servicos desnecessarios)
# ==============================================================
$servicosList = @(
    @{ Nome = "DiagTrack (Telemetria)";           Servico = "DiagTrack" }
    @{ Nome = "dmwappushservice";                  Servico = "dmwappushservice" }
    @{ Nome = "SysMain (Superfetch)";              Servico = "SysMain" }
    @{ Nome = "Windows Error Reporting";           Servico = "WerSvc" }
    @{ Nome = "Retail Demo Service";               Servico = "RetailDemo" }
    @{ Nome = "Fax";                                Servico = "Fax" }
    @{ Nome = "Registro Remoto";                    Servico = "RemoteRegistry" }
    @{ Nome = "Maps Broker";                        Servico = "MapsBroker" }
    @{ Nome = "Windows Media Player Network";       Servico = "WMPNetworkSvc" }
    @{ Nome = "Print Notify (sem impressora)";      Servico = "PrintNotify" }
    @{ Nome = "Xbox Auth Manager";                  Servico = "XblAuthManager" }
    @{ Nome = "Xbox Game Save";                     Servico = "XblGameSave" }
    @{ Nome = "Xbox Live Networking";               Servico = "XboxNetApiSvc" }
    @{ Nome = "Superfetch/SysMain (compatibilidade)"; Servico = "SysMain" }
    @{ Nome = "Servico de Biometria";               Servico = "WbioSrvc" }
)

$lblServicos = New-Object System.Windows.Forms.Label
$lblServicos.Text = "Selecione os servicos do Windows para desativar:"
$lblServicos.ForeColor = $corAzulClaro
$lblServicos.Font = $fonteSecao
$lblServicos.Location = New-Object System.Drawing.Point(10, 10)
$lblServicos.AutoSize = $true
$tabServicos.Controls.Add($lblServicos)

$servicosCL = New-CheckList -parent $tabServicos -x 10 -y 40 -w 1100 -h 500 -itens $servicosList

$btnServicosTodos = New-BotaoPadrao $tabServicos "Marcar todos" 10 550 150 34 $corPainel2 $corTexto
$btnServicosTodos.Add_Click({ Select-All $servicosCL.Checks $true })

$btnServicosNenhum = New-BotaoPadrao $tabServicos "Desmarcar todos" 170 550 150 34 $corPainel2 $corTexto
$btnServicosNenhum.Add_Click({ Select-All $servicosCL.Checks $false })

$btnServicosAplicar = New-BotaoPadrao $tabServicos "DESATIVAR SELECIONADOS" 850 550 260 42 $corVermelho ([System.Drawing.Color]::White)
$btnServicosAplicar.Font = $fonteBotao
$btnServicosAplicar.Add_Click({
    $selecionados = $servicosCL.Checks | Where-Object { $_.Checked }
    if ($selecionados.Count -eq 0) {
        [System.Windows.Forms.MessageBox]::Show("Nenhum servico selecionado.", "ROMA")
        return
    }
    $tabs.SelectedTab = $tabLog
    $barraProgresso.Maximum = $selecionados.Count
    $barraProgresso.Value = 0
    foreach ($cb in $selecionados) {
        $item = $cb.Tag
        Set-Status "Desativando $($item.Nome)..."
        Write-Log "Desativando servico: $($item.Nome) ($($item.Servico))"
        try {
            Stop-Service -Name $item.Servico -Force -ErrorAction SilentlyContinue
            Set-Service -Name $item.Servico -StartupType Disabled -ErrorAction SilentlyContinue
            Write-Log "  -> OK"
        } catch {
            Write-Log "  -> ERRO: $_"
        }
        $barraProgresso.Value += 1
    }
    Set-Status "Servicos atualizados."
    Write-Log "=== Ajuste de servicos finalizado ==="
})

# ==============================================================
#  ABA 5 - PRIORIDADE DE JOGOS (Image File Execution Options)
# ==============================================================
$gamesList = @(
    @{ Nome = "Fortnite";               Exe = "FortniteClient-Win64-Shipping.exe" }
    @{ Nome = "GTA V";                  Exe = "GTA5.exe" }
    @{ Nome = "FiveM";                  Exe = "FiveM.exe" }
    @{ Nome = "CS2";                    Exe = "cs2.exe" }
    @{ Nome = "Minecraft";              Exe = "javaw.exe" }
    @{ Nome = "Valorant";               Exe = "VALORANT-Win64-Shipping.exe" }
    @{ Nome = "League of Legends";      Exe = "League of Legends.exe" }
    @{ Nome = "Apex Legends";           Exe = "r5apex.exe" }
    @{ Nome = "PUBG";                   Exe = "TslGame.exe" }
    @{ Nome = "Rainbow Six Siege";      Exe = "RainbowSix.exe" }
    @{ Nome = "Free Fire (Emulador)";   Exe = "HD-Player.exe" }
    @{ Nome = "Resident Evil Village";  Exe = "re8.exe" }
    @{ Nome = "Roblox";                 Exe = "RobloxPlayerBeta.exe" }
    @{ Nome = "Genshin Impact";         Exe = "GenshinImpact.exe" }
    @{ Nome = "Call of Duty (Warzone)"; Exe = "cod.exe" }
    @{ Nome = "Dota 2";                 Exe = "dota2.exe" }
    @{ Nome = "Overwatch 2";            Exe = "Overwatch.exe" }
    @{ Nome = "Rocket League";          Exe = "RocketLeague.exe" }
    @{ Nome = "Rust";                   Exe = "RustClient.exe" }
    @{ Nome = "ARK Survival Evolved";   Exe = "ShooterGame.exe" }
    @{ Nome = "Escape from Tarkov";     Exe = "EscapeFromTarkov.exe" }
    @{ Nome = "Elden Ring";             Exe = "eldenring.exe" }
    @{ Nome = "Cyberpunk 2077";         Exe = "Cyberpunk2077.exe" }
    @{ Nome = "The Sims 4";             Exe = "TS4_x64.exe" }
    @{ Nome = "World of Warcraft";      Exe = "Wow.exe" }
)

$lblGames = New-Object System.Windows.Forms.Label
$lblGames.Text = "Selecione os jogos para aumentar a prioridade de CPU:"
$lblGames.ForeColor = $corAzulClaro
$lblGames.Font = $fonteSecao
$lblGames.Location = New-Object System.Drawing.Point(10, 10)
$lblGames.AutoSize = $true
$tabGames.Controls.Add($lblGames)

$gamesCL = New-CheckList -parent $tabGames -x 10 -y 40 -w 1100 -h 500 -itens $gamesList

$btnGamesTodos = New-BotaoPadrao $tabGames "Marcar todos" 10 550 150 34 $corPainel2 $corTexto
$btnGamesTodos.Add_Click({ Select-All $gamesCL.Checks $true })

$btnGamesNenhum = New-BotaoPadrao $tabGames "Desmarcar todos" 170 550 150 34 $corPainel2 $corTexto
$btnGamesNenhum.Add_Click({ Select-All $gamesCL.Checks $false })

$btnGamesAplicar = New-BotaoPadrao $tabGames "AUMENTAR PRIORIDADE" 850 550 260 42 $corAzul ([System.Drawing.Color]::White)
$btnGamesAplicar.Font = $fonteBotao
$btnGamesAplicar.Add_Click({
    $selecionados = $gamesCL.Checks | Where-Object { $_.Checked }
    if ($selecionados.Count -eq 0) {
        [System.Windows.Forms.MessageBox]::Show("Nenhum jogo selecionado.", "ROMA")
        return
    }
    $tabs.SelectedTab = $tabLog
    $barraProgresso.Maximum = $selecionados.Count
    $barraProgresso.Value = 0
    foreach ($cb in $selecionados) {
        $item = $cb.Tag
        $chave = "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\$($item.Exe)"
        Set-Status "Priorizando $($item.Nome)..."
        Write-Log "Aumentando prioridade: $($item.Nome) ($($item.Exe))"
        try {
            reg add "$chave" /f | Out-Null
            reg add "$chave\PerfOptions" /f | Out-Null
            reg add "$chave\PerfOptions" /v CpuPriorityClass /t REG_DWORD /d 3 /f | Out-Null
            Write-Log "  -> OK"
        } catch {
            Write-Log "  -> ERRO: $_"
        }
        $barraProgresso.Value += 1
    }
    Set-Status "Prioridades aplicadas."
    Write-Log "=== Prioridade de jogos finalizada ==="
})

# ==============================================================
#  ABA 6 - REDE
# ==============================================================
$lblRede = New-Object System.Windows.Forms.Label
$lblRede.Text = "Ferramentas de rede e DNS:"
$lblRede.ForeColor = $corAzulClaro
$lblRede.Font = $fonteSecao
$lblRede.Location = New-Object System.Drawing.Point(10, 10)
$lblRede.AutoSize = $true
$tabRede.Controls.Add($lblRede)

function Get-AdaptadorAtivo {
    return Get-NetAdapter -ErrorAction SilentlyContinue | Where-Object { $_.Status -eq "Up" } | Select-Object -First 1
}

$btnFlushDns = New-BotaoPadrao $tabRede "Limpar cache DNS" 10 45 350 42 $corPainel2 $corTexto
$btnFlushDns.TextAlign = "MiddleLeft"
$btnFlushDns.Add_Click({
    Set-Status "Limpando cache DNS..."
    Write-Log "Executando ipconfig /flushdns ..."
    ipconfig /flushdns | Out-Null
    Write-Log "Cache DNS limpo."
    Set-Status "Pronto."
})

$btnWinsock = New-BotaoPadrao $tabRede "Resetar Winsock" 10 95 350 42 $corPainel2 $corTexto
$btnWinsock.TextAlign = "MiddleLeft"
$btnWinsock.Add_Click({
    Set-Status "Resetando Winsock..."
    Write-Log "Executando netsh winsock reset ..."
    netsh winsock reset | Out-Null
    Write-Log "Winsock resetado. Reinicie o computador."
    Set-Status "Pronto (reinicie o PC)."
})

$btnTcpIp = New-BotaoPadrao $tabRede "Resetar TCP/IP" 10 145 350 42 $corPainel2 $corTexto
$btnTcpIp.TextAlign = "MiddleLeft"
$btnTcpIp.Add_Click({
    Set-Status "Resetando TCP/IP..."
    Write-Log "Executando netsh int ip reset ..."
    netsh int ip reset | Out-Null
    Write-Log "TCP/IP resetado. Reinicie o computador."
    Set-Status "Pronto (reinicie o PC)."
})

$btnRenovarIp = New-BotaoPadrao $tabRede "Liberar e renovar IP" 10 195 350 42 $corPainel2 $corTexto
$btnRenovarIp.TextAlign = "MiddleLeft"
$btnRenovarIp.Add_Click({
    Set-Status "Renovando IP..."
    Write-Log "Executando ipconfig /release e /renew ..."
    ipconfig /release | Out-Null
    ipconfig /renew | Out-Null
    Write-Log "IP renovado."
    Set-Status "Pronto."
})

$btnDnsCloudflare = New-BotaoPadrao $tabRede "Definir DNS Cloudflare (1.1.1.1)" 10 245 350 42 $corPainel2 $corTexto
$btnDnsCloudflare.TextAlign = "MiddleLeft"
$btnDnsCloudflare.Add_Click({
    $adaptador = Get-AdaptadorAtivo
    if (-not $adaptador) { Write-Log "Nenhum adaptador de rede ativo encontrado."; return }
    Set-Status "Configurando DNS Cloudflare..."
    Write-Log "Definindo DNS 1.1.1.1 / 1.0.0.1 no adaptador $($adaptador.Name)..."
    Set-DnsClientServerAddress -InterfaceIndex $adaptador.ifIndex -ServerAddresses ("1.1.1.1", "1.0.0.1")
    Write-Log "DNS Cloudflare configurado."
    Set-Status "Pronto."
})

$btnDnsGoogle = New-BotaoPadrao $tabRede "Definir DNS Google (8.8.8.8)" 10 295 350 42 $corPainel2 $corTexto
$btnDnsGoogle.TextAlign = "MiddleLeft"
$btnDnsGoogle.Add_Click({
    $adaptador = Get-AdaptadorAtivo
    if (-not $adaptador) { Write-Log "Nenhum adaptador de rede ativo encontrado."; return }
    Set-Status "Configurando DNS Google..."
    Write-Log "Definindo DNS 8.8.8.8 / 8.8.4.4 no adaptador $($adaptador.Name)..."
    Set-DnsClientServerAddress -InterfaceIndex $adaptador.ifIndex -ServerAddresses ("8.8.8.8", "8.8.4.4")
    Write-Log "DNS Google configurado."
    Set-Status "Pronto."
})

$btnDnsAuto = New-BotaoPadrao $tabRede "Restaurar DNS automatico (DHCP)" 10 345 350 42 $corPainel2 $corTexto
$btnDnsAuto.TextAlign = "MiddleLeft"
$btnDnsAuto.Add_Click({
    $adaptador = Get-AdaptadorAtivo
    if (-not $adaptador) { Write-Log "Nenhum adaptador de rede ativo encontrado."; return }
    Set-Status "Restaurando DNS automatico..."
    Write-Log "Restaurando DNS automatico no adaptador $($adaptador.Name)..."
    Set-DnsClientServerAddress -InterfaceIndex $adaptador.ifIndex -ResetServerAddresses
    Write-Log "DNS automatico restaurado."
    Set-Status "Pronto."
})

# ==============================================================
#  ABA 7 - SISTEMA
# ==============================================================
$lblSistema = New-Object System.Windows.Forms.Label
$lblSistema.Text = "Informacoes e manutencao do sistema:"
$lblSistema.ForeColor = $corAzulClaro
$lblSistema.Font = $fonteSecao
$lblSistema.Location = New-Object System.Drawing.Point(10, 10)
$lblSistema.AutoSize = $true
$tabSistema.Controls.Add($lblSistema)

$txtInfoSistema = New-Object System.Windows.Forms.TextBox
$txtInfoSistema.Multiline = $true
$txtInfoSistema.ReadOnly = $true
$txtInfoSistema.ScrollBars = "Vertical"
$txtInfoSistema.BackColor = $corPainel
$txtInfoSistema.ForeColor = $corTexto
$txtInfoSistema.Font = New-Object System.Drawing.Font("Consolas", 9)
$txtInfoSistema.Location = New-Object System.Drawing.Point(10, 45)
$txtInfoSistema.Size = New-Object System.Drawing.Size(700, 300)
$tabSistema.Controls.Add($txtInfoSistema)

$btnAtualizarInfo = New-BotaoPadrao $tabSistema "Atualizar informacoes" 730 45 370 40 $corPainel2 $corTexto
$btnAtualizarInfo.Add_Click({
    try {
        $os = Get-CimInstance Win32_OperatingSystem
        $cpu = Get-CimInstance Win32_Processor | Select-Object -First 1
        $ram = [Math]::Round($os.TotalVisibleMemorySize / 1MB, 1)
        $ramLivre = [Math]::Round($os.FreePhysicalMemory / 1MB, 1)
        $disco = Get-CimInstance Win32_LogicalDisk -Filter "DeviceID='C:'"
        $discoLivre = [Math]::Round($disco.FreeSpace / 1GB, 1)
        $discoTotal = [Math]::Round($disco.Size / 1GB, 1)
        $texto = "Sistema Operacional: $($os.Caption) (Build $($os.BuildNumber))`r`n"
        $texto += "Processador: $($cpu.Name)`r`n"
        $texto += "Memoria RAM total: $ram GB   |   Livre: $ramLivre GB`r`n"
        $texto += "Disco C: total $discoTotal GB   |   Livre: $discoLivre GB`r`n"
        $texto += "Nome do computador: $($env:COMPUTERNAME)`r`n"
        $texto += "Usuario: $($env:USERNAME)"
        $txtInfoSistema.Text = $texto
    } catch {
        $txtInfoSistema.Text = "Erro ao obter informacoes: $_"
    }
})

New-BotaoPadrao $tabSistema "Abrir Configuracoes do Windows Update" 10 365 400 40 $corPainel2 $corTexto | ForEach-Object {
    $_.Add_Click({ Start-Process "ms-settings:windowsupdate" })
}

New-BotaoPadrao $tabSistema "Abrir Gerenciador de Dispositivos" 10 415 400 40 $corPainel2 $corTexto | ForEach-Object {
    $_.Add_Click({ Start-Process "devmgmt.msc" })
}

New-BotaoPadrao $tabSistema "Abrir Configuracoes do Sistema" 10 465 400 40 $corPainel2 $corTexto | ForEach-Object {
    $_.Add_Click({ Start-Process "ms-settings:about" })
}

New-BotaoPadrao $tabSistema "Pausar atualizacoes automaticas (7 dias)" 430 365 400 40 $corPainel2 $corTexto | ForEach-Object {
    $_.Add_Click({
        Set-Status "Pausando atualizacoes..."
        Write-Log "Pausando atualizacoes do Windows por 7 dias..."
        $pauseAte = (Get-Date).AddDays(7).ToString("yyyy-MM-dd")
        reg add "HKLM\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" /v PauseUpdatesExpiryTime /t REG_SZ /d "$pauseAte" /f | Out-Null
        Write-Log "Atualizacoes pausadas ate $pauseAte."
        Set-Status "Pronto."
    })
}

New-BotaoPadrao $tabSistema "Criar Ponto de Restauracao" 430 415 400 40 $corPainel2 $corTexto | ForEach-Object {
    $_.Add_Click({
        Set-Status "Criando ponto de restauracao..."
        Write-Log "Criando ponto de restauracao 'ROMA - Antes dos Tweaks'..."
        try {
            Checkpoint-Computer -Description "ROMA - Antes dos Tweaks" -RestorePointType "MODIFY_SETTINGS"
            Write-Log "Ponto de restauracao criado com sucesso."
        } catch {
            Write-Log "ERRO ao criar ponto de restauracao: $_"
        }
        Set-Status "Pronto."
    })
}

New-BotaoPadrao $tabSistema "Executar SFC /scannow" 430 465 400 40 $corPainel2 $corTexto | ForEach-Object {
    $_.Add_Click({
        $tabs.SelectedTab = $tabLog
        Set-Status "Executando SFC..."
        Write-Log "Executando sfc /scannow (isso pode demorar alguns minutos)..."
        Start-Process "sfc" -ArgumentList "/scannow" -Wait -NoNewWindow
        Write-Log "SFC finalizado."
        Set-Status "Pronto."
    })
}

# ==============================================================
#  ABA 8 - LIMPEZA
# ==============================================================
$lblLimpeza = New-Object System.Windows.Forms.Label
$lblLimpeza.Text = "Ferramentas de limpeza e manutencao:"
$lblLimpeza.ForeColor = $corAzulClaro
$lblLimpeza.Font = $fonteSecao
$lblLimpeza.Location = New-Object System.Drawing.Point(10, 10)
$lblLimpeza.AutoSize = $true
$tabLimpeza.Controls.Add($lblLimpeza)

function New-BotaoLimpeza($texto, $y, $acao) {
    $btn = New-BotaoPadrao $tabLimpeza $texto 10 $y 450 42 $corPainel2 $corTexto
    $btn.TextAlign = "MiddleLeft"
    $btn.Padding = New-Object System.Windows.Forms.Padding(10, 0, 0, 0)
    $btn.Add_Click($acao)
}

New-BotaoLimpeza "Limpar arquivos temporarios" 45 {
    Set-Status "Limpando temporarios..."
    Write-Log "Limpando pasta TEMP..."
    Remove-Item -Path "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item -Path "C:\Windows\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue
    Write-Log "Temporarios limpos."
    Set-Status "Pronto."
}

New-BotaoLimpeza "Esvaziar Lixeira" 95 {
    Set-Status "Esvaziando lixeira..."
    Write-Log "Esvaziando a Lixeira..."
    Clear-RecycleBin -Force -ErrorAction SilentlyContinue
    Write-Log "Lixeira esvaziada."
    Set-Status "Pronto."
}

New-BotaoLimpeza "Limpar cache do Windows Update" 145 {
    Set-Status "Limpando cache do Update..."
    Write-Log "Parando servico wuauserv e limpando SoftwareDistribution..."
    Stop-Service -Name wuauserv -Force -ErrorAction SilentlyContinue
    Remove-Item -Path "C:\Windows\SoftwareDistribution\*" -Recurse -Force -ErrorAction SilentlyContinue
    Start-Service -Name wuauserv -ErrorAction SilentlyContinue
    Write-Log "Cache do Windows Update limpo."
    Set-Status "Pronto."
}

New-BotaoLimpeza "Executar Liberador de Espaco (cleanmgr)" 195 {
    Set-Status "Abrindo Liberador de Espaco..."
    Write-Log "Executando cleanmgr /sagerun:1 ..."
    Start-Process "cleanmgr" -ArgumentList "/sagerun:1"
}

New-BotaoLimpeza "Limpar cache de miniaturas (thumbnails)" 245 {
    Set-Status "Limpando cache de miniaturas..."
    Write-Log "Limpando cache de thumbnails..."
    Stop-Process -Name explorer -Force -ErrorAction SilentlyContinue
    Remove-Item -Path "$env:LOCALAPPDATA\Microsoft\Windows\Explorer\thumbcache_*.db" -Force -ErrorAction SilentlyContinue
    Start-Process explorer
    Write-Log "Cache de miniaturas limpo."
    Set-Status "Pronto."
}

New-BotaoLimpeza "Limpar arquivos de prefetch" 295 {
    Set-Status "Limpando prefetch..."
    Write-Log "Limpando C:\Windows\Prefetch..."
    Remove-Item -Path "C:\Windows\Prefetch\*" -Recurse -Force -ErrorAction SilentlyContinue
    Write-Log "Prefetch limpo."
    Set-Status "Pronto."
}

New-BotaoLimpeza "Criar Ponto de Restauracao" 345 {
    Set-Status "Criando ponto de restauracao..."
    Write-Log "Criando ponto de restauracao 'ROMA - Antes dos Tweaks'..."
    try {
        Checkpoint-Computer -Description "ROMA - Antes dos Tweaks" -RestorePointType "MODIFY_SETTINGS"
        Write-Log "Ponto de restauracao criado com sucesso."
    } catch {
        Write-Log "ERRO ao criar ponto de restauracao: $_"
    }
    Set-Status "Pronto."
}

# ==============================================================
#  RODAPE
# ==============================================================
$rodape = New-Object System.Windows.Forms.Label
$rodape.Text = "ROMA - Rode como Administrador. Sempre crie um ponto de restauracao antes de aplicar tweaks."
$rodape.ForeColor = $corTextoMuted
$rodape.Font = $fonteSub
$rodape.Location = New-Object System.Drawing.Point(15, 760)
$rodape.AutoSize = $true
$form.Controls.Add($rodape)

Write-Log "ROMA iniciado. Pronto para uso."

[System.Windows.Forms.Application]::Run($form)
