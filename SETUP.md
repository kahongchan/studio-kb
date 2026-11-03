# SETUP：建立和連接 studio-kb

全部用 **個人** GitHub 帳戶。公司 GitHub 帳戶不要接觸這個 repo。

## 第 0 步：建立 repo（約 10 分鐘）
1. 用個人 GitHub 帳戶建立私人 repo `studio-kb`。**不要**勾選加入 README、.gitignore 或 license（保持空白）。
2. 二選一：
   - **由 Claude 推上：** 把 repo 名稱（`你的帳戶/studio-kb`）告訴 Claude，Claude 連接 repo（需要你批准），推上全部檔案。
   - **自己推上：** 下載骨架 zip，解壓後在 MacBook 的**私人** macOS 用戶執行：
     ```bash
     cd studio-kb
     git init -b main
     git config core.quotepath false
     git add .
     git commit -m "建立 studio-kb"
     git remote add origin git@github.com:<你的帳戶>/studio-kb.git
     git push -u origin main
     ```
3. 建議升級 GitHub Pro（每月 US$4）。私人 repo 的 branch protection 要 Pro 或以上。
4. Settings → Branches → 為 `main` 加規則：
   - Require a pull request before merging
   - 不要勾「Do not allow bypassing」：你自己可以直接把 proposals 存入 main，機器帳戶不可以。

## 第 1 步：連接 Claude Project 和 ChatGPT
**Claude Project「一人 AI 遊戲工作室」**
1. Project knowledge → 加入 GitHub → 選 `studio-kb`。如果看不到，到 GitHub 的 Claude app 設定授權這個 repo。
2. 只揀 `AGENTS.md` 和 `docs/`（不用揀 proposals 和 assets，省 context）。
3. 確認 Claude 讀得到之後，刪除 Project 裡舊的上傳文件，避免兩份並存。
4. 把 `docs/專案指示-Project-Instructions.md` 的內容貼到「Set project instructions」。
5. 之後每次合併 PR，按 Project 的 **Sync**（不會自動更新）。

**ChatGPT**
1. 設定 → Apps → GitHub → 安裝 ChatGPT 的 GitHub app，**只授權 `studio-kb`**。
2. ChatGPT 的 GitHub 讀取是唯讀的；部分方案只在 deep research 或 agent 模式可用。在一般對話用不到時，下載 `docs/` 的檔案上傳到 ChatGPT Project。
3. ChatGPT Project 的指示加入 `proposals/README.md` 最後那一句。

## 第 2 步：Mac Studio（到手後）
> 完整的 Mac Studio 設定（電源、用戶、工具、實測、手機遙控）見 `docs/15-Mac-Studio設定步驟.md`。以下只是 studio-kb 相關的部分。

1. 開 GitHub 機器帳戶（例如 `<你的帳戶>-bot`；條款容許一個免費機器帳戶，只可以做自動化）。
2. 用個人帳戶邀請機器帳戶為 `studio-kb` 和遊戲 repo 的協作者。
3. 在 `factory` macOS 用戶：
   ```bash
   mkdir -p ~/studio && cd ~/studio
   git clone git@github.com:<你的帳戶>/studio-kb.git
   cd studio-kb && bash scripts/install-hooks.sh
   ```
4. 遊戲 repo 的 `AGENTS.md` 加一句：「專案背景和決策見 `../studio-kb/AGENTS.md` 和 `../studio-kb/docs/02-決策記錄.md`」。
5. Codex 設定 → 連接 GitHub → 開啟 code review。

## 第 3 步：日常
| 想做 | 做法 |
|---|---|
| Claude Project 討論後有新決定 | Claude Code：「把這段決策記錄更新寫入 studio-kb，開 PR」→ 手機 GitHub app 批准 → Project 按 Sync |
| ChatGPT 給意見 | ChatGPT 按範本輸出 → 存入 `proposals/` → 叫 Claude 處理 |
| 記錄新 AI 資產 | orchestrator 或 agent 在 `assets/records/` 加 JSON，經 PR |
| 查某個決定的歷史 | GitHub 網頁看 `docs/02-決策記錄.md` 的 History |
