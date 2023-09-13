server {
        listen 80;
        server_name operacao-hml.credseller.com.br;

        root /credseller/operacao;

        index index.html;
        charset utf-8;

        location / {
                try_files $uri $uri/ /index.html;
                add_header Cache-Control "no-store, no-cache, must-revalidate";
        }

        location ~* \.(jpg|jpeg|gif|png|svg|webp|js|css|eot|otf|ttf|ttc|woff|woff2|font.css)$ {
                try_files $uri $uri/ /index.html;
                expires 1
                add_header Cache-Control "public";
                access_log off;
        }

        location = /robots.txt  { access_log off; log_not_found off; }

        location ~ /\.(?!well-known).* {
                deny all;
        }
}
