# Paths
$src = 'C:\Users\matur\source'
$repos = 'C:\Users\matur\source\work\repos'
$pRepos = 'C:\Users\matur\source\personal\repos'

# Functions
function new-branch {
  param(
     [parameter(Mandatory=$true)]
     [Alias("name")]
     [string]$BranchName
  )
  $uncommitted = git status -s
  if ($null -ne $uncommitted) {
      Write-Host "Uncommitted changes found. A clean working tree is required." -ForegroundColor Red
      return
  }
  git checkout main
  git pull
  $CompleteBranchName = "dev/$env:USERNAME/$BranchName"
  git checkout -b $CompleteBranchName origin/main
  git push --set-upstream origin $CompleteBranchName
  Write-Host "Feature branch ($CompleteBranchName) created and checked out" -ForegroundColor Green
}

function export-profile($dest) {
  copy-item $profile $dest
}

# Aliases
function touch($fileName) {
  echo '' > $fileName
}

function ga($listArgs) {
  git add $listArgs
}

function gc($msg) {
  git commit -m $msg
}

function np($file) {
  & 'C:\Program Files\Notepad++\notepad++.exe' $file
}

# Oh My Posh setup
oh-my-posh init pwsh | Invoke-Expression
# oh-my-posh init pwsh --config "https://raw.githubusercontent.com/matthewaturner/scripts/master/ohmyposh/config.json" | Invoke-Expression
oh-my-posh init pwsh --config "C:\Users\matur\source\personal\repos\scripts\ohmyposh\config.json" | Invoke-Expression
