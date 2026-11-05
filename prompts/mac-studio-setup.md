# Mac Studio 設定 prompts

> 2026-11-05 改寫：按 Mac Studio 的實際情況，即 `billychan` 帳戶、Agent Orchestrator（AO）、Codex 維護基建。
> 分工見 `docs/02-決策記錄.md` 2026-11-05：基建由 Codex 在 `openclaw-to-hermes` 做；`studio-kb` 由 Claude Code 做；AO 只派開發任務。
> 這些 prompts 都在互動 session 貼上，不要經 AO 或 Hermes 派工。

| 次序 | 用甚麼 | 在哪個資料夾 | 做甚麼 | 會不會改東西 |
|---|---|---|---|---|
| P0 ✅ | Claude Code | `~/Projects` | 把 studio-kb 加進 Mac Studio，對照實際狀態報告差異 | 只 clone |
| P1 | Codex | `openclaw-to-hermes` | 維運 repo 加入和 studio-kb 的分工說明 | 只改該 repo 的 AGENTS、README |
| P2 ✅ | Claude Code | `~/Projects/studio-kb` | 按 P0 的報告更新 studio-kb，開 PR | 開分支和 PR，你合併 |
| P5 | Codex | `openclaw-to-hermes` | **退貨期內實測 T1～T5（2026-11-14 前）** | 安裝 macmon、LM Studio、Blender、Aider、mflux，下載三個模型；結果開 PR |
| P3 | Codex | `openclaw-to-hermes` | （之後）把 studio-kb 和遊戲 repo 註冊到 AO、加入 bridge allowlist | 改 AO 和 bridge 設定，要你批准 |

---

## P0 之前：你自己在終端機處理 GitHub 帳戶（約 2 分鐘）

> **✅ 已完成（2026-11-05）：** active 已改為 `kahongchan`。公司帳戶仍登入，見 `docs/02` 待決 #16。

2026-11-05 發現：`billychan` 的 `gh` 同時登入了公司帳戶和 `kahongchan`，而 active 的是公司帳戶。AO 和 agent 都在 `billychan` 下運行，預設會用到公司帳戶。

```bash
gh auth status                                                      # 看清楚兩個帳戶
gh auth switch --hostname github.com --user kahongchan              # 預設改為個人帳戶
gh auth logout --hostname github.com --user <公司帳戶名稱>           # 建議：公司帳戶離開 Mac Studio
gh auth status                                                      # 確認只剩 kahongchan，或 kahongchan 是 active
```
- 建議登出公司帳戶：公司同意之前，公司帳戶不放上 Mac Studio（待決 #16）。日後公司同意，就在獨立的 `corp` macOS 用戶登入。
- 如果現在 Mac Studio 上有公司工作正在用這個帳戶，可以暫時只做 `switch`，不做 `logout`，但要盡快搬到 `corp`。
- 不用理 `ssh -T git@github.com` 的 host key 錯誤：這部機的 GitHub 一律用 HTTPS 加 `gh`，和 `openclaw-to-hermes` 一樣。

---

## P0：把 studio-kb 加進 Mac Studio（Claude Code，在 `~/Projects`）

> **✅ 已完成（2026-11-05），不要重跑。** 和 P2 合併成一段 prompt 執行；結果見 PR #4、`docs/02` 背景事實和 `docs/15` 各階段「實際進度」。

