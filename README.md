# Social Network - Flutter GetX MVP

## Visão Geral

Este é um projeto MVP (Minimum Viable Product) de uma aplicação de rede social desenvolvida com Flutter. O objetivo principal é demonstrar uma arquitetura robusta, escalável e testável utilizando o framework **GetX** para gestão de estado, rotas e injeção de dependências.

A aplicação permite que os utilizadores façam login, visualizem uma lista de outros utilizadores com paginação infinita, pesquisem, favoritem perfis (com persistência local) e vejam um feed de postagens com suporte offline completo, incluindo imagens, c

Layout Responsivo: A interface adapta-se a diferentes tamanhos de tamanhos, oferecendo uma experiência otimizada tanto em telefone como em tablets/desktops.

Suporte a Múltiplos Idiomas: A aplicação está preparada para internacionalização (i18n), com suporte para Português e Inglês.
## Decisões Técnicas

-   **Gerenciamento de Estado e Arquitetura:** **GetX** foi escolhido pela sua simplicidade, performance e pelo ecossistema completo que oferece. A arquitetura segue um padrão **MVC (Model-View-Controller)**, com uma clara separação de responsabilidades:
    -   **View (Screen):** Responsável apenas por exibir a UI e reagir às mudanças de estado do Controller.
    -   **Controller:** Contém toda a lógica de negócio, gestão de estado e interações do utilizador.
    -   **Binding:** Gere a injeção de dependências, inicializando os controllers e repositórios necessários para cada feature.

-   **Persistência Local:**
    -   **shared_preferences:** Utilizado para armazenar dados simples e leves, como o token de autenticação após o login.
    -   **Hive:** Uma base de dados NoSQL leve e rápida, usada para o cache local da lista de utilizadores e do feed de posts, permitindo uma experiência offline fluida. O estado de "favorito" de um utilizador também é guardado aqui.
    -   **cached_network_image:** Este pacote gere o cache de todas as imagens da aplicação (avatares e fotos de posts), garantindo que elas sejam exibidas mesmo sem conexão à internet.

-   **Estrutura de Projeto:** A estrutura de pastas é organizada por `features` (módulos de negócio como `auth`, `users`, `posts`) e camadas (`app`, `core`), promovendo baixo acoplamento e alta coesão.

-   **Testes:** A metodologia de desenvolvimento prioriza a testabilidade.
    -   **Testes Unitários:** Escritos para os `Controllers` para validar a lógica de negócio de forma isolada.
    -   **Testes de Widget:** Escritos para as `Screens` para garantir que a UI responde corretamente às interações do utilizador e às mudanças de estado.

-   **Integração Contínua (CI):** O projeto está configurado com **GitHub Actions** para garantir a qualidade e a estabilidade do código. O fluxo de trabalho, localizado em `.github/workflows/ci.yml`, é acionado a cada `push` ou `pull request` para o branch `main` e executa automaticamente os seguintes passos:
    -   `flutter analyze`: Verifica o código em busca de erros de lint e potenciais problemas.
    -   `flutter test`: Roda todos os testes unitários e de widget do projeto.

## Como Rodar Localmente

### Pré-requisitos

-   Flutter SDK (versão 3.35.2 • channel stable ou superior)
-   Um emulador Android ou iOS, ou um dispositivo físico

### Passos para Execução

1.  **Clone o repositório:**
    ```bash
    git clone https://github.com/caioscarassati/social_network_flutter.git
    ```

2.  **Crie o arquivo de ambiente:**
    Copie o conteúdo de `.env.example` para um novo ficheiro chamado `.env`.
    ```bash
    cp .env.example .env
    ```

3.  **Instale as dependências:**
    ```bash
    flutter pub get
    ```

4.  **Execute o gerador de código (essencial para o Hive):**
    Este comando gera os `TypeAdapters` necessários para a persistência de dados.
    ```bash
    flutter pub run build_runner build --delete-conflicting-outputs
    ```

5.  **Execute a aplicação:**
    ```bash
    flutter run
    ```

### Credenciais de Acesso para Teste
-   **Email:** `admin@email.com`
-   **Senha:** `admin123`


## Como Rodar os Testes

Para executar todos os testes unitários e de widget definidos no projeto, siga estes passos:

1.  **Gere os ficheiros de mock:**
    Os nossos testes dependem de simulações (`mocks`) das dependências externas. Execute o comando abaixo para gerar os ficheiros necessários.
    ```bash
    flutter pub run build_runner build --delete-conflicting-outputs
    ```

2.  **Execute os testes:**
    Use o seguinte comando para rodar todos os testes do projeto.
    ```bash
    flutter test
    ```

