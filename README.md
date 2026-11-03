# Ofertas da equipe — Illustrator

Skill portátil com as orientações do Gustavo, nove telas corrigidas por ele e conexão nativa com Illustrator no Windows. O objetivo é consultar os padrões aprovados antes de cada oferta e preservar a identidade de cada cliente.

## Instalar em outro PC

1. Instale Codex e Adobe Illustrator pelos canais oficiais. Para sincronizar referências, instale também Git para Windows e entre na sua própria conta com acesso a este repositório privado.
2. Baixe em **Code → Download ZIP** e extraia tudo.
3. Abra **Instalar.cmd**. Informe primeiro a versão do Illustrator e depois as pastas das fotos. O aplicativo pode ser iniciado para testar a conexão.
4. No Codex, peça: **Use $gustavo-illustrator-ofertas para atualizar minha oferta.** Reinicie o Codex se a skill não aparecer.

O instalador usa Windows PowerShell 5.1 e instala por padrão em `%USERPROFILE%\.agents\skills`. Não instala Illustrator, licença, fontes, arquivos `.ai` nem toda a biblioteca de produtos. Cada PC precisa ter seus próprios modelos e fotos. A configuração local fica em `%LOCALAPPDATA%\GustavoIllustrator`; não é enviada ao GitHub.

Exemplo com outra pasta de instalação:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File Instalar.ps1 -VersionLabel 2024 -SkillsDirectory "$env:USERPROFILE\.codex\skills"
```

## Padrão visual e contribuições

As regras estão em [padrão visual](skills/gustavo-illustrator-ofertas/references/padrao-visual.md), acompanhadas das [telas aprovadas](skills/gustavo-illustrator-ofertas/references/layout-referencia-usuario/visao-geral.jpg). Fotografias grandes, descrições com quebras semânticas e composição adaptada à embalagem. Quantidade de cópias e cores dependem do produto e do cliente.

Antes de cada oferta, a skill busca a branch `main`. Novas ideias e imagens só são enviadas após autorização; use uma proposta revisável conforme [modelo](ideias/MODELO.md). Não compartilhe credenciais. Convide cada funcionário como colaborador com sua própria conta.

Este pacote oferece conexão e orientações para o agente; não é um gerador automático de artes nem garante composição correta sem revisão visual. Testes e limitações estão em [VALIDACAO.md](VALIDACAO.md).
