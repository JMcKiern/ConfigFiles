# dotfiles

## Installation

### Linux

`curl https://raw.githubusercontent.com/JMcKiern/dotfiles/master/install.sh -o install.sh && chmod +x install.sh && ./install.sh`


### Windows

Run in elevated PowerShell

`Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/JMcKiern/dotfiles/master/install.ps1'))`
