# Conexão no Windows

Em um PC novo, instalar previamente Codex e Illustrator pelos meios oficiais. Extrair o pacote e abrir `Instalar.cmd`: a pergunta é a versão do Illustrator. O instalador copia a skill e testa o COM; se a conexão falhar, informa a pendência. Não perguntar tarefa, arquivo a abrir ou fotos na instalação: aguardar o próximo pedido. Não instala Adobe, fontes ou modelos dos clientes. Configurar caminhos das fotos somente quando forem necessários à produção.

Usar Windows PowerShell 5.1 (`powershell.exe`), pois PowerShell 7 não oferece o mesmo acesso ao Illustrator COM. Anos 2020–2026 correspondem a versões internas 24–30; para outros anos usar o número de Ajuda → Sobre.

Exemplos a partir da pasta da skill:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File scripts/Setup-Illustrator.ps1 -VersionLabel 28.1
powershell.exe -NoProfile -ExecutionPolicy Bypass -File scripts/Invoke-Illustrator.ps1 -Mode Status
powershell.exe -NoProfile -ExecutionPolicy Bypass -File scripts/Invoke-Illustrator.ps1 -Mode ListDocuments
powershell.exe -NoProfile -ExecutionPolicy Bypass -File scripts/Invoke-Illustrator.ps1 -Mode Script -DocumentName "Oferta.ai" -ScriptPath "C:\trabalho\alterar.jsx"
```

O modo Script executa código com acesso ao documento; revisar o JSX e usar somente operações autorizadas. Os modos Status e ListDocuments são de leitura. Não fechar aplicativo ou documentos do usuário. Se o Illustrator travar ou abrir um diálogo modal, parar as tentativas e pedir que o usuário resolva o estado do aplicativo. Evitar varrer recursivamente todo o DOM de artes grandes; para inspeção visual, preferir PDF compatível já salvo ou exportações pontuais. ExtendScript pode não ter JSON nativo.

A skill fica por padrão em `%USERPROFILE%\.agents\skills\gustavo-illustrator-ofertas`. Para ambientes que usam outra pasta, passar `-SkillsDirectory` ao instalador. Não instalar duplicatas em `.agents` e `.codex`. Se não aparecer, reiniciar Codex e usar `$gustavo-illustrator-ofertas`.

Se já houver uma instalação em `.codex/skills`, o instalador reutiliza esse local. Atualizar as orientações com `scripts/Update-Skill.ps1`, sem refazer o setup ou perguntar versão a cada trabalho. Para trocar a versão do Illustrator, executar Setup novamente com a versão escolhida.

Configuração específica do PC: `%LOCALAPPDATA%\GustavoIllustrator\settings.json`. Não compartilhar esse arquivo. `Instalar.cmd` usa Bypass apenas no processo iniciado, sem mudar a política global do Windows.

Documentação: [skills do Codex](https://learn.chatgpt.com/docs/build-skills), [scripts do Illustrator](https://helpx.adobe.com/illustrator/desktop/automate-visualize-data/automate-actions/install-and-run-scripts.html).
