# 硬件排名查询工具 / Hardware Rank Checker

## 项目概述 / Overview
通过 PowerShell 检测本机显卡（笔记本移动版）和 CPU（桌面版）型号，调用 apihz.cn 天梯 API 查询排名。  
Detect local GPU (mobile) and CPU (desktop) models via PowerShell, then query their tier rankings from apihz.cn API.

## 适用环境 / Requirements
- **操作系统 / OS**：Windows 10 / Windows 11  
- **PowerShell**：5.1 或更高 / 5.1 or later  
- **网络 / Network**：需能访问 `cn.apihz.cn` / Must be able to reach `cn.apihz.cn`

## 文件清单 / File List
| 文件名 / Script        | 用途 / Purpose                         |
| ----------------------- | -------------------------------------- |
| `cpu-gpu-rank.ps1`  | 一键查询显卡 + CPU / Check both at once |
| `cpu-gpu-rank.md`      | 维护文档 / Maintenance doc             |

## 脚本核心流程 / Core Logic
1. 通过 `Get-CimInstance` 获取硬件名称（显卡用 `Win32_VideoController`，CPU 用 `Win32_Processor`）。  
   Retrieve hardware name via `Get-CimInstance` (GPU: `Win32_VideoController`, CPU: `Win32_Processor`).
2. 调用对应 API 获取天梯数据。  
   Call the corresponding API to fetch tier list data.
3. 使用忽略大小写的安全包含匹配（`String.IndexOf`）将本地名称与榜单条目比对，输出排名。  
   Use case-insensitive safe substring matching (`String.IndexOf`) to compare local name with list entries and output rank.
4. 匹配失败时提示“未在榜单中找到”。  
   Show “not found” if no match.

## 安全说明 / Security Notes
- 所有 API 请求强制使用 HTTPS，防止中间人攻击。  
  All API requests use HTTPS to prevent MITM attacks.
- 匹配算法采用 `OrdinalIgnoreCase` 比较，杜绝了 `-like` 通配符可能引发的脚本错误。  
  Matching uses `OrdinalIgnoreCase` comparison, eliminating potential issues from wildcard characters in `-like`.
- 网络异常统一捕获，不泄露敏感堆栈信息。  
  Network exceptions are caught without exposing sensitive stack traces.
- 公共密钥 `88888888` 仅供测试，频繁使用可能被限频，请自行注册替换。  
  The public key `88888888` is for testing only. Heavy usage may be rate-limited, please register your own.

## API 接口说明 / API Details
| 硬件     | 接口地址 / Endpoint                                                   |
| -------- | --------------------------------------------------------------------- |
| GPU (笔记本) | `https://cn.apihz.cn/api/bang/xianka2.php?id=<ID>&key=<KEY>` |
| CPU (桌面)   | `https://cn.apihz.cn/api/bang/cpu1.php?id=<ID>&key=<KEY>`    |
- **请求方式 / Method**：GET  
- **成功返回**：`{"code":200, "data":[{"top":1, "name":"RTX 4090 Laptop"}, ...]}`  
- **公共密钥限频**：每分钟调用次数有限，建议注册 [apihz.cn](https://www.apihz.cn) 获取个人凭证。  
  Public key rate limit: limited calls per minute, it's recommended to register for your own credentials.

## 常见问题 / FAQ
| 现象 / Issue                               | 解决方式 / Solution                                                                 |
| ----------------------------------------- | ----------------------------------------------------------------------------------- |
| 未检测到硬件 / No hardware detected       | 安装最新驱动，确认 CIM 类可用。 / Install latest drivers, ensure CIM classes exist. |
| API 返回“通讯密钥错误” / “Key error”        | 公共 KEY 超频，注册个人 ID/KEY 替换。 / Register personal ID/KEY and replace.       |
| 硬件未在榜单中找到 / Not found in list     | 接口仅收录笔记本显卡和桌面 CPU，极新或极旧型号可能未录入。 / Only mobile GPUs and desktop CPUs are covered; very new/old models may be missing. |
| 脚本无法运行 / Script cannot run          | 执行 `Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass` 临时放行。 / Allow execution with the given command. |

## 更换密钥 / How to Replace the Key
1. 打开脚本，找到 `$api` 变量。 / Open the script and locate the `$api` variable.
2. 将 `id=88888888&key=88888888` 替换为自己的 `id` 和 `key`。 / Replace `id=88888888&key=88888888` with your own `id` and `key`.
3. 保存脚本即可。 / Save and run.

## 版本历史 / Version History
- v3.0 (2026-04-26) — 全面中英双语输出与文档 / Full bilingual output and documentation.
- v2.0 — 增加 CPU 查询与整合脚本 / Added CPU query and combined script.
- v1.0 — 初版显卡查询 / Initial GPU query release.
