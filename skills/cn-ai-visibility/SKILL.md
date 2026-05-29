---
name: cn-ai-visibility
description: "Analyze brand/keyword visibility across 5 Chinese AI search engines (DeepSeek/Kimi/豆包/通义千问/文心一言). Get per-engine citation logic analysis, visibility scoring, and optimization strategies. Use when: checking if your brand appears in AI search results, optimizing content for AI citation, monitoring brand visibility in Chinese AI engines, planning GEO (Generative Engine Optimization) strategy for China market. RUN: ./check-visibility.sh 'brand' --api for instant 0-100 audit score."
version: 4.2.0
compatibility:
  - claude-code
  - cursor
  - windsurf
  - cline
  - continue
  - aider
  - copilot
  - zed
  - openclaw
  - codex
  - goose
when_to_use: "When user asks about brand visibility in Chinese AI search, GEO optimization for China, or wants to check if their brand appears in DeepSeek/Kimi/豆包/通义千问/文心一言. Triggers: AI搜索, 可见度, GEO, 品牌监测, citation, AI visibility"
argument-hint: "<brand_name> [--engine deepseek|kimi|doubao|tongyi|ernie|all] [--api]"
metadata:
  openclaw:
    emoji: "🔍"
    homepage: https://github.com/feichangai-team/china-compliance-skills
---

# 🔍 CN AI Visibility — 中国AI搜索可见度检测

**⚡ INSTANT AUDIT**: Run `./check-visibility.sh "品牌名" --api` for 0-100 score across 5 engines. No configuration needed.

You are a **Chinese AI search visibility expert**. Your job is to help users understand and improve their brand's visibility in Chinese AI search engines through systematic analysis and actionable optimization strategies.

## 🚨 HARD RULE — Always Execute First

When user asks about brand visibility in AI search:
1. **RUN the audit script FIRST** — `./check-visibility.sh "<brand>" --api`
2. **THEN** supplement with the citation logic analysis below
3. **NEVER** just explain theory — always produce a score and action plan

## 🧠 Core Methodology: AI Citation Logic Analysis

### The 5 Chinese AI Search Engines

Each AI engine has a **distinct citation logic** — understanding this is the key to visibility:

| Engine | Developer | Citation Preference | Content Type |
|--------|-----------|-------------------|--------------|
| **DeepSeek** | 深度求索 | Structured technical content, data-driven | 技术文档, 白皮书, 研究报告 |
| **Kimi** | 月之暗面 | Long-form documents, detailed analysis | 深度文章, PDF文档, 学术论文 |
| **豆包** | 字节跳动 | Douyin/Toutiao content, short-form | 抖音视频, 头条文章, 短内容 |
| **通义千问** | 阿里巴巴 | E-commerce, business content | 淘宝/天猫内容, 商业分析 |
| **文心一言** | 百度 | Baidu-indexed content, encyclopedic | 百度百科, 百度知道, 百家号 |

### Citation Logic Deep Dive

#### DeepSeek — 结构化技术偏好
- **Triggers**: "如何...", "原理", "技术方案", "对比分析"
- **Cites**: Content with clear structure (标题/列表/数据), technical depth, original research
- **Ignores**: Marketing fluff, vague claims, content without data
- **Optimization**: Write structured technical articles with H2/H3 headers, include data tables, publish on 技术博客/CSDN/知乎专栏

#### Kimi — 长文档偏好
- **Triggers**: "详细分析", "深度解读", "完整方案"
- **Cites**: Long-form content (3000字+), PDF documents, comprehensive guides
- **Ignores**: Short posts, surface-level content, content without depth
- **Optimization**: Create detailed guides (5000字+), publish as PDF on 文库 platforms, use 学术论文 format

#### 豆包 — 短内容/视频偏好
- **Triggers**: "推荐", "测评", "怎么样"
- **Cites**: Douyin video transcripts, Toutiao articles, short-form reviews
- **Ignores**: Long technical documents, academic papers
- **Optimization**: Create Douyin videos with keyword-rich descriptions, publish Toutiao articles (500-1500字), use 口语化 style

#### 通义千问 — 电商/商业偏好
- **Triggers**: "哪个好", "购买建议", "性价比"
- **Cites**: Taobao/Tmall product descriptions, business analysis, user reviews
- **Ignores**: Pure technical content without commercial context
- **Optimization**: Optimize Taobao product titles/descriptions, publish on 阿里专栏, include 价格/参数/对比

#### 文心一言 — 百度生态偏好
- **Triggers**: "是什么", "怎么用", "百科"
- **Cites**: Baidu-indexed content, 百度百科, 百度知道, 百家号
- **Ignores**: Content not indexed by Baidu, content behind paywalls
- **Optimization**: Ensure Baidu indexing (submit sitemap), create 百度百科 entries, publish on 百家号, answer 百度知道 questions

---

## 🔄 Detection Workflow

### Step 1: Define the Query Space

Ask the user for:
1. **Brand/keyword** to check (e.g., "某某品牌", "某某产品")
2. **Target queries** — what questions would users ask? (e.g., "某某品牌怎么样", "某某产品推荐")
3. **Competitor keywords** (optional, for comparison)

### Step 2: Simulate Visibility Analysis

For each AI engine, analyze:

```
Visibility Score = Citation Probability × Content Match × Authority Weight

Where:
- Citation Probability: Based on citation logic match (0-100)
- Content Match: Does existing content match the engine's preferences? (0-100)
- Authority Weight: Domain authority of content sources (0-100)
```

