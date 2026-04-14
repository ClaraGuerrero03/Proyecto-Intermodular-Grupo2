#!/bin/bash

set -e

USUARIO_ANSIBLE="ansible"
CLAVE_PUBLICA="ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGKylU/v2RsVWooqVWU4qLgs+Co+8qlCDyCw3mIzApxB usuario@ubserver24virt"

echo "==> Creando usuario técnico si no existe..."
if ! id "$USUARIO_ANSIBLE" >/dev/null 2>&1; then
    sudo adduser --disabled-password --gecos "" "$USUARIO_ANSIBLE"
fi

echo "==> Añadiendo el usuario al grupo sudo..."
sudo usermod -aG sudo "$USUARIO_ANSIBLE"

echo "==> Creando directorio .ssh..."
sudo mkdir -p /home/$USUARIO_ANSIBLE/.ssh

echo "==> Instalando clave pública..."
echo "$CLAVE_PUBLICA" | sudo tee /home/$USUARIO_ANSIBLE/.ssh/authorized_keys >/dev/null

echo "==> Ajustando permisos..."
sudo chown -R $USUARIO_ANSIBLE:$USUARIO_ANSIBLE /home/$USUARIO_ANSIBLE/.ssh
sudo chmod 700 /home/$USUARIO_ANSIBLE/.ssh
sudo chmod 600 /home/$USUARIO_ANSIBLE/.ssh/authorized_keys

echo "==> Configurando sudo sin contraseña..."
echo "$USUARIO_ANSIBLE ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/$USUARIO_ANSIBLE >/dev/null
sudo chmod 440 /etc/sudoers.d/$USUARIO_ANSIBLE

echo "==> Comprobando que OpenSSH Server esté instalado..."
if ! dpkg -s openssh-server >/dev/null 2>&1; then
    sudo apt update
    sudo apt install -y openssh-server
fi

echo "==> Habilitando y arrancando SSH..."
sudo systemctl enable ssh
sudo systemctl restart ssh

echo "==> Bootstrap terminado correctamente."
