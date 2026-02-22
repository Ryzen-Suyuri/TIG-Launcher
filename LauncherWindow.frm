VERSION 5.00
Begin VB.Form Form1 
   BackColor       =   &H00808000&
   BorderStyle     =   1  'Fixed Single
   Caption         =   "TIG-Launcher"
   ClientHeight    =   6120
   ClientLeft      =   6630
   ClientTop       =   2625
   ClientWidth     =   4320
   ForeColor       =   &H8000000B&
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   6120
   ScaleWidth      =   4320
   Begin VB.CommandButton Command4 
      Appearance      =   0  'Flat
      BackColor       =   &H00808000&
      Caption         =   "Get Crash Fix"
      BeginProperty Font 
         Name            =   "Akashi"
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
   Begin VB.CommandButton Command3 
      Appearance      =   0  'Flat
      BackColor       =   &H00808000&
      Caption         =   "Level BG Importer"
      BeginProperty Font 
         Name            =   "Akashi"
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
   Begin VB.CommandButton Command2 
      Appearance      =   0  'Flat
      BackColor       =   &H00808000&
      Caption         =   "Credits"
      BeginProperty Font 
         Name            =   "Akashi"
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
   Begin VB.CommandButton Command1 
      Appearance      =   0  'Flat
      BackColor       =   &H00808000&
      Caption         =   "Editor Tools"
      BeginProperty Font 
         Name            =   "Akashi"
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
   Begin VB.CheckBox Check1 
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
   Begin VB.CheckBox Check1 
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
   Begin VB.CheckBox Check1 
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
   Begin VB.CheckBox Check1 
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
   Begin VB.Label Label4 
      BackColor       =   &H00808000&
      Caption         =   "Track Total Attempts Per Level"
      BeginProperty Font 
         Name            =   "Akashi"
         Size            =   11.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   495
      Left            =   480
      TabIndex        =   7
      Top             =   4080
      Width           =   3735
   End
   Begin VB.Label Label3 
      BackColor       =   &H00808000&
      Caption         =   "Disable Death Effect"
      BeginProperty Font 
         Name            =   "Akashi"
         Size            =   11.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   495
      Left            =   480
      TabIndex        =   6
      Top             =   3360
      Width           =   2775
   End
   Begin VB.Label Label2 
      BackColor       =   &H00808000&
      Caption         =   "Noclip"
      BeginProperty Font 
         Name            =   "Akashi"
         Size            =   11.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   495
      Left            =   480
      TabIndex        =   5
      Top             =   2640
      Width           =   2775
   End
   Begin VB.Label Label1 
      BackColor       =   &H00808000&
      Caption         =   "Practice Mode Music"
      BeginProperty Font 
         Name            =   "Akashi"
         Size            =   11.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   495
      Left            =   480
      TabIndex        =   4
      Top             =   1920
      Width           =   2775
   End
   Begin VB.Image Image1 
      Height          =   1665
      Left            =   0
      Picture         =   "LauncherWindow.frx":0000
      Top             =   0
      Width           =   4500
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub Command1_Click()
Shell "C:\Users\Ryzen\Documents\TIG-Launcher\TIGUnusedInserter.exe", vbNormalFocus
End Sub

Private Sub Command2_Click()
Credits.Show
End Sub

Private Sub Command4_Click()
CrashFixGetWindow.Show
End Sub
