# LazyLearning

**把内容存进去，需要时问出来。**

一个让 Claude 读懂你 Obsidian 笔记库的 Skill。发链接自动整理成结构化笔记，发问题从你自己存过的内容里找答案。无需额外 API Key，Claude 就是引擎。

---

## 能做什么

### 📥 保存内容
发任何链接或文字，自动完成：
- 抓取小红书、微信公众号、任意网页的完整正文
- 识别图片截图中的文字（Claude 原生多模态）
- 生成结构化摘要 + 个性化启发
- 查找笔记库中的关联内容，标注具体关联理由
- 按统一模板写入 Obsidian

### 🔍 查找知识
直接提问，从你自己存过的内容里找答案：
- 找某篇具体笔记
- 用多篇笔记回答一个问题，每个论点注明出处
- 梳理某个主题下的全部积累

---

## 环境要求

- **Claude 客户端**：支持 Skill 的版本（Cowork、Claude Code 等）
- **Obsidian**：本地笔记库，知道收件箱文件夹的完整路径即可
- **文件访问权限**：Claude 需要能读写你的 Obsidian 目录

不需要任何额外 API Key。

---

## 安装

### 方式一：Cowork 一键安装（推荐）

1. 下载 [lazylearning.skill](https://github.com/Connie810/lazy_learning/releases/download/LazyLearning/lazylearning.skill)
2. 在 Cowork 中点击「Save skill」安装
3. 重启 Claude，新开对话即可使用

### 方式二：Claude Code

```bash
claude skill add /path/to/lazylearning
```

### 方式三：手动添加

将 `lazylearning/` 文件夹复制到你的 Claude Skill 目录（通常是 `~/.claude/skills/`）。

---

## 首次使用

第一次使用时，LazyLearning 只问你一件事：

> 「你希望把新笔记保存到哪个文件夹？」

粘贴路径，它会自动识别 Vault 根目录和子目录，无需手动配置。

配置只做一次，之后直接用。

---

## 使用示例

### 保存一篇小红书笔记
```
你：https://www.xiaohongshu.com/explore/xxx

LazyLearning：🔍 正在读取链接内容...

📚 摘要
独立开发者冷启动的 3 个反直觉原则...
  • 先收钱再开发：用预售验证需求...
  • ...

💭 你收藏这篇的原因是什么？（直接回复，或发「跳过」）

你：准备做独立产品，想看看别人怎么起步的

LazyLearning：
- 预售验证这一步直接对应你「起步」的问题：...
- ...


✅ 已存入 Obsidian：20_Reading/inbox/20260422_独立开发冷启动原则.md
🔗 关联笔记：
  · [[20260310_产品定价策略]]：两篇都涉及冷启动，可对比定价和获客的不同切入点
```

### 从笔记库查找
```
你：我有没有存过关于 OKR 的内容？

LazyLearning：找到了 2 篇：

  1. [[OKR复盘方法论]]：季度 OKR 的 3 种失败模式及修复方法
     你当时的想法：Q3 复盘时用
  2. [[目标管理的常见误区]]：OKR vs KPI 的核心区别...

想深入哪一篇？
```

---

## 笔记格式

每篇保存的笔记结构如下：

```markdown
# 标题
来源链接

## 总结
一句话总结

- 要点1
- 要点2
- 要点3

## 启发
- ...

## 相关内容
- [[关联笔记]]：具体关联理由

## 原文
完整正文
```

---

## 常见问题

**Q：小红书链接读取失败？**
把笔记正文直接复制粘贴发给 LazyLearning，同样能处理。

**Q：微信文章提示"仅限微信内打开"？**
在微信里复制文章正文，粘贴发给 LazyLearning。

**Q：想修改收件箱路径？**
发送 `/config`，重新配置。

**Q：问答功能能搜索哪些笔记？**
扫描整个 Vault（你的 Obsidian 库），不限于收件箱目录。新笔记只写入你指定的收件箱文件夹。

**Q：支持英文内容吗？**
支持。LazyLearning 会用你对话的语言回复，笔记内容语言保持原文。

---

## License

MIT — 自由使用、修改和分发。欢迎 PR 和 Issue。
