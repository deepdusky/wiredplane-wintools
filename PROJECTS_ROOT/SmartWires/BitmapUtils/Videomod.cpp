/*
Module : VIDEOMOD.CPP
Purpose: Implementation for some handy classes which wrap access 
to the EnumDisplaySettings & ChangeDisplaySettings SDK functions
Created: PJN / 24-09-1997
History: PJN / 03-01-1999 Major tidy up of the code
UNICODE enabled the code

  Copyright (c) 1997 by PJ Naughter.  
  All rights reserved.
  
*/

/////////////////////////////////  Includes  //////////////////////////////////
#include "stdafx.h"
#include "videomod.h"




///////////////////////////////// defines /////////////////////////////////////

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif



//////////////////////////////// Implementation ///////////////////////////////
CVideoMode::CVideoMode()
{
	dwAdditionalData=0;
	m_dwBitsPerPixel = 0;
	m_dwWidth = 0;
	m_dwHeight = 0;
	m_dwFrequency = 0;
}


CVideoMode::CVideoMode(DWORD BitsPerPixel, DWORD Width, DWORD Height, DWORD Frequency)
{
	dwAdditionalData=0;
	m_dwBitsPerPixel = BitsPerPixel;
	m_dwWidth = Width;
	m_dwHeight = Height;
	m_dwFrequency = Frequency;
}


CVideoMode::CVideoMode(const CVideoMode& mode)
{
	*this = mode;
}


CVideoMode& CVideoMode::operator=(const CVideoMode& mode)
{
	m_dwBitsPerPixel = mode.m_dwBitsPerPixel;
	m_dwWidth = mode.m_dwWidth;
	m_dwHeight = mode.m_dwHeight;
	m_dwFrequency = mode.m_dwFrequency;
	dwAdditionalData=mode.dwAdditionalData;
	return *this;
}



BOOL CVideoModes::GetCurrentVideoMode(CVideoMode& mode)
{
	HDC hdc = ::GetDC(NULL);  // Screen DC used to get current display settings
	if (hdc == NULL)
		return FALSE;
	
	CVideoMode m(GetDeviceCaps(hdc, BITSPIXEL), GetDeviceCaps(hdc, HORZRES),
		GetDeviceCaps(hdc, VERTRES), GetDeviceCaps(hdc, VREFRESH));
	mode = m;
	
	::ReleaseDC(NULL, hdc);
	
	return TRUE;
}


BOOL CVideoModes::GetAvailableVideoModes(CAvailableVideoModes& modes)
{
	modes.SetSize(0, 5);
	int iCount=0;
	DEVMODE dm;
	
	while (EnumDisplaySettings(NULL, iCount, &dm))
	{
		CVideoMode thismode(dm.dmBitsPerPel, dm.dmPelsWidth, 
			dm.dmPelsHeight, dm.dmDisplayFrequency);
		//if(dm.dmDisplayFrequency>=50){
			modes.Add(thismode);
		//}
		++iCount;
	}
	
	modes.FreeExtra();
	// ��������� � ������� ����������� ����������
	for(int i=modes.GetSize()-1;i>0;i--){
		for(int j=i-1;j>=0;j--){
			if(modes[i].m_dwWidth<modes[j].m_dwWidth ||
				(modes[i].m_dwHeight<modes[j].m_dwHeight && modes[i].m_dwWidth==modes[j].m_dwWidth) ||
				(modes[i].m_dwBitsPerPixel<modes[j].m_dwBitsPerPixel && (modes[i].m_dwHeight==modes[j].m_dwHeight && modes[i].m_dwWidth==modes[j].m_dwWidth)) || 
				(modes[i].m_dwFrequency<modes[j].m_dwFrequency && (modes[i].m_dwBitsPerPixel==modes[j].m_dwBitsPerPixel && (modes[i].m_dwHeight==modes[j].m_dwHeight && modes[i].m_dwWidth==modes[j].m_dwWidth)))){
				CVideoMode md=modes[i];
				modes[i]=modes[j];
				modes[j]=md;
			}
		}
	}
	return (iCount>0);
}


LONG CVideoModes::RevertVideoModeToDefault()
{
	LONG rVal = ChangeDisplaySettings(NULL, 0);
	
#ifdef _DEBUG
	ReportChangeVideoErrorValue(rVal);
#endif
	
	return rVal;
}


void CVideoModes::ReportChangeVideoErrorValue(LONG lError)
{
	switch (lError)
	{
    case DISP_CHANGE_SUCCESSFUL: TRACE(_T("ChangeDisplaySettings: The settings change was successful\n")); break;
    case DISP_CHANGE_RESTART:	   TRACE(_T("ChangeDisplaySettings: The computer must be restarted in order for the graphics mode to work\n")); break;
    case DISP_CHANGE_BADFLAGS:	 TRACE(_T("ChangeDisplaySettings: An invalid set of flags was passed in\n")); break;
    case DISP_CHANGE_FAILED:	   TRACE(_T("ChangeDisplaySettings: The display driver failed the specified graphics mode\n")); break;
    case DISP_CHANGE_BADMODE:	   TRACE(_T("ChangeDisplaySettings: The graphics mode is not supported\n")); break;
    case DISP_CHANGE_NOTUPDATED: TRACE(_T("ChangeDisplaySettings: Unable to write settings to the registry\n")); break;
    default:                     TRACE(_T("ChangeDisplaySettings: Unexpected error value\n")); break;
	}
}


