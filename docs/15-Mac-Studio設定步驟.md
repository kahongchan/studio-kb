# 15 Mac Studio 設定步驟

> **2026-11-05 更新：每個階段加了「實際進度」（2026-11-05 Claude Code 在 `billychan` 唯讀實測，及 `openclaw-to-hermes` 有日期的紀錄）。** 狀態：✅ 完成、⬜ 未完成、↗ 改由 `openclaw-to-hermes` 處理、⏸ 暫停、❓ 未核實。原本的步驟保留不刪。
> 實際情況：orchestrator 是 Agent Orchestrator（AO），不是 Python 腳本；工具暫時都在 `billychan` 帳戶，`factory` 未啟用；手機遙控已由 VPS 上的 Hermes `studio-admin` 經 ao-bridge 做到。第 4、5 階段以 Python orchestrator、`remote-desk`、Channels 為前提的步驟暫停使用。
> 基建的即時狀態和操作紀錄以 `kahongchan/openclaw-to-hermes` 為準（`docs/LIVE-STATE.md`、`docs/08-MacStudio-Setup-and-Git-Sync.md`）。

> 2026-11-03 Mac Studio 到手。腳本在 `mac-setup/`；先讀腳本再執行。
> 原則：每一階段達到「完成標準」才做下一階段。公司的 `corp` 用戶等公司同意後才建立（待決 #16）。

## 最重要的期限：退貨期 14 日
Apple 新加坡的標準退貨期是收貨日起 **14 日**，要有收據、原裝配件和包裝。所以**第三階段（實測）一定要在第 12 日前完成**，用實測結果決定留下 M5 Max 128GB，還是退貨改買 M5 Ultra 256GB。包裝盒先不要丟。

| 階段 | 做甚麼 | 時間 | 期限 |
|---|---|---|---|
| 0 | 開機、網絡、電源、遙距連線 | 1～2 小時 | 第 1 日 |
| 1 | 建立用戶、安裝工具 | 約 1 小時 | 第 1～2 日 |
| 2 | 帳戶：GitHub、Claude、Codex、知識庫 | 約 1 小時 | 第 2 日 |
| 3 | **退貨期內實測** | 分幾晚，合共約 3～4 小時 | **第 12 日前** |
| 4 | orchestrator 模擬 → 真實運行 → Unity 專案 | 2～3 小時 | 實測之後 |
| 5 | 手機遙控（Discord、Remote Control）、升級 Max 5x | 約 1 小時 | 第 4 階段穩定後 |
| 6 | 之後才做：多引擎 orchestrator、Hermes/VPS、公司用戶 | — | 不急 |

---

## 第 0 階段：開機、網絡、電源、遙距連線

