#!/usr/bin/env bash
# 檢查 Mac Studio 設定。任何用戶都可以執行：bash mac-setup/03-verify.sh
# 只讀取，不修改任何設定。
set -u

ok()   { printf '  \033[32m✔\033[0m %s\n' "$1"; }
bad()  { printf '  \033[31m✘\033[0m %s\n' "$1"; }
info() { printf '  · %s\n' "$1"; }
check_cmd() { if command -v "$1" >/dev/null 2>&1; then ok "$1：$($1 --version 2>/dev/null | head -1)"; else bad "$1 未安裝"; fi; }

echo "== 電源 =="
p=$(pmset -g)
echo "$p" | grep -qE '^ *sleep +0' && ok "系統不睡眠" || bad "系統會睡眠（執行 01-power.sh）"
echo "$p" | grep -qE 'autorestart +1' && ok "停電後自動開機" || bad "未設定停電後自動開機"
echo "$p" | grep -qE 'womp +1' && ok "網絡喚醒" || bad "未開啟網絡喚醒"

echo "== 安全 =="
fdesetup status 2>/dev/null | grep -q "On" && ok "FileVault 已開啟" || bad "FileVault 未開啟"
info "遠端登入：系統設定 → 一般 → 共享 → 遠端登入（應該只允許管理員和 factory）"

echo "== 用戶和 home 權限 =="
for u in /Users/*; do
  n=$(basename "$u"); [ "$n" = "Shared" ] && continue; [ -d "$u" ] || continue
  perm=$(stat -f '%Lp' "$u")
  [ "$perm" = "700" ] && ok "$n home 權限 700" || bad "$n home 權限 $perm（應為 700）"
done

echo "== 工具 =="
for c in git git-lfs gh gitleaks tmux jq node uv bun; do check_cmd "$c"; done
command -v macmon >/dev/null 2>&1 && ok "macmon" || bad "macmon 未安裝"
if [ "$(whoami)" = "factory" ]; then
  for c in claude codex aider; do check_cmd "$c"; done
  [ -z "${ANTHROPIC_API_KEY:-}" ] && ok "沒有設定 ANTHROPIC_API_KEY（用訂閱額度）" \
    || bad "設定了 ANTHROPIC_API_KEY：Claude Code 會按 API 收費"
fi

echo "== 網絡 =="
if command -v tailscale >/dev/null 2>&1; then
  tailscale status >/dev/null 2>&1 && ok "Tailscale 已連線" || bad "Tailscale 未連線"
elif [ -x "/Applications/Tailscale.app/Contents/MacOS/Tailscale" ]; then
  /Applications/Tailscale.app/Contents/MacOS/Tailscale status >/dev/null 2>&1 \
    && ok "Tailscale 已連線" || bad "Tailscale 未連線（要有用戶登入 macOS）"
else
  bad "Tailscale 未安裝"
fi
curl -s -m 3 http://127.0.0.1:1234/v1/models >/dev/null 2>&1 \
  && ok "LM Studio 模型伺服器（127.0.0.1:1234）運行中" \
  || info "LM Studio 模型伺服器未運行（第 3 階段才需要）"
