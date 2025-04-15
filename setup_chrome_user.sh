#!/bin/bash

# Verifica se está sendo executado como root
if [[ $EUID -ne 0 ]]; then
   echo "Este script precisa ser executado como root."
   exit 1
fi

echo "==> Atualizando pacotes..."
apt update -y

echo "==> Instalando dependências para baixar o Chrome..."
apt install -y wget gnupg

echo "==> Baixando chave do repositório do Google..."
wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | gpg --dearmor -o /usr/share/keyrings/google-chrome.gpg

echo "==> Adicionando repositório do Chrome..."
echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/google-chrome.gpg] http://dl.google.com/linux/chrome/deb/ stable main' | tee /etc/apt/sources.list.d/google-chrome.list

echo "==> Instalando Google Chrome..."
apt update -y
apt install -y google-chrome-stable

echo "==> Criando usuário 'usuario'..."

# Solicita a senha do usuário
read -s -p "Digite a senha para o novo usuário 'usuario': " USUARIO_SENHA
echo
read -s -p "Confirme a senha: " USUARIO_SENHA_CONFIRMA
echo

if [ "$USUARIO_SENHA" != "$USUARIO_SENHA_CONFIRMA" ]; then
    echo "As senhas não coincidem. Abortando."
    exit 1
fi

# Cria o usuário e define a senha
useradd -m -s /bin/bash usuario
echo "usuario:$USUARIO_SENHA" | chpasswd

# Adiciona o usuário ao grupo sudo
usermod -aG sudo usuario

echo "Usuário 'usuario' criado com permissões de administrador."
