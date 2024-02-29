<#
   Created by BJ Rutledge 2024-02-28
   This tool is for whenever you have a shit ton of files that you need to push to github and you 
   can't because the repo is to god-damn big... This will only work if the files are staged but not 
   commited. 

#>

function Push-Repo {
   param (
      # Directory of the repository.
      [string][Parameter(Mandatory=$true, Position=0)]
      $Directory,
  
      # Commit message.
      [string][Parameter(Mandatory=$true, Position=1)]
      $CommmitMessage
  )

   [int] $MIN_LEN_MESSAGE = 4;

   if($CommmitMessage.Length -lt $MIN_LEN_MESSAGE){
      Write-Error "You're gonna have to pass a commit message longer than that. Git's kinda picky about that shit. And besides, it's just bad practice! Come on man! Get it together!";
      return;
   }
   
   try {
      Write-Host "Setting location: " + $Directory; 
      Set-Location $Directory;
      Write-Host "Checking git status...";
      $status = git status;
   }
   catch {
      <#Do this if a terminating exception happens#>
      Write-Error "Oops. That directoy isn't any good. Get your shit together and hit me up.";
      return 
   }

   if(-not $status){
      Write-Error "Dude! The directory you passed isn't even a freakin' repo. Get your shit together and hit me up. I'm tryin' to help here, but... Fuck man. I'm only bits and bytes.";
      return; 
   }
   if($status -isnot [array]){ 
      Write-Error "Oh boy... We have an issue! When I run the 'git status' command, I'm expecting an array but getting:";
      Write-Error $status.GetType(); 
      return; 
   }

   Write-Host "Ok, everything checks out so far. Let's get going..."

   <#There is a special character in the beginning of untract files, for some reason. 
      To overcome this, we will store the special char and check against it. 
   #>
   [int]$specialCharValue = 9; 
   $specialChar = [char]$specialCharValue; 
   #grab all of the filenames that are not staged and store them in a list. 
   $list = New-Object "System.Collections.Generic.List[string]"; 
   
   foreach($stringEntry in $status){
      if($stringEntry.Contains("Modified:") -or $stringEntry.Contains("   ")){
         $splitString = $stringEntry.Split(" ");
         $fileName = $splitString[$splitString.Length - 1];
         if(-not $list.Contains($fileName)){
            $list.Add($fileName); 
         }
      }
      elseif($stringEntry.Contains($specialChar)){
         $splitString = $stringEntry.Split($specialChar);
         $fileName = $splitString[$splitString.Length - 1];
         $list.Add($fileName); 
         if(-not $list.Contains($fileName)){
            $list.Add($fileName); 
         }
      }

   }
      
   #Batch the files and process them. 
   BatchFiles -list $list | ProcessBatch -commitMessage $CommmitMessage;  
   
   
   Write-Host "Dude, that was a lot... We got it done though. You're welcome!";
   # if($successful){
   #    Write-Host "Dude, that was a lot... We got it done though. You're welcome!";
   # }
   # else {
   #    Write-Host "Sorry things didn't work out. Feel free to fix your fuckups and try agian. I know it wasn't me! 🤣";
   # }
   
}

# Push-Repo . "test" -Verbose


function BatchFiles{
   param (
      
      [System.Collections.Generic.LinkedList[string]]
      [Parameter(Mandatory=$true, Position=0)]
      $list
   )
   $result = New-Object "System.Collections.Generic.List[System.Collections.Stack]"; 
   $stack = New-Object System.Collections.Stack
   [bigint]$MAX_BATCH_SIZE = 2147483648;
   [bigint]$batchSize = 0;
   <# 
   Iterate through the files in the list and create batches of 
   files < 2GB in size. 
   #>
   foreach ($file in $list) {
      $fileSize = GetSize $file;
      if($batchSize + $fileSize -lt $MAX_BATCH_SIZE){
         $batchSize += $fileSize;
         $stack.Push($file); 
      }
      else{
         $result.Add($stack.Clone()); 
         $stack.clear(); 
         $batchSize = 0;
      }
   }

   return $result; 
}

function ProcessBatch {
   param (
      [Parameter(Mandatory=$true, Position=0, ValueFromPipeline=$true)]
      $stackList,
      [string]
      [Parameter(Mandatory=$true, Position=1)]
      $commitMessage
   )
   $count = 0; 
   foreach($stack in $stackList){
      while($stack.Count > 0){
         $file = $stack.Pop(); 
         # Write-Host "Adding: " + $file; 
         git add $file; 
      }
      $message = $commitMessage + '0' + (++$count); 
      Write-Host "Commiting message:" $message; 
      git commit -m $message; 
      git push; 
   }
   
}

function GetSize {
   param (
    [string]$FilePath
   )

   # Check if the file exists
   if (Test-Path $FilePath -PathType Leaf) {
      # Get the size of the file
      $fileSize = (Get-Item $FilePath).Length;
      # Write-Output "The size of the file '$FilePath' is $fileSize bytes.";
      return $fileSize; 
   } else {
      # Write-Output "File '$FilePath' not found."
      Write-Error "File not found."
   }

}

