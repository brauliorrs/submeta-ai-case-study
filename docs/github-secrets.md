# GitHub Secrets e variáveis sensíveis

Este documento lista os secrets e variáveis sensíveis previstos para o Submeta.AI.

Nenhum valor real deve ser commitado neste repositório.

## Regra geral

Use GitHub Secrets para CI/CD e, no provedor de deploy, replique as mesmas variáveis no ambiente de produção.

Importante: GitHub Secrets ficam disponíveis para GitHub Actions, mas a aplicação em produção também precisa receber essas variáveis no ambiente onde estiver hospedada.

## Secrets obrigatórios para segurança

| Nome | Finalidade |
|---|---|
| `APP_ENV` | Ambiente: `development`, `staging` ou `production` |
| `APP_URL` | URL pública da aplicação |
| `DATABASE_URL` | Conexão com PostgreSQL/Supabase |
| `REDIS_URL` | Conexão com Redis/RQ |
| `EMAIL_HASH_SECRET` | Segredo para HMAC/hash de e-mails |
| `ENCRYPTION_KEY` | Chave para criptografia de dados temporários sensíveis |
| `DOWNLOAD_TOKEN_SECRET` | Segredo para tokens de download único |
| `WEBHOOK_SECRET` | Segredo geral para validação de webhooks internos |

## Acesso interno autorizado

| Nome | Finalidade |
|---|---|
| `INTERNAL_FREE_ACCESS_ENABLED` | Ativa ou desativa o fluxo interno sem cobrança |
| `INTERNAL_FREE_ACCESS_EMAIL_HASHES` | Lista de hashes/HMACs dos e-mails autorizados, separados por vírgula |
| `INTERNAL_FREE_ACCESS_REQUIRE_EMAIL_CODE` | Exige código por e-mail em produção |
| `INTERNAL_FREE_ACCESS_CODE_TTL_MINUTES` | Tempo de validade do código |
| `INTERNAL_FREE_ACCESS_PRODUCT` | `FULL_REPORT` ou `FULL_REPORT_WITH_ADJUSTED_VERSION` |

Recomendação:

```env
INTERNAL_FREE_ACCESS_REQUIRE_EMAIL_CODE=true
INTERNAL_FREE_ACCESS_PRODUCT=FULL_REPORT_WITH_ADJUSTED_VERSION
```

## E-mail transacional

| Nome | Finalidade |
|---|---|
| `EMAIL_PROVIDER` | Provedor: `resend`, `brevo`, `sendgrid` ou `ses` |
| `EMAIL_FROM` | Remetente verificado |
| `RESEND_API_KEY` | Token da Resend, se este for o provedor escolhido |
| `BREVO_API_KEY` | Token da Brevo, se este for o provedor escolhido |
| `SENDGRID_API_KEY` | Token da SendGrid, se este for o provedor escolhido |
| `AWS_ACCESS_KEY_ID` | Chave AWS, se usar SES/S3 |
| `AWS_SECRET_ACCESS_KEY` | Segredo AWS, se usar SES/S3 |
| `AWS_REGION` | Região AWS |

## Mercado Pago

| Nome | Finalidade |
|---|---|
| `MERCADO_PAGO_ACCESS_TOKEN` | Token privado do Mercado Pago |
| `MERCADO_PAGO_PUBLIC_KEY` | Chave pública, quando necessária no frontend |
| `MERCADO_PAGO_WEBHOOK_SECRET` | Segredo para validação de webhook, quando aplicável |
| `MERCADO_PAGO_ENV` | `sandbox` ou `production` |

## PayPal futuro

| Nome | Finalidade |
|---|---|
| `PAYPAL_CLIENT_ID` | Client ID do PayPal |
| `PAYPAL_CLIENT_SECRET` | Secret do PayPal |
| `PAYPAL_WEBHOOK_ID` | ID do webhook PayPal |
| `PAYPAL_ENV` | `sandbox` ou `production` |

## APIs de IA

