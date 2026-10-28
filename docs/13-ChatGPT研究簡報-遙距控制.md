# 13 給 ChatGPT 的研究簡報：Mac Studio 24 小時工廠 + Hermes 遙距控制

> 2026-10-27 版本。整段貼給 ChatGPT，再附上 `02-決策記錄`、`04-AI分工與自動化架構`、`07-風險合規與注意事項`。
> 不用附：06、10、11、12（和遙距架構無關）。
> 「我的補充資料」一節要先填好再貼。

---

# 研究任務：Mac Studio 24 小時 AI 開發工廠 + Hermes 遙距控制

## 背景
我是一人遊戲開發者（Unity 6，曾一人推出 Steam + Switch 遊戲），現職軟件開發，每星期只有約 10 小時。
目標：Mac Studio 24 小時自主運行開發工作，我用 MacBook 或手機遙距監察、審批。

## 已定的事（請以此為前提，不要重新討論）
- 硬件：準備買 Mac Studio M5 Max 128GB / 2TB（未下單），做 24 小時工廠。
  MacBook Pro M4 Max 64GB 是我私人擁有的機（同時用來做公司專案，公司已同意；機上沒有公司 MDM 或監察軟件），主要做遙距控制台；在家時可以做第二個寫碼工人。
- 引擎：Unity 6（不是 Unreal）。
- 大腦：Claude Max 5x 訂閱 + 官方 Claude Code。自動化用我自己的腳本呼叫 `claude -p`。
- 手腳：Mac Studio 本地模型（MLX / LM Studio / Ollama）+ Aider 照任務卡寫碼。
- 已有自己的 orchestrator 腳本（Python）：Claude 規劃 → 本地模型在獨立 git 分支寫碼 → 自動測試 → Claude 審查 → 合併 main。額度用完時自動冷卻、只做已規劃任務。現在只支援單一工人。
- 遙距：Tailscale；SSH + tmux；macOS 螢幕共享。
- VPS 目前閒置，曾裝 OpenClaw。現時傾向「方案 A」：Hermes 放 Mac Studio，VPS 只做 Tailscale 出口節點和看守。「方案 B」：Hermes 放 VPS，經 Tailscale 指揮 Mac Studio。
- **Hermes 的角色：** 只做「遙控按鈕」和通知。Hermes 的大腦用本地模型（或 ChatGPT 登入）；要用 Claude 時，Hermes 只把指令寫入 orchestrator 的任務佇列，由 orchestrator 呼叫官方 `claude -p`。Hermes 不持有任何 Claude 訂閱登入。
- Mac Studio 分開 macOS 用戶：`factory`（Claude Code、orchestrator、本地模型、GitHub 機器帳戶）和 `hermes`（Hermes、訊息閘道）。

## 紅線（必須遵守）
1. Claude 訂閱的 OAuth 登入只可用於官方 Claude Code 和 Anthropic 自家 app，不可以放入 Hermes、OpenClaw 或任何第三方工具。Anthropic 2026-04 表明第三方工具用訂閱不在條款允許範圍，自 4 月 4 日起改扣 extra usage；冒認 Claude Code 的修補是明確禁止的。
2. Hermes 預設會自動借用 Claude Code（Keychain）和 Codex CLI 的登入，必須設定 `auth.adopt_external_logins: false`，並在沒有 Claude Code 登入的 macOS 用戶下運行。
3. Claude 憑證不放上 VPS。Claude Code 只在 Mac Studio 運行。
4. Agent 在獨立 macOS 用戶帳戶下運行。MacBook 上有公司專案，私人項目的 agent 不可以讀取公司的程式碼、憑證和帳戶。
5. 不用多個訂閱帳戶輪替避開額度上限（不要建議 Hermes 的 credential pool 或 account-pool 外掛做這件事）。
6. GitHub：一個個人帳戶 + 一個機器帳戶（GitHub 條款上限）。Agent 用機器帳戶，不可以合併 main。

## 最新事實（你之前的資料可能過時）
- Max 方案原本計劃的獨立 Agent SDK / `claude -p` 額度於 2026-06-15 暫停。
- **2026-10-07 起，Max 5x 每月附送 US$100 API credit**（Max 20x 為 US$200），要在 claude.ai 帳單設定連結 Console 組織領取。涵蓋 Claude API、Agent SDK、Managed Agents 和用該組織 API key 執行的 `claude -p`。用訂閱登入的 Claude Code 和 `claude -p` 仍計入訂閱額度。
- Hermes 要求模型至少 64K context，低於 64K 會拒絕啟動。

