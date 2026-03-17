VERSION 5.00
Begin VB.Form LauncherWindow 
   BackColor       =   &H00808000&
   BorderStyle     =   1  'Fixed Single
   Caption         =   "TIG-Launcher"
   ClientHeight    =   6120
   ClientLeft      =   6630
   ClientTop       =   2625
   ClientWidth     =   4320
   ForeColor       =   &H8000000B&
   Icon            =   "LauncherWindow.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   6120
   ScaleWidth      =   4320
   Begin VB.CommandButton btnCrashFix 
      Appearance      =   0  'Flat
      BackColor       =   &H00808000&
      Caption         =   "Get Crash Fix"
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   855
      Left            =   3240
      MaskColor       =   &H00808000&
      Style           =   1  'Graphical
      TabIndex        =   11
      Top             =   5280
      Width           =   1095
   End
   Begin VB.CommandButton btnImport 
      Appearance      =   0  'Flat
      BackColor       =   &H00808000&
      Caption         =   "Level BG Importer"
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   855
      Left            =   2160
      MaskColor       =   &H00808000&
      Style           =   1  'Graphical
      TabIndex        =   10
      Top             =   5280
      Width           =   1095
   End
   Begin VB.CommandButton btnCredits 
      Appearance      =   0  'Flat
      BackColor       =   &H00808000&
      Caption         =   "Credits"
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   855
      Left            =   1080
      MaskColor       =   &H00808000&
      Style           =   1  'Graphical
      TabIndex        =   9
      Top             =   5280
      Width           =   1095
   End
   Begin VB.CommandButton btnTools 
      Appearance      =   0  'Flat
      BackColor       =   &H00808000&
      Caption         =   "Editor Tools"
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   855
      Left            =   0
      MaskColor       =   &H00808000&
      Style           =   1  'Graphical
      TabIndex        =   8
      Top             =   5280
      Width           =   1095
   End
   Begin VB.CheckBox chkAttempts 
      BackColor       =   &H00808000&
      Caption         =   "Check1"
      Height          =   255
      Index           =   3
      Left            =   120
      MaskColor       =   &H00FFFFFF&
      TabIndex        =   3
      Top             =   4080
      Width           =   255
   End
   Begin VB.CheckBox chkDeath 
      BackColor       =   &H00808000&
      Caption         =   "Check1"
      Height          =   255
      Index           =   2
      Left            =   120
      MaskColor       =   &H00FFFFFF&
      TabIndex        =   2
      Top             =   3360
      Width           =   255
   End
   Begin VB.CheckBox chkNoclip 
      BackColor       =   &H00808000&
      Caption         =   "Check1"
      Height          =   255
      Index           =   1
      Left            =   120
      MaskColor       =   &H00FFFFFF&
      TabIndex        =   1
      Top             =   2640
      Width           =   255
   End
   Begin VB.CheckBox chkPractice 
      BackColor       =   &H00808000&
      Caption         =   "Check1"
      Height          =   255
      Index           =   0
      Left            =   120
      MaskColor       =   &H00FFFFFF&
      TabIndex        =   0
      Top             =   1920
      Width           =   255
   End
   Begin VB.Label lblAttempts 
      BackColor       =   &H00808000&
      Caption         =   "Track Total Attempts Per Level"
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   11.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00FFFFC0&
      Height          =   495
      Left            =   480
      TabIndex        =   7
      Top             =   4080
      Width           =   3735
   End
   Begin VB.Label lblDeath 
      BackColor       =   &H00808000&
      Caption         =   "Disable Death Effect"
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   11.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00FFFFC0&
      Height          =   495
      Left            =   480
      TabIndex        =   6
      Top             =   3360
      Width           =   2775
   End
   Begin VB.Label lblNoclip 
      BackColor       =   &H00808000&
      Caption         =   "Noclip"
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   11.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00FFFFC0&
      Height          =   495
      Left            =   480
      TabIndex        =   5
      Top             =   2640
      Width           =   2775
   End
   Begin VB.Label lblPractice 
      BackColor       =   &H00808000&
      Caption         =   "Practice Mode Music"
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   11.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00FFFFC0&
      Height          =   495
      Left            =   480
      TabIndex        =   4
      Top             =   1920
      Width           =   2775
   End
   Begin VB.Image imgBanner 
      Height          =   1665
      Left            =   0
      Picture         =   "LauncherWindow.frx":7098
      Top             =   0
      Width           =   4500
   End
End
Attribute VB_Name = "LauncherWindow"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub chkNoclip_Click(Index As Integer)
    Dim patchBytes(0) As Byte
    If chkNoclip(1).Value = vbChecked Then
        patchBytes(0) = &HEB
        ' Patch
        PatchMemory "ImpossibleGame.exe", &H33891, patchBytes
    Else
        patchBytes(0) = &H74
        ' Revert patch
        PatchMemory "ImpossibleGame.exe", &H33891, patchBytes
    End If
End Sub

Private Sub btnTools_Click()
    Dim relative_path As String
    relative_path = App.Path & "\TIGUnusedInserter.exe"
    Shell relative_path, vbNormalFocus
End Sub

Private Sub btnCredits_Click()
    Credits.Show
End Sub

Private Sub btnCrashFix_Click()
    CrashFixGetWindow.Show
End Sub
