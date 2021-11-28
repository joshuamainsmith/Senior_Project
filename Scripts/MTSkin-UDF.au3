#include-once
#cs ===[SCRIPT HEADER]==============================================================

    Title ...........:	MTSkin UDF
	Description .....:	Create Light & Modern GUI for Autoit Scripts
    Script Version ..:	v1.2
	Author ..........:	Taskms4
    Language ........:	English
    AutoIt Version ..:	v3.3.12.0+
	Notes ...........:

#ce ================================================================================


;#Declare Global Variables
   Global $GUI_COLOR, $GUI_MENU_COLOR, $GUI_MENU_HOVER_COLOR, $GUI_TITLES_COLOR, $GUI_MINIMIZECLOSE_COLOR, $GUI_FONT_COLOR, $GUI_MENU_FONT_COLOR, $GUI_SKIN_NAME


#Region "Default Theme Setting" ------------------------------------------------------------------------------------------------------------
;#[Default Theme]
   Dim $GUI_COLOR_DEFAULT=0xEEEEEE
   Dim $GUI_MENU_COLOR_DEFAULT=0x2E363F
   Dim $GUI_MENU_HOVER_COLOR_DEFAULT=0x27A9E3
   Dim $GUI_TITLES_COLOR_DEFAULT=0x555555
   Dim $GUI_MINIMIZECLOSE_COLOR_DEFAULT = $GUI_TITLES_COLOR_DEFAULT
   Dim $GUI_FONT_COLOR_DEFAULT=0x0094E3
   Dim $GUI_MENU_FONT_COLOR_DEFAULT=0xeeeeee
   Dim $GUI_SKIN_NAME_DEFAULT="MTDefault"
   ;#(These values will be used by the func _MTSkin_GUISetSkin() below)
#Region "Default Theme Setting" ------------------------------------------------------------------------------------------------------------


#Region "Functions Definition" -------------------------------------------------------------------------------------------------------------
; [FUNCTION]================================================================================================================================
;    Name ..........:	_MTSkin_GUICreate
;    Description ...:	Creates a modern GUI with the colors set by the selected theme.
;    Syntax ........:	_Metro_GUIDelete( $WinTitle, $WinWidth, $WinHeight, [ $WinLeft, [ $WinTop, [ $ShowMinimizeBtn, [ $ShowCloseBtn ]]]] )
;    Parameters ....: 	$WinTitle           - Title of the window to create
;						$WinWidth           - Width
;						$WinHeight          - Height
;						$WinLeft            - [optional] Window X-pos (Default value is -1).
;						$WinTop             - [optional] Window Y-pos (Default value is -1).
;						$ShowMinimizeBtn    - [optional] Create a "minimize" button: True/False. (Default value is True)
;						$ShowCloseBtn       - [optional] Create a "close" button: True/False. (Default value is True)
;    Return values .:	Array of handles/controlIDs
;						   $RetunHndls[0] => "GUI windows handle"
;						   $RetunHndls[1] => "Close button controlID"
;						   $RetunHndls[2] => "Minimize button controlID"
;    Remarks .......:
; ==========================================================================================================================================
Func _MTSkin_GUICreate($WinTitle = "Title", $WinWidth=0, $WinHeight=0, $WinLeft = -1, $WinTop = -1, $ShowMinimizeBtn = True, $ShowCloseBtn = True)

	  Local $RetunHndls[3]=[-1, -1, -1]
		 ;_ $RetunHndls[0] = "GUI windows handle"
		 ;_ $RetunHndls[1] = "Close button controlID"
		 ;_ $RetunHndls[2] = "Minimize button controlID"

	  $RetunHndls[0]=GUICreate($WinTitle, $WinWidth, $WinHeight, $WinLeft, $WinTop, 0x80000000)	;#0x80000000=$WS_POPUP
	  GUISetBkColor($GUI_COLOR)

	  If $ShowCloseBtn Then
		 ;#Create the Close Btn
		 $RetunHndls[1] = GUICtrlCreateLabel("×", $GUI_WIDTH-($CLOSE_BTN_WIDTH+1), 0, 28, 32, $SS_CENTER)
		   GUICtrlSetFont(-1, 14.5, 400, 0, "Segoe UI")
		   GUICtrlSetColor(-1, $GUI_MINIMIZECLOSE_COLOR)
		   GUICtrlSetBkColor(-1, $GUI_COLOR)
		   ;#GUICtrlSetBkColor(-1, 0xCC508B)
		   GUICtrlSetTip(-1, "Click to exit program")
	  EndIf
	  If $ShowMinimizeBtn Then
		 ;#Create the Minimize Btn
		 $RetunHndls[2] = GUICtrlCreateLabel("–", $GUI_WIDTH-(($CLOSE_BTN_WIDTH+1)*2-2), 0, 28, 32, $SS_CENTER)
		   GUICtrlSetFont(-1, 14.5, 400, 0, "Segoe UI")
		   GUICtrlSetColor(-1, $GUI_MINIMIZECLOSE_COLOR)
		   GUICtrlSetBkColor(-1, $GUI_COLOR)
		   ;#GUICtrlSetBkColor(-1, 0xCC508B)
		   GUICtrlSetTip(-1, "Click to minimize program")
	  EndIf

	  Return ($RetunHndls)

