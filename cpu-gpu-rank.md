# 显卡排名查询工具（纯 PowerShell 版）

## 项目概述
通过 PowerShell 直接检测本机显卡型号，并调用 apihz.cn 的笔记本显卡天梯 API 获取对应排名。

## 适用环境
- **操作系统**：Windows 10 / Windows 11
- **PowerShell 版本**：5.1 或更高（系统自带）
- **网络要求**：可访问 `cn.apihz.cn`

## 文件清单
| 文件名             | 用途                         |
| ------------------ | ---------------------------- |
| `Get-GpuRank.ps1`  | 主查询脚本                   |
| `gpu_rank.md`      | 维护文档                     |

## 脚本流程
1. 使用 `Get-CimInstance Win32_VideoController` 获取所有显卡名称。
2. 调用 API `https://cn.apihz.cn/api/bang/xianka2.php` 获取最新排名列表。
3. 将本地显卡名称与榜单条目模糊匹配（`*ModelName*`），输出 `top` 字段值。
4. 匹配失败时提示“未在榜单中找到”。

## API 说明
- **接口地址**：`https://cn.apihz.cn/api/bang/xianka2.php`
- **请求方式**：GET
- **参数**：
  - `id`：开发者 ID（示例值 `88888888`）
  - `key`：开发者 KEY（示例值 `88888888`）
- **返回格式**：JSON，主要使用 `data` 数组中的 `top`（排名）和 `name`（型号）。
- **注意事项**：
  - 公共密钥每分钟调用频次有限，大量使用会被限制。
  - 接口仅收录**笔记本移动版**显卡，台式机/服务器显卡可能无法匹配。

## 常见问题排查
| 现象                           | 原因及解决                                                                 |
| ------------------------------ | -------------------------------------------------------------------------- |
| 脚本无法运行，提示执行权限错误 | 默认执行策略为 Restricted。请在 PowerShell 中先用 `Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass` 临时放行。 |
| 未检测到显卡                   | 显卡驱动未安装或异常；系统精简版可能缺失 CIM 类。请重新安装驱动。          |
| API 返回“通讯密钥错误”         | 同一公钥并发过大，或被临时封禁。建议去 [apihz.cn](https://www.apihz.cn) 注册并替换脚本开头的 `$apiUrl` 中的 `id` 和 `key`。 |
| 显卡未在榜单中找到             | 显卡可能是台式机型号或服务器/专业卡，也可能刚刚发布尚未收录。              |
| 网络请求失败                   | 检查防火墙、代理，确认 `cn.apihz.cn` 可达。可以尝试浏览器访问相同 URL 测试。|

## 如何更换 API 密钥
1. 用文本编辑器打开 `Get-GpuRank.ps1`。
2. 找到脚本开头的 `$apiUrl` 变量：
   ```powershell
   $apiUrl = "https://cn.apihz.cn/api/bang/xianka2.php?id=88888888&key=88888888"