#!/usr/bin/env bash
# 建立一般（非管理員）macOS 用戶，並把 home 設為只有自己可以讀。
# 用法（管理員帳戶）：bash mac-setup/02-create-user.sh factory "Factory"
# 之後的公司用戶（公司同意後）：bash mac-setup/02-create-user.sh corp "Corp"
set -euo pipefail

name="${1:?用法：02-create-user.sh <短名稱> <全名>}"
full="${2:?用法：02-create-user.sh <短名稱> <全名>}"

if id "$name" >/dev/null 2>&1; then
  echo "用戶 $name 已存在，只更新 home 權限。"
else
  echo "建立用戶 $name，稍後會要求輸入它的密碼："
  # -password - ：互動輸入密碼，不會留在指令紀錄
  sudo sysadminctl -addUser "$name" -fullName "$full" -password -
fi

home="/Users/$name"
if [ ! -d "$home" ]; then
  sudo createhomedir -c -u "$name" >/dev/null
fi

# macOS 預設 home 頂層讓同機其他用戶讀取；改為只有自己
sudo chmod 700 "$home"
ls -ld "$home"

echo "完成。記得在 系統設定 → 共享 → 遠端登入，把 $name 加入允許名單。"