```text
你在我的 Mac Studio，macOS 帳戶 billychan（我 2026-11-03 決定暫時沿用這個帳戶，不要求改用 factory）。任務：把我的知識庫 kahongchan/studio-kb 加進這部機，然後對照這部機的實際狀態報告差異。除了 clone 和設定這個 repo 的 git 身份，不要修改任何東西：不用 sudo，不安裝軟件，不改系統、gh 帳戶、AO、Hermes 或 ao-bridge 設定，不 commit，不 push。GitHub 一律用 HTTPS 加 gh，不用 SSH。

1. GitHub 身份：執行 `gh auth status`，報告有哪些帳戶、哪個是 active（不要顯示 token）。這個 repo 只可以用個人帳戶 kahongchan，現階段由我本人互動使用，不需要機器帳戶。
   - active 是 kahongchan：繼續。
   - active 是公司帳戶：停下來，叫我先照 prompts/mac-studio-setup.md「P0 之前」處理。
   - 公司帳戶有登入但不是 active：繼續，但不可以用它做任何事，並在報告中列為風險。
2. clone：只在這個指令的程序用 kahongchan，不改全機設定：
   cd ~/Projects && GH_TOKEN="$(gh auth token --hostname github.com --user kahongchan)" GH_HOST=github.com gh repo clone kahongchan/studio-kb
   如果 ~/Projects/studio-kb 已經存在，只執行 git fetch 並報告狀態。然後在這個 repo 設定 repo-local 的 user.name 和 user.email，用和 openclaw-to-hermes 工作副本相同的 kahongchan noreply 身份（從它的 repo-local git config 讀取）。
   之後在這個 repo push 或開 PR，一律經 scripts/gh-personal.sh 執行（例如 bash scripts/gh-personal.sh git push），不要依賴全機的 gh 預設帳戶。
3. 讀 studio-kb 的 AGENTS.md、docs/02-決策記錄.md、docs/04-AI分工與自動化架構.md、docs/15-Mac-Studio設定步驟.md；再讀 openclaw-to-hermes 的 AGENTS.md、docs/LIVE-STATE.md、docs/08-MacStudio-Setup-and-Git-Sync.md、docs/09-Studio-Claude-Multi-Account-Plan.md、hermes-staging/ao-bridge/README.md。
4. 執行唯讀檢查：claude --version、claude auth status（只答登入方式和方案，不顯示電郵以外的識別資料）、codex --version、AO 的 `ao status --json`（只摘要健康狀態）、echo 檢查 ANTHROPIC_API_KEY 和 OPENAI_API_KEY 有沒有設定（只答有或沒有）、pmset -g custom 的 sleep 和 autorestart、fdesetup status。
5. 用表格報告：
   a. studio-kb 哪些內容和這部機的實際狀態不符，每項寫明 studio-kb 的檔案和章節、實際情況、證據來源（指令輸出或 openclaw-to-hermes 的檔案和日期）。
   b. 兩個 repo 有沒有互相矛盾的紅線或決定。
   c. 建議 studio-kb 應該怎樣改，只列出，不要改。
6. 檢查 gitleaks 有沒有安裝；沒有就告訴我，不要安裝，暫時不執行 scripts/install-hooks.sh。

不要在回覆中顯示任何 token、密碼、IP、序號或 bearer token 的位置內容。
```

---

## P1：維運 repo 加入分工說明（Codex，在 `openclaw-to-hermes` 工作副本）

```text
先照 AGENTS.md 執行 preflight（python3 hermes-staging/sync_before_work.py --personal-github），exit 3 就重讀指令再跑。

任務：在這個維運 repo 寫明和 kahongchan/studio-kb 的分工，只改文件，不改任何系統、VPS、Hermes、AO 或 bridge 設定。
1. AGENTS.md 加一小段「與 studio-kb 的分工」，README 加一行連結：
   - 本 repo（Codex 維護）：VPS、Hermes、ao-bridge、Mac Studio 系統和 AO 的即時狀態、操作紀錄、回復步驟。
   - studio-kb（Claude Code 維護，修改經 PR，本機工作副本 ~/Projects/studio-kb）：遊戲工作室的目標、決定、紅線、AI 分工、工具預算、遊戲設計。
   - 衝突時：系統即時狀態以本 repo 為準；遊戲和產品決定以 studio-kb 的 docs/02-決策記錄.md 為準；兩邊紅線取較嚴格的一方，並在兩邊記錄差異。
   - 兩邊只放連結，不複製內容。
2. 先給我看 diff，我確認後才照本 repo 的規則 commit 和 push。按 GOOGLE-DRIVE-SYNC 判斷這次是否需要發布（只改 AGENTS 和 README，預計不需要），並告訴我結果。
```

