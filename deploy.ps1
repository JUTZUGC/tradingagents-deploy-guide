# TradingAgents 一键部署脚本（第三方指南）——按官方文档封装
# 官方文档：https://github.com/TauricResearch/TradingAgents#installation-and-cli
# 更新日期：2026-10-28
# 类型：script
$ErrorActionPreference = 'Stop'
Set-Location -Path $PSScriptRoot

if (-not (Get-Command git -ErrorAction SilentlyContinue)) { throw '需要先安装 Git' }
if (-not (Get-Command python -ErrorAction SilentlyContinue)) { throw '需要先安装 Python 3' }

New-Item -ItemType Directory -Force -Path .download | Out-Null
Set-Location -Path .download

git clone https://github.com/TauricResearch/TradingAgents
Set-Location TradingAgents
python -m venv .venv
.venv\Scripts\python.exe -m pip install . ; if ($LASTEXITCODE -ne 0) { throw '依赖安装失败，请查看上面的输出' }
if (Test-Path .env.example) { Copy-Item .env.example .env -Force }
Write-Host '请编辑 .env 填入模型 API Key，然后运行 .venv\Scripts\tradingagents.exe'

Write-Host ''

Write-Host '安装完成：编辑 .env 填入模型 API Key，然后运行 .venv/bin/tradingagents 启动（Windows 为 .venv\Scripts\tradingagents.exe）'
Write-Host '若结果异常或需要改配置，请参考官方文档：https://github.com/TauricResearch/TradingAgents#installation-and-cli'
