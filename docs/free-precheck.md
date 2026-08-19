# Diagnóstico gratuito com perfil editorial real

A versão gratuita do Submeta.AI não deve ser fictícia, genérica ou baseada apenas em uma nota estimada.

Ela deve ser uma pré-avaliação real, limitada em profundidade, baseada no periódico selecionado.

## Fórmula do gratuito

```text
FREE_PRECHECK
=
journal_profile_basic real
+
pacote reduzido do manuscrito
+
API free/free-tier
```

## O que o sistema deve fazer antes da avaliação gratuita

Quando o usuário selecionar ou informar o periódico, o sistema deve tentar obter:

- página oficial do periódico;
- foco e escopo;
- diretrizes aos autores;
- normas de submissão;
- tipos de artigo aceitos;
- política de avaliação, quando disponível;
- exigências formais;
- publicações recentes;
- padrões básicos dos artigos publicados.

## `journal_profile_basic`

Objeto esperado:

```json
{
  "journal_title": "Nome do periódico",
  "journal_url": "https://...",
  "scope_summary": "Resumo do escopo",
  "accepted_article_types": ["artigo original", "revisão", "estudo de caso"],
  "main_requirements": [
    "aderência ao escopo",
    "metodologia clara",
    "referências conforme norma",
    "avaliação cega",
    "declaração ética"
  ],
  "recent_publication_patterns": {
    "common_sections": ["Introdução", "Metodologia", "Resultados", "Discussão", "Conclusão"],
    "typical_methods": ["qualitativo", "quantitativo", "revisão"],
    "reference_density": "média",
    "recent_literature_expected": true
  },
  "limitations": []
}
```

## Pacote reduzido do manuscrito

A avaliação gratuita não deve enviar o manuscrito completo para API free/free-tier.

Enviar somente:

- título;
- resumo;
- palavras-chave;
- nomes das seções;
- contagem de palavras;
- quantidade de referências;
- presença/ausência de metodologia;
- presença/ausência de resultados;
- presença/ausência de conclusão;
- presença/ausência de declaração ética;
- presença/ausência de declaração de IA;
- presença/ausência de declaração de disponibilidade de dados;
- trechos mínimos, apenas quando estritamente necessário.

## Saída esperada

A API deve retornar JSON estruturado:

```json
{
  "current_score": 6.8,
  "potential_score": 8.4,
  "risk_level": "medio_alto",
  "recommendation": "submetivel_com_ajustes",
  "section_scores": {
    "escopo": 7,
    "originalidade": 6,
    "problema": 7,
    "revisao_literatura": 6,
    "metodologia": 6,
    "resultados": 7,
    "discussao": 6,
    "conclusao": 7,
    "referencias": 6,
    "formatacao": 5,
    "etica_ia_ciencia_aberta": 5
  },
  "main_risks": [
    "Metodologia aparentemente pouco detalhada.",
    "Aderência ao escopo precisa ser reforçada.",
    "Elementos formais do periódico podem estar incompletos."
  ],
  "free_summary": "Pré-avaliação baseada no perfil editorial básico do periódico e na estrutura reduzida do manuscrito.",
  "upsell_message": "O relatório completo aprofunda a análise seção por seção e compara o manuscrito com as diretrizes completas do periódico."
}
```

## Quando os dados do periódico forem insuficientes

O sistema não deve inventar um perfil editorial.

Se não localizar dados mínimos, deve marcar a análise como limitada.

Mensagem ao usuário:

```text
Não foi possível localizar informações editoriais suficientes do periódico. A avaliação gratuita será limitada. Informe a URL oficial do periódico para melhorar a precisão da análise.
```

## O que a versão gratuita não entrega

- análise completa por seção;
- leitura profunda do artigo inteiro;
- comentários por trecho;
- plano detalhado de ajustes;
- checklist completo do periódico;
- auditoria completa das referências;
- reescrita;
- versão ajustada;
- parecer editorial completo.

## Critério de aceite

- [ ] O gratuito acessa o periódico antes da avaliação.
- [ ] O gratuito gera `journal_profile_basic`.
- [ ] O gratuito não envia manuscrito completo à API free/free-tier.
- [ ] O gratuito informa limitação quando os dados do periódico forem insuficientes.
- [ ] O gratuito entrega pontuação, risco e principais pontos críticos.
- [ ] O gratuito diferencia claramente suas limitações em relação ao plano pago.
