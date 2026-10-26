#!/usr/bin/env bash
set -euo pipefail
# TradingAgents 一键部署脚本（第三方指南）——按官方文档封装
# 官方文档：https://github.com/TauricResearch/TradingAgents#installation-and-cli
# 更新日期：2026-10-26
# 类型：script
cd "$(dirname "${BASH_SOURCE[0]}")"

command -v git >/dev/null 2>&1 || { echo "需要先安装 Git"; exit 1; }
command -v python3 >/dev/null 2>&1 || command -v python >/dev/null 2>&1 || { echo "需要先安装 Python 3"; exit 1; }

mkdir -p .download
cd .download

git clone https://github.com/TauricResearch/TradingAgents
cd TradingAgents
python3 -m venv .venv
.venv/bin/pip install .
cp .env.example .env 2>/dev/null || true
echo "请编辑 .env 填入模型 API Key，然后运行 .venv/bin/tradingagents"

echo ""

echo "安装完成：编辑 .env 填入模型 API Key，然后运行 .venv/bin/tradingagents 启动（Windows 为 .venv\Scripts\tradingagents.exe）"
echo "若结果异常或需要改配置，请参考官方文档：https://github.com/TauricResearch/TradingAgents#installation-and-cli"
