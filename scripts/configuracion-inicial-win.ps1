Write-Host "Instalando OpenSSH Server..."

Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0

Write-Host "Iniciando servicio SSH..."

Start-Service sshd
Set-Service -Name sshd -StartupType Automatic

Write-Host "Abriendo firewall para SSH..."

New-NetFirewallRule -Name sshd `
  -DisplayName "OpenSSH Server (sshd)" `
  -Enabled True `
  -Direction Inbound `
  -Protocol TCP `
  -Action Allow `
  -LocalPort 22

Write-Host "Creando usuario ansible..."

if (!(Get-LocalUser -Name "ansible" -ErrorAction SilentlyContinue)) {
    net user ansible usuario /add
    net localgroup Administrators ansible /add
}

Write-Host "Configuración terminada"