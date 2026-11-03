(() => {
  'use strict';
  const $ = id => document.getElementById(id);
  const params = new URLSearchParams(location.hash.slice(1));
  const token = params.get('session') || sessionStorage.getItem('mac-central-session') || '';
  if (token) sessionStorage.setItem('mac-central-session', token);
  if (location.hash) history.replaceState(null, '', location.pathname);
  let busy = false, status = null, referenceUrl = null;
  const prompt = 'Use $gustavo-illustrator-ofertas. Busque as orientações e referências aprovadas mais recentes da equipe e aguarde minha tarefa para o Illustrator. Não altere nenhuma oferta ainda.';
  $('prompt-preview').textContent = prompt;
  function notice(message, kind = 'success') {
    $('notice').hidden = false; $('notice').className = `notice ${kind}`; $('notice').textContent = message;
  }
  async function api(path, method = 'GET', body) {
    const res = await fetch(path, { method, headers: { 'Authorization': `Bearer ${token}`, ...(method === 'POST' ? { 'Content-Type': 'application/json' } : {}) }, body: body === undefined ? undefined : JSON.stringify(body), cache: 'no-store' });
    const data = await res.json();
    if (!res.ok || data.error) throw new Error(data.error || 'Não foi possível concluir esta operação.');
    return data;
  }
  function controls() {
    $('version').disabled = busy || !status;
    $('install').disabled = busy || !status || !$('version').value;
    $('test').disabled = busy || !status?.configured;
    $('update').disabled = busy || !status?.installed || !status?.gitAvailable;
    $('stop').disabled = busy;
    const ready = !busy && !!status?.connected && !!status?.installed;
    $('chat').classList.toggle('disabled', !ready); $('chat').setAttribute('aria-disabled', String(!ready));
    if (ready) $('chat').href = status.chatUrl; else $('chat').removeAttribute('href');
    $('install-label').textContent = busy ? 'Preparando…' : status?.installed ? 'Configurar e conectar' : 'Instalar e conectar';
  }
  function render(data) {
    status = data;
    const selected = $('version').value || data.configuredVersion || (data.versions[0] && String(data.versions[0].major)) || '';
    const versions = new Map(data.versions.map(v => [String(v.major), v.label]));
    for (const [year, major] of [[2026, 30], [2025, 29], [2024, 28], [2023, 27], [2022, 26], [2021, 25], [2020, 24]]) if (!versions.has(String(major))) versions.set(String(major), `Illustrator ${year} · versão ${major}`);
    $('version').replaceChildren();
    for (const [value, label] of versions) { const option = document.createElement('option'); option.value = value; option.textContent = label; $('version').append(option); }
    $('version').value = versions.has(String(selected)) ? String(selected) : '30';
    $('version-hint').textContent = data.versions.length ? `${data.versions.length === 1 ? 'Versão detectada' : 'Versões detectadas'} neste PC. Confirme a que deseja conectar.` : 'Selecione a versão. Ela precisa estar instalada neste PC.';
    $('connection-dot').classList.toggle('connected', !!data.connected);
    $('connection-label').textContent = data.connected ? `Conectado ao Illustrator ${data.activeVersion}` : data.installed ? 'Skill instalada · conexão pendente' : 'Pronto para configurar neste computador';
    $('system-label').textContent = `Windows · Conexão local${data.installed ? ' · Skill instalada' : ''}${!data.gitAvailable ? ' · Git não encontrado' : ''}`;
    controls();
  }
  async function action(path, message, body) {
    if (busy) return;
    busy = true; controls(); notice(message, 'busy');
    try {
      const result = await api(path, 'POST', body || {});
      render(result.status);
      notice(result.message, result.warning ? 'error' : 'success');
    } catch (error) {
      if (status && (path === '/api/test' || path === '/api/install')) render({ ...status, connected: false });
      notice(error.message, 'error');
    }
    finally { busy = false; controls(); }
  }
  $('version').addEventListener('change', controls);
  $('install').addEventListener('click', () => action('/api/install', 'Instalando a skill e testando a conexão. O Illustrator pode ser aberto; aguarde.', { version: $('version').value }));
  $('test').addEventListener('click', () => action('/api/test', 'Verificando a conexão com o Illustrator…'));
  $('update').addEventListener('click', () => action('/api/update', 'Buscando a versão aprovada da skill e das referências no GitHub…'));
  $('chat').addEventListener('click', e => { if ($('chat').getAttribute('aria-disabled') === 'true') e.preventDefault(); else notice('O Codex vai abrir com a mensagem preparada. Revise e envie. Se o aplicativo não abrir, veja “Como funciona”.'); });
  $('copy-prompt').addEventListener('click', async () => { try { await navigator.clipboard.writeText(prompt); $('copy-prompt').textContent = 'Mensagem copiada ✓'; } catch { $('copy-prompt').textContent = 'Selecione e copie a mensagem acima'; } });
  $('nav-help').addEventListener('click', () => $('help-dialog').showModal());
  $('nav-apps').addEventListener('click', () => $('illustrator-title').scrollIntoView({ behavior: 'smooth', block: 'center' }));
  async function references() {
    $('references-dialog').showModal();
    if (referenceUrl) return;
    try {
      const response = await fetch('/api/reference', { headers: { Authorization: `Bearer ${token}` }, cache: 'no-store' });
      if (!response.ok) throw new Error('Não foi possível carregar as referências. Abra novamente a Central.');
      referenceUrl = URL.createObjectURL(await response.blob()); $('reference-image').src = referenceUrl;
      $('reference-image').hidden = false; $('reference-loading').hidden = true;
    } catch (error) { $('reference-loading').textContent = error.message; }
  }
  $('nav-references').addEventListener('click', references); $('view-references').addEventListener('click', references);
  for (const button of document.querySelectorAll('[data-close]')) button.addEventListener('click', () => $(button.dataset.close).close());
  for (const dialog of document.querySelectorAll('dialog')) dialog.addEventListener('click', e => { if (e.target === dialog && (e.offsetX < 0 || e.offsetY < 0 || e.offsetX > dialog.offsetWidth || e.offsetY > dialog.offsetHeight)) dialog.close(); });
  $('stop').addEventListener('click', async () => { if (busy) return; try { await api('/api/stop', 'POST', {}); status = null; busy = true; controls(); notice('Central encerrada. Para voltar, abra Central.cmd. Sua skill continua instalada.'); } catch (error) { notice(error.message, 'error'); } });
  if (!token) { notice('Abra a Central pelo arquivo Central.cmd para conectar esta página ao computador.', 'error'); $('connection-label').textContent = 'Central sem sessão local'; $('stop').disabled = true; }
  else api('/api/status').then(render).catch(error => { notice(`${error.message} Abra Central.cmd novamente se a sessão expirou.`, 'error'); $('connection-label').textContent = 'Não foi possível conectar'; });
})();