## 請你研究和整理
1. 方案 A 和方案 B 的完整比較：安全性、可靠性（VPS 斷線或 Mac 重開機時怎樣）、設定難度、Hermes 需要的權限。建議哪一個作起步？
2. Hermes Agent 現時版本能做甚麼：接本地模型（MLX / llama.cpp / LM Studio）、MCP、訊息閘道、排程、子 agent。怎樣限制只接受我自己的帳戶？
3. 手機遙控的實際流程：我在手機上可以安全地做哪些事（查狀態、開任務、批准合併、暫停）？哪些應該只能在電腦上做？
4. Hermes 和 orchestrator 怎樣分工：任務佇列的介面設計（檔案、SQLite 或本地 HTTP API）、權限（`hermes` 用戶只可以寫佇列，不可以執行 `claude`）、避免兩個系統搶本地模型記憶體。
5. Tailscale 設定：ACL 範例（VPS 只能連模型 port 和受限帳戶的 SSH）、VPS 做出口節點。
6. Mac Studio 24 小時運行：不睡眠、停電自動開機、UPS、launchd KeepAlive、FileVault 重開機要人手解鎖的取捨、無螢幕螢幕共享。
7. VPS 重置步驟：撤銷舊 OpenClaw 憑證、重裝、加固。
8. 分階段實施計劃：每個階段的完成標準。
9. MacBook 加入做第二個工人：怎樣和 Mac Studio 共用任務佇列；MacBook 帶出門時，任務怎樣交回 Mac Studio；同一部機上公司和私人兩個用戶帳戶怎樣隔離（檔案、鑰匙圈、SSH key、Tailscale）。
10. 多帳戶設定：Claude 和 GitHub 各有公司、個人帳戶；私人項目只用個人帳戶，公司帳戶只做公司工作的自動化排程和審批。Mac Studio 計劃分 `factory`（私人）、`hermes`（私人，可選）、`corp`（公司）三個 macOS 用戶。
    - 同一部機上公司和私人 macOS 用戶的隔離（home 權限、Keychain、SSH key、Claude Code 登入）。
    - 多個 macOS 用戶同時 24 小時運行 Claude Code：用戶未登入時 launchd 背景服務能否讀到 Keychain 的登入；`claude setup-token` 長期 token 是否可靠。
    - 兩個用戶共用一個本地模型伺服器和記憶體排程的做法。
    - GitHub 機器帳戶的權限設定：fine-grained token 還是 deploy key、branch protection、只有我的個人帳戶可以合併 main。
    - Hermes 用 ChatGPT／Codex 登入：OpenAI 條款是否容許、怎樣計入 Plus 額度、和 Codex CLI 共用登入的問題。

11. **官方方案 vs Hermes：** Claude Code 有官方 Channels（Telegram／Discord／iMessage 送訊息入運行中的 session，用 Max 訂閱登入，research preview）和 Remote Control（`claude remote-control`）。請比較「Channels + Remote Control + ntfy」和「Hermes」做手機遙控的優劣；如果官方方案已經足夠，Hermes 還有甚麼用途值得保留？
12. Hermes 是否 OpenAI「Sign in with ChatGPT」（2026-09-29 DevDay）的參與夥伴？Hermes 用 ChatGPT 登入是否計入官方容許的範圍？

## 回覆格式
- 每個建議列明所依據的假設；假設和上面不同就明確指出。
- 涉及軟件功能、條款、價格的事實，附來源連結和核實日期；不確定的標明「未核實」。
- 最後列出「需要我回答的問題」。

## 我的補充資料
- VPS：供應商＿＿、機房地點＿＿、CPU／RAM＿＿、作業系統＿＿；OpenClaw 是否仍在運行＿＿；舊 token 是否已撤銷＿＿
- 家中網絡：寬頻供應商＿＿、有沒有固定 IP＿＿、路由器可否設定＿＿；Mac Studio 用有線網絡＿＿
- 手機：iOS／Android＿＿；想用的訊息平台（Telegram／Slack／Discord）＿＿
- Hermes 要做到甚麼程度：只收通知／可以開新任務／可以批准合併＿＿
- 帳戶：Claude 公司＋個人；GitHub 公司＋個人（另開機器帳戶）；ChatGPT 個人
