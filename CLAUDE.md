@AGENTS.md

## Claude 專用補充
- Claude Code 不會自動讀 `AGENTS.md`，上面一行把它匯入。共同規則只寫在 `AGENTS.md`，這裡只放 Claude 專用的內容。
- 在 claude.ai Project 討論後，如果改變或新增了決定，在回答最後附上：

```
### 決策記錄更新（請開 PR 寫入 docs/02-決策記錄.md）
- [日期] 決定／修改：…… 理由：……
- 待決事項變動：……
```

- 用 Claude Code 寫入時：開分支 → 修改 → 開 PR，PR 說明寫明來源（哪一次討論、哪個 proposal）。
- **PR 由你自己建立，不要叫 Billy 開。** Billy 只負責審閱和合併。在 Mac Studio 上用 `bash scripts/gh-personal.sh gh pr create ...`，確保用個人帳戶 kahongchan。
