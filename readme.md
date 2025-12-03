# Pedido Fornecedor

Aplicação de compras (Delphi VCL) para gestão de pedidos de compra, fornecedores e itens, com listagem, filtros por período/fornecedor, geração de relatórios HTML e migrações/seed de banco alinhados ao DDL.

## Visão Geral
- Foco em pedidos de compra (`PEDIDO_COMPRA`), fornecedores (`FORNECEDORES`) e itens de pedido (`PEDCOMPRA_ITEM`).
- Camadas separadas: DAO (acesso a dados), Business (regras), View (VCL), Utils (HTML, logs), DB (migrações/seed).
- Banco SQL Server via `FireDAC` (DriverID `MSSQL`) usando `comercial.model.resource.impl.queryFD`.

## Funcionalidades
- Cadastro/listagem de fornecedores e pedidos.
- Filtros de pedidos por período e por fornecedor (tela de listagem).
- Itens vinculados ao pedido com totalizações por item.
- Relatórios HTML:
  - Compras por Fornecedor: soma do valor total dos itens por fornecedor.
  - Compras por Produto: preço médio, quantidade total e valor total por `COD_Item` e descrição.

## Banco de Dados (DDL)
- Tabelas principais criadas por migrações:
  - `FORNECEDORES(COD_CLIFOR, RAZAO, COD_ESTADO, FANTASIA, COD_PAIS, CLIENTE, FORNEC)`
  - `PEDIDO_COMPRA(COD_PEDIDOCOMPRA, COD_EMPRESA, COD_CLIFOR, COD_MOEDA, DT_EMISSAO, DT_PREVISTAENTREGA, DT_ENTREGA, TIPO_COMPRA)`
  - `PEDCOMPRA_ITEM(COD_PEDIDOCOMPRA, COD_EMPRESA, SEQUENCIA, COD_Item, COD_unidadecompra, QTDE_PEDIDA, QTDE_RECEBIDA, DESCRICAO, PRECO_UNITARIO, PERC_DESCTO, VALOR_DESCTO, PERC_FINANC, VALOR_TOTAL, DT_INCLUSAO, DT_SOLICITADA, DT_RECEBIDA)`
- Índices e FKs: FK de `PEDIDO_COMPRA(COD_CLIFOR)` para `FORNECEDORES(COD_CLIFOR)` e FK de `PEDCOMPRA_ITEM(COD_PEDIDOCOMPRA)` para `PEDIDO_COMPRA(COD_PEDIDOCOMPRA)`.

## Migrações e Seed
- Migrações em `src/model/db/comercial.model.db.migrations.pas` (DDL manual, não alterar nomes/colunas).
- Seed em `src/model/db/comercial.model.db.migrations.seed.pas` lê `.xlsx` e insere via DAOs com mapeamento por cabeçalhos (compatível com ordem variável de colunas no Excel).

## Configuração
- Arquivo `comercial.ini` (no diretório do executável):
  - `[Database]`
  - `Server`: host do SQL Server (ex.: `localhost`)
  - `Database`: nome do banco (ex.: `PedidoFornecedor`)
  - `User`: usuário (ex.: `sa`) — deixe vazio para autenticação do Windows
  - `Password`: senha — deixe vazio para autenticação do Windows

## Build e Execução
- Abrir `comercial.dproj` e compilar em `Win32/Debug` (Delphi).
- Garantir `comercial.ini` com servidor/banco/credenciais válidos do SQL Server.
- Executar a aplicação e usar a tela “Listagem de Pedidos” para consultar e filtrar.

## Relatórios HTML
- Implementados em `src/utils/comercial.util.printhtml.pas`:
  - Compras por Fornecedor: agrupa `PEDIDO_COMPRA` + `PEDCOMPRA_ITEM` por fornecedor e soma `i.VALOR_TOTAL`.
  - Compras por Produto: agrupa somente `PEDCOMPRA_ITEM` por `COD_Item` e `DESCRICAO`, calculando `avg(PRECO_UNITARIO)`, `sum(QTDE_PEDIDA)` e `sum(VALOR_TOTAL)`.
- Saída gravada em diretório `reports/` junto ao executável.

## Arquitetura
- `src/model/DAO`: DAOs de Fornecedor, Pedido e Item com CRUD e binding de `DataSource`.
- `src/model/business`: Orquestra DAOs, fluxos de tela, filtros e relatórios.
- `src/model/db`: migrações DDL e seed (Excel → DAOs).
- `src/model/entity`: entidades com validações simples.
- `src/view`: forms VCL (listagem, edição).
- `src/utils`: impressão HTML, logs.

## Observações
- Entidades/DAOs seguem estritamente os nomes e tipos do DDL manual.
- Seed usa DAOs; antes de inserir, limpa tabelas de destino com `delete` simples para evitar duplicidades.

## Testes (DUnitX)
- Projeto de testes: `tests/comercial.dunitx.tests.dproj` (console).
- Como executar:
  - Compilar em `Win32`.
  - Garantir `comercial.ini` configurado (conexão SQL Server).
  - Executar `comercial.dunitx.tests.exe` e verificar saída do console (exit code 0 indica sucesso).
- Suites:
  - Migrações: valida criação de `FORNECEDORES`, `PEDIDO_COMPRA`, `PEDCOMPRA_ITEM` e índices `IDX_PEDIDO_COMPRA_CLIFOR`, `IDX_PEDCOMPRA_ITEM_PED`.
  - Fornecedor: insere, atualiza e realiza soft delete (`ACTIVE = 0`).
  - Pedido: cria pedido de compra, associa fornecedor/empresa e adiciona item.
  - Relatório HTML: gera “Compras por Produto” e “Compras por Fornecedor”.

## Requisitos
- Delphi (versão compatível com FireDAC).
- SQL Server 2016+.
- Acesso ao servidor e base definidos no `comercial.ini`.
