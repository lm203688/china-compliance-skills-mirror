#!/usr/bin/env bash
# cn-seo-optimizer - Safe Replacement Suggestions
# Get safe replacement suggestions for banned/sensitive words
# Usage:
#   ./suggestions.sh "最好" --platform douyin
#   ./suggestions.sh "美白" --platform xiaohongshu

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ENV_FILE="$SCRIPT_DIR/../.env"

if [[ -f "$ENV_FILE" ]]; then
  while IFS='=' read -r key value; do
    case "$key" in
      CN_COMPLIANCE_API_KEY|CN_COMPLIANCE_API_BASE)
        export "$key=$value"
        ;;
    esac
  done < <(grep -E '^(CN_COMPLIANCE_API_KEY|CN_COMPLIANCE_API_BASE)=' "$ENV_FILE" 2>/dev/null || true)
fi

API_BASE="${CN_COMPLIANCE_API_BASE:-https://1341839497-jv04655vcs.ap-shanghai.tencentscf.com}"
API_BASE="${API_BASE%/}"
PLATFORM="all"
WORD=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --platform|-p)
      PLATFORM="$2"
      shift 2
      ;;
    --help|-h)
      echo "用法: ./suggestions.sh \"违禁词\" --platform [baidu|douyin|xiaohongshu|taobao|wechat|all]"
      exit 0
      ;;
    *)
      if [[ -z "$WORD" ]]; then
        WORD="$1"
      fi
      shift
      ;;
  esac
done

if [[ -z "$WORD" ]]; then
  echo "用法: ./suggestions.sh \"违禁词\" --platform douyin" >&2
  exit 1
fi

# Call API
HTTP_RESPONSE=$(curl -s -w "\n%{http_code}" \
  -X GET \
  "$API_BASE/suggestions?word=$(python3 -c "import urllib.parse; print(urllib.parse.quote('$WORD'))")&platform=$PLATFORM" \
  --connect-timeout 10 \
  --max-time 15 2>&1) || {
  echo "错误: 网络连接失败"
  exit 1
}

HTTP_CODE=$(echo "$HTTP_RESPONSE" | tail -1)
BODY=$(echo "$HTTP_RESPONSE" | sed '$d')

if [[ "$HTTP_CODE" != "200" ]]; then
  echo "错误: 服务异常 (HTTP $HTTP_CODE)"
  exit 1
fi

# Format output
echo "$BODY" | python3 -c "
import json, sys
data = json.load(sys.stdin)
word = data.get('word', '')
suggestions = data.get('suggestions', [])
category = data.get('category', '')
severity = data.get('severity', '')

if severity == 'high':
    emoji = '🔴'
elif severity == 'medium':
    emoji = '🟡'
else:
    emoji = '🟢'

print(f'{emoji} \"{word}\" — 分类: {category}')
if suggestions:
    print(f'✅ 安全替换建议: {', '.join(suggestions)}')
else:
    print('⚠️ 建议直接删除或改写相关表述')
" 2>/dev/null