**實際進度（2026-11-05）**
- ✅ 管理員帳戶：實際是 `billychan`（不是 `billy`），而且暫時用它跑全部工具（02 2026-11-05，本人 2026-11-03 決定）。
- ✅ FileVault：On（`fdesetup status`）。
- ❓ 軟件更新設定、有線網絡、DHCP 保留：未核實。
- ⬜ 電腦名稱：仍是預設名稱，不是 `studio`。
- ↗ 遠端登入、螢幕共享：2026-11-02 未開啟（[openclaw-to-hermes 08](https://github.com/kahongchan/openclaw-to-hermes/blob/main/docs/08-MacStudio-Setup-and-Git-Sync.md)）；這次未重查。
- ✅ 電源：`sleep 0`、`autorestart 1`（`pmset -g custom`）；網絡喚醒未核實。
- ❓ HDMI 假負載、UPS：未核實。
- ↗ Tailscale：已安裝，Studio ↔ VPS 已連通（[LIVE-STATE](https://github.com/kahongchan/openclaw-to-hermes/blob/main/docs/LIVE-STATE.md) 2026-11-02、11-03）；完成標準（MacBook 經外網 SSH 和螢幕共享）未完成。
1. **建立管理員帳戶**（開機設定時建立的第一個帳戶）：例如 `billy`。這個帳戶只做管理，不跑 agent。
   - Apple ID：可以在這個帳戶登入個人 Apple ID（用於「尋找」和軟件更新）；`factory` 不登入 Apple ID。
2. **FileVault：開啟。** 復原密鑰抄下或存入密碼管理器，**不要**存入 `studio-kb`。
3. **軟件更新**到最新的 macOS 26.x。然後 系統設定 → 一般 → 軟件更新 → 自動更新：只開「下載」和「安全回應」，**關閉自動安裝 macOS 更新**，避免半夜自動重開機。
4. **網絡：** 用有線 Ethernet。在路由器設定 DHCP 保留，固定 Mac Studio 的內網 IP。電腦名稱改為 `studio`（系統設定 → 一般 → 關於本機）。
5. **共享**（系統設定 → 一般 → 共享）：
   - 開啟「遠端登入」（SSH），只允許管理員和 `factory`（第 1 階段建立後再加）。
   - 開啟「螢幕共享」。
   - 其他共享項目全部關閉。
6. **電源：** 執行 `bash mac-setup/01-power.sh`（不睡眠、停電後自動開機、網絡喚醒）。
7. **硬件：** 插上 HDMI 假負載插頭（無螢幕時螢幕共享才有正常解像度）；UPS 用 USB 連接，macOS 會在電池低時自動關機。
8. **Tailscale：** 在 Tailscale 網站下載 **Standalone** 版本（不是 App Store 版），用管理員帳戶登入你的 Tailnet。開啟 MagicDNS。
   - 限制：Standalone 版要有用戶登入 macOS 才會連線。重開機後怎樣處理，見本文最後「停電和重開機」。

**完成標準：** MacBook 用手機熱點（即不在家中網絡）經 Tailscale 可以 `ssh billy@studio` 和螢幕共享。

---

## 第 1 階段：建立用戶、安裝工具

**實際進度（2026-11-05）**
- ⏸ `factory`：2026-11-03 已建立（標準帳戶），但未啟用；工具留在 `billychan`，搬遷是 02 待決 #21（[openclaw-to-hermes 08](https://github.com/kahongchan/openclaw-to-hermes/blob/main/docs/08-MacStudio-Setup-and-Git-Sync.md)）。
- 部分 ✅ Homebrew 已安裝；Brewfile 中已有 gh、jq、node、uv；**未有** git-lfs、gitleaks、tmux、bun、macmon、LM Studio。
- ✅ Claude Code 2.1.318、Codex CLI 0.166.0（都在 `billychan`）；⬜ Aider 未安裝。
- ⬜ `autoUpdatesChannel`：`~/.claude/settings.json` 沒有這一項（24 小時無人運行前才需要）。
- ❓ `03-verify.sh`：這次未執行。
1. **建立 `factory` 用戶**（一般用戶，不是管理員）：
   ```bash
   bash mac-setup/02-create-user.sh factory "Factory"
   ```
   腳本同時把 home 設為 `chmod 700`。macOS 預設的 home 頂層，同一部機的其他用戶可以讀，放在 `~/studio` 的檔案會被看到，所以要改。管理員自己的 home 也執行一次：`chmod 700 ~`。
2. **Homebrew**（只在管理員帳戶安裝，`factory` 只用不裝）：到 brew.sh 安裝，然後：
   ```bash
   brew bundle --file=mac-setup/Brewfile
   ```
   包括 git、git-lfs、gh、gitleaks、tmux、jq、node、uv、bun、macmon、LM Studio。
3. **切換到 `factory`**（快速用戶切換，或 `ssh factory@studio`），安裝個人用的工具：
   ```bash
   # Claude Code（官方原生安裝，自動更新）
   curl -fsSL https://claude.ai/install.sh | bash
   # Codex CLI（官方安裝）
   curl -fsSL https://chatgpt.com/codex/install.sh | sh
   # Aider（寫碼工人）
   uv tool install --python 3.12 aider-chat
   git config --global core.quotepath false
   git lfs install
   ```
4. **24 小時工廠用 Claude Code 穩定版：** 在 `factory` 的 `~/.claude/settings.json` 加入 `"autoUpdatesChannel": "stable"`（落後最新版約一星期，略過有重大問題的版本）。
5. 執行檢查：`bash mac-setup/03-verify.sh`

**完成標準：** `03-verify.sh` 沒有紅色項目；`factory` 讀不到 `/Users/billy` 的內容。

---

## 第 2 階段：帳戶和知識庫

**實際進度（2026-11-05）**
- ✅ `studio-kb` 私人 repo 已建立；❓ GitHub Pro 未核實；⬜ `main` 沒有 branch protection 或 ruleset（`gh api` 2026-11-05）。
- ⏸ GitHub 機器帳戶：延後到搬去 `factory`（02 2026-11-05）。在 `billychan` 由本人互動時直接用 `kahongchan`。
- ✅ `gh` active 已改為 `kahongchan`（2026-11-05）；⚠️ 公司帳戶仍登入（待決 #16）。
- ✅ Claude：claude.ai 登入、Pro。✅ `ANTHROPIC_API_KEY`、`OPENAI_API_KEY` 都沒有設定。✅ Codex：用 ChatGPT 登入。
- ✅ 知識庫：改用 HTTPS 加 `gh`，clone 到 `~/Projects/studio-kb`（不是 `~/studio`，不用 SSH）；push 經 `scripts/gh-personal.sh`。⬜ `install-hooks.sh` 未執行（gitleaks 未安裝）。
- ⬜ 完成標準（`claude -p` 和 `codex exec` 讀 AGENTS.md 測試）：未做。
全部用**個人**帳戶。公司帳戶不在這部機登入（直至公司同意並建立 `corp`）。

**GitHub（在 MacBook 私人用戶或網頁做）**
1. 升級 GitHub Pro（每月 US$4），私人 repo 才有 branch protection。
2. 建立空白私人 repo `studio-kb`。把名稱告訴 Claude 推上去，或照 `SETUP.md` 第 0 步自己推。
3. `main` 加規則：Require a pull request before merging。
4. 開 GitHub 機器帳戶（要另一個電郵），邀請為 `studio-kb` 的協作者。
5. 在 `factory` 為機器帳戶產生 SSH key（`ssh-keygen -t ed25519 -C factory@studio`），公鑰加到**機器帳戶**（不是你的個人帳戶）。

**AI 登入（在 `factory`）**
1. `claude` → 用個人 Claude 帳戶登入。現在用 Pro 可以；第 5 階段開始 24 小時運行時才升級 Max 5x。
2. 確認沒有設定 `ANTHROPIC_API_KEY`：`echo $ANTHROPIC_API_KEY` 應該是空的。
3. `codex` → Sign in with ChatGPT（個人帳戶）。

**知識庫**
```bash
mkdir -p ~/studio && cd ~/studio
git clone git@github.com:kahongchan/studio-kb.git
cd studio-kb && bash scripts/install-hooks.sh
```
然後照 `SETUP.md` 第 1 步，連接 Claude Project 和 ChatGPT。

**完成標準：** 在 `~/studio/studio-kb` 執行 `claude -p "讀 AGENTS.md，用一句話講出這個 repo 的修改規則"`，答案提到「開 PR、由擁有者合併」；`codex exec "讀 AGENTS.md，講出紅線第一條"` 答得出。

---

## 第 3 階段：退貨期內實測（第 12 日前完成）

**實際進度（2026-11-05）**
- ⬜ 未開始：LM Studio、macmon、Aider 都未安裝，T1～T5 未做。2026-11-03 收貨，按「第 12 日前」計是 **2026-11-14 或之前**（以收據日期為準）。
- ✅ Unity Editor 已安裝 Unity 6（6000.6.7f1）和 2017.4.40f1，T2 的 Unity 部分可以做。
目的：用真實工作量確認 128GB 夠用。這是 03 的「收貨後在退貨期內測試」。

1. **在管理員帳戶開 LM Studio**，下載三個模型（MLX 4-bit）：Qwen3.8-27B、Qwen3-Coder-Next 80B-A3B、gpt-oss-120b。Server 只綁 `127.0.0.1`，context 設 64K（Hermes 和長任務要 64K）。
2. 每項測試開著 `macmon`，記錄記憶體壓力（活動監視器的「記憶體壓力」圖）和 swap：

| # | 測試 | 記錄 | 結果 |
|---|---|---|---|
| T1 | 每個模型：64K context 下的生成速度（tok/s）和佔用記憶體 | tok/s、GB | |
| T2 | Qwen3-Coder-Next + Unity 編輯器開著一個 3D 場景 + Blender 渲染 | 記憶體壓力顏色、swap GB | |
| T3 | T2 + 一個圖像模型（Qwen-Image 或 FLUX，在 Draw Things）同時出圖 | 會否 swap、會否卡死 | |
| T4 | 連續兩小時高負載：溫度、風扇聲、有沒有降速 | 溫度、tok/s 前後對比 | |
| T5 | 用 Aider + 本地模型完成一個真實小任務（例如在測試 repo 加一個有單元測試的函數） | 是否一次成功、耗時 | |

3. 如果某個模型載入失敗，提示 GPU 記憶體不足，可以調高上限（重開機會還原）：`sudo sysctl iogpu.wired_limit_mb=110000`（留約 18GB 給系統）。

**判斷：**
- T2 綠色或黃色，T3 只有短暫 swap → **留下 128GB**。
- T2 已經紅色或大量 swap，而你又確定要同時常駐多個模型 → 考慮退貨改買 M5 Ultra 256GB（決定前和 Claude、ChatGPT 對一次數據）。

**完成標準：** 上表填好，決定寫入 `02-決策記錄`。

---

## 第 4 階段：orchestrator 和第一個專案

**實際進度（2026-11-05）**
- ⏸ 第 1～3 步（Python `claude-local-orchestrator`、`config.toml`）：**暫停，待按 AO 和 Hermes 改寫**。實際的 orchestrator 是 AO 0.14.8（`ao status --json`：ready、health ok），見 04 第四部分。
- ↗ AO 和 Hermes 的接入：由 `openclaw-to-hermes` 處理，見 [ao-bridge README](https://github.com/kahongchan/openclaw-to-hermes/blob/main/hermes-staging/ao-bridge/README.md)（2026-11-04 驗收）。
- 部分 ✅ 第 4 步：Unity 6 Editor 已安裝（在 `billychan`）；⬜ `sotg-remake` repo 未建立。
- ⬜ 第 5 步和完成標準：未開始。
1. 把 `claude-local-orchestrator` 放入新的**私人** repo（例如 `studio-orchestrator`），clone 到 `~/studio/`。
2. **模擬運行：** 用工具包內的模擬 Claude 和模擬本地 agent 跑一次（之前已測試過），確認在 Mac 上一樣可以跑。
3. **真實運行（測試 repo）：** 建立一個小 Python repo，`plan "加一個計算傷害的函數和單元測試"` → `run-once`。看清楚每一步：Claude 規劃、Aider 用本地模型寫、測試、Claude 審查。
   - 檢查 `config.toml` 的 Aider 參數（`aider --help`），指向 LM Studio 的 `http://127.0.0.1:1234/v1`。
4. **Unity：** 在 `factory` 安裝 Unity Hub 和 Unity 6 LTS，建立 `sotg-remake` 私人 repo（Git LFS）。`AGENTS.md` 寫明背景見 `../studio-kb`，`CLAUDE.md` 第一行 `@AGENTS.md`。
5. 第一個真正的 plan：「建立測試框架」（07 第九部分的建議）。

**完成標準：** 真實運行完成三個任務，全部合併到 `develop`，你在 GitHub 批准了第一個 `develop → main` PR。

---

## 第 5 階段：手機遙控

**實際進度（2026-11-05）**
- ⏸ 第 3～6 步（Channels、`remote-desk`、`start-sessions.sh`、orchestrator 通知）：**暫停，待按 AO 和 Hermes 改寫**。
- ↗ 手機遙控已由 VPS 上的 Hermes `studio-admin`（Discord）經 ao-bridge 做到（[LIVE-STATE](https://github.com/kahongchan/openclaw-to-hermes/blob/main/docs/LIVE-STATE.md) 2026-11-03、11-04）。要不要再加 Channels 見 02 待決 #22。
- ⬜ 第 1 步：仍是 Pro，未升級 Max 5x（02 待決 #23）。❓ 第 2、4 步未核實。
1. **升級 Claude Max 5x**（開始 24 小時運行）。升級滿 7 日後，在 claude.ai Settings → Billing 連結一個 Console 組織，領取每月 US$100 API credit（暫時不用，留作後備，見待決 #12）。
2. **Account 頁開啟「Require trusted devices」**，只有你信任的裝置可以連接 Remote Control。
3. **Discord（官方 Channels）：**
   1. 開一個只有你的私人 Discord 伺服器。
   2. Discord Developer Portal → New Application → Bot → Reset Token（複製）→ 開啟 Message Content Intent。
   3. OAuth2 → URL Generator：`bot` scope，權限 View Channels、Send Messages、Send Messages in Threads、Read Message History、Attach Files、Add Reactions，把 bot 邀請入伺服器。
   4. 在 `factory` 複製遙控台資料夾：`cp -R ~/studio/studio-kb/mac-setup/remote-desk ~/studio/remote-desk && chmod +x ~/studio/remote-desk/desk`。這個 session 只可以執行 `./desk status` 和 `./desk plan "…"`，不可以改檔案、不可以用 git。先在終端機試 `./desk status`，確認 orchestrator 的路徑正確。
   5. 在 `remote-desk` 執行 `claude`，輸入 `/plugin install discord@claude-plugins-official`（選 user scope），再 `/discord:configure <token>`。
   6. 離開，再用 `claude --channels plugin:discord@claude-plugins-official` 啟動。在 Discord DM 你的 bot，收到配對碼後在 Claude Code 輸入 `/discord:access pair <碼>`，然後 `/discord:access policy allowlist`。
4. **Remote Control（伺服器模式）：** 在 `~/studio/sotg-remake` 執行一次 `claude remote-control --spawn worktree`，回答信任和啟用的問題（第一次一定要在終端機回答）。每個手機開的 session 有自己的 git worktree，不會互相改壞。
5. **開機自動啟動：** 照 `mac-setup/start-sessions.sh` 的說明，安裝 LaunchAgent。`factory` 登入時自動開三個 tmux 視窗：`rc`（Remote Control）、`desk`（Discord）、`orch`（orchestrator loop）。
6. **通知：** orchestrator 設定 ntfy 或 Discord webhook（完成、卡住、額度用完）。

**完成標準：** 你在外面用手機 Discord 傳「狀態」，收到 orchestrator 的狀態；傳「plan：……」，任務出現在佇列；用 Claude app 經 Remote Control 開一個 session 看到 repo。

---

## 第 6 階段：之後才做

**實際進度（2026-11-05）**
- ↗ VPS 和 Hermes：已提早做，由 `openclaw-to-hermes` 維護。
- ⏸ 多引擎 orchestrator：改由 AO 處理（04 第十四部分）。
- ⬜ `corp` 用戶、Time Machine、外置 SSD：未做或未核實。
- **多引擎 orchestrator**（加入 Codex：第一輪審查、第二層寫手、補測試，見 04 第十四部分）。可以叫 Claude 寫這部分程式碼。
- **VPS 重置和 Hermes：** 只有在 Channels 不夠用時才做（例如想 Mac Studio 當機時仍收到訊息）。
- **`corp` 用戶：** 公司同意後，用 `02-create-user.sh corp "Corp"` 建立，照 04 第十二部分設定。
- **Time Machine** 備份到外置硬碟；外置 Thunderbolt 5 SSD 放模型和大型素材。

---

## 停電和重開機（FileVault 開啟時）
- UPS 撐過短時間停電；長時間停電，macOS 會在 UPS 電量低時關機，來電後自動開機（第 0 階段設定）。
- 開機後停在 FileVault 解鎖畫面。**macOS 26 可以用 SSH 解鎖 FileVault**（遠端登入要開啟），但這時 Tailscale 還未運行，只能從**同一個家中網絡**連入；有用戶回報 Wi-Fi 不穩定，有線網絡才可靠。
- 解鎖後：螢幕共享登入管理員（Tailscale 開始運行）→ 快速用戶切換登入 `factory`（Keychain 解鎖，LaunchAgent 啟動三個 tmux 視窗）→ 切回管理員。
- **人不在家時：** 在家中另放一部長開的小裝置（例如 Apple TV、Raspberry Pi 或支援 Tailscale 的路由器）做 Tailscale subnet router，就可以從外面連到 Mac Studio 的內網 IP 做 SSH 解鎖。未有這部裝置之前，長時間停電後要等你回家處理。**要實測。**
- 不建議為了方便而關閉 FileVault：之後 `corp` 會有公司程式碼。
