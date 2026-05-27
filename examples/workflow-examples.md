# 🔗 Multi-Skill Workflow Examples

## Workflow 1: 新品发布合规全检

**场景**: 新产品上线前，需要确保所有营销内容合规、AI搜索可见、且标注AI生成内容。

```
Step 1: cn-aigc-detector
→ 检测营销文案是否由AI生成
→ 如果AI生成概率>60%，需要标注"AI辅助创作"

Step 2: cn-compliance-guard
→ 扫描所有文案的违禁词
→ 检查各平台SEO合规性
→ 获取安全替换建议

Step 3: cn-ai-visibility
→ 检查品牌在5个AI搜索引擎的可见度
→ 获取针对性优化建议

Step 4: cn-data-export (if applicable)
→ 如果涉及用户数据跨境传输，评估合规路径
```

## Workflow 2: 竞品内容审计

**场景**: 分析竞品内容策略，找出合规漏洞和AI使用痕迹。

```
Step 1: cn-aigc-detector
→ 检测竞品内容是否AI生成
→ 找出AI生成比例最高的内容类型

Step 2: cn-compliance-guard
→ 扫描竞品内容的违禁词
→ 发现合规漏洞可作为竞争情报

Step 3: cn-ai-visibility
→ 对比你和竞品在AI搜索中的可见度
→ 找出差距最大的引擎，优先优化
```

## Workflow 3: 跨境业务合规评估

**场景**: 中国公司出海，需要评估数据出境合规性。

```
Step 1: cn-data-export
→ 完成7问风险评估
→ 确定合规路径

Step 2: cn-compliance-guard
→ 检查隐私政策/数据处理声明的合规性
→ 确保用户告知义务满足PIPL要求

Step 3: cn-ai-visibility
→ 检查海外市场AI搜索可见度
→ 优化海外GEO策略
```

## Workflow 4: 内容团队SOP

**场景**: 建立内容团队的合规审查标准流程。

```
每次发布内容前:

1. [作者自查] cn-compliance-guard 快速扫描
   → 0个违禁词 → 通过
   → 1-2个低风险 → 修改后通过
   → 任何高风险 → 必须修改

2. [编辑审核] cn-aigc-detector 检测
   → AI概率<40% → 通过
   → AI概率40-60% → 人工重写30%+
   → AI概率>60% → 必须标注或重写

3. [月度] cn-ai-visibility 品牌监控
   → 追踪5引擎可见度变化
   → 低于60分的引擎优先优化

4. [季度] cn-data-export 合规复查
   → 更新风险评估
   → 检查政策变化
```
