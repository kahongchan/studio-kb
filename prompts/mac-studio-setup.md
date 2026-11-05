# Mac Studio 設定 prompts

> 2026-11-05 改寫：按 Mac Studio 的實際情況，即 `billychan` 帳戶、Agent Orchestrator（AO）、Codex 維護基建。
> 分工見 `docs/02-決策記錄.md` 2026-11-05：基建由 Codex 在 `openclaw-to-hermes` 做；`studio-kb` 由 Claude Code 做；AO 只派開發任務。
> 這些 prompts 都在互動 session 貼上，不要經 AO 或 Hermes 派工。

| 次序 | 用甚麼 | 在哪個資料夾 | 做甚麼 | 會不會改東西 |
|---|---|---|---|---|
| P0 ✅ | Claude Code | `~/Projects` | 把 studio-kb 加進 Mac Studio，對照實際狀態報告差異 | 只 clone |
| P1 | Codex | `openclaw-to-hermes` | 維運 repo 加入和 studio-kb 的分工說明 | 只改該 repo 的 AGENTS、README |
| P2 ✅ | Claude Code | `~/Projects/studio-kb` | 按 P0 的報告更新 studio-kb，開 PR | 開分支和 PR，你合併 |
| P3 | Codex | `openclaw-to-hermes` | （之後）把 studio-kb 和遊戲 repo 註冊到 AO、加入 bridge allowlist | 改 AO 和 bridge 設定，要你批准 |
| P5 | Codex | `openclaw-to-hermes` | 本地模型實測：安裝 LM Studio、下載模型、量度速度（T1）、用 OpenCode 和 Codex 本地設定做小任務（T5） | 安裝軟件前先問你；結果寫入 `~/Projects/local-model-tests/RESULTS.md` |
| P6 | Claude Code | `~/Projects/studio-kb` | 把 P5 的結果填入 `docs/15` 的 T1～T5 表，開 PR | 開分支和 PR，你合併 |

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

## P3（之後）：把 studio-kb 和遊戲 repo 接入 AO 和 Hermes（Codex，在 `openclaw-to-hermes`）

等遊戲 repo（`sotg-remake`）建立後才做。大概內容：在 AO 註冊專案；把專案加入 ao-bridge 的 allowlist；更新 `studio-admin` 的 profile 說明；照該 repo 的「查看 → 備份 → 修改 → 驗證」流程做，並記錄回復步驟。到時再寫完整 prompt。

---

## P4（可選）：Codex 唯讀交叉檢查（在 `~/Projects/studio-kb` 的終端機）

```bash
codex exec "讀 AGENTS.md 和 docs/02-決策記錄.md，再讀 ~/Projects/openclaw-to-hermes 的 AGENTS.md。檢查兩個 repo 的紅線有沒有矛盾、studio-kb 有沒有密碼或 token、有沒有任何地方把 Claude 訂閱登入交給第三方工具。只報告，不要修改任何檔案。"
```
`codex exec` 預設唯讀，不會改檔案。如果 openclaw-to-hermes 不在 `~/Projects`，改成實際路徑。

---

## P5：本地模型實測 T1 和 T5（Codex，在 `openclaw-to-hermes` 工作副本）

> 2026-11-05 加入。來源：claude.ai Project 討論「本地模型 getting started」（第 1～4 步）。
> **為甚麼分成 P5 和 P6：** 安裝軟件是基建，由 Codex 在 `openclaw-to-hermes` 做和記錄；`studio-kb` 由 Claude Code 維護（`docs/02` 2026-11-05「兩個 repo 分工」）。P5 把結果寫入兩個 repo 以外的 `~/Projects/local-model-tests/RESULTS.md`，P6 由 Claude Code 讀它再填入 `docs/15`，兩個 AI 不會同時改同一份文件。
> **期限：** 退貨期要在 2026-11-14 或之前決定（`docs/02` 待決 #18）。模型合共約 130GB，下載要時間，建議今晚開始。
> **範圍：** 只做 T1 和 T5。T2～T4 要開 Unity 場景、Blender、Draw Things，要你在畫面前做，見本節最後。

