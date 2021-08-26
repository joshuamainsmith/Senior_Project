// dllmain.cpp : Defines the entry point for the DLL application.
#include "pch.h"
#include "detours.h"
#include "Windows.h"
#include "Shlobj.h"

struct WindowData
{
    unsigned long pid;
    HWND windowHandle;
};

static LRESULT(__stdcall* mouseHookProc_1)(int nCode, WPARAM arg2, LPARAM arg3) = (LRESULT (__stdcall*)(int, WPARAM, LPARAM))((DWORD)GetModuleHandle(L"LockDownBrowser.dll") + 0x1310);
static LRESULT(__stdcall* mouseHookProc_2)(int nCode, WPARAM arg2, LPARAM arg3) = (LRESULT(__stdcall*)(int, WPARAM, LPARAM))((DWORD)GetModuleHandle(L"LockDownBrowser.dll") + 0x1250);
static LRESULT(__stdcall* shellHookProc)(int nCode, WPARAM arg2, LPARAM arg3) = (LRESULT(__stdcall*)(int, WPARAM, LPARAM))((DWORD)GetModuleHandle(L"LockDownBrowser.dll") + 0x13a0);
static LRESULT(__stdcall* keyboardHookProc)(int nCode, WPARAM arg2, LPARAM arg3) = (LRESULT(__stdcall*)(int, WPARAM, LPARAM))((DWORD)GetModuleHandle(L"LockDownBrowser.dll") + 0x11d0);

static LSTATUS(WINAPI* TrueRegSetValueExA)(HKEY hKey, LPCSTR lpValueName, DWORD Reserved, DWORD dwType, const BYTE* lpData, DWORD cbData) = RegSetValueExA;
static LSTATUS(WINAPI* TrueRegQueryValueExA)(HKEY hKey, LPCSTR lpValueName, LPDWORD lpReserved, LPDWORD lpType, LPBYTE lpData, LPDWORD lpcbData) = RegQueryValueExA;
static LSTATUS(WINAPI* TrueRegOpenKeyExA)(HKEY hKey, LPCSTR lpSubKey, DWORD ulOptions, REGSAM samDesired, PHKEY phkResult) = RegOpenKeyExA;
static LSTATUS(WINAPI* TrueRegOpenKeyA)(HKEY hKey, LPCSTR lpSubKey, PHKEY phkResult) = RegOpenKeyA;
static LSTATUS(WINAPI* TrueRegDeleteValueA)(HKEY hKey, LPCSTR lpValueName) = RegDeleteValueA;
static LSTATUS(WINAPI* TrueRegCreateKeyA)(HKEY hKey, LPCSTR lpSubKey, PHKEY phkResult) = RegCreateKeyA;
static BOOL(WINAPI* TrueEmptyClipboard)() = EmptyClipboard;
static HWND(WINAPI* TrueGetForegroundWindow)() = GetForegroundWindow;
static BOOL(WINAPI* TrueShowWindow)(HWND hWnd, int nCmdShow) = ShowWindow;
//static HHOOK(WINAPI* TrueSetWindowsHookExA)(int idHook, HOOKPROC lpfn, HINSTANCE hmod, )

BOOL WriteLog(LPCSTR message, LPCSTR loggedReg, const BYTE* data, DWORD dataSize)
{
    DWORD bytesWritten = 0;
    LPWSTR desktopPath;
    TCHAR logPath[256];


    if (SHGetKnownFolderPath(FOLDERID_Desktop, 0, NULL, &desktopPath) != S_OK)
    {
        return false;
    }

    wsprintf(logPath, L"%s%s", desktopPath, L"\\log.txt");

    HANDLE hFile = CreateFile(logPath, FILE_APPEND_DATA, 0, NULL, OPEN_ALWAYS, FILE_ATTRIBUTE_NORMAL, NULL);
    if (hFile == INVALID_HANDLE_VALUE)
        return false;

    if (WriteFile(hFile, message, DWORD(strlen(message)), &bytesWritten, NULL) == ERROR_IO_PENDING)
        WaitForSingleObject(hFile, INFINITE);
    if (WriteFile(hFile, loggedReg, DWORD(strlen(loggedReg)), &bytesWritten, NULL) == ERROR_IO_PENDING)
        WaitForSingleObject(hFile, INFINITE);
    /*if (dataSize != 0)
    {
        if (WriteFile(hFile, data, dataSize, &bytesWritten, NULL) == ERROR_IO_PENDING)
            WaitForSingleObject(hFile, INFINITE);
    }*/
    if (WriteFile(hFile, L"\n", DWORD(strlen("\n")), &bytesWritten, NULL) == ERROR_IO_PENDING)
        WaitForSingleObject(hFile, INFINITE);

    CloseHandle(hFile);
    return true;
}

