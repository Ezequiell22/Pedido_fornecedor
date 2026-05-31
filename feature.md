# Feature: Plataforma de Internacionalização (i18n) para ERP Legado Delphi

## Objetivo

Implementar uma plataforma desacoplada de internacionalização (i18n) para o ERP legado desenvolvido em Delphi, permitindo a tradução completa da aplicação em tempo de execução, sem recompilação, sem builds específicas por idioma e sem dependência de banco de dados ou componentes pagos.

A solução deverá suportar inicialmente Português, Inglês e Espanhol, sendo preparada para expansão futura para qualquer idioma sem necessidade de alteração de código-fonte.

---

# Objetivos Arquiteturais

## OA001 - Runtime Only

Toda tradução deverá ocorrer exclusivamente em tempo de execução.

Não será permitido:

* Build por idioma
* Alteração de DFM durante compilação
* Resource DLLs
* Tradução em tempo de build
* Geração de executáveis específicos por idioma

---

## OA002 - Desacoplamento

A solução deverá ser implementada de forma totalmente desacoplada do ERP.

Arquitetura preferencial:

```text
ERP Legado

│
├── Language.Core
├── Language.Runtime
├── Language.VCL
├── Language.JsonProvider
├── Language.Tools
└── Language.Tests
```

Distribuição:

```text
ERP.exe
│
├── LanguageRuntime.bpl (opcional)
└── Languages\
```

A utilização de BPL é opcional e não deverá ser requisito técnico obrigatório.

A arquitetura deverá funcionar igualmente como:

* Runtime Package (BPL)
* Biblioteca Delphi
* DLL (caso necessário futuramente)

---

## OA003 - Compatibilidade

Compatibilidade obrigatória:

* Delphi XE2
* Delphi 12 Athens

Sem dependência de recursos exclusivos de versões modernas.

---

# Arquitetura da Solução

## Módulos

### Language.Core

Responsável pelas interfaces e contratos.

Interfaces:

```text
ILanguageManager
ITranslator
IFormTranslator
ILanguageProvider
IMessageTranslator
ITranslationCache
```

---

### Language.JsonProvider

Responsável pela leitura dos arquivos de idioma.

---

### Language.Runtime

Responsável por:

* gerenciamento de idiomas
* cache
* fallback
* logs
* observabilidade

---

### Language.VCL

Responsável por:

* tradução automática de formulários
* tradução de componentes
* tradução de menus
* tradução de actions
* tradução de hints

---

### Language.Tools

Ferramentas auxiliares:

```text
LanguageExtractor.exe
LanguageValidator.exe
LanguageDiscovery.exe
```

---

### Language.Tests

Projeto de testes automatizados.

---

# Configuração

## Config.ini

```ini
[Language]
Current=es
Fallback=en
HotReload=1
AuditMode=0
DiscoveryMode=0
```

---

# Arquivos de Idioma

## Estrutura

```text
Languages

├── pt.json
├── en.json
├── es.json
├── fr.json
└── de.json
```

---

# Estratégia de Chaves

## Obrigatório

É proibido utilizar o texto original como chave.

Exemplo incorreto:

```json
{
  "Salvar": "Save"
}
```

Exemplo correto:

```json
{
  "BTN_SAVE": "Save"
}
```

---

# Namespaces

Todas as chaves deverão possuir contexto.

Exemplo:

```json
{
  "FORM_CLIENTE.BTN_SAVE": "Save",
  "FORM_CLIENTE.LBL_NAME": "Name",
  "FORM_PEDIDO.BTN_SAVE": "Confirm Order"
}
```

Evita colisões semânticas.

---

# Estrutura do Arquivo

Exemplo:

```json
{
  "_metadata": {
    "language": "es",
    "version": "1.0.0",
    "erpVersion": "10.5"
  },

  "FORM_CLIENTE.LBL_NOME": "Nombre",
  "FORM_CLIENTE.BTN_SALVAR": "Guardar",
  "MSG_CLIENTE_NAO_ENCONTRADO": "Cliente no encontrado"
}
```

---

# Carregamento

Fluxo:

```text
ERP Startup
      │
      ▼
Leitura Config.ini
      │
      ▼
Idioma Atual
      │
      ▼
Carrega JSON
      │
      ▼
Valida Estrutura
      │
      ▼
Monta Cache
      │
      ▼
Disponibiliza Traduções
```

---

# Cache

Todos os arquivos deverão ser carregados integralmente para memória.

Estrutura recomendada:

```delphi
TDictionary<String,String>
```

Nenhuma consulta ao arquivo deverá ocorrer durante o uso normal da aplicação.

Objetivo:

```text
Lookup O(1)
```

---

# Fallback de Idiomas

A solução deverá suportar fallback hierárquico.

Exemplo:

```text
es-MX
  ↓
es
  ↓
en
  ↓
pt
```

Caso uma chave não exista:

```json
FORM_CLIENTE.BTN_SAVE
```

O sistema deverá procurar automaticamente nos idiomas subsequentes.

---

# Tradução Automática de Formulários

A solução deverá traduzir automaticamente:

