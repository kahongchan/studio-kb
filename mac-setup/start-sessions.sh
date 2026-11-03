#!/usr/bin/env bash
# factory 登入時自動開三個 tmux 視窗：
#   rc   ：Remote Control 伺服器（手機 Claude app 操作遊戲 repo，每個 session 一個 worktree）
#   desk ：Discord Channels（只可以查狀態、加任務）
#   orch ：orchestrator 24 小時循環
# 已經在運行的視窗不會重開。手動執行：bash mac-setup/start-sessions.sh
# 查看：tmux attach -t studio
#
# 開機自動執行（在 factory 用戶）：
#   0. mkdir -p ~/studio/bin ~/studio/logs ~/Library/LaunchAgents
#   1. 把這個腳本複製到 ~/studio/bin/start-sessions.sh，並 chmod +x
#   2. 把 com.studio.sessions.plist 複製到 ~/Library/LaunchAgents/，把裡面的 factory 換成你的短名稱（如有不同）
#   3. launchctl bootstrap gui/$(id -u) ~/Library/LaunchAgents/com.studio.sessions.plist
#
# 第一次使用前，每個資料夾都要先在終端機手動執行一次對應指令，回答「信任資料夾」和「啟用」的問題。
set -euo pipefail

export PATH="$HOME/.local/bin:/opt/homebrew/bin:/usr/bin:/bin:/usr/sbin:/sbin"
unset ANTHROPIC_API_KEY   # 確保用訂閱額度

STUDIO="${STUDIO:-$HOME/studio}"
GAME_DIR="${GAME_DIR:-$STUDIO/sotg-remake}"
DESK_DIR="${DESK_DIR:-$STUDIO/remote-desk}"
ORCH_DIR="${ORCH_DIR:-$STUDIO/studio-orchestrator}"
S=studio

tmux has-session -t "$S" 2>/dev/null || tmux new-session -d -s "$S" -n shell

start_window() {   # 名稱 資料夾 指令
  local name="$1" dir="$2" cmd="$3"
  if tmux list-windows -t "$S" -F '#W' | grep -qx "$name"; then
    echo "$name：已在運行"; return
  fi
  if [ ! -d "$dir" ]; then
    echo "$name：找不到 $dir，略過"; return
  fi
  tmux new-window -d -t "$S" -n "$name" -c "$dir" "$cmd; echo '已結束，按 Enter 關閉'; read"
  echo "$name：已啟動"
}

start_window rc   "$GAME_DIR" "claude remote-control --spawn worktree"
start_window desk "$DESK_DIR" "claude --channels plugin:discord@claude-plugins-official"
start_window orch "$ORCH_DIR" "python3 orchestrator.py loop"
