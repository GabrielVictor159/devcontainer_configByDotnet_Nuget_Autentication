

# Função para ler variáveis do arquivo .env se ele existir
read_env_file() {
    if [ -e "./.devcontainer/env/NugetAutenticator.env" ]; then
        source ./.devcontainer/env/NugetAutenticator.env
    fi
}

# Função para adicionar NugetAutenticator.env ao .gitignore se necessário
add_to_gitignore() {
    local entry="NugetAutenticator.env"

    for dir in $(find . -type d); do
        gitignore_path="$dir/.gitignore"
        if [ -e "$gitignore_path" ] && ! grep -qxF "$entry" "$gitignore_path"; then
            echo "$entry" >> "$gitignore_path"
        fi
    done
}


# Lê variáveis do arquivo .env se existir
read_env_file

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


