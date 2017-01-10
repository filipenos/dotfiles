#!/bin/bash

randomizer -h >/dev/null 2>&1 || go install beneficiofacil.gopkg.net/site/cmd/randomizer

help() {
  echo "use $0 {cpf|cnpj|cep|date|name}"
}

case "$1" in
  cpf)
    value=$(randomizer -cpf 1)
    ;;
  cnpj)
    value=$(randomizer -cnpj 1)
    ;;
  cep)
    value=$(mysql -u test -ptest cep -Nse "SELECT cep FROM log_logradouro WHERE ufe_sg = 'SP' AND loc_nu_sequencial = 9668 ORDER BY RAND() LIMIT 1")
    ;;
  date)
    value=$(randomizer -dates 1)
    ;;
  name)
    value=$(randomizer -names 1)
    ;;
  *)
    help
    exit 1
    ;;
esac

echo "$value" | copy
echo "copy  $value to clipboard"
