# i18n com TsiLang — mapeamento do feature.md

Este documento descreve como os objetivos do `feature.md` são atendidos usando **TsiLang Components Suite** em vez da plataforma JSON customizada.

## Decisão de arquitetura

| Aspecto | feature.md (custom) | Com TsiLang |
|---------|---------------------|-------------|
| Motor de tradução | `Language.Runtime.*` + JSON | `TsiLang` / `TsiLangLinked` + `TsiLangDispatcher` |
| Arquivos externos | `Languages/pt.json`, `en.json` | `Languages/comercial.sil` ou `.sib` |
| Troca de idioma | `LanguageManager.Reload` | `LanguageBootstrap.Reload` → `LoadAllFromFile` + `ActiveLanguage` |
| Formulários | Hook `WM_SHOWWINDOW` | Tradução nativa do componente (automática) |
| Mensagens | `Translator.Msg('MSG_X')` | `Translator.Msg('MSG_X')` → `GetTextOrDefault` |
| Configuração | `Config.ini` | **Mesmo** `Config.ini` (adaptado) |

## Pré-requisitos

1. Instalar **TsiLang Components Suite** no Delphi (palette SiLang).
2. Adicionar o pacote runtime ao projeto (`siComp` / pacote SiLang da sua versão).
3. Rodar **TsiLang Expert** nos forms e exportar `Languages\comercial.sil`.

## Componentes no ERP

```
frmIndex (MDI)
├── TsiLangDispatcher  ← controle central, FileName, ActiveLanguage
└── TsiLang            ← CommonContainer (Dialogs, Locales, Strings)

Demais forms
└── TsiLangLinked      ← LangDispatcher + CommonContainer = frmIndex
```

## Config.ini

```ini
[Language]
Current=pt
Fallback=en
HotReload=1
AuditMode=0
DiscoveryMode=0
TranslationFile=Languages\comercial.sil
```

Ordem dos idiomas no `siLangDispatcher1.LangNames` **deve** ser: Portuguese (1), English (2), Spanish (3).

## API no código (fachada fina)

```delphi
// Após CreateForm(frmIndex):
TLanguageBootstrap.Initialize;

// Mensagens
ShowMessage(Translator.Msg('MSG_FANTASIA_OBRIGATORIO'));
ShowMessage(Translator.FormatMsg('MSG_RELATORIO_SALVO', [GetCurrentDir]));

// Hot reload
TLanguageBootstrap.Reload;
```

## Critérios de aceitação — status

| # | Critério | TsiLang |
|---|----------|---------|
| 1 | Delphi XE2 e 12 | Suportado pelo fabricante |
| 2 | Sem componentes pagos | **Não** — TsiLang é comercial |
| 3 | Sem banco de dados | Sim |
| 4 | Arquivo independente por idioma | SIL/SIB multi-idioma (1 arquivo, N línguas) |
| 5 | Runtime only | Sim (external SIL/SIB) |
| 6 | Fallback | `GetTextOrDefault` + `DefaultLanguage` |
| 7 | Cache em memória | Interno ao TsiLang |
| 8 | Hot reload | `LoadAllFromFile` |
| 9 | Discovery mode | TsiLang Expert + Translation Memory |
| 10 | Audit mode | Parcial via `AuditMode` + `[MISSING]` na fachada |
| 11 | Logging | Implementar à parte se necessário |
| 12 | Tradução automática de forms | Nativo |
| 13 | Mensagens | `Strings` + `GetTextOrDefault` |
| 14 | Placeholders | `FormatMsg` na fachada |
| 15 | Pluralização | Manual por ID ou Extended Translations |
| 16 | Ferramentas | SIL Editor, Expert, Validator do fabricante |
| 17 | Testes | Config + integração manual |
| 18 | Sem alteração massiva nos forms | Expert automatiza inclusão de TsiLang |
| 19 | Novos idiomas sem recompilar | Sim com SIL externo |
| 20 | Desacoplado do ERP | Fachada `Language.*` mantida |

## Próximos passos no IDE

1. Compilar — se faltar unit `siComp`, instale/configure o pacote TsiLang.
2. **TsiLang Expert** → traduzir todos os forms.
3. Exportar strings hard-coded (`ShowMessage` → IDs já referenciados no código).
4. Gerar `Languages\comercial.sil` e copiar junto ao `.exe`.
5. Testar `Current=en` no `Config.ini` e validar telas.

## Observação sobre JSON

Os arquivos `Languages/*.json` podem servir como **documentação/referência** para tradutores. A conversão para SIL é feita pelo TsiLang Expert ou SIL Editor, não em runtime.
