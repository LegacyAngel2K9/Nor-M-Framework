# 🚀 Nor-M Framework  
**A Custom Lua-based FiveM Framework**  
Developed by **Legacy DEV Team**  

## 🌐 Project Information  
- **Website:** [https://legacyh.dev](https://legacyh.dev)  
- **Support:** [https://discord.legacyh.dev](https://discord.legacyh.dev)  
- **GitHub:** [Nor-M Framework Repository](https://github.com/LegacyAngel2K9/Nor-M-Framework)  
- **Issue Tracker:** [Report Issues](https://github.com/LegacyAngel2K9/Nor-M-Framework/issues)  

---

## 📌 Features  
✅ **Fully Custom Lua-Based Framework**  
✅ **Custom UI for Menus & HUD**  
✅ **Police & EMS Systems**  
✅ **Vehicle Controls**  
✅ **Admin Tools**  
✅ **Chat Commands**  
✅ **Anti-Cheat Protection**  
✅ **Integrated Database**  

---

## 🔧 Installation Guide  

### 📥 1. Download & Extract  
1. Download the framework from **GitHub** or obtain the **ZIP file**.  
2. Extract the files into your **FiveM resources folder**.  

---

### 🛠 2. Configure Database  
1. Ensure **oxmysql** is installed on your server.  
2. Import `norm.sql` into your database
3. Configure your **database settings** in `config/config.lua`:

```lua
Config.Database = {
    UseMySQL = true,
    Host = "localhost",
    Username = "root",
    Password = "password",
    DatabaseName = "norm_framework",
    Port = 3306
}
```

---

### ⚙️ 3. Start the Resource  
1. Add the following line to your `server.cfg`:

```cfg
ensure NorM
```

2. Restart your server and check for any errors.  

---

### 🛠 4. Available Commands  

#### 🎮 **Player Commands**
| Command | Description |
|---------|-------------|
| `/me <message>` | In-character action |
| `/do <message>` | In-character description |
| `/ooc <message>` | Out-of-character chat |
| `/911 <message>` | Call emergency services |
| `/911r <message>` | Respond to 911 calls (Police Only) |

#### 🚔 **Police & EMS Commands**
| Command | Description |
|---------|-------------|
| `/pduty` | Toggle police duty |
| `/emsduty` | Toggle EMS duty |
| `/cuff <id>` | Cuff a player |
| `/uncuff <id>` | Uncuff a player |
| `/jail <id> <time>` | Send a player to jail |
| `/release <id>` | Release a player from jail |
| `/revive <id>` | Revive a player (EMS) |
| `/heal <id>` | Heal a player (EMS) |

#### ⚡ **Vehicle Commands**
| Command | Description |
|---------|-------------|
| `/engine` | Start/stop vehicle engine |
| `/lock` | Lock/unlock vehicle |
| `/cruise` | Toggle cruise control |
| `B Key` | Toggle seatbelt |

#### 🛠 **Admin Commands**
| Command | Description |
|---------|-------------|
| `/arevive <id>` | Revive a player |
| `/aheal <id>` | Heal a player |
| `/asetjob <id> <job>` | Set player job |
| `/goto <id>` | Teleport to player |
| `/bring <id>` | Teleport player to you |
| `/akick <id> <reason>` | Kick a player |
| `/aban <id> <reason>` | Ban a player |
| `/announce <message>` | Global announcement |

---

## 🛠 Known Issues & Support  
If you encounter issues, check the **F8 console logs** for errors.  

- Open a **GitHub Issue**: [Report Issues](https://github.com/LegacyAngel2K9/Nor-M-Framework/issues)  
- Join our **Discord** for support: [Support Discord](https://discord.legacyh.dev)  

---

## 🚀 Contributing  
Want to contribute to the project? Feel free to **fork** the repo, create a new branch, and submit a **pull request**!  

---

### 📜 License  
This project is licensed under the **MIT License**. You are free to modify and distribute it with proper credit to the **Legacy DEV Team**.  

---

🎮 **Enjoy the Nor-M Framework!** 🚀  
Developed with ❤️ by **Legacy DEV Team**  