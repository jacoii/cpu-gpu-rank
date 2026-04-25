function Get-Rank {
    param($hardware, $api)
    Write-Host "=== 查询: $($hardware -join ', ')" -ForegroundColor Cyan
    try {
        $res = Invoke-RestMethod $api -TimeoutSec 15
        if ($res.code -ne 200) { throw $res.msg }
        foreach ($h in $hardware) {
            $rank = ($res.data | Where-Object { $h.IndexOf($_.name, [StringComparison]::OrdinalIgnoreCase) -ge 0 }).top
            if ($rank) { Write-Host ('{0,-50} 排名: #{1}' -f $h, $rank) -ForegroundColor Cyan }
            else { Write-Host ('{0,-50} 未在榜单中找到' -f $h) -ForegroundColor Yellow }
        }
    } catch { Write-Host "请求失败: $_" -ForegroundColor Red }
}

$gpus = (Get-CimInstance Win32_VideoController).Name
$cpus = (Get-CimInstance Win32_Processor).Name

if ($gpus) { Get-Rank $gpus 'https://cn.apihz.cn/api/bang/xianka2.php?id=88888888&key=88888888' }
else { Write-Host '未检测到显卡' -ForegroundColor Red }

if ($cpus) { Get-Rank $cpus 'https://cn.apihz.cn/api/bang/cpu1.php?id=88888888&key=88888888' }
else { Write-Host '未检测到 CPU' -ForegroundColor Red }

pause