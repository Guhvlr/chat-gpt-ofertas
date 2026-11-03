# Destino lembrado por arquivo

Memória específica do PC: `%LOCALAPPDATA%\GustavoIllustrator\work-files.json`. Não publicar esse arquivo, seu backup ou caminhos dos trabalhos. Registro por caminho completo, nunca apenas pelo nome da janela. Um novo arquivo/campanha exige seu próprio destino; voltar a editar um trabalho registrado reutiliza pasta, nome e validade.

Usar Windows PowerShell 5.1. Exemplos a partir da pasta da skill:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File scripts/Save-Work.ps1 -Mode Inspect -DocumentName "Modelo.ai"
powershell.exe -NoProfile -ExecutionPolicy Bypass -File scripts/Save-Work.ps1 -Mode Prepare -DocumentName "Modelo.ai" -OutputPath "C:\Ofertas\Cliente\Oferta 05 e 06.11.2026.ai" -Validity "05 e 06.11.2026"
powershell.exe -NoProfile -ExecutionPolicy Bypass -File scripts/Save-Work.ps1 -Mode Checkpoint -DocumentName "Oferta 05 e 06.11.2026.ai"
```

`Inspect` não salva nem edita. Se `needsDestination=true`, coletar os dados ausentes antes de editar. Criar somente a pasta confirmada. `Prepare` salva uma cópia `.ai` com PDF compatível e registra o trabalho somente após confirmar o salvamento. Save As muda o nome do documento: usar o `documentName` retornado nos próximos comandos. `Checkpoint` salva apenas arquivos já registrados. Novo destino existente é recusado para evitar sobrescrever outro trabalho.

O helper não troca textos, validade ou imagens sozinho. Esses ajustes continuam sendo feitos pelo agente, que salva depois de cada bloco. O histórico registra a validade confirmada para não voltar a perguntá-la. Se o usuário mudar a data, passar `-Validity` no próximo checkpoint e atualizar também a arte.

Ao reabrir arquivo registrado no mesmo caminho, não perguntar destino outra vez. Em outro PC ou após mover o arquivo, o histórico local pode não existir: confirmar o caminho e registrar novamente. Não pressupor que o arquivo aberto é a cópia conhecida porque tem o mesmo nome. Salvar frequentemente reduz perdas; não garante recuperação de alterações desde o último checkpoint, nem substitui backup do cliente.

Por conector alternativo, manter exatamente o mesmo comportamento e verificar a existência do arquivo. O histórico serve para a rotina do agente; não é um salvamento independente em segundo plano.
