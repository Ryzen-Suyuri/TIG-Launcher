Attribute VB_Name = "CommonDialog"
' From Nucleus on VBForums
' https://www.vbforums.com/showthread.php?84273-How-to-hide-the-quot-Open-as-Read-Only-quot-checkbox-on-a-commondialog-open-box

Option Explicit

Private Type OPENFILENAME
    lStructSize As Long
    hwndOwner As Long
    hInstance As Long
    lpstrFilter As String
    lpstrCustomFilter As Long
    nMaxCustrFilter As Long
    nFilterIndex As Long
    lpstrFile As String
    nMaxFile As Long
    lpstrFileTitle As String
    nMaxFileTitle As Long
    lpstrInitialDir As String
    lpstrTitle As String
    Flags As Long
    nFileOffset As Integer
    nFileExtension As Integer
    lpstrDefExt As String
    lCustrData As Long
    lpfnHook As Long
    lpTemplateName As Long
End Type

Private Const OFN_HIDEREADONLY = &H4 'hide Open As read only check box
Private Const OFN_ALLOWMULTISELECT = &H200
Private Const OFN_CREATEPROMPT = &H2000
Private Const OFN_EXPLORER = &H80000
Private Const OFN_FILEMUSTEXIST = &H1000
Private Const OFN_NOCHANGEDIR = &H8
Private Const OFN_NODEREFERENCELINKS = &H100000
Private Const OFN_NONETWORKBUTTON = &H20000
Private Const OFN_NOREADONLYRETURN = &H8000
Private Const OFN_NOVALIDATE = &H100
Private Const OFN_OVERWRITEPROMPT = &H2
Private Const OFN_PATHMUSTEXIST = &H800
Private Const OFN_READONLY = &H1
Private Const OFN_SHOWHELP = &H10

Private Const ALLFILES = "All Files"

Private Declare Function GetActiveWindow Lib "user32" () As Long
Private Declare Function GetOpenFileName Lib "comdlg32.dll" Alias _
    "GetOpenFileNameA" (pOpenfilename As OPENFILENAME) As Boolean
    
'Purpose: Shows the Open file common dialog
'Inputs: strTitle, the title of the dialog, pass "" For default
'Inputs: strDefaultPath, the default path
'Inputs: Filter, the filter, an even number of arguments e.g.("text files, *.txt, mdb files, *.mdb")
'Outputs: Returns the specified file name And path Or "" If cancelled
'Author: Nucleus
    
Public Function ShowOpen(Optional strTitle As String, _
    Optional strDefaultPath As String, Optional Filter As String) As String

    Dim OFName As OPENFILENAME
    OFName.lStructSize = Len(OFName)
    'Set the parent window
    OFName.hwndOwner = GetActiveWindow
    'Set the application's instance
    OFName.hInstance = 0
    'create a buffer For the file
    OFName.lpstrFile = Space$(254)
    'set the maximum length of a returned file
    OFName.nMaxFile = 255
    'Create a buffer For the file title
    OFName.lpstrFileTitle = Space$(254)
    'Set the maximum length of a returned file title
    OFName.nMaxFileTitle = 255
    'Set the title
    OFName.lpstrTitle = strTitle
    'No flags
    OFName.Flags = OFN_HIDEREADONLY Or OFN_FILEMUSTEXIST _

    Dim fsObject As Object
    Set fsObject = CreateObject("Scripting.FileSystemObject")
    If fsObject.FolderExists(strDefaultPath) Then
        OFName.lpstrInitialDir = strDefaultPath
    Else
        OFName.lpstrInitialDir = CurDir$
    End If
    
    OFName.lpstrFilter = CreateFilterString(Filter)
    
    'Call the Open dialog routine.
    If GetOpenFileName(OFName) Then
        ' ShowOpen = Trim$(OFName.lpstrFile)
        ShowOpen = Left$(OFName.lpstrFile, InStr(OFName.lpstrFile, Chr$(0)) - 1)
    Else
        ShowOpen = ""
    End If
    
End Function

Private Function CreateFilterString(Filter As String) As String
' Creates a filter String from the passed In arguments.
' Expects an even number of arguments
    Dim sa() As String, i%
    sa = Split(Filter, ",")
    
    For i = 0 To UBound(sa)
        CreateFilterString = CreateFilterString & sa(i) & vbNullChar
    Next i
    ' CreateFilterString = CreateFilterString & "All Files (*.*)" & vbNullChar & "*.*"
End Function

