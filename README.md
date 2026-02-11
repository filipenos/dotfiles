# dotfiles

Base público do meu setup de shell e ferramentas.

Este repositório é o bootstrap principal. Configurações privadas/sensíveis ficam em
`~/dotfiles-private`, carregado automaticamente por `dotfilesrc` quando presente.

## Instalação

```sh
wget https://raw.githubusercontent.com/filipenos/dotfiles/main/install.sh -O - | sh
```

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
