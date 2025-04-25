<###############################################################################
### Description: Various functions I tend to reuse.                          ###
###                                                                          ###
################################################################################
### Notes:                                                                   ###
###    - May god have mercy on your soul.                                    ###
###                                                                          ###
################################################################################
### Created some time before 2024-03-24 by Christopher "Rowdy" Yates         ###
### Last updated 2024-03-24 by Christopher "Rowdy" Yates                     ###
###############################################################################>


<###############################################################################
### Description: Writes exit info to log and exits the program.              ###
###############################################################################>
#MARK: Exit-Nicely
function Exit-Nicely {
	#Say goodnight Gracie
	Write-Output "Done."
	Write-Output "Consult $Log for details.`n`n"   
	Write-Log $LogFile 3
	#Now get off my lawn!
	Exit
 }#end: Exit-Nicely



<###############################################################################
### Description: Reads in data from a given reference file.                  ###
###############################################################################>
#MARK: Read-Ref
 function Read-Ref {
	param(
	   [Parameter (Mandatory=$True)] [String[]] $FileIn #The file to be read
	)
 
	Write-Log $Log 2 3 "Read-Ref is awake."
 
	$ReadIn = @() #The data read in from the file
	$Lines = 0    #The number of lines read in from the file
 
	#Check if the file exists
	Write-Log $Log  2 6 "Looking for the reference file"
	If(Test-Path $FileIn){
	   Write-Log $Log 2 6 "Found it."
	}else {
	   $logEntry = "Could not find " + $FileIn + ". Terminating the program."
	   Write-Log $Log 2 6 $logEntry
	   Exit-Nicely
	}
	
	#Since we found the file, let's read it
	Write-Log $Log 2 6 "Attempting to import the reference file"
	If($ReadIn = Import-Csv $FileIn){
	   $Lines = $ReadIn.Count
	   $logEntry = "Success, read " + $Lines + " lines."
	   Write-Log $Log 2 9 $logEntry
	}
	else{
	   $logEntry =  "Could not read " + $FileIn + ". Terminating the program."
	   Write-Log $Log 2 9 $logEntry
	   Exit-Nicely
	}
	  
	Write-Log $Log 2 3 "Read-Ref is going back to sleep now."
	#That's done. Leave me alone now.
	return $ReadIn
 }#end: Read-Ref



<###############################################################################
### Description: Writes to a log file with indentions for readability.       ###
###############################################################################>
#MARK: Write-Log
function Write-Log {
	param (
	   [Parameter (Mandatory=$True)] [String[]] $Lgf, #The log file
	   [Parameter (Mandatory=$True)] [Int[]] $Option, #Type of message to write
	   [Parameter (Mandatory=$False)] [Int] $Space = 3, #Amount of spaces to indent
	   [Parameter (Mandatory=$False)] [String[]] $Message, #The message
	   [Parameter (Mandatory=$False)] [DateTime] $StartStamp, #Time of program start
	   [Parameter (Mandatory=$False)] [DateTime] $StopStamp, # Time of program termination
	   [Parameter (Mandatory=$False)] [Boolean] $Lead = 1, # Option to remove leading pound sign at start of misc messages
	   [Parameter (Mandatory=$False)] [Boolean] $Break = 1 # Option to remove line break at end of misc messages
	)
	
	If(Test-Path -Path $Lgf){
		# Log file was found, all is good
	}else{
		$path = $Lgf -split "\\"
		$l = 0
		$levelTotal = $path.length
		While($l -lt $path.length){
			$testPath = $path[0]
			$i = 1
			While($i -le $l){
				$testPath = $testPath + "\" + $path[$i]
				$i++
			}

			If(Test-Path -Path $testPath){
				# All is good
			}else{
				if($l -eq ($levelTotal - 1)){
					New-Item -ItemType "File" -Path $testPath >> $null
				}else{
					New-Item -ItemType "Directory" -Path $testPath >> $null
				}
			}

			$l++
		}
		
	}

	$TimeStamp = Get-Date -Format "yyyy.MM.dd HH:mm:ss"
 
	#The $Option chooses which type of message we write
	switch ($Option){
		1{ #This means it is the start of the program. Write a timestamp.
			Add-Content $Lgf ""
			Add-Content $Lgf "##################################################"
			if($null -ne $StartStamp){
				Add-Content $Lgf "# Program is starting at $StartStamp"
			}else{
				Add-Content $Lgf "# Program is starting at $TimeStamp"
			}
		}
	   2{ #This is for all the miscellaneous messages we want to log
			$pad = ""
			$i = 0
			While($i -lt $Space){
				$pad += " "
				$i++
			}
			if($Lead -eq 0){
				$logEntry = $pad + $Message
			}else{
				$logEntry = "# " + $pad + $Message
			}
			if($Break -eq 0){
				Add-Content $Lgf $logEntry -NoNewLine		  
			}else{
				Add-Content $Lgf $logEntry
			}
	   }
	   3{ #This means the program is ending. Write a timestamp
			if($null -ne $StopStamp){
				Add-Content $Lgf "# Program is ending at $StopStamp"
			}else{
				Add-Content $Lgf "# Program is ending at $TimeStamp"
			}
			if(($null -ne $StartStamp) -AND ($null -ne $StopStamp)){
				$totalTime = New-TimeSpan -Start $StartStamp -End $StopStamp
				Add-Content $Lgf "# Total runtime: $totalTime"
			}
			Add-Content $Lgf "##################################################"
			Add-Content $Lgf ""
	   }
	}
	
	return 0 | Out-Null
 }# End Write-Log



#MARK: Code Snippets

<###############################################################################
### Description: Sets path for log file                                      ###
###############################################################################>
$LogPath = Split-Path -Parent $Script:MyInvocation.MyCommand.Path
$date = Get-Date -Format "yyyy-MM-dd_HHmm"
$LogFile = $LogPath  + "\Logs\Log_$date.log"


