param(
    [Parameter(mandatory)] $path, #path to the json file
    [Parameter(mandatory)] $start_date #be carefull to the date format, may be using yyyy-mm-dd to avoid confusion

)

# example : -path json.json -start_date 2022-12-01


Write-Verbose "Retrieving data from the json"
$json = get-content $path |ConvertFrom-Json

$col= $null
$col =@()

Write-Verbose "Getting the full list of users who have been leaked"
$userlist = $json.BreachSearchResults

$userlist_count = $userlist.count

$ptr = 1

Write-Verbose "Getting in the loop"
foreach ($user in $userlist){
    [int]$perc = (($ptr/$userlist_count)*100)
    Write-Progress -Activity "Retrieving leaked users" -status ("User number "+$ptr+" out of "+$userlist_count+ " : " +$perc +"%") -perc $perc

    $user_breach=$user.breaches
    $dataclasses_tostring = ""
    ($user_breach.dataclasses | sort -Unique) | %{$cur_dataclasses=$_; $dataclasses_tostring += $cur_dataclasses + ";"}
    $dataclasses_tostring=$dataclasses_tostring.substring(0,$dataclasses_tostring.length -1)
    
    $breach = ($user_breach |?{(get-date $_.addeddate) -gt (get-date $start_date)}) | select @{n="user";E={$user.alias}},@{n="domain";E={$user.domainname}},@{n="email";E={($user.alias +"@"+$user.domainname)}}, title,name,breachdate,addeddate,modifieddate,pwncount,@{N="dataclasses";E={$dataclasses_tostring}},isverified,IsFabricated,IsSensitive,IsActive,IsRetired,IsSpamList,IsMalware
    
    $col +=$breach
    $ptr++
}
Write-Verbose "Exiting the loop"

Write-Verbose "Export as csv"
$col |Export-Csv -Delimiter "," -Path "hibp-out.csv" -NoTypeInformation


Write-host ("output file : "+ (get-location).path +"\hibp-out.csv has been created")
