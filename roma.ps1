#Requires -RunAsAdministrator
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# ============================================================
#                        R O M A
#   Utilitario de Otimizacao, Debloat e Performance Windows
#     (inspirado no estilo do ChrisTitusTech WinUtil)
# ============================================================

[System.Windows.Forms.Application]::EnableVisualStyles()

# ---------- Paleta de cores (tema azul escuro / moderno) ----------
$corFundo      = [System.Drawing.Color]::FromArgb(10, 14, 22)
$corPainel     = [System.Drawing.Color]::FromArgb(17, 24, 38)
$corPainel2    = [System.Drawing.Color]::FromArgb(23, 32, 50)
$corCartao     = [System.Drawing.Color]::FromArgb(15, 21, 33)
$corBorda      = [System.Drawing.Color]::FromArgb(35, 46, 68)
$corAzul       = [System.Drawing.Color]::FromArgb(35, 105, 225)
$corAzulEscuro = [System.Drawing.Color]::FromArgb(22, 70, 160)
$corAzulClaro  = [System.Drawing.Color]::FromArgb(90, 170, 255)
$corCiano      = [System.Drawing.Color]::FromArgb(70, 210, 235)
$corVerde      = [System.Drawing.Color]::FromArgb(60, 190, 120)
$corAmarelo    = [System.Drawing.Color]::FromArgb(235, 180, 60)
$corVermelho   = [System.Drawing.Color]::FromArgb(220, 70, 70)
$corTexto      = [System.Drawing.Color]::FromArgb(230, 238, 248)
$corTextoMuted = [System.Drawing.Color]::FromArgb(140, 160, 190)

$fonteTitulo   = New-Object System.Drawing.Font("Segoe UI", 22, [System.Drawing.FontStyle]::Bold)
$fonteSub      = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Italic)
$fonteNormal   = New-Object System.Drawing.Font("Segoe UI", 9)
$fonteSecao    = New-Object System.Drawing.Font("Segoe UI", 10.5, [System.Drawing.FontStyle]::Bold)
$fonteBotao    = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$fonteAviso    = New-Object System.Drawing.Font("Segoe UI", 8.5, [System.Drawing.FontStyle]::Italic)

# ---------- Janela principal ----------
$form = New-Object System.Windows.Forms.Form
$form.Text = "ROMA - Otimizador, Debloat e Performance para Windows"
$form.Size = New-Object System.Drawing.Size(1220, 830)
$form.StartPosition = "CenterScreen"
$form.BackColor = $corFundo
$form.ForeColor = $corTexto
$form.FormBorderStyle = "FixedSingle"
$form.MaximizeBox = $false

# ---------- Cabecalho ----------
$header = New-Object System.Windows.Forms.Panel
$header.Size = New-Object System.Drawing.Size(1220, 84)
$header.Location = New-Object System.Drawing.Point(0, 0)
$header.BackColor = $corPainel
$form.Controls.Add($header)

$faixa = New-Object System.Windows.Forms.Panel
$faixa.Size = New-Object System.Drawing.Size(1220, 3)
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
$subtitulo.Text = "Otimizacao, debloat, tweaks, servicos e rede em um so lugar"
$subtitulo.Font = $fonteSub
$subtitulo.ForeColor = $corTextoMuted
$subtitulo.Location = New-Object System.Drawing.Point(24, 50)
$subtitulo.AutoSize = $true
$header.Controls.Add($subtitulo)

$lblStatus = New-Object System.Windows.Forms.Label
$lblStatus.Text = "Pronto."
$lblStatus.ForeColor = $corAzulClaro
$lblStatus.Font = $fonteNormal
$lblStatus.Location = New-Object System.Drawing.Point(700, 14)
$lblStatus.Size = New-Object System.Drawing.Size(500, 20)
$lblStatus.TextAlign = "MiddleRight"
$header.Controls.Add($lblStatus)

$barraProgresso = New-Object System.Windows.Forms.ProgressBar
$barraProgresso.Location = New-Object System.Drawing.Point(700, 40)
$barraProgresso.Size = New-Object System.Drawing.Size(500, 18)
$barraProgresso.Style = "Continuous"
$header.Controls.Add($barraProgresso)

function Set-Status($texto) {
    $lblStatus.Text = $texto
    $form.Refresh()
}

# ---------- Abas ----------
$tabs = New-Object System.Windows.Forms.TabControl
$tabs.Location = New-Object System.Drawing.Point(10, 94)
$tabs.Size = New-Object System.Drawing.Size(1200, 690)
$tabs.Font = $fonteNormal
$tabs.ItemSize = New-Object System.Drawing.Size(150, 32)
$tabs.SizeMode = "Fixed"
$form.Controls.Add($tabs)

