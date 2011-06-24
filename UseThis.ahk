; by MasterFocus - 06/DEC/2010 - 20:16h BRT
; http://www.autohotkey.com/forum/viewtopic.php?p=405187#405187
CoordMode, Mouse
SetBatchLines, -1
SetWinDelay, -1
ListLines, Off
Process, Priority, , High
; if the Monitor Work Area may change, put the
; following 2 lines inside the label's if-statement
SysGet, MWA_, MonitorWorkArea
scrW := MWA_Right-MWA_Left , scrH := MWA_Bottom-MWA_Top
;-------------------------------------------------
~*$LButton::
  MouseGetPos, , , hWin
  WinGet, State, MinMax, ahk_id %hWin%
  If State = 0  ; Only if the window isn't maximized/minimized
    SetTimer, MyLabel, 10
  KeyWait, LButton
  SetTimer, MyLabel, Off
  Confine(0,0,0,0,0)
Return
;-------------------------------------------------
MyLabel:
  WinGetPos, winX, winY, winW, winH, ahk_id %hWin%
  If (WM_NCHITTEST()="CAPTION")
  {
    MouseGetPos, mouseX, mouseY
    Confine( 1 , mouseX-winX , mouseY-winY , mouseX+scrW-winW-winX , mouseY+scrH-winH-winY )
  }
  Else
    SetTimer, MyLabel, Off ; avoid the unnecessary timed subroutine
Return
;=================================================
WM_NCHITTEST()
{
   CoordMode, Mouse, Screen
   MouseGetPos, x, y, z
   SendMessage, 0x84, 0, (x&0xFFFF)|(y&0xFFFF)<<16,, ahk_id %z%
   RegExMatch("ERROR TRANSPARENT NOWHERE CLIENT CAPTION SYSMENU SIZE MENU HSCROLL VSCROLL MINBUTTON MAXBUTTON LEFT RIGHT TOP TOPLEFT TOPRIGHT BOTTOM BOTTOMLEFT BOTTOMRIGHT BORDER OBJECT CLOSE HELP", "(?:\w+\s+){" . ErrorLevel+2&0xFFFFFFFF . "}(?<AREA>\w+\b)", HT)
   Return   HTAREA
}
;=================================================
Confine(C,X1,Y1,X2,Y2) { ; http://www.autohotkey.com/forum/viewtopic.php?p=293413#293413
  VarSetCapacity(R,16,0),NumPut(X1,&R+0),NumPut(Y1,&R+4),NumPut(X2,&R+8),NumPut(Y2,&R+12)
  Return C ? DllCall("ClipCursor",UInt,&R) : DllCall("ClipCursor")
}