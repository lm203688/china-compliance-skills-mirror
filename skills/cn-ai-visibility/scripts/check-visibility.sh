#!/usr/bin/env bash
# cn-geo-monitor - AI Search Visibility Check
# Check your brand's visibility across Chinese AI search engines
# Usage:
#   ./check-visibility.sh "你的品牌名" --all-engines
#   ./check-visibility.sh "你的品牌名" --engine deepseek
#   ./check-visibility.sh "你的品牌名" --engine kimi --queries 10
#
# Environment:
#   CN_DEBUG=1    Enable debug logging
#   CN_GEO_API_BASE  API base URL
#   CN_GEO_API_KEY   API key (optional)

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Source shared utilities (retry, JSON validation, debug logging)
COMMON_LIB="$SCRIPT_DIR/../../scripts/common.sh"
if [[ -f "$COMMON_LIB" ]]; then
  source "$COMMON_LIB"
else
  cn_debug() { [[ "${CN_DEBUG:-0}" == "1" ]] && echo "[DEBUG] $*" >&2 || true; }
  cn_error() { echo "[ERROR] $*" >&2; }
fi
ENV_FILE="$SCRIPT_DIR/../.env"

if [[ -f "$ENV_FILE" ]]; then
  while IFS='=' read -r key value; do
    case "$key" in
      CN_GEO_API_KEY|CN_GEO_API_BASE)
        export "$key=$value"
        ;;
    esac
  done < <(grep -E '^(CN_GEO_API_KEY|CN_GEO_API_BASE)=' "$ENV_FILE" 2>/dev/null || true)
fi

API_BASE="${CN_GEO_API_BASE:-https://1341839497-jv04655vcs.ap-shanghai.tencentscf.com}"
API_BASE="${API_BASE%/}"
ENGINE="all"
BRAND=""
QUERIES=20

while [[ $# -gt 0 ]]; do
  case "$1" in
    --engine|-e)
      ENGINE="$2"
      shift 2
      ;;
    --all-engines|-a)
      ENGINE="all"
      shift
      ;;
    --queries|-q)
      QUERIES="$2"
      shift 2
      ;;
    --help|-h)
      echo "用法: ./check-visibility.sh \"品牌名\" --engine [deepseek|kimi|doubao|tongyi|ernie|all]"
      echo "      ./check-visibility.sh \"品牌名\" --all-engines --queries 10"
      echo ""
      echo "引擎: deepseek(DeepSeek R1) kimi(Kimi 2) doubao(豆包) tongyi(通义千问) ernie(文心一言) all(全部)"
      exit 0
      ;;
    *)
      if [[ -z "$BRAND" ]]; then
        BRAND="$1"
      fi
      shift
      ;;
  esac
done

if [[ -z "$BRAND" ]]; then
  echo "用法: ./check-visibility.sh \"品牌名\" --engine deepseek" >&2
  exit 1
fi

ENGINES=("deepseek" "kimi" "doubao" "tongyi" "ernie")
ENGINE_NAMES=("DeepSeek R1" "Kimi 2" "豆包" "通义千问" "文心一言")

if [[ "$ENGINE" != "all" ]]; then
  ENGINES=("$ENGINE")
  # Find display name
  for i in "${!ENGINES[@]}"; do
    if [[ "${ENGINES[$i]}" == "$ENGINE" ]]; then
      ENGINE_NAMES=("${ENGINE_NAMES[$i]}")
      break
    fi
  done
fi

echo "🔍 AI搜索可见度报告 — $BRAND"
echo ""

TOTAL_CITATIONS=0
TOTAL_QUERIES=0

for i in "${!ENGINES[@]}"; do
  eng="${ENGINES[$i]}"
  name="${ENGINE_NAMES[$i]}"
  
  # Call API
  HTTP_RESPONSE=$(curl -s -w "\n%{http_code}" \
    -X POST \
    -H "Content-Type: application/json" \
    -d "{\"brand\": \"$BRAND\", \"engine\": \"$eng\", \"queries\": $QUERIES}" \
    --connect-timeout 10 \
    --max-time 30 \
    "$API_BASE/check-visibility" 2>&1) || {
    echo "  $name: ⚠️ 连接失败"
    continue
  }

  HTTP_CODE=$(echo "$HTTP_RESPONSE" | tail -1)
  BODY=$(echo "$HTTP_RESPONSE" | sed '$d')

  if [[ "$HTTP_CODE" != "200" ]]; then
    echo "  $name: ⚠️ 服务异常 (HTTP $HTTP_CODE)"
    continue
  fi

  # Parse result
  RESULT=$(echo "$BODY" | python3 -c "
import json, sys
data = json.load(sys.stdin)
cited = data.get('citations', 0)
total = data.get('total_queries', $QUERIES)
rate = data.get('citation_rate', 0)
trend = data.get('trend', '→')
suggestions = data.get('suggestions', [])

print(f'{rate}%')
print(f'{cited}/{total}')
print(f'{trend}')
if suggestions:
    for s in suggestions[:2]:
        print(f'💡 {s}')
" 2>/dev/null || echo "N/A")

  RATE=$(echo "$RESULT" | head -1)
  DETAIL=$(echo "$RESULT" | head -2 | tail -1)
  TREND=$(echo "$RESULT" | head -3 | tail -1)
  SUGGESTIONS=$(echo "$RESULT" | tail -n +4)
  
  printf "  %-12s %5s  (%s)  %s\n" "$name" "$RATE" "$DETAIL" "$TREND"
  if [[ -n "$SUGGESTIONS" ]]; then
    echo "$SUGGESTIONS" | while read -r line; do
      echo "    $line"
    done
  fi
done

echo ""
echo "─────────────────────────────────────"
echo "💡 使用 ./predict.sh 预测内容在各引擎的表现"
