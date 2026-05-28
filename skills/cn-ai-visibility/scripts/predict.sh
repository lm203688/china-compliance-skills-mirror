#!/usr/bin/env bash
# cn-geo-monitor - Content Performance Prediction
# Predict how your content will perform in Chinese AI search engines
# Usage:
#   ./predict.sh "你的内容文本" --engine deepseek --brand "品牌名"
#   ./predict.sh --file content.txt --engine kimi --brand "品牌名"

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
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

API_BASE="${CN_GEO_API_BASE:-https://1341839497-2yuxt6z58d.ap-guangzhou.tencentscf.com}"
API_BASE="${API_BASE%/}"
ENGINE="deepseek"
BRAND=""
CONTENT=""
FILE=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --engine|-e)
      ENGINE="$2"
      shift 2
      ;;
    --brand|-b)
      BRAND="$2"
      shift 2
      ;;
    --file|-f)
      FILE="$2"
      shift 2
      ;;
    --help|-h)
      echo "用法: ./predict.sh \"内容文本\" --engine deepseek --brand \"品牌名\""
      echo "      ./predict.sh --file content.txt --engine kimi --brand \"品牌名\""
      echo ""
      echo "引擎: deepseek kimi doubao tongyi ernie"
      exit 0
      ;;
    *)
      if [[ -z "$CONTENT" ]]; then
        CONTENT="$1"
      fi
      shift
      ;;
  esac
done

if [[ -n "$FILE" ]]; then
  if [[ ! -f "$FILE" ]]; then
    echo "错误: 文件不存在 - $FILE" >&2
    exit 1
  fi
  CONTENT=$(cat "$FILE")
fi

if [[ -z "$CONTENT" ]]; then
  echo "用法: ./predict.sh \"内容文本\" --engine deepseek --brand \"品牌名\"" >&2
  exit 1
fi

# Call prediction API
PAYLOAD=$(python3 -c "
import json, sys
print(json.dumps({
    'content': sys.argv[1],
    'target_engine': sys.argv[2],
    'brand': sys.argv[3] if sys.argv[3] else 'unknown'
}))
" "$CONTENT" "$ENGINE" "${BRAND:-unknown}")

HTTP_RESPONSE=$(curl -s -w "\n%{http_code}" \
  -X POST \
  -H "Content-Type: application/json" \
  -d "$PAYLOAD" \
  --connect-timeout 10 \
  --max-time 30 \
  "$API_BASE/predict" 2>&1) || {
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

engine = data.get('engine', 'unknown')
phase = data.get('calibration_phase', 'cold-start')

engine_names = {
    'deepseek': 'DeepSeek R1',
    'kimi': 'Kimi 2',
    'doubao': '豆包',
    'tongyi': '通义千问',
    'ernie': '文心一言'
}
name = engine_names.get(engine, engine)

print(f'📊 内容预测报告 — {name}')
print(f'校准阶段: {phase}')
print()

scores = data.get('scores', {})
if scores:
    print('5维评分:')
    dims = {
        'compliance_risk': ('合规风险', '🔴'),
        'engagement_potential': ('互动潜力', '📈'),
        'brand_safety': ('品牌安全', '🛡️'),
        'seo_visibility': ('SEO可见度', '🔍'),
        'ai_citation_probability': ('AI引用概率', '🤖')
    }
    for key, (label, emoji) in dims.items():
        score = scores.get(key, 'N/A')
        print(f'  {emoji} {label}: {score}/100')
    print()

suggestions = data.get('suggestions', [])
if suggestions:
    print('💡 优化建议:')
    for s in suggestions:
        print(f'  - {s}')
    print()

citation_prob = data.get('ai_citation_probability', 0)
if isinstance(citation_prob, (int, float)):
    if citation_prob >= 60:
        print(f'✅ AI引用概率 {citation_prob}% — 内容质量优秀，预计会被AI引擎引用')
    elif citation_prob >= 30:
        print(f'🟡 AI引用概率 {citation_prob}% — 有改进空间，参考上方建议优化')
    else:
        print(f'🔴 AI引用概率 {citation_prob}% — 需要大幅优化才能获得AI引用')
" 2>/dev/null