EndFunc



; [FUNCTION]================================================================================================================================
;    Name ..........:	_MTSkin_GUICreateMenu
;    Description ...:	Creates a menu pane on the GUI
;    Syntax ........:	_MTSkin_GUICreateMenu( $WinHndl, $MenEntries, $Width, [ $Title, [ $SubTitle, [ $SubTitle2 ]]] )
;    Parameters ....: 	$WinHndl            - hWND of the GUI
;						$MenEntries         - Array of Menu-Items to create
;						$Width              - Width of the menu pane
;						$Title              - [optional] Title of the menu pane (Default value is "Menu").
;						$SubTitle           - [optional] Add a subtitle in the menu pane (Default value is "").
;						$SubTitle2          - [optional] Add a second subtitle in the menu pane (Default value is "").
;    Return values .:	Array of handles/controlIDs
;						   $RetunHndls[0] => "1st Menu-Item controlID"
;						   $RetunHndls[1] => "2nd Menu-Item controlID"
;						   (...)
;						   $RetunHndls[n] => "Nth Menu-Item controlID"
;
;    Remarks .......:	/!\ If there is not enough space to create all the specified menu entries, exit program with a warning MsgBox
; ==========================================================================================================================================
Func _MTSkin_GUICreateMenu($WinHndl, ByRef $MenEntries, $Width, $Title="Menu", $SubTitle="", $SubTitle2="")

	  ;#Local vars
		 Local $NbEntries=Ubound($MenEntries)
		 Local $RetunHndls[$NbEntries]
	   ;::::::
		 Local $WinSize=WinGetClientSize($WinHndl)	;Parent Window Sizes
		 Local $Height=$WinSize[1]					;Parent Window Height
	   ;::::::
		 Local $TitleTop=10				;Main-Title Label "Top" value
		 Local $TitleLeft=10			;Main-Title Label "Left" value
		 Local $TitleHeight=44			;Main-Title Label "Height" value
		 Local $SubTitlesLeft=10		;SubTitles Label "Left" value
		 Local $SubTitlesHeight=23		;SubTitles Labels "Height" value
		 Local $MenuItemsHeight=25		;MenuItems Labels "Height" value
		 Local $MenuItemsLeft=10		;MenuItems Labels "Height" value
	   ;::::::
		 Local $TitleMenuOffset=9		;Offset between the Main-Title and the Menu
		 Local $MenuItemsOffset=8.5		;Offset between 2 Menu Items
		 Local $SubTitlesOffset=6		;Offset between SubTitles
	   ;::::::


	  $RetunHndls["MenuBkg"] = GUICtrlCreateLabel("", 0, 0, $Width, $Height)
		 GUICtrlSetBkColor(-1, $GUI_MENU_COLOR)
		 GUICtrlSetState(-1, $GUI_DISABLE+$GUI_FOCUS)
	  $RetunHndls["Title"] = GUICtrlCreateLabel($Title, $TitleLeft, $TitleTop, $Width-($TitleLeft+6), $TitleHeight)
		 GUICtrlSetFont(-1, 16, 400, 4, "Segoe UI Light")
		 GUICtrlSetColor(-1, $GUI_MENU_FONT_COLOR)
		 GUICtrlSetBkColor(-1, $GUI_MENU_COLOR)
		 ;;GUICtrlSetBkColor(-1, 0xCC508B)
	  $RetunHndls["SubTitle"] = GUICtrlCreateLabel($SubTitle, $SubTitlesLeft, $Height-($SubTitlesHeight+5), $Width-($SubTitlesLeft+8), $SubTitlesHeight)
		 GUICtrlSetFont(-1, 10, 400, 0, "Segoe UI Light")
		 GUICtrlSetColor(-1, $GUI_MENU_FONT_COLOR)
		 GUICtrlSetBkColor(-1, $GUI_MENU_COLOR)
		 ;;GUICtrlSetBkColor(-1, 0xCC508B)
	  $RetunHndls["SubTitle2"] = GUICtrlCreateLabel($SubTitle2, $SubTitlesLeft, $Height-(($SubTitlesHeight+$SubTitlesOffset)+$SubTitlesHeight+($SubTitlesOffset/2)), $Width-($SubTitlesLeft+8), $SubTitlesHeight)
		 GUICtrlSetFont(-1, 9, 400, 0, "Segoe UI Light")
		 GUICtrlSetColor(-1, $GUI_MENU_FONT_COLOR)
		 GUICtrlSetBkColor(-1, $GUI_MENU_COLOR)
		 ;;GUICtrlSetBkColor(-1, 0xCC508B)

	  ;#Calculate available area for the menu
	  $SubTitle2Pos = ControlGetPos( $WinHndl, "", $RetunHndls["SubTitle2"]) ;Y-Value = $SubTitle2Pos[1]
	  $StartMenuPos = ($TitleTop + $TitleHeight + $TitleMenuOffset)
	  $EndMenuPos =  ($SubTitle2Pos[1] - $TitleMenuOffset)
	  ;(Recover the total available height for the menu)
	  $TotalMenuHeight=($EndMenuPos-$StartMenuPos)

	  ;#[DEBUG]=> Uncomment the line below to draw/show the menu area
		 ;GUICtrlSetBkColor( GUICtrlCreateLabel("", 0, $StartMenuPos, $Width, $TotalMenuHeight), "0xffffff")

	  ;#Calculate the maximum menu entries that will fit in the menu area
	  $TotalEntriesHeight=(($NbEntries*$MenuItemsHeight)+(($NbEntries-1)*$MenuItemsOffset))
	  $MaxNbEntries=Floor($TotalMenuHeight/($TotalEntriesHeight/$NbEntries))

	  ;#If there is not enough space to create all the specified menu entries => Exit program with a warning
	  If $NbEntries > $MaxNbEntries Then
		 MsgBox(48, "_MTSkin_GUICreateMenu()", "The number of menu items you entered exceeds the available menu size."&@CRLF&"Please reduce the number of entries to "&$MaxNbEntries&" or enlarge the GUI height.")
		 Exit
	  EndIf
	  If $TotalEntriesHeight > $TotalMenuHeight Then
		 MsgBox(48, "_MTSkin_GUICreateMenu()", "The number of menu items you entered exceeds the available menu size."&@CRLF&"Please reduce the number of entries to "&($MaxNbEntries-1)&" or enlarge the GUI height.")
		 Exit
	  EndIf

	  ;#Calculate the height value to start to create menu entries (to center entries in the menu area)
	  $StartMenuEntries=$StartMenuPos + Round(($TotalMenuHeight-$TotalEntriesHeight)/2, 1)

	  ;#Create the menu entries
	  For $i=0 To ($NbEntries-1)
		 $RetunHndls[$i]=GUICtrlCreateLabel($MenEntries[$i], $MenuItemsLeft, $StartMenuEntries+($i*($MenuItemsHeight+$MenuItemsOffset)), $Width-(2*$MenuItemsLeft), $MenuItemsHeight, $SS_CENTER)
			GUICtrlSetFont(-1, 10, 400, 0, "Segoe UI")
			GUICtrlSetColor(-1, $GUI_MENU_FONT_COLOR)
			GUICtrlSetBkColor(-1, $GUI_MENU_COLOR)
	  Next

	  Return ($RetunHndls)

