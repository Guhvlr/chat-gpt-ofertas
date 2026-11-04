# Central Mac Digital — Windows

Abra `Central.cmd`, na raiz do pacote. A Central inicia um pequeno servidor no próprio computador, com janela de fundo oculta, e abre a interface no navegador padrão. Não precisa Node, Python, instalar serviço ou configurar o firewall.

## Disponibilidade

- **Illustrator:** detecção das versões COM registradas, seleção de versão, instalação da skill, teste de conexão, atualização da skill/referências, visualização das referências e abertura de conversa no Codex.
- **After Effects, Photoshop e CapCut:** somente cartões com ícone e “Em breve”, sem ações de instalação.

Os executáveis Adobe e suas licenças não são instalados pela Central. O botão de conversa requer o aplicativo desktop com Codex instalado e o protocolo `codex://` registrado. Ele abre a pasta e preenche a mensagem inicial, sem enviá-la. Se o aplicativo não abrir, “Como funciona” oferece a mensagem para copiar. Documentação: [links de conversa](https://learn.chatgpt.com/docs/reference/commands).

## Operação

- Ao selecionar uma versão e instalar, o instalador existente configura apenas o Illustrator e preserva as pastas de fotos já configuradas. Se a conexão falhar, a skill continua instalada e a pendência é mostrada.
- “Testar conexão” não modifica as artes. Para edição posterior, o agente usa os salvamentos por arquivo previstos na skill.
- “Atualizar skill e referências” busca a branch aprovada do repositório público. Git para Windows é necessário; conta, convite ou chave do GitHub não são exigidos para baixar ou atualizar. As atualizações da própria interface Central são recebidas ao baixar uma nova cópia do pacote ou atualizar seu checkout Git; o botão atualiza a skill e as referências.
- Nenhum produto é editado e nenhuma mensagem é enviada automaticamente ao iniciar a Central.
- “Encerrar Central” para o servidor, mas mantém a skill instalada. O servidor também encerra após duas horas sem chamadas autenticadas.

## Sessão local

O servidor escuta somente `127.0.0.1`, em porta livre escolhida pelo Windows. Os endpoints privados exigem uma sessão aleatória e rejeitam origem/Host diferentes. O token temporário não é uma chave GitHub; é usado apenas entre essa página e o servidor local. Ele fica no fragmento inicial da URL, removido pela interface e mantido na sessão da aba.

Dados locais em `%LOCALAPPDATA%\GustavoIllustrator`: `central-session.json`, `central.log` e `central-error.log`. A sessão é apagada ao encerrar normalmente. Não colocar esses arquivos no GitHub. Se o navegador não abrir, execute `Central.cmd` novamente; se o servidor existente responder, a Central o reutiliza. Se houver erro, consulte o log local.

Para o agente abrir a interface a partir do repositório já baixado:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File central/Abrir-Central.ps1
```

Para instalação sem interface, o `Instalar.ps1` da raiz continua disponível. O servidor não recebe comandos arbitrários ou caminhos para executar; suas rotas expõem somente as ações fixas desta interface.
