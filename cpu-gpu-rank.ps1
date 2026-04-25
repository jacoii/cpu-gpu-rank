<#
.SYNOPSIS
    One-click check GPU & CPU rankings / 一键查询显卡和 CPU 排名
.DESCRIPTION
    Detects both GPU and CPU models, then queries the apihz.cn tier lists.
    检测显卡和 CPU 型号，然后查询天梯排名。
.NOTES
    Public API key 88888888 has rate limits, please register for your own.
    公共密钥 88888888 有调用频次限制，建议注册申请个人密钥。
#>

function Get-Rank {
    param($hardware, $api, $type)
    if (-not $hardware) {
        Write-Host "未检测到 $type / No $type detected" -ForegroundColor Red
        return
    }

    Write-Host "=== $type : $($hardware -join ', ')" -ForegroundColor Cyan
    try {
        $res = Invoke-RestMethod $api -TimeoutSec 15
        if ($res.code -ne 200) { throw $res.msg }
        foreach ($h in $hardware) {
            $rank = ($res.data | Where-Object {
                $h.IndexOf($_.name, [StringComparison]::OrdinalIgnoreCase) -ge 0
            }).top
            if ($rank) {
                Write-Host ('{0,-50} 排名: #{1} / Rank: #{1}' -f $h, $rank) -ForegroundColor Cyan
            } else {
                Write-Host ('{0,-50} 未在榜单中找到 / Not found in list' -f $h) -ForegroundColor Yellow
            }
        }
    } catch {
        Write-Host "请求失败 / Request failed: $_" -ForegroundColor Red
    }
}

$gpus = (Get-CimInstance Win32_VideoController).Name
$cpus = (Get-CimInstance Win32_Processor).Name

Get-Rank -hardware $gpus -api 'https://cn.apihz.cn/api/bang/xianka2.php?id=88888888&key=88888888' -type 'GPU'
Write-Host ''
Get-Rank -hardware $cpus -api 'https://cn.apihz.cn/api/bang/cpu1.php?id=88888888&key=88888888' -type 'CPU'

pause