$tabTweaks   = New-Object System.Windows.Forms.TabPage; $tabTweaks.Text   = "  Tweaks  "
$tabDebloat  = New-Object System.Windows.Forms.TabPage; $tabDebloat.Text  = "  Debloat  "
$tabServicos = New-Object System.Windows.Forms.TabPage; $tabServicos.Text = "  Servicos  "
$tabRede     = New-Object System.Windows.Forms.TabPage; $tabRede.Text     = "  Rede  "
$tabSistema  = New-Object System.Windows.Forms.TabPage; $tabSistema.Text  = "  Sistema  "
$tabLimpeza  = New-Object System.Windows.Forms.TabPage; $tabLimpeza.Text  = "  Limpeza  "
$tabLog      = New-Object System.Windows.Forms.TabPage; $tabLog.Text      = "  Log  "
foreach ($t in @($tabTweaks, $tabDebloat, $tabServicos, $tabRede, $tabSistema, $tabLimpeza, $tabLog)) {
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
$txtLog.Size = New-Object System.Drawing.Size(1170, 630)
$tabLog.Controls.Add($txtLog)

function Write-Log($texto) {
    $hora = Get-Date -Format "HH:mm:ss"
    $txtLog.AppendText("[$hora] $texto`r`n")
    $txtLog.SelectionStart = $txtLog.Text.Length
    $txtLog.ScrollToCaret()
}

# ==============================================================
#  FUNCOES AUXILIARES DE UI
# ==============================================================

function New-Cartao {
    param($parent, $x, $y, $w, $h)
    $p = New-Object System.Windows.Forms.Panel
    $p.Location = New-Object System.Drawing.Point($x, $y)
    $p.Size = New-Object System.Drawing.Size($w, $h)
    $p.BackColor = $corCartao
    $parent.Controls.Add($p)
    return $p
}

function New-Titulo {
    param($parent, $texto, $x, $y, $cor)
    $l = New-Object System.Windows.Forms.Label
    $l.Text = $texto
    $l.Font = $fonteSecao
    $l.ForeColor = $cor
    $l.Location = New-Object System.Drawing.Point($x, $y)
    $l.AutoSize = $true
    $parent.Controls.Add($l)
    return $l
}

function New-CheckList {
    param($parent, $x, $y, $w, $h, $itens)
    $panel = New-Object System.Windows.Forms.Panel
    $panel.Location = New-Object System.Drawing.Point($x, $y)
    $panel.Size = New-Object System.Drawing.Size($w, $h)
    $panel.AutoScroll = $true
    $panel.BackColor = $corCartao
    $parent.Controls.Add($panel)

    $checks = @()
    $i = 0
    foreach ($item in $itens) {
        $cb = New-Object System.Windows.Forms.CheckBox
        $cb.Text = $item.Nome
        $cb.Tag = $item
        $cb.ForeColor = $corTexto
        $cb.Font = $fonteNormal
        $cb.Location = New-Object System.Drawing.Point(10, (8 + $i * 25))
        $cb.Size = New-Object System.Drawing.Size(($w - 35), 22)
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
    $btn.Cursor = [System.Windows.Forms.Cursors]::Hand
    $parent.Controls.Add($btn)
    return $btn
}

# Toggle estilo "switch" moderno (como no WinUtil)
function New-Toggle {
    param($parent, $x, $y, $largura, $nome, [scriptblock]$getState, [scriptblock]$onEnable, [scriptblock]$onDisable)

    $lbl = New-Object System.Windows.Forms.Label
    $lbl.Text = $nome
    $lbl.ForeColor = $corTexto
    $lbl.Font = $fonteNormal
    $lbl.Location = New-Object System.Drawing.Point($x, ($y + 3))
    $lbl.Size = New-Object System.Drawing.Size(($largura - 55), 20)
    $parent.Controls.Add($lbl)

    $sw = New-Object System.Windows.Forms.Panel
    $sw.Location = New-Object System.Drawing.Point(($x + $largura - 46), $y)
    $sw.Size = New-Object System.Drawing.Size(46, 22)
    $sw.Cursor = [System.Windows.Forms.Cursors]::Hand

    $estadoAtual = $false
    try { $estadoAtual = [bool](& $getState) } catch { $estadoAtual = $false }

    $sw.Tag = [PSCustomObject]@{ Enabled = $estadoAtual; Nome = $nome; OnEnable = $onEnable; OnDisable = $onDisable }

    $sw.Add_Paint({
        $g = $_.Graphics
        $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
        $tag = $this.Tag
        $corLigado    = [System.Drawing.Color]::FromArgb(35, 105, 225)
        $corDesligado = [System.Drawing.Color]::FromArgb(65, 75, 92)
        $cor = if ($tag.Enabled) { $corLigado } else { $corDesligado }
        $h = $this.Height
        $w = $this.Width
        $path = New-Object System.Drawing.Drawing2D.GraphicsPath
        $path.AddArc(0, 0, $h, $h, 90, 180)
        $path.AddArc(($w - $h), 0, $h, $h, 270, 180)
        $path.CloseFigure()
        $brush = New-Object System.Drawing.SolidBrush($cor)
        $g.FillPath($brush, $path)
        $d = $h - 4
        $kx = if ($tag.Enabled) { $w - $d - 2 } else { 2 }
        $knob = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
        $g.FillEllipse($knob, $kx, 2, $d, $d)
    })

    $sw.Add_Click({
        $tag = $this.Tag
        $tag.Enabled = -not $tag.Enabled
        try {
            if ($tag.Enabled) { & $tag.OnEnable } else { & $tag.OnDisable }
            Write-Log "$($tag.Nome): $(if ($tag.Enabled) {'Ativado'} else {'Desativado'})"
            Set-Status "$($tag.Nome) atualizado."
        } catch {
            Write-Log "ERRO em '$($tag.Nome)': $_"
        }
        $this.Invalidate()
    })

    $parent.Controls.Add($sw)
}

function Get-AdaptadorAtivo {
    return Get-NetAdapter -ErrorAction SilentlyContinue | Where-Object { $_.Status -eq "Up" } | Select-Object -First 1
}

# ==============================================================
#  ABA 1 - TWEAKS  (Essenciais / Avancados / Preferencias)
# ==============================================================

# ---- Lista de tweaks essenciais (recomendados) ----
$tweaksEssenciais = @(
    @{ Nome = "Desativar telemetria do Windows"
       Acao = { reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f }
       Desfazer = { reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v AllowTelemetry /f } }
    @{ Nome = "Desativar Cortana"
       Acao = { reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v AllowCortana /t REG_DWORD /d 0 /f }
       Desfazer = { reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v AllowCortana /f } }
    @{ Nome = "Desativar sugestoes no menu Iniciar"
       Acao = { reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SystemPaneSuggestionsEnabled /t REG_DWORD /d 0 /f }
       Desfazer = { reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SystemPaneSuggestionsEnabled /t REG_DWORD /d 1 /f } }
    @{ Nome = "Ativar plano de energia Alto Desempenho"
       Acao = { powercfg -setactive SCHEME_MIN }
       Desfazer = { powercfg -setactive SCHEME_BALANCED } }
    @{ Nome = "Desativar Game DVR / Xbox Game Bar"
       Acao = {
            reg add "HKCU\System\GameConfigStore" /v GameDVR_Enabled /t REG_DWORD /d 0 /f
            reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /v AllowGameDVR /t REG_DWORD /d 0 /f
       }
       Desfazer = {
            reg add "HKCU\System\GameConfigStore" /v GameDVR_Enabled /t REG_DWORD /d 1 /f
            reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /v AllowGameDVR /f
       } }
    @{ Nome = "Desativar efeitos visuais (melhor performance)"
       Acao = { reg add "HKCU\Control Panel\Desktop" /v UserPreferencesMask /t REG_BINARY /d 9012038010000000 /f }
       Desfazer = { reg add "HKCU\Control Panel\Desktop" /v UserPreferencesMask /t REG_BINARY /d 9E1E07800C000000 /f } }
    @{ Nome = "Desativar notificacoes de dicas do Windows"
       Acao = { reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SoftLandingEnabled /t REG_DWORD /d 0 /f }
       Desfazer = { reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SoftLandingEnabled /t REG_DWORD /d 1 /f } }
    @{ Nome = "Reduzir delay do menu Iniciar"
       Acao = { reg add "HKCU\Control Panel\Desktop" /v MenuShowDelay /t REG_SZ /d 0 /f }
       Desfazer = { reg add "HKCU\Control Panel\Desktop" /v MenuShowDelay /t REG_SZ /d 400 /f } }
    @{ Nome = "Desativar hibernacao"
       Acao = { powercfg -hibernate off }
       Desfazer = { powercfg -hibernate on } }
    @{ Nome = "Desativar inicializacao rapida (Fast Startup)"
       Acao = { reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Power" /v HiberbootEnabled /t REG_DWORD /d 0 /f }
       Desfazer = { reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Power" /v HiberbootEnabled /t REG_DWORD /d 1 /f } }
    @{ Nome = "Desativar Historico de Atividades"
       Acao = {
            reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v EnableActivityFeed /t REG_DWORD /d 0 /f
            reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v PublishUserActivities /t REG_DWORD /d 0 /f
       }
       Desfazer = {
            reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v EnableActivityFeed /f
            reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v PublishUserActivities /f
       } }
    @{ Nome = "Desativar rastreamento de localizacao"
       Acao = { reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" /v Value /t REG_SZ /d Deny /f }
       Desfazer = { reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" /v Value /t REG_SZ /d Allow /f } }
    @{ Nome = "Desativar Widgets (Windows 11)"
       Acao = {
            reg add "HKLM\SOFTWARE\Policies\Microsoft\Dsh" /v AllowNewsAndInterests /t REG_DWORD /d 0 /f
            reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarDa /t REG_DWORD /d 0 /f
       }
       Desfazer = {
            reg delete "HKLM\SOFTWARE\Policies\Microsoft\Dsh" /v AllowNewsAndInterests /f
            reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarDa /t REG_DWORD /d 1 /f
       } }
    @{ Nome = "Limpar arquivos temporarios"
       Acao = { Remove-Item -Path "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue }
       Desfazer = $null }
    @{ Nome = "Criar Ponto de Restauracao antes dos tweaks"
       Acao = { Checkpoint-Computer -Description "ROMA - Antes dos Tweaks" -RestorePointType "MODIFY_SETTINGS" }
       Desfazer = $null }
    @{ Nome = "Desativar Otimizacao de Entrega (P2P de updates)"
       Acao = { reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config" /v DODownloadMode /t REG_DWORD /d 0 /f }
       Desfazer = { reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config" /v DODownloadMode /t REG_DWORD /d 1 /f } }
    @{ Nome = "Desativar recursos/apps sugeridos (ConsumerFeatures)"
       Acao = { reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v DisableWindowsConsumerFeatures /t REG_DWORD /d 1 /f }
       Desfazer = { reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v DisableWindowsConsumerFeatures /t REG_DWORD /d 0 /f } }
    @{ Nome = "Executar Liberador de Espaco em Disco"
       Acao = { Start-Process "cleanmgr" -ArgumentList "/sagerun:1" }
       Desfazer = $null }
)

# ---- Lista de tweaks avancados (cuidado) ----
$tweaksAvancados = @(
    @{ Nome = "Desativar Windows Copilot / Recall"
       Acao = {
            reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsCopilot" /v TurnOffWindowsCopilot /t REG_DWORD /d 1 /f
            reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsAI" /v DisableAIDataAnalysis /t REG_DWORD /d 1 /f
       }
       Desfazer = {
            reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsCopilot" /v TurnOffWindowsCopilot /f
            reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsAI" /v DisableAIDataAnalysis /f
       } }
    @{ Nome = "Remover Microsoft OneDrive"
       Acao = {
            Stop-Process -Name OneDrive -Force -ErrorAction SilentlyContinue
            $od = "$env:SYSTEMROOT\SysWOW64\OneDriveSetup.exe"
            if (-not (Test-Path $od)) { $od = "$env:SYSTEMROOT\System32\OneDriveSetup.exe" }
            if (Test-Path $od) { Start-Process $od -ArgumentList "/uninstall" -Wait -ErrorAction SilentlyContinue }
       }
       Desfazer = $null }
    @{ Nome = "Debloat do Microsoft Edge"
       Acao = {
            reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v HideFirstRunExperience /t REG_DWORD /d 1 /f
            reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v StartupBoostEnabled /t REG_DWORD /d 0 /f
            reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v BackgroundModeEnabled /t REG_DWORD /d 0 /f
       }
       Desfazer = {
            reg delete "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v HideFirstRunExperience /f
            reg delete "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v StartupBoostEnabled /f
            reg delete "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v BackgroundModeEnabled /f
       } }
    @{ Nome = "Desativar Armazenamento Reservado"
       Acao = { Dism /Online /Set-ReservedStorageState /State:Disabled }
       Desfazer = { Dism /Online /Set-ReservedStorageState /State:Enabled } }
    @{ Nome = "Desativar IPv6 nos adaptadores"
       Acao = { Get-NetAdapterBinding -ComponentID ms_tcpip6 -ErrorAction SilentlyContinue | Disable-NetAdapterBinding -ErrorAction SilentlyContinue }
       Desfazer = { Get-NetAdapterBinding -ComponentID ms_tcpip6 -ErrorAction SilentlyContinue | Enable-NetAdapterBinding -ErrorAction SilentlyContinue } }
    @{ Nome = "Preferir IPv4 sobre IPv6"
       Acao = { reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip6\Parameters" /v DisabledComponents /t REG_DWORD /d 32 /f }
       Desfazer = { reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip6\Parameters" /v DisabledComponents /t REG_DWORD /d 0 /f } }
    @{ Nome = "Desativar Otimizacoes de Tela Cheia"
       Acao = {
            reg add "HKCU\System\GameConfigStore" /v GameDVR_FSEBehaviorMode /t REG_DWORD /d 2 /f
            reg add "HKCU\System\GameConfigStore" /v GameDVR_HonorUserFSEBehaviorMode /t REG_DWORD /d 1 /f
       }
       Desfazer = {
            reg delete "HKCU\System\GameConfigStore" /v GameDVR_FSEBehaviorMode /f
            reg delete "HKCU\System\GameConfigStore" /v GameDVR_HonorUserFSEBehaviorMode /f
       } }
    @{ Nome = "Desativar apps em segundo plano"
       Acao = { reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v GlobalUserDisabled /t REG_DWORD /d 1 /f }
       Desfazer = { reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v GlobalUserDisabled /t REG_DWORD /d 0 /f } }
    @{ Nome = "Definir relogio do sistema para UTC (dual-boot Linux)"
       Acao = { reg add "HKLM\SYSTEM\CurrentControlSet\Control\TimeZoneInformation" /v RealTimeIsUniversal /t REG_DWORD /d 1 /f }
       Desfazer = { reg add "HKLM\SYSTEM\CurrentControlSet\Control\TimeZoneInformation" /v RealTimeIsUniversal /t REG_DWORD /d 0 /f } }
    @{ Nome = "Desativar SMBv1 (protocolo legado inseguro)"
       Acao = { Disable-WindowsOptionalFeature -Online -FeatureName SMB1Protocol -NoRestart -ErrorAction SilentlyContinue }
       Desfazer = { Enable-WindowsOptionalFeature -Online -FeatureName SMB1Protocol -NoRestart -ErrorAction SilentlyContinue } }
    @{ Nome = "Desativar Storage Sense"
       Acao = { reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy" /v 01 /t REG_DWORD /d 0 /f }
       Desfazer = { reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy" /v 01 /t REG_DWORD /d 1 /f } }
    @{ Nome = "Desativar Teredo"
       Acao = { netsh interface teredo set state disabled }
       Desfazer = { netsh interface teredo set state default } }
    @{ Nome = "Remover componentes Xbox e Jogos"
       Acao = {
            $pkgs = @("Microsoft.Xbox.TCUI","Microsoft.XboxApp","Microsoft.XboxGameOverlay","Microsoft.XboxGamingOverlay","Microsoft.XboxIdentityProvider","Microsoft.XboxSpeechToTextOverlay")
            foreach ($p in $pkgs) {
                Get-AppxPackage -Name $p -AllUsers -ErrorAction SilentlyContinue | Remove-AppxPackage -ErrorAction SilentlyContinue
            }
       }
       Desfazer = $null }
    @{ Nome = "Desativar telemetria do Microsoft Office"
       Acao = { reg add "HKCU\SOFTWARE\Policies\Microsoft\Office\16.0\Common\ClientTelemetry" /v DisableTelemetry /t REG_DWORD /d 1 /f }
       Desfazer = { reg add "HKCU\SOFTWARE\Policies\Microsoft\Office\16.0\Common\ClientTelemetry" /v DisableTelemetry /t REG_DWORD /d 0 /f } }
)

# ---------- Layout da aba Tweaks ----------
$lblTweaksTop = New-Object System.Windows.Forms.Label
$lblTweaksTop.Text = "Selecione as otimizacoes e clique em APLICAR. Preferencias (direita) mudam na hora."
$lblTweaksTop.ForeColor = $corTextoMuted
$lblTweaksTop.Font = $fonteAviso
$lblTweaksTop.Location = New-Object System.Drawing.Point(10, 8)
$lblTweaksTop.AutoSize = $true
$tabTweaks.Controls.Add($lblTweaksTop)

# Coluna esquerda: Essenciais
New-Titulo $tabTweaks "Tweaks Essenciais" 10 32 $corCiano
$essenciaisCL = New-CheckList -parent $tabTweaks -x 10 -y 60 -w 370 -h 250 -itens $tweaksEssenciais

# Coluna esquerda (embaixo): Avancados
New-Titulo $tabTweaks "Tweaks Avancados - CUIDADO" 10 322 $corAmarelo
$avancadosCL = New-CheckList -parent $tabTweaks -x 10 -y 350 -w 370 -h 210 -itens $tweaksAvancados

$btnTweaksTodos = New-BotaoPadrao $tabTweaks "Marcar todos" 10 568 175 34 $corPainel2 $corTexto
$btnTweaksTodos.Add_Click({ Select-All $essenciaisCL.Checks $true; Select-All $avancadosCL.Checks $true })

$btnTweaksNenhum = New-BotaoPadrao $tabTweaks "Desmarcar todos" 195 568 185 34 $corPainel2 $corTexto
$btnTweaksNenhum.Add_Click({ Select-All $essenciaisCL.Checks $false; Select-All $avancadosCL.Checks $false })

$btnTweaksAplicar = New-BotaoPadrao $tabTweaks "APLICAR TWEAKS" 10 610 260 42 $corAzul ([System.Drawing.Color]::White)
$btnTweaksAplicar.Font = $fonteBotao
$btnTweaksAplicar.Add_Click({
    $selecionados = @($essenciaisCL.Checks | Where-Object { $_.Checked }) + @($avancadosCL.Checks | Where-Object { $_.Checked })
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
        try { & $item.Acao; Write-Log "  -> OK" } catch { Write-Log "  -> ERRO: $_" }
        $barraProgresso.Value += 1
    }
    Set-Status "Tweaks aplicados."
    Write-Log "=== Tweaks finalizados ==="
})

$btnTweaksDesfazer = New-BotaoPadrao $tabTweaks "DESFAZER SELECIONADOS" 280 610 260 42 $corPainel2 $corTexto
$btnTweaksDesfazer.Add_Click({
    $selecionados = @($essenciaisCL.Checks | Where-Object { $_.Checked }) + @($avancadosCL.Checks | Where-Object { $_.Checked })
    if ($selecionados.Count -eq 0) {
        [System.Windows.Forms.MessageBox]::Show("Nenhum tweak selecionado.", "ROMA")
        return
    }
    $tabs.SelectedTab = $tabLog
    foreach ($cb in $selecionados) {
        $item = $cb.Tag
        if ($null -eq $item.Desfazer) {
            Write-Log "Sem opcao de desfazer para: $($item.Nome)"
            continue
        }
        Write-Log "Desfazendo: $($item.Nome)"
        try { & $item.Desfazer; Write-Log "  -> OK" } catch { Write-Log "  -> ERRO: $_" }
    }
    Write-Log "=== Desfazer finalizado ==="
})

# Coluna direita: Preferencias (toggles no estilo switch)
$cartaoPrefs = New-Cartao -parent $tabTweaks -x 400 -y 32 -w 400 -h 528
New-Titulo $cartaoPrefs "Personalizar Preferencias" 10 8 $corCiano

$togY = 40
$togX = 10
$togW = 380
$togGap = 32

New-Toggle $cartaoPrefs $togX $togY $togW "Tema escuro do Windows" `
    { (Get-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name AppsUseLightTheme -ErrorAction SilentlyContinue).AppsUseLightTheme -eq 0 } `
    { reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v AppsUseLightTheme /t REG_DWORD /d 0 /f; reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v SystemUsesLightTheme /t REG_DWORD /d 0 /f } `
    { reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v AppsUseLightTheme /t REG_DWORD /d 1 /f; reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v SystemUsesLightTheme /t REG_DWORD /d 1 /f }
$togY += $togGap

New-Toggle $cartaoPrefs $togX $togY $togW "Mostrar extensoes de arquivo" `
    { (Get-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name HideFileExt -ErrorAction SilentlyContinue).HideFileExt -eq 0 } `
    { reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v HideFileExt /t REG_DWORD /d 0 /f } `
    { reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v HideFileExt /t REG_DWORD /d 1 /f }
$togY += $togGap

New-Toggle $cartaoPrefs $togX $togY $togW "Mostrar arquivos e pastas ocultos" `
    { (Get-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name Hidden -ErrorAction SilentlyContinue).Hidden -eq 1 } `
    { reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v Hidden /t REG_DWORD /d 1 /f } `
    { reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v Hidden /t REG_DWORD /d 2 /f }
$togY += $togGap

New-Toggle $cartaoPrefs $togX $togY $togW "Modo de Jogo (Game Mode)" `
    { (Get-ItemProperty "HKCU:\SOFTWARE\Microsoft\GameBar" -Name AutoGameModeEnabled -ErrorAction SilentlyContinue).AutoGameModeEnabled -eq 1 } `
    { reg add "HKCU\SOFTWARE\Microsoft\GameBar" /v AutoGameModeEnabled /t REG_DWORD /d 1 /f } `
    { reg add "HKCU\SOFTWARE\Microsoft\GameBar" /v AutoGameModeEnabled /t REG_DWORD /d 0 /f }
$togY += $togGap

New-Toggle $cartaoPrefs $togX $togY $togW "Aceleracao do mouse" `
    { (Get-ItemProperty "HKCU:\Control Panel\Mouse" -Name MouseSpeed -ErrorAction SilentlyContinue).MouseSpeed -ne "0" } `
    { reg add "HKCU\Control Panel\Mouse" /v MouseSpeed /t REG_SZ /d 1 /f; reg add "HKCU\Control Panel\Mouse" /v MouseThreshold1 /t REG_SZ /d 6 /f; reg add "HKCU\Control Panel\Mouse" /v MouseThreshold2 /t REG_SZ /d 10 /f } `
    { reg add "HKCU\Control Panel\Mouse" /v MouseSpeed /t REG_SZ /d 0 /f; reg add "HKCU\Control Panel\Mouse" /v MouseThreshold1 /t REG_SZ /d 0 /f; reg add "HKCU\Control Panel\Mouse" /v MouseThreshold2 /t REG_SZ /d 0 /f }
$togY += $togGap

New-Toggle $cartaoPrefs $togX $togY $togW "Icones centralizados na barra de tarefas" `
    { (Get-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name TaskbarAl -ErrorAction SilentlyContinue).TaskbarAl -eq 1 } `
    { reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarAl /t REG_DWORD /d 1 /f } `
    { reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarAl /t REG_DWORD /d 0 /f }
$togY += $togGap

New-Toggle $cartaoPrefs $togX $togY $togW "Icone de pesquisa na barra de tarefas" `
    { (Get-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" -Name SearchboxTaskbarMode -ErrorAction SilentlyContinue).SearchboxTaskbarMode -ne 0 } `
    { reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v SearchboxTaskbarMode /t REG_DWORD /d 1 /f } `
    { reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v SearchboxTaskbarMode /t REG_DWORD /d 0 /f }
$togY += $togGap

New-Toggle $cartaoPrefs $togX $togY $togW "Pesquisa Bing no menu Iniciar" `
    { (Get-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" -Name BingSearchEnabled -ErrorAction SilentlyContinue).BingSearchEnabled -eq 1 } `
    { reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v BingSearchEnabled /t REG_DWORD /d 1 /f } `
    { reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v BingSearchEnabled /t REG_DWORD /d 0 /f }
$togY += $togGap

New-Toggle $cartaoPrefs $togX $togY $togW "Recomendacoes no menu Iniciar" `
    { (Get-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-338388Enabled" -ErrorAction SilentlyContinue)."SubscribedContent-338388Enabled" -eq 1 } `
    { reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SubscribedContent-338388Enabled /t REG_DWORD /d 1 /f } `
    { reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SubscribedContent-338388Enabled /t REG_DWORD /d 0 /f }
$togY += $togGap

New-Toggle $cartaoPrefs $togX $togY $togW "Sugestoes e apps promovidos" `
    { (Get-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name SilentInstalledAppsEnabled -ErrorAction SilentlyContinue).SilentInstalledAppsEnabled -eq 1 } `
    { reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SilentInstalledAppsEnabled /t REG_DWORD /d 1 /f } `
    { reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SilentInstalledAppsEnabled /t REG_DWORD /d 0 /f }
$togY += $togGap

New-Toggle $cartaoPrefs $togX $togY $togW "Teclas de aderencia (Sticky Keys)" `
    { (Get-ItemProperty "HKCU:\Control Panel\Accessibility\StickyKeys" -Name Flags -ErrorAction SilentlyContinue).Flags -eq "510" } `
    { reg add "HKCU\Control Panel\Accessibility\StickyKeys" /v Flags /t REG_SZ /d 510 /f } `
    { reg add "HKCU\Control Panel\Accessibility\StickyKeys" /v Flags /t REG_SZ /d 506 /f }
$togY += $togGap

New-Toggle $cartaoPrefs $togX $togY $togW "Relogio com segundos na bandeja" `
    { (Get-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name ShowSecondsInSystemClock -ErrorAction SilentlyContinue).ShowSecondsInSystemClock -eq 1 } `
    { reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v ShowSecondsInSystemClock /t REG_DWORD /d 1 /f } `
    { reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v ShowSecondsInSystemClock /t REG_DWORD /d 0 /f }
$togY += $togGap

New-Toggle $cartaoPrefs $togX $togY $togW "Mensagens detalhadas ao ligar/desligar" `
    { (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name VerboseStatus -ErrorAction SilentlyContinue).VerboseStatus -eq 1 } `
    { reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v VerboseStatus /t REG_DWORD /d 1 /f } `
    { reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v VerboseStatus /t REG_DWORD /d 0 /f }
$togY += $togGap

New-Toggle $cartaoPrefs $togX $togY $togW "Num Lock ao iniciar o Windows" `
    { (Get-ItemProperty "Registry::HKEY_USERS\.DEFAULT\Control Panel\Keyboard" -Name InitialKeyboardIndicators -ErrorAction SilentlyContinue).InitialKeyboardIndicators -eq "2147483650" } `
    { reg add "HKU\.DEFAULT\Control Panel\Keyboard" /v InitialKeyboardIndicators /t REG_SZ /d 2147483650 /f } `
    { reg add "HKU\.DEFAULT\Control Panel\Keyboard" /v InitialKeyboardIndicators /t REG_SZ /d 2147483648 /f }
$togY += $togGap + 6

$lblPerf = New-Object System.Windows.Forms.Label
$lblPerf.Text = "Planos de Energia - NAO RECOMENDADO PARA NOTEBOOKS"
$lblPerf.ForeColor = $corAmarelo
$lblPerf.Font = $fonteAviso
$lblPerf.Location = New-Object System.Drawing.Point($togX, $togY)
$lblPerf.AutoSize = $true
$cartaoPrefs.Controls.Add($lblPerf)
$togY += 22

$btnUltimateOn = New-BotaoPadrao $cartaoPrefs "Ativar Desempenho Maximo (Ultimate)" $togX $togY 380 34 $corPainel2 $corTexto
$btnUltimateOn.Add_Click({
    Write-Log "Ativando plano de Desempenho Maximo..."
    powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 | Out-Null
    powercfg -setactive e9a42b02-d5df-448d-aa00-03f14749eb61
    Write-Log "Plano Desempenho Maximo ativado."
})
$togY += 40

$btnUltimateOff = New-BotaoPadrao $cartaoPrefs "Desativar Desempenho Maximo (Ultimate)" $togX $togY 380 34 $corPainel2 $corTexto
$btnUltimateOff.Add_Click({
    Write-Log "Removendo plano de Desempenho Maximo..."
    powercfg -setactive SCHEME_BALANCED
    $planos = powercfg -list | Select-String "Ultimate"
    if ($planos) {
        foreach ($linha in $planos) {
            if ($linha -match "([a-f0-9-]{36})") { powercfg -delete $Matches[1] }
        }
    }
    Write-Log "Plano Desempenho Maximo removido."
})
$togY += 46

$lblDns = New-Object System.Windows.Forms.Label
$lblDns.Text = "DNS - Definir para:"
$lblDns.ForeColor = $corTexto
$lblDns.Font = $fonteNormal
$lblDns.Location = New-Object System.Drawing.Point($togX, ($togY + 4))
$lblDns.AutoSize = $true
$cartaoPrefs.Controls.Add($lblDns)

$comboDns = New-Object System.Windows.Forms.ComboBox
$comboDns.DropDownStyle = "DropDownList"
$comboDns.Location = New-Object System.Drawing.Point(150, $togY)
$comboDns.Size = New-Object System.Drawing.Size(240, 24)
$comboDns.Items.AddRange(@("Padrao (DHCP)", "Cloudflare (1.1.1.1)", "Google (8.8.8.8)", "Quad9 (9.9.9.9)", "OpenDNS (208.67.222.222)"))
$comboDns.SelectedIndex = 0
$cartaoPrefs.Controls.Add($comboDns)
$comboDns.Add_SelectedIndexChanged({
    $adaptador = Get-AdaptadorAtivo
    if (-not $adaptador) { Write-Log "Nenhum adaptador de rede ativo encontrado."; return }
    switch ($comboDns.SelectedItem) {
        "Padrao (DHCP)"             { Set-DnsClientServerAddress -InterfaceIndex $adaptador.ifIndex -ResetServerAddresses; Write-Log "DNS restaurado para automatico (DHCP)." }
        "Cloudflare (1.1.1.1)"      { Set-DnsClientServerAddress -InterfaceIndex $adaptador.ifIndex -ServerAddresses ("1.1.1.1","1.0.0.1"); Write-Log "DNS definido para Cloudflare." }
        "Google (8.8.8.8)"          { Set-DnsClientServerAddress -InterfaceIndex $adaptador.ifIndex -ServerAddresses ("8.8.8.8","8.8.4.4"); Write-Log "DNS definido para Google." }
        "Quad9 (9.9.9.9)"           { Set-DnsClientServerAddress -InterfaceIndex $adaptador.ifIndex -ServerAddresses ("9.9.9.9","149.112.112.112"); Write-Log "DNS definido para Quad9." }
        "OpenDNS (208.67.222.222)"  { Set-DnsClientServerAddress -InterfaceIndex $adaptador.ifIndex -ServerAddresses ("208.67.222.222","208.67.220.220"); Write-Log "DNS definido para OpenDNS." }
    }
})

# ==============================================================
#  ABA 2 - DEBLOAT (remover apps pre-instalados)
# ==============================================================
$debloatList = @(
    @{ Nome = "3D Builder";              Id = "Microsoft.3DBuilder" }
    @{ Nome = "Clima (BingWeather)";     Id = "Microsoft.BingWeather" }
    @{ Nome = "Noticias (BingNews)";     Id = "Microsoft.BingNews" }
    @{ Nome = "Financas (BingFinance)";  Id = "Microsoft.BingFinance" }
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
    @{ Nome = "Copilot";                 Id = "Microsoft.Copilot" }
    @{ Nome = "Quick Assist";            Id = "MicrosoftCorporationII.QuickAssist" }
    @{ Nome = "Cross Device Experience"; Id = "MicrosoftWindows.CrossDevice" }
    @{ Nome = "Microsoft To Do";         Id = "Microsoft.Todos" }
    @{ Nome = "Power Automate Desktop";  Id = "Microsoft.PowerAutomateDesktop" }
    @{ Nome = "Cortana (app)";           Id = "Microsoft.549981C3F5F10" }
)

New-Titulo $tabDebloat "Selecione os aplicativos pre-instalados para remover" 10 8 $corCiano
$debloatCL = New-CheckList -parent $tabDebloat -x 10 -y 40 -w 1170 -h 540 -itens $debloatList

$btnDebloatTodos = New-BotaoPadrao $tabDebloat "Marcar todos" 10 590 175 34 $corPainel2 $corTexto
$btnDebloatTodos.Add_Click({ Select-All $debloatCL.Checks $true })

$btnDebloatNenhum = New-BotaoPadrao $tabDebloat "Desmarcar todos" 195 590 185 34 $corPainel2 $corTexto
$btnDebloatNenhum.Add_Click({ Select-All $debloatCL.Checks $false })

$btnDebloatRemover = New-BotaoPadrao $tabDebloat "REMOVER SELECIONADOS" 920 590 260 42 $corVermelho ([System.Drawing.Color]::White)
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
#  ABA 3 - SERVICOS (desativar servicos desnecessarios)
# ==============================================================
$servicosList = @(
    @{ Nome = "DiagTrack (Telemetria)";             Servico = "DiagTrack" }
    @{ Nome = "dmwappushservice";                    Servico = "dmwappushservice" }
    @{ Nome = "SysMain (Superfetch)";                Servico = "SysMain" }
    @{ Nome = "Windows Error Reporting";             Servico = "WerSvc" }
    @{ Nome = "Retail Demo Service";                 Servico = "RetailDemo" }
    @{ Nome = "Fax";                                  Servico = "Fax" }
    @{ Nome = "Registro Remoto";                      Servico = "RemoteRegistry" }
    @{ Nome = "Maps Broker";                          Servico = "MapsBroker" }
    @{ Nome = "Windows Media Player Network";         Servico = "WMPNetworkSvc" }
    @{ Nome = "Print Notify (sem impressora)";        Servico = "PrintNotify" }
    @{ Nome = "Xbox Auth Manager";                    Servico = "XblAuthManager" }
    @{ Nome = "Xbox Game Save";                       Servico = "XblGameSave" }
    @{ Nome = "Xbox Live Networking";                 Servico = "XboxNetApiSvc" }
    @{ Nome = "Servico de Biometria";                 Servico = "WbioSrvc" }
    @{ Nome = "Programa Windows Insider";             Servico = "wisvc" }
    @{ Nome = "Servico de Camera (Frame Server)";     Servico = "FrameServer" }
    @{ Nome = "Entrada por Toque/Caneta";             Servico = "TabletInputService" }
)

New-Titulo $tabServicos "Selecione os servicos do Windows para desativar" 10 8 $corCiano
$servicosCL = New-CheckList -parent $tabServicos -x 10 -y 40 -w 1170 -h 540 -itens $servicosList

$btnServicosTodos = New-BotaoPadrao $tabServicos "Marcar todos" 10 590 175 34 $corPainel2 $corTexto
$btnServicosTodos.Add_Click({ Select-All $servicosCL.Checks $true })

$btnServicosNenhum = New-BotaoPadrao $tabServicos "Desmarcar todos" 195 590 185 34 $corPainel2 $corTexto
$btnServicosNenhum.Add_Click({ Select-All $servicosCL.Checks $false })

$btnServicosAplicar = New-BotaoPadrao $tabServicos "DESATIVAR SELECIONADOS" 920 590 260 42 $corVermelho ([System.Drawing.Color]::White)
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
#  ABA 4 - REDE
# ==============================================================
New-Titulo $tabRede "Ferramentas de rede e DNS" 10 8 $corCiano

$btnFlushDns = New-BotaoPadrao $tabRede "Limpar cache DNS" 10 45 360 42 $corPainel2 $corTexto
$btnFlushDns.TextAlign = "MiddleLeft"
$btnFlushDns.Add_Click({
    Set-Status "Limpando cache DNS..."
    Write-Log "Executando ipconfig /flushdns ..."
    ipconfig /flushdns | Out-Null
    Write-Log "Cache DNS limpo."
    Set-Status "Pronto."
})

$btnWinsock = New-BotaoPadrao $tabRede "Resetar Winsock" 10 95 360 42 $corPainel2 $corTexto
$btnWinsock.TextAlign = "MiddleLeft"
$btnWinsock.Add_Click({
    Set-Status "Resetando Winsock..."
    Write-Log "Executando netsh winsock reset ..."
    netsh winsock reset | Out-Null
    Write-Log "Winsock resetado. Reinicie o computador."
    Set-Status "Pronto (reinicie o PC)."
})

$btnTcpIp = New-BotaoPadrao $tabRede "Resetar TCP/IP" 10 145 360 42 $corPainel2 $corTexto
$btnTcpIp.TextAlign = "MiddleLeft"
$btnTcpIp.Add_Click({
    Set-Status "Resetando TCP/IP..."
    Write-Log "Executando netsh int ip reset ..."
    netsh int ip reset | Out-Null
    Write-Log "TCP/IP resetado. Reinicie o computador."
    Set-Status "Pronto (reinicie o PC)."
})

$btnRenovarIp = New-BotaoPadrao $tabRede "Liberar e renovar IP" 10 195 360 42 $corPainel2 $corTexto
$btnRenovarIp.TextAlign = "MiddleLeft"
$btnRenovarIp.Add_Click({
    Set-Status "Renovando IP..."
    Write-Log "Executando ipconfig /release e /renew ..."
    ipconfig /release | Out-Null
    ipconfig /renew | Out-Null
    Write-Log "IP renovado."
    Set-Status "Pronto."
})

$btnInfoRede = New-BotaoPadrao $tabRede "Mostrar informacoes de rede" 10 245 360 42 $corPainel2 $corTexto
$btnInfoRede.TextAlign = "MiddleLeft"
$btnInfoRede.Add_Click({
    $tabs.SelectedTab = $tabLog
    Write-Log "--- ipconfig /all ---"
    $saida = ipconfig /all
    foreach ($linha in $saida) { Write-Log $linha }
    Write-Log "--- fim ---"
})

$btnSpeedtest = New-BotaoPadrao $tabRede "Testar velocidade da internet" 10 295 360 42 $corPainel2 $corTexto
$btnSpeedtest.TextAlign = "MiddleLeft"
$btnSpeedtest.Add_Click({
    Write-Log "Abrindo teste de velocidade no navegador..."
    Start-Process "https://fast.com"
})

$btnDnsCloudflare = New-BotaoPadrao $tabRede "Definir DNS Cloudflare (1.1.1.1)" 390 45 360 42 $corPainel2 $corTexto
$btnDnsCloudflare.TextAlign = "MiddleLeft"
$btnDnsCloudflare.Add_Click({
    $adaptador = Get-AdaptadorAtivo
    if (-not $adaptador) { Write-Log "Nenhum adaptador de rede ativo encontrado."; return }
    Set-Status "Configurando DNS Cloudflare..."
    Set-DnsClientServerAddress -InterfaceIndex $adaptador.ifIndex -ServerAddresses ("1.1.1.1", "1.0.0.1")
    Write-Log "DNS Cloudflare configurado no adaptador $($adaptador.Name)."
    Set-Status "Pronto."
})

$btnDnsGoogle = New-BotaoPadrao $tabRede "Definir DNS Google (8.8.8.8)" 390 95 360 42 $corPainel2 $corTexto
$btnDnsGoogle.TextAlign = "MiddleLeft"
$btnDnsGoogle.Add_Click({
    $adaptador = Get-AdaptadorAtivo
    if (-not $adaptador) { Write-Log "Nenhum adaptador de rede ativo encontrado."; return }
    Set-Status "Configurando DNS Google..."
    Set-DnsClientServerAddress -InterfaceIndex $adaptador.ifIndex -ServerAddresses ("8.8.8.8", "8.8.4.4")
    Write-Log "DNS Google configurado no adaptador $($adaptador.Name)."
    Set-Status "Pronto."
})

$btnDnsQuad9 = New-BotaoPadrao $tabRede "Definir DNS Quad9 (9.9.9.9)" 390 145 360 42 $corPainel2 $corTexto
$btnDnsQuad9.TextAlign = "MiddleLeft"
$btnDnsQuad9.Add_Click({
    $adaptador = Get-AdaptadorAtivo
    if (-not $adaptador) { Write-Log "Nenhum adaptador de rede ativo encontrado."; return }
    Set-DnsClientServerAddress -InterfaceIndex $adaptador.ifIndex -ServerAddresses ("9.9.9.9", "149.112.112.112")
    Write-Log "DNS Quad9 configurado no adaptador $($adaptador.Name)."
})

$btnDnsOpenDns = New-BotaoPadrao $tabRede "Definir DNS OpenDNS" 390 195 360 42 $corPainel2 $corTexto
$btnDnsOpenDns.TextAlign = "MiddleLeft"
$btnDnsOpenDns.Add_Click({
    $adaptador = Get-AdaptadorAtivo
    if (-not $adaptador) { Write-Log "Nenhum adaptador de rede ativo encontrado."; return }
    Set-DnsClientServerAddress -InterfaceIndex $adaptador.ifIndex -ServerAddresses ("208.67.222.222", "208.67.220.220")
    Write-Log "DNS OpenDNS configurado no adaptador $($adaptador.Name)."
})

$btnDnsAuto = New-BotaoPadrao $tabRede "Restaurar DNS automatico (DHCP)" 390 245 360 42 $corPainel2 $corTexto
$btnDnsAuto.TextAlign = "MiddleLeft"
$btnDnsAuto.Add_Click({
    $adaptador = Get-AdaptadorAtivo
    if (-not $adaptador) { Write-Log "Nenhum adaptador de rede ativo encontrado."; return }
    Set-DnsClientServerAddress -InterfaceIndex $adaptador.ifIndex -ResetServerAddresses
    Write-Log "DNS automatico restaurado no adaptador $($adaptador.Name)."
})

# ==============================================================
#  ABA 5 - SISTEMA
# ==============================================================
New-Titulo $tabSistema "Informacoes e manutencao do sistema" 10 8 $corCiano

$txtInfoSistema = New-Object System.Windows.Forms.TextBox
$txtInfoSistema.Multiline = $true
$txtInfoSistema.ReadOnly = $true
$txtInfoSistema.ScrollBars = "Vertical"
$txtInfoSistema.BackColor = $corCartao
$txtInfoSistema.ForeColor = $corTexto
$txtInfoSistema.Font = New-Object System.Drawing.Font("Consolas", 9)
$txtInfoSistema.Location = New-Object System.Drawing.Point(10, 40)
$txtInfoSistema.Size = New-Object System.Drawing.Size(740, 300)
$tabSistema.Controls.Add($txtInfoSistema)

$btnAtualizarInfo = New-BotaoPadrao $tabSistema "Atualizar informacoes" 770 40 380 40 $corPainel2 $corTexto
$btnAtualizarInfo.Add_Click({
    try {
        $os = Get-CimInstance Win32_OperatingSystem
        $cpu = Get-CimInstance Win32_Processor | Select-Object -First 1
        $ram = [Math]::Round($os.TotalVisibleMemorySize / 1MB, 1)
        $ramLivre = [Math]::Round($os.FreePhysicalMemory / 1MB, 1)
        $disco = Get-CimInstance Win32_LogicalDisk -Filter "DeviceID='C:'"
        $discoLivre = [Math]::Round($disco.FreeSpace / 1GB, 1)
        $discoTotal = [Math]::Round($disco.Size / 1GB, 1)
        $texto  = "Sistema Operacional: $($os.Caption) (Build $($os.BuildNumber))`r`n"
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

New-BotaoPadrao $tabSistema "Abrir Configuracoes do Windows Update" 10 360 400 40 $corPainel2 $corTexto | ForEach-Object {
    $_.Add_Click({ Start-Process "ms-settings:windowsupdate" })
}
New-BotaoPadrao $tabSistema "Verificar atualizacoes agora" 10 410 400 40 $corPainel2 $corTexto | ForEach-Object {
    $_.Add_Click({
        Write-Log "Solicitando verificacao de atualizacoes..."
        Start-Process "UsoClient.exe" -ArgumentList "StartScan" -ErrorAction SilentlyContinue
        Write-Log "Verificacao solicitada."
    })
}
New-BotaoPadrao $tabSistema "Abrir Gerenciador de Dispositivos" 10 460 400 40 $corPainel2 $corTexto | ForEach-Object {
    $_.Add_Click({ Start-Process "devmgmt.msc" })
}
New-BotaoPadrao $tabSistema "Abrir Configuracoes do Sistema" 10 510 400 40 $corPainel2 $corTexto | ForEach-Object {
    $_.Add_Click({ Start-Process "ms-settings:about" })
}

New-BotaoPadrao $tabSistema "Pausar atualizacoes automaticas (7 dias)" 450 360 400 40 $corPainel2 $corTexto | ForEach-Object {
    $_.Add_Click({
        Set-Status "Pausando atualizacoes..."
        Write-Log "Pausando atualizacoes do Windows por 7 dias..."
        $pauseAte = (Get-Date).AddDays(7).ToString("yyyy-MM-dd")
        reg add "HKLM\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" /v PauseUpdatesExpiryTime /t REG_SZ /d "$pauseAte" /f | Out-Null
        Write-Log "Atualizacoes pausadas ate $pauseAte."
        Set-Status "Pronto."
    })
}
New-BotaoPadrao $tabSistema "Criar Ponto de Restauracao" 450 410 400 40 $corPainel2 $corTexto | ForEach-Object {
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
New-BotaoPadrao $tabSistema "Executar SFC /scannow" 450 460 400 40 $corPainel2 $corTexto | ForEach-Object {
    $_.Add_Click({
        $tabs.SelectedTab = $tabLog
        Set-Status "Executando SFC..."
        Write-Log "Executando sfc /scannow (isso pode demorar alguns minutos)..."
        Start-Process "sfc" -ArgumentList "/scannow" -Wait -NoNewWindow
        Write-Log "SFC finalizado."
        Set-Status "Pronto."
    })
}
New-BotaoPadrao $tabSistema "Executar DISM /RestoreHealth" 450 510 400 40 $corPainel2 $corTexto | ForEach-Object {
    $_.Add_Click({
        $tabs.SelectedTab = $tabLog
        Set-Status "Executando DISM..."
        Write-Log "Executando DISM /Online /Cleanup-Image /RestoreHealth (pode demorar bastante)..."
        Start-Process "DISM" -ArgumentList "/Online /Cleanup-Image /RestoreHealth" -Wait -NoNewWindow
        Write-Log "DISM finalizado."
        Set-Status "Pronto."
    })
}

# ==============================================================
#  ABA 6 - LIMPEZA
# ==============================================================
New-Titulo $tabLimpeza "Ferramentas de limpeza e manutencao" 10 8 $corCiano

function New-BotaoLimpeza($texto, $y, $acao) {
    $btn = New-BotaoPadrao $tabLimpeza $texto 10 $y 460 42 $corPainel2 $corTexto
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

New-BotaoLimpeza "Limpar logs de eventos do Windows" 345 {
    Set-Status "Limpando logs de eventos..."
    Write-Log "Limpando logs de eventos do Windows..."
    wevtutil el | ForEach-Object { wevtutil cl "$_" 2>$null }
    Write-Log "Logs de eventos limpos."
    Set-Status "Pronto."
}

New-BotaoLimpeza "Otimizar unidade C: (TRIM/Desfragmentar)" 395 {
    Set-Status "Otimizando unidade C:..."
    Write-Log "Executando Optimize-Volume na unidade C: ..."
    try {
        Optimize-Volume -DriveLetter C -Verbose -ErrorAction Stop
        Write-Log "Unidade C: otimizada."
    } catch {
        Write-Log "ERRO ao otimizar unidade: $_"
    }
    Set-Status "Pronto."
}

New-BotaoLimpeza "Criar Ponto de Restauracao" 445 {
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
$rodape.Location = New-Object System.Drawing.Point(15, 790)
$rodape.AutoSize = $true
$form.Controls.Add($rodape)

Write-Log "ROMA iniciado. Pronto para uso."

[System.Windows.Forms.Application]::Run($form)
