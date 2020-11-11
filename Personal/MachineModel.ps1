class Connection {

    [float]$Weight
    [float]$inputValue =  1
    [float]$outputValue

    Connection(){
        $this.Weight = 1
    }
    Eval(){
        $this.outputValue = $this.inputValue*$this.Weight
    }
    changeWeight([float]$newWeight){
        $this.Weight = $newWeight
    }

    Train([float]$lr,[float]$DelWeight){
        $this.changeWeight($this.Weight - $lr*$DelWeight)
    }

}
class Node{
    [Connection[]]$inputConn
    [Connection[]]$OutputConn
    [float]$Bias
    [float[]]$InputValues
    [float]$EvaluatedValue
    Node(){
        $this.Bias = 1.2
    }
    Eval(){
        foreach($conn in $this.inputConn){$conn.Eval()}
        foreach($v in $this.inputConn.outputValue){$this.InputValues+=$v}
        $this.EvaluatedValue = ((($this.Bias +($this.inputConn.outputValue|Measure-Object -Sum).sum),0)|Measure-Object -Maximum).Maximum
        foreach($conn in $this.OutputConn){
        
            $conn.inputvalue = $this.EvaluatedValue
        }
        #$this.OutputConn|foreach {$_.inputValue = $this.EvaluatedValue}
    }
    ChangeBias([float]$NewBias){
        $this.Bias = $NewBias
    }


}
Class Layer {
    [int]$LayerNumber
    [Node[]]$LayerNodes
    Layer([int]$num){
        foreach($_ in 1..$num){
            $this.LayerNodes+= New-Object Node
        }
    }
    NextLayer([Layer]$l){
        foreach($LayerNode in $l.LayerNodes){
            foreach($HomeLayerNode in $this.LayerNodes){
            $con = New-Object Connection
            $Layernode.inputconn += $con
            $HomeLayerNode.outputconn += $Con
        }
    }
    }

    Eval(){
        $this.LayerNodes|foreach{$_.Eval()}
    }

    DeclareInputLayer(){
       foreach($n in $this.LayerNodes){
        $n.inputconn = New-Object Connection
       } #$this.LayerNodes|foreach($_.inputConn = New-Object Connection)
    }
     DeclareOutputLayer(){
      foreach($n in $this.LayerNodes){
        $n.outputconn = New-Object Connection
       }
        #$this.LayerNodes|foreach($_.OutputConn = New-Object Connection)
    }

}
class MachineModel{
    [Layer]$InputLayer
    [Layer[]]$HiddenLayers
    [Layer]$OutputLayer
    [float[]]$Outputs
    MachineModel([int[]]$ArrofNumNodes,[int]$InputNumNodes,[int]$OutputNumNodes){
        $this.InputLayer = New-Object Layer -ArgumentList $InputNumNodes
        $this.InputLayer.DeclareInputLayer()
        $this.OutputLayer = New-Object Layer -ArgumentList $OutputNumNodes
        $this.OutputLayer.DeclareOutputLayer()
        foreach($num in $ArrofNumNodes){
            $TempLayer = New-Object Layer -ArgumentList $num
            if($this.HiddenLayers -eq $null){$this.InputLayer.NextLayer($TempLayer)}
            else{$this.HiddenLayers[-1].NextLayer($TempLayer)}
            $this.HiddenLayers+=$TempLayer
        }
        $this.HiddenLayers[-1].NextLayer($this.OutputLayer)
    }
    Eval(){
        foreach($n in $this.InputLayer.LayerNodes){
            $n.inputconn[0].inputvalue = Read-Host "Enter Value"
        }
        $this.InputLayer.Eval()
        foreach($HiddenLayer in $this.HiddenLayers){$HiddenLayer.Eval()}
        $this.OutputLayer.Eval()
        
        foreach($evalValue in $this.OutputLayer.LayerNodes.EvaluatedValue){
        $this.Outputs += $evalValue 
        }
    }

    Train([float[]]$InputArr,[float[]]$ExpectedOutput){
       $errorOutput = (ArrSub -a1 $ExpectedOutput -a2 $this.Outputs)
       Write-Host $errorOutput
    }
}

$model = New-Object MachineModel -ArgumentList @(2,2),1,2
$model.Eval()


function ArrSub{param([object[]]$a1,[object[]]$a2)
    $arr = @()
    for($i = 0;$i -lt $a1.Count;$i++){
        $arr+= $a1[$i] - $a2[$i]
    }

return $arr
}
function
