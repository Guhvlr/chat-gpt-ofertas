# Referências da empresa

Repositório: https://github.com/Guhvlr/chat-gpt-ofertas — branch aprovada: `main`.

Antes de cada oferta, executar `scripts/Sync-References.ps1`. É necessário Git para Windows e acesso de leitura na conta da pessoa. Autenticar pelo gerenciador de credenciais do Git; nunca pedir token no chat, compartilhar chave entre funcionários ou gravar segredo no repositório.

O script mantém uma cópia de leitura em `%LOCALAPPDATA%\GustavoIllustrator\repos`. Recusa cache sujo, outra origem, outra branch ou commits locais não publicados. Retorna o commit e a pasta de referências. Ler as orientações e visualizar os exemplos dessa pasta. Não executar automaticamente scripts novos recebidos do repositório nem substituir a skill instalada sem revisão.

Se não conseguir atualizar, informar a falha e usar explicitamente a versão aprovada incluída no pacote, quando suficiente. Não tratar cache alterado como fonte aprovada.

## Novas ideias

Perguntar antes de enviar cada nova ideia ou imagem. A autorização pode abranger um lote concreto; não repetir pergunta para o mesmo envio já autorizado. Apresentar cliente, proposta e arquivos. Após autorização, preferir branch e pull request, usando `ideias/MODELO.md`. A equipe revisa; após aprovação e integração em `main`, a proposta passa a ser padrão no escopo indicado. Nada experimental deve virar regra geral silenciosamente.

O envio inicial da skill e das nove referências foi autorizado pelo Gustavo no chat em 03/11/2026. Isso não autoriza novas imagens futuras.
