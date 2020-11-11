
<#y = mx+c
$Vectors = @()
foreach($num in 0..5e2){
$n = Get-Random -Maximum 1.0e4 -Minimum 1.0
$prop = @{y=(1058*$n)+1001;x=$n}
$Vector = New-Object psobject -Property $prop
$Vectors += $Vector
$num
}#>
$TempDataSet = $dataset
$Species = @{}
$count = 0
foreach($Data in $TempDataSet){
try{
    $Species.Add($data.Species,$count)
    $count++
}catch{
    
}
finally{
$data.Species=$Species[$data.Species]
}
}

function StochasticGradientDescent{
    param(
        [object[]]$DataSet,
        [single]$Lr,
        [single]$Stepsize,
        [int]$Epoch
    )
    cls
    $Slope = @(1)*(($dataset|gm -MemberType NoteProperty).count -1)
    
    for($i=$Epoch;$i -lt $DataSet.Count ;$i+=$Epoch){

    $TempDataset = $DataSet[$i..($i+$Epoch-1)]

    while($true){

        $Cs = @(0)*(($dataset|gm -MemberType NoteProperty).count -1)

        foreach($Temp in $TempDataset){
            $Cs += -($Vector.y - ($Slope * $Temp.) -$Const)*($Vector.x)
        }

        $Cs/=$tempVectors.Count        
        $Slope = $Slope - $Lr*$Cs;
        $y = ($tempVectors.y |Measure-Object -Average).Average
        $x = ($tempVectors.x |Measure-Object -Average).Average
        $Const = ($y - ($Slope * $x))
        if($Slope*$prevSlope -lt 0){$Lr-=$Lr*0.01;$Decreased = $true;}
        if($Decreased -eq $false){$Lr+=$Lr*0.01}
        $prevSlope = $Slope
        $test = [Math]::Abs($Lr*$Cs)
        "$Slope : $Const : $Lr"
        if(($test -le $StepSize)){$EpochCount++;"Epoch Number $EpochCount Completed";break}
}
}
return @{Slope=$Slope;Const=$Const}
}


function MatrixMul