#!/usr/bin/env bash
# cn-seo-optimizer - Compliance Check Script
# Scan Chinese content for advertising law violations and SEO compliance
# Usage:
#   ./check.sh "要检测的文案" --platform douyin
#   ./check.sh --file input.txt --platform xiaohongshu
#   ./check.sh "文案"  (defaults to all platforms)

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ENV_FILE="$SCRIPT_DIR/../.env"

# Load env if exists
if [[ -f "$ENV_FILE" ]]; then
  while IFS='=' read -r key value; do
    case "$key" in
      CN_COMPLIANCE_API_KEY|CN_COMPLIANCE_API_BASE)
        export "$key=$value"
        ;;
    esac
  done < <(grep -E '^(CN_COMPLIANCE_API_KEY|CN_COMPLIANCE_API_BASE)=' "$ENV_FILE" 2>/dev/null || true)
fi

# Defaults
API_BASE="${CN_COMPLIANCE_API_BASE:-https://1341839497-2yuxt6z58d.ap-guangzhou.tencentscf.com}"
API_BASE="${API_BASE%/}"
PLATFORM="all"
TEXT=""
FILE=""

# Parse arguments
while [[ $# -gt 0 ]]; do
  case "$1" in
    --platform|-p)
      PLATFORM="$2"
      shift 2
      ;;
    --file|-f)
      FILE="$2"
      shift 2
      ;;
    --help|-h)
      echo "用法: ./check.sh \"要检测的文案\" --platform [baidu|douyin|xiaohongshu|taobao|wechat|all]"
      echo "      ./check.sh --file input.txt --platform douyin"
      echo ""
      echo "平台: baidu(百度) douyin(抖音) xiaohongshu(小红书) taobao(淘宝) wechat(微信) all(全部)"
      exit 0
      ;;
    *)
      if [[ -z "$TEXT" ]]; then
        TEXT="$1"
      fi
      shift
      ;;
  esac
done

# Read from file if specified
if [[ -n "$FILE" ]]; then
  if [[ ! -f "$FILE" ]]; then
    echo "错误: 文件不存在 - $FILE" >&2
    exit 1
  fi
  TEXT=$(cat "$FILE")
fi

# Validate input
if [[ -z "$TEXT" ]]; then
  echo "用法: ./check.sh \"要检测的文案\" --platform douyin" >&2
  echo "      ./check.sh --file input.txt --platform xiaohongshu" >&2
  exit 1
fi

# Check text length
CHAR_COUNT=${#TEXT}
if [[ $CHAR_COUNT -gt 5000 ]]; then
  echo "错误: 文本长度 ${CHAR_COUNT} 超过上限 5000 字符" >&2
  exit 1
fi

# Build request
PAYLOAD=$(python3 -c "
import json, sys
print(json.dumps({
    'content': sys.argv[1],
    'platform': sys.argv[2],
    'check_seo': True
}))
" "$TEXT" "$PLATFORM")

# Call API
HTTP_RESPONSE=$(curl -s -w "\n%{http_code}" \
  -X POST \
  -H "Content-Type: application/json" \
  -d "$PAYLOAD" \
  --connect-timeout 10 \
  --max-time 30 \
  "$API_BASE/check" 2>&1) || {
  echo "错误: 网络连接失败，请检查网络"
  exit 1
}

# Extract status code and body
HTTP_CODE=$(echo "$HTTP_RESPONSE" | tail -1)
BODY=$(echo "$HTTP_RESPONSE" | sed '$d')

# Handle HTTP errors
case "$HTTP_CODE" in
  200) ;;
  429)
    echo "⚠️ 请求频率过高，请稍后再试"
    exit 1
    ;;
  *)
    echo "错误: 服务异常 (HTTP $HTTP_CODE)"
    exit 1
    ;;
esac

# Parse and format output
COMPLIANT=$(echo "$BODY" | python3 -c "import json,sys; print(json.load(sys.stdin).get('compliant', True))" 2>/dev/null || echo "true")

if [[ "$COMPLIANT" == "True" ]]; then
  echo "✅ 文案合规，可以安全发布！"
  echo ""
  SEO_SCORE=$(echo "$BODY" | python3 -c "import json,sys; print(json.load(sys.stdin).get('seo_score', 'N/A'))" 2>/dev/null || echo "N/A")
  echo "SEO评分: ${SEO_SCORE}/100"
  exit 0
fi

# Has violations - format output
VIOLATIONS=$(echo "$BODY" | python3 -c "
import json, sys
data = json.load(sys.stdin)
violations = data.get('violations', [])
if not violations:
    print('0')
    sys.exit(0)

high = sum(1 for v in violations if v.get('severity') == 'high')
medium = sum(1 for v in violations if v.get('severity') == 'medium')
low = sum(1 for v in violations if v.get('severity') == 'low')

print(f'{len(violations)}')
print(f'风险概览: 🔴 高危={high} | 🟡 中危={medium} | 🟢 低危={low}')
print()

if high > 0:
    print('🔴 高危（可能导致封号/删帖/罚款）')
    for v in violations:
        if v.get('severity') == 'high':
            word = v.get('word', '')
            cat = v.get('category', '')
            sug = v.get('suggestion', '')
            line = f'  - \"{word}\" — 分类: {cat}'
            if sug:
                line += f' → 建议替换: {sug}'
            print(line)
    print()

if medium > 0:
    print('🟡 中危（可能导致限流/降权）')
    for v in violations:
        if v.get('severity') == 'medium':
            word = v.get('word', '')
            cat = v.get('category', '')
            sug = v.get('suggestion', '')
            line = f'  - \"{word}\" — 分类: {cat}'
            if sug:
                line += f' → 建议替换: {sug}'
            print(line)
    print()

if low > 0:
    print('🟢 低危（建议修改）')
    for v in violations:
        if v.get('severity') == 'low':
            word = v.get('word', '')
            cat = v.get('category', '')
            sug = v.get('suggestion', '')
            line = f'  - \"{word}\" — 分类: {cat}'
            if sug:
                line += f' → 建议替换: {sug}'
            print(line)
    print()

seo = data.get('seo_score', 'N/A')
print(f'SEO评分: {seo}/100')
seo_sugs = data.get('seo_suggestions', [])
if seo_sugs:
    print('SEO建议:')
    for s in seo_sugs:
        print(f'  - {s}')
" 2>/dev/null)

COUNT=$(echo "$VIOLATIONS" | head -1)
DETAILS=$(echo "$VIOLATIONS" | tail -n +2)

echo "⚠️ 检测到 ${COUNT} 个违规词"
echo ""
echo "$DETAILS"