```text
先照 AGENTS.md 執行 preflight（python3 hermes-staging/sync_before_work.py --personal-github），exit 3 就重讀指令再跑。

背景：這部是我的 Mac Studio（M5 Max 128GB、4TB），macOS 帳戶 billychan。我要在退貨期內測試本地模型，決定留下 128GB 還是退貨。這是我第一次用本地模型。知識庫在 ~/Projects/studio-kb，先讀它的 AGENTS.md、docs/15-Mac-Studio設定步驟.md 第 3 階段、docs/04-AI分工與自動化架構.md；只讀，不要修改 studio-kb。

任務：照以下 4 步裝好本地模型、量度速度（T1），並用兩個 agent 工具接本地模型做一個小任務（T5）。全部結果寫入 ~/Projects/local-model-tests/RESULTS.md。

## 規則（全程遵守）
- 安裝任何軟件前，先列出：名稱、安裝方法（優先用 studio-kb 的 mac-setup/Brewfile 已列的項目）、來源、大約大小，等我確認才裝。不用 curl | sh 的安裝方式，除非是官方唯一的方法，而且先問我。
- 不要用 sudo，不改系統設定。模型載入失敗、提示 GPU 記憶體不足，就停下來告訴我，不要自行執行 sysctl iogpu.wired_limit_mb。
- LM Studio 的伺服器只綁 127.0.0.1，「在區域網絡提供服務」保持關閉；不設 API key 以外的任何對外存取。
- 不改 AO、Hermes、ao-bridge、Tailscale 的設定；不改 gh 帳戶；不碰公司帳戶。
- 不改你自己平時用的 ~/.codex/config.toml。測試 Codex 本地設定時，一律用另一個設定目錄：CODEX_HOME=~/.codex-local。
- 不設定 ANTHROPIC_API_KEY 或 OPENAI_API_KEY；不要把 Claude Code 接到本地模型（例如設定 ANTHROPIC_BASE_URL），這是 studio-kb 的紅線。
- 同一時間只載入一個大模型；換模型前先 unload，避免互相搶記憶體。
- 照本 repo 的規則（查看 → 備份 → 修改 → 驗證）記錄這次安裝；需要更新 LIVE-STATE 或操作紀錄的，照本 repo 的方式做，並告訴我改了哪些檔案。
- 回覆和 RESULTS.md 都不要寫 token、密碼、IP、序號。

## 第 1 步：安裝 LM Studio 和監察工具
1. 檢查現況：LM Studio、lms 指令、macmon、uv、node 是否已安裝，以及版本。報告後等我確認才安裝缺少的項目（LM Studio 和 macmon 都在 Brewfile）。
2. 裝好 LM Studio 後，開一次讓它完成初次設定，然後用 LM Studio 自帶的方法把 lms 指令加入 PATH（例如 lms bootstrap，以官方文件為準）。
3. 確認 LM Studio 的推理引擎有 MLX（Apple Silicon 用 MLX 版本模型）。報告 LM Studio 版本、MLX 引擎版本，以及它的本機伺服器是否支援 OpenAI Responses API（/v1/responses）；Codex CLI 2026 年 2 月起只支援 Responses API，這一點決定 Codex 能否接 LM Studio。

## 第 2 步：下載三個模型（MLX 4-bit）
1. 用 lms 搜尋並下載以下三個模型的 MLX 4-bit 版本，優先選 lmstudio-community 或 mlx-community 發佈的：
   - Qwen3-Coder-Next（80B 總參數、約 3B active，4-bit 約 46GB）：主力寫碼候選
   - Qwen3.8-27B（dense，4-bit 約 16GB，支援看圖）：第二個寫碼候選
   - gpt-oss-120b（約 65GB）：對照組
2. 下載前先報告每個模型的確實名稱、發佈者、檔案大小和授權（看模型卡），以及磁碟剩餘空間，等我確認才下載。如果找不到我寫的名稱，列出最接近的選擇讓我揀，不要自行換成其他模型。
3. 下載期間可以先做第 3 步的準備（寫量度腳本、建測試 repo），但不要載入未下載完的模型。

## 第 3 步：T1，每個模型的速度和記憶體
1. 建立 ~/Projects/local-model-tests（普通資料夾，git init 但不設 remote，不要放入任何現有 repo）。量度腳本放這裡，用 Python 標準庫或 uv 管理的環境，不要用系統 Python 裝套件。
2. 每個模型逐一做：
   a. lms load <模型> --context-length 65536（以 lms 實際參數為準），記錄載入時間和 lms ps 顯示的佔用記憶體。
   b. lms server start，確認只聽 127.0.0.1:1234。
   c. 經 http://127.0.0.1:1234/v1 量度兩種情況，各跑 3 次取中位數：
      - 短 prompt（約 100 tokens），生成約 400 tokens：生成速度 tok/s、首個 token 時間。
      - 長 prompt（約 32K tokens，例如重複貼上一份程式碼），生成約 200 tokens：prompt 處理速度 tok/s、首個 token 時間、生成速度。
      生成速度用 API 回傳的 usage 和實際時間計算；LM Studio 有自己的統計就一併記錄。
   d. 量度期間每秒記錄一次記憶體：macmon（如有）、sysctl vm.swapusage、memory_pressure 或 vm_stat。記錄最高記憶體用量、有沒有 swap、記憶體壓力最差時的狀態。
   e. lms unload，等記憶體回落再做下一個。
3. 原始數據存入 ~/Projects/local-model-tests/t1/，摘要寫入 RESULTS.md 的「T1」表：模型、確實名稱、量化、檔案大小、載入後記憶體、短 prompt 生成 tok/s、長 prompt 處理 tok/s、長 prompt 生成 tok/s、首個 token 時間、swap、備註。

## 第 4 步：T5，經 agent 工具用本地模型完成小任務（先不經 AO）
1. 在 ~/Projects/local-model-tests/sandbox 建立測試 repo（只在本機，不上 GitHub）：Python、用 uv 管理、有 pytest；main 分支有一個空的 combat.py 和 tests/。先 commit 一個乾淨的起點，每次測試前都 git reset 回這個起點。
2. 任務（每次測試都用同一句，原文照貼）：
   「在 combat.py 加一個 calc_damage(attack: int, defense: int, crit: bool) -> int 函數：傷害 = max(1, attack - defense)，crit 為 True 時乘 2；在 tests/test_combat.py 加三個 pytest 測試（一般、防禦高於攻擊、暴擊），然後執行測試，全部通過才算完成。」
3. 兩個工具：
   a. OpenCode：先報告官方安裝方法和版本，等我確認才裝。設定一個 openai-compatible provider 指向 http://127.0.0.1:1234/v1，只用於這個測試。
   b. Codex 本地設定：CODEX_HOME=~/.codex-local，用 Codex 內建的 lmstudio provider（--oss --local-provider lmstudio，以 codex --help 的實際參數為準），在 sandbox 用 codex exec --sandbox workspace-write 執行任務。如果第 1 步發現 LM Studio 不支援 Responses API，這一項記為「不能接」，寫明錯誤訊息，不要裝 proxy 繞過。
4. 測試組合，每個組合跑 2 次：
   - OpenCode + Qwen3-Coder-Next
   - OpenCode + Qwen3.8-27B
   - Codex 本地 + Qwen3-Coder-Next
   - （如時間許可）Codex 本地 + gpt-oss-120b
5. 每次記錄：是否一次成功（pytest 全部通過、沒有我介入）、耗時、工具呼叫有沒有出錯（例如格式錯、無限循環、改錯檔案）、最終 git diff 行數。超過 15 分鐘未完成就中止，記為失敗。
6. 你用自己的判斷看一次每個成功的 diff，用一句話評價程式碼質素（不要修改它）。
7. 原始 log 存入 ~/Projects/local-model-tests/t5/，摘要寫入 RESULTS.md 的「T5」表。

## 最後
1. RESULTS.md 開頭寫：日期、macOS 版本、LM Studio 和 MLX 引擎版本、OpenCode 和 Codex 版本、每個模型的確實名稱和授權。
2. 最後加一段「觀察」：哪個模型和工具組合最適合做寫碼工人、128GB 在 T1 的情況下是否緊張、有沒有我需要決定的事。只寫觀察，不要寫「建議留下或退貨」，那個要等 T2～T4。
3. 用表格回覆我 T1 和 T5 的摘要，以及你在 openclaw-to-hermes 改了哪些檔案。不要 commit 或 push openclaw-to-hermes，先給我看 diff。
4. 完成後所有模型 unload，LM Studio 伺服器停止（lms server stop），不要讓它常駐。
```

