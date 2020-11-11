##K Nearest Neighbour

#$DataSet = @()
#    foreach($_ in 0..10){
#    $DataSet+=get-random -maximum 1000.0
#}



Function Calculate-KNN1DMean{
    param(
        [single[]]$Arr
    )
    $LengthArr = $Arr.Count
    $SumArr = ($Arr|Measure-Object -Sum).Sum
    return $SumArr/$LengthArr
}

Function Calculate-KNN1DVariance{
    param([single[]]$Arr)
    if($Arr.Length -eq 1){return 0}
    $KNNMean = Calculate-KNN1DMean -Arr $Arr
    $KNNDenominator = -1
    foreach($Num in $Arr){
        $KNNNumerator+=[math]::Pow($Num - $KNNMean ,2)
        $KNNDenominator++
    }
    $KNNVariance = [math]::Sqrt($KNNNumerator/$KNNDenominator)
    return $KNNVariance
}

Function Calculate-KNN1DClosestNeighbour{
    param(
        [single[]]$MeanArray,
        [Single]$Number
    )
    $MinDistance = [Double]::MaxValue
    foreach($Mean in $MeanArray){
        
        $Distance = [math]::abs($Mean -$Number)
        if($MinDistance -gt $Distance){
            $MinDistance = $Distance
            $ClosestNeighbour = $Mean
        }
    }
    return $ClosestNeighbour
}

Function Calculate-KNN1DCategory{
    param(
        [Single[]]$DataSet,
        [int]$ClustersNeeded = 3
    )
    
    
    
    $MeanArray=$DataSet |Select-Object -First $ClustersNeeded -Unique
    foreach($_ in 0..($dataset.Count)){
    $Arr = @()
    foreach($Num in $DataSet){
         $DataObject = New-Object psobject -Property @{DataPoint=$Num;Category=[int](Calculate-KNN1DClosestNeighbour -MeanArray $MeanArray -Number $Num)}
         $Arr+=$DataObject
    }

    $TempMeanArray = $null
    foreach($Mean in [int[]]$MeanArray){
        $TempMeanArray+=,(Calculate-KNN1DMean ($Arr|Where-Object{$_.category -eq $mean}).DataPoint)
    }
    $MeanArray = $TempMeanArray

}
return ($arr|sort -Property Category,datapoint),[int[]]$MeanArray
}

Function Calculate-KNN1DClusterVariance{
    param(
        [Object[]]$ClusterDataPointObject,
        [int[]]$CategoryArray
    )
    $KNNVariance=0
    foreach($Category in $CategoryArray){
        
            $KNNVariance+= Calculate-KNN1DVariance -Arr (($ClusterDataPointObject|where {$_.category -eq $Category}).datapoint)
       
    }
    return $KNNVariance

}

Function Calculate-KNN1D{
param(
    [single[]]$DataSet,
    [Int]$Cluster=$null
)

if($Cluster -ne 0){
    $KNN1DObject,$Category=Calculate-KNN1DCategory -DataSet $DataSet -ClustersNeeded $Cluster
    return $KNN1DObject
}

$finalReduction =$null
$flag = $false
foreach($ClusterNumber in 1..($DataSet.Count)){

    $KNN1DObject,$Category=Calculate-KNN1DCategory -DataSet $DataSet -ClustersNeeded $ClusterNumber
    
     $ClusterVariance= ((Calculate-KNN1DClusterVariance -ClusterDataPointObject $KNN1DObject -CategoryArray $Category))
     if($flag -eq $false){$flag = $true;$NullVariance = $ClusterVariance;$PreviousReduction=-100}

     $CurrentReduction=($NullVariance -$ClusterVariance)
     if(($CurrentReduction - $PreviousReduction) -lt 10 -and ($CurrentReduction -gt 0)){
        break;
     }
     $PreviousReduction = $CurrentReduction
}
    return $KNN1DObject
}

Calculate-KNN1D -DataSet $DataSet