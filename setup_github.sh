#!/bin/bash
# LazyLearning GitHub 一键发布脚本
# 用法：bash setup_github.sh

set -e

SKILL_DIR="$(cd "$(dirname "$0")" && pwd)"
SKILL_FILE="$(dirname "$SKILL_DIR")/lazylearning.skill"

echo "🚀 LazyLearning GitHub 发布流程"
echo ""

# ── 检查 gh CLI ──
if ! command -v gh &>/dev/null; then
    echo "📦 安装 gh CLI..."
    brew install gh
fi

# ── 检查登录状态 ──
if ! gh auth status &>/dev/null; then
    echo "🔑 请登录 GitHub（会打开浏览器）..."
    gh auth login
fi

echo "✅ GitHub 已登录"
echo ""

# ── 创建仓库并推送 ──
echo "📁 创建 GitHub 仓库..."
cd "$SKILL_DIR"

gh repo create lazylearning \
    --public \
    --description "把任何内容存入 Obsidian，需要时用 AI 问答 | A Claude skill for Obsidian knowledge management" \
    --push \
    --source=.

echo ""
echo "📦 发布 v0.1.0..."

gh release create v0.1.0 "$SKILL_FILE" \
    --title "v0.1.0 · 首个公开版本" \
    --notes "## 安装方法

1. 下载下方的 \`lazylearning.skill\` 文件
2. 在 Claude Cowork 中点击「Save skill」安装
3. 重启 Claude，新开对话即可使用

## 使用说明

- 发送任何链接、文字或截图 → 自动整理存入 Obsidian
- 直接提问 → 从你的笔记库里找答案

首次使用会引导配置 Obsidian 路径，只需操作一次。"

echo ""
REPO_URL=$(gh repo view --json url -q .url)
echo "🎉 发布完成！"
echo ""
echo "   仓库地址：$REPO_URL"
echo "   Release：$REPO_URL/releases/latest"
echo ""
echo "把仓库地址发给 Lena 的 Claude 对话，更新 README 安装链接。"
