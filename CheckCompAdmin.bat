echo "Helper BatchScript to run the powershell script with one-click"
echo " "

set scpath=%cd%
set fileloc=%scpath%\checkdualboot.ps1
set finalloc="C:\Users\Public"
xcopy /i %fileloc% %finalloc%

powershell -noprofile -command "&{ start-process powershell -ArgumentList '-noprofile -noexit -file C:\Users\Public\checkdualboot.ps1' -verb RunAs}"

set /p temp="Hit Enter to Finish "
IF EXIST %finalloc%\checkdualboot.ps1 DEL %finalloc%\checkdualboot.ps1