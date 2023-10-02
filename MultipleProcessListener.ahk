; ***********************************************************************************
; --- Multiple Process Listener ---
; Description:
; Listens for activation/termination of user defined processes. 
; Runs a batch file (or whatever you wish) in accordance.

; Requirements
; AutoHotKey v2

; Author
; Mihael Bruus, 2023
; ***********************************************************************************

; --- Config --------------------------------------------------------------------------------
; Define name of processes we'll observe
waitForProcessStart := ["Cubase11.exe", "VST Live.exe"]

; Path to Process Started batch file.
startedPath := "D:\ProcessStarted.bat"

; Path to All Processes Ended batch file.
endedPath := "D:\AllProcessesEnded.bat"

; Set debugging mode (prints info to message box)
debug := 0
; -------------------------------------------------------------------------------------------

; Holds names of processes that must be checked for termination
waitForProcessEnd := []
; Path to currently (i.e. last) executed batch file.
currentPath := ""

loop 
{
	; --- Check for process execution ---
	i := 1
	while (i <= waitForProcessStart.length) {
		output("Checking if process has started: " waitForProcessStart[i])
		if (ProcessExist(waitForProcessStart[i])) {
			output("Process has started: " waitForProcessStart[i])
			waitForProcessEnd.push(waitForProcessStart[i])
			waitForProcessStart.removeAt(i)
			if (currentPath != startedPath) {
				output("Calling startedPath")
				currentPath := startedPath
				Run currentPath,,"Hide"
			}
		}
		else {
			i++
		}
	}

	; --- Check for process termination ---
	i := 1
	while (i <= waitForProcessEnd.length) {
		output("Checking if process has ended: " waitForProcessEnd[i])
		if (!ProcessExist(waitForProcessEnd[i])) {
			output("Process has ended: " waitForProcessEnd[i])
			waitForProcessStart.push(waitForProcessEnd[i])
			waitForProcessEnd.removeAt(i)
			if (waitForProcessEnd.length = 0 and currentPath != endedPath) {
				output("Calling endedPath")
				currentPath := endedPath
				Run currentPath,,"Hide"
			}
		}
		else {
			i++
		}
	}
	
	sleep 100
}

; Prints txt to message box in debugging mode
output(txt) {
	if (debug) {
		MsgBox txt
	}
}

