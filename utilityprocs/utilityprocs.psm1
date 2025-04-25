<#
	.SYNOPSIS
	A collection of PowerShell functions commonly used for IT support.

	.DESCRIPTION
	This module contains reusable PowerShell functions. 
	Designed for automation, diagnostics, and real-world IT workflows.

	.AUTHOR
	Christopher "Rowdy" Yates
#>


# region: Function Definitions


<#
	.SYNOPSIS
	Logs a final message and exits the script gracefully.

	.DESCRIPTION
	This function writes a closing log entry, outputs a "Done" message to the terminal, 
	and cleanly terminates the script. Used as a consistent way to end scripts when
	something fatal occurs or when processing finishes intentionally.

	.EXAMPLE
	Exit-Nicely

	.NOTES
	Never have to wonder how to leave without offending anyone again.
#>

#MARK: Exit-Nicely
function Exit-Nicely {
    # Say goodnight Gracie
    Write-Output "Done."
    Write-Output "Consult $Log for details.`n`n" 
    Write-Log $LogFile 3 # Writes a final timestamp to the log
    # Now get off my lawn!
    Exit
}#end: Exit-Nicely



<#
	.SYNOPSIS
	Reads a reference CSV file into memory and logs the process.

	.DESCRIPTION
	This function attempts to import a given CSV file. It logs progress messages, 
	including file discovery and line count. If the file is missing or unreadable, 
	it logs the failure and exits the script using Exit-Nicely.

	.PARAMETER FileIn
	One or more file paths to read as input. Must be a CSV format.

	.EXAMPLE
	$refData = Read-Ref -FileIn "C:\Scripts\input.csv"

	.NOTES
	Everyone loves reading, right?
#>

#MARK: Read-Ref
function Read-Ref {
    param(
        [Parameter (Mandatory = $True)] [String[]] $FileIn #The file to be read
    )
 
    Write-Log $Log 2 3 "Read-Ref is awake."
 
    $ReadIn = @() # Stores CSV data from $FileIn
    $Lines = 0    # Number of lines read in from the file
 
    #Check if the file exists
    Write-Log $Log  2 6 "Looking for the reference file"
    If (Test-Path $FileIn) {
        Write-Log $Log 2 6 "Found it."
    }
    else {
        $logEntry = "Could not find " + $FileIn + ". Terminating the program."
        Write-Log $Log 2 6 $logEntry
        Exit-Nicely
    }
	
    Write-Log $Log 2 6 "Attempting to import the reference file"

    # Try to import the CSV, but exit gracefully if it fails
    If ($ReadIn = Import-Csv $FileIn) {
        # Success! We read the file. Log the number of lines read.
        $Lines = $ReadIn.Count
        $logEntry = "Success, read " + $Lines + " lines."
        Write-Log $Log 2 9 $logEntry
    }
    # Failure! We were not able to read the file, throw error and exit
    else {
        $logEntry = "Could not read " + $FileIn + ". Terminating the program."
        Write-Log $Log 2 9 $logEntry
        Exit-Nicely
    }
	  
    Write-Log $Log 2 3 "Read-Ref is going back to sleep now."
    # That's done. Leave me alone now.
    return $ReadIn
}#end: Read-Ref



<#
    .SYNOPSIS
    Sets the path for the log file relative to the script's location.

    .DESCRIPTION
    This function dynamically sets the path for log output by grabbing the current 
    script's directory and appending a timestamped filename inside a 'Logs' subfolder.
    It's useful for consistent log organization and avoids hardcoded paths.

    .EXAMPLE
    Set-Path

    .NOTES
    Where are we going and why are we in this handbasket?
#>

#MARK: Set-Path
function Set-Path {
    # Get the path of the current script and remember it for later
    $script:CurPath = Split-Path -Parent $Script:MyInvocation.MyCommand.Path
    $date = Get-Date -Format "yyyy-MM-dd_HHmm"
    # Set the path for the log file
    $script:LogFile = $CurPath + "\Logs\Log_$date.log"
}#end: Set-Path



