# Bot Discord em Elixir

Projeto desenvolvido para a disciplina de Programação Funcional.

## Tecnologias

- Elixir
- Mix
- Nostrum
- HTTPoison
- Jason
- OTP / GenServer

## Como configurar o token

O token do bot deve ser configurado por variável de ambiente.

No PowerShell:

```powershell
[Environment]::SetEnvironmentVariable("DISCORD_TOKEN", "SEU_TOKEN_AQUI", "User")
````

Depois feche e abra o terminal novamente.

## Como instalar

```bash
mix deps.get
```

## Como executar

```bash
mix run --no-halt
```

## Comandos

```text
!ping
!cachorro
!clima fortaleza
!cep 60160170
!conv 200 USD BRL
!numero 42 trivia
!lembrar prova amanhã
!lembretes
!curiosidade fortaleza
```

## Estrutura

```text
lib/
├── discord_bot_elixir.ex
└── discord_bot_elixir/
    ├── consumer.ex
    ├── commands.ex
    └── store.ex
```