LSTATUS WINAPI NewRegSetValueExA(HKEY hKey, LPCSTR lpValueName, DWORD Reserved, DWORD dwType, const BYTE* lpData, DWORD cbData)
{
    LPCSTR message = "Registry Key Value Set: ";

    WriteLog(message, lpValueName, lpData, cbData);

    if (!strcmp(lpValueName, "active"))
    {
        return TrueRegSetValueExA(hKey, lpValueName, Reserved, dwType, lpData, cbData);
    }

    return ERROR_SUCCESS;
}


LSTATUS WINAPI NewRegQueryValueExA(HKEY hKey, LPCSTR lpValueName, LPDWORD lpReserved, LPDWORD lpType, LPBYTE lpData, LPDWORD lpcbData)
{
    LPCSTR message = "Registry Key Queried: ";

    WriteLog(message, lpValueName, NULL, 0);

    return TrueRegQueryValueExA(hKey, lpValueName, lpReserved, lpType, lpData, lpcbData);
}

LSTATUS WINAPI NewRegOpenKeyExA(HKEY hKey, LPCSTR lpSubKey, DWORD ulOptions, REGSAM samDesired, PHKEY phkResult)
{
    LPCSTR message = "Registry Key Opened: ";

    WriteLog(message, lpSubKey, NULL, 0);

    return TrueRegOpenKeyExA(hKey, lpSubKey, ulOptions, samDesired, phkResult);
}

LSTATUS WINAPI NewRegOpenKeyA(HKEY hKey, LPCSTR lpSubKey, PHKEY phkResult)
{
    LPCSTR message = "Registry Key Opened: ";

    WriteLog(message, lpSubKey, NULL, 0);

    return TrueRegOpenKeyA(hKey, lpSubKey, phkResult);
}

LSTATUS WINAPI NewRegDeleteValueA(HKEY hKey, LPCSTR lpValueName)
{
    LPCSTR message = "Registry Key Deleted: ";

    WriteLog(message, lpValueName, NULL, 0);

    return TrueRegDeleteValueA(hKey, lpValueName);
}

LSTATUS WINAPI NewRegCreateKeyA(HKEY hKey, LPCSTR lpSubKey, PHKEY phkResult)
{
    LPCSTR message = "Registry Key Created: ";

    WriteLog(message, lpSubKey, NULL, 0);

    return TrueRegCreateKeyA(hKey, lpSubKey, phkResult);;
}

BOOL WINAPI NewEmptyClipboard()
{
    return 1;
}

BOOL CALLBACK EnumCallback(HWND handle, LPARAM lparam)
{
    WindowData& data = *(WindowData*)lparam;
    unsigned long pid = 0;

    GetWindowThreadProcessId(handle, &pid);
    if (data.pid != pid || (GetWindow(handle, GW_OWNER) == 0 && IsWindowVisible(handle)))
        return true;

    data.windowHandle = handle;
    return false;
}

HWND WINAPI NewGetForegroundWindow()
{
    WindowData data;
    data.pid = GetCurrentProcessId();
    data.windowHandle = 0;

    EnumWindows(EnumCallback, (LPARAM)&data);

    return data.windowHandle;
}

BOOL WINAPI NewShowWindow(HWND hWnd, int nCmdShow)
{
    TCHAR windowName[128];

    GetWindowTextW(hWnd, windowName, 128);
    if (!wcscmp(windowName, L"Shell_TrayWnd"))
    {
        return 1;
    }

    return TrueShowWindow(hWnd, nCmdShow);
}

LRESULT NewMouseHook_1(int nCode, WPARAM arg2, LPARAM arg3)
{
    static PVOID *mouseHook = (PVOID*)((DWORD)GetModuleHandle(L"LockDownBrowser.dll") + 0x14008);
    return CallNextHookEx((HHOOK)*mouseHook, nCode, arg2, arg3);
}

