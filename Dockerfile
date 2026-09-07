# Usamos o Nginx ultraleve como base
FROM nginx:alpine

# Copiamos nosso código fonte para dentro da imagem imutável
COPY index.html /usr/share/nginx/html/index.html

# Expomos a porta 80 (O Traefik vai se conectar nela)
EXPOSE 80