EndFunc



; [FUNCTION]================================================================================================================================
;    Name ..........:	_MTSkin_GUIDelete
;    Description ...:	Delete a created GUI
;    Syntax ........:	_Metro_GUIDelete( $WinHandles )
;    Parameters ....: 	$WinHandle         - Winhandle rof the GUI
;    Return values .:	(none)
;    Remarks .......:
; ==========================================================================================================================================
Func _MTSkin_GUIDelete($WinHandle)

	  GUIDelete($WinHandle)

EndFunc



; [FUNCTION]================================================================================================================================
;    Name ..........:	_MTSkin_GUISetSkin
;    Description ...:	Define the skin (set of colors) to use for the GUI and Labels
;    Syntax ........:	_MTSkin_GUISetSkin( $SkinSelect )
;    Parameters ....: 	$SkinSelect         - Name of the skin to use (Default value is "Default").
;    Return values .:	(None, initializes global vars)
;    Remarks .......:
; ==========================================================================================================================================
Func _MTSkin_GUISetSkin($SkinSelect = "Default") ;("Default" => Case Else)

   Switch ($SkinSelect)
    ;;################################
    ;;## BASIC OFFICE COLORS THEMES ##
    ;;################################
	  Case "WordBlue"
			$GUI_COLOR = "0x2b579a"
			$GUI_MENU_COLOR = "0x214d90"
			$GUI_MENU_HOVER_COLOR = "0x3E6DB5"
			$GUI_TITLES_COLOR = "0xC0C0C0"
			$GUI_MINIMIZECLOSE_COLOR = $GUI_MENU_FONT_COLOR
			$GUI_FONT_COLOR = "0xffffff"
			$GUI_MENU_FONT_COLOR = "0xffffff"
			$GUI_SKIN_NAME = "WordBlue"
	  Case "ExcelGreen"
			$GUI_COLOR = "0x217346"
			$GUI_MENU_COLOR = "0x17693C"
			$GUI_MENU_HOVER_COLOR = "0x439467"
			$GUI_TITLES_COLOR = "0xCCCCCC"
			$GUI_MINIMIZECLOSE_COLOR = $GUI_MENU_FONT_COLOR
			$GUI_FONT_COLOR = "0xffffff"
			$GUI_MENU_FONT_COLOR = "0xffffff"
			$GUI_SKIN_NAME = "ExcelGreen"
	  Case "PowerPointRed"
			$GUI_COLOR = "0xb7472a"
			$GUI_MENU_COLOR = "0xAD3D20"
			$GUI_MENU_HOVER_COLOR = "0xDC5939"
			$GUI_TITLES_COLOR = "0xEAC282"
			$GUI_MINIMIZECLOSE_COLOR = $GUI_MENU_FONT_COLOR
			$GUI_FONT_COLOR = "0xffffff"
			$GUI_MENU_FONT_COLOR = "0xffffff"
			$GUI_SKIN_NAME = "PowerPointRed"
	  Case "OneNotePurple"
			$GUI_COLOR = "0x80397B"
			$GUI_MENU_COLOR = "0x762F71"
			$GUI_MENU_HOVER_COLOR = "0xA3569E"
			$GUI_TITLES_COLOR = "0xC7A2D7"
			$GUI_MINIMIZECLOSE_COLOR = $GUI_MENU_FONT_COLOR
			$GUI_FONT_COLOR = "0xffffff"
			$GUI_MENU_FONT_COLOR = "0xffffff"
			$GUI_SKIN_NAME = "OneNotePurple"
	  Case "SkypeBlue"
			$GUI_COLOR = "0x00B1F4"
			$GUI_MENU_COLOR = "0x00A5E6"
			$GUI_MENU_HOVER_COLOR = "0x73C5FB"
			$GUI_TITLES_COLOR = "0x1C488B"
			$GUI_MINIMIZECLOSE_COLOR = $GUI_MENU_FONT_COLOR
			$GUI_FONT_COLOR = "0xffffff"
			$GUI_MENU_FONT_COLOR = "0xffffff"
			$GUI_SKIN_NAME = "SkypeBlue"
	  Case "OfficeGrey"
			$GUI_COLOR = "0xB2B2B2"
			$GUI_MENU_COLOR = "0x6A6A6A"
			$GUI_MENU_HOVER_COLOR = "0x444444"
			$GUI_TITLES_COLOR = "0x444444"
			$GUI_MINIMIZECLOSE_COLOR = $GUI_MENU_FONT_COLOR
			$GUI_FONT_COLOR = "0x1E1E1E"
			$GUI_MENU_FONT_COLOR = "0xffffff"
			$GUI_SKIN_NAME = "OfficeGrey"
    ;;##################################
    ;;## FLAT UI OFFICE COLORS THEMES ##
    ;;##################################
	  Case "FlatUIWordBlue"
			$GUI_COLOR = "0xEEEEEE"
			$GUI_MENU_COLOR = "0x214d90"
			$GUI_MENU_HOVER_COLOR = "0x3E6DB5"
			$GUI_TITLES_COLOR = "0x425F7B"
			$GUI_MINIMIZECLOSE_COLOR = "0x77889D"
			$GUI_FONT_COLOR = "0x214d90"
			$GUI_MENU_FONT_COLOR = "0xffffff"
			$GUI_SKIN_NAME = "FlatUIWordBlue"
	  Case "FlatUIExcelGreen"
			$GUI_COLOR = "0xEEEEEE"
			$GUI_MENU_COLOR = "0x17693C"
			$GUI_MENU_HOVER_COLOR = "0x439467"
			$GUI_TITLES_COLOR = "0x5A5A5A"
			$GUI_MINIMIZECLOSE_COLOR = "0x77889D"
			$GUI_FONT_COLOR = "0x17693C"
			$GUI_MENU_FONT_COLOR = "0xffffff"
			$GUI_SKIN_NAME = "FlatUIExcelGreen"
	  Case "FlatUIPowerPointRed"
			$GUI_COLOR = "0xEEEEEE"
			$GUI_MENU_COLOR = "0xAD3D20"
			$GUI_MENU_HOVER_COLOR = "0xDC5939"
			$GUI_TITLES_COLOR = "0x5A5A5A"
			$GUI_MINIMIZECLOSE_COLOR = "0x77889D"
			$GUI_FONT_COLOR = "0xDC5939"
			$GUI_MENU_FONT_COLOR = "0xffffff"
			$GUI_SKIN_NAME = "FlatUIPowerPointRed"
	  Case "FlatUIOneNotePurple"
			$GUI_COLOR = "0xEEEEEE"
			$GUI_MENU_COLOR = "0x762F71"
			$GUI_MENU_HOVER_COLOR = "0xA3569E"
			$GUI_TITLES_COLOR = "0x5A5A5A"
			$GUI_MINIMIZECLOSE_COLOR = "0x77889D"
			$GUI_FONT_COLOR = "0x84357D"
			$GUI_MENU_FONT_COLOR = "0xffffff"
			$GUI_SKIN_NAME = "FlatUIOneNotePurple"
	  Case "FlatUISkypeBlue"
			$GUI_COLOR = "0xEEEEEE"
			$GUI_MENU_COLOR = "0x00A5E6"
			$GUI_MENU_HOVER_COLOR = "0x73C5FB"
			$GUI_TITLES_COLOR = "0x5A5A5A"
			$GUI_MINIMIZECLOSE_COLOR = "0x77889D"
			$GUI_FONT_COLOR = "0x00A5E6"
			$GUI_MENU_FONT_COLOR = "0xffffff"
			$GUI_SKIN_NAME = "FlatUISkypeBlue"
	  Case "FlatUIOfficeGrey"
			$GUI_COLOR = "0xEEEEEE"
			$GUI_MENU_COLOR = "0x6A6A6A"
			$GUI_MENU_HOVER_COLOR = "0x444444"
			$GUI_TITLES_COLOR = "0x5A5A5A"
			$GUI_MINIMIZECLOSE_COLOR = "0x77889D"
			$GUI_FONT_COLOR = "0x384752"
			$GUI_MENU_FONT_COLOR = "0xffffff"
			$GUI_SKIN_NAME = "FlatUIOfficeGrey"
    ;;##################################
    ;;## FLAT UI CUSTOM COLORS THEMES ##
    ;;##################################
	  Case "FlatUIGrey"
			$GUI_COLOR = "0xEEEEEE"
			$GUI_MENU_COLOR = "0x616161"
			$GUI_MENU_HOVER_COLOR = "0x828282"
			$GUI_TITLES_COLOR = "0x275CAB"
			$GUI_MINIMIZECLOSE_COLOR = "0x77889D"
			$GUI_FONT_COLOR = "0x666666"
			$GUI_MENU_FONT_COLOR = "0xffffff"
			$GUI_SKIN_NAME = "FlatUIGrey"
	  Case "FlatUIGreyBlue"
			$GUI_COLOR = "0xDFDFDF"
			$GUI_MENU_COLOR = "0x314351"
			$GUI_MENU_HOVER_COLOR = "0x476378"
			$GUI_TITLES_COLOR = "0x314351"
			$GUI_MINIMIZECLOSE_COLOR = $GUI_MENU_COLOR
			$GUI_FONT_COLOR = "0x0086C6"
			$GUI_MENU_FONT_COLOR = "0xffffff"
			$GUI_SKIN_NAME = "FlatUIGrey"
	  Case "FlatUIBlue"
			$GUI_COLOR = "0xEEEEEE"
			$GUI_MENU_COLOR = "0x1182BC"
			$GUI_MENU_HOVER_COLOR = "0x0B6CA3"
			$GUI_TITLES_COLOR = "0x7B7B7B"
			$GUI_MINIMIZECLOSE_COLOR = $GUI_TITLES_COLOR
			$GUI_FONT_COLOR = "0x1D94CC"
			$GUI_MENU_FONT_COLOR = "0xffffff"
			$GUI_SKIN_NAME = "FlatUIBlue"
	  Case "FlatUIGreyTeal"
			$GUI_COLOR = "0xE7E7E7"
			$GUI_MENU_COLOR = "0x2C3E50"
			$GUI_MENU_HOVER_COLOR = "0x16A0B5"
			$GUI_TITLES_COLOR = "0x34495E"
			$GUI_MINIMIZECLOSE_COLOR = $GUI_TITLES_COLOR
			$GUI_FONT_COLOR = "0x16A0B5"
			$GUI_MENU_FONT_COLOR = "0xffffff"
			$GUI_SKIN_NAME = "FlatUIGreyBlu"
	  Case "FlatUIMidnight"
			$GUI_COLOR = "0xecf0f1"
			$GUI_MENU_COLOR = "0x003366"
			$GUI_MENU_HOVER_COLOR = "0x004A95"
			$GUI_TITLES_COLOR = "0x39526A"
			$GUI_MINIMIZECLOSE_COLOR = $GUI_TITLES_COLOR
			$GUI_FONT_COLOR = "0x003F7D"
			$GUI_MENU_FONT_COLOR = "0xffffff"
			$GUI_SKIN_NAME = "FlatUIMidnight"
	  Case "FlatUIDarkSapphire"
			$GUI_COLOR = "0xecf0f1"
			$GUI_MENU_COLOR = "0x0c2461"
			$GUI_MENU_HOVER_COLOR = "0x353875"
			$GUI_TITLES_COLOR = "0x39526A"
			$GUI_MINIMIZECLOSE_COLOR = $GUI_TITLES_COLOR
			$GUI_FONT_COLOR = "0x1e3799"
			$GUI_MENU_FONT_COLOR = "0xffffff"
			$GUI_SKIN_NAME = "FlatUIDarkSapphire"
	  Case "FlatUILightPurple"
			$GUI_COLOR = "0xF5F5F5"
			$GUI_MENU_COLOR = "0x667AFF"
			$GUI_MENU_HOVER_COLOR = "0x7E95FE"
			$GUI_TITLES_COLOR = "0x959595"
			$GUI_MINIMIZECLOSE_COLOR = "0xA5A5A5"
			$GUI_FONT_COLOR = "0x667AFF"
			$GUI_MENU_FONT_COLOR = "0xffffff"
			$GUI_SKIN_NAME = "FlatUIPurple"
    ;;################################
    ;;## FLAT UI CUSTOM DARK THEMES ##
    ;;################################
	  Case "DarkFlatUIBlue"
			$GUI_COLOR = "0x333942"
			$GUI_MENU_COLOR = "0x0190DC"
			$GUI_MENU_HOVER_COLOR = "0x007DBF"
			$GUI_TITLES_COLOR = "0xA4AFBF"
			$GUI_MINIMIZECLOSE_COLOR = $GUI_TITLES_COLOR
			$GUI_FONT_COLOR = "0x01A3FA"
			$GUI_MENU_FONT_COLOR = "0xffffff"
			$GUI_SKIN_NAME = "DarkFlatUIBlue"
	  Case "DarkFlatUIRed"
			$GUI_COLOR = "0x333942"
			$GUI_MENU_COLOR = "0xD54646"
			$GUI_MENU_HOVER_COLOR = "0xCC2F2F"
			$GUI_TITLES_COLOR = "0xA4AFBF"
			$GUI_MINIMIZECLOSE_COLOR = $GUI_TITLES_COLOR
			$GUI_FONT_COLOR = "0xD85454"
			$GUI_MENU_FONT_COLOR = "0xffffff"
			$GUI_SKIN_NAME = "DarkFlatUIRed"
	  Case "DarkFlatUIGreen"
			$GUI_COLOR = "0x333942"
			$GUI_MENU_COLOR = "0x70C536"
			$GUI_MENU_HOVER_COLOR = "0x5CA42D"
			$GUI_TITLES_COLOR = "0xA4AFBF"
			$GUI_MINIMIZECLOSE_COLOR = $GUI_TITLES_COLOR
			$GUI_FONT_COLOR = "0x70C536"
			$GUI_MENU_FONT_COLOR = "0xffffff"
			$GUI_SKIN_NAME = "DarkFlatUIGreen"
	  Case "DarkFlatUITeal"
			$GUI_COLOR = "0x333333"
			$GUI_MENU_COLOR = "0x00AC9F"
			$GUI_MENU_HOVER_COLOR = "0x018D82"
			$GUI_TITLES_COLOR = "0xA4AFBF"
			$GUI_MINIMIZECLOSE_COLOR = $GUI_TITLES_COLOR
			$GUI_FONT_COLOR = "0x00AC9F"
			$GUI_MENU_FONT_COLOR = "0xffffff"
			$GUI_SKIN_NAME = "DarkFlatUITeal"
	  Case "DarkFlatUIPurple"
			$GUI_COLOR = "0x424242"
			$GUI_MENU_COLOR = "0x9260A5"
			$GUI_MENU_HOVER_COLOR = "0x794E89"
			$GUI_TITLES_COLOR = "0xA4AFBF"
			$GUI_MINIMIZECLOSE_COLOR = $GUI_TITLES_COLOR
			$GUI_FONT_COLOR = "0xAF6AB7"
			$GUI_MENU_FONT_COLOR = "0xffffff"
			$GUI_SKIN_NAME = "DarkFlatUIPurple"
	  Case "DarkFlatUIChampagne"
			$GUI_COLOR = "0x424242"
			$GUI_MENU_COLOR = "0xC28E66"
			$GUI_MENU_HOVER_COLOR = "0xD2B186"
			$GUI_TITLES_COLOR = "0xA6A6A6"
			$GUI_MINIMIZECLOSE_COLOR = $GUI_TITLES_COLOR
			$GUI_FONT_COLOR = "0xC28E66"
			$GUI_MENU_FONT_COLOR = "0xffffff"
			$GUI_SKIN_NAME = "DarkFlatUIChampagne"
	  ;Case "AddYourCustomSkin(s)"
    ;;###################
    ;;## DEFAULT THEME ##
    ;;###################
	  Case Else
			$GUI_COLOR = $GUI_COLOR_DEFAULT
			$GUI_MENU_COLOR = $GUI_MENU_COLOR_DEFAULT
			$GUI_MENU_HOVER_COLOR = $GUI_MENU_HOVER_COLOR_DEFAULT
			$GUI_TITLES_COLOR = $GUI_TITLES_COLOR_DEFAULT
			$GUI_MINIMIZECLOSE_COLOR = $GUI_TITLES_COLOR_DEFAULT
			$GUI_FONT_COLOR = $GUI_FONT_COLOR_DEFAULT
			$GUI_MENU_FONT_COLOR = $GUI_MENU_FONT_COLOR_DEFAULT
			$GUI_SKIN_NAME = $GUI_SKIN_NAME_DEFAULT

   EndSwitch
EndFunc


#EndRegion "Functions Definition" ----------------------------------------------------------------------------------------------------------