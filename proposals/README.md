# proposals：其他 AI 的修改建議

不能直接開 PR 的 AI（例如 ChatGPT 網頁版）的意見放這裡，不直接改 `docs/`。

## 流程
1. 叫 ChatGPT 按 `_template.md` 的格式輸出建議。
2. 在 GitHub 網頁（手機也可以）按「Add file → Create new file」，檔名用 `YYYY-MM-DD-<來源>-<主題>.md`，貼上內容，直接 commit 到 main（這個資料夾的檔案 status 是 `open`，不算決定）。
3. 在 Claude Project 或 Claude Code 說：「處理 proposals 裡 status 為 open 的建議」。
4. Claude 列出假設差異、核實事實，開 PR 修改 `docs/`，並更新建議的 `status`。
5. 你審閱 PR，合併。

## 給 ChatGPT 的一句指示（可以放入 ChatGPT Project 的指示）
> 讀 studio-kb repo 的 AGENTS.md 和 docs/02-決策記錄.md。修改建議請按 proposals/_template.md 的格式輸出，一個建議一份，每個事實附來源和核實日期。
