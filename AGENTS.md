# AGENTS.md：所有 AI 的共同規則

這個 repo 是「一人 AI 遊戲工作室」（代號 **REFORGE FRAME**，重鑄框架）的知識庫，是所有 AI（Claude、ChatGPT、Codex、Hermes、本地模型）共用的**唯一來源**。擁有者：Billy Chan。

代號：整個專案叫 REFORGE FRAME；Sword of the Guardian 重製的格鬥引擎（連技、判定、影格數據）叫 GUARDIAN REFORGE。在文件、commit 和 PR 中可以直接用這兩個代號。

## 開始工作前
1. 先讀 `docs/02-決策記錄.md`。它是目前狀態的唯一依據：已定的事不要重新推翻，除非有新資料令原本的理由不再成立；如果是這樣，要明確指出是哪條理由失效。
2. 再讀和任務相關的文件（索引見 `README.md`）。
3. 標示「未獨立核實」的資料，引用前先核實。

## 修改規則
- **不要直接改 `main`。** 一律開分支（`kb/<日期>-<主題>`）和 PR，由擁有者合併。
- **同一個工作副本，同一時間只有一個 agent 修改。** Claude Code 和 Codex 共用 `~/Projects/studio-kb`。開始修改前執行 `git status`：有不是你做的未 commit 修改，或者目前不在 `main`、也不在你自己的分支，就停下來問擁有者，不要 stash、reset 或覆蓋。要和另一個 agent 同時工作，就用 `git worktree add ../studio-kb-<名稱> -b kb/<日期>-<主題>` 開獨立的工作資料夾，完成後 `git worktree remove`。
- 在 Mac Studio 上 push 和開 PR，一律經 `bash scripts/gh-personal.sh`，只用個人帳戶 kahongchan。
- 改決定時，同時修改 `docs/02-決策記錄.md` 和相關文件，寫明日期和理由。
- 有時效的事實（價格、條款、模型排名、軟件功能）要附來源連結和核實日期，並更新 `docs/08-資料來源與核實狀態.md`。
- 你不能開 PR 的話（例如 ChatGPT 網頁版），按 `proposals/_template.md` 的格式輸出建議，由擁有者存入 `proposals/`。
- 處理 `proposals/` 時：先列出它和現有方案的**假設差異**，再核實它引用的事實，接納的才改 `docs/`，並把建議的狀態改為 `accepted` 或 `rejected`，寫明原因。

## 紅線
- 不放任何密碼、API key、OAuth token、bot token、VPS IP、帳單或財務資料。
- Claude 訂閱（Pro/Max）的登入只用於官方 Claude Code 和 Anthropic 自家 app，不可以交給第三方工具。
- 私人項目和公司工作完全分開：私人項目不使用公司帳戶、不接觸公司程式碼；公司帳戶不作私人用途。
- 不用多個訂閱帳戶輪替來避開額度上限。
- 每個 AI 生成的資產都要在 `assets/records/` 記錄來源模型和授權；不可以使用授權不明的模型。

## 寫作風格
- 繁體中文，可以用香港口語；直接講結論，再講理由。
- 不確定就寫「未核實」或「不確定」，並說明怎樣確認。

## Code Review Rules
（給 Codex 的 `@codex review`；這個 repo 主要是文件）
- 檢查有沒有洩漏密碼、token、IP。
- 檢查修改有沒有和 `docs/02-決策記錄.md` 矛盾。
- 有時效的事實沒有來源或核實日期，要指出。
