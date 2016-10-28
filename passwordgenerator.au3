#pragma compile(Out, Password Generator.exe)
; Uncomment to use the following icon. Make sure the file path is correct and matches the installation of your AutoIt install path.
#pragma compile(Icon, C:\Users\cerringt\Downloads\Artua-Mac-Lock.ico)
#pragma compile(Compatibility, win7)
#pragma compile(UPX, False)
#pragma compile(FileDescription, Generate a list of random passwords)
#pragma compile(ProductName, Password Generator)
#pragma compile(ProductVersion, 1.1)
#pragma compile(FileVersion, 1.1.0.1) ; The last parameter is optional.
#pragma compile(LegalCopyright, © Clayton Errington)
#pragma compile(LegalTrademarks, 'None')
#pragma compile(CompanyName, 'Clayton Erington & Co')

Global Const $CHR_AZ_LOW        = StringLower("abcdefghijklmnopqrstuvwxyz")
Global Const $CHR_AZ_UP        = StringUpper("ABCDEFGHIJKLMNOPQRSTUVWXYZ")
Global Const $CHR_NUMBERS    = "0123456789"

Global $sUseCharacters = $CHR_AZ_LOW

$hWnd = GUICreate("Password Generator.", 460, 175)
GUICtrlCreateGroup("Options", 10, 10, 280, 75)
GUICtrlCreateLabel("Password length:", 20, 30)
$hPasswordLength = GUICtrlCreateInput(8, 130, 27, 40)
$hUpDown = GUICtrlCreateUpDown($hPasswordLength)
GUICtrlCreateLabel("Characters:", 20, 53)
$hCharacters = GUICtrlCreateCombo("a-z", 130, 50, 150, 20, 0x0003)
$hCurrentSequence = GUICtrlCreateLabel("Hover me to see your current sequence.", 10, 90, 280)
$hGenerate = GUICtrlCreateButton("Generate", 10, 110, 135, 25)
$hClearHistory = GUICtrlCreateButton("Clear history", 155, 110, 135, 25)
$hPassword = GUICtrlCreateInput("", 10, 145, 280, 20)
$hHistory = GUICtrlCreateEdit("", 300, 10, 150, 155, BitOR(0x0800, 0x0040, 0x00200000))

GUICtrlSetData($hCharacters, "A-Z|0-9|a-z, A-Z|a-z, 0-9|A-Z, 0-9|a-z, A-Z, 0-9|< User defined ... >", "a-z")
GUICtrlSetLimit($hUpDown, 99, 1)
GUICtrlSetTip($hCurrentSequence, $sUseCharacters)
GUISetState()
While 1
    Switch GUIGetMsg()
        Case -3
            Exit
        Case $hCharacters
            $sRead = GUICtrlRead($hCharacters)
            If ($sRead == "a-z") Then
                $sUseCharacters = $CHR_AZ_LOW
            ElseIf ($sRead == "A-Z") Then
                $sUseCharacters = $CHR_AZ_UP
            ElseIf ($sRead == "0-9") Then
                $sUseCharacters = $CHR_NUMBERS
            ElseIf ($sRead == "a-z, A-Z") Then
                $sUseCharacters = $CHR_AZ_LOW & $CHR_AZ_UP
            ElseIf ($sRead == "a-z, 0-9") Then
                $sUseCharacters = $CHR_AZ_LOW & $CHR_NUMBERS
            ElseIf ($sRead == "A-Z, 0-9") Then
                $sUseCharacters = $CHR_AZ_UP & $CHR_NUMBERS
            ElseIf ($sRead == "a-z, A-Z, 0-9") Then
                $sUseCharacters = $CHR_AZ_LOW & $CHR_AZ_UP & $CHR_NUMBERS
            ElseIf ($sRead == "< User defined ... >") Then
                $sUseCharacters = InputBox("Password Generator.", "Enter a character sequence.", "abcABC123!@#", "", 200, 100)
            EndIf
            GUICtrlSetTip($hCurrentSequence, $sUseCharacters)

        Case $hGenerate
            $sPassword = _GeneratePassword(GUICtrlRead($hPasswordLength), $sUseCharacters)
            GUICtrlSetData($hPassword, $sPassword)
            GUICtrlSetData($hHistory, $sPassword & @CRLF, "|")

        Case $hClearHistory
            GUICtrlSetData($hHistory, "")
    EndSwitch
WEnd

Func _GeneratePassword($iLength, $sSequence)
    Local $sResult
    Local $aSplit = StringSplit($sSequence, "", 2)

    For $i = 1 To $iLength
        $sResult &= $aSplit[Random(0, UBound($aSplit) - 1, 1)]
    Next

    Return $sResult
EndFunc