LONG CVideoModes::ChangeVideoModePermanently(const CVideoMode& mode)
{
	DEVMODE dm;
	memset(&dm,0,sizeof(dm));
	dm.dmSize=sizeof(dm);
	CreateCompatibleDEVMODE(&dm, mode.m_dwBitsPerPixel, mode.m_dwWidth, mode.m_dwHeight, mode.m_dwFrequency);
	LONG rVal = ChangeDisplaySettings(&dm, CDS_UPDATEREGISTRY);//|CDS_SET_PRIMARY|CDS_GLOBAL
	//4294967295=-1
	//DISP_CHANGE_BADDUALVIEW
	//DISP_CHANGE_NOTUPDATED
#ifdef _DEBUG
	ReportChangeVideoErrorValue(rVal);
#endif
	
	return rVal;
}


LONG CVideoModes::ChangeVideoModeTemporarily(const CVideoMode& mode)
{
	DEVMODE dm;
	CreateCompatibleDEVMODE(&dm, mode.m_dwBitsPerPixel, mode.m_dwWidth, mode.m_dwHeight, mode.m_dwFrequency);
	LONG rVal = ChangeDisplaySettings(&dm, 0);
	
#ifdef _DEBUG
	ReportChangeVideoErrorValue(rVal);
#endif
	
	return rVal;
}

typedef BOOL (WINAPI *_EnumDisplayDevices)(PVOID Unused,DWORD iDevNum,PDISPLAY_DEVICEA lpDisplayDevice,DWORD dwFlags);
LONG CVideoModes::ChangeVideoModePermanentlyEx(const CVideoMode& mode)
{
	DISPLAY_DEVICE ddi;
	memset(&ddi,0,sizeof(ddi));
	ddi.cb=sizeof(ddi);
	HINSTANCE hUser32=LoadLibrary("User32.dll");
	if(hUser32){
		_EnumDisplayDevices fp=(_EnumDisplayDevices)DBG_GETPROC(hUser32,"EnumDisplayDevicesA");
		int iCount=0;
		while((*fp)(NULL,iCount,&ddi,NULL)){
			if((ddi.StateFlags & DISPLAY_DEVICE_ATTACHED_TO_DESKTOP)!=0){
				break;
			}
			iCount++;
		}
		FreeLibrary(hUser32);
	}
	if(strlen((const char*)ddi.DeviceName)==NULL){
		return DISP_CHANGE_FAILED;
	}
	DEVMODE dm;
	CreateCompatibleDEVMODE(&dm, mode.m_dwBitsPerPixel, mode.m_dwWidth, mode.m_dwHeight, mode.m_dwFrequency);
	LONG rVal = ChangeDisplaySettingsEx((const char*)ddi.DeviceName,&dm, NULL, CDS_UPDATEREGISTRY, NULL);
	
#ifdef _DEBUG
	ReportChangeVideoErrorValue(rVal);
#endif
	
	return rVal;
}

LONG CVideoModes::CanChangeVideoMode(const CVideoMode& mode)
{
	DEVMODE dm;
	CreateCompatibleDEVMODE(&dm, mode.m_dwBitsPerPixel, mode.m_dwWidth, mode.m_dwHeight, mode.m_dwFrequency);
	LONG rVal = ChangeDisplaySettings(&dm, CDS_TEST);
	
#ifdef _DEBUG
	ReportChangeVideoErrorValue(rVal);
#endif
	
	return rVal;
}


void CVideoModes::CreateCompatibleDEVMODE(DEVMODE* pdm, DWORD BitsPerPixel, DWORD Width, DWORD Height, DWORD Frequency)
{
	ZeroMemory(pdm, sizeof(DEVMODE));
	pdm->dmSize = sizeof(DEVMODE);
	
	if (BitsPerPixel)
	{
		pdm->dmBitsPerPel = BitsPerPixel;
		pdm->dmFields |= DM_BITSPERPEL;
	}
	
	if (Width)
	{
		pdm->dmPelsWidth = Width;
		pdm->dmFields |= DM_PELSWIDTH;
	}
	
	if (Height)
	{
		pdm->dmPelsHeight = Height;
		pdm->dmFields |= DM_PELSHEIGHT;
	}
	
	if (Frequency)
	{
		pdm->dmDisplayFrequency = Frequency;
		pdm->dmFields |= DM_DISPLAYFREQUENCY;
	}
}

