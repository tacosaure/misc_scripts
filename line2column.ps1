param (
    [Parameter(mandatory)] $path,
    $delimiter = ","
)


$csv = get-content $path | ConvertFrom-Csv -Delimiter $delimiter

$col=@()
$user = $null
$csv.mail |%{
    $current=$_
    if($current.contains(";")){
        $temp = $current -split ";"
        $temp |%{
                $row = New-Object System.Object
                $row | Add-Member -MemberType NoteProperty -Name "user" -Value $_
                $col += $row
                }
    }else{
        $row = New-Object System.Object
        $row | Add-Member -MemberType NoteProperty -Name "user" -Value $current
        $col += $row
    }
}
($col | sort -unique user ) | Export-Csv "out.csv" -NoTypeInformation
write-host ("the output file "+(Get-Location).path+"\out.csv has been created" )
