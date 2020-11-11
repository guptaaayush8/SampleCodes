function Show-form
{
$path = "C:\PS\Microsoft.Online.SharePoint.PowerShell\16.0.20212.12000"
$path = "C:\Windows\WinSxS"

Add-Type -assembly System.Windows.Forms

#title for the winform
$Title = "Directory Usage Analysis: $Path"
$height=400
$width=800
$color = "White"

$script:CancelLoop = $false

#create the form
$form1 = New-Object System.Windows.Forms.Form
$form1.Text = $title
$form1.Height = $height
$form1.Width = $width
$form1.BackColor = $color
$form1.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedSingle
$form1.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen

# create label
$label1 = New-Object system.Windows.Forms.Label
$label1.Text = "not started"
$label1.Left=5
$label1.Top= 10
$label1.Width= $width - 20
$label1.Height=15
$label1.Font= "Verdana"
$label1.BorderStyle=1
$form1.controls.add($label1)

$objTextBox1 = New-Object System.Windows.Forms.TextBox 
$objTextBox1.Multiline = $True;
$objTextBox1.Location = New-Object System.Drawing.Size(5,80) 
$objTextBox1.Size = New-Object System.Drawing.Size(($width -20),($height - 150))
$objTextBox1.Scrollbars = "Both" 
$form1.Controls.Add($objTextBox1)


$progressBar1 = New-Object System.Windows.Forms.ProgressBar
$progressBar1.Name = 'progressBar1'
$progressBar1.Value = 0
$progressBar1.Style="Continuous"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = $width - 40
$System_Drawing_Size.Height = 20
$progressBar1.Size = $System_Drawing_Size
$progressBar1.Left = 5
$progressBar1.Top = 40
$form1.Controls.Add($progressBar1)

  # Add Button
    $Button = New-Object System.Windows.Forms.Button
    $Button.Location = New-Object System.Drawing.Size(($width-150),($height - 60))
    $Button.Size = New-Object System.Drawing.Size(120,23)
    $Button.Text = "Start Process"

    $form1.Controls.Add($Button)

    #Add Button event 
    $Button.Add_Click(
        {    
		    StartCount 
        }
    )
     
    $Button1 = New-Object System.Windows.Forms.Button
    $Button1.Location = New-Object System.Drawing.Size(($width-300),($height - 60))
    $Button1.Size = New-Object System.Drawing.Size(120,23)
    $Button1.Text = "close Process"

    $form1.Controls.Add($Button1)

    #Add Button event 
    $Button1.Add_Click(
        {    
		   $script:CancelLoop=$True
        }
    )

$label1.text="Preparing to analyze $path"
$form1.Refresh()

start-sleep -Seconds 1

#run code and update the status form

#get top level folders
$top = Get-ChildItem -Path $path -Directory

$form1_FormClosing=[System.Windows.Forms.FormClosingEventHandler]{
#Event Argument: $_ = [System.Windows.Forms.FormClosingEventArgs]
    $script:CancelLoop = $true
}

#initialize a counter
$i=0
function Startcount{
foreach ($folder in $top) {
#calculate percentage
$Button.Enabled=$false
$button1.Enabled=$True
$i++
[int]$pct = ($i/$top.count)*100
#update the progress bar
$progressbar1.Value = $pct

$label1.text="Measuring size: $($folder.Name)"
$form1.Refresh()

$stats = Get-ChildItem -path $folder -Recurse -File |
Measure-Object -Property Length -Sum -Average
$obj = [pscustomobject]@{
Path=$folder.Name
Files = $stats.count
SizeKB = [math]::Round($stats.sum/1KB,2)
Avg = [math]::Round($stats.average,2)
}
$objTextBox1.AppendText("$($Obj|fl|Out-String)")
$script:CancelLoop=$false
[System.Windows.Forms.Application]::DoEvents()
 if($script:CancelLoop -eq $True)
        {
            $progressbar1.Value = 0
            $Button.Enabled=$True
            $button1.Enabled=$false
            break;
        }
    if($form1.DialogResult -eq 'Cancel'){
        break;
    }
} #foreach
}
$form1.ShowDialog()| out-null

#>
}
Show-form