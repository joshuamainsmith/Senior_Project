// Dll Injector.cpp : This file contains the 'main' function. Program execution begins and ends there.
//

#include <iostream>
#include <string>
#include "Windows.h"
#include "tlhelp32.h"
#include <tchar.h>

BOOL IsElevated() {
    BOOL fRet = FALSE;
    HANDLE hToken = NULL;
    if (OpenProcessToken(GetCurrentProcess(), TOKEN_QUERY, &hToken)) {
        TOKEN_ELEVATION Elevation;
        DWORD cbSize = sizeof(TOKEN_ELEVATION);
        if (GetTokenInformation(hToken, TokenElevation, &Elevation, sizeof(Elevation), &cbSize)) {
            fRet = Elevation.TokenIsElevated;
        }
    }
    if (hToken) {
        CloseHandle(hToken);
    }
    return fRet;
}

BOOL FileExists(LPCTSTR path)
{
    DWORD retVal = GetFileAttributes(path);
    return retVal != INVALID_FILE_ATTRIBUTES && !(retVal & FILE_ATTRIBUTE_DIRECTORY);
}

int main(int argc, char *argv[])
{
    STARTUPINFO si;
    PROCESS_INFORMATION pi;
    HANDLE snapshot;
    THREADENTRY32 entry;
    TCHAR dllPath[256];
    TCHAR dllName[256];
    DWORD pathSize, retval = 0;
    LPTSTR lockDown = _tcsdup(TEXT("\"C:\\Program Files (x86)\\Respondus\\LockDown Browser\\LockDownBrowser.exe\""));


    ZeroMemory(&si, sizeof(si));
    ZeroMemory(&pi, sizeof(pi));
    ZeroMemory(&entry, sizeof(entry));
    si.cb = sizeof(si);
    entry.dwSize = sizeof(entry);

    switch (argc)
    {
    case 1:
        printf("Usage: DLL Injector.exe [dll name]\n");
        printf("The DLL has to be placed in the same directory as the injector.\n");
        return -1;

    case 2:
        sprintf_s(dllName, "%s", argv[1]);
        break;
    }

    if (!IsElevated())
    {
        printf("[-] Process is not running as admin. Make sure to run process as Admin.\n");
        return -1;
    }

    // Start the child process. 
    if (!CreateProcess(NULL,   // No module name (use command line)
        lockDown,        // Command line
        NULL,           // Process handle not inheritable
        NULL,           // Thread handle not inheritable
        FALSE,          // Set handle inheritance to FALSE
        CREATE_SUSPENDED,              // No creation flags
        NULL,           // Use parent's environment block
        NULL,           // Use parent's starting directory 
        &si,            // Pointer to STARTUPINFO structure
        &pi)           // Pointer to PROCESS_INFORMATION structure
        )
    {
        printf("[-] CreateProcess failed: %d.\n", GetLastError());
        return -1;
    }

    WaitForSingleObject(pi.hProcess, 2000);

    pathSize = GetFullPathNameA(dllName, 256, dllPath, NULL);
    if ( pathSize == 0)
    {
        printf("[-] GetFullPathNameA failed: %d\n", GetLastError());
    }

    if (!FileExists(dllPath))
    {
        printf("[-] Filename is invalid.\n");
    }

    LPVOID dllAddressInRespondus = VirtualAllocEx(pi.hProcess, NULL, pathSize + 1, MEM_RESERVE | MEM_COMMIT, PAGE_EXECUTE_READWRITE);

    if (dllAddressInRespondus == NULL)
    {
        printf("[-] VirtualAllocEx Failed: %d.\n", GetLastError());
        return -1;
    }

    if (!WriteProcessMemory(pi.hProcess, dllAddressInRespondus, dllPath, pathSize, NULL))
    {
        printf("[-] WriteProcessMemory Failed: %d.\n", GetLastError());
        return -1;
    }
    else
    {
        LPVOID loadLibraryAddr = static_cast<LPVOID>(GetProcAddress(GetModuleHandle(TEXT("kernel32.dll")), "LoadLibraryA"));
        if (loadLibraryAddr == NULL)
        {
            printf("[-] GetProcAddress Failed: %d.\n", GetLastError());
            return -1;
        }

        HANDLE remoteThread = CreateRemoteThread(pi.hProcess, NULL, NULL, (LPTHREAD_START_ROUTINE)loadLibraryAddr, dllAddressInRespondus, NULL, NULL);
        if (remoteThread == NULL)
        {
            printf("[-] CreateRemoteThread Failed: %d.\n", GetLastError());
            return false;
        }

        if (WaitForSingleObject(remoteThread, INFINITE) == WAIT_FAILED)
        {
            printf("[-] WaitForSingleObject Failed: %d.\n", GetLastError());
            return false;
        }

        CloseHandle(remoteThread);

        /*snapshot = CreateToolhelp32Snapshot(TH32CS_SNAPTHREAD, NULL);
        if (snapshot == INVALID_HANDLE_VALUE)
        {
            printf("[-] CreateToolhelp32Snapshot failed: %d.\n", GetLastError());
            return -1;
        }

        if (!Thread32First(snapshot, &entry))
        {
            printf("[-] Thread32First failed: %d.\n", GetLastError());
            return -1;
        }

        while (1)
        {
            if (entry.th32OwnerProcessID == pi.dwProcessId)
            {
                HANDLE h = OpenThread(THREAD_ALL_ACCESS, FALSE, entry.th32ThreadID);
                if (h == NULL)
                {
                    printf("[-] OpenThread failed: %d.\n", GetLastError());
                    return -1;
                }
                if (QueueUserAPC((PAPCFUNC)loadLibraryAddr, h, (ULONG_PTR)dllAddressInRespondus) == 0)
                {
                    printf("[-] QueueUserAPC failed: %d.\n", GetLastError());
                    return -1;
                }
                CloseHandle(h);
                break;
            }
            if (!Thread32Next(snapshot, &entry))
            {
                printf("[-] Thread32Next failed: %d.\n", GetLastError());
                return -1;
            }
        }*/

    }

    if (ResumeThread(pi.hThread) == -1)
    {
        printf("[-] ResumeThread failed: %d.\n", GetLastError());
        return -1;
    }
    if (!CloseHandle(pi.hProcess))
    {
        printf("[-] CloseHandle failed: %d.\n", GetLastError());
    }

    printf("Succesfully injected into Respondus.");
    return 0;
}
