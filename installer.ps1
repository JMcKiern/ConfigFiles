# Run this before script: Set-ExecutionPolicy Bypass -Scope Process -Force

function Update-EnvVars() {
	$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
}

Write-Host "Installing Chocolatey"
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

Update-EnvVars

choco install packages.config -y

Update-EnvVars

#New-Item -ItemType SymbolicLink -Path ~ -Name .vimrc -Value "$PSScriptRoot/.vimrc"
if (Test-Path "~/.vimrc") {
	Move-Item -Path "~/.vimrc" -Destination "~/.vimrc.bak"
}
Copy-Item -Path "$PSScriptRoot/.vimrc" -Destination "~/.vimrc"

if (-not (Test-Path "~/vimfiles/autoload")) {
	md ~\vimfiles\autoload
	$uri = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
	(New-Object Net.WebClient).DownloadFile(
		$uri,
		$ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath(
			"~/vimfiles/autoload/plug.vim"
		)
	)
}

vim +PlugInstall +qall

git config --global core.editor "'$(Get-Command vim | % { $_.Source -replace '\\', '/'})'"
git config --global core.autocrlf true
