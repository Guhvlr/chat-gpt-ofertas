---
name: gustavo-illustrator-ofertas
description: Configurar a conexão local com o Illustrator no Windows e criar ou atualizar artes de ofertas no padrão aprovado pelo Gustavo, com fotos por código, descrições, preços e referências compartilhadas da equipe.
---

# Illustrator — Ofertas do Gustavo

Esta skill inclui as orientações e nove telas corrigidas manualmente pelo Gustavo. Usa a automação COM/ExtendScript nativa do Illustrator no Windows, sem painel azul, servidor MCP, Node ou Python para conectar. Illustrator e Codex precisam estar instalados; o pacote não instala o aplicativo Adobe nem inclui licença, fontes, modelos `.ai` ou a biblioteca completa de fotos.

## Primeiro uso ou computador diferente

1. Perguntar **qual a versão do Illustrator** e confirmar o sistema operacional, se ainda não informados. Não repetir respostas da sessão. Os scripts suportam Windows; explicar a limitação em outro sistema.
2. Ler [conexão e operação](references/conexao-illustrator.md). Executar `scripts/Setup-Illustrator.ps1` com `powershell.exe`, passando a versão respondida e os caminhos das fotos. O instalador do pacote faz essa configuração.
3. Testar a conexão sem editar documento e confirmar a versão que respondeu. Nunca usar silenciosamente outra instalação.
4. Confirmar onde estão modelos `.ai` e fotos neste PC. Caminhos antigos são históricos. A configuração local fica em `%LOCALAPPDATA%\GustavoIllustrator\settings.json`.
5. Não reinstalar algo que já funciona nem alterar registro, instalação Adobe ou permissões globais para contornar falhas.

## Antes de cada oferta

- Havendo repositório configurado, ler [equipe e GitHub](references/equipe-github.md), executar `scripts/Sync-References.ps1` e consultar as referências da branch aprovada, por padrão `main`.
- Se a sincronização falhar, informar que não foi possível confirmar atualizações. A cópia aprovada incluída na skill pode ser usada de forma explícita; não afirmar que sincronizou. Não usar mudanças locais não aprovadas do cache como padrão.
- Ler [padrão visual](references/padrao-visual.md) e visualizar as telas pertinentes em `references/layout-referencia-usuario/`. Uma referência aprovada mais recente prevalece; instruções atuais do usuário têm prioridade.
- Adaptar escala, quantidade, orientação e sobreposição a cada embalagem. Não aplicar automaticamente três cópias iguais a tudo.
- Identificar arquivo, validade, destaques e quantidade por tela pelo contexto. Perguntar somente dados ausentes que mudem o resultado.

## Produção

1. Inspecionar o documento exato antes de editar e ativá-lo explicitamente no script. Preferir um conector próprio de Illustrator quando disponível e suficiente; caso contrário, usar o helper COM incluído.
2. Preservar ajustes do usuário, tema, fontes e cores do cliente. Não impor a identidade de outro cliente. Fazer cópia de segurança antes de alterações extensas.
3. Buscar fotos pelos códigos nas pastas configuradas e depois por descrição. Ver a foto: código e nome podem apontar para embalagem antiga ou errada. Pesquisar faltantes na web quando autorizado no pedido/sessão, preferindo fabricante e embalagem exata. Não inventar rótulos ou trocar marcas. Usar ferramenta de edição de imagens disponível para recorte de fundo.
4. Fotos grandes, embalagens reconhecíveis, opções reais em DIVERSOS/SABORES/FRAGRÂNCIAS, descrições curtas com quebras semânticas e preço junto à base da foto. Conferir marca, peso, volume e variante.
5. Usar `CADA` por embalagem/unidade. Para venda por quilo, usar `KG` na descrição e no preço. Unidade sob os centavos, com margem. Pacote de 1 kg não vira automaticamente venda por KG.
6. Preservar condições de compra e avisos fornecidos: frase do leite pequena acima do preço correspondente e selo de álcool junto ao produto, sem encobrir informações.
7. Exportar e visualizar cada tela nova, comparar com as referências e corrigir diferenças antes de concluir. Execução do script não substitui revisão visual.
8. Salvar no destino autorizado e relatar o resultado real, incluindo pendências quando houver.

## Ideias e contribuições

O usuário pediu **uma pergunta antes de enviar imagens ou ideias ao GitHub**. Identificar a proposta e o destino concreto, explicar sua utilidade e perguntar se ele quer enviá-la. Não criar issue, branch, commit, PR ou push sem autorização para aquela publicação. Permissão para ler/sincronizar não autoriza publicar.

Após autorização, preferir uma proposta em branch e PR com exemplo e escopo. Ela só vira padrão depois de aprovada na branch principal. Não aplicar ideias em avaliação a todos os clientes.

## Recursos

- [Conexão e cuidados](references/conexao-illustrator.md)
- [Padrão e exemplos aprovados](references/padrao-visual.md)
- [GitHub e revisão da equipe](references/equipe-github.md)
- `assets/frase-leite.png` e `assets/selo-beba-com-moderacao.png`: avisos fornecidos pelo usuário, para inserir pequenos junto ao preço dos produtos correspondentes.
- `scripts/Setup-Illustrator.ps1`: versão, pastas e teste.
- `scripts/Invoke-Illustrator.ps1`: status, documentos ou JSX em arquivo identificado.
- `scripts/Sync-References.ps1`: atualização apenas de leitura do repositório.

Não alegar que a skill elimina autorizações ou limitações do computador, Codex ou empresa. Não colocar credenciais no pacote ou no repositório.