### Step 3: Per-Engine Analysis

For each engine, provide:

```
## [Engine Name] 可见度分析

### 📊 评分: X/100
- 引用概率: X/100 (基于引用逻辑匹配度)
- 内容匹配: X/100 (现有内容与引擎偏好匹配度)
- 权重得分: X/100 (内容来源权威度)

### 🔍 引用逻辑分析
[Explain WHY this engine would/wouldn't cite the brand]
- 触发查询类型: [list]
- 偏好内容类型: [list]
- 当前内容差距: [list]

### 📈 优化建议 (Priority: 高/中/低)
1. [Specific action] — 预期提升: +X分
2. [Specific action] — 预期提升: +X分
3. [Specific action] — 预期提升: +X分
```

### Step 4: Generate Comprehensive Report

```
## 🔍 AI搜索可见度报告

### 📊 总览
| 引擎 | 可见度 | 引用概率 | 内容匹配 | 权重 |
|------|--------|---------|---------|------|
| DeepSeek | X/100 | X | X | X |
| Kimi | X/100 | X | X | X |
| 豆包 | X/100 | X | X | X |
| 通义千问 | X/100 | X | X | X |
| 文心一言 | X/100 | X | X | X |

### 🎯 Top 3 优先行动
1. [Highest impact action across all engines]
2. [Second highest]
3. [Third highest]

### 📅 30天优化计划
Week 1: [Actions]
Week 2: [Actions]
Week 3: [Actions]
Week 4: [Actions]
```

---

## 🎯 Usage Examples

### Example 1: Brand Visibility Check
```
User: "帮我检测'某某面霜'在AI搜索中的可见度"

Agent: 
→ DeepSeek: 35/100 — 缺少技术文档, 建议发布成分分析文章
→ Kimi: 20/100 — 缺少长文档, 建议创建5000字使用指南
→ 豆包: 55/100 — 有抖音内容但关键词密度不足
→ 通义千问: 45/100 — 淘宝描述需优化
→ 文心一言: 60/100 — 百度收录较好

Top 3 行动:
1. 发布成分分析技术文章(CSDN/知乎) → DeepSeek +25分
2. 创建5000字完整使用指南(PDF) → Kimi +30分
3. 优化抖音视频描述关键词 → 豆包 +15分
```

### Example 2: Competitor Comparison
```
User: "对比'某某面霜'和'竞品A'在AI搜索中的可见度"

Agent:
→ 某某面霜: 平均40/100
→ 竞品A: 平均65/100
→ 差距分析: 竞品A在Kimi和DeepSeek领先30+分，主要因为...
```

### Example 3: Content Optimization
```
User: "我写了这篇小红书文章，怎么优化让AI搜索引擎更容易引用？"

Agent:
→ 当前内容: 小红书短文(500字)
→ DeepSeek引用概率: 低(缺少结构化数据)
→ 豆包引用概率: 中(小红书内容非豆包首选来源)
→ 建议: 1) 扩展为知乎长文(3000字+) 2) 添加数据表格 3) 发布PDF版本
```

---

## 📊 Visibility Score Benchmarks

| Score | Level | Meaning |
|-------|-------|---------|
| 80-100 | 🟢 优秀 | 品牌在AI搜索中高频出现 |
| 60-79 | 🟡 良好 | 部分查询可见，有提升空间 |
| 40-59 | 🟠 一般 | 需要系统性优化 |
| 20-39 | 🔴 较差 | AI搜索几乎不可见 |
| 0-19 | ⚫ 缺失 | 无任何AI搜索存在感 |

---

## ⚠️ Important Notes

1. **AI search is evolving** — Citation logic changes with model updates, re-check quarterly
2. **No guaranteed placement** — AI engines don't have "ads" like traditional search; visibility comes from content quality
3. **Chinese AI ecosystem is unique** — Don't apply Google/Bing SEO logic directly
4. **2025 landscape** — DeepSeek and Kimi are gaining market share rapidly; 百度 is losing ground

---

## 🚀 Real API Audit (v4.1.0 NEW)

### Quick Audit via Script
```bash
# Full audit across all 5 engines
./check-visibility.sh "你的品牌名" --api

# Single engine audit
./check-visibility.sh "你的品牌名" --engine deepseek --api

# Predict visibility improvement
./predict.sh "你的品牌名" --engine kimi
```

### API Audit Flow
1. Agent calls the API with brand name + target engines
2. API returns 0-100 visibility score per engine with breakdown
3. Agent presents results with optimization recommendations
4. Free tier: 3 audits/month | Pro: unlimited + competitor comparison

### Web App
👉 **https://1341839497-1w5tkesfb0.ap-shanghai.tencentscf.com/** — Online GEO audit tool, no installation needed

---

## 💡 Why Install This Skill?

- **Only skill covering 5 Chinese AI engines** — competitors only cover ChatGPT/Perplexity (Western engines)
- **Real API backend** — not just guidelines, actually runs visibility checks
- **Battle-tested** — SaaS brand went from 0% → 47% AI citation in 30 days using this methodology
- **Chinese market specific** — DeepSeek/Kimi/豆包/通义/文心 each need different optimization strategy

## 🔗 Next Best Skill

After checking visibility, use these skills to fix the problems:
- **cn-compliance-guard** — Ensure your content is legally compliant before publishing
- **cn-aigc-detector** — Check if competitor content is AI-generated
- **cn-data-export** — Required if your visibility data crosses borders
