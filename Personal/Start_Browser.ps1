# IEServiceList.ps1
# Jeffery Hicks
# http://jdhitsolutions.blogspot.com
# http://www.jdhitsolutions.com
# May 2006
#Display all running services in an Internet Explorer window

#create an object with the running services
$svc = get-service | where {$_.status -eq “running”}

#create a new COM object that is Internet Explorer
$oIE=New-object -COM InternetExplorer.Application

# If you want to see what Internet Explorer methods and
# properties exist, then run from within this script:
#$oIE |get-member

#Configure IE object
$oIE.navigate2(“about:blank”)

$id=0
#build the html code to display
foreach ($s in $svc) {$id++;$html=$html+”<p id=$id face=Verdana size=2>”+`
$s.Displayname+”: “+$s.status+”</p><br>”}

#set the body with our html code
$oIE.document.write($html)

#display a summary in the status bar
$oIE.StatusText=($svc.Count).ToString()+” running services”

#display the IE object
$oIE.Visible=$True