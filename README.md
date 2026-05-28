# 🛡️ China Compliance Skills

**4 premium AI agent skills for Chinese content compliance — used by 2000+ businesses.**

> Methodology + Detection Workflow + Result Interpretation — not just prompts, complete compliance loops.

[![GitHub stars](https://img.shields.io/github/stars/lm203688/china-compliance-skills-mirror?style=social)](https://github.com/lm203688/china-compliance-skills-mirror/stargazers)
[![GitHub forks](https://img.shields.io/github/forks/lm203688/china-compliance-skills-mirror?style=social)](https://github.com/lm203688/china-compliance-skills-mirror/fork)
[![ClawHub](https://img.shields.io/badge/ClawHub-Published-blue)](https://clawhub.com)
[![Skills](https://img.shields.io/badge/Skills-4-green)](./skills)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](./LICENSE)
[![PRs Welcome](https://img.shields.io/badge/PRs-Welcome-brightgreen.svg)](./CONTRIBUTING.md)

**English** | [中文](./README.zh-CN.md)

---

## 🎯 Why This Exists

Every piece of Chinese content faces **3 legal minefields**:
1. **广告法 (Advertising Law)** — "最好", "第一", "国家级" = 罚款20-100万
2. **数据出境 (Data Export)** — Transferring data overseas without CAC assessment = 违法
3. **AI生成标注 (AI Content Labeling)** — 2025新规要求AI内容必须标注

**Most AI agents don't know these rules.** These skills give them the expertise.

---

## 📦 The 4 Skills

### 1. 🛡️ cn-compliance-guard — 内容合规守卫
**What it does:** Scans Chinese text for 200+ banned words across 6 legal categories, checks SEO compliance for 5 platforms, provides safe replacement suggestions.

**Why it's not just a prompt:** It contains the actual banned word database (广告法第九条/第十七条/第二十八条/第二十五条, 消费者权益保护法), platform-specific SEO rules (百度/小红书/抖音/淘宝/京东), and a replacement suggestion engine.

```
Input:  "我们是最好的产品，100%有效，3天见效！"
Output: ⚠️ 3个高风险违禁词 + 法律依据 + 罚款金额 + 安全替换建议
```

### 2. 🔍 cn-ai-visibility — AI搜索可见度检测
**What it does:** Analyzes brand/keyword visibility across 5 Chinese AI search engines (DeepSeek/Kimi/豆包/通义千问/文心一言), provides per-engine optimization strategies.

**Why it's not just a prompt:** It contains the citation logic database for each AI engine — DeepSeek prefers structured technical content, Kimi prefers long-form documents, 豆包 prefers Douyin/Toutiao content. Each engine has specific optimization tips.

```
Input:  "某某品牌"
Output: 5引擎可见度评分 + 引用逻辑分析 + 针对性优化建议
```

### 3. 🛡️ cn-data-export — 数据出境合规评估
**What it does:** 7-question risk assessment covering PIPL/网络安全法/数据安全法, determines which compliance pathway (安全评估/标准合同/认证) your business needs.

**Why it's not just a prompt:** It contains the actual legal thresholds — 10万人以上个人信息必须申报安全评估, CIIO认定标准, 重要数据识别规则, and generates a prioritized action list based on your specific situation.

```
Input:  7个问题答案（数据类型/规模/目的地等）
Output: 风险评分 + 合规路径推荐 + 优先级行动清单
```

### 4. 🤖 cn-aigc-detector — AI生成内容检测
**What it does:** Statistical analysis of Chinese text to detect AI-generated content — sentence variance, vocabulary diversity, AI pattern matching, punctuation analysis.

**Why it's not just a prompt:** It implements 5 detection signals with weighted scoring — perplexity (sentence length variance), burstiness (vocabulary TTR), structural patterns (首先...其次...最后), sentence starter uniformity, and punctuation density. It highlights suspicious sections.

```
Input:  一段中文文本（50字以上）
Output: AI生成概率 + 5项信号分析 + 可疑片段标注
```

---

## 🚀 Quick Start

### One-Line Install (Recommended)

```bash
curl -fsSL https://raw.githubusercontent.com/lm203688/china-compliance-skills-mirror/main/scripts/install.sh | sh
```

Automatically installs to `~/.agents/skills/` (Codex/Gemini/Kiro) and `~/.claude/skills/` (Claude Code).

### For Claude Code / Cursor / OpenClaw

Add to your `AGENTS.md` or `CLAUDE.md`:

```markdown
## Skills
- cn-compliance-guard: Scan Chinese text for 200+ banned words (广告法)
- cn-ai-visibility: Check brand visibility in 5 Chinese AI search engines
- cn-data-export: Assess cross-border data transfer compliance (PIPL)
- cn-aigc-detector: Detect AI-generated Chinese text
```

### Manual Installation

```bash
# Clone to universal skills path
git clone https://github.com/lm203688/china-compliance-skills-mirror.git ~/.agents/skills/china-compliance-skills

# Or for Claude Code specifically
git clone https://github.com/lm203688/china-compliance-skills-mirror.git ~/.claude/skills/china-compliance-skills
```

---

## 🏗️ Architecture

```
china-compliance-skills/
├── README.md                          # This file
├── LICENSE                            # MIT
├── .claude-plugin/
│   └── marketplace.json               # Plugin marketplace config
├── skills/
│   ├── cn-compliance-guard/
│   │   └── SKILL.md                   # Content compliance skill
│   ├── cn-ai-visibility/
│   │   └── SKILL.md                   # AI visibility skill
│   ├── cn-data-export/
│   │   └── SKILL.md                   # Data export assessment skill
│   └── cn-aigc-detector/
│       └── SKILL.md                   # AIGC detection skill
└── examples/                          # Usage examples
    └── workflow-examples.md           # Multi-skill workflows
```

---

## 🔗 Live Web Apps

Each skill powers a live web application:

| Skill | Web App | Pricing |
|-------|---------|---------|
| cn-compliance-guard | [合规通](https://1341839497-jv04655vcs.ap-shanghai.tencentscf.com/) | Free 5次/月, Pro ¥49/月 |
| cn-ai-visibility | [AI搜索可见度](https://1341839497-2d5g5k6b1k.ap-shanghai.tencentscf.com/) | Free 3次/月, Pro ¥149/月 |
| cn-data-export | [数据出境自评](https://1341839497-xq8m5j4e2n.ap-shanghai.tencentscf.com/) | Free, Pro ¥199/月 |
| cn-aigc-detector | [AI内容检测](https://1341839497-7v3p9w5k2m.ap-shanghai.tencentscf.com/) | Free 5次/月, Pro ¥99/月 |

---

## 📊 Coverage

- **200+** banned words across 6 legal categories
- **5** Chinese AI search engines analyzed
- **3** major data protection laws covered (PIPL, 网络安全法, 数据安全法)
- **5** AI detection signals with weighted scoring
- **5** platform SEO rule sets (百度/小红书/抖音/淘宝/京东)

---

## ⚖️ Legal Disclaimer

These skills provide compliance **screening and suggestions only**. They do not constitute legal advice. For specific compliance decisions, consult a qualified Chinese attorney.

---

## 📄 License

MIT License — use freely in your projects. Attribution appreciated.

---

## 🙏 Acknowledgments

Inspired by:
- [ConardLi/garden-skills](https://github.com/ConardLi/garden-skills) — "少而精" skill design philosophy
- [Anthropic-Cybersecurity-Skills](https://github.com/mukul975/Anthropic-Cybersecurity-Skills) — Vertical domain skill library pattern
- [Compliance-to-Code](https://github.com/AlexJJJChen/Compliance-to-Code) — Chinese financial regulations → executable code
- [ok-skills](https://github.com/mxyhi/ok-skills) — Practical SKILL.md examples and AGENTS.md playbooks
- [MagicSkills](https://github.com/Narwhal-Lab/MagicSkills) — Cross-agent skill infrastructure

Built by [非常AI团队](https://github.com/feichangai-team). If these skills help you, please ⭐ star this repo!
