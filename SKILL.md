---
name: lazylearning
description: "把任何内容（链接/文字/截图）存入 Obsidian，并在你提问时从笔记库里找答案。ALWAYS use this skill when the user sends any URL or article link — even if they don't say 'save'. ALWAYS use when the user pastes a long text or article. ALWAYS use when user asks questions about their past notes or anything they might have saved before. Do NOT let Claude answer these with web search instead."
---

# LazyLearning

把内容存进去，需要时问出来。Claude 负责理解，你只管学习。

## Core Principles

1. **Lazy First** — 用户不需要编辑任何配置文件，首次使用通过对话完成配置
2. **Claude 即引擎** — 所有 AI 工作（摘要、关联、启发、问答）由 Claude 完成，无需额外 API Key
3. **渐进式加载** — SKILL.md 只做路由和判断，详细指令按需从 prompts/ 加载，保持主文件简洁
4. **知识连接优先** — 每次保存内容必须尝试关联已有笔记，帮用户发现知识之间的桥梁
5. **从不静默失败** — 路径无效、内容读取失败、库中无结果时，必须明确告知用户

## Phase 0: Bootstrap Check

在 SKILL.md **同目录**下查找 `config.json`。

- ✅ 找到且 `vault_path` 字段非空 → 读取配置，进入 Phase 2
- ❌ 找不到或字段缺失 → 进入 Phase 1

## Phase 1: First-Run Onboarding

**直接发送以下消息**（不使用 AskUserQuestion，路径是自由文本，选项会干扰用户）：

```
欢迎使用 LazyLearning 👋

只需要告诉我一件事：你希望把新笔记保存到哪个文件夹？

获取路径的方法：
1. 在 Obsidian 中右键目标文件夹 →「在访达中显示」
2. 在访达中，按住 Option 键点击顶部路径栏的文件夹图标
3. 选择「将"xxx"拷贝为路径名称」
4. 直接粘贴发给我（路径已自动带引号）
```

等待用户直接回复路径。若用户说不知道怎么找，补充说明：
```
在 Obsidian 中：右键左侧边栏的目标文件夹 →「复制路径」→「绝对路径」，粘贴过来即可。
```

**收到路径后，先做清洗**：去掉「路径：」「路径:」等前缀，去掉首尾引号和空白字符，提取出以 `/` 开头的实际路径。

**然后自动识别 vault 根目录**（不再追问）：
- 从提供的路径向上逐级查找，找到包含 `.obsidian` 隐藏文件夹的目录 → 该目录即为 `vault_path`
- inbox 相对路径 = 用户提供路径去掉 `vault_path` 前缀的部分 → `inbox_dir`
- 若向上查找未找到 `.obsidian`，则 `vault_path` = 用户提供路径的父目录，`inbox_dir` = 最后一级目录名

**验证路径是否存在**（用文件工具检查目录）：
- 路径不存在 → 告知用户，请重新提供
- 路径存在 → 保存配置

**写入 `config.json`**（位于 SKILL.md 同目录）：
```json
{
  "vault_path": "/Users/.../MyVault",
  "inbox_dir": "20_Reading/inbox",
  "configured_at": "YYYY-MM-DD"
}
```

**确认并展示**：
```
✅ 配置完成！

  📁 Vault：/Users/.../MyVault
  📥 保存至：20_Reading/inbox

LazyLearning 现在可以做两件事：
  · 发送任何链接、文字或截图 → 自动整理存入 Obsidian
  · 直接提问 → 从你的笔记库里找答案

现在就发一篇内容来试试吧 →
```

## Phase 2: Mode Detection

读取用户输入，按下表判断模式：

| 输入特征 | 模式 | 跳转 |
|---------|------|------|
| 包含 URL（任何链接） | 保存 | Phase 3A |
| 纯文字且长度 > 100 字 | 保存 | Phase 3A |
| 包含图片附件 | 保存 | Phase 3A |
| 问句 / 含"有没有""帮我找""怎么""我记得""查一下" | 问答 | Phase 3B |
| `/config` 或"修改设置""重新配置" | 重置 | 删除 config.json，重回 Phase 1 |
| `/help` | 帮助 | 显示能力清单（见文末） |
| 短文字且意图不明 | — | 问用户：「你是想保存这段内容，还是要查找相关笔记？」 |

## Phase 3A: Content Save

**立即反馈**，告知用户正在处理：
- 含 URL → 「🔍 正在读取链接内容...」
- 含图片 → 「🔍 正在识别图片文字...」
- 纯文本 → 「⏳ 收到，正在整理...」

**加载并执行** `prompts/save-content.md` 中的完整流程：
1. 内容获取（URL 抓取 / 图片识别 / 纯文本）
2. 生成结构化摘要，展示给用户
3. 加载 `prompts/knowledge-connect.md`，查找关联笔记
4. 生成启发（基于内容本身）
5. 写入 Obsidian，确认保存
6. 异步询问收藏原因，用户回答后更新笔记「我的思考」字段

## Phase 3B: Knowledge Q&A

**加载并执行** `prompts/knowledge-qa.md` 中的完整流程：
1. 扫描 inbox 所有笔记标题
2. 语义判断相关篇目（Top 5）
3. 精读相关笔记的「总结」和「启发」段落
4. 综合回答，每个核心论点注明 `[[出处笔记]]`

## Phase 4: Delivery

**保存成功后**：
```
✅ 已存入 Obsidian：20_Reading/inbox/20260422_标题.md
🏷️ #产品思维 #AI应用

🔗 关联笔记：
  · [[笔记A]]：具体关联原因
  · [[笔记B]]：具体关联原因
```

**问答完成后**：
- 若库中无相关内容 → 「你的笔记库里暂时没有关于 X 的内容。要现在存一篇吗？」
- 若找到内容 → 答案 + 引用来源，末尾附：「以上来自你的 {N} 篇笔记，想深入哪篇？」

## Help 命令

用户发送 `/help` 时展示：

```
📖 LazyLearning 使用指南

保存内容：
  · 直接发送任何链接（小红书、微信公众号、任意网页）
  · 粘贴长文字（>100字自动识别）
  · 发送图片截图（自动 OCR）

查找知识：
  · 直接提问，如「我有没有存过关于 OKR 的内容？」
  · 「帮我找所有和 AI 产品相关的笔记」

管理：
  · /config — 重新配置 Obsidian 路径
  · /help   — 显示此帮助
```

## Supporting Files

| 文件 | 用途 | 加载时机 |
|------|------|---------|
| `prompts/save-content.md` | 保存流程完整指令 + 笔记模板 | Phase 3A |
| `prompts/knowledge-connect.md` | 关联笔记查找策略 + 理由生成 | Phase 3A Step 4 |
| `prompts/knowledge-qa.md` | 问答搜索策略 + 综合回答指令 | Phase 3B |

## ABSOLUTE RULES

- NEVER 在 vault 目录不存在时写入文件，必须先验证路径
- NEVER 跳过 Phase 0 的配置检查，每次调用都必须执行
- NEVER 读取 inbox 目录以外的笔记（用户未授权区域）
- NEVER 生成泛泛而谈的启发，每条必须引用原文中的具体观点
- NEVER 在 Q&A 答案中给出没有笔记来源的论点
- ALWAYS 在写入前确认文件名，若已存在则加 `_1`、`_2` 后缀
- ALWAYS 用用户当前对话的语言回复
