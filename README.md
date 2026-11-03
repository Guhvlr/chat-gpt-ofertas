# Ofertas da equipe — Illustrator

Central Mac Digital e skill portátil com as orientações do Gustavo, nove telas corrigidas por ele e conexão nativa com Illustrator no Windows. O objetivo é consultar os padrões aprovados antes de cada oferta e preservar a identidade de cada cliente.

## Instalar em outro PC

1. Instale Codex e Adobe Illustrator pelos canais oficiais. Para sincronizar referências, instale também Git para Windows e entre na sua própria conta com acesso a este repositório privado.
2. Baixe em **Code → Download ZIP** e extraia tudo.
3. Abra **Central.cmd** (ou **Instalar.cmd**, que abre a mesma Central). Na página local, selecione a versão do Illustrator e clique em **Instalar e conectar**. O aplicativo pode ser iniciado para testar a conexão. Na instalação não é preciso escolher oferta, fotos ou arquivo a abrir.
4. Quando estiver conectado, clique em **Iniciar conversa**. O Codex abre com a pasta e uma mensagem inicial preparadas; revise e envie. Alternativa: abra o Codex e peça **Use $gustavo-illustrator-ofertas para atualizar minha oferta.** Reinicie o Codex se a skill não aparecer.

A Central também permite testar a conexão, atualizar skill/referências e visualizar as nove telas aprovadas. **Apenas Illustrator está disponível. After Effects, Photoshop e CapCut aparecem como “Em breve”.** Veja [operação da Central](central/README.md).

O instalador usa Windows PowerShell 5.1 e instala por padrão em `%USERPROFILE%\.agents\skills`. Não instala Illustrator, licença, fontes, arquivos `.ai` nem toda a biblioteca de produtos. Cada PC precisa ter seus próprios modelos e fotos. A configuração local fica em `%LOCALAPPDATA%\GustavoIllustrator`; não é enviada ao GitHub.

Exemplo com outra pasta de instalação:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File Instalar.ps1 -VersionLabel 2024 -SkillsDirectory "$env:USERPROFILE\.codex\skills"
```

## Padrão visual e contribuições

As regras estão em [padrão visual](skills/gustavo-illustrator-ofertas/references/padrao-visual.md), acompanhadas das [telas aprovadas](skills/gustavo-illustrator-ofertas/references/layout-referencia-usuario/visao-geral.jpg). Fotografias grandes, descrições com quebras semânticas e composição adaptada à embalagem. Quantidade de cópias e cores dependem do produto e do cliente.

Antes de cada oferta, a skill busca a branch `main`. Novas ideias e imagens só são enviadas após autorização; use uma proposta revisável conforme [modelo](ideias/MODELO.md). Não compartilhe credenciais. Convide cada funcionário como colaborador com sua própria conta.

### Atualizações em todos os PCs

Cada PC com esta skill instalada executa `Update-Skill.ps1` antes de trabalhar: busca a versão aprovada em `main`, guarda backup quando houver mudança e atualiza instruções, scripts e referências. Releia as instruções atualizadas na conversa. A configuração do Illustrator e a memória dos arquivos ficam no PC. Não existe atualização instantânea em segundo plano; ela ocorre na próxima utilização com conexão ao GitHub.

### Salvar sem repetir perguntas

No primeiro uso de cada arquivo, a skill confirma pasta, nome e validade pelos dados ainda ausentes, salva uma cópia antes da primeira alteração e registra esse destino. Depois salva a cada bloco de trabalho. Ao voltar ao mesmo arquivo, reutiliza os dados. Outro arquivo, campanha ou destino recebe sua própria confirmação. Consulte [salvamento](skills/gustavo-illustrator-ofertas/references/salvamento.md).

### Pedido pronto para um PC novo

> Baixe e configure https://github.com/Guhvlr/chat-gpt-ofertas neste PC. Leia o AGENTS.md e abra a Central Mac Digital para eu selecionar a versão do Illustrator e instalar a integração. Depois aguarde minha tarefa.

O Codex do novo PC precisa conseguir acessar o repositório privado com a conta da pessoa. O pedido orienta o agente a executar a instalação; apenas colar um link ou baixar um ZIP não executa programas sozinho. Se Git estiver ausente, o agente pode instalar o Git oficial dentro das permissões do computador. Acesso privado e licença Adobe continuam próprios de cada pessoa/PC.

Este pacote oferece conexão e orientações para o agente; não é um gerador automático de artes nem garante composição correta sem revisão visual. Testes e limitações estão em [VALIDACAO.md](VALIDACAO.md).
