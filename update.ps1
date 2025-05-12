# Symlink and force (delete file if it exists and replace with link)
function New-SymbolicLink {
    param (
        [Parameter(Mandatory = $true)]
        [string]$LinkPath,

        [Parameter(Mandatory = $true)]
        [string]$TargetPath
    )

    # Check if the link already exists
    if (Test-Path $LinkPath) {
        Write-Output "Removing existing file: $LinkPath"
        Remove-Item -Path $LinkPath -Force
    }

    # Create a new symbolic link
    Write-Output "Creating new symbolic link: $LinkPath -> $TargetPath"
    New-Item -Path $LinkPath -ItemType SymbolicLink -Value $TargetPath | Out-Null

    # Verify the link was created
    if (Test-Path $LinkPath) {
        Write-Output "Symbolic link successfully created!"
    } else {
        Write-Error "Failed to create symbolic link."
    }
}

$windowsNvimPath = "$HOME\AppData\Local\nvim"
echo "Neovim path is: $windowsNvimPath"

#Create symlinks for all dotfiles
#New-SymbolicLink -LinkPath $HOME\.vimrc -TargetPath $HOME\dotfiles\.vimrc 
New-SymbolicLink -LinkPath $HOME\.gitconfig -TargetPath $HOME\dotfiles\.gitconfig 

# Copy over rest of lua configuration
New-SymbolicLink -LinkPath $HOME\AppData\Local\nvim\lua -TargetPath $HOME\dotfiles\neovim\lua
# Must do this after, because previous command will delete this file.
New-SymbolicLink -LinkPath $HOME\AppData\Local\nvim\init.lua -TargetPath $HOME\dotfiles\neovim\init.lua 

# Make the folder where snippets are actually stored if it doesn't exist
$nvimSnippetsPath = "${windowsNvimPath}\UltiSnips" 
New-Item -Path  $nvimSnippetsPath -ItemType Directory -Force

# TODO need to link over spellcheck files, but I don't type much on windows computers.

# Copy any new snippets files to dotfiles repo
$customSnippetFolder = $nvimSnippetsPath
$dotfilesUltiSnipsFolder = "$HOME\dotfiles\UltiSnips"
echo "Custom snippets folder is: $customSnippetFolder"
echo "Dotfiles snippets folder is: $dotfilesUltiSnipsFolder"
Get-ChildItem -Path $customSnippetFolder -Recurse | ForEach-Object {
    $targetPath = $_.FullName -replace [regex]::Escape($customSnippetFolder), $dotfilesUltiSnipsFolder
	    if (-Not (Test-Path $targetPath)) {
		    echo "Creating new snippet file: $targetPath"
			    Copy-Item -Path $_.FullName -Destination $targetPath
    }
}

# Create symlinks for snippets pointing back to dotfiles folder
Get-ChildItem -Path $dotfilesUltiSnipsFolder | ForEach-Object {
     $targetPath = $_.FullName -replace [regex]::Escape($dotfilesUltiSnipsFolder), $customSnippetFolder
    echo "New symlink path is: $targetPath"

    New-SymbolicLink -LinkPath  $targetPath -TargetPath $_.FullName
}