### T2～T4：要你在 Mac Studio 前面做（P5 之後）
- **T2：** LM Studio 載入 Qwen3-Coder-Next（64K），開 Unity 6 一個 3D 場景（例如 URP 範例場景，播放中），同時開 Blender 渲染一個範例檔。看活動監視器「記憶體」分頁的記憶體壓力顏色和「已使用的交換空間」，拍一張截圖。
- **T3：** T2 再加 Draw Things（或 LM Studio 以外的圖像模型）同時出圖，看會否 swap 或卡死。
- **T4：** 可以叫 Codex 寫一個連續兩小時生成的腳本，同時用 macmon 記錄溫度和 tok/s；開始前先確認你在附近。
- 結果截圖或數字直接告訴 Claude，P6 會一併填入。

---

## P6：把 P5 的結果寫入 studio-kb（Claude Code，在 `~/Projects/studio-kb`）

```text
照 AGENTS.md 的規則：開分支 kb/<今日日期>-local-model-tests，不要改 main。

1. 讀 ~/Projects/local-model-tests/RESULTS.md（P5 的結果）。如果檔案不存在或 T1、T5 未完成，停下來告訴我，不要猜。
2. docs/15 第 3 階段：
   a. 「實際進度」更新：已安裝的工具和版本、已下載的模型、T1 和 T5 的完成日期。
   b. T1～T5 表的「結果」欄：T1、T5 填入摘要（每格兩三行，詳細數據寫「見 ~/Projects/local-model-tests/RESULTS.md」）。T2～T4 如我在這個 session 提供了結果就一併填入，否則寫「⬜ 未做」。
   c. T5 的「測試」欄原本寫 Aider，改為「OpenCode 和 Codex 本地設定 + 本地模型（2026-11-05 改：AO 支援這兩個工具，Aider 不再是主要選項）」，原文保留在括號內。
3. docs/05 模型清單：加入實測過的模型確實名稱、量化、授權和實測日期。
4. docs/02：背景事實的 Mac Studio 現況加一行實測摘要；待決 #18 的「決定的關鍵」更新 T1、T5 已完成的部分。不要寫「決定留下或退貨」，等我決定。
5. docs/08：加入 RESULTS.md 的來源和日期（本機實測）。
6. commit，然後：
   bash scripts/gh-personal.sh git push -u origin <分支>
   bash scripts/gh-personal.sh gh pr create --base main --title "<標題>" --body "<改了甚麼、來源：P5 實測、日期>"
   把 PR 連結給我。不要合併。
```
