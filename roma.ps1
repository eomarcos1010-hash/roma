#Requires -RunAsAdministrator
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# ============================================================
#                        R O M A
#     Utilitario de Otimizacao e Performance para Windows
# ============================================================

[System.Windows.Forms.Application]::EnableVisualStyles()

# ---------- Paleta de cores (tema fogo) ----------
$corFundo      = [System.Drawing.Color]::FromArgb(18, 12, 12)
$corPainel     = [System.Drawing.Color]::FromArgb(28, 18, 16)
$corVermelho   = [System.Drawing.Color]::FromArgb(220, 40, 30)
$corLaranja    = [System.Drawing.Color]::FromArgb(255, 110, 30)
$corAmarelo    = [System.Drawing.Color]::FromArgb(255, 190, 60)
$corTexto      = [System.Drawing.Color]::FromArgb(240, 230, 225)
$corTextoMuted = [System.Drawing.Color]::FromArgb(180, 150, 140)
$fonteTitulo   = New-Object System.Drawing.Font("Segoe UI", 20, [System.Drawing.FontStyle]::Bold)
$fonteSub      = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Italic)
$fonteNormal   = New-Object System.Drawing.Font("Segoe UI", 9)
$fonteBotao    = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)

# ---------- Janela principal ----------
$form = New-Object System.Windows.Forms.Form
$form.Text = "ROMA - Otimizador Windows"
$form.Size = New-Object System.Drawing.Size(980, 700)
$form.StartPosition = "CenterScreen"
$form.BackColor = $corFundo
$form.ForeColor = $corTexto
$form.FormBorderStyle = "FixedSingle"
$form.MaximizeBox = $false

# ---------- Cabecalho ----------
$header = New-Object System.Windows.Forms.Panel
$header.Size = New-Object System.Drawing.Size(980, 80)
$header.Location = New-Object System.Drawing.Point(0, 0)
$header.BackColor = $corPainel
$form.Controls.Add($header)

$titulo = New-Object System.Windows.Forms.Label
$titulo.Text = "ROMA"
$titulo.Font = $fonteTitulo
$titulo.ForeColor = $corVermelho
$titulo.Location = New-Object System.Drawing.Point(20, 12)
$titulo.AutoSize = $true
$header.Controls.Add($titulo)

$subtitulo = New-Object System.Windows.Forms.Label
$subtitulo.Text = "Otimizacao, performance e prioridade de jogos"
$subtitulo.Font = $fonteSub
$subtitulo.ForeColor = $corTextoMuted
$subtitulo.Location = New-Object System.Drawing.Point(24, 48)
$subtitulo.AutoSize = $true
$header.Controls.Add($subtitulo)

$lblStatus = New-Object System.Windows.Forms.Label
$lblStatus.Text = "Pronto."
$lblStatus.ForeColor = $corLaranja
$lblStatus.Font = $fonteNormal
$lblStatus.Location = New-Object System.Drawing.Point(650, 30)
$lblStatus.Size = New-Object System.Drawing.Size(310, 20)
$lblStatus.TextAlign = "MiddleRight"
$header.Controls.Add($lblStatus)

function Set-Status($texto) {
    $lblStatus.Text = $texto
    $form.Refresh()
}

# ---------- Abas ----------
$tabs = New-Object System.Windows.Forms.TabControl
$tabs.Location = New-Object System.Drawing.Point(10, 90)
$tabs.Size = New-Object System.Drawing.Size(960, 560)
$tabs.Font = $fonteNormal
$form.Controls.Add($tabs)

$tabApps    = New-Object System.Windows.Forms.TabPage; $tabApps.Text = "  Instalar Apps  "
$tabTweaks  = New-Object System.Windows.Forms.TabPage; $tabTweaks.Text = "  Tweaks  "
$tabGames   = New-Object System.Windows.Forms.TabPage; $tabGames.Text = "  Prioridade de Jogos  "
$tabLimpeza = New-Object System.Windows.Forms.TabPage; $tabLimpeza.Text = "  Limpeza  "
$tabLog     = New-Object System.Windows.Forms.TabPage; $tabLog.Text = "  Log  "
foreach ($t in @($tabApps, $tabTweaks, $tabGames, $tabLimpeza, $tabLog)) {
    $t.BackColor = $corFundo
    $t.ForeColor = $corTexto
    $tabs.Controls.Add($t)
}

