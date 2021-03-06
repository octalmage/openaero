/*

openAero

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
SysGet, MonitorWorkArea, MonitorWorkArea

detecthiddenwindows, on
CoordMode, Mouse , Screen
settimer, mousewatch, 10
#singleinstance, force



SysGet, VirtualScreenWidth, 78
SysGet, VirtualScreenHeight, 79
sysget, MonitorCount, MonitorCount


ww:=a_screenwidth/2
monitorcount--
ww2:=(a_screenwidth/2)+(a_screenwidth*MonitorCount)

sides=10


fullcheck:=VirtualScreenWidth-sides



menu, tray, NoStandard
menu,tray,icon,logo.ico
menu, tray, add, About, about
menu, tray, add ; separator
menu,tray,add,Exit,cleanup



return

cleanup:
exitapp

about:
MsgBox , , About, openAero v0.1`nBy: Jason Stallings`ncode.google.com/p/openaero
return




/*
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
*/
#`::
#up::
winmax()
return

/*
#q::

winmove,A,, 0,0,%a_screenwidth%, %A_ScreenHeight%
return

#w::

winmove,A,, %a_screenwidth%,0,%a_screenwidth%, %A_ScreenHeight%
return
	*/



#left::
winleft()
return


#right::
winright()
return

winright()
{
	global

	WinGetPos , xx, , , , A
	if xx<%a_screenwidth%
	{
		winmove,A,, %ww%,0,%ww%, %MonitorWorkAreaBottom%
	}
	else
	{
		winmove,A,, %ww2%,0,%ww%, %A_ScreenHeight%
	}
	return
}

winleft()
{
	global
	WinGetPos , xx, , , , A
	if xx<%a_screenwidth%
	{
		winmove,A,, 0,0,%ww%, %MonitorWorkAreaBottom%
	}
	else
	{
		winmove,A,, %a_screenwidth%,0,%ww%, %A_ScreenHeight%
	}
	return
}

winmax()
{
	global
	WinGetPos , xx, , , , A
	if xx<%a_screenwidth%
	{
		winmove,A,, 0,0,%a_screenwidth%, %MonitorWorkAreaBottom%
	}
	else
	{
		winmove,A,, %a_screenwidth%,0,%a_screenwidth%, %A_ScreenHeight%
	}
	return
}


splash:


	SysGet, MonitorWorkArea, MonitorWorkArea

	splashimage,shade2243324.jpg,hide CW1589FF b2,,,SplashImage
	WinSet, Transparent, 85 ,SplashImage
	if mode=1
		winmove,SplashImage,,0, 0, %ww%, %MonitorWorkAreabottom% 
	else if mode=3
	{
		if (mousex>a_screenwidth)
			winmove,SplashImage,, %a_screenwidth%,0,%a_screenwidth%, %A_ScreenHeight%
		else
			winmove,SplashImage,, 0,0,%a_screenwidth%, %MonitorWorkAreabottom%
	}
	else if mode=2
	{
	if (fullcheck>a_screenwidth)
	{
	winmove,SplashImage,, %ww2%,0,%ww%, %MonitorWorkAreabottom%
	}
	else
	{
	winmove,SplashImage,, %ww%,0,%ww%, %MonitorWorkAreabottom%
	}
		
		
		}
	SplashImage, Show, b2,,, SplashImage
	splash=1
return

setmode:

	mode=
	if (mousex<sides)
		mode=1
	else if (mousex>fullcheck)
		mode=2
	else if (mousey<sides)
		mode=3

return

splashoff:
	splashimage,off
				splash=0
return


mousewatch:
	while not isdragging()
	{
	return
	}


if	(GetKeyState("lbutton"))
{
	MouseGetPos, mousex, mousey, winid
	winget,minmax,minmax, ahk_id %winid%
	if minmax=1
		return
	WinGetClass, thisclass ,  ahk_id %winid%
	if thisclass=Shell_TrayWnd
		return
	check:=winstatus%winid%
	if check=1
	{
		if isdragging()
		{
		MouseGetPos,_x,_y

			newwinw:=winw%winid%
			newwinh:=winh%winid%
			newwinx:=mousex-(newwinw/2)

			winmove,ahk_id %winid%,, %newwinx%,,%newwinw%, %newwinh%
			winstatus%winid%=0
		}
		return
	}
	gosub setmode

	if mode
	{
		WinSet, alwaysontop, on , ahk_id %winid%
		WinGetPos ,thiswinx , thiswiny, thiswinw, thiswinh, ahk_id %winid%
		mousegetpos, mousex, mousey
		;	gui,show,x0 y0 w%ww% h%A_ScreenHeight%
		winmove,ahk_id %winid%,, %thiswinx%,%thiswiny%
		;mousemove,%mousex%,%mousey%
		;sendinput {lbutton down}
		loop
		{
			MouseGetPos, mousex, mousey
			if   (mousex<sides or mousex>fullcheck or mousey<10)
			{
				if not splash
				{
					gosub setmode
					gosub splash
				}
			}
			else
			{
				gosub splashoff
			}
			if	not GetKeyState("lbutton")
			{	
				MouseGetPos, mousex, mousey
				gosub setmode
				if mode
				{
					
					WinGetPos ,thiswinx , , thiswinw, thiswinh, ahk_id %winid%
					winstatus%winid%=1
					winw%winid%=%thiswinw%
					winh%winid%=%thiswinh%
					if (mousex>fullcheck)
					{
						gosub splashoff
						winright()
					}
					else if (mousey<10)
					{
						gosub splashoff
						winmax()
					}
					else
					{
						winleft()
					}
						
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
		gui,destroy
		WinSet, alwaysontop, off, ahk_id %winid%
	    gosub splashoff
	}
}
return




~ctrl::

	Confine(1,0,0,a_screenwidth,a_screenheight)
	fullcheck:=A_screenwidth-sides

keywait, ctrl
  Confine(0,0,0,0,0)
fullcheck:=VirtualScreenWidth-sides

return




Confine(C,X1,Y1,X2,Y2) { ; http://www.autohotkey.com/forum/viewtopic.php?p=293413#293413
  VarSetCapacity(R,16,0),NumPut(X1,&R+0),NumPut(Y1,&R+4),NumPut(X2,&R+8),NumPut(Y2,&R+12)
  Return C ? DllCall("ClipCursor",UInt,&R) : DllCall("ClipCursor")
}


isdragging()
{
 MouseGetPos, x, y, hwnd
		SendMessage, 0x84, 0, (x&0xFFFF) | (y&0xFFFF) << 16,, ahk_id %hwnd%
		RegExMatch("ERROR TRANSPARENT NOWHERE CLIENT CAPTION SYSMENU SIZE MENU HSCROLL VSCROLL MINBUTTON MAXBUTTON LEFT RIGHT TOP TOPLEFT TOPRIGHT BOTTOM BOTTOMLEFT BOTTOMRIGHT BORDER OBJECT CLOSE HELP", "(?:\w+\s+){" . ErrorLevel+2&0xFFFFFFFF . "}(?<AREA>\w+\b)", HT)
		if htarea!=CAPTION
			Return 0
		else
			return 1
}
