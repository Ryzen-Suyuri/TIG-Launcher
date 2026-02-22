VERSION 5.00
Begin VB.Form CrashFixGetWindow 
   BackColor       =   &H00808000&
   BorderStyle     =   1  'Fixed Single
   Caption         =   "GetCrashFix"
   ClientHeight    =   2475
   ClientLeft      =   6255
   ClientTop       =   3585
   ClientWidth     =   4560
   LinkTopic       =   "Form2"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   2475
   ScaleWidth      =   4560
   Begin VB.CommandButton Command2 
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
   Begin VB.CommandButton Command1 
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
   Begin VB.Label Label2 
      BackStyle       =   0  'Transparent
      Caption         =   "No"
      Height          =   255
      Left            =   3000
      TabIndex        =   3
      Top             =   1800
      Width           =   735
   End
   Begin VB.Label Label1 
      BackColor       =   &H00808000&
      Caption         =   $"CrashFixGetWindow.frx":0000
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
Private Sub Command2_Click()
CrashFixGetWindow.Hide
End Sub
