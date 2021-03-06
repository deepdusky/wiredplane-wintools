// stdafx.h : include file for standard system include files,
//  or project specific include files that are used frequently, but
//      are changed infrequently
//

#if !defined(AFX_STDAFX_H__434ED7BA_1FFE_4B55_B2F2_4953FBA3F99E__INCLUDED_)
#define AFX_STDAFX_H__434ED7BA_1FFE_4B55_B2F2_4953FBA3F99E__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000


// Insert your headers here
#define WIN32_LEAN_AND_MEAN		// Exclude rarely-used stuff from Windows headers

#include <afxwin.h>         // MFC core and standard components
#include <afxext.h>         // MFC extensions
#include <afxtempl.h>
#include <atlbase.h>
#include <afxmt.h>
#include <afxdisp.h>        // MFC Automation classes
#include <afxdtctl.h>		// MFC support for Internet Explorer 4 Common Controls
#include <afxcmn.h>
//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.
#include "..\..\SmartWires\SystemUtils\Macros.h"
#define _NO_XMLHOTKEYSUPPORT
#define EXECRYPTOR_SALT	"WC5"
#endif // !defined(AFX_STDAFX_H__434ED7BA_1FFE_4B55_B2F2_4953FBA3F99E__INCLUDED_)