# ---------- Caixa de log (compartilhada) ----------
$txtLog = New-Object System.Windows.Forms.TextBox
$txtLog.Multiline = $true
$txtLog.ScrollBars = "Vertical"
$txtLog.ReadOnly = $true
$txtLog.BackColor = [System.Drawing.Color]::FromArgb(10, 8, 8)
$txtLog.ForeColor = $corAmarelo
$txtLog.Font = New-Object System.Drawing.Font("Consolas", 9)
$txtLog.Location = New-Object System.Drawing.Point(10, 10)
$txtLog.Size = New-Object System.Drawing.Size(930, 500)
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
    $colWidth = 300
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

# ==============================================================
#  ABA 1 - INSTALAR APPS (via winget)
# ==============================================================
$appsList = @(
    @{ Nome = "Google Chrome";        Id = "Google.Chrome" }
    @{ Nome = "Mozilla Firefox";      Id = "Mozilla.Firefox" }
    @{ Nome = "Discord";              Id = "Discord.Discord" }
    @{ Nome = "Steam";                Id = "Valve.Steam" }
    @{ Nome = "Epic Games Launcher";  Id = "EpicGames.EpicGamesLauncher" }
    @{ Nome = "VLC Media Player";     Id = "VideoLAN.VLC" }
    @{ Nome = "7-Zip";                Id = "7zip.7zip" }
    @{ Nome = "Spotify";              Id = "Spotify.Spotify" }
    @{ Nome = "Visual Studio Code";   Id = "Microsoft.VisualStudioCode" }
    @{ Nome = "Notepad++";            Id = "Notepad++.Notepad++" }
    @{ Nome = "OBS Studio";           Id = "OBSProject.OBSStudio" }
    @{ Nome = "MSI Afterburner";      Id = "Guru3D.Afterburner" }
    @{ Nome = "WinRAR";               Id = "RARLab.WinRAR" }
    @{ Nome = "GeForce Experience";   Id = "Nvidia.GeForceExperience" }
    @{ Nome = "PowerToys";            Id = "Microsoft.PowerToys" }
    @{ Nome = "CCleaner";             Id = "Piriform.CCleaner" }
    @{ Nome = "WhatsApp Desktop";     Id = "9NKSQGP7F2NH" }
    @{ Nome = "Malwarebytes";         Id = "Malwarebytes.Malwarebytes" }
)

$lblApps = New-Object System.Windows.Forms.Label
$lblApps.Text = "Selecione os programas para instalar (via winget):"
$lblApps.ForeColor = $corLaranja
$lblApps.Font = $fonteNormal
$lblApps.Location = New-Object System.Drawing.Point(10, 10)
$lblApps.AutoSize = $true
$tabApps.Controls.Add($lblApps)

$appsCL = New-CheckList -parent $tabApps -x 10 -y 35 -w 930 -h 400 -itens $appsList

$btnAppsTodos = New-Object System.Windows.Forms.Button
$btnAppsTodos.Text = "Marcar todos"
$btnAppsTodos.Location = New-Object System.Drawing.Point(10, 445)
$btnAppsTodos.Size = New-Object System.Drawing.Size(140, 32)
$btnAppsTodos.BackColor = $corPainel
$btnAppsTodos.ForeColor = $corTexto
$btnAppsTodos.FlatStyle = "Flat"
$btnAppsTodos.Add_Click({ Select-All $appsCL.Checks $true })
$tabApps.Controls.Add($btnAppsTodos)

$btnAppsNenhum = New-Object System.Windows.Forms.Button
$btnAppsNenhum.Text = "Desmarcar todos"
$btnAppsNenhum.Location = New-Object System.Drawing.Point(160, 445)
$btnAppsNenhum.Size = New-Object System.Drawing.Size(140, 32)
$btnAppsNenhum.BackColor = $corPainel
$btnAppsNenhum.ForeColor = $corTexto
$btnAppsNenhum.FlatStyle = "Flat"
$btnAppsNenhum.Add_Click({ Select-All $appsCL.Checks $false })
$tabApps.Controls.Add($btnAppsNenhum)