LRESULT NewMouseHook_2(int nCode, WPARAM arg2, LPARAM arg3)
{
    static PVOID *mouseHook = (PVOID*)((DWORD)GetModuleHandle(L"LockDownBrowser.dll") + 0x14008);
    return CallNextHookEx((HHOOK)*mouseHook, nCode, arg2, arg3);
}

LRESULT NewShellHook(int nCode, WPARAM arg2, LPARAM arg3)
{
    static PVOID *shellHook = (PVOID*)((DWORD)GetModuleHandle(L"LockDownBrowser.dll") + 0x14004);
    return CallNextHookEx((HHOOK)*shellHook, nCode, arg2, arg3);
}

LRESULT NewKeyboardHook(int nCode, WPARAM arg2, LPARAM arg3)
{
    static PVOID *keyboardHook = (PVOID*)((DWORD)GetModuleHandle(L"LockDownBrowser.dll") + 0x14000);
    return CallNextHookEx((HHOOK)*keyboardHook, nCode, arg2, arg3);
}

BOOL APIENTRY DllMain( HMODULE hModule,
                       DWORD  ul_reason_for_call,
                       LPVOID lpReserved
                     )
{
    switch (ul_reason_for_call)
    {
    case DLL_PROCESS_ATTACH:
        DetourRestoreAfterWith();

        DetourTransactionBegin();
        DetourUpdateThread(GetCurrentThread());
        DetourAttach(&(PVOID&)TrueEmptyClipboard, NewEmptyClipboard);
        DetourAttach(&(PVOID&)TrueGetForegroundWindow, NewGetForegroundWindow);
        DetourAttach(&(PVOID&)TrueRegCreateKeyA, NewRegCreateKeyA);
        DetourAttach(&(PVOID&)TrueRegDeleteValueA, NewRegDeleteValueA);
        DetourAttach(&(PVOID&)TrueRegOpenKeyA, NewRegOpenKeyA);
        DetourAttach(&(PVOID&)TrueRegOpenKeyExA, NewRegOpenKeyExA);
        DetourAttach(&(PVOID&)TrueRegQueryValueExA, NewRegQueryValueExA);
        DetourAttach(&(PVOID&)TrueRegSetValueExA, NewRegSetValueExA);
        //DetourAttach(&(PVOID&)TrueShowWindow, NewShowWindow);
        DetourAttach(&(PVOID&)mouseHookProc_1, NewMouseHook_1);
        DetourAttach(&(PVOID&)mouseHookProc_2, NewMouseHook_2);
        DetourAttach(&(PVOID&)shellHookProc, NewShellHook);
        DetourAttach(&(PVOID&)keyboardHookProc, NewKeyboardHook);
        DetourTransactionCommit();
        break;
    case DLL_THREAD_ATTACH:
        break;
    case DLL_THREAD_DETACH:
        break;
    case DLL_PROCESS_DETACH:
        DetourTransactionBegin();
        DetourUpdateThread(GetCurrentThread());
        DetourDetach(&(PVOID&)TrueEmptyClipboard, NewEmptyClipboard);
        DetourDetach(&(PVOID&)TrueGetForegroundWindow, NewGetForegroundWindow);
        DetourDetach(&(PVOID&)TrueRegCreateKeyA, NewRegCreateKeyA);
        DetourDetach(&(PVOID&)TrueRegDeleteValueA, NewRegDeleteValueA);
        DetourDetach(&(PVOID&)TrueRegOpenKeyA, NewRegOpenKeyA);
        DetourDetach(&(PVOID&)TrueRegOpenKeyExA, NewRegOpenKeyExA);
        DetourDetach(&(PVOID&)TrueRegQueryValueExA, NewRegQueryValueExA);
        DetourDetach(&(PVOID&)TrueRegSetValueExA, NewRegSetValueExA);
        //DetourDetach(&(PVOID&)TrueShowWindow, NewShowWindow);
        DetourDetach(&(PVOID&)mouseHookProc_1, NewMouseHook_1);
        DetourDetach(&(PVOID&)mouseHookProc_2, NewMouseHook_2);
        DetourDetach(&(PVOID&)shellHookProc, NewShellHook);
        DetourDetach(&(PVOID&)keyboardHookProc, NewKeyboardHook);
        DetourTransactionCommit();
        break;
    }
    return TRUE;
}