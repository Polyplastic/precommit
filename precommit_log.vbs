' Precommit �����������
' https://polyplastic.teamlead.ru/browse/IS-417

' �����������
' 1. ��� ���� ��������� �������� ��������� � WshShell.Run
' 2. ���� �������������� ������ epf, erf (cfe �������� ����)
' 3. apppath   - ���� � exe 1c  
'	 serviceib - ���� � ���� ��� ���������� ������

'Option Explicit

Dim WshShell, apppath, serviceib, PathrepoGIT, PathSRC, FolderSrc, FileName, FullPathFile, FSO, File,TempFile,ResultCode,ParsingIsSuccess,DirFileName
const WaitUntilFinished = true, DontWaitUntilFinished = false, ShowWindow = 1, DontShowWindow = 0

apppath = "C:\Program Files\1cv8\8.3.16.1502\bin\1cv8.exe" ' ���� � ����������� ����� 1�
serviceib = "/S srv-msk-test1c1/precommit" ' ���� ������ ������ � ������ ��� ���������� ������ � ����������
ParsingIsSuccess = false

If WScript.Arguments.Count <> 1 Then
	WScript.echo "waiting only 1 parameters"
	WScript.Quit 1
End If

PathrepoGIT = WScript.Arguments(0)
PathrepoGIT = Replace(PathrepoGIT, "/", "\")

FolderSrc = "src"
PathSRC = PathrepoGIT & "\" & FolderSrc & "\"

Set WshShell = CreateObject("WScript.Shell")
TempFile = "C:\temp\logprecommit.tmp"

' ������� ���������
'Example: show only added , changed, modified files exclude deleted files:
WshShell.Run "cmd /C git diff-index --diff-filter=ACM --name-status --cached HEAD > " & TempFile , DontShowWindow, WaitUntilFinished

Dim objStream, strData, arraystr, Str, i
Set objStream = CreateObject("ADODB.Stream")
objStream.CharSet = "utf-8"
objStream.Open
objStream.LoadFromFile(TempFile)
strData = objStream.ReadText()
WScript.Echo strData

Set FSO = CreateObject("Scripting.FileSystemObject")

'��������� �� ������
arraystr = Split(strData, vbLf)
'���� �� �������
For i = 0 To UBound(arraystr) 
	Str = Rtrim(arraystr(i)) 
	if Right(Str,3) = "epf" or Right(Str,3) = "erf" then
		 ' or Right(Str,3) = "cfe" ����� �������� ����� ��������. ������� � ������
		FileName = Mid(Str,3)
		FileName = Replace(FileName, "/", "\")
		FileNameWithoutExt = Left(FileName,Len(FileName)-4)
		WScript.Echo FileNameWithoutExt

		DirFileName = ""
		if InStrRev(FileNameWithoutExt,"\") > 1 Then
			DirFileName = Left(FileNameWithoutExt,InStrRev(FileNameWithoutExt,"\")-1)
		end if
		
		WScript.Echo DirFileName
		' �������� ����� � src ���� ���
		localsrcDir = PathSRC & DirFileName
		Call CreateFolderInSrc(localsrcDir)
	
		FullPathFile = PathrepoGIT & "\" & FileName
		
		' � vbs ������ try catch , ��� ��������������� ������. 
		' ���� ������, ��� ����� ���������� ����������� ������
		On Error Resume Next

		' ���� ����� ������� ��� �������� �� 1� ��������� """ /Out C:\Temp\out1.txt"
		StrParsing1C = """" & apppath & """" & " DESIGNER " & serviceib & " /DumpExternalDataProcessorOrReportToFiles """ & localsrcDir & """ """ & FullPathFile & """" & " /Out C:\Temp\out1.txt"	
		WScript.Echo StrParsing1C
		ResultCode = WshShell.Run(StrParsing1C, DontShowWindow, WaitUntilFinished)

		If Err.Number <> 0 Then
			WScript.Echo "Error in starting 1c and parsing: " & Err.Number & vbLf & StrParsing1C
			Err.Clear
			WScript.Quit 1
		End If

		' xml ���� � �����. �������� ���� �������� ����������.
		' �� �� ���� ��� ���������� ����� ���������� �� ���� ������, �� ���������� ������� ���������� ����� � ����. 
		if ResultCode=0 Then ' ���� ���������� �������� ����� �������. ������ ����� ���� ������ ��� ���� �� ����� ������ "�������� ���������"
           'WshShell.Run "cmd /C git add --all """ & FolderSrc & FileNameWithoutExt & ".xml""", DontShowWindow, WaitUntilFinished
		   'WshShell.Run "cmd /C git add --all ""./"   & FolderSrc & """", DontShowWindow, WaitUntilFinished   
		   ParsingIsSuccess = true
		else 
			WScript.Echo "Parsing 1c - error code: " & ResultCode
			WScript.Quit 1		
        end if 
	end if
Next

' ������ ����� ��������� ����� src
if ParsingIsSuccess=True Then
	WScript.Echo "ParsingIsSuccess: " & ParsingIsSuccess
	WshShell.Run "cmd /C git add --all ""./" & FolderSrc & """" & " > " & TempFile, DontShowWindow, WaitUntilFinished 
	WScript.Echo "cmd /C git add --all ""./" & FolderSrc & """" & " > " & TempFile
	
	objStream.CharSet = "utf-8"
	objStream.Open
	objStream.LoadFromFile(TempFile)
	strData = objStream.ReadText()
	WScript.Echo strData
end if

Set objStream = nothing
Set WshShell = nothing

'��������� �������� ����� � src ���� ���
Sub CreateFolderInSrc(localsrcDir) 
	srcDirTree = Split(localsrcDir, "\")
	For k = 0 To UBound(srcDirTree)
		If srcDirTree(k) <> "" Then
			srcDirNext = srcDirNext & srcDirTree(k) & "\"
			If Not FSO.FolderExists(srcDirNext) Then
				FSO.CreateFolder(srcDirNext)
			End If
		End If
	Next
End sub


' � vbs ������ try catch , ��� ��������������� ������. 
' ���� ������, ��� ����� ���������� ����������� ������
'On Error Resume Next

' If Err.Number <> 0 Then
' 	WScript.Echo "Error " & Err.Description
' 	Err.Clear
' 	WScript.Quit 1
' End If