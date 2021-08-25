#ifndef HOOKS_GUARD
#define HOOKS_GUARD
#include "Windows.h"
#include "pch.h"


BOOL WriteLog(LPCSTR message, LPCSTR loggedReg);
LSTATUS WINAPI NewRegSetValueExA(HKEY hKey, LPCSTR lpValueName, DWORD Reserved, DWORD dwType, const BYTE* lpData, DWORD cbData);
LSTATUS WINAPI NewRegQueryValueExA(HKEY hKey, LPCSTR lpValueName, LPDWORD lpReserved, LPDWORD lpType, LPBYTE lpData, LPDWORD lpcbData);
LSTATUS WINAPI NewRegOpenKeyExA(HKEY hKey, LPCSTR lpSubKey, DWORD ulOptions, REGSAM samDesired, PHKEY phkResult);
LSTATUS WINAPI NewRegOpenKeyA(HKEY hKey, LPCSTR lpSubKey, PHKEY phkResult);
LSTATUS WINAPI NewRegDeleteValueA(HKEY hKey, LPCSTR lpValueName);
LSTATUS WINAPI NewRegCreateKeyA(HKEY hKey, LPCSTR lpSubKey, PHKEY phkResult);
BOOL WINAPI NewEmptyClipboard();
BOOL CALLBACK EnumCallback(HWND handle, LPARAM lparam);
HWND WINAPI NewGetForegroundWindow();

#endif