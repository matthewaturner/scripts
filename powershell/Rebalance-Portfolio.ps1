param (
    [string]$filename
)

# Define the desired stock allocation
$target_allocations = @{
    "US Stocks"=@{ "FXAIX"=.26; };
    "International Stocks"=@{ "FZILX"=.1; };
    "Bonds"=@{ "FTBFX"=.15; "FNBGX"=.2 };
    "Cash"=@{ "SPAXX**"=0 };
	"MSFT"=@{ "MSFT"=.29 };
}

# Flatten the list of stocks -> allocation percentages
$asset_allocations = @{}
$sanity_sum = 0

foreach ($bucket in $target_allocations.Keys) {
    foreach ($symbol in $target_allocations[$bucket].Keys) {
        if ($bucket -ne "Cash") {
            $asset_allocations.Add($symbol, $target_allocations.Item($bucket).Item($symbol))
        }
        $sanity_sum = $sanity_sum + $target_allocations.Item($bucket).Item($symbol)
    }
}

# Have seen floating point errors so round to nearest .001
$rounded = [System.Math]::Round($sanity_sum, 3)
if ($rounded -ne 1) {
    write-host ("Your target allocations sum to {0}!" -f $sanity_sum) -ForegroundColor Red
    exit
} else {
    write-host "Your targe allocations sum to 1."
}

$csv = import-csv "$filename"

$positions = $csv | where-object { $_.symbol.length -gt 1 }
$positions | foreach-object -process {
    $_.'Current Value' = $_.'Current Value' -replace '[^\d.]'
}

$total_portfolio_value = ($positions | measure-object 'Current Value' -sum).Sum

write-host ("Total Portfolio Value: {0}" -f $total_portfolio_value)

$assets = $asset_allocations.keys
foreach ($position in $positions) {
	$assets += $position.Symbol
}

foreach ($symbol in $assets | select -unique) {
    $target = $asset_allocations.Item($symbol)*$total_portfolio_value
    $position = $positions | where-object { $_.symbol -eq $symbol } | select-object -First 1
    $value = $position.'Current Value'
    if ($null -eq $value) {
        $value = 0
    }

    write-host ""
    write-host ("Symbol: {0}`tCurrent Value: {1}`tTarget Value: {2}" -f $symbol, $value, $target)
    if ($target -gt $value) {
        write-host ("BUY $ {0} OF {1}" -f [Math]::Round($target - $value, 2), $symbol) -ForegroundColor Green
    } else {
        write-host ("SELL $ {0} OF {1}" -f [Math]::Round($value - $target, 2), $symbol) -ForegroundColor Red
    }
}