$btnAppsInstalar = New-Object System.Windows.Forms.Button
$btnAppsInstalar.Text = "INSTALAR SELECIONADOS"
$btnAppsInstalar.Location = New-Object System.Drawing.Point(690, 445)
$btnAppsInstalar.Size = New-Object System.Drawing.Size(250, 40)
$btnAppsInstalar.BackColor = $corVermelho
$btnAppsInstalar.ForeColor = [System.Drawing.Color]::White
$btnAppsInstalar.Font = $fonteBotao
$btnAppsInstalar.FlatStyle = "Flat"
$btnAppsInstalar.Add_Click({
    $selecionados = $appsCL.Checks | Where-Object { $_.Checked }
    if ($selecionados.Count -eq 0) {
        [System.Windows.Forms.MessageBox]::Show("Nenhum programa selecionado.", "ROMA")
        return
    }
    $tabs.SelectedTab = $tabLog
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
    }
    Set-Status "Instalacao finalizada."
    Write-Log "=== Instalacao de apps finalizada ==="
})
$tabApps.Controls.Add($btnAppsInstalar)

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
    @{ Nome = "Mostrar extensoes de arquivo";            Acao = {
        reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v HideFileExt /t REG_DWORD /d 0 /f
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
    @{ Nome = "Desativar indexacao de disco (SSD/HDD)";   Acao = {
        Get-Volume | ForEach-Object { fsutil behavior set disabledeletenotify 0 }
    }}
    @{ Nome = "Limpar arquivos temporarios";              Acao = {
        Remove-Item -Path "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue
    }}
    @{ Nome = "Desativar Widgets (Windows 11)";           Acao = {
        reg add "HKLM\SOFTWARE\Policies\Microsoft\Dsh" /v AllowNewsAndInterests /t REG_DWORD /d 0 /f
    }}
)

$lblTweaks = New-Object System.Windows.Forms.Label
$lblTweaks.Text = "Selecione os tweaks que deseja aplicar:"
$lblTweaks.ForeColor = $corLaranja
$lblTweaks.Font = $fonteNormal
$lblTweaks.Location = New-Object System.Drawing.Point(10, 10)
$lblTweaks.AutoSize = $true
$tabTweaks.Controls.Add($lblTweaks)

$tweaksCL = New-CheckList -parent $tabTweaks -x 10 -y 35 -w 930 -h 400 -itens $tweaksList

$btnTweaksTodos = New-Object System.Windows.Forms.Button
$btnTweaksTodos.Text = "Marcar todos"
$btnTweaksTodos.Location = New-Object System.Drawing.Point(10, 445)
$btnTweaksTodos.Size = New-Object System.Drawing.Size(140, 32)
$btnTweaksTodos.BackColor = $corPainel
$btnTweaksTodos.ForeColor = $corTexto
$btnTweaksTodos.FlatStyle = "Flat"
$btnTweaksTodos.Add_Click({ Select-All $tweaksCL.Checks $true })
$tabTweaks.Controls.Add($btnTweaksTodos)

$btnTweaksNenhum = New-Object System.Windows.Forms.Button
$btnTweaksNenhum.Text = "Desmarcar todos"
$btnTweaksNenhum.Location = New-Object System.Drawing.Point(160, 445)
$btnTweaksNenhum.Size = New-Object System.Drawing.Size(140, 32)
$btnTweaksNenhum.BackColor = $corPainel
$btnTweaksNenhum.ForeColor = $corTexto
$btnTweaksNenhum.FlatStyle = "Flat"
$btnTweaksNenhum.Add_Click({ Select-All $tweaksCL.Checks $false })
$tabTweaks.Controls.Add($btnTweaksNenhum)

$btnTweaksAplicar = New-Object System.Windows.Forms.Button
$btnTweaksAplicar.Text = "APLICAR TWEAKS"
$btnTweaksAplicar.Location = New-Object System.Drawing.Point(690, 445)
$btnTweaksAplicar.Size = New-Object System.Drawing.Size(250, 40)
$btnTweaksAplicar.BackColor = $corVermelho
$btnTweaksAplicar.ForeColor = [System.Drawing.Color]::White
$btnTweaksAplicar.Font = $fonteBotao
$btnTweaksAplicar.FlatStyle = "Flat"
$btnTweaksAplicar.Add_Click({
    $selecionados = $tweaksCL.Checks | Where-Object { $_.Checked }
    if ($selecionados.Count -eq 0) {
        [System.Windows.Forms.MessageBox]::Show("Nenhum tweak selecionado.", "ROMA")
        return
    }
    $tabs.SelectedTab = $tabLog
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
    }
    Set-Status "Tweaks aplicados."
    Write-Log "=== Tweaks finalizados ==="
})
$tabTweaks.Controls.Add($btnTweaksAplicar)

# ==============================================================
#  ABA 3 - PRIORIDADE DE JOGOS (Image File Execution Options)
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
)

$lblGames = New-Object System.Windows.Forms.Label
$lblGames.Text = "Selecione os jogos para aumentar a prioridade de CPU:"
$lblGames.ForeColor = $corLaranja
$lblGames.Font = $fonteNormal
$lblGames.Location = New-Object System.Drawing.Point(10, 10)
$lblGames.AutoSize = $true
$tabGames.Controls.Add($lblGames)

