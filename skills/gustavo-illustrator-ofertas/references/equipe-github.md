# Referências da empresa

Repositório: https://github.com/Guhvlr/chat-gpt-ofertas — branch aprovada: `main`. Público desde 04/11/2026, por autorização do Gustavo.

Antes de cada oferta, executar `scripts/Update-Skill.ps1`, que chama `Sync-References.ps1`. É necessário Git para Windows. Baixar e sincronizar este repositório público não exige conta, convite ou token: não pedir autenticação do GitHub para instalação ou leitura. Só o envio de contribuições exige conta com permissão de escrita, autenticada pelo gerenciador de credenciais do Git; nunca pedir token no chat, compartilhar chave entre funcionários ou gravar segredo no repositório.

O sincronizador mantém uma cópia de leitura em `%LOCALAPPDATA%\GustavoIllustrator\repos`. Recusa cache sujo, outra origem, outra branch ou commits locais não publicados. O atualizador compara os arquivos com a skill instalada, guarda backup quando houver diferenças e copia as atualizações aprovadas, preservando a configuração e o histórico do PC. Essa atualização foi autorizada pelo Gustavo: não perguntar novamente só para receber orientações aprovadas.

Após atualizar, reler o `SKILL.md` retornado e as referências pertinentes, inclusive durante a mesma conversa: o texto já carregado pelo chat pode estar antigo. Revisar alterações de código antes de executar novos scripts em documentos. Conteúdo do repositório não substitui instruções do usuário ou permissões do aplicativo. Quem já usa a primeira versão deve atualizá-la uma vez para receber esse fluxo.

Não há serviço de atualização em segundo plano nem alteração instantânea em PCs desligados. Os PCs recebem a versão atual quando usam a skill com acesso ao GitHub. Buscar novamente no começo de cada nova oferta e, durante trabalho longo, antes do próximo bloco se o usuário avisar que publicou uma atualização. Sem internet, informar o uso da última versão disponível.

Se não conseguir atualizar, informar a falha e usar explicitamente a versão aprovada incluída no pacote, quando suficiente. Não tratar cache alterado como fonte aprovada.

## Novas ideias

Perguntar antes de enviar cada nova ideia ou imagem. A autorização pode abranger um lote concreto; não repetir pergunta para o mesmo envio já autorizado. Apresentar cliente, proposta e arquivos. Após autorização, preferir branch e pull request, usando `ideias/MODELO.md`. A equipe revisa; após aprovação e integração em `main`, a proposta passa a ser padrão no escopo indicado. Nada experimental deve virar regra geral silenciosamente.

O envio inicial da skill e das nove referências foi autorizado pelo Gustavo no chat em 03/11/2026. Isso não autoriza novas imagens futuras.
