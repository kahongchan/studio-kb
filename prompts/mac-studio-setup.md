# Mac Studio 設定 prompts

> 2026-11-05 改寫：按 Mac Studio 的實際情況，即 `billychan` 帳戶、Agent Orchestrator（AO）、Codex 維護基建。
> 分工見 `docs/02-決策記錄.md` 2026-11-05：基建由 Codex 在 `openclaw-to-hermes` 做；`studio-kb` 由 Claude Code 做；AO 只派開發任務。
> 這些 prompts 都在互動 session 貼上，不要經 AO 或 Hermes 派工。

| 次序 | 用甚麼 | 在哪個資料夾 | 做甚麼 | 會不會改東西 |
|---|---|---|---|---|
| P0 | Claude Code | `~/Projects` | 把 studio-kb 加進 Mac Studio，對照實際狀態報告差異 | 只 clone |
| P1 | Codex | `openclaw-to-hermes` | 維運 repo 加入和 studio-kb 的分工說明 | 只改該 repo 的 AGENTS、README |
| P2 | Claude Code | `~/Projects/studio-kb` | 按 P0 的報告更新 studio-kb，開 PR | 開分支和 PR，你合併 |
| P3 | Codex | `openclaw-to-hermes` | （之後）把 studio-kb 和遊戲 repo 註冊到 AO、加入 bridge allowlist | 改 AO 和 bridge 設定，要你批准 |

---

## P0：把 studio-kb 加進 Mac Studio（Claude Code，在 `~/Projects`）

```text
你在我的 Mac Studio，macOS 帳戶 billychan。任務：把我的知識庫 kahongchan/studio-kb 加進這部機，然後對照這部機的實際狀態報告差異。除了 clone，不要修改任何東西：不用 sudo，不安裝軟件，不改系統、AO、Hermes 或 ao-bridge 設定，不 commit，不 push。

1. GitHub 身份：執行 `gh auth status`，報告有哪些帳戶、哪個是 active（不要顯示 token）。這個 repo 只可以用個人帳戶 kahongchan。如果 active 不是 kahongchan，不要切換全機的預設帳戶；先找出這部機上的 openclaw-to-hermes 工作副本，讀它的 hermes-staging/sync_before_work.py，看它怎樣只在子程序用 kahongchan，再照同樣方法 clone，並告訴我你用了甚麼方法。發現任何公司帳戶的憑證就停下來告訴我。
2. clone 到 ~/Projects/studio-kb；如果已經存在，只執行 git fetch 並報告狀態。repo-local 的 user.name 和 user.email 設成和 openclaw-to-hermes 一樣的 kahongchan noreply 身份。
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
7. commit（如果 gitleaks 已安裝，會在 commit 前自動檢查），push 這個分支，給我開 PR 的連結。不要合併。
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
