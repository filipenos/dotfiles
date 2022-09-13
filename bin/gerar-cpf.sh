#!/bin/bash

curl 'https://www.4devs.com.br/ferramentas_online.php' \
  -H 'authority: www.4devs.com.br' \
  -H 'accept: */*' \
  -H 'accept-language: pt-BR,pt;q=0.9,en-US;q=0.8,en;q=0.7,ja;q=0.6,zh-CN;q=0.5,zh;q=0.4' \
  -H 'cache-control: no-cache' \
  -H 'content-type: application/x-www-form-urlencoded; charset=UTF-8' \
  -H 'cookie: _ga_7RD2VB3FJH=GS1.1.1652799398.7.0.1652799398.0; AMP_TOKEN=%24NOT_FOUND; _ga=GA1.3.255698126.1649348015; _gid=GA1.3.316658504.1652799400; __gpi=UID=000003db16461480:T=1649349851:RT=1652799399:S=ALNI_MYpfkPi9M5kXR-7eFzxKMvCm3eevg; ___iat_ses=3BBD1E3AB02AFF2C; ___iat_vis=3BBD1E3AB02AFF2C.272d19ee0d97941f2b4a1ac596e9d83e.1652799399757.2a008c065700df63da540b0dd334c6b4.JJABMBAMAA.11111111.1.0; __gads=ID=6a61cd21cf718531-220f4603327c0060:T=1649348015:RT=1652799403:S=ALNI_MY9BxkFZ2x83K-4_XVUnzhuFAz7ZA' \
  -H 'origin: https://www.4devs.com.br' \
  -H 'pragma: no-cache' \
  -H 'referer: https://www.4devs.com.br/gerador_de_cpf' \
  -H 'sec-ch-ua: " Not A;Brand";v="99", "Chromium";v="101", "Google Chrome";v="101"' \
  -H 'sec-ch-ua-mobile: ?0' \
  -H 'sec-ch-ua-platform: "macOS"' \
  -H 'sec-fetch-dest: empty' \
  -H 'sec-fetch-mode: cors' \
  -H 'sec-fetch-site: same-origin' \
  -H 'user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/101.0.4951.64 Safari/537.36' \
  -H 'x-requested-with: XMLHttpRequest' \
  --data-raw 'acao=gerar_cpf&pontuacao=N&cpf_estado=' \
  --compressed
