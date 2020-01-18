$ComputerSystem = Get-WmiObject -Query "select * from Msvm_ComputerSystem where ElementName = 'MY_VM_NAME'" -Namespace "root\virtualization\v2"
$Keyboard = Get-WmiObject -Query "ASSOCIATORS OF {$($ComputerSystem.path.path)} WHERE resultClass = Msvm_Keyboard" -Namespace "root\virtualization\v2"

$Keyboard.InvokeMethod("TypeText","Hello world!") # Type 'Hello World!'
$Keyboard.InvokeMethod("TypeKey","13") # Press enter
	
