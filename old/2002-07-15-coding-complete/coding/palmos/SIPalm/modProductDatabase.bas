Attribute VB_Name = "modProductDatabase"
'---------------------------------------------------------------
'     AppForge PDB Converter auto-generated code module
'
'     Source Database: D:\coding\SimpleInvoice\SInvoice.mdb
'     Source Table   : ProductPDA
'
'     Num Records    : 5
'
'     PDB Table Name : Product
'          CreatorID : ELF2
'          TypeID    : DATA
'
'     Converted Time : 16/01/2002 01:08:17 PM
'
'---------------------------------------------------------------

Option Explicit

' Use these constants for the CreatorID and TypeID
Public Const Product_CreatorID As Long = &H454C4632
Public Const Product_TypeID As Long = &H44415441

' Use this global to store the database handle
Public dbProduct As Long

' Use this enumeration to get access to the converted database Fields
Public Enum tProductDatabaseFields
        UID_Field = 0
        Name_Field = 1
        Description_Field = 2
        NetCost_Field = 3
        VATPercent_Field = 4
End Enum

Public Type tProductRecord
        UID As Long
        Name As String
        Description As String
        NetCost As Long 'Default Net Cost
        VATPercent As Long      'Default VAT Cost
End Type


Public Function OpenProductDatabase() As Boolean

        ' Open the database
        #If APPFORGE Then
        dbProduct = PDBOpen(Byfilename, "Product", 0, 0, 0, 0, afModeReadWrite + afModeAsciiStrings)
        #Else
        dbProduct = PDBOpen(Byfilename, App.Path & "\Product", 0, 0, 0, 0, afModeReadWrite)
        #End If

        If dbProduct <> 0 Then
                'We successfully opened the database
                OpenProductDatabase = True

        Else
                'We failed to open the database
                OpenProductDatabase = False
                #If APPFORGE Then
                MsgBox "Could not open database - Product", vbExclamation
                #Else
                MsgBox "Could not open database - " + App.Path + "\Product.pdb" + vbCrLf + vbCrLf + "Potential causes are:" + vbCrLf + "1. Database file does not exist" + vbCrLf + "2. The database path in the PDBOpen call is incorrect", vbExclamation
                #End If
        End If

End Function


Public Sub CloseProductDatabase()

        ' Close the database
        PDBClose dbProduct
        dbProduct = 0

End Sub


Public Function ReadProductRecord(MyRecord As tProductRecord) As Boolean

        ReadProductRecord = PDBReadRecord(dbProduct, VarPtr(MyRecord))

End Function


Public Function WriteProductRecord(MyRecord As tProductRecord) As Boolean

        WriteProductRecord = PDBWriteRecord(dbProduct, VarPtr(MyRecord))

End Function
