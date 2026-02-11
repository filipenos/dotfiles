# dotfiles

Base público do meu setup de shell e ferramentas.

Este repositório é o bootstrap principal. Configurações privadas/sensíveis ficam em
`~/dotfiles-private`, carregado automaticamente por `dotfilesrc` quando presente.

## Instalação

```sh
wget https://raw.githubusercontent.com/filipenos/dotfiles/main/install.sh -O - | bash
```

Alternativa com `curl`:

```sh
curl -fsSL https://raw.githubusercontent.com/filipenos/dotfiles/main/install.sh | bash
```

## Pré-requisitos

- `git`
- `bash`
- `wget` ou `curl` para bootstrap remoto

## O que este repositório cobre

- `dotfilesrc`: aliases, PATH e carregamento do ambiente.
- `zshrc`: configuração de plugins/tema do Zsh via Antigen.
- `bin/`: scripts utilitários.
- `install.sh`: bootstrap inicial.

## Integração com dotfiles-private

Quando `~/dotfiles-private` existir, o `dotfilesrc` deste projeto carrega:

- `~/dotfiles-private/dotfilesrc`
- `~/dotfiles-private/host/$HOST/dotfilesrc` (quando existir)

Também adiciona `~/dotfiles-private/bin` no `PATH`.

## Troubleshooting

- `missing required command: git`: instale o Git e rode novamente.
- erro de link do `nvim`: remova `~/.config/nvim/init.vim` e rode o instalador de novo.
- para remover o bootstrap do shell e o diretório local:

```sh
bash "$HOME/dotfiles/install.sh" remove
```
