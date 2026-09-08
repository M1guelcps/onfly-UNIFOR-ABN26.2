# 🚀 Mini-PaaS Educacional (Vercel/Netlify Clone)

Uma Plataforma como Serviço (PaaS) leve, segura e automatizada, construída do zero para hospedar múltiplas aplicações web em uma única VPS com recursos limitados (4 GB de RAM). 

Este projeto foi desenvolvido com foco educacional para aprofundar conhecimentos em **Linux, Docker, Redes, CI/CD e Arquitetura de Software**, replicando em menor escala o fluxo mágico de deploys de plataformas como Vercel e Netlify.

---

## 🏗️ Arquitetura e Fluxo

O sistema utiliza contêineres imutáveis e roteamento dinâmico. O desenvolvedor não precisa acessar a VPS para publicar o projeto.

```text
[ Desenvolvedor ]
       │ (git push)
       ▼
[ GitHub Actions ] ──(Build)──> [ GitHub Container Registry (GHCR) ]
       │
       │ (SSH Auth + Docker Pull)
       ▼
[ VPS Ubuntu (4GB RAM) ]
       │
       ├─► [ Traefik (Reverse Proxy) ] ──(Gera SSL Automático Let's Encrypt)
       │         │
       │         ├─► app1.meudominio.com (App Frontend - Limite: 50MB RAM)
       │         ├─► app2.meudominio.com (API Node.js  - Limite: 100MB RAM)
       │         └─► app3.meudominio.com (API Python   - Limite: 100MB RAM)
       │
       └─► [ PostgreSQL Central ] (Isolado na rede interna - 400MB RAM)
