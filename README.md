# studio-kb：一人 AI 遊戲工作室知識庫

以 Claude、ChatGPT、Codex 和 Mac Studio 本地模型協作，由 AI 補足美術、動畫、數值和 QA，一人用 Unity 6 開發遊戲。第一步：重製 Sword of the Guardian（Steam 優先），驗證 AI 流程。

**這個 repo 是所有 AI 共用的唯一來源。** AI 的規則見 `AGENTS.md`；建立和連接步驟見 `SETUP.md`；方法說明見 `docs/14-AI共用檔案方法.md`。

## 文件索引
| 文件 | 內容 |
|---|---|
| `docs/01-背景與目標.md` | 我是誰、設備、帳戶、時間、目標 |
| `docs/02-決策記錄.md` | **目前狀態的唯一依據**：已定、背景事實、待決 |
| `docs/03-硬件方案比較.md` | Mac Studio 配置、效能、記憶體預算 |
| `docs/04-AI分工與自動化架構.md` | 分工、任務流程、orchestrator、Hermes、多帳戶、多引擎 |
| `docs/05-模型與工具清單.md` | 寫碼、2D、3D、動畫、音樂模型和軟件 |
| `docs/06-遊戲引擎比較.md` | Unity 6 / Unreal / Godot（已定 Unity 6） |
| `docs/07-風險合規與注意事項.md` | 條款、版權、授權、資產紀錄、帳戶規則、QA 清單 |
| `docs/08-資料來源與核實狀態.md` | 來源和核實日期、已修正的錯誤 |
| `docs/10-過往作品-Sword-of-the-Guardian.md` | 舊作資料和評價拆解、重製版設計目標 |
| `docs/11-項目方向分析.md` | 重製 vs 香港項目、畫面路線 |
| `docs/12-工具預算.md` | 訂閱和工具價格、分階段預算 |
| `docs/13-ChatGPT研究簡報-遙距控制.md` | 給 ChatGPT 的研究任務 |
| `docs/14-AI共用檔案方法.md` | 這個 repo 怎樣運作 |
| `docs/15-Mac-Studio設定步驟.md` | **Mac Studio 到手後的設定步驟**（6 個階段、實測表、停電處理） |
| `docs/專案指示-Project-Instructions.md` | 貼到 Claude Project 的指示 |

## 其他資料夾
| 資料夾 | 內容 |
|---|---|
| `proposals/` | 其他 AI 的修改建議，一個建議一個檔案 |
| `assets/records/` | 每個 AI 資產的來源紀錄（JSON），大檔案本身放 Google Drive |
| `scripts/` | commit 前檢查密碼和 token |
| `prompts/` | 給 Claude Code 的設定 prompts（`mac-studio-setup.md`：把專案加進 Mac Studio、連接 orchestrator、第一次真實運行） |
| `mac-setup/` | Mac Studio 設定腳本：電源、建立用戶、Brewfile、檢查、開機自動啟動、手機遙控台 |
