# Traduções (TsiLang)

Este projeto usa **TsiLang Components Suite** para internacionalização em runtime.

## Formato

- Arquivo principal: `comercial.sil` (texto, editável com SIL Editor)
- Alternativa binária: `comercial.sib` (altere `TranslationFile` no `Config.ini`)

Os arquivos `*.json` nesta pasta são referência legada; o runtime carrega o `.sil`/`.sib`.

## Gerar / atualizar traduções

1. Abra o projeto no Delphi com TsiLang instalado.
2. Menu **TsiLang Expert** → selecione os forms do módulo comercial.
3. Defina idiomas na ordem: **Portuguese (pt)**, **English (en)**, **Spanish (es)** — a ordem deve coincidir com `Language.Runtime.Config.pas`.
4. Traduza captions, hints e strings de código via Expert (`GetTextOrDefault('MSG_...')`).
5. Exporte para `Languages\comercial.sil` (External translations).

## Strings de código (mensagens)

IDs sugeridos (namespace semântico, não texto original):

| ID | Uso |
|----|-----|
| `MSG_RELATORIO_SALVO` | Relatório salvo em {0} |
| `MSG_FANTASIA_OBRIGATORIO` | Validação fornecedor |
| `MSG_RAZAO_OBRIGATORIA` | Validação fornecedor |
| `MSG_PEDIDO_ID_INVALIDO` | Validação pedido |
| `MSG_FORNECEDOR_ID_INVALIDO` | Validação pedido |
| `MSG_VALOR_INVALIDO` | Validação item |
| `MSG_QUANTIDADE_INVALIDA` | Validação item |

No código: `Translator.FormatMsg('MSG_RELATORIO_SALVO', [GetCurrentDir])`.

## Hot reload

Com `HotReload=1` no `Config.ini`, chame `LanguageBootstrap.Reload` após atualizar o `.sil` em disco.
