VERSION 5.00
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "COMDLG32.OCX"
Begin VB.Form CrashFixGetWindow 
   BackColor       =   &H00808000&
   BorderStyle     =   1  'Fixed Single
   Caption         =   "GetCrashFix"
   ClientHeight    =   2475
   ClientLeft      =   6255
   ClientTop       =   3585
   ClientWidth     =   4560
   Icon            =   "CrashFixGetWindow.frx":0000
   LinkTopic       =   "Form2"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   2475
   ScaleWidth      =   4560
   Begin MSComDlg.CommonDialog dlgImpossibleSelect 
      Left            =   4080
      Top             =   2040
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   393216
   End
   Begin VB.CommandButton btnNah 
      BackColor       =   &H00808000&
      Caption         =   "No"
      BeginProperty Font 
         Name            =   "Akashi"
         Size            =   11.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   1335
      Left            =   2280
      Style           =   1  'Graphical
      TabIndex        =   2
      Top             =   1200
      Width           =   2295
   End
   Begin VB.CommandButton btnSure 
      BackColor       =   &H00808000&
      Caption         =   "Yes"
      BeginProperty Font 
         Name            =   "Akashi"
         Size            =   11.25
         Charset         =   0
         Weight          =   400
         Underline       =   -1  'True
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   1335
      Left            =   0
      Style           =   1  'Graphical
      TabIndex        =   1
      Top             =   1200
      Width           =   2295
   End
   Begin VB.Label lblNah 
      BackStyle       =   0  'Transparent
      Caption         =   "No"
      Height          =   255
      Left            =   3000
      TabIndex        =   3
      Top             =   1800
      Width           =   735
   End
   Begin VB.Label lblFixDesc 
      BackColor       =   &H00808000&
      Caption         =   $"CrashFixGetWindow.frx":000C
      BeginProperty Font 
         Name            =   "Akashi"
         Size            =   11.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00FFFFFF&
      Height          =   3135
      Left            =   0
      TabIndex        =   0
      Top             =   0
      Width           =   4575
   End
End
Attribute VB_Name = "CrashFixGetWindow"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub Form_Load()
    CrashFixGetWindow.Icon = LauncherWindow.Icon
End Sub

Private Sub btnSure_Click()
    ' Only allow ImpossibleGame.exe to be selected, non-read-only
    dlgImpossibleSelect.Filter = "Impossible Game executable (ImpossibleGame.exe)|ImpossibleGame.exe"
    dlgImpossibleSelect.DialogTitle = "Select Impossible Game executable (ImpossibleGame.exe)"
    dlgImpossibleSelect.Flags = cdlOFNHideReadOnly

    ' Get Steam directory from registry if installed
    Dim shell As Object
    Set shell = CreateObject("WScript.Shell")
    Dim steamDir As String
    On Error Resume Next
    steamDir = shell.RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Valve\Steam\InstallPath")
    ' If Steam is installed, default the file open dialog to the Impossible Game
    ' install directory from there
    If Not StrComp(steamDir, "", vbBinaryCompare) = 0 Then
        dlgImpossibleSelect.InitDir = steamDir & "\steamapps\common\TheImpossibleGame"
    End If
    
    dlgImpossibleSelect.ShowOpen
    
    ' If a file is selected, patch it
    If Not StrComp(dlgImpossibleSelect.FileName, "", vbBinaryCompare) = 0 Then
        ' Make backup .og file if nonexistent
        If Dir(dlgImpossibleSelect.FileName & ".og") <> "" Then
            On Error GoTo CopyFail
            FileCopy dlgImpossibleSelect.FileName, dlgImpossibleSelect.FileName & ".og"
        End If
        
        ' Begin the patching. Open the file
        On Error GoTo PatchFail
        Dim impossibleFile As Integer
        impossibleFile = FreeFile
        Open dlgImpossibleSelect.FileName For Binary Access Write Lock Read Write As #impossibleFile
        
        ' VB6 Puts start at 1!
        ' Write first continuous patch at 0x349DA
        Dim patch1(4) As Byte
        patch1(0) = &HE9
        patch1(1) = &H13
        patch1(2) = &H61
        patch1(3) = &H1
        patch1(4) = &H0
        Put #impossibleFile, &H349DA + 1, patch1
            
        ' Write second continuous patch at 0x4AAF2
        Dim patch2(11) As Byte
        patch2(0) = &HD9
        patch2(1) = &HE1
        patch2(2) = &HDD
        patch2(3) = &H55
        patch2(4) = &HDC
        patch2(5) = &HD9
        patch2(6) = &HC0
        patch2(7) = &HE9
        patch2(8) = &HE1
        patch2(9) = &H9E
        patch2(10) = &HFE
        patch2(11) = &HFF
        Put #impossibleFile, &H4AAF2 + 1, patch2
            
        Close #impossibleFile
        MsgBox dlgImpossibleSelect.FileName & " patched!"
        Unload Me
    End If
    Exit Sub
    
CopyFail:
    MsgBox "Failed to make backup file! Patching cancelled."
    Exit Sub
PatchFail:
    MsgBox "Failed to patch file!"
    Exit Sub
End Sub

Private Sub btnNah_Click()
    Unload Me
End Sub
