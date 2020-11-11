
$lengtharr = 100
#Radix Sort

$arr = @()

foreach($_ in 1..$lengtharr){
    $arr+=get-random -Maximum 1000000 -Minimum 100000
}

function RadixSort([object[]]$arr){
    $HashforSort = [Ordered] @{'0'=@();'1'=@();'2'=@();'3'=@();'4'=@();'5'=@();'6'=@();'7'=@();'8'=@();'9'=@()}
    $maxlength = 0
    foreach($num in $arr){
   $maxlength=  ($maxlength,$num.tostring().length|Measure-Object -Maximum).Maximum
}
    foreach($i in 1..($maxlength)){
    $HashObject = New-Object psobject -Property $HashforSort
    foreach($num in $arr){
    $num= $num.tostring()
        if($num[-$i] -eq $null){
            $HashObject.0 +=$num
        }
        else{
        $HashObject."$($num[-$i])"+=$num
        }
    }
    $arr=@()
    foreach($t in 0..9){
        $arr+=$HashObject.$t
    }
   Write-verbose ($arr -join " ")
   #$HashObject
}
return $arr
}

$arr = RadixSort($arr)
