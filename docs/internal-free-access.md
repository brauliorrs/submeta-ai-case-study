# Acesso interno autorizado sem cobrança

Este documento define o fluxo de uso interno do Submeta.AI sem pagamento, destinado a testes, validação e operação controlada.

## Objetivo

Permitir que e-mails previamente autorizados usem a plataforma sem cobrança para gerar relatório completo em PDF, sem passar pelo checkout do Mercado Pago.

Esse recurso existe para validação interna do produto e não deve ser tratado como cupom público.

## Princípios

- Não expor e-mails reais no código-fonte.
- Não commitar allowlists sensíveis no repositório.
- Usar GitHub Secrets ou variáveis seguras do ambiente de deploy.
- Exigir verificação por código em produção.
- Enviar o relatório somente para o e-mail autorizado.
- Manter a mesma política de privacidade dos fluxos pagos.
- Excluir manuscrito, texto extraído, prompts e arquivos temporários após envio.

## Fluxo funcional

```text
Usuário informa e-mail
↓
Sistema normaliza o e-mail
↓
Sistema calcula HMAC/hash do e-mail normalizado
↓
Sistema compara com allowlist segura
↓
Se autorizado:
    em desenvolvimento: libera fluxo interno
    em produção: envia código de verificação ao e-mail
↓
Usuário confirma código
↓
Sistema marca internal_free_access_verified = true
↓
Sistema pula checkout
↓
Sistema gera relatório completo em PDF
↓
Sistema envia PDF para o e-mail autorizado
↓
Sistema exclui arquivos temporários
↓
Sistema registra metadados mínimos
```

## Normalização do e-mail

Antes de qualquer comparação, o e-mail deve ser normalizado:

```text
trim
lowercase
```

Exemplo lógico:

```ts
const normalizedEmail = email.trim().toLowerCase()
```

## Comparação segura

A implementação recomendada é comparar hashes/HMACs, não e-mails em texto puro.

```ts
const emailHash = hmacSha256(normalizedEmail, EMAIL_HASH_SECRET)
const allowlist = process.env.INTERNAL_FREE_ACCESS_EMAIL_HASHES?.split(',') ?? []
const isAuthorized = allowlist.includes(emailHash)
```

## Secrets necessários

Os valores reais devem estar em GitHub Secrets ou no painel do provedor de deploy.

```env
INTERNAL_FREE_ACCESS_ENABLED=true
INTERNAL_FREE_ACCESS_EMAIL_HASHES=<lista_de_hashes_autorizados>
INTERNAL_FREE_ACCESS_REQUIRE_EMAIL_CODE=true
INTERNAL_FREE_ACCESS_CODE_TTL_MINUTES=10
EMAIL_HASH_SECRET=<segredo_forte>
EMAIL_PROVIDER=resend
EMAIL_FROM=<remetente_verificado>
RESEND_API_KEY=<token_resend>
```

## Código de verificação

Em produção, não basta a pessoa digitar um e-mail autorizado. O sistema deve enviar um código temporário para o próprio e-mail autorizado.

Regras:

- código de 6 dígitos;
- validade de 10 minutos por padrão;
- armazenar somente hash do código;
- invalidar após uso;
- limitar tentativas;
- nunca registrar o código em logs.

## Tabela sugerida

```sql
CREATE TABLE internal_access_codes (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  email_hash TEXT NOT NULL,
  code_hash TEXT NOT NULL,
  expires_at TIMESTAMP NOT NULL,
  used BOOLEAN DEFAULT FALSE,
  used_at TIMESTAMP,
  attempts INTEGER DEFAULT 0,
  created_at TIMESTAMP DEFAULT NOW()
);
```

## Campos em analysis_jobs

```sql
ALTER TABLE analysis_jobs
ADD COLUMN internal_free_access BOOLEAN DEFAULT FALSE,
ADD COLUMN internal_free_access_verified BOOLEAN DEFAULT FALSE,
ADD COLUMN internal_free_access_verified_at TIMESTAMP,
ADD COLUMN report_sent_by_email BOOLEAN DEFAULT FALSE,
ADD COLUMN report_sent_at TIMESTAMP;
```

## Status de job

Adicionar os seguintes status:

```text
INTERNAL_ACCESS_VERIFICATION_SENT
INTERNAL_ACCESS_VERIFIED
INTERNAL_FREE_REPORT_GENERATING
INTERNAL_FREE_REPORT_SENT
```

## Contratos de API

A implementação pode ser feita com endpoints dedicados:

```text
POST /api/internal-access/check
POST /api/internal-access/send-code
POST /api/internal-access/verify-code
POST /api/internal-access/generate-report
```

Ou integrada ao fluxo normal:

```text
POST /api/jobs/create
```

Resposta sugerida:

```json
{
  "jobId": "uuid",
  "internalFreeAccess": true,
  "requiresEmailVerification": true,
  "nextStep": "VERIFY_EMAIL_CODE"
}
```

## Regra de checkout

Antes de criar cobrança no Mercado Pago, o backend deve verificar:

```ts
if (job.internal_free_access && job.internal_free_access_verified) {
  enqueueInternalFreeFullReport(job.id)
  return {
    paymentRequired: false,
    status: 'INTERNAL_FREE_REPORT_GENERATING'
  }
}
```

## Produto liberado

Controlar por variável:

```env
INTERNAL_FREE_ACCESS_PRODUCT=FULL_REPORT
```

Valores aceitos:

```text
FULL_REPORT
FULL_REPORT_WITH_ADJUSTED_VERSION
```

Recomendação para validação interna:

```text
FULL_REPORT_WITH_ADJUSTED_VERSION
```

Assim o fluxo interno permite testar o produto pago completo sem gerar cobrança.

## Envio do PDF

O relatório gerado no fluxo interno deve ser enviado automaticamente para o e-mail autorizado.

O arquivo não deve ficar disponível publicamente. O envio deve ocorrer por e-mail transacional, e o arquivo temporário deve ser removido após envio confirmado ou após timeout de segurança.

## Deleção obrigatória

Após envio do PDF:

```text
- deletar manuscrito original;
- deletar texto extraído;
- deletar prompts com conteúdo;
- deletar relatório PDF temporário;
- deletar versão ajustada temporária, se houver;
- deletar arquivos intermediários;
- marcar content_deleted = true.
```

## Logs permitidos

Registrar apenas metadados mínimos:

```text
job_id
email_hash
internal_free_access = true
internal_free_access_verified_at
report_sent_at
content_deleted_at
status
```

Não registrar:

```text
e-mail em texto puro
código de verificação
conteúdo do manuscrito
prompts com conteúdo do manuscrito
PDF do relatório
texto extraído
```

## Mensagem de interface

Quando o acesso interno for identificado:

```text
Acesso interno autorizado identificado.
Após a verificação do e-mail, o relatório completo será gerado sem cobrança e enviado automaticamente para o e-mail autorizado.
```

Após envio:

```text
Relatório enviado para o e-mail autorizado. Por segurança e sigilo, o manuscrito, o texto extraído, os prompts e os arquivos temporários foram excluídos da plataforma.
```