| Nome | Finalidade |
|---|---|
| `FREE_PRECHECK_PROVIDER` | Provedor usado no diagnóstico gratuito |
| `FREE_PRECHECK_MODEL` | Modelo usado no diagnóstico gratuito |
| `FREE_PRECHECK_MAX_INPUT_CHARS` | Limite de caracteres enviados à API free/free-tier |
| `PAID_ANALYSIS_PROVIDER` | Provedor usado no relatório completo |
| `PAID_ANALYSIS_MODEL` | Modelo usado no relatório completo |
| `PAID_ADJUSTMENT_PROVIDER` | Provedor usado na versão ajustada |
| `PAID_ADJUSTMENT_MODEL` | Modelo usado na versão ajustada |
| `OPENAI_API_KEY` | Chave OpenAI, se usada |
| `GEMINI_API_KEY` | Chave Gemini, se usada |
| `OPENROUTER_API_KEY` | Chave OpenRouter, se usada |

## Storage temporário

| Nome | Finalidade |
|---|---|
| `TEMP_STORAGE_PROVIDER` | `local`, `s3`, `r2` ou equivalente |
| `TEMP_STORAGE_BUCKET` | Bucket privado temporário |
| `TEMP_STORAGE_ACCESS_KEY_ID` | Chave de acesso |
| `TEMP_STORAGE_SECRET_ACCESS_KEY` | Segredo de acesso |
| `TEMP_STORAGE_ENDPOINT` | Endpoint S3/R2, se aplicável |
| `TEMP_ACTIVE_JOB_TTL_MINUTES` | Tempo máximo de retenção temporária durante fluxo ativo |
| `DELETE_AFTER_DOWNLOAD` | Deve ser `true` em produção |

## Como gerar hash de e-mail autorizado

Não grave o e-mail real no repositório. Gere um HMAC localmente usando o mesmo `EMAIL_HASH_SECRET` que estará em produção.

Exemplo local:

```bash
export EMAIL_HASH_SECRET="coloque-um-segredo-forte-aqui"
python - <<'PY'
import hmac, hashlib, os
email = "email-autorizado@example.com".strip().lower()
secret = os.environ["EMAIL_HASH_SECRET"].encode()
print(hmac.new(secret, email.encode(), hashlib.sha256).hexdigest())
PY
```

Depois, configure o resultado como secret:

```text
INTERNAL_FREE_ACCESS_EMAIL_HASHES=<hash_gerado>
```

Para múltiplos e-mails:

```text
INTERNAL_FREE_ACCESS_EMAIL_HASHES=<hash_1>,<hash_2>,<hash_3>
```

## Secrets mínimos para o MVP

Para rodar o MVP com diagnóstico gratuito, relatório pago, Mercado Pago e acesso interno autorizado:

```text
APP_ENV
APP_URL
DATABASE_URL
REDIS_URL
EMAIL_HASH_SECRET
ENCRYPTION_KEY
DOWNLOAD_TOKEN_SECRET
INTERNAL_FREE_ACCESS_ENABLED
INTERNAL_FREE_ACCESS_EMAIL_HASHES
INTERNAL_FREE_ACCESS_REQUIRE_EMAIL_CODE
INTERNAL_FREE_ACCESS_PRODUCT
EMAIL_PROVIDER
EMAIL_FROM
RESEND_API_KEY
MERCADO_PAGO_ACCESS_TOKEN
MERCADO_PAGO_PUBLIC_KEY
MERCADO_PAGO_WEBHOOK_SECRET
FREE_PRECHECK_PROVIDER
FREE_PRECHECK_MODEL
PAID_ANALYSIS_PROVIDER
PAID_ANALYSIS_MODEL
OPENAI_API_KEY ou GEMINI_API_KEY ou OPENROUTER_API_KEY
TEMP_STORAGE_PROVIDER
DELETE_AFTER_DOWNLOAD
```

## O que nunca deve entrar no repositório

```text
.env real
chaves de API
tokens de pagamento
e-mails autorizados reais
manuscritos de usuários
relatórios gerados
logs com conteúdo de artigo
prompts com conteúdo de artigo
arquivos temporários
```

## Checklist antes do deploy

- [ ] `.env` real fora do repositório.
- [ ] `.env.example` apenas com placeholders.
- [ ] GitHub Secrets configurados.
- [ ] Variáveis replicadas no provedor de deploy.
- [ ] Webhooks validados por assinatura/secret.
- [ ] Logs sem conteúdo de manuscrito.
- [ ] Fluxo interno exige código em produção.
- [ ] Deleção automática testada.
- [ ] Download único testado.
- [ ] Relatório por e-mail testado para acesso interno.
