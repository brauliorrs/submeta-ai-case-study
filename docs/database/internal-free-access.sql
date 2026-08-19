-- Submeta.AI
-- Migração conceitual para acesso interno autorizado sem cobrança.
-- Ajustar nomes, schemas e tipos conforme a implementação final.

-- Campos adicionais no job de análise
ALTER TABLE analysis_jobs
ADD COLUMN IF NOT EXISTS internal_free_access BOOLEAN DEFAULT FALSE,
ADD COLUMN IF NOT EXISTS internal_free_access_verified BOOLEAN DEFAULT FALSE,
ADD COLUMN IF NOT EXISTS internal_free_access_verified_at TIMESTAMP,
ADD COLUMN IF NOT EXISTS report_sent_by_email BOOLEAN DEFAULT FALSE,
ADD COLUMN IF NOT EXISTS report_sent_at TIMESTAMP;

-- Códigos temporários de verificação para e-mails autorizados
CREATE TABLE IF NOT EXISTS internal_access_codes (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  email_hash TEXT NOT NULL,
  code_hash TEXT NOT NULL,
  expires_at TIMESTAMP NOT NULL,
  used BOOLEAN DEFAULT FALSE,
  used_at TIMESTAMP,
  attempts INTEGER DEFAULT 0,
  created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_internal_access_codes_email_hash
ON internal_access_codes(email_hash);

CREATE INDEX IF NOT EXISTS idx_internal_access_codes_expires_at
ON internal_access_codes(expires_at);

-- Extensão opcional da tabela de auditoria.
-- A tabela audit_logs deve registrar metadados mínimos e nunca conteúdo do manuscrito.
-- Exemplo de ações:
-- INTERNAL_ACCESS_CHECKED
-- INTERNAL_ACCESS_CODE_SENT
-- INTERNAL_ACCESS_VERIFIED
-- INTERNAL_FREE_REPORT_GENERATED
-- INTERNAL_FREE_REPORT_SENT
-- INTERNAL_TEMP_FILES_DELETED

-- Exemplo de metadados seguros permitidos:
-- {
--   "internal_free_access": true,
--   "report_sent_by_email": true,
--   "content_deleted": true
-- }

-- Dados proibidos em audit_logs:
-- - e-mail em texto puro
-- - código de verificação
-- - texto do manuscrito
-- - prompts com conteúdo do manuscrito
-- - PDF do relatório
-- - trechos do artigo
