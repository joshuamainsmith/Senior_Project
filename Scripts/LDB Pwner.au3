; ===============================================================================================================================
; Name ..........:	MTSkin UDF Example
; Version .......:	v1.0
; Author ........:	Taskms4
; ===============================================================================================================================
#RequireAdmin
#Region "Global Const" -------------------------------------------------------------------------------------

;#Program Info. Constants
GLOBAL Const $TITLE="LDB Pwner"
GLOBAL Const $SUBTITLE="conkie asnure15 jmb"
GLOBAL Const $SUBTITLE2="authors"

;#GUI SIZE Constants
GLOBAL Const $GUI_WIDTH=552
GLOBAL Const $GUI_HEIGHT=322
GLOBAL Const $CLOSE_BTN_WIDTH=30
GLOBAL Const $CLOSE_BTN_HEIGHT=30
;:::
GLOBAL Const $GUI_MENUBKG_WIDTH=142
;:::
GLOBAL Const $GUI_MENUBTN_WIDTH=132
GLOBAL Const $GUI_MENUBTN_HEIGHT=25
GLOBAL Const $GUI_MENUBTN_LEFT=6
GLOBAL Const $GUI_MENUBTN_TOP_START=90
GLOBAL Const $GUI_MENUBTN_SEPARATOR=$GUI_MENUBTN_HEIGHT+9

#EndRegion "Global Const" ----------------------------------------------------------------------------------


#Region "Include Files" ------------------------------------------------------------------------------------

#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <ButtonConstants.au3>
#Include <WinAPI.au3>
#include <SendMessage.au3>
#include "MTSkin-UDF.au3"	;#(Check that this path is correct)

#EndRegion "Include Files" ---------------------------------------------------------------------------------



;#GUI Handle/hWND & Buttons Handles/ControlIDs
Global $GUI_WHNDL=0
Global $GUI_CLOSEBTN=0, $GUI_MINIMIZEBTN=0

;#Menu Items
   Dim $MenuEntries[4]=["", "", "", ""]
;#Flag for Over Detection (each Menu-Item above must have one)
   Global $OverFlag[4]=[False, False, False, False]

;#Colors Settings
_MTSkin_GUISetSkin("DarkFlatUIBlue")



#Region "GUI CREATION" ------------------------------------------------------------------------

   Local $Handles=_MTSkin_GUICreate("MTSkin_Example", $GUI_WIDTH, $GUI_HEIGHT, @DesktopWidth /2.95, @DesktopHeight /3.2)

   $GUI_WHNDL=$Handles[0]		;_ $Handles[0] = "GUI windows handle"
   $GUI_CLOSEBTN=$Handles[1]	;_ $Handles[1] = "Close button controlID"
   $GUI_MINIMIZEBTN=$Handles[2]	;_ $Handles[2] = "Minimize button controlID"

   Local $MenuItems=_MTSkin_GUICreateMenu($GUI_WHNDL, $MenuEntries, $GUI_MENUBKG_WIDTH, $TITLE, $SUBTITLE, $SUBTITLE2)
	  ;_ $MenuItems[n] = "Array of the 'n" menu items controlID"


   ;#Create Handles For Over Menu Items Detection (for each Menu-Item)
   Local $hOvrLblWnd[Ubound($MenuItems)]
   For $i=0 To Ubound($hOvrLblWnd)-1
	  $hOvrLblWnd[$i] = ControlGetHandle(WinGetHandle($GUI_WHNDL), '', $MenuItems[$i])
   Next

   ;#Create some Sample Content (Function defined below)
   _CreateSampleContent()

   GUISetState(@SW_SHOW)


	GLOBAL $Button1 = GUICtrlCreateButton("Browse", ($GUI_MENUBKG_WIDTH+35)+150, 80, 85, 23)
		 GUICtrlSetColor(-1, 0xffffff)
		 GUICtrlSetBkColor(-1, $GUI_FONT_COLOR)
	GLOBAL $Button2 = GUICtrlCreateButton("Browse", ($GUI_MENUBKG_WIDTH+35)+150, 112, 85, 23)
		 GUICtrlSetColor(-1, 0xffffff)
		 GUICtrlSetBkColor(-1, $GUI_FONT_COLOR)
	GLOBAL $Button3 = GUICtrlCreateButton("Inject", ($GUI_MENUBKG_WIDTH+35)+65, 250, 95, 32)
		 GUICtrlSetColor(-1, 0xffffff)
		 GUICtrlSetBkColor(-1, $GUI_FONT_COLOR)
	GLOBAL $Button4 = GUICtrlCreateButton("Cancel", ($GUI_MENUBKG_WIDTH+35)+170, 250, 95, 32)
		 GUICtrlSetColor(-1, 0xffffff)
		 GUICtrlSetBkColor(-1, $GUI_FONT_COLOR)

#EndRegion "GUI CREATION" ---------------------------------------------------------------------