* Form Caption
* Label Caption
* Button Caption
* BitBtn Caption
* SpeedButton Caption
* GroupBox Caption
* RadioButton Caption
* CheckBox Caption
* StaticText Caption
* Panel Caption
* TabSheet Caption
* Menu Items
* Actions
* Toolbars
* StatusBar Panels
* Hints
* DBGrid Titles
* StringGrid Headers

Sem necessidade de código específico em cada formulário.

---

# Hook Automático

A solução deverá possuir mecanismo centralizado de tradução.

Objetivo:

Não exigir:

```delphi
Translator.Translate(Self);
```

em cada tela.

O processo deverá ocorrer automaticamente quando o formulário for criado ou exibido.

---

# Componentes Criados Dinamicamente

A solução deverá suportar componentes criados em runtime.

Exemplo:

```delphi
Btn := TButton.Create(Self);
```

API obrigatória:

```delphi
Translator.TranslateComponent(Btn);
```

e

```delphi
Translator.TranslateContainer(Self);
```

---

# Tradução de Mensagens

A solução deverá suportar:

* ShowMessage
* MessageDlg
* Application.MessageBox
* Mensagens customizadas

Exemplo:

```delphi
Translator.Msg('MSG_CLIENTE_NAO_ENCONTRADO');
```

---

# Placeholders

Suporte obrigatório.

Exemplo:

```json
{
  "MSG_CLIENTE": "Cliente {0} não encontrado"
}
```

Uso:

```delphi
Translator.Format(
  'MSG_CLIENTE',
  [Codigo]
);
```

---

# Pluralização

Suporte obrigatório.

Exemplo:

```json
{
  "ITEMS_FOUND": {
    "one": "{0} item found",
    "other": "{0} items found"
  }
}
```

API:

```delphi
Translator.Plural(
  'ITEMS_FOUND',
  Count
);
```

---

# Hot Reload

A solução deverá permitir recarregar idiomas sem reiniciar o ERP.

Exemplo:

```delphi
LanguageManager.Reload;
```

Comportamento:

* recarrega arquivos
* atualiza cache
* reprocessa telas abertas

---

# Discovery Mode

Modo destinado à implantação inicial.

Configuração:

```ini
DiscoveryMode=1
```

Ao abrir formulários, o sistema gera automaticamente:

```json
{
  "FORM_CLIENTE.BTN_SALVAR": "Salvar",
  "FORM_CLIENTE.LBL_NOME": "Nome"
}
```

Permitindo acelerar o mapeamento das traduções.

---

# Audit Mode

Configuração:

```ini
AuditMode=1
```

Quando ativo:

Traduções inexistentes serão exibidas visualmente.

Exemplo:

```text
[MISSING] Cliente não encontrado
```

Objetivo:

Facilitar homologação e QA.

---

# Logging e Observabilidade

Arquivo:

```text
Logs\translation.log
```

Eventos registrados:

* chave inexistente
* idioma ausente
* erro de carregamento
* erro de parsing
* fallback utilizado

Exemplo:

```text
WARN
Missing Key:
FORM_CLIENTE.BTN_SAVE

Language:
es
```

---

# Ferramentas Auxiliares

## LanguageDiscovery.exe

Gera catálogo inicial de traduções.

---

## LanguageExtractor.exe

Extrai chaves dos formulários.

---

## LanguageValidator.exe

Valida:

* chaves faltantes
* chaves duplicadas
* traduções vazias
* inconsistências entre idiomas

Exemplo:

```text
Missing Keys: 14
Duplicate Keys: 2
Empty Values: 6
```

---

# Testes Automatizados

Framework:

* DUnit
* DUnitX (quando disponível)

---

# Casos de Teste

## Configuração

* leitura do idioma
* leitura do fallback

---

## Arquivos

* carregamento
* parsing
* validação

---

## Traduções

* chave existente
* chave inexistente
* fallback

---

## Placeholders

* substituição correta

---

## Pluralização

* singular
* plural

---

## Componentes

* formulário
* menus
* actions
* grids
* componentes dinâmicos

---

## Hot Reload

* atualização de cache
* atualização de telas abertas

---

## Discovery

* geração correta de chaves

---

## Auditoria

* identificação de textos não traduzidos

---

## Performance

Cenário:

```text
50.000 traduções
500 formulários
```

Metas:

```text
Inicialização < 2 segundos

Lookup < 1 ms

Tradução de formulário < 100 ms
```

---

## Testes de Memória

Execução obrigatória com:

```text
FastMM FullDebugMode
```

Objetivo:

* zero memory leaks
* zero resource leaks

---

# Critérios de Aceitação

1. Funciona em Delphi XE2 e Delphi 12.
2. Não utiliza componentes pagos.
3. Não utiliza banco de dados.
4. Utiliza um arquivo independente por idioma.
5. Todas as traduções ocorrem em runtime.
6. Possui fallback de idiomas.
7. Possui cache em memória.
8. Possui hot reload.
9. Possui discovery mode.
10. Possui audit mode.
11. Possui logging.
12. Possui tradução automática de formulários.
13. Possui tradução de mensagens.
14. Possui suporte a placeholders.
15. Possui suporte a pluralização.
16. Possui ferramentas de validação.
17. Possui testes automatizados.
18. Não exige alterações massivas nos formulários legados.
19. Permite inclusão de novos idiomas sem recompilação.
20. Mantém compatibilidade com a arquitetura atual do ERP legado.
