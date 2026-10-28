# assets：AI 資產紀錄

**這裡只放紀錄，不放大檔案。** 圖片、3D 原始檔、影片放 Google Drive；Unity 實際用到的最終資產放遊戲 repo 的 Git LFS。

每個 AI 生成或修改的資產一個 JSON：`assets/records/<資產 ID>.json`。格式見 `records/_example.json`，欄位說明：

| 欄位 | 必填 | 說明 |
|---|---|---|
| `asset` | ✅ | 資產 ID，和檔名一致 |
| `type` | ✅ | concept / model3d / texture / animation / music / sfx / voice / text |
| `status` | ✅ | candidate（候選）/ selected（選用）/ in-game（已放入遊戲）/ dropped |
| `model`、`version` | ✅ | 生成模型和版本 |
| `license` | ✅ | 模型授權；不明就不可以用於商業流程 |
| `prompt`、`seed` | 建議 | 重現用 |
| `generated_at` | ✅ | ISO 日期時間 |
| `edited_by` | 建議 | 之後的修改步驟，包括人手修改（版權上有用） |
| `source_references` | 建議 | 參考圖來源 |
| `drive_url` | 原始檔在 Drive 時 | Google Drive 連結 |
| `game_path` | 已放入遊戲時 | 遊戲 repo 內的路徑 |
| `steam_ai_disclosure` | ✅ | 玩家看得到或聽得到的資產填 true（Steam 要披露） |

大量候選圖不用每張一個紀錄：只為 `selected` 或以上的資產建立紀錄，候選圖用一個批次紀錄（`asset` 用批次 ID）。
