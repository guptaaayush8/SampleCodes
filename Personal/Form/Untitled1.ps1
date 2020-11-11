Add-Type -AssemblyName System.Windows.Forms

# Create a new form
$ActiveDirectorySearch = New-Object system.Windows.Forms.Form

# Define the size, title and background color
$ActiveDirectorySearch.ClientSize         = '500,300'
$ActiveDirectorySearch.text               = "Search Active Directory"
$ActiveDirectorySearch.BackColor          = "#ffffff"

# Display the form

$Username = New-Object System.Windows.Forms.Label
$Username.Text = $Usernametxt.Text
$Username.AutoSize=$true
$Username.Location = New-Object System.Drawing.Point(150,150)
$Username.Font = 'Microsoft Sans Serif,13,style=Bold'
$username.Visible=$true
$ActiveDirectorySearch.Controls.Add($Username)

$Emaillbl = New-Object System.Windows.Forms.Label
$Emaillbl.Text = "Enter Username"
$Emaillbl.AutoSize=$true
$emaillbl.Location = New-Object System.Drawing.Point(20,50)
$emaillbl.Font = 'Microsoft Sans Serif,13,style=Bold'
$ActiveDirectorySearch.Controls.Add($emaillbl)

$Usernametxt = New-Object system.Windows.Forms.TextBox
$Usernametxt.AutoSize=$true
$Usernametxt.location  = New-Object System.Drawing.Point(200,50)
$Usernametxt.Font      = 'Microsoft Sans Serif,10'
$Usernametxt.Visible   = $true
$ActiveDirectorySearch.Controls.Add($Usernametxt)



$SearchBtn                   = New-Object system.Windows.Forms.Button
$SearchBtn.text              = "Search User"
$SearchBtn.width             = 90
$SearchBtn.height            = 30
$SearchBtn.location          = New-Object System.Drawing.Point(370,250)
#$SearchBtn.Font              = 'Microsoft Sans Serif,10'
$UserSearch = $SearchBtn.add_click({UserDetails -Usernameff $Usernametxt.Text})

$ActiveDirectorySearch.Controls.Add($SearchBtn)
function UserDetails{
#
param(
    [String]$Usernameff = $UserNameTxt.Text
)
    $ControllerUser=([ADSISEARCHER]"mail=$Usernameff").FindOne() 
    #Return ($ControllerUser.Properties -ne $null)#>
    Write-host $Usernametxt.Text
    $username.text = ($ControllerUser.Properties.mailnickname)

}
$r = $ActiveDirectorySearch.ShowDialog()





#title,mail,eco-employeeid,samaccountname,employeetype,displayname,mailnickname
