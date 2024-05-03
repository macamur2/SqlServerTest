$countries = 1..3 | ForEach-Object {
    "$($_),Pais $_"
}

$header = "CountryId,CountryName"

$content = $header + "`n" + ($countries -join "`n")
[System.IO.File]::WriteAllText('./archivos/Countries.csv', $content, [System.Text.Encoding]::UTF8)


$addressHeader = "AddressId,Street,City,StateProvince,PostalCode,CountryId"

$addressContent = 1..3 | ForEach-Object {
    "$($_),Calle $_,Ciudad $_,Estado $_,0000$_,$_"
}

$addressCsv = $addressHeader + "`n" + ($addressContent -join "`n")
[System.IO.File]::WriteAllText('./archivos/Address.csv', $addressCsv, [System.Text.Encoding]::UTF8)


$customersHeader = "CustomerId,CustomerName,ContactName,AddressId"
$customersContent = 1..3 | ForEach-Object {
    "$($_),'Cliente $_','Contacto $_',$_"
}
$customersCsv = $customersHeader + "`n" + ($customersContent -join "`n")
[System.IO.File]::WriteAllText('./archivos/Customers.csv', $customersCsv, [System.Text.Encoding]::UTF8)

$productsHeader = "ProductId,ProductName"
$productsContent = 1..3 | ForEach-Object {
    "$($_),'Producto $_'"
}
$productsCsv = $productsHeader + "`n" + ($productsContent -join "`n")
[System.IO.File]::WriteAllText('./archivos/Products.csv', $productsCsv, [System.Text.Encoding]::UTF8)

$vatTypesHeader = "VatTypeId,Description,VatRate"
$vatTypesContent = 1..3 | ForEach-Object {
    "$($_),'IVA Tipo $_',$(10.00 * $_)"
}
$vatTypesCsv = $vatTypesHeader + "`n" + ($vatTypesContent -join "`n")
[System.IO.File]::WriteAllText('./archivos/VatTypes.csv', $vatTypesCsv, [System.Text.Encoding]::UTF8)



$invoicesHeaderHeader = "InvoiceId,InvoiceDate,CustomerId,AddressId,TaxBase,TotalVat,Total"
                                   
$startDate = Get-Date "2020-01-01"
$endDate = Get-Date "2024-12-31"
$rangeDays = New-TimeSpan -Start $startDate -End $endDate

$invoicesHeaderContent = 1..10000 | ForEach-Object {
    $randomDays = Get-Random -Minimum 0 -Maximum $rangeDays.Days
    $invoiceDate = $startDate.AddDays($randomDays).ToString("yyyy-MM-dd")
    $customerId = Get-Random -Minimum 1 -Maximum 4
    $addressId = Get-Random -Minimum 1 -Maximum 4
    "$($_),$invoiceDate,$customerId,$addressId,$(1000.00 * $_),$(210.00 * $_),$(1210.00 * $_)"
}

$invoicesHeaderCsv = $invoicesHeaderHeader + "`n" + ($invoicesHeaderContent -join "`n")

[System.IO.File]::WriteAllText('./archivos/InvoicesHeader.csv', $invoicesHeaderCsv, [System.Text.Encoding]::UTF8)




$invoicesDetailHeader = "InvoiceId,RowNumber,ProductId,Description,Quantity,UnitPrice,Discount,VatTypeId,TotalLine"

$invoicesDetailContent = 1..10000 | ForEach-Object {
    $invoiceId = $_
    $details = 1..50 | ForEach-Object {
        $rowNumber = $_
        $productId = Get-Random -Minimum 1 -Maximum 4
        $description = "Detalle $rowNumber"
        $quantity = 10
        $unitPrice = 100.00
        $discount = 0
        $vatTypeId = if ($rowNumber % 2 -eq 0) { 2 } else { 3 }
        $totalLine = 1000.00

        "$invoiceId,$rowNumber,$productId,$description,$quantity,$unitPrice,$discount,$vatTypeId,$totalLine"
    }

    $details -join "`n"
}


$invoicesDetailCsv = $invoicesDetailHeader + "`n" + ($invoicesDetailContent -join "`n")

[System.IO.File]::WriteAllText('./archivos/InvoicesDetail.csv', $invoicesDetailCsv, [System.Text.Encoding]::UTF8)
