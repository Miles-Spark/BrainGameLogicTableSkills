# Level Format Transform Script (PowerShell)
# Usage: powershell -ExecutionPolicy Bypass -File LevelTransform.ps1 -FileName "C:\Users\admin\Desktop\BrainGameLevel-Create\references\modificationTest.md"
# Optional: -BasePath "D:\output" -OutputSuffix "_export"


param(
    [Parameter(Mandatory=$true)]
    [string]$FileName,    
    [string]$OutputSuffix = "_output"
)
# 修复控制台中文乱码
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
[Console]::InputEncoding = [System.Text.Encoding]::UTF8


# 标准化输入文件路径并校验文件是否存在
$inputFile = [System.IO.Path]::GetFullPath($FileName)
if (-not (Test-Path -Path $inputFile -PathType Leaf)) {
    Write-Error "错误：输入文件不存在 -> $inputFile"
    exit 1
}

# 解析文件目录、纯文件名、扩展名
$fileDir = [System.IO.Path]::GetDirectoryName($inputFile)
$baseName = [System.IO.Path]::GetFileNameWithoutExtension($inputFile)
$extension = [System.IO.Path]::GetExtension($inputFile)
#Write-Host "fileDir: $fileDir  ,baseName: $baseName  ,extension: $extension  ,"

# 2. 确定输出目录
if (-not [string]::IsNullOrWhiteSpace($BasePath)) {
    $outputDir = [System.IO.Path]::GetFullPath($BasePath)
} else {
    $outputDir = $fileDir
}


# 拼接输出文件完整路径
$outputFileName = $baseName + $OutputSuffix + $extension
$outputFile = Join-Path $outputDir $outputFileName


# 读取所有行
$lines = Get-Content $inputFile -Encoding UTF8 
$result = @()
# 层级替换逻辑：兜底保留不匹配的所有文本行
foreach ($line in $lines) {
    if ($line -match '^- (Level\d+)') {
        $result += "- " + $matches[1]
    } elseif ($line -match '^(  )- (.+)') {
        $result += "-- " + $matches[2]
    } elseif ($line -match '^(    )- (.+)') {
        $result += "--- " + $matches[2]
    } elseif ($line -match '^(      )- (.+)') {
        $result += "---- " + $matches[2]
    } elseif ($line -match '^(        )- (.+)') {
        $result += "----- " + $matches[2]
   } elseif ($line -match '^(          )- (.+)') {
        $result += "------ " + $matches[2]
      }
}

# 写入输出文件
$result | Out-File $outputFile -Encoding UTF8

Write-Host "Conversion completed! Output file: $outputFile"