---

## P2：按實際情況更新 studio-kb（Claude Code，在 `~/Projects/studio-kb`）

> **✅ 已完成（2026-11-05，PR #4），不要重跑。** 日後 Mac Studio 有重大改變，可以照這段的做法再更新一次。

```text
照 AGENTS.md 的規則：開分支 kb/<今日日期>-studio-reality，不要改 main。根據你在 P0 的報告（如果這是新 session，先重做 P0 第 3 至 5 步，但不要再 clone）更新 studio-kb：

1. docs/02：背景事實的 Mac Studio 現況寫上 P0 實測的版本和設定（不寫 token、IP、序號）；P0 發現的紅線矛盾列入待決事項。
2. docs/04：
   - 第一、二、四部分：orchestrator 改為 Agent Orchestrator（AO）。AO 負責 session、worktree 和派工，可以開 Codex 和 Claude Code session。原本 Python 工具包的內容移到「歷史」小節，不要刪除。
   - 第八、十四部分：Hermes 的實際做法改為 studio-admin profile 加 ao-bridge 的 5 個工具（引用 openclaw-to-hermes 的 ao-bridge README，只放連結和摘要）。
   - 「Claude 規劃 → 本地模型寫 → Codex 初審 → Claude 終審 → 合併 develop」的流程在 AO 怎樣做，寫成待驗證的設計，不要寫成已實作。
3. docs/03：Mac Studio 實際配置為 M5 Max 128GB / 4TB。
4. docs/15：每個階段加「實際進度」，標明已完成、未完成、已改由 openclaw-to-hermes 處理（連結到它的文件）。第 4、5 階段中 Python orchestrator、remote-desk、Channels 的內容標為「暫停，待按 AO 和 Hermes 改寫」。
5. mac-setup/start-sessions.sh 和 mac-setup/remote-desk/：在檔頭註明「以 Python orchestrator 為前提，AO 不適用，暫停使用」，不要刪除。
6. docs/08 加入你在 P0 核實過的來源和日期。
7. commit（如果 gitleaks 已安裝，會在 commit 前自動檢查），然後用個人帳戶 push 和開 PR：
   bash scripts/gh-personal.sh git push -u origin <分支>
   bash scripts/gh-personal.sh gh pr create --base main --title "<標題>" --body "<改了甚麼、來源>"
   把 PR 連結給我。不要合併。
```

---

## P5：退貨期內實測 T1～T5（Codex，在 `openclaw-to-hermes` 工作副本）

> 2026-11-05 加入。**2026-11-14 前完成**（`docs/02` 待決 #18）。下載約 130GB，加上 T4 兩小時，建議晚上開始。
> 用 Codex：安裝工具和模型伺服器屬基建（`docs/02` 2026-11-05 的分工）；測試結果和建議另外寫入 studio-kb。

