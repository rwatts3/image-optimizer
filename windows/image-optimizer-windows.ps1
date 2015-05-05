<#
   @platform windows
   @script powershell
   @version 1.0.0
   @author Ryan Watts
   Uses ImageMagick to convert files within the directory the code is ran under. 
#>

#Before processing begins prompt the user for the executed folder path.
function getImageDirectory {
Param ([string]$dir=(Read-Host "Set the Image's directory you are optimizing."))
write-host "Proceeding optimization on $dir"
}


function optimizeImages{
   $images = Get-ChildItem . -Recurse | where{$_.Extension -match "gif|jpg|jpeg|png"}

   for ($i = 0; $i -lt $images.count; $i++) {

      $preOptimization = identify $images[$i].FullName
      mogrify -strip -interlace Plane -quality 80% -density 72 $images[$i].FullName
      $postOptimization = identify $images[$i].FullName
      
      echo "Optimized Images Log"
      echo "This document contains the result of your image process."
      echo "----------------------------------------------------------------------------"
      echo $images[$i]
      echo Before $preOptimization
      echo " "
      echo After $postOptimization
      echo "----------------------------------------------------------------------------"
   }
 
}

function processImages{
   #Export the results to a text file. 
   optimizeImages | Out-File -Enc ASCII -Append optimization-images-log.txt
   echo "PROCESS COMPLETE!"
   echo "Review the optimization-images-log.txt file to see details."
}

getImageDirectory

processImages

