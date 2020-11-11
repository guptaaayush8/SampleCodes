
function CalculateFitness{
    param([object]$Population)
    $Fitness=0
    for($i = 0 ; $i -lt $Population.Count-1 ;$i++){
        $Fitness += (Distance -City1 $Population[$i] -City2 $Population[$i+1])
    }
    return 1/($Fitness+1)
}

function NextGeneration{
   param(
    [object]$PopulationFitness
   )
    $NewPop=@()
    $populationFitness=($populationFitness|Sort-Object -Property Fitness -Descending -Unique)[0..($bestselection-1)]*($PopulationSize/$bestselection)
    foreach($Config in $PopulationFitness){
        
        $Picked = PickOne -Population $PopulationFitness
        $PickedCity = Mutate -Picked $Picked.City -Rate $mutationrate
        $NewPop+= ,$PickedCity
    }
    return $NewPop
}

function PickOne{
param([object]$Population)
$Index =0
$r= Get-Random -Maximum 100

while($r -gt 0){
    $r-=$Population[$Index].fitness
    $Index++
}
$Index--
return $Population[$Index]
}

function PopulationFitness{
param([object[]]$Population)
$PopFitnessArray=@()
$Sum = 0

foreach($Config in $Population){
    $TempSFit = (CalculateFitness -Population $Config)
    $Sum+= $TempSFit*$TempSFit*$TempSFit
}
foreach($Config in $Population){
    $tempIFit = (CalculateFitness -Population $Config)
    $Fitness = $tempIFit*$tempIFit*$tempIFit*100/$Sum
    $PopFitnessArray+=New-Object CitiesClass($Config, $Fitness)
}
return $PopFitnessArray
}

function Mutate{
    param(
        [object]$pickedConfig,
        [int]$Rate
    )
    foreach($_ in 1..$pickedConfig.count){
    if((Get-Random -Maximum 100) -lt $Rate){
        $I1 = Get-Random -Maximum $pickedConfig.Count
        $I2 = Get-Random -Maximum $pickedConfig.count
        $pickedConfig=Swap -I1 $I1 -I2 $I2 -Array $pickedConfig
    }
    return $pickedConfig
}
}

function CreatePopolation{
    param([int]$PopSize=$populationSize,[object]$Array)
    $Pop=@()
        foreach($_ in 1..$PopSize){
            $Pop+=, (Shuffle -Array $Array -Times 10)
        }
    return $Pop
}


class City{
[int]$Number
[int]$X
[int]$Y
City($x,$y,$City){
    $this.X = $x
    $this.Y = $y
    $this.Number = $City
}
}

function Swap{
param($I1,$I2,$Array)
    $temp = $Array[$I1]
    $Array[$I1] = $Array[$I2]
    $Array[$I2]=$temp
    return $Array
}

function Distance{
param([object]$City1,[object]$City2)
$Dx=([int]$City1.X - [int]$City2.X)
$Dx = [math]::Pow($Dx,2)
$Dy = [math]::Pow(($City1.Y-$City2.Y),2)
   return $Dx+$Dy
}

function Shuffle{
param(
    [object]$Array,
    [int]$Times
)
foreach($_ in 1..$Times){
    $I1 = Get-Random -Maximum ($Array.count)
    $I2 = Get-Random -Maximum ($Array.count)
    $Array=Swap -I1 $I1 -I2 $I2 -Array $Array
}
return $Array
}

class CitiesClass{
    [object]$City
    [single]$Fitness
    CitiesClass($arr,$f){
        $this.City=$arr
        $this.Fitness = $f
    }
}


function global:set-ConsolePosition  {
param([int]$x,[int]$y)
# Get current cursor position and store away
$position=$host.ui.rawui.cursorposition
# Store new X and Y Co-ordinates away
$position.x=$x
$position.y=$y
# Place modified location back to $HOST
$host.ui.rawui.cursorposition=$position
}

function global:draw-line{ 
param([int]$x, [int]$y, [int]$length,[int]$vertical)
# Move to assigned X/Y position in Console 
set-ConsolePosition $x $y
# Draw the Beginning of the line
write-host “*” -nonewline 
# Is this vertically drawn?  Set direction variables and appropriate character to draw 
If ([boolean]$vertical) 
    { $linechar=“!”; $vert=1;$horz=0}
else
    { $linechar=“-“; $vert=0;$horz=1} 
# Draw the length of the line, moving in the appropriate direction 
    foreach ($count in 1..($length-1)) { 
        set-ConsolePosition (($horz*$count)+$x) (($vert*$count)+$y)
        write-host $linechar -nonewline
    }
# Bump up the counter and draw the end
$count++
    set-ConsolePosition (($horz*$count)+$x) (($vert*$count)+$y) 
write-host “*” -nonewline 
} 

