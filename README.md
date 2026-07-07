# Submeta Aí — Case Study

**Plataforma com IA para apoiar pesquisadores antes da submissão de artigos científicos.**

O **Submeta Aí** é um produto digital em desenvolvimento voltado à análise pré-submissão de artigos acadêmicos. A proposta é ajudar pesquisadores a verificar aderência às diretrizes de periódicos, escopo editorial, padrões de publicação e pontos de melhoria antes do envio do manuscrito.

Este repositório não contém o código-fonte privado da plataforma. Ele documenta a proposta do produto, problema, solução, arquitetura conceitual, modelo de negócio e competências demonstradas.

---

## Resumo executivo

O Submeta Aí atua como uma camada de inteligência editorial antes da submissão científica.

A plataforma busca reduzir erros formais, desalinhamento com escopo de revistas, inconsistências de formatação e problemas de aderência às normas editoriais.

**Tipo:** SaaS acadêmico / produto com IA  
**Status:** em desenvolvimento  
**Stack prevista:** aplicação web, APIs de IA, análise de páginas de periódicos, upload de manuscritos e geração de relatórios  
**Modelo de negócio:** freemium, relatórios pagos e análises avançadas

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

O problema é especialmente relevante para pesquisadores iniciantes, pós-graduandos e autores que submetem para periódicos com diretrizes extensas.

---

## Solução

O Submeta Aí propõe uma plataforma capaz de:

1. acessar ou receber informações sobre o periódico;
2. analisar diretrizes para autores;
3. identificar padrões de publicações recentes;
4. receber o manuscrito do usuário;
5. comparar artigo, escopo e normas editoriais;
6. gerar relatório de aderência;
7. indicar pontos fortes, fragilidades e ajustes prioritários;
8. oferecer uma versão gratuita básica e relatórios pagos mais completos.

---

## Funcionalidades previstas

- Busca ou indicação do periódico
- Leitura das diretrizes para autores
- Análise de escopo editorial
- Verificação de estrutura do manuscrito
- Avaliação de aderência formal
- Comparação com padrões de publicações recentes
- Upload de artigo
- Relatório básico gratuito
- Relatório completo pago
- Recomendações objetivas de melhoria
- Política de privacidade com descarte do arquivo após análise

---

## Arquitetura conceitual

```text
Usuário
  ↓
Upload do manuscrito ou formulário de análise
  ↓
Identificação do periódico
  ↓
Coleta das diretrizes editoriais
  ↓
Análise de escopo e padrões de publicação
  ↓
Processamento por IA
  ↓
Geração de relatório
  ↓
Versão gratuita ou relatório pago
```

---

## Modelo de produto

### Versão gratuita

A versão gratuita deve oferecer uma análise básica, útil e limitada, com foco em:

- escopo geral;
- estrutura mínima;
- principais riscos de submissão;
- pontos formais mais evidentes;
- indicação de necessidade de análise completa.

### Versão paga

A versão paga pode aprofundar:

- aderência às normas;
- comparação com artigos publicados;
- linguagem acadêmica;
- estrutura argumentativa;
- resumo, palavras-chave e referências;
- checklist editorial;
- recomendações priorizadas.

---

## Diferencial

O Submeta Aí não deve ser apenas um corretor de texto.

A proposta é combinar:

- análise do manuscrito;
- análise do periódico;
- leitura das diretrizes;
- padrões de publicação;
- inteligência editorial;
- recomendações acionáveis.

O foco é aumentar a qualidade da submissão antes que o artigo entre no fluxo editorial.

---

## Cuidados de privacidade

Como o produto lida com manuscritos acadêmicos, a política de dados é parte central do projeto.

Diretrizes previstas:

- não armazenar manuscritos de forma persistente;
- remover arquivos após a geração do relatório;
- evitar acesso humano ao conteúdo;
- informar claramente os limites da análise;
- não prometer aceite em periódico;
- tratar a IA como apoio, não como decisão editorial.

---

## Stack conceitual

| Camada | Possibilidades |
|---|---|
| Frontend | Aplicação web responsiva |
| Backend | API para processamento dos documentos |
| IA | Modelos via API para análise textual e editorial |
| Dados externos | Páginas de periódicos, diretrizes e publicações recentes |
| Pagamento | Integração com gateway de pagamento |
| Relatórios | PDF, HTML ou painel web |
| Privacidade | Descarte automático e controle de retenção |

---

## Modelo de negócio

O modelo inicial pode combinar:

- análise gratuita limitada;
- relatório intermediário pago;
- relatório completo pago;
- upgrade de relatório;
- planos futuros para grupos de pesquisa, programas de pós-graduação ou instituições.

Exemplo de estrutura:

```text
Free → análise básica
Pago 1 → relatório editorial objetivo
Pago 2 → relatório completo com comparação e recomendações avançadas
```

---

## O que este projeto demonstra

Este case demonstra competências em:

- desenho de produto SaaS;
- aplicação de IA a problemas acadêmicos reais;
- análise de mercado científico;
- estruturação de modelo freemium;
- automação de leitura editorial;
- UX para pesquisadores;
- integração com APIs;
- preocupação com privacidade;
- monetização de produto digital;
- visão estratégica para nicho acadêmico.

---

## Roadmap

### MVP

- Landing page
- Formulário de indicação do periódico
- Upload de manuscrito
- Análise básica gratuita
- Geração de relatório
- Limite de palavras
- Política de privacidade clara

### Próximas etapas

- Integração com pagamento
- Versão paga intermediária
- Versão paga completa
- Histórico local temporário de relatório
- Expansão para diferentes periódicos
- Internacionalização futura
- Painel de análise para pesquisadores
- API interna para classificação editorial

---

## Limitações

A plataforma não substitui pareceristas, editores ou avaliação científica humana.

Ela atua como apoio pré-submissão e pode indicar riscos, inconsistências e pontos de melhoria, mas não garante aceite, publicação ou adequação total a um periódico.

---

## Status

Projeto privado em desenvolvimento.

Este repositório público funciona como documentação profissional do case, sem exposição do código-fonte.

---

## Autor

**Bráulio Roberto Rangel da Silva**

GitHub: [@brauliorrs](https://github.com/brauliorrs)
