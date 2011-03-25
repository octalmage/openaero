/*

Octal's Multi-Monitor Script.

I made this script to model the window management in windows 7 at work when I have to use windows xp.

Made for a dual-monitor setup. 

Win+1:		Move active window to first half of the first screen.
Win+2:		Move active window to second half of the first screen.
Win+3:		Move active window to first half of the second screen.
Win+4:		Move active window to second half of the second screen.

Win+q:		Move active window to fill the first screen.
Win+w:		Move active window to fill the second screen.

Win+left:	Move active window to the left half of the current monitor.
Win+right:	Move active window to the right half of the current monitor.
Win+up:		Move active window to fill the current monitor.
Win+`:		Move active window to fill the current monitor.



*/
CoordMode, Mouse , Screen
settimer, mousewatch, 10


ww:=a_screenwidth/2
ww2:=(a_screenwidth/2)+a_screenwidth

SysGet, VirtualScreenWidth, 78
SysGet, VirtualScreenHeight, 79


sides=10



#1::
winmove,A,, 0,0,%ww%, %A_ScreenHeight%
return


#2::
winmove,A,, %ww%,0,%ww%, %A_ScreenHeight%
return

#3::
winmove,A,, %a_screenwidth%,0,%ww%, %A_ScreenHeight%
return

#4::
winmove,A,, %ww2%,0,%ww%, %A_ScreenHeight%
return

#`::
#up::
WinGetPos , xx, , , , A
if xx<%a_screenwidth%
{
winmove,A,, 0,0,%a_screenwidth%, %A_ScreenHeight%
}
else
{
winmove,A,, %a_screenwidth%,0,%a_screenwidth%, %A_ScreenHeight%
}
return


#q::

winmove,A,, 0,0,%a_screenwidth%, %A_ScreenHeight%
return

#w::

winmove,A,, %a_screenwidth%,0,%a_screenwidth%, %A_ScreenHeight%
return




#left::
WinGetPos , xx, , , , A
if xx<%a_screenwidth%
{
winmove,A,, 0,0,%ww%, %A_ScreenHeight%
}
else
{
winmove,A,, %a_screenwidth%,0,%ww%, %A_ScreenHeight%
}
return


#right::
WinGetPos , xx, , , , A
if xx<%a_screenwidth%
{
winmove,A,, %ww%,0,%ww%, %A_ScreenHeight%
}
else
{
winmove,A,, %ww2%,0,%ww%, %A_ScreenHeight%
}
return

mousewatch:
if	(GetKeyState("lbutton"))
{
	MouseGetPos, mousex, mousey, winid
	check:=winstatus%winid%
	if check=1
	{
		 MouseGetPos, x, y, hwnd
		SendMessage, 0x84, 0, (x&0xFFFF) | (y&0xFFFF) << 16,, ahk_id %hwnd%
		RegExMatch("ERROR TRANSPARENT NOWHERE CLIENT CAPTION SYSMENU SIZE MENU HSCROLL VSCROLL MINBUTTON MAXBUTTON LEFT RIGHT TOP TOPLEFT TOPRIGHT BOTTOM BOTTOMLEFT BOTTOMRIGHT BORDER OBJECT CLOSE HELP", "(?:\w+\s+){" . ErrorLevel+2&0xFFFFFFFF . "}(?<AREA>\w+\b)", HT)
		if htarea!=CAPTION
			Return
		MouseGetPos,_x,_y

			newwinw:=winw%winid%
			newwinh:=winh%winid%
			newwinx:=mousex-(newwinw/2)

			winmove,ahk_id %winid%,, %newwinx%,,%newwinw%, %newwinh%
			winstatus%winid%=0
	
		return
	}
	fullcheck:=VirtualScreenWidth-sides
	
	
	if (mousex<sides or mousex>fullcheck or mousey<sides)
	{
		;WinSet, alwaysontop, on , ahk_id %winid%
		gui, -caption +toolwindow
		gui, color,blue
		;gui,show,x0 y0 w%ww% h%A_ScreenHeight%
		;WinSet, Transparent, 150 
		sendinput {lbutton down}
		loop
		{
			if	not GetKeyState("lbutton")
			{	
				MouseGetPos, mousex, mousey
				if (mousex<sides or mousex>fullcheck or mousey<10)
				{
					send {lbutton up}
					WinGetPos ,thiswinx , , thiswinw, thiswinh, ahk_id %winid%
					winstatus%winid%=1
					winw%winid%=%thiswinw%
					winh%winid%=%thiswinh%
					if (mousex>fullcheck)
					{
						winmove,ahk_id %winid%,, %ww2%,0,%ww%, %A_ScreenHeight%
					}
					else if (mousey<10)
					{
						if (mousex>a_screenwidth)
							winmove,ahk_id %winid%,, %a_screenwidth%,0,%a_screenwidth%, %A_ScreenHeight%
						else
							winmove,ahk_id %winid%,, 0,0,%a_screenwidth%, %A_ScreenHeight%
					}
					else
						winmove,ahk_id %winid%,, 0,0,%ww%, %A_ScreenHeight%
					check:=winstatus%winid%
		
					;mww:=ww/2
					;mousemove,%mww% ,5, 0
				
					break
				}
				else
				{
					break
				}
			}

		}
		;gui,destroy
		WinSet, alwaysontop, off , ahk_id %winid%
	}
}
return

