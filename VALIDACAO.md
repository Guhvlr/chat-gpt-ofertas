# Validação do pacote — 03/11/2026

- Skill aprovada pelo validador oficial `quick_validate.py`.
- Sintaxe de todos os scripts PowerShell validada.
- Instalação em diretório isolado: cópia e configuração concluídas; sem acesso ao COM, a pendência de conexão foi reportada corretamente.
- Instalação real neste PC: Illustrator **28.1.0**, conexão confirmada.
- Modos Status e ListDocuments testados com três documentos abertos, todos salvos. Nenhum documento foi alterado nesses testes.
- Conversão de versões 2024 → 28 e 30.0.1 → 30; entrada inválida rejeitada.
- Sincronização testada com repositório local isolado: clone, atualização fast-forward e recusa de cache com alterações locais.
- Nove imagens de referência copiadas da versão corrigida pelo usuário; os arquivos `.ai` e a biblioteca de fotos não estão incluídos.

Limites: a conexão foi verificada neste PC com Windows e Illustrator 28.1.0. Outras versões precisam do teste inicial previsto pelo instalador. O modo Script executa JSX fornecido pelo agente; a correção de cada arte depende da revisão visual. Um computador novo ainda precisa de Illustrator/Codex, fontes e materiais do cliente. Sincronização depende de Git; o repositório público não exige conta para leitura.

## Atualização: memória por arquivo e recebimento de padrões

- `Save-Work.ps1` testado em documentos temporários no Illustrator 28.1.0: primeiro salvamento, destino e validade lembrados após fechar/reabrir, checkpoint após JSX, novo documento identificado separadamente e tentativa de sobrescrever outro arquivo bloqueada. As artes do usuário não foram modificadas.
- `Update-Skill.ps1` testado com origem Git isolada: atualização da skill instalada com backup, repetição sem mudanças e preservação de cache com alterações locais.
- Histórico por arquivo e configuração local permanecem fora da pasta da skill e do GitHub. Não há salvamento ou atualização em segundo plano: o agente aciona os helpers nos blocos de trabalho.
- A instalação não pede tarefa, arquivo a abrir ou biblioteca de fotos. Versão continua sendo a informação necessária para escolher o COM correto.

## Central Mac Digital 1.0

- Interface HTML/CSS/JS local, sem dependências web externas. Illustrator é a única integração ativa; After Effects, Photoshop e CapCut aparecem como “Em breve”.
- Servidor Windows PowerShell 5.1 testado com detecção do Illustrator 2024/28.1.0, instalação em pasta isolada pelo botão da página, confirmação da conexão e entrega da imagem de referências.
- Chamadas sem sessão e de origem externa rejeitadas (403); tentativa de ler arquivo fora das rotas públicas rejeitada (404); versão inválida rejeitada (400).
- Link de conversa validado com protocolo `codex://new`, pasta absoluta e mensagem que invoca a skill. Não foi criada uma conversa de teste nem enviada uma mensagem automaticamente.
- Interface revisada no navegador em largura de desktop (1280 px) e estreita (390 px), sem rolagem horizontal no teste estreito. Instalação e teste da conexão confirmados pela interface.
- Botão de atualização testado contra o GitHub privado pela interface. O cálculo de hashes usa SHA-256 do .NET para funcionar também no processo local de fundo, sem depender da descoberta do cmdlet Get-FileHash.

## Acesso público — 04/11/2026

O Gustavo autorizou tornar público o repositório, incluindo o instalador, scripts, orientações e nove imagens de referência. A visibilidade pública foi confirmada pela API sem autenticação e o endpoint do ZIP respondeu sem credenciais. Os testes anteriores contra o GitHub privado acima registram a condição histórica da primeira versão; instalações e atualizações atuais não exigem conta do GitHub.
