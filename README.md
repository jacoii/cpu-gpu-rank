# Hardware Rank Checker

**Detect your local GPU (laptop/mobile) and CPU (desktop) models using PowerShell, then query their tier rankings from the apihz.cn API.**

[![PowerShell](https://img.shields.io/badge/PowerShell-5.1+-blue.svg)](https://learn.microsoft.com/en-us/powershell/)
[![Windows](https://img.shields.io/badge/Windows-10%2F11-green.svg)](https://www.microsoft.com/windows)

> 🔍 一键检测笔记本显卡和桌面 CPU 型号，并查询它们在 apihz.cn 天梯表中的排名。

## ✨ Features
- ✅ Pure PowerShell – no external tools required
- ✅ Safe matching – uses ordinal case‑insensitive comparison, no wildcard injection
- ✅ Clear color output – easily spot the rank of each part
- ✅ Dual mode – check GPU / CPU separately or together

## 📦 Files
| Script                  | Description                               |
| ----------------------- | ----------------------------------------- |
| `Get-GpuRank.ps1`       | Query GPU (mobile) ranking                |
| `Get-CpuRank.ps1`       | Query CPU (desktop) ranking               |
| `Get-HardwareRank.ps1`  | Check both GPU and CPU at once           |

## 🚀 Quick Start
```powershell
# Clone this repository
git clone https://github.com/your-username/hardware-rank-checker.git
cd hardware-rank-checker

# Allow script execution (once per session)
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass

# Run the combined checker
.\Get-HardwareRank.ps1