$gamesCL = New-CheckList -parent $tabGames -x 10 -y 35 -w 930 -h 400 -itens $gamesList

$btnGamesTodos = New-Object System.Windows.Forms.Button
$btnGamesTodos.Text = "Marcar todos"
$btnGamesTodos.Location = New-Object System.Drawing.Point(10, 445)
$btnGamesTodos.Size = New-Object System.Drawing.Size(140, 32)
$btnGamesTodos.BackColor = $corPainel
$btnGamesTodos.ForeColor = $corTexto
$btnGamesTodos.FlatStyle = "Flat"
$btnGamesTodos.Add_Click({ Select-All $gamesCL.Checks $true })
$tabGames.Controls.Add($btnGamesTodos)

$btnGamesNenhum = New-Object System.Windows.Forms.Button
$btnGamesNenhum.Text = "Desmarcar todos"
$btnGamesNenhum.Location = New-Object System.Drawing.Point(160, 445)
$btnGamesNenhum.Size = New-Object System.Drawing.Size(140, 32)
$btnGamesNenhum.BackColor = $corPainel
$btnGamesNenhum.ForeColor = $corTexto
$btnGamesNenhum.FlatStyle = "Flat"
$btnGamesNenhum.Add_Click({ Select-All $gamesCL.Checks $false })
$tabGames.Controls.Add($btnGamesNenhum)

$btnGamesAplicar = New-Object System.Windows.Forms.Button
$btnGamesAplicar.Text = "AUMENTAR PRIORIDADE"
$btnGamesAplicar.Location = New-Object System.Drawing.Point(690, 445)
$btnGamesAplicar.Size = New-Object System.Drawing.Size(250, 40)
$btnGamesAplicar.BackColor = $corVermelho
$btnGamesAplicar.ForeColor = [System.Drawing.Color]::White
$btnGamesAplicar.Font = $fonteBotao
$btnGamesAplicar.FlatStyle = "Flat"
$btnGamesAplicar.Add_Click({
    $selecionados = $gamesCL.Checks | Where-Object { $_.Checked }
    if ($selecionados.Count -eq 0) {
        [System.Windows.Forms.MessageBox]::Show("Nenhum jogo selecionado.", "ROMA")
        return
    }
    $tabs.SelectedTab = $tabLog
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
    }
    Set-Status "Prioridades aplicadas."
    Write-Log "=== Prioridade de jogos finalizada ==="
})
$tabGames.Controls.Add($btnGamesAplicar)

# ==============================================================
#  ABA 4 - LIMPEZA
# ==============================================================
$lblLimpeza = New-Object System.Windows.Forms.Label
$lblLimpeza.Text = "Ferramentas de limpeza e manutencao:"
$lblLimpeza.ForeColor = $corLaranja
$lblLimpeza.Font = $fonteNormal
$lblLimpeza.Location = New-Object System.Drawing.Point(10, 10)
$lblLimpeza.AutoSize = $true
$tabLimpeza.Controls.Add($lblLimpeza)

function New-BotaoLimpeza($texto, $y, $acao) {
    $btn = New-Object System.Windows.Forms.Button
    $btn.Text = $texto
    $btn.Location = New-Object System.Drawing.Point(10, $y)
    $btn.Size = New-Object System.Drawing.Size(400, 40)
    $btn.BackColor = $corPainel
    $btn.ForeColor = $corTexto
    $btn.Font = $fonteNormal
    $btn.FlatStyle = "Flat"
    $btn.TextAlign = "MiddleLeft"
    $btn.Padding = New-Object System.Windows.Forms.Padding(10, 0, 0, 0)
    $btn.Add_Click($acao)
    $tabLimpeza.Controls.Add($btn)
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

New-BotaoLimpeza "Executar SFC /scannow (verificar arquivos do sistema)" 245 {
    Set-Status "Executando SFC..."
    Write-Log "Executando sfc /scannow (isso pode demorar alguns minutos)..."
    Start-Process "sfc" -ArgumentList "/scannow" -Wait -NoNewWindow
    Write-Log "SFC finalizado."
    Set-Status "Pronto."
}

New-BotaoLimpeza "Criar Ponto de Restauracao" 295 {
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
$rodape.Location = New-Object System.Drawing.Point(15, 658)
$rodape.AutoSize = $true
$form.Controls.Add($rodape)

Write-Log "ROMA iniciado. Pronto para uso."

[System.Windows.Forms.Application]::Run($form)