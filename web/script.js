const app = document.getElementById('app');
const panel = document.getElementById('panel');
const header = document.getElementById('header');
const body = document.getElementById('body');
const dot = document.getElementById('dot');
const statusText = document.getElementById('statusText');
const serverName = document.getElementById('serverName');
const playerCount = document.getElementById('playerCount');
const whitelistStatus = document.getElementById('whitelistStatus');
const playerId = document.getElementById('playerId');
const btnPortal = document.getElementById('btnPortal');
const btnClose = document.getElementById('btnClose');

let visible = false;
let serverInfo = null;

window.addEventListener('message', function(event) {
    const data = event.data;

    switch (data.type) {
        case 'x64hub:open':
            serverInfo = data;
            updateUI(data);
            show();
            break;

        case 'x64hub:serverInfo':
            serverInfo = data;
            updateUI(data);
            break;

        case 'x64hub:whitelistResult':
            updateWhitelist(data);
            break;

        case 'x64hub:close':
            hide();
            break;
    }
});

function updateUI(data) {
    if (data.serverName) serverName.textContent = data.serverName;
    if (data.onlinePlayers !== undefined) {
        playerCount.textContent = data.onlinePlayers + ' / ' + (data.maxPlayers || '64');
    }
    if (data.playerId) playerId.textContent = data.playerId;

    if (data.connected) {
        setStatus('connected', 'Conectado');
    } else if (data.connected === false) {
        setStatus('disconnected', 'Desconectado');
    } else {
        setStatus('connecting', 'Conectando...');
    }

    if (data.whitelisted !== undefined) {
        updateWhitelist(data);
    }
}

function updateWhitelist(data) {
    if (data.whitelisted) {
        whitelistStatus.textContent = 'Aprobada';
        whitelistStatus.style.color = '#34d399';
    } else if (data.status === 'pending') {
        whitelistStatus.textContent = 'Pendiente';
        whitelistStatus.style.color = '#fbbf24';
    } else if (data.status === 'rejected') {
        whitelistStatus.textContent = 'Rechazada';
        whitelistStatus.style.color = '#f87171';
    } else if (data.status === 'no_submission') {
        whitelistStatus.textContent = 'Sin solicitud';
        whitelistStatus.style.color = '#71717a';
    } else if (data.status === 'no_account' || data.status === 'no_discord') {
        whitelistStatus.textContent = 'Sin vincular';
        whitelistStatus.style.color = '#f87171';
    } else {
        whitelistStatus.textContent = '---';
        whitelistStatus.style.color = '#71717a';
    }
}

function setStatus(state, text) {
    dot.className = 'status-dot ' + state;
    statusText.textContent = text;
}

function show() {
    visible = true;
    app.classList.remove('hidden');
    body.style.display = 'block';
}

function hide() {
    visible = false;
    app.classList.add('hidden');
    fetch('https://' + document.location.host + '/x64hub:closeUI', {
        method: 'POST',
        body: JSON.stringify({})
    }).catch(function() {});
}

header.addEventListener('click', function() {
    if (body.style.display === 'none') {
        body.style.display = 'block';
    } else {
        body.style.display = 'none';
    }
});

btnClose.addEventListener('click', hide);

btnPortal.addEventListener('click', function() {
    if (serverInfo && serverInfo.apiUrl && serverInfo.serverId) {
        var slug = serverInfo.slug || serverInfo.serverId;
        var url = serverInfo.apiUrl + '/s/' + slug + '/portal';
        if (window.invokeNative) {
            window.invokeNative("openUrl", url);
        } else {
            window.open(url, '_blank');
        }
    }
});

document.addEventListener('keydown', function(e) {
    if (e.key === 'Escape' && visible) {
        hide();
    }
});
