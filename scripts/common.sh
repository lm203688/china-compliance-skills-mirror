#!/usr/bin/env bash
# common.sh - Shared utilities for China Compliance skill scripts
# Source this file: source "$(dirname "$0")/../../scripts/common.sh"
#
# Features:
# - Retry with exponential backoff for 429/500 errors
# - JSON response validation
# - Debug logging (set CN_DEBUG=1)
# - Rate limit handling

# ============================================================
# Debug Logging
# ============================================================
cn_debug() {
  if [[ "${CN_DEBUG:-0}" == "1" ]]; then
    echo "[DEBUG $(date '+%H:%M:%S')] $*" >&2
  fi
}

cn_info() {
  echo "[INFO] $*" >&2
}

cn_error() {
  echo "[ERROR] $*" >&2
}

# ============================================================
# API Call with Retry
# ============================================================
# Usage: cn_api_call RESPONSE_VAR HTTP_CODE_VAR METHOD URL [PAYLOAD]
# 
# Features:
# - Automatic retry on 429 (rate limit) and 500 (server error)
# - Exponential backoff: 2s, 4s, 8s
# - JSON response validation
# - Debug logging of request/response
#
# Example:
#   cn_api_call body code POST "https://api.example.com/check" '{"text":"hello"}'
#   echo "HTTP $code: $body"

cn_api_call() {
  local __response_var="$1"
  local __code_var="$2"
  local __method="$3"
  local __url="$4"
  local __payload="${5:-}"
  
  local max_retries=3
  local retry=0
  local delay=2
  local response=""
  local http_code=""
  
  while [[ $retry -lt $max_retries ]]; do
    cn_debug "API call attempt $((retry+1))/$max_retries: $__method $__url"
    
    if [[ -n "$__payload" ]]; then
      response=$(curl -s -w "\n%{http_code}" \
        -X "$__method" \
        -H "Content-Type: application/json" \
        -d "$__payload" \
        --connect-timeout 10 \
        --max-time 30 \
        "$__url" 2>&1) || {
        cn_debug "curl failed, retrying in ${delay}s..."
        sleep "$delay"
        retry=$((retry+1))
        delay=$((delay*2))
        continue
      }
    else
      response=$(curl -s -w "\n%{http_code}" \
        -X "$__method" \
        --connect-timeout 10 \
        --max-time 30 \
        "$__url" 2>&1) || {
        cn_debug "curl failed, retrying in ${delay}s..."
        sleep "$delay"
        retry=$((retry+1))
        delay=$((delay*2))
        continue
      }
    fi
    
    http_code=$(echo "$response" | tail -1)
    local body=$(echo "$response" | sed '$d')
    
    cn_debug "Response: HTTP $http_code, body length: ${#body}"
    
    case "$http_code" in
      200)
        # Validate JSON response
        if cn_validate_json "$body"; then
          eval "$__response_var=\"\$body\""
          eval "$__code_var=\"\$http_code\""
          return 0
        else
          cn_debug "Invalid JSON response, retrying in ${delay}s..."
          sleep "$delay"
          retry=$((retry+1))
          delay=$((delay*2))
          continue
        fi
        ;;
      429)
        cn_debug "Rate limited (429), retrying in ${delay}s..."
        sleep "$delay"
        retry=$((retry+1))
        delay=$((delay*2))
        continue
        ;;
      500|502|503|504)
        cn_debug "Server error ($http_code), retrying in ${delay}s..."
        sleep "$delay"
        retry=$((retry+1))
        delay=$((delay*2))
        continue
        ;;
      *)
        # Client error (4xx) - don't retry
        eval "$__response_var=\"\$body\""
        eval "$__code_var=\"\$http_code\""
        return 1
        ;;
    esac
  done
  
  # All retries exhausted
  eval "$__response_var=\"\""
  eval "$__code_var=\"000\""
  cn_error "API call failed after $max_retries retries"
  return 1
}

# ============================================================
# JSON Validation
# ============================================================
# Usage: cn_validate_json JSON_STRING
# Returns 0 if valid, 1 if invalid

cn_validate_json() {
  local json="$1"
  if [[ -z "$json" ]]; then
    return 1
  fi
  echo "$json" | python3 -c "import json,sys; json.load(sys.stdin)" 2>/dev/null
}

# ============================================================
# JSON Field Extraction
# ============================================================
# Usage: cn_json_get JSON_STRING FIELD_PATH
# Example: cn_json_get "$body" "data.violations"

cn_json_get() {
  local json="$1"
  local path="$2"
  echo "$json" | python3 -c "
import json, sys
data = json.load(sys.stdin)
keys = sys.argv[1].split('.')
for k in keys:
    if isinstance(data, dict):
        data = data.get(k)
    elif isinstance(data, list) and k.isdigit():
        data = data[int(k)]
    else:
        data = None
        break
if data is None:
    print('')
elif isinstance(data, (list, dict)):
    print(json.dumps(data, ensure_ascii=False))
else:
    print(data)
" "$path" 2>/dev/null
}

# ============================================================
# Rate Limit Info
# ============================================================
# Parse rate limit headers from response
# Usage: cn_parse_rate_limit HEADERS_STRING

cn_parse_rate_limit() {
  local headers="$1"
  local remaining=$(echo "$headers" | grep -i "x-ratelimit-remaining" | awk '{print $2}' | tr -d '\r')
  local reset=$(echo "$headers" | grep -i "x-ratelimit-reset" | awk '{print $2}' | tr -d '\r')
  
  if [[ -n "$remaining" ]]; then
    cn_debug "Rate limit remaining: $remaining, reset: ${reset:-unknown}"
    if [[ "$remaining" -lt 5 ]] 2>/dev/null; then
      cn_info "⚠️ Rate limit low: $remaining requests remaining"
    fi
  fi
}

# ============================================================
# Configuration
# ============================================================
# Load API configuration from .env file

cn_load_config() {
  local script_dir="$(cd "$(dirname "${BASH_SOURCE[1]}")" && pwd)"
  local env_file="$script_dir/../.env"
  
  if [[ -f "$env_file" ]]; then
    while IFS='=' read -r key value; do
      case "$key" in
        CN_*|API_*)
          export "$key=$value"
          cn_debug "Loaded config: $key"
          ;;
      esac
    done < <(grep -E '^(CN_|API_)' "$env_file" 2>/dev/null || true)
  fi
}

# Auto-load config when sourced
cn_load_config
