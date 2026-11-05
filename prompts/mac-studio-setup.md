# Mac Studio 設定 prompts

> 2026-11-05。在 Mac Studio 的 **`factory` 用戶**開 **Claude Code 互動 session**，按次序逐段貼上。
> 每段完成後，看清楚它的報告才貼下一段。不要用 orchestrator 或 `claude -p` 執行這些 prompts（理由見 `docs/02-決策記錄.md` 2026-11-05）。
> 要 `sudo` 的系統設定（電源、建立用戶、共享）不在這裡，由你在管理員帳戶照 `docs/15` 做。

---

## P0：把 studio-kb 加進 Mac Studio（在 `~` 開 Claude Code）

```text
你在我的 Mac Studio「factory」用戶。任務：把我的知識庫 repo kahongchan/studio-kb 加進這部機，然後報告現況。只做以下步驟，不要用 sudo，不要安裝或移除任何軟件，不要改系統設定。

1. 檢查 GitHub 存取：執行 `ssh -T git@github.com` 和 `gh auth status`（如果有 gh），告訴我現在用哪個 GitHub 帳戶登入。這個用戶應該用 GitHub「機器帳戶」，不可以是公司帳戶；如果是公司帳戶，立即停止並告訴我。
2. 如果 ~/studio/studio-kb 不存在：mkdir -p ~/studio，然後 `git clone git@github.com:kahongchan/studio-kb.git ~/studio/studio-kb`。clone 失敗（沒有權限）就停止，告訴我錯誤訊息，並列出我要做的事（例如把機器帳戶加為 repo 協作者、把這個用戶的 SSH 公鑰加到機器帳戶）。
3. 在 ~/studio/studio-kb 執行 `bash scripts/install-hooks.sh`；如果未安裝 gitleaks，告訴我，不要自行安裝。
4. 讀 AGENTS.md、docs/02-決策記錄.md、docs/15-Mac-Studio設定步驟.md。
5. 執行 `bash mac-setup/03-verify.sh`，並另外收集：claude、codex、aider、git、git-lfs、tmux、bun 的版本；~/.claude/settings.json 是否有 autoUpdatesChannel；ANTHROPIC_API_KEY 和 OPENAI_API_KEY 是否有設定（只答有或沒有，不要顯示內容）；LM Studio 伺服器 127.0.0.1:1234 是否運行；orchestrator 安裝在哪個資料夾（在 ~ 和 ~/studio 下找 orchestrator.py 或 config.toml）。
6. 用一個表格報告：docs/15 第 0 至 5 階段每一項的狀態（完成／未完成／無法從這個用戶檢查），以及和 docs/02 紅線不符的地方。

規則：不要顯示任何 token、密碼或 IP；這一步不要修改 studio-kb 的任何檔案，不要 commit。
```

---

## P1：讓 orchestrator 讀 studio-kb（在 orchestrator 資料夾開 Claude Code）

```text
這是我的 orchestrator（claude-local-orchestrator）。任務：讓它規劃和審查時讀到 ~/studio/studio-kb 的共同規則，並確認它在這部機可以正常運行。

先讀 ~/studio/studio-kb/AGENTS.md 和 docs/04-AI分工與自動化架構.md 第二至四部分，然後：
1. 讀 orchestrator 的程式碼、config.toml 和 prompts/，用幾句話告訴我現在的流程和設定（Claude 指令、本地模型端點、Aider 參數、冷卻和每日上限、合併到哪個分支）。
2. 如果 orchestrator 是 git repo：開分支 `setup/studio-kb-context`；如果不是，先告訴我，等我決定是否建立私人 repo（kahongchan/studio-orchestrator），不要自行建立。
3. 修改：
   a. config.toml 加 `kb_path = "~/studio/studio-kb"`。
   b. plan 和 review 的 prompt 加入一段：先讀 kb_path 的 AGENTS.md 和 docs/02-決策記錄.md，任務卡和審查不可以違反其中的決定和紅線。
   c. 合併目標改為 develop 分支（docs/02 2026-10-28 的決定）；如果現在是 main，改之前先告訴我。
   d. 確認呼叫 Claude 時仍會移除 ANTHROPIC_API_KEY。
4. 用模擬模式跑一次完整流程，貼出結果摘要。
5. 不要跑真實的 claude -p 或本地模型，不要 push；完成後列出改動和 git diff 摘要，等我確認。
```

---

## P2：第一次真實運行（在 orchestrator 資料夾開 Claude Code）

```text
P1 的改動我已確認。任務：用一個測試 repo 做第一次真實運行，驗證 Claude 規劃 → 本地模型寫 → 測試 → Claude 審查 → 合併 develop。

1. 在 ~/studio/sandbox-test 建立一個本地 git repo（不要上 GitHub）：Python，有 pytest，main 和 develop 兩個分支。
2. 確認 LM Studio 伺服器在 127.0.0.1:1234 運行，並列出已載入的模型；未運行就停止並告訴我。
3. 執行 orchestrator：plan "在 combat.py 加一個 calc_damage(attack, defense, crit) 函數和三個單元測試"，然後 run-once。
4. 報告每一步：用了哪個模型、耗時、測試結果、Claude 審查意見、有沒有合併到 develop、用了多少次 Claude 呼叫。
5. 如果失敗，說明在哪一步、原因，以及建議修改，但不要自行修改 orchestrator。
```

---

## P3：把現況寫回 studio-kb（在 ~/studio/studio-kb 開 Claude Code）

```text
任務：把 P0 至 P2 的結果寫入知識庫。照 AGENTS.md 的規則：開分支 kb/<今日日期>-mac-studio-status，不要改 main。

1. 在 docs/15-Mac-Studio設定步驟.md 最後加「實際進度」一節：每個階段的狀態、日期、已安裝的版本（不寫任何 token、IP、序號）。
2. docs/02-決策記錄.md「背景事實」加一行：Mac Studio 已安裝的工具和 orchestrator 位置；如果 P2 成功，寫明第一次真實運行的日期和結果。
3. 如果 P0 發現和紅線不符的地方，在 docs/02 待決事項加一項，不要自行改設定。
4. commit（commit 前 gitleaks 會自動檢查），push 這個分支，給我 GitHub 開 PR 的連結。不要合併。
```

---

## P4：Codex 交叉檢查（在 ~/studio/studio-kb 的終端機，可選）

```bash
codex exec "讀 AGENTS.md 和 docs/02-決策記錄.md。然後檢查 ~/studio 下各 repo 的設定：有沒有任何地方把 Claude 訂閱登入交給第三方工具、有沒有密碼或 token 寫在 repo 裡、orchestrator 是否可能直接合併到 main。只報告，不要修改任何檔案。"
```
`codex exec` 預設唯讀，這個指令不會改檔案。

---

## 之後（未寫 prompt）
- 第 5 階段手機遙控：Discord Channels、remote-desk、Remote Control、開機自動啟動（`docs/15` 第 5 階段）。
- 連接 VPS 上的 Hermes 和 Codex 管理的 VPS 專案（見 `docs/02` 待決 #20）。
