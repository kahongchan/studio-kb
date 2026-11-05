#!/usr/bin/env bash
# 只在這個程序用個人 GitHub 帳戶 kahongchan 執行一個指令，不切換 gh 的全機預設帳戶。
# 做法和 openclaw-to-hermes 的 sync_before_work.py --personal-github 相同。
# 用法：
#   bash scripts/gh-personal.sh git push -u origin <分支>
#   bash scripts/gh-personal.sh gh pr create --fill
#   bash scripts/gh-personal.sh git pull --ff-only
# token 只放在這個程序的環境變數，不寫入檔案、不顯示。
set -euo pipefail

if [ "$#" -eq 0 ]; then
  echo "用法：bash scripts/gh-personal.sh <指令> [參數...]" >&2
  exit 2
fi

gh_bin="$(command -v gh)" || { echo "找不到 gh" >&2; exit 1; }

# 先移除可能存在的其他 token，避免用錯帳戶
unset GH_TOKEN GITHUB_TOKEN GH_ENTERPRISE_TOKEN GITHUB_ENTERPRISE_TOKEN

token="$("$gh_bin" auth token --hostname github.com --user kahongchan 2>/dev/null)" || {
  echo "gh 沒有登入 kahongchan。先執行：gh auth login --hostname github.com" >&2
  exit 1
}
export GH_TOKEN="$token" GH_HOST=github.com

# 只在這個程序把 git 的 credential helper 換成 gh（第一個空值會清除原有的 helper）
export GIT_CONFIG_COUNT=2
export GIT_CONFIG_KEY_0=credential.helper GIT_CONFIG_VALUE_0=""
export GIT_CONFIG_KEY_1=credential.helper GIT_CONFIG_VALUE_1="!$gh_bin auth git-credential"

who="$("$gh_bin" api user --jq .login)"
if [ "$who" != "kahongchan" ]; then
  echo "目前身份是 $who，不是 kahongchan，停止。" >&2
  exit 1
fi

exec "$@"