```text
先照本 repo 的 AGENTS.md 執行 preflight。

任務：Mac Studio 退貨期內的實測（studio-kb 的 docs/15「第 3 階段」T1～T5），結果用來決定留下 M5 Max 128GB 還是退貨，期限 2026-11-14。先讀 ~/Projects/studio-kb 的 docs/15-Mac-Studio設定步驟.md 第 3 階段、docs/03-硬件方案比較.md 第三、四部分、docs/05-模型與工具清單.md。

授權範圍（只限以下，全部在 billychan，不用 sudo）：
- 安裝：brew install macmon；brew install --cask lm-studio blender；uv tool install --python 3.12 aider-chat；uv tool install mflux（T3 出圖用）。
- 下載三個 MLX 4-bit 模型：Qwen3.8-27B、Qwen3-Coder-Next 80B-A3B、gpt-oss-120b。用 LM Studio 的 lms CLI 搜尋，優先選官方或 mlx-community 的版本；找不到完全相同的，選最接近的並報告實際的模型 ID 和大小。下載前先檢查可用空間。
- LM Studio 伺服器只綁 127.0.0.1，不可以開放給 Tailscale 或區域網絡；context 設 64K。
- 在 ~/Projects/bench/ 建立測試用的資料夾和 repo（不上 GitHub）。

不可以做：不改 AO、Hermes、ao-bridge、Tailscale、電源或系統設定；不經 AO 派工；不用公司帳戶。開始前用 ao status 確認沒有 AO session 正在工作，有就停下來問我。如果模型因 GPU 記憶體上限載入失敗，不要自行執行 sudo sysctl，停下來告訴我。

測試（每項都用 macmon 和 memory_pressure、sysctl vm.swapusage 記錄記憶體壓力和 swap）：
- T1：三個模型各自在 64K context 下的生成速度（tok/s）、prompt 處理速度、佔用記憶體。
- T2：Qwen3-Coder-Next 載入並持續生成，同時 Unity 6（6000.6.7f1）開一個新建的 3D URP 範例場景，Blender 用 CLI 背景渲染一個內建測試場景。
- T3：T2 再加 mflux 用 4-bit FLUX 模型出圖。
- T4：用背景腳本對 LM Studio 連續生成兩小時，每 5 分鐘記錄 tok/s、溫度、功耗，log 放 ~/Projects/bench/logs/；開始和結束各報告一次。
- T5：用 Aider 接 LM Studio（OpenAI 相容 API，127.0.0.1）在測試 repo 完成一個小任務：加一個 calc_damage(attack, defense, crit) 函數和三個 pytest 單元測試；記錄是否一次成功、耗時、改了幾次。

記錄：
1. 基建部分（安裝了甚麼、版本、路徑、LM Studio 伺服器綁定和設定、模型存放位置和大小、回復方法）照本 repo 的規則寫入 LIVE-STATE 和 MIGRATION-STATUS，照規則處理 Drive 發布。
2. 測試結果寫入 studio-kb：在 ~/Projects/studio-kb 開分支 kb/<日期>-phase3-bench，填好 docs/15 第 3 階段的表格（加「實測日期」），docs/03 加「實測結果」小節，docs/02 待決 #18 寫上你的建議（留下或退貨）和理由，理由要對照 docs/15 的判斷標準。用 bash scripts/gh-personal.sh git push 和 bash scripts/gh-personal.sh gh pr create 開 PR，不要合併。
3. 不要寫入任何 token、IP、序號。

最後報告（繁體中文）：T1～T5 結果表、你的建議和理由、裝了甚麼和怎樣移除、兩個 PR 或 commit 的連結。
```

---

## P3（之後）：把 studio-kb 和遊戲 repo 接入 AO 和 Hermes（Codex，在 `openclaw-to-hermes`）

等遊戲 repo（`sotg-remake`）建立後才做。大概內容：在 AO 註冊專案；把專案加入 ao-bridge 的 allowlist；更新 `studio-admin` 的 profile 說明；照該 repo 的「查看 → 備份 → 修改 → 驗證」流程做，並記錄回復步驟。到時再寫完整 prompt。

---

## P4（可選）：Codex 唯讀交叉檢查（在 `~/Projects/studio-kb` 的終端機）

```bash
codex exec "讀 AGENTS.md 和 docs/02-決策記錄.md，再讀 ~/Projects/openclaw-to-hermes 的 AGENTS.md。檢查兩個 repo 的紅線有沒有矛盾、studio-kb 有沒有密碼或 token、有沒有任何地方把 Claude 訂閱登入交給第三方工具。只報告，不要修改任何檔案。"
```
`codex exec` 預設唯讀，不會改檔案。如果 openclaw-to-hermes 不在 `~/Projects`，改成實際路徑。
