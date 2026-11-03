---
name: gustavo-illustrator-ofertas
description: Configurar a conexão local com o Illustrator no Windows e criar ou atualizar artes de ofertas no padrão aprovado pelo Gustavo, com fotos por código, descrições, preços e referências compartilhadas da equipe.
---

# Illustrator — Ofertas do Gustavo

Esta skill inclui as orientações e nove telas corrigidas manualmente pelo Gustavo. Usa a automação COM/ExtendScript nativa do Illustrator no Windows, sem painel azul, servidor MCP, Node ou Python para conectar. Illustrator e Codex precisam estar instalados; o pacote não instala o aplicativo Adobe nem inclui licença, fontes, modelos `.ai` ou a biblioteca completa de fotos.

## Primeiro uso ou computador diferente

1. Perguntar **qual a versão do Illustrator** e confirmar o sistema operacional, se ainda não informados. Não repetir respostas da sessão. Os scripts suportam Windows; explicar a limitação em outro sistema.
   Se o pedido for instalar pela **Central Mac Digital**, abrir `central/Abrir-Central.ps1` na raiz do pacote e deixar a pessoa escolher a versão pela interface, sem repetir a pergunta no chat. Somente Illustrator está disponível; os outros aplicativos aparecem como “Em breve”.
2. Ler [conexão e operação](references/conexao-illustrator.md). Executar o `Instalar.ps1` da raiz do repositório com `powershell.exe`, passando a versão respondida. O instalador configura o conector. Se já estiver instalado, preservar a configuração local.
3. Testar a conexão sem editar documento e confirmar a versão que respondeu. Nunca usar silenciosamente outra instalação.
4. Na instalação, não perguntar tarefa, arquivo a abrir, pasta de saída ou validade: aguardar o pedido posterior. Perguntar por modelos e fotos somente quando necessários à tarefa. Caminhos antigos são históricos. A configuração local fica em `%LOCALAPPDATA%\GustavoIllustrator\settings.json`.
5. Não reinstalar algo que já funciona nem alterar registro, instalação Adobe ou permissões globais para contornar falhas.

## Antes de cada oferta

- Havendo repositório configurado, ler [equipe e GitHub](references/equipe-github.md), executar `scripts/Update-Skill.ps1` e **reler o SKILL.md atualizado retornado**, além das referências da branch aprovada, por padrão `main`. A atualização do próprio pacote e das orientações foi autorizada pelo Gustavo; não repetir confirmação para buscar os padrões aprovados. Respeitar as permissões do computador e revisar código novo antes de executá-lo em documentos.
- Se a sincronização falhar, informar que não foi possível confirmar atualizações. A cópia aprovada incluída na skill pode ser usada de forma explícita; não afirmar que sincronizou. Não usar mudanças locais não aprovadas do cache como padrão.
- Ler [padrão visual](references/padrao-visual.md) e visualizar as telas pertinentes em `references/layout-referencia-usuario/`. Uma referência aprovada mais recente prevalece; instruções atuais do usuário têm prioridade.
- Adaptar escala, quantidade, orientação e sobreposição a cada embalagem. Não aplicar automaticamente três cópias iguais a tudo.
- Identificar arquivo, validade, destaques e quantidade por tela pelo contexto. Perguntar somente dados ausentes que mudem o resultado.

## Destino e salvamentos por arquivo

Antes de editar, ler [salvamento contínuo](references/salvamento.md) e executar `scripts/Save-Work.ps1 -Mode Inspect` no documento exato.

- **Primeira vez nesse trabalho:** perguntar pasta de saída, nome do arquivo e validade da oferta, juntos, apenas pelos dados que faltarem. Não inventar validade a partir do nome antigo. Usar respostas já dadas na sessão. Confirmar um destino existente antes de sobrescrever; preferir nova cópia do modelo.
- Executar `Prepare` com o destino e a validade confirmados, **antes da primeira mudança**. A cópia precisa existir em disco, com salvamento confirmado. Atualizar a descrição e o rodapé com a validade conforme a tarefa; registrar a data não altera sozinho a arte.
- **Ao voltar ao mesmo arquivo:** usar o caminho e a validade registrados sem repetir perguntas. Perguntar de novo somente se o usuário iniciar outra campanha, pedir outro destino/data ou o arquivo tiver sido movido e não for possível identificá-lo.
- Salvar ao concluir cada bloco pequeno (descrições/preços, um lote de imagens ou uma tela) e antes de operação demorada. `Invoke-Illustrator.ps1 -Mode Script` faz checkpoint após execução bem-sucedida; por outro conector, fazer o equivalente a Ctrl+S e verificar o resultado. Não esperar o fim de todas as telas.
- Não salvar mudanças parciais de script que falhou sem inspecionar o resultado. Se falhar ao salvar, parar e informar o último arquivo confirmado; não continuar acumulando trabalho sem proteção.
- O histórico local identifica cada arquivo pelo caminho completo; arquivos com nomes iguais em pastas diferentes são trabalhos distintos. Não enviar histórico de trabalho ao GitHub.

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
- `scripts/Update-Skill.ps1`: busca a branch aprovada, faz backup e atualiza a própria skill sem repetir o setup.
- `scripts/Save-Work.ps1`: primeiro salvamento, memória de destino/validade e checkpoints por arquivo.

Não alegar que a skill elimina autorizações ou limitações do computador, Codex ou empresa. Não colocar credenciais no pacote ou no repositório.
