$CityNumber=0
$TotalCities = 4
$MutationRate = 10
$bestselection = 2
$Cities=@()
$PopulationSize=50
$Population=@()

foreach($_ in 1..$TotalCities){
$X= Get-Random -Maximum 100
$Y= Get-Random -Maximum 100
$Cities+= New-Object City($X,$Y,$CityNumber)
$CityNumber++
}

$Population = CreatePopolation -Array $Cities

$populationFitness = PopulationFitness -Population $Population

$BestinPopulation = $populationFitness |where{$_.Fitness -eq ($populationFitness|Measure-Object -Property Fitness -Maximum).Maximum}
$bestever=$null
while($true){
$NextGen = NextGeneration -PopulationFitness $populationFitness
$populationFitness = PopulationFitness -Population $NextGen
$BestinPopulation = $populationFitness |where{$_.Fitness -eq ($populationFitness|Measure-Object -Property Fitness -Maximum).Maximum}|select -First 1
#$populationFitness
$BestEver = $BestinPopulation,$BestEver|where{$_.Fitness -eq ($BestinPopulation,$BestEver|Measure-Object -Maximum -Property Fitness).Maximum}
"Best In Population: $($BestinPopulation.Fitness) ||| Best Ever : $($BestEver.Fitness) "
""
}