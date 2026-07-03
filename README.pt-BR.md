# Windows Maintenance Toolkit

🌎 **English version**  
➡️ [README.md](README.md)

Um conjunto de scripts em PowerShell para manter máquinas Windows limpas, organizadas e otimizadas de forma simples e segura.

O projeto foi desenvolvido principalmente para desenvolvedores, automatizando tarefas comuns de manutenção sem remover arquivos pessoais ou projetos.

## Preview

![Windows Maintenance Toolkit](assets/preview.png)

---

## Recursos

- Limpeza diária de arquivos temporários
- Limpeza da Lixeira
- Limpeza do cache de miniaturas
- Limpeza do cache DNS
- Limpeza semanal do Docker (quando instalado)
- Verificação do cache do npm
- Limpeza do store do pnpm (quando instalado)
- Manutenção do Windows utilizando DISM e SFC
- Suporte ao WSL
- Integração com o Agendador de Tarefas do Windows
- Geração automática de logs

---

## Estrutura do Projeto

```text
windows-maintenance-toolkit/
│
├── scripts/
│   ├── Daily.ps1
│   ├── Weekly.ps1
│   └── Monthly.ps1
│
├── logs/
│
├── Menu.ps1
├── Start.bat
├── README.md
├── README.pt-BR.md
└── LICENSE.txt
```

---

## Tipos de Manutenção

### Daily Cleanup

Executa uma limpeza segura incluindo:

- Arquivos temporários do usuário
- Arquivos temporários do Windows
- Lixeira
- Cache de miniaturas
- Arquivos temporários locais
- Cache DNS

**Frequência recomendada:** diariamente.

---

### Weekly Cleanup

Inclui tudo da limpeza diária, além de:

- Limpeza do Docker (apenas recursos não utilizados)
- Verificação do cache do npm
- Limpeza do store do pnpm (quando instalado)

**Frequência recomendada:** semanalmente.

---

### Monthly Maintenance

Executa:

- Limpeza de componentes do Windows (DISM)
- Verificação de integridade do sistema (SFC)
- Encerramento do WSL

A compactação do disco virtual do WSL permanece desabilitada por padrão e deve ser configurada manualmente pelo usuário.

**Frequência recomendada:** mensalmente.

---

## Automação

O toolkit permite criar automaticamente tarefas no Agendador de Tarefas do Windows.

As opções disponíveis são:

- Limpeza diária ao iniciar sessão
- Limpeza semanal aos domingos

As tarefas também podem ser removidas diretamente pelo menu.

---

## Segurança

Este projeto **não remove**:

- Arquivos pessoais
- Documentos
- Downloads
- Projetos
- Código-fonte
- Fotos
- Vídeos

A limpeza é restrita a arquivos temporários, caches e recursos de desenvolvimento que podem ser recriados automaticamente.

Mesmo assim, recomenda-se revisar os scripts antes da utilização para garantir que atendam às suas necessidades.

---

## Requisitos

- Windows 10 ou Windows 11
- PowerShell 5.1 ou superior
- Privilégios de administrador

Docker, npm e pnpm são opcionais.

---

## Como utilizar

1. Execute o arquivo:

```text
Start.bat
```

2. Escolha a opção desejada no menu interativo.

O toolkit executará automaticamente a rotina selecionada.

---

## Logs

Todos os logs são armazenados na pasta:

```text
logs/
```

Cada execução gera ou atualiza um arquivo de log correspondente ao tipo de manutenção executada.

---

## Licença

Distribuído sob a licença MIT. Consulte o arquivo `LICENSE.txt` para mais informações.