While 1

    $tPoint = _WinAPI_GetMousePos()
	;#==========================================#
	;# Check if the cursor is over a menu item  #
	;#==========================================#
    If _WinAPI_WindowFromPoint($tPoint) = $hOvrLblWnd[0] Then
        If Not $OverFlag[0] Then
            ConsoleWrite(' Over-Detection: Label1' & @CR)
			;GUICtrlSetBkColor($MenuItems[0], $GUI_MENU_HOVER_COLOR)
            $OverFlag[0] = 1
        EndIf
    ElseIf _WinAPI_WindowFromPoint($tPoint) = $hOvrLblWnd[1] Then
        If Not $OverFlag[1] Then
            ConsoleWrite(' Over-Detection: Label2' & @CR)
			;GUICtrlSetBkColor($MenuItems[1], $GUI_MENU_HOVER_COLOR)
            $OverFlag[1] = 1
        EndIf
    ElseIf _WinAPI_WindowFromPoint($tPoint) = $hOvrLblWnd[2] Then
        If Not $OverFlag[2] Then
            ConsoleWrite(' Over-Detection: Label3' & @CR)
			;GUICtrlSetBkColor($MenuItems[2], $GUI_MENU_HOVER_COLOR)
            $OverFlag[2] = 1
        EndIf
    ElseIf _WinAPI_WindowFromPoint($tPoint) = $hOvrLblWnd[3] Then
        If Not $OverFlag[3] Then
            ConsoleWrite(' Over-Detection: Label4' & @CR)
			;GUICtrlSetBkColor($MenuItems[3], $GUI_MENU_HOVER_COLOR)
            $OverFlag[3] = 1
        EndIf
    Else
	   ;#========================================#
	   ;# Check if focus is lost on a menu item  #
	   ;#========================================#
        If $OverFlag[0] Then
            ConsoleWrite(' Focus-Loss: Label1' & @CR)
			GUICtrlSetBkColor($MenuItems[0], $GUI_MENU_COLOR)
            $OverFlag[0] = 0
        ElseIf $OverFlag[1] Then
            ConsoleWrite(' Focus-Loss: Label2' & @CR)
			GUICtrlSetBkColor($MenuItems[1], $GUI_MENU_COLOR)
            $OverFlag[1] = 0
        ElseIf $OverFlag[2] Then
            ConsoleWrite(' Focus-Loss: Label3' & @CR)
			GUICtrlSetBkColor($MenuItems[2], $GUI_MENU_COLOR)
            $OverFlag[2] = 0
        ElseIf $OverFlag[3] Then
            ConsoleWrite(' Focus-Loss: Label4' & @CR)
			GUICtrlSetBkColor($MenuItems[3], $GUI_MENU_COLOR)
            $OverFlag[3] = 0
		EndIf
	 EndIf
	;#=======================================#
	;# Check if an element has been clicked  #
	;#=======================================#
	$nMsg = GUIGetMsg()
	Switch $nMsg
		 Case $GUI_EVENT_PRIMARYDOWN
             _SendMessage($GUI_WHNDL, $WM_SYSCOMMAND, 0xF012, 0)	;#(0xF012 = MAKES GUI DRAGGABLE)
		 Case $GUI_EVENT_CLOSE, $GUI_CLOSEBTN
			_MTSkin_GUIDelete($GUI_WHNDL)
			Exit
		 Case $GUI_EVENT_MINIMIZE, $GUI_MINIMIZEBTN
			GUISetState(@SW_MINIMIZE)
		 Case $Button1
			$inject = FileGetShortName(FileOpenDialog("Open a file", @desktopdir, "All file (*.exe)"))
		 Case $Button2
			$bypass = FileGetShortName(FileOpenDialog("Open a file", @desktopdir, "All file (*.dll)"))
		 Case $Button3
			Run("" & $inject & ' ' & $bypass & "")
		 Case $Button4
			Exit
	EndSwitch
 WEnd


#Region "FUNCTIONS DEFINITION" ----------------------------------------------------------------

Func _CreateSampleContent()

  ;#[1]=> Create Titles (using a default data/text)
	  GLOBAL $TitleLabel001 = GUICtrlCreateLabel("Path to Inject.exe:", $GUI_MENUBKG_WIDTH+35, 80, 118, 23)
		 GUICtrlSetFont(-1, 10, 400, 0, "Segoe UI")
		 GUICtrlSetColor(-1, $GUI_TITLES_COLOR)
	  GLOBAL $TitleLabel002 = GUICtrlCreateLabel("Path to bypass.dll:", $GUI_MENUBKG_WIDTH+35, 112, 118, 23)
		 GUICtrlSetFont(-1, 10, 400, 0, "Segoe UI")
		 GUICtrlSetColor(-1, $GUI_TITLES_COLOR)
	  GLOBAL $TitleLabel004 = GUICtrlCreateLabel("Click Inject to start LDB:", $GUI_MENUBKG_WIDTH+35, 214, 188, 23)
		 GUICtrlSetFont(-1, 10, 400, 0, "Segoe UI")
		 GUICtrlSetColor(-1, $GUI_TITLES_COLOR)



EndFunc	;=> _CreateSampleContent()

#EndRegion "FUNCTIONS DEFINITION" -------------------------------------------------------------