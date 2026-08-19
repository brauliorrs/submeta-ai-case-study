# Submeta.AI — Case Study

**Inteligência para Submissão Científica.**

O **Submeta.AI** é uma plataforma SaaS em desenvolvimento para apoiar pesquisadores antes da submissão de artigos científicos. A proposta é analisar a aderência de um manuscrito ao periódico escolhido, considerando diretrizes editoriais, foco e escopo, normas para autores e padrões observáveis nas publicações recentes.

Este repositório documenta o produto, suas decisões de arquitetura, regras de privacidade, modelo de negócio e instruções para implementação pelo Codex. Ele não deve conter segredos, chaves de API, e-mails sensíveis, manuscritos ou código proprietário exposto indevidamente.

---

## Resumo executivo

O Submeta.AI atua como uma camada de inteligência editorial antes da submissão científica.

A plataforma busca reduzir erros formais, desalinhamento com escopo de revistas, inconsistências de estrutura, lacunas metodológicas aparentes e problemas de aderência às normas editoriais.

**Tipo:** SaaS acadêmico com IA  
**Mercado inicial:** Brasil  
**Posicionamento:** avaliação editorial inteligente para artigos científicos antes da submissão  
**Modelo:** freemium com relatório completo pago e versão ajustada opcional  
**Privacidade:** processamento temporário, sem armazenamento permanente do manuscrito

---

## Problema

Pesquisadores frequentemente submetem artigos sem uma análise prévia adequada de aderência ao periódico.

Isso pode gerar:

- rejeição por inadequação ao escopo;
- problemas com normas da revista;
- formatação inconsistente;
- ausência de elementos obrigatórios;
- desalinhamento com padrões de artigos publicados;
- perda de tempo no processo editorial;
- retrabalho antes de nova submissão.

O problema é especialmente relevante para pesquisadores iniciantes, pós-graduandos, grupos de pesquisa e autores que submetem para periódicos com diretrizes extensas.

---

## Solução

O Submeta.AI propõe uma plataforma capaz de:

1. permitir que o usuário selecione ou informe o periódico;
2. acessar a página oficial do periódico;
3. localizar foco e escopo, diretrizes aos autores e normas de submissão;
4. observar padrões básicos ou avançados de publicações recentes;
5. receber o manuscrito do usuário;
6. comparar artigo, escopo e normas editoriais;
7. gerar diagnóstico preliminar gratuito;
8. oferecer relatório completo pago;
9. oferecer versão editorialmente ajustada no plano avançado;
10. excluir arquivos e conteúdo temporário após a entrega.

---

## Regra central da avaliação gratuita

A avaliação gratuita **não é fictícia** e **não deve ser genérica**.

Ela deve combinar:

```text
perfil editorial básico real do periódico
+
pacote reduzido do manuscrito
+
API free/free-tier
=
pré-avaliação editorial gratuita
```

A versão gratuita deve consultar o periódico selecionado antes de avaliar o manuscrito. O sistema deve tentar obter:

- página oficial do periódico;
- foco e escopo;
- diretrizes aos autores;
- normas de submissão;
- tipos de artigo aceitos;
- política de avaliação, quando disponível;
- exigências formais;
- publicações recentes;
- padrões básicos dos artigos publicados.

Por privacidade e custo, a avaliação gratuita **não deve enviar o manuscrito completo** para API free/free-tier. Ela deve usar apenas um pacote reduzido com título, resumo, palavras-chave, nomes das seções, contagens, presença ou ausência de elementos obrigatórios e trechos mínimos quando estritamente necessário.

---

## Diferença entre gratuito e pago

| Item | Gratuito | Pago |
|---|---|---|
| Acessa o periódico | Sim | Sim |
| Lê diretrizes | Sim, nível básico | Sim, nível completo |
| Analisa publicações recentes | Padrões básicos | Padrões mais profundos |
| Envia manuscrito inteiro para IA | Não | Sim, dentro do limite contratado |
| Usa API free/free-tier | Sim | Não |
| Usa API paga | Não | Sim |
| Gera nota estimada | Sim | Sim |
| Gera plano detalhado | Não | Sim |
| Gera versão ajustada | Não | Apenas no plano correspondente |

---

## Produtos iniciais

### Diagnóstico gratuito

Entrega uma pré-avaliação com:

- nota atual estimada;
- nota potencial após ajustes;
- risco geral de rejeição;
- notas por grandes áreas;
- três a cinco principais riscos;
- recomendação preliminar;
- convite para relatório completo.

### Relatório completo

Preço promocional de lançamento: **R$ 49,99**.

Inclui análise aprofundada do manuscrito dentro do limite contratado, comparação com o perfil editorial completo do periódico, riscos de rejeição, checklist e recomendações priorizadas.

### Relatório completo + versão ajustada

Preço promocional de lançamento: **R$ 99,99**.

Inclui o relatório completo e uma versão editorialmente ajustada das seções críticas, sem criar dados, resultados ou referências inexistentes.

