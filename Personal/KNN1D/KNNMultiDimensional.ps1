##Calculate KNN-MultiDimensional
$VerbosePreference = 'Continue'
$dataset=@()
foreach($_ in 1..50){
    $obj= New-Object psobject
    $obj|Add-Member -MemberType NoteProperty -Name X -Value 1000 #(Get-Random -Maximum 50.0)
    $obj|Add-Member -MemberType NoteProperty -Name Y -Value 1000 #(get-random -Maximum 50.0)
    $dataset+=$obj                                          

}

Function Calculate-KNN{
param(
    [Object[]]$DataSet,
    [Int]$Cluster=$null
)

$Dimension = ($DataSet|gm -MemberType NoteProperty).Count
$DataVariable = ($DataSet|gm -MemberType NoteProperty).Name

if($Cluster -ne 0){
    $KNNObject,$Category=Calculate-KNNCategory -DataSet $DataSet -ClustersNeeded $Cluster
    return $KNNObject
}

$finalReduction =$null
$flag = $false
foreach($ClusterNumber in 1..($DataSet.Count)){
    Write-Progress -Activity "Compiling K Means Clustering" -Status "Compiling Cluster $ClusterNumber" -PercentComplete ($ClusterNumber*100/($DataSet.Count))
    
    $KNNObject,$Category=Calculate-KNNCategory -DataSet $DataSet -ClustersNeeded $ClusterNumber
    
     $ClusterVariance= ((Calculate-KNNClusterVariance -ClusterDataPointObject $KNNObject -CategoryObject $Category))
     if($flag -eq $false){$flag = $true;$NullVariance = $ClusterVariance;$PreviousReduction=[int]::MinValue}

     $CurrentReduction=($NullVariance -$ClusterVariance)
     Write-Verbose "Cluster : $ClusterNumber :: Reduced Variance : $CurrentReduction"
     if(($CurrentReduction - $PreviousReduction) -lt 10 -and ($CurrentReduction -gt 0)){
       break;
     }
     $PreviousKNNObject = $KNNObject
     $PreviousReduction = $CurrentReduction
     $finalReduction+=,$CurrentReduction
}

Write-Progress -Activity "Compiling K Means Clustering" -Completed
    Write-Verbose "Cluster Size : $($ClusterNumber - 1) :: DataSet Size : $($DataSet.Count)"
    return $PreviousKNNObject
}

Function Calculate-KNNClusterVariance{
    param(
        [Object[]]$ClusterDataPointObject=$KNNObject,
        [object[]]$CategoryArray=$Category
    )
    $KNNVariance=0
    foreach($Category in $CategoryArray){
        
            $KNNVariance+= Calculate-KNNVariance -ObjectArray (Return-KNNMatchObject -In $ClusterDataPointObject -With $Category).datapoint
       
    }
    return $KNNVariance

}

Function Calculate-KNNVariance{
    param([object[]]$ObjectArray)
    if($ObjectArray.Length -eq 1){return 0}
    $KNNMean = Calculate-KNNMean -Array $ObjectArray
    $KNNDenominator = -1
    foreach($Object in $ObjectArray){
        $Distance=  Calculate-KNNDistance -Obj1 $object -Obj2 $KNNMean
        $KNNNumerator+=[math]::Pow( $Distance ,2)
        $KNNDenominator++
    }
    $KNNVariance = [math]::Sqrt($KNNNumerator/$KNNDenominator)
    return $KNNVariance
}

Function Calculate-KNNCategory{
    param(
        [object[]]$DataSet,
        [int]$ClustersNeeded = 3
    )
    
    $MeanArray=Get-Random -InputObject $DataSet -Count $ClustersNeeded
    foreach($_ in 0..(($dataset.Count)/2)){
    $Arr = @()
    foreach($Data in $DataSet){
         $DataObject = New-Object psobject -Property @{DataPoint=$Data;Category=(Calculate-KNNClosestNeighbour -MeanArray $MeanArray -Data $Data)}
         $Arr+=$DataObject
    }

    $TempMeanArray = $null
    foreach($Mean in $MeanArray){
        $TempMeanArray+=,(Calculate-KNNMean (Return-KNNMatchObject -With $Mean -In $Arr).DataPoint)
    }
    $MeanArray = $TempMeanArray


}
return ($arr|sort -Property Category.X,datapoint.X),$MeanArray
}

Function Calculate-KNNClosestNeighbour{
    param(
        [Object[]]$MeanArray,
        [object]$Data
    )
    $Dimension = ($DataSet|gm -MemberType NoteProperty).Count
    $DataVariable = ($DataSet|gm -MemberType NoteProperty).Name

    $MinDistance = [Double]::MaxValue
    foreach($Mean in $MeanArray){
        $Distance = Calcuate-KNNDistance -Obj1 $Mean -Obj2 $Data 
        if($MinDistance -gt $Distance){
            $MinDistance = $Distance
            $ClosestNeighbour = $Mean
        }
    }
    return $ClosestNeighbour
}

Function Calculate-KNNDistance{
    param([object]$Obj1,[object]$Obj2)
    
    $DataVariable = ($Obj1|gm -MemberType NoteProperty).Name
    $Distance = 0
    foreach($Var in $DataVariable){
        $Distance+=[math]::pow(($Obj1.($Var) -$obj2.($Var)),2)
    }
    return ([math]::Sqrt($Distance))
}

Function Calculate-KNNMean {
    param([object[]]$Array)
    
    if($Array.Count -eq 1){
        return $Array
    }

    $DataVariable = ($Array.Item(0)|gm -MemberType NoteProperty).Name
    $obj = New-Object psobject
    foreach($Var in $DataVariable){
        $obj|Add-Member -MemberType NoteProperty -Name $Var -Value (($Array|Measure-Object -Average -Property $Var).Average)
    }
    return $obj
}

function Return-KNNMatchObject{
    param(
        [object]$With,
        [Object[]]$In
    )
    $DataVariable = ($With|gm -MemberType NoteProperty).Name
    $MatchingSet=$null
    foreach($object in $In){
        $flag=$true
        foreach($Var in $DataVariable){
            if($object.Category.($Var) -ne $With.($Var)){
                $flag = $false
                continue
            }
        }
        if($flag -eq $true){
            $MatchingSet+=,$object
        }
    }
    return $MatchingSet
}