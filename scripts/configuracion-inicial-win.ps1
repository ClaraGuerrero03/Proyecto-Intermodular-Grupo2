Write-Host "=== CONFIGURACIÓN INICIAL WINDOWS PARA ANSIBLE ==="

Write-Host "Instalando OpenSSH Server..."
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0 -ErrorAction SilentlyContinue

Write-Host "Iniciando servicio SSH..."
Start-Service sshd -ErrorAction SilentlyContinue
Set-Service -Name sshd -StartupType Automatic

Write-Host "Configurando regla de firewall para SSH..."
if (!(Get-NetFirewallRule -Name sshd -ErrorAction SilentlyContinue)) {
    New-NetFirewallRule `
        -Name sshd `
        -DisplayName "OpenSSH Server (sshd)" `
        -Enabled True `
        -Direction Inbound `
        -Protocol TCP `
        -Action Allow `
        -LocalPort 22
}

Write-Host "Configurando perfil de red como Privado..."
Set-NetConnectionProfile -NetworkCategory Private

Write-Host "Activando WinRM..."
Enable-PSRemoting -Force
Set-Service WinRM -StartupType Automatic
Start-Service WinRM

Write-Host "Configurando autenticación WinRM..."
Set-Item WSMan:\localhost\Service\Auth\Basic -Value $true
Set-Item WSMan:\localhost\Service\AllowUnencrypted -Value $true

Write-Host "Creando usuario ansible si no existe..."
if (!(Get-LocalUser -Name "ansible" -ErrorAction SilentlyContinue)) {
    net user ansible usuario /add
}

Write-Host "Añadiendo usuario ansible al grupo administradores..."
$grupoAdmins = (Get-LocalGroup | Where-Object {$_.SID -like "S-1-5-32-544"}).Name
if (!(Get-LocalGroupMember -Group $grupoAdmins -ErrorAction SilentlyContinue | Where-Object {$_.Name -like "*\ansible"})) {
    Add-LocalGroupMember -Group $grupoAdmins -Member ansible
}

Write-Host "Configurando política de ejecución PowerShell..."
Set-ExecutionPolicy RemoteSigned -Scope LocalMachine -Force

Write-Host "Permitindo ping desde la red..."

if (!(Get-NetFirewallRule -DisplayName "Permitir ICMPv4-In" -ErrorAction SilentlyContinue)) {

    New-NetFirewallRule `
        -DisplayName "Permitir ICMPv4-In" `
        -Protocol ICMPv4 `
        -IcmpType 8 `
        -Direction Inbound `
        -Action Allow

}

Write-Host "=== CONFIGURACIÓN TERMINADA CORRECTAMENTE ==="Write-Host "=== CONFIGURACIÓN INICIAL WINDOWS PARA ANSIBLE ==="

Write-Host "Instalando OpenSSH Server..."
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0 -ErrorAction SilentlyContinue

Write-Host "Iniciando servicio SSH..."
Start-Service sshd -ErrorAction SilentlyContinue
Set-Service -Name sshd -StartupType Automatic

Write-Host "Configurando regla de firewall para SSH..."
if (!(Get-NetFirewallRule -Name sshd -ErrorAction SilentlyContinue)) {
    New-NetFirewallRule `
        -Name sshd `
        -DisplayName "OpenSSH Server (sshd)" `
        -Enabled True `
        -Direction Inbound `
        -Protocol TCP `
        -Action Allow `
        -LocalPort 22
}

Write-Host "Configurando perfil de red como Privado..."
Set-NetConnectionProfile -NetworkCategory Private

Write-Host "Activando WinRM..."
Enable-PSRemoting -Force
Set-Service WinRM -StartupType Automatic
Start-Service WinRM

Write-Host "Configurando autenticación WinRM..."
Set-Item WSMan:\localhost\Service\Auth\Basic -Value $true
Set-Item WSMan:\localhost\Service\AllowUnencrypted -Value $true

Write-Host "Creando usuario ansible si no existe..."
if (!(Get-LocalUser -Name "ansible" -ErrorAction SilentlyContinue)) {
    net user ansible usuario /add
}

Write-Host "Añadiendo usuario ansible al grupo administradores..."
$grupoAdmins = (Get-LocalGroup | Where-Object {$_.SID -like "S-1-5-32-544"}).Name
if (!(Get-LocalGroupMember -Group $grupoAdmins -ErrorAction SilentlyContinue | Where-Object {$_.Name -like "*\ansible"})) {
    Add-LocalGroupMember -Group $grupoAdmins -Member ansible
}

Write-Host "Configurando política de ejecución PowerShell..."
Set-ExecutionPolicy RemoteSigned -Scope LocalMachine -Force

Write-Host "=== CONFIGURACIÓN TERMINADA CORRECTAMENTE ==="