### Ajuste posterior

Caso o usuário compre apenas o relatório completo e depois queira a versão ajustada, o valor será **R$ 129,99** e o manuscrito deverá ser reenviado, porque o conteúdo é excluído após a entrega.

---

## Pagamento

Para o lançamento no Brasil, o gateway principal recomendado é o **Mercado Pago**, por melhor aderência a Pix e cartão nacional.

O PayPal pode ficar como integração futura ou secundária para expansão internacional.

A implementação deve usar uma abstração de pagamento, permitindo trocar ou adicionar provedores depois:

```text
PaymentProvider
  ├─ MercadoPagoProvider
  └─ PayPalProvider futuro
```

---

## Acesso interno autorizado

O projeto deve permitir um fluxo interno de teste e operação sem cobrança para e-mails autorizados.

Essa regra **não deve ser implementada como cupom público** e **não deve expor e-mails reais no código-fonte**.

O fluxo esperado é:

```text
Usuário informa e-mail
↓
Sistema normaliza o e-mail
↓
Sistema calcula hash/HMAC do e-mail
↓
Sistema compara com allowlist configurada em GitHub Secrets / variáveis seguras
↓
Se autorizado, exige código por e-mail em produção
↓
Após verificação, pula checkout
↓
Gera relatório completo sem cobrança
↓
Envia PDF para o e-mail autorizado
↓
Exclui manuscrito, texto extraído, prompts e arquivos temporários
```

Em ambiente de desenvolvimento, o bypass pode ser liberado diretamente. Em produção, deve exigir código enviado ao próprio e-mail autorizado para evitar abuso.

Detalhes técnicos estão em [`docs/internal-free-access.md`](docs/internal-free-access.md).

---

## GitHub Secrets e dados sensíveis

Nenhuma informação sensível deve ser commitada no repositório.

Devem ser configurados como GitHub Secrets ou variáveis seguras do ambiente de deploy:

- chaves de IA;
- tokens do Mercado Pago;
- segredos de hash e criptografia;
- credenciais de e-mail transacional;
- allowlist de acesso interno;
- URL de banco de dados;
- URL do Redis;
- segredos de webhook.

A lista de secrets esperados está em [`docs/github-secrets.md`](docs/github-secrets.md).

---

## Privacidade

Como o produto lida com manuscritos acadêmicos, a política de dados é parte central do projeto.

Diretrizes obrigatórias:

- não armazenar manuscritos permanentemente;
- evitar acesso humano ao conteúdo;
- não registrar texto do artigo em logs;
- não salvar prompts contendo conteúdo do manuscrito;
- excluir arquivos após download ou envio por e-mail;
- informar claramente os limites da análise;
- não prometer aceite em periódico;
- tratar a IA como apoio, não como decisão editorial.

---

## Arquitetura conceitual

```text
Usuário
  ↓
Busca/seleção do periódico
  ↓
Coleta de diretrizes e publicações recentes
  ↓
Geração de perfil editorial básico ou completo
  ↓
Upload do manuscrito
  ↓
Extração temporária do texto
  ↓
Diagnóstico gratuito ou relatório pago
  ↓
Pagamento ou bypass interno autorizado
  ↓
Geração do relatório
  ↓
Download único ou envio por e-mail
  ↓
Exclusão automática do conteúdo temporário
```

---

## Stack prevista

| Camada | Decisão inicial |
|---|---|
| Frontend | Next.js, React, Tailwind, shadcn/ui |
| Backend | API web para jobs, pagamentos e downloads |
| Worker | Python com Redis/RQ |
| Banco | PostgreSQL / Supabase |
| Fila | Redis |
| IA gratuita | API free/free-tier com pacote reduzido |
| IA paga | API paga com maior controle e qualidade |
| Pagamento | Mercado Pago no Brasil |
| E-mail | Resend, Brevo, SendGrid ou SES |
| Armazenamento | Temporário, privado e criptografado |
| Segurança | hashes, secrets, webhooks, deleção automática |

---

## Roadmap do MVP

- Landing page
- Busca de periódico
- Perfil editorial básico real
- Upload seguro de manuscrito
- Diagnóstico gratuito não genérico
- Relatório completo pago
- Checkout Mercado Pago
- Download único
- Acesso interno autorizado por secret
- Envio automático de PDF para e-mail autorizado
- Exclusão automática dos arquivos temporários
- Política de privacidade clara

---

## Limitações

A plataforma não substitui pareceristas, editores ou avaliação científica humana.

Ela atua como apoio pré-submissão e pode indicar riscos, inconsistências e pontos de melhoria, mas não garante aceite, publicação ou adequação total a um periódico.

---

## Status

Projeto privado em desenvolvimento.

Este repositório público funciona como documentação profissional do case e guia de implementação, sem exposição de segredos ou código-fonte sensível.

---

## Autor

**Bráulio Roberto Rangel da Silva**

GitHub: [@brauliorrs](https://github.com/brauliorrs)
