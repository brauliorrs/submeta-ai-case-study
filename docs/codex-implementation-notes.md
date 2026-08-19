# Notas de implementação para o Codex

Este documento orienta a próxima etapa de implementação do Submeta.AI.

## Decisão atual

O produto deve começar no Brasil com a marca **Submeta.AI** e domínio brasileiro.

A versão gratuita deve ser real, mas limitada:

```text
FREE_PRECHECK = journal_profile_basic real + pacote reduzido do manuscrito + API free/free-tier
```

A versão paga deve ser completa:

```text
PAID_FULL_REPORT = journal_profile_full + manuscrito integral dentro do limite + API paga
```

O acesso interno autorizado deve pular cobrança, gerar relatório completo em PDF e enviar o arquivo por e-mail, usando secrets para a allowlist.

## Tarefas prioritárias

### 1. Implementar `journal_profile_basic`

Criar serviço para coletar informações mínimas do periódico:

```text
apps/worker/app/services/journal_profiler_basic.py
```

O perfil básico deve tentar extrair:

- título do periódico;
- URL oficial;
- foco e escopo;
- diretrizes aos autores;
- tipos de artigo aceitos;
- principais exigências formais;
- publicações recentes;
- padrões básicos de estrutura dos artigos.

Objeto esperado:

```json
{
  "journal_title": "Nome do periódico",
  "journal_url": "https://...",
  "scope_summary": "Resumo do escopo",
  "accepted_article_types": ["artigo original", "revisão"],
  "main_requirements": ["aderência ao escopo", "metodologia clara"],
  "recent_publication_patterns": {
    "common_sections": ["Introdução", "Metodologia", "Resultados", "Discussão", "Conclusão"],
    "typical_methods": ["qualitativo", "quantitativo", "revisão"],
    "reference_density": "média",
    "recent_literature_expected": true
  },
  "limitations": []
}
```

### 2. Implementar pacote reduzido do manuscrito

Criar:

```text
apps/worker/app/services/free_precheck_payload.py
```

Esse serviço deve extrair apenas:

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
- presença/ausência de declaração de dados;
- trechos mínimos apenas quando necessário.

Regra crítica:

```text
Não enviar manuscrito completo para API free/free-tier.
```

### 3. Implementar roteamento de IA

Criar:

```text
apps/worker/app/services/llm_router.py
```

Com rotas:

```text
FREE_PRECHECK -> provider/model free-tier
PAID_FULL_REPORT -> provider/model pago
PAID_ADJUSTED_VERSION -> provider/model pago forte
```

### 4. Implementar acesso interno autorizado

Criar serviços:

```text
apps/web/src/server/internal-access.ts
apps/worker/app/jobs/internal_free_report.py
apps/worker/app/services/email_sender.py
```

Regras:

- comparar HMAC/hash do e-mail com `INTERNAL_FREE_ACCESS_EMAIL_HASHES`;
- não gravar e-mail real em logs;
- exigir código por e-mail em produção;
- pular checkout após verificação;
- gerar relatório completo;
- enviar PDF para o e-mail autorizado;
- deletar temporários após envio.

### 5. Implementar Mercado Pago como gateway principal

Criar abstração:

```text
apps/web/src/server/payments/payment-provider.ts
apps/web/src/server/payments/mercado-pago-provider.ts
```

Fluxo:

```text
create_preference/order
↓
webhook confirma pagamento
↓
job passa para PAYMENT_CONFIRMED
↓
worker gera relatório pago
```

Antes de criar cobrança, verificar:

```ts
if (job.internal_free_access && job.internal_free_access_verified) {
  // não criar cobrança
  enqueueInternalFreeFullReport(job.id)
}
```

### 6. Implementar deleção automática

Criar:

```text
apps/worker/app/services/deletion_manager.py
```

Deve apagar:

- arquivo original;
- texto extraído;
- prompts com conteúdo;
- relatório temporário;
- versão ajustada temporária;
- arquivos intermediários.

### 7. Implementar status de job

Adicionar:

```text
CREATED
UPLOAD_RECEIVED
SCANNING_FILE
EXTRACTING_TEXT
FETCHING_JOURNAL_PROFILE
ANALYZING
BASIC_REPORT_READY
AWAITING_PAYMENT
PAYMENT_CONFIRMED
GENERATING_FULL_REPORT
FULL_REPORT_READY
GENERATING_ADJUSTED_VERSION
ADJUSTED_VERSION_READY
DOWNLOAD_STARTED
DOWNLOAD_COMPLETED
TEMP_FILES_DELETING
TEMP_FILES_DELETED
FAILED
FAILED_TEMP_FILES_DELETED
INTERNAL_ACCESS_VERIFICATION_SENT
INTERNAL_ACCESS_VERIFIED
INTERNAL_FREE_REPORT_GENERATING
INTERNAL_FREE_REPORT_SENT
```

## Migrações necessárias

Consultar:

```text
docs/database/internal-free-access.sql
```

## Secrets

Consultar:

```text
docs/github-secrets.md
```

## Critérios de aceite

- [ ] A avaliação gratuita não roda de forma genérica sem dados mínimos do periódico.
- [ ] A avaliação gratuita não envia manuscrito completo para API free/free-tier.
- [ ] O relatório pago usa perfil editorial completo e manuscrito integral dentro do limite.
- [ ] O acesso interno autorizado pula Mercado Pago somente após verificação.
- [ ] O PDF interno é enviado ao e-mail autorizado.
- [ ] Nenhum e-mail real autorizado é commitado.
- [ ] Nenhum segredo aparece no repositório.
- [ ] A deleção automática roda após download ou envio por e-mail.
- [ ] Logs não contêm manuscrito, prompt com conteúdo ou relatório.
- [ ] GitHub Secrets e variáveis de deploy estão documentados.
