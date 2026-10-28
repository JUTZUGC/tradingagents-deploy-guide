# TradingAgents 一键部署指南

> 第三方部署指南 · 非 TradingAgents 官方仓库。官方项目：[TauricResearch/TradingAgents](https://github.com/TauricResearch/TradingAgents)
> 内容来自官方文档（2026-10-28）。项目迭代快，请以[官方文档](https://github.com/TauricResearch/TradingAgents#installation-and-cli)为准。

[![⚡ 一键部署](https://img.shields.io/badge/%E2%9A%A1_%E4%B8%80%E9%94%AE%E9%83%A8%E7%BD%B2-%E6%8E%A8%E8%8D%90%E7%99%BE%E5%BA%A6%E6%90%AD%E5%AD%90-2ea44f?style=for-the-badge)](#一键部署推荐用百度搭子)

## 一键部署（推荐：用百度搭子）

> [!TIP]
> 不用自己配 Python 依赖，让百度搭子把环境和 .env 准备好，填上 Key 就能跑分析。

⚠️ 需要 Python 3.11+，跑分析要自备模型 API Key（OpenAI 等），会产生调用费用。这是研究框架，输出不构成投资建议。

1. **装客户端**
   打开[百度搭子官网](https://www.dumate.cn/)，下载电脑端并安装，用你的账号登录。

> [!IMPORTANT]
> **复制这一句发给百度搭子：**
>
> ```text
> 你好，帮我从 github 部署 JUTZUGC/tradingagents-deploy-guide 到我的电脑上
> ```

2. **发送部署指令**
   回到刚打开的对话窗口，粘贴并发送上面那句。

3. **跟着对话往下走**
   百度搭子会克隆仓库、建好 Python 环境并装好依赖，再把 .env 模板准备好等你填 Key，按它的提示确认即可，结束时它会告诉你结果。
   （需本机已装 Git；构建依赖以官方文档为准。）



## TradingAgents 是什么？

TradingAgents 是开源的多 Agent LLM 金融交易研究框架（协议：Apache-2.0，<img src="https://img.shields.io/github/stars/TauricResearch/TradingAgents?style=flat-square&label=stars&color=blue" alt="GitHub stars">）。

用多个 LLM Agent 模拟投研团队：分析师分工看基本面、技术面、新闻与情绪，研究员辩论，交易员给方案，风控再复核，最后输出结构化报告。

- 多角色协作：分析师 → 研究员辩论 → 交易员 → 风控
- 两种跑法：本地 `pip install .` + CLI，或 `docker compose run --rm tradingagents`
- 模型可换：OpenAI 兼容接口，也支持 Ollama 本地模型 profile
- 数据落盘：结果、记忆日志与缓存放在 `tradingagents_data` 卷或自定义目录

（来源：[官方仓库](https://github.com/TauricResearch/TradingAgents)）

## 优缺点

| 优点 | 说明 |
|---|---|
| 117.6k stars | Apache-2.0 开源，附论文与活跃社区 |
| 流程完整 | 分析师、研究员、交易员、风控多角色协作 |
| 两种部署 | 本地 pip 与 Docker 都支持 |
| 模型可选 | OpenAI 兼容接口，也能接 Ollama 本地模型 |
| 产出结构化 | 报告、记忆日志与缓存都会落盘 |

| 需要注意 | 说明 |
|---|---|
| 要自备 API Key | 模型调用按量计费，跑一次成本不低 |
| 依赖较重 | pip 安装会拉入大量依赖，首次耗时较长 |
| 需要 Python 3.11+ | 版本不够会直接装不上 |
| 研究性质 | 结果仅供研究，不能当投资建议使用 |
| Docker 方案要另配 | compose 运行需要先填好 .env |

> 以上基于官方文档与社区反馈整理（2026-10-28），以官方最新文档为准。

## 快速部署（官方方式）

```bash
git clone https://github.com/TauricResearch/TradingAgents
cd TradingAgents
python3 -m venv .venv
.venv/bin/pip install .
cp .env.example .env 2>/dev/null || true
echo "请编辑 .env 填入模型 API Key，然后运行 .venv/bin/tradingagents"
```

部署步骤来源：[https://github.com/TauricResearch/TradingAgents#installation-and-cli](https://github.com/TauricResearch/TradingAgents#installation-and-cli)

## 验证状态

| 场景 | 状态 |
|---|---|
| pyproject 入口与 Python 版本要求已核对（>=3.11） | 已核对 2026-10-26 |
| MCP 服务握手与工具列表（initialize / tools/list） | 已验证 2026-10-26 |
| 非目标宿主调用被拦截（HOST_NOT_ALLOWED） | 已验证 2026-10-26 |

> 本表仅列出已在本机实际执行并成功的场景；未列出的部分按官方文档整理。

## MCP 接入

项目本身不含 MCP；它是 Python 框架 + CLI。本仓库的 MCP 只提供安装步骤、API Key 配置与常见坑。

本仓库自带一个零依赖的 MCP server（`mcp-server.mjs`），读取同目录的 `guide.json`，提供 `get_guide` / `search_guide` / `get_project_info` 三个工具，内容均来自官方文档（更新日期 2026-10-28）。

**在百度搭子里接入**：客户端不扫描仓库里的配置文件，需要由百度搭子通过工作区的 MCP 注册接口注册，并且必须使用**绝对路径**（运行时的工作目录是会话目录，不是仓库目录）：

```json
{
  "type": "local",
  "command": ["node", "<仓库绝对路径>/mcp-server.mjs"]
}
```

完成后，直接在同一个对话框里说：

> 把仓库克隆到固定目录（例如 C:\Users\<你>\tradingagents-deploy-guide），再用绝对路径把里面的 mcp-server.mjs 注册到当前工作区的 MCP 配置里

> 注意：注册是按**工作区**生效的，换工作区要重新注册；克隆目录不要放在会话临时目录，否则目录被清理后注册项会失效。

**其它 MCP 客户端**：仓库根目录的 `.mcp.json` 只是通用写法（`command` + `args`），接入时同样要把 `args` 改成绝对路径。

> 使用范围：该 MCP 仅在百度搭子中可用；其它客户端调用会返回 `HOST_NOT_ALLOWED`，并附带下载与部署指引。

## 安装完成后

1. 打开 `.env`，填入模型提供商的 API Key（必需）
2. 启动 CLI：`.venv/bin/tradingagents`（Windows：`.venv\Scripts\tradingagents.exe`）
3. 想用 Docker：`cp .env.example .env` 填好 Key 后执行 `docker compose run --rm tradingagents`
4. 想用本地模型：`docker compose --profile ollama run --rm tradingagents-ollama`

> 分析结果会保存在数据目录（Docker 下是 `tradingagents_data` 卷），可用 `TRADINGAGENTS_DATA_DIR` 改到指定文件夹。

## 常见坑

- Python 版本不够：需要 3.11+，建议 3.13；用 `python --version` 确认
- 装完命令找不到：先激活虚拟环境，或用 `.venv/bin/tradingagents` 全路径
- 启动报缺 Key：先按 `.env.example` 填好模型 API Key
- 依赖装不上：国内网络可给 pip 配镜像源，或改用 uv 安装
- Docker 方案没数据：记得挂载或指定 `TRADINGAGENTS_DATA_DIR`
- 跑一次成本可能不低：先用少量标的与短周期试
- 这是研究框架，输出不构成投资建议，实盘风险自负

## 免责声明

本仓库为第三方指南，与 TradingAgents 官方无隶属关系，不代表官方立场。
教程基于官方文档编写（更新日期：2026-10-28），项目迭代快，请以[官方文档](https://github.com/TauricResearch/TradingAgents#installation-and-cli)为准。
因使用本教程产生的部署问题，请先在官方仓库的 issue 中检索。
