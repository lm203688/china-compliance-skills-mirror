# 🛡️ 中国合规 Skills

**4个精品AI Agent合规技能 — 2000+企业正在使用。**

> 方法论 + 检测流程 + 结果解读 — 不是简单prompt，是完整合规闭环。

[![GitHub stars](https://img.shields.io/github/stars/lm203688/china-compliance-skills-mirror?style=social)](https://github.com/lm203688/china-compliance-skills-mirror/stargazers)
[![GitHub forks](https://img.shields.io/github/forks/lm203688/china-compliance-skills-mirror?style=social)](https://github.com/lm203688/china-compliance-skills-mirror/fork)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](./LICENSE)

[English](./README.md) | **中文**

---

## 🎯 为什么需要这个？

每一条中文内容都面临**3个法律雷区**：
1. **广告法** — "最好"、"第一"、"国家级" = 罚款20-100万
2. **数据出境** — 未经网信办安全评估向境外传输数据 = 违法
3. **AI生成标注** — 2025新规要求AI内容必须标注

**大多数AI Agent不知道这些规则。** 这些Skill给它们专业知识。

---

## 📦 4个Skill

### 1. 🛡️ cn-compliance-guard — 内容合规守卫
扫描中文文本的200+违禁词（6个法律类别），检查5个平台SEO合规性，提供安全替换建议。

```
输入:  "我们是最好的产品，100%有效，3天见效！"
输出: ⚠️ 3个高风险违禁词 + 法律依据 + 罚款金额 + 安全替换建议
```

### 2. 🔍 cn-ai-visibility — AI搜索可见度检测
分析品牌/关键词在5个中国AI搜索引擎（DeepSeek/Kimi/豆包/通义千问/文心一言）的可见度，提供针对性优化策略。

```
输入:  "某某品牌"
输出: 5引擎可见度评分 + 引用逻辑分析 + 针对性优化建议
```

### 3. 🛡️ cn-data-export — 数据出境合规评估
7问风险评估，覆盖PIPL/网络安全法/数据安全法，确定合规路径（安全评估/标准合同/认证）。

```
输入:  7个问题答案（数据类型/规模/目的地等）
输出: 风险评分 + 合规路径推荐 + 优先级行动清单
```

### 4. 🤖 cn-aigc-detector — AI生成内容检测
5项统计信号分析中文文本是否AI生成：句长方差、词汇多样性、结构化模式、句首一致性、标点密度。

```
输入:  一段中文文本（50字以上）
输出: AI生成概率 + 5项信号分析 + 可疑片段标注
```

---

## 🚀 快速开始

### Claude Code / Cursor / OpenClaw

在Agent的skill配置中添加：

```json
{
  "skills": [
    "cn-compliance-guard",
    "cn-ai-visibility", 
    "cn-data-export",
    "cn-aigc-detector"
  ]
}
```

### 手动安装

```bash
git clone https://github.com/lm203688/china-compliance-skills-mirror.git
cp -r china-compliance-skills/skills/* ~/.claude/skills/
```

---

## 🔗 在线Web应用

| Skill | Web应用 | 定价 |
|-------|---------|------|
| cn-compliance-guard | [合规通](https://1341839497-jv04655vcs.ap-shanghai.tencentscf.com/) | 免费5次/月, Pro ¥49/月 |
| cn-ai-visibility | [AI搜索可见度](https://1341839497-2d5g5k6b1k.ap-shanghai.tencentscf.com/) | 免费3次/月, Pro ¥149/月 |
| cn-data-export | [数据出境自评](https://1341839497-xq8m5j4e2n.ap-shanghai.tencentscf.com/) | 免费, Pro ¥199/月 |
| cn-aigc-detector | [AI内容检测](https://1341839497-7v3p9w5k2m.ap-shanghai.tencentscf.com/) | 免费5次/月, Pro ¥99/月 |

---

## 📊 覆盖范围

- **200+** 违禁词，6个法律类别
- **5** 个中国AI搜索引擎分析
- **3** 部主要数据保护法律（PIPL、网络安全法、数据安全法）
- **5** 项AI检测信号加权评分
- **5** 个平台SEO规则集（百度/小红书/抖音/淘宝/京东）

---

## ⚖️ 法律声明

这些Skill仅提供合规**筛查和建议**，不构成法律意见。具体合规决策请咨询中国执业律师。

---

## 📄 许可证

MIT License — 自由使用，请注明出处。

---

## 🙏 致谢

灵感来自：
- [ConardLi/garden-skills](https://github.com/ConardLi/garden-skills) — "少而精" Skill设计哲学
- [Anthropic-Cybersecurity-Skills](https://github.com/anthropics/anthropic-cybersecurity-skills) — 垂直领域Skill库模式

由[非常AI团队](https://github.com/feichangai-team)构建。如果这些Skill对你有帮助，请⭐ Star！
