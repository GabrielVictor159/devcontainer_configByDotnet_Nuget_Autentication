# Docker-compose
Lembre-se de adicionar as variavéis de ambiente dos containers de aplicações secundarias no container de execução no docker-compose, as configurações do container de webapi são adicionadas automaticamente.

# Executando a aplicação
Lembre-se que qualquer aplicação secundaria no seu projeto deve ser executada individualmente no container, exemplo se eu tenho a aplicação Gcsb.Connect.Reports.Service dentro do meu workspace e se trata de um projeto distinto do webapi essa aplicação deve ser executada separadamente dentro do ambiente.