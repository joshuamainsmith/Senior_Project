#include <MsgBoxConstants.au3>
#include <AutoItConstants.au3>
#include <WinAPISysWin.au3>

HotKeySet("{ESC}", "Terminate")

 While 1

 MsgBox($MB_SYSTEMMODAL, "", "Never gonna give you up")
 MsgBox($MB_SYSTEMMODAL, "", "Never gonna let you down")
 MsgBox($MB_SYSTEMMODAL, "", "Never gonna run around")
 MsgBox($MB_SYSTEMMODAL, "", "and desert you!")

 WEnd

 Func Terminate()
    Exit
EndFunc   ;==>Terminate