$excel = New-Object -ComObject excel.application
$excel.visible = $False
$workbook = $excel.Workbooks.Open('hyperlinks.xlsx')
$links = $workbook.Worksheets(1).hyperlinks

($links | select Texttodisplay,address) | Export-Csv -NoTypeInformation "out.csv" -Encoding UTF8

#Looping the Workbook sheet to check all the sheets in the Excel
<#
for ($loop_index = 1; $loop_index -le $workbook.Sheets.Count; $loop_index++)
{
#Assigining the hyperlinks to the Variable from each sheet
$Sheet = $workbook.Worksheets($loop_index).Hyperlinks
#looping the Sheet one by one and store it in collection
$Sheet | ForEach-Object 
    {
    $Range = $_.Range
    [pscustomobject]@{
        SheetName = $workbook.Worksheets($loop_index).name
        LinkText = $_.TextToDisplay
        Url = $_.Address
        Cell = $Range.Row , $Range.Column 
       
                     }
    }
}
#>

#Kill the excel
Stop-Process -name excel