<#
	.SYNOPSIS
	Writes structured log messages to a file with timestamps and indentation.

	.DESCRIPTION
	A flexible logging function used to create or append log entries to a file. 
	Supports startup/shutdown markers, message formatting, and spacing customization.

	.PARAMETER Lgf
	Full path to the log file.

	.PARAMETER Option
	Type of message to write (1 = start, 2 = message, 3 = stop).

	.PARAMETER Space
	Indentation level for message alignment (default = 3).

	.PARAMETER Message
	The message string(s) to write to the log.

	.PARAMETER StartStamp
	Optional: Used to specify a start time.

	.PARAMETER StopStamp
	Optional: Used to specify an end time.

	.PARAMETER Lead
	If 1, message is prefixed with a '#'. If 0, no prefix.

	.PARAMETER Break
	If 1, ends with newline. If 0, no newline.

	.EXAMPLE
	Write-Log "C:\Logs\example.log" 2 4 "Connecting to server..."

	.NOTES
	My eyes bleed less when I read logs now.
#>

#MARK: Write-Log
function Write-Log {
    <# The $Option chooses which type of message we write
		1 - This means it is the start of the program. Write a timestamp.
		2 - This is for all the miscellaneous messages we want to log
		3 - This means the program is ending. Write a timestamp
	#>
    param (
        [Parameter (Mandatory = $True)] [String[]] $Lgf, # The log file
        [Parameter (Mandatory = $True)] [Int[]] $Option, # Type of message to write
        [Parameter (Mandatory = $False)] [Int] $Space = 3, # Amount of spaces to indent
        [Parameter (Mandatory = $False)] [String[]] $Message, # Message to log
        [Parameter (Mandatory = $False)] [DateTime] $StartStamp, # Time of program start
        [Parameter (Mandatory = $False)] [DateTime] $StopStamp, # Time of program termination
        [Parameter (Mandatory = $False)] [Boolean] $Lead = 1, # Option to remove leading pound sign at start of misc messages
        [Parameter (Mandatory = $False)] [Boolean] $Break = 1 # Option to remove line break at end of misc messages
    )
	
    If (Test-Path -Path $Lgf) {
        # Log file was found, all is good
    }
    else {
        # Log file was not found, create it
        $path = $Lgf -split "\\"
        $l = 0
        $levelTotal = $path.length
        While ($l -lt $path.length) {
            $testPath = $path[0]
            $i = 1
            While ($i -le $l) {
                $testPath = $testPath + "\" + $path[$i]
                $i++
            }

            If (Test-Path -Path $testPath) {
                # All is good
            }
            else {
                if ($l -eq ($levelTotal - 1)) {
                    New-Item -ItemType "File" -Path $testPath >> $null
                }
                else {
                    New-Item -ItemType "Directory" -Path $testPath >> $null
                }
            }

            $l++
        }
		
    }

    $TimeStamp = Get-Date -Format "yyyy.MM.dd HH:mm:ss"
 
    switch ($Option) {
        1 {
            Add-Content $Lgf ""
            Add-Content $Lgf "##################################################"
            if ($null -ne $StartStamp) {
                Add-Content $Lgf "# Program is starting at $StartStamp"
            }
            else {
                Add-Content $Lgf "# Program is starting at $TimeStamp"
            }
        }
        2 {
            $pad = ""
            $i = 0
            While ($i -lt $Space) {
                $pad += " "
                $i++
            }
            if ($Lead -eq 0) {
                $logEntry = $pad + $Message
            }
            else {
                $logEntry = "# " + $pad + $Message
            }
            if ($Break -eq 0) {
                Add-Content $Lgf $logEntry -NoNewLine		  
            }
            else {
                Add-Content $Lgf $logEntry
            }
        }
        3 {
            if ($null -ne $StopStamp) {
                Add-Content $Lgf "# Program is ending at $StopStamp"
            }
            else {
                Add-Content $Lgf "# Program is ending at $TimeStamp"
            }
            if (($null -ne $StartStamp) -AND ($null -ne $StopStamp)) {
                $totalTime = New-TimeSpan -Start $StartStamp -End $StopStamp
                Add-Content $Lgf "# Total runtime: $totalTime"
            }
            Add-Content $Lgf "##################################################"
            Add-Content $Lgf ""
        }
    }
	
    return 0 | Out-Null
}# End Write-Log



# endregion


# region: Module Exports

Export-ModuleMember -Function `
    Exit-Nicely, `
    Read-Ref, `
    Set-Path, `
    Write-Log

# endregion