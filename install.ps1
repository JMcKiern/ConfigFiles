# Run this before script: Set-ExecutionPolicy Bypass -Scope Process -Force

function Update-EnvVars() {
	$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
}

Write-Host "Installing Chocolatey"
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

Update-EnvVars

Write-Host "Installing packages"
if (Test-Path "$PSScriptRoot/windows/packages.config") {
	choco install "$PSScriptRoot/windows/packages.config" -y
} else {
	$pkgFP = "$env:TMP\packages.config"
	Invoke-WebRequest 'https://raw.githubusercontent.com/JMcKiern/dotfiles/master/windows/packages.config' -OutFile $pkgFP
	choco install $pkgFP -y
	Remove-Item $pkgFP
}

Update-EnvVars

Write-Host "Setting up vim"
if (Test-Path "~/.vimrc") {
	Move-Item -Path "~/.vimrc" -Destination "~/.vimrc.bak" -Force
}

if (Test-Path "$PSScriptRoot/files/.vimrc") {
	#New-Item -ItemType SymbolicLink -Path ~ -Name .vimrc -Value "$PSScriptRoot/.vimrc"
	Copy-Item -Path "$PSScriptRoot/files/.vimrc" -Destination "~/.vimrc"
} else {
	Invoke-WebRequest 'https://raw.githubusercontent.com/JMcKiern/dotfiles/master/files/.vimrc' -OutFile "~/.vimrc"
}

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

Write-Host "Setting up git"
git config --global core.editor "'$(Get-Command vim | % { $_.Source -replace '\\', '/'})'"
git config --global core.autocrlf true
git config --global user.email "jmckiern@tcd.ie"
git config --global user.name "jmckiern"