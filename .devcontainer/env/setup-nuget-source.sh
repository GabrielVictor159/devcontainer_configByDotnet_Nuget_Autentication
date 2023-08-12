#!/bin/bash
sudo apt-get update
sudo apt-get -y install whiptail
# Função para ler variáveis do arquivo .env se ele existir
read_env_file() {
    if [ -e "./.devcontainer/env/NugetAutenticator.env" ]; then
        source ./.devcontainer/env/NugetAutenticator.env
    fi
}

# Função para adicionar NugetAutenticator.env ao .gitignore se necessário
add_to_gitignore() {
    for dir in $(find . -type d); do
        if [ -e "$dir/.gitignore" ]; then
            if ! grep -q "/.devcontainer/env/NugetAutenticator.env" "$dir/.gitignore"; then
                echo "NugetAutenticator.env" >> "$dir/.gitignore"
            fi
        fi
    done
}

# Lê variáveis do arquivo .env se existir
read_env_file
# Se as variáveis não estiverem definidas, solicita ao usuário usando whiptail
if [ -z "$NUGET_USERNAME" ]; then
    NUGET_USERNAME=$(whiptail --title "E-mail" --inputbox "Insira o seu e-mail para o NuGet:" 8 60 3>&1 1>&2 2>&3)
fi

if [ -z "$NUGET_PASSWORD" ]; then
    NUGET_PASSWORD=$(whiptail --title "Token" --passwordbox "Insira o seu token para o NuGet:" 8 60 3>&1 1>&2 2>&3)
fi

# Cria o comando dotnet nuget com as credenciais inseridas
nuget_command="dotnet nuget add source https://pkgs.dev.azure.com/your-organization/_packaging/your-feed/nuget/v3/index.json --name gcsbvivofeed --username \"$NUGET_USERNAME\" --password \"$NUGET_PASSWORD\" --store-password-in-clear-text"

# Executa o comando
eval "$nuget_command"
eval "dotnet dev-certs https --trust"
# Cria o arquivo .env e adiciona as variáveis
echo "NUGET_USERNAME=\"$NUGET_USERNAME\"" > ./.devcontainer/env/NugetAutenticator.env
echo "NUGET_PASSWORD=\"$NUGET_PASSWORD\"" >> ./.devcontainer/env/NugetAutenticator.env

# Adiciona NugetAutenticator.env ao .gitignore se necessário
add_to_gitignore


