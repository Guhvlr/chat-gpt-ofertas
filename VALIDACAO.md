# Validação do pacote — 03/11/2026

- Skill aprovada pelo validador oficial `quick_validate.py`.
- Sintaxe de todos os scripts PowerShell validada.
- Instalação em diretório isolado: cópia e configuração concluídas; sem acesso ao COM, a pendência de conexão foi reportada corretamente.
- Instalação real neste PC: Illustrator **28.1.0**, conexão confirmada.
- Modos Status e ListDocuments testados com três documentos abertos, todos salvos. Nenhum documento foi alterado nesses testes.
- Conversão de versões 2024 → 28 e 30.0.1 → 30; entrada inválida rejeitada.
- Sincronização testada com repositório local isolado: clone, atualização fast-forward e recusa de cache com alterações locais.
- Nove imagens de referência copiadas da versão corrigida pelo usuário; os arquivos `.ai` e a biblioteca de fotos não estão incluídos.

Limites: a conexão foi verificada neste PC com Windows e Illustrator 28.1.0. Outras versões precisam do teste inicial previsto pelo instalador. O modo Script executa JSX fornecido pelo agente; a correção de cada arte depende da revisão visual. Um computador novo ainda precisa de Illustrator/Codex, fontes e materiais do cliente. Sincronização privada depende de Git e acesso da conta local.

## Atualização: memória por arquivo e recebimento de padrões

- `Save-Work.ps1` testado em documentos temporários no Illustrator 28.1.0: primeiro salvamento, destino e validade lembrados após fechar/reabrir, checkpoint após JSX, novo documento identificado separadamente e tentativa de sobrescrever outro arquivo bloqueada. As artes do usuário não foram modificadas.
- `Update-Skill.ps1` testado com origem Git isolada: atualização da skill instalada com backup, repetição sem mudanças e preservação de cache com alterações locais.
- Histórico por arquivo e configuração local permanecem fora da pasta da skill e do GitHub. Não há salvamento ou atualização em segundo plano: o agente aciona os helpers nos blocos de trabalho.
- A instalação não pede tarefa, arquivo a abrir ou biblioteca de fotos. Versão continua sendo a informação necessária para escolher o COM correto.
