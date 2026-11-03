#!/usr/bin/env bash
# Mac Studio 24 小時運行的電源設定。用管理員帳戶執行：bash mac-setup/01-power.sh
# 會要求 sudo 密碼。可以重複執行。
set -euo pipefail

# sleep 0：系統永不睡眠；disksleep 0：硬碟不休眠；displaysleep 15：螢幕 15 分鐘後關
# womp 1：網絡喚醒；autorestart 1：停電後來電自動開機；powernap 0：關閉 Power Nap
sudo pmset -a sleep 0 disksleep 0 displaysleep 15 womp 1 autorestart 1 powernap 0

# 系統當機時自動重開機（較新的 macOS 可能要給終端機「完全磁碟取用權」才可以設定）
sudo systemsetup -setrestartfreeze on 2>/dev/null \
  || echo "注意：未能設定當機自動重開機（可略過）"

echo "目前設定："
pmset -g | grep -E ' sleep|disksleep|displaysleep|womp|autorestart|powernap' || true
