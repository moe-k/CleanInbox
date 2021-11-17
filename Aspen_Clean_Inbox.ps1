# Script to Delete all Files in Y:\ mapped drive (that points to aspen inbox) older than 3 day(s). 

#Get the drive that is mapped to the aspen inbox
param(
   [string] $Path = $(Read-Host -Prompt 'Please provide drive that is mapped to the aspen inbox, for example if the drive is Y, provide it as ''Y:\''')
)

#Clear console 
Clear-Host

#Check path that is input matches this pattern lower case letter:\ or upper case letter:\ not including c or d (as precaution)
if ($Path -match '[A-Ba-be-zE-Z]:\\') {
   try {

      # create log
      Start-Transcript -Path "C:\Users\khalilmo\Desktop\Desktop Items\ASPEN\Programming\Inbox cleanup\DeleteFiles PowerShell\Logs\$( Get-Date -Format 'MM_dd_yyyy-HH_mm' ).txt" 

      #Get drive portion of the path without the slash for testing if drive is mapped or not
      $mapedDrive = $Path.Substring(0, 2)

      #Check if drive is mapped already and if not map it
      if (!(Test-Path $mapedDrive)) {
         # for testing, the below will need to be commented out when ready for use and the below marked "for actual" will need to be un-commented
         net use $mapedDrive "\\USWHBWD00179973\aspen-inboxcleanup-testing"
         # for actual
         # net use $mapedDrive "\\aspenla1nas08\inbox\ASTShipping"
      }
         
      # Hold how many days back to check and delete, in this case any files older then 3 days will be deleted at the path above
      $Daysback = "-3"
         
      $CurrentDate = Get-Date
         
      $DatetoDelete = $CurrentDate.AddDays($Daysback)
         
      # To get all file extensions recursively Get-Childitem C:\MyDirectory -Recurse | WHERE { -NOT $_.PSIsContainer } | Group Extension -NoElement | 

      # Recersively Remove files older then 3 days old from the aspen inbox
      Get-ChildItem $Path -Recurse -File | `
         Where-Object { $_.LastWriteTime -lt $DatetoDelete } `
      | Remove-Item 
         
      #unmap drive
      net use $Path.Substring(0, 2) /DELETE
      
      # Stop log
      Stop-Transcript
   }
   #catch any errors that occured and display to console
   catch {
      Write-Host $_.Exception.Message
      Write-Host $Error
   }
}
else {
   Write-Host "You either input C drive which is prohobited, or input the mapped drive incorrectly. Please input the mapped drive in the correct format like so Z:\, notice the drive letter is followed by a colon and backslash, so if your mapped drive is z, input z:\ or Z:\"
   Exit-PSSession   
}



