#!/usr/bin/env bash
# 安裝 commit 前檢查：用 gitleaks 找出密碼、API key、token。
# 用法：在 repo 根目錄執行 bash scripts/install-hooks.sh
set -euo pipefail

if ! command -v gitleaks >/dev/null 2>&1; then
  echo "未安裝 gitleaks。macOS：brew install gitleaks"
  exit 1
fi

hook=".git/hooks/pre-commit"
cat > "$hook" <<'EOF'
#!/usr/bin/env bash
# 只檢查這次 commit 的內容（新版 gitleaks 用 git 子指令，舊版用 protect）
if gitleaks help git >/dev/null 2>&1; then
  cmd=(gitleaks git --pre-commit --staged --redact --no-banner)
else
  cmd=(gitleaks protect --staged --redact --no-banner)
fi
"${cmd[@]}" || {
  echo "gitleaks 發現疑似密碼或 token，commit 已取消。"
  exit 1
}
EOF
chmod +x "$hook"

# 中文檔名正常顯示
git config core.quotepath false

echo "已安裝 commit 前檢查。"
