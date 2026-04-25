<#
.SYNOPSIS
    Detect CPU model and query its ranking / 检测 CPU 型号并查询排名
.DESCRIPTION
    Uses Get-CimInstance to get the local CPU name, then calls apihz.cn
    API to retrieve the desktop CPU tier list and displays the rank.
    使用 Get-CimInstance 获取本机 CPU 名称，调用 apihz.cn API
    获取桌面 CPU 天梯排名并显示。
.NOTES
    Public API key 88888888 has rate limits, please register for your own.
    公共密钥 88888888 有调用频次限制，建议注册申请个人密钥。
#>

$api = 'https://cn.apihz.cn/api/bang/cpu1.php?id=88888888&key=88888888'
$cpus = (Get-CimInstance Win32_Processor).Name
if (-not $cpus) {
    Write-Host '未检测到 CPU / No CPU detected' -ForegroundColor Red
    pause
    exit 1
}

Write-Host "=== CPU: $($cpus -join ', ') / CPU(s): $($cpus -join ', ')" -ForegroundColor Cyan
try {
    $res = Invoke-RestMethod $api -TimeoutSec 15
    if ($res.code -ne 200) { throw $res.msg }
    foreach ($c in $cpus) {
        $rank = ($res.data | Where-Object {
            $c.IndexOf($_.name, [StringComparison]::OrdinalIgnoreCase) -ge 0
        }).top
        if ($rank) {
            Write-Host ('{0,-50} 排名: #{1} / Rank: #{1}' -f $c, $rank) -ForegroundColor Cyan
        } else {
            Write-Host ('{0,-50} 未在榜单中找到 / Not found in list' -f $c) -ForegroundColor Yellow
        }
    }
} catch {
    Write-Host "请求失败 / Request failed: $_" -ForegroundColor Red
    pause
    exit 1
}
pause
