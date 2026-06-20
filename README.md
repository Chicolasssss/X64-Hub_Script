<div align="center">
  <h1>🚀 X64-HUB - FiveM Connection Bridge</h1>
  <p>The official connection resource for <a href="https://x64hub.com">X64HUB</a>, the Operating System for your Roleplay server.</p>
  <p>
    <a href="#english-">English 🇬🇧</a> •
    <a href="#español-">Español 🇪🇸</a> •
    <a href="#português-">Português 🇧🇷</a>
  </p>
</div>

---

<h2 id="english-">🇬🇧 English</h2>

### 🛠️ What does this script do?
This lightweight script acts as a **secure communication bridge** between your FiveM server and your X64HUB cloud dashboard. It handles:
- **Synchronization:** Active players, playtime, and real-time statistics.
- **Automatic Whitelist:** Queries the AI Whitelist status instantly when a player attempts to connect.
- **Sanctions:** Validates bans and kicks in real time.
- **Anticheat:** Alerts about potential cheaters by detecting prohibited explosions or abnormal damage, sending critical logs to your dashboard.

### ⚙️ Installation & Configuration
1. Download the latest `.zip` release or run `git clone`.
2. Extract and move the `x64-hub` folder to your FiveM `resources` folder.
3. Open the `config.lua` file and configure your credentials:
   ```lua
   Config.ServerId = "YOUR_SERVER_ID" 
   Config.WebhookSecret = "YOUR_WEBHOOK_SECRET" 
   ```
   *(You can find both in the "Settings -> Connections" menu of your X64HUB web dashboard).*
4. Add `ensure x64-hub` to your `server.cfg` file.
5. That's it! Start your server and X64HUB will sync automatically.

### 🔒 Security & Performance
This resource **does not use heavy local SQL queries or intrusive obfuscation**. All role validation, AI decision-making, and economy control are executed on our high-performance cloud infrastructure. This guarantees a 0.00ms impact (lag) on your FiveM server's main thread!

### 📜 License & Transparency
This script is **100% Open Source**. As server creators ourselves, we know trust is key. Feel free to read the entire code to ensure there are no backdoors or strange injections. Your security is our priority.

---

<h2 id="español-">🇪🇸 Español</h2>

### 🛠️ ¿Qué hace este script?
Este script ligero actúa como un **puente de comunicación seguro** entre tu servidor de FiveM y tu panel en la nube de X64HUB. Se encarga de:
- **Sincronización:** Jugadores activos, horas jugadas y estadísticas en tiempo real.
- **Whitelist Automática:** Consulta el estado de la Whitelist IA al instante cuando un jugador intenta conectarse.
- **Sanciones:** Valida baneos y expulsiones en tiempo real.
- **Anticheat:** Alerta sobre posibles tramposos detectando explosiones prohibidas o daños anormales, enviando logs críticos a tu panel.

### ⚙️ Instalación y Configuración
1. Descarga la última versión en formato `.zip` desde la pestaña de *Releases* (o haz `git clone`).
2. Descomprime y mueve la carpeta `x64-hub` a la carpeta `resources` de tu servidor FiveM.
3. Abre el archivo `config.lua` y configura tus credenciales:
   ```lua
   Config.ServerId = "TU_SERVER_ID" 
   Config.WebhookSecret = "TU_WEBHOOK_SECRET" 
   ```
   *(Ambos datos los encontrarás en el menú "Configuración -> Conexiones" de tu panel web de X64HUB).*
4. Añade `ensure x64-hub` en tu archivo `server.cfg`.
5. ¡Listo! Inicia tu servidor y X64HUB se sincronizará automáticamente.

### 🔒 Seguridad y Rendimiento
Este recurso **no utiliza consultas SQL locales pesadas ni ofuscación intrusiva**. Toda la validación de roles, la toma de decisiones de la IA y el control de la economía se ejecuta en nuestra infraestructura en la nube de alto rendimiento. ¡Garantizando 0.00ms de impacto (lag) en el hilo principal de tu servidor de FiveM!

### 📜 Licencia y Transparencia
Este script es **100% Open Source**. Como creadores de servidores, sabemos que la confianza es clave. Siéntete libre de leer todo el código para comprobar que no existen *backdoors* ni inyecciones raras. Tu seguridad es nuestra prioridad.

---

<h2 id="português-">🇧🇷 Português</h2>

### 🛠️ O que este script faz?
Este script leve atua como uma **ponte de comunicação segura** entre o seu servidor FiveM e o seu painel na nuvem X64HUB. Ele é responsável por:
- **Sincronização:** Jogadores ativos, horas jogadas e estatísticas em tempo real.
- **Whitelist Automática:** Consulta o status da Whitelist IA instantaneamente quando um jogador tenta se conectar.
- **Punições:** Valida banimentos e expulsões em tempo real.
- **Anticheat:** Alerta sobre possíveis trapaceiros detectando explosões proibidas ou danos anormais, enviando logs críticos para o seu painel.

### ⚙️ Instalação e Configuração
1. Baixe a versão mais recente em formato `.zip` na aba de *Releases* (ou faça `git clone`).
2. Extraia e mova a pasta `x64-hub` para a pasta `resources` do seu servidor FiveM.
3. Abra o arquivo `config.lua` e configure suas credenciais:
   ```lua
   Config.ServerId = "SEU_SERVER_ID" 
   Config.WebhookSecret = "SEU_WEBHOOK_SECRET" 
   ```
   *(Você encontrará ambos os dados no menu "Configurações -> Conexões" do seu painel web X64HUB).*
4. Adicione `ensure x64-hub` ao seu arquivo `server.cfg`.
5. Pronto! Inicie o seu servidor e o X64HUB será sincronizado automaticamente.

### 🔒 Segurança e Desempenho
Este recurso **não utiliza consultas SQL locais pesadas ou ofuscação intrusiva**. Toda a validação de cargos, a tomada de decisões da IA e o controle da economia são executados em nossa infraestrutura na nuvem de alto desempenho. Isso garante 0.00ms de impacto (lag) na thread principal do seu servidor FiveM!

### 📜 Licença e Transparência
Este script é **100% Open Source**. Como criadores de servidores, sabemos que a confiança é fundamental. Sinta-se à vontade para ler todo o código para garantir que não existam *backdoors* ou injeções estranhas. A sua segurança é a nossa prioridade.
