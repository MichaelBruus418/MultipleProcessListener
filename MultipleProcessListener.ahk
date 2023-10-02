; ***********************************************************************************
; --- Multiple Process Listener ---
; Description:
; Listens for activation/termination of user defined processes. 
; Activates specific windows power schemes in accordance.
; When process start is detected, Audio Power Plan is activated.
; When process end is dectected and no other process end is pending, balanced power scheme is activated. 

; Requirements
; AutoHotKey v2

; Author
; Mihael Bruus, 2023
; ***********************************************************************************

; --- Config --------------------------------------------------------------------------------
; Define name of processes that will trigger loading of Audio power plan
waitForProcessStart := ["Cubase11.exe", "VST Live.exe"]

; Path to Audio power plan
audioPowerPlan := "D:\PowerPlan_AudioPower.bat"

; Path to Balanced power plan (default)
balancedPowerPlan := "D:\PowerPlan_Balanced.bat"

; Set debugging mode (prints info to message box)
debug := 0
; -------------------------------------------------------------------------------------------

; Holds names of processes that must be checked for termination
waitForProcessEnd := []
; Path to last activated power plan
activePowerPlan := ""

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
			; Activate Audio Power Plan if not already running
			if (activePowerPlan != audioPowerPlan) {
				output("Activating Audio Power Plan")
				activePowerPlan := audioPowerPlan
				Run activePowerPlan,,"Hide"
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
			; Activate Balanced Power Plan if not already running AND waitForProcessEnd is empty
			if (waitForProcessEnd.length = 0 and activePowerPlan != balancedPowerPlan) {
				output("Activating Balanced Power Plan")
				activePowerPlan := balancedPowerPlan
				Run activePowerPlan,,"Hide"
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

