Attribute VB_Name = "SharedFunctions"
' Define types and constants
Private Type PROCESSENTRY32
    dwSize As Long
    cntUsage As Long
    th32ProcessID As Long
    th32DefaultHeapID As Long
    th32ModuleID As Long
    cntThreads As Long
    th32ParentProcessID As Long
    pcPriClassBase As Long
    dwFlags As Long
    szExeFile As String * 260
End Type

Private Type PROCESS_BASIC_INFORMATION
    Reserved1 As Long
    PebBaseAddress As Long
    Reserved2(1) As Long
    UniqueProcessId As Long
    Reserved3 As Long
End Type

Private Enum PROCESSINFOCLASS
    ProcessBasicInformation = 0
    ProcessDebugPort = 7
    ProcessWow64Information = 26
    ProcessImageFileName = 27
    ProcessBreakOnTermination = 29
End Enum

Private Const PROCESS_QUERY_INFORMATION = &H400
Private Const PROCESS_CREATE_THREAD = &H2
Private Const PROCESS_VM_OPERATION = &H8
Private Const PROCESS_VM_READ = &H10
Private Const PROCESS_VM_WRITE = &H20

Private Const PAGE_EXECUTE_READWRITE = &H40

Private Const TH32CS_SNAPPROCESS = &H2

' Import needed Windows API functions
Private Declare Function Process32First Lib "kernel32" (ByVal hSnapshot As Long, ByRef lppe As PROCESSENTRY32) As Long

Private Declare Function Process32Next Lib "kernel32" (ByVal hSnapshot As Long, ByRef lppe As PROCESSENTRY32) As Long

Private Declare Function OpenProcess Lib "kernel32" (ByVal dwDesiredAccess As Long, ByVal bInheritHandle As Long, ByVal dwProcessId As Long) As Long

Private Declare Function VirtualProtectEx Lib "kernel32" (ByVal hProcess As Long, ByVal lpAddress As Long, ByVal dwSize As Long, ByVal flNewProtect As Long, ByRef lpflOldProtect As Long) As Long

Private Declare Function NtQueryInformationProcess Lib "ntdll" (ByVal ProcessHandle As Long, ByVal ProcessInformationClass As PROCESSINFOCLASS, ByRef ProcessInformation As Any, ByVal ProcessInformationLength As Long, ByVal ReturnLength As Long) As Long

Private Declare Function CloseHandle Lib "kernel32" (ByVal hObject As Long) As Boolean

Private Declare Function ReadProcessMemory Lib "kernel32" (ByVal hProcess As Long, ByVal lpBaseAddress As Long, ByRef lpBuffer As Any, ByVal nSize As Long, ByRef lpNumberOfBytesRead As Long) As Long

Private Declare Function WriteProcessMemory Lib "kernel32" (ByVal hProcess As Long, ByVal lpBaseAddress As Long, ByRef lpBuffer As Any, ByVal nSize As Long, ByRef lpNumberOfBytesWritten As Long) As Long

Private Declare Function CreateToolhelp32Snapshot Lib "kernel32" (ByVal dwFlags As Long, ByVal th32ProcessID As Long) As Long

' Main memory patching procedure
' Requires name of running executable to patch, target RVA, and an array of bytes to patch in at the address
Public Sub PatchMemory(ByVal exeName As String, ByVal targetAddress As Long, ByRef patchBytes() As Byte)
    ' Find the given executable in memory
    Dim currProcEntry As PROCESSENTRY32
    Dim thSnapshot As Long
    currProcEntry.dwSize = Len(currProcEntry)
    thSnapshot = CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0)
    ' If process info is obtainable, iterate through all of the currently-running processes
    If Process32First(thSnapshot, currProcEntry) Then
        Dim currName As String
        Do
            ' Strip garbage from current executable's name after null (0) terminator
            currName = Left$(currProcEntry.szExeFile, InStr(currProcEntry.szExeFile, Chr$(0)) - 1)
            ' If this is the executable with the name we're looking for
            If StrComp(currName, exeName, vbBinaryCompare) = 0 Then
                CloseHandle thSnapshot
                
                ' Get a handle to the current process
                Dim hProc As Long
                hProc = OpenProcess( _
                PROCESS_QUERY_INFORMATION Or PROCESS_CREATE_THREAD Or PROCESS_VM_OPERATION Or PROCESS_VM_READ Or PROCESS_VM_WRITE, _
                0, currProcEntry.th32ProcessID)
                If hProc = 0 Then
                    MsgBox "Error opening " & currName & " in memory..."
                    Exit Sub
                End If
                
                ' Get base address
                Dim procBasicInfo As PROCESS_BASIC_INFORMATION
                NtQueryInformationProcess hProc, ProcessBasicInformation, procBasicInfo, Len(procBasicInfo), 0
                
                ' Get current image base address of the target (as it is dynamic for programs like The Impossible Game)
                Dim imageBaseAddress As Long
                Dim bytesRead As Long
                ReadProcessMemory hProc, procBasicInfo.PebBaseAddress + &H8, imageBaseAddress, Len(imageBaseAddress), bytesRead
                
                ' Write memory patch
                Dim oldProtect As Long
                Dim bytesWritten As Long
                If VirtualProtectEx(hProc, imageBaseAddress + targetAddress, UBound(patchBytes) + 1, PAGE_EXECUTE_READWRITE, oldProtect) = 0 Then
                    MsgBox "Error changing memory permission with VirtualProtect..."
                End If
                If WriteProcessMemory(hProc, imageBaseAddress + targetAddress, patchBytes(0), UBound(patchBytes) + 1, bytesWritten) = 0 Then
                    MsgBox "Error writing memory patch with WriteProcessMemory..."
                End If
                If VirtualProtectEx(hProc, imageBaseAddress + targetAddress, UBound(patchBytes) + 1, oldProtect, oldProtect) = 0 Then
                    MsgBox "Error reverting memory permission with VirtualProtect..."
                End If
                
                CloseHandle hProc
                Exit Sub
            End If
        Loop While (Process32Next(thSnapshot, currProcEntry))
        
        MsgBox "Could not find " & exeName & " in memory..."
    End If
End Sub
