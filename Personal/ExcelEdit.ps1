### Excel Activity

$xl = New-Object -ComObject 'Excel.Application'
$xl.Visible=$true
$wb = $xl.Workbooks.Open("C:\Users\guptaaa\desktop\COTS Sample Output - v1.xlsx")
$ws = $wb.Worksheets | where {$_.name -eq 'Server Utilization'}
$ws.Activate()
$ws.Cells.Item(1,2).text

###Cell Text 
function CellEdit{
    param(
        [String]$Value,
        [Int]$x,
        [Int]$y,
        [System.__ComObject]$Worksheet
            )
    
      $Worksheet.cells.item($x,$y) = $value
    
}

###Server Utilization
$ws = $wb.Worksheets | where {$_.name -eq 'Server Utilization'}
function ServerUtilization{
param([System.__ComObject]$Worksheet)
$x = 2
while($True){
if($Worksheet.Cells.Item($x,1).value2 -eq $null){break}
    $Server = $Worksheet.Cells.Item($x,1).value2
    $Parameter = $Worksheet.Cells.Item($x,2).value2
    Switch($Parameter){
        'CPU'{$Worksheet.Cells.Item($x,4) = "$x";break}
        'MEM'{$Worksheet.Cells.Item($x,4)= $x;break}
        'DISK'{$Worksheet.Cells.Item($x,4)= $x;break}
        default{}
    }
    $date = Get-Date -UFormat "%m/%d/%y %H:%M"
    $Worksheet.Cells.Item($x,5)= $date
    Write-Host "$Server,$Parameter"
    $x+=1
    
}
}

###Service Details
$ws = $wb.Worksheets | where {$_.name -eq 'Service Details'}
function ServiceDetails{
    param([System.__ComObject]$Worksheet)
$x = 2
while($True){
if($Worksheet.Cells.Item($x,1).value2 -eq $null){break}
    $Server = $Worksheet.Cells.Item($x,1).value2
    $ServiceName = $Worksheet.Cells.Item($x,2).value2
    #GetService Function return Status
    $Status = 'sad'
    Switch($Status){
        'Running'{$Worksheet.Cells.Item($x,5) = "UP";break}
        'Stopped'{$Worksheet.Cells.Item($x,5)= 'DOWN';break}
        default{$Worksheet.Cells.Item($x,5)= 'TBD'}
    }
    $date = Get-Date -UFormat "%m/%d/%y %H:%M"
    $Worksheet.Cells.Item($x,6)= $date
    Write-Host "$Server,$Parameter"
    $x+=1
    
}
}

$ws = $wb.Worksheets | where {$_.name -eq 'Server Inventory'}
function ServiceDetails{
    param([System.__ComObject]$Worksheet)
$x = 3
while($True){
if($Worksheet.Cells.Item($x,1).value2 -eq $null){break}
    $Server = $Worksheet.Cells.Item($x,1).value2
    Write-Host "$Server"
    ##Get Server Details
    # CPU
    $x+=1
    
}
}