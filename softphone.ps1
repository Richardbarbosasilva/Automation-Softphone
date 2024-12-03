# first get current username and hostname to later save the file using it


unblock-file -Path "UNC-path-to-this-script" -WarningAction Ignore


###################################################################################### STEP 1 = GET HOSTNAME #########################################################################################################


$hostname = [System.Environment]::MachineName

    Write-Host "$hostname"

$currentuser = $env:USERNAME

    Write-Host "$currentuser"


######################################################################## STEP 2 = create local folder and Copy files from arquivosdti to local disk #################################################################### 


# path to softphone network folder

$networkfoldersoftphone = "UNC-path-to-softphonefolder"

# Path to softphone localhost folder

$destinysoftphone = "C:\"

# Path to softphone exported files

$destinysoftphonefiles = "path-to-your-local-folder-softphone"

# Verify if the network's softphone custom folder does exist

if (Test-Path $networkfoldersoftphone -PathType Container) {

   Write-Host "$networkfoldersoftphone is a directory! Trying to create equivalent folder on the local C: disk"

# create local folder to ClickIP Softphone
   
   New-Item -Path "path-to-softphone-folder" -ItemType Directory

   Write-Host "Created Softphone folder on C:\"

} else {

   Write-Host "Could not create Softphone folder on C:\, verify permissions, path or maybe it already does exists."

}

# Create variable to fetch extensions from UNC folder

$extensions = @("dll", "exe", "xml", "wav", "txt")

# Verify extensions and copy them to C:\

Start-Sleep -Seconds 1

 foreach ($extension in $extensions) {

# list every file on $extensions variable

$files = Get-ChildItem -Path $networkfoldersoftphone -Filter "*.$extension"

Write-Host "$files"

# copy and troubleshoot

if ($files.Count -gt 0) {

# Copy all files to inside $destinysoftphone

  Copy-Item -Path $files.FullName -Destination $destinysoftphonefiles -Force

  Write-Host "$extension files copied with success to local C: disk ClickIP Softphone folder."

} else {

  Write-Host "No $extension file found."

   }
}

Write-Host "Copied files from UNC path to local Folder"


########################################################################### STEP 3: Create symbolic link on Desktop #######################################################################################################

$prefileini = "local-path-to-your-ini" 

if (Test-Path $prefileini -PathType leaf) {

   Write-Host "$prefileini with user's softphone configuration settings found!"

# delete pre setted ini file from UNC to local and rename it
  
  Remove-Item -Path "path-to-remove-old-link (if exist)"           

} else {

   Write-Host "Could not exclude $prefileini or rename file!"

}

##########################################################################################################################################################################################################################

$ClickipsoftphoneExecutable = "local-path-to-softphone-executable"

Write-Host "Creating symbolic link (shortcut) on user's desktop from local installation folder"
 
$shortcutPath = [System.IO.Path]::Combine([System.Environment]::GetFolderPath("Desktop"), "(yoursoftphone) Softphone.lnk")

$shell = New-Object -ComObject WScript.Shell

$shortcut = $shell.CreateShortcut($shortcutPath)

$shortcut.TargetPath = $ClickipsoftphoneExecutable

$shortcut.Save()

Write-Host "Shortcut created on $shortcutPath"


############################################################################# STEP 4: Delete old Clickip softphone folders ################################################################################################

# only if exist
# Define the variables

#$Localappdataclickip = "appdata-softphone-path-folder"

#$Roaminginitfolder = "roaming-softphone-path-folder"



 # Delete ClickIP folder inside roaming appdata

#if (Test-Path $Roaminginitfolder -PathType Container) {

    #Write-Host "$Roaminginitfolder found! Trying to delete it"

    # Delete the folder if it exists

    #Remove-Item -Path "$Roaminginitfolder" -Recurse -Force

    #Write-Host "Deleted $Roaminginitfolder"

    #} else {
    
    #Write-Host "old ClickIP folder could not be deleted at $Roaminginitfolder, maybe it already has been?"

    #}

# Delete ClickIP folder inside Local appdata

#if (Test-Path $Localappdataclickip -PathType Container) {

    #Remove-Item -Path $Localappdataclickip -ItemType Directory

    #Write-Host "Removed old ClickIP folder at $Localappdataclickip"

    #} else {

    #Write-Host "old ClickIP folder could not be deleted at $Localappdataclickip, maybe it already has been?"

    #}

################ STEP 5: COPY ClickIP init file and exclude any pre existence of it on C:\ as "ClickIP Softphone" ##########################

$hostname = [System.Environment]::MachineName

    Write-Host "$hostname"

$currentuser = $env:USERNAME

    Write-Host "$currentuser"

$Roaminginitdestiny = "path-to-your-local-softphone-folder" 

if (Test-Path $Roaminginitdestiny -PathType Container) {

   Write-Host "$Roaminginitfolder with user's softphone configuration settings found!"

   Remove-Item "path-to-old-softphone-symbolic-link"
   
   Write-Host "Softphone.ini deleted (pre stored)"

# Copy user ini file from UNC to local and rename it
                  
   Copy-Item -Path "path-to-your-softphone-ini-file-$currentuser.ini" -Destination "path-to-softphone-local-folder" -Force

   Write-Host "File imported"

   Rename-Item -Path "path-to-your-softphone-ini-file-$currentuser.ini" -NewName "path-to-your-softphone-ini-file-$currentuser.ini\(newfilename).ini" 

   Write-Host "init file was renamed from UNC path to new softphone version name (Softphone)!"

} else {

   Write-Host "Could not copy to $Roaminginitdestiny or rename file!"

}

stop-process -id $PID
