
Dim objFSO, objFile, ExtName, WshShell
Dim apppath, serviceib, strExtForms, strSource
const WaitUntilFinished = true, DontWaitUntilFinished = false, ShowWindow = 1, DontShowWindow = 0 


apppath = "C:\Program Files\1cv8\8.3.16.1814\bin\1cv8.exe"
serviceib = "/S srv-msk-test1c1/precommit"
strExtForms = "F:\Vissarov\git\repo"
strSource = "F:\Vissarov\git\repo\src"

Set objFSO = WScript.CreateObject("Scripting.FileSystemObject")
Set WshShell = WScript.CreateObject("WScript.Shell")

If objFSO.FolderExists(strExtForms) Then
If objFSO.FolderExists(strSource) Then

'Создаем объект папки файловой системы 
'и отправляем его в рекурсивную функцию
Set FSO = CreateObject("Scripting.FileSystemObject")
ParsingSubFolders FSO.GetFolder(strExtForms)
'Сигнализируем о завершении программы
WScript.Echo "Completed in " & strExtForms

end if
end if

'Функция рекурсивного обхода папок
sub ParsingSubFolders(Folder)
'Перебираем подпапки
  For Each Subfolder in Folder.SubFolders
'	В каждой подпапке Subfolder смотрим файлы и распоковывам
	For Each objFile In Subfolder.Files
		ExtName = objFSO.GetExtensionName(objFile)
		
		If ExtName = "epf" or ExtName = "erf" Then
			Subfoldersrc = Replace(Subfolder.Path , strExtForms, strSource)

			'создадим папки в src
			CreateFolderInSrc(Subfoldersrc)	

			' в vbs замена try catch , для переопределения ошибок. 
			' пока решено, что будем отображать стандартные ошибки
			' /Out E:\Temp\test\out1.txt"	
			On Error Resume Next

			StrParsing1C = """" & apppath & """" & " DESIGNER " & serviceib & " /DumpExternalDataProcessorOrReportToFiles """ & Subfoldersrc & """ """ & objFile.Path & """"
			WScript.Echo StrParsing1C
			ResultCode = WshShell.Run(StrParsing1C, DontShowWindow, WaitUntilFinished)
			
			If Err.Number <> 0 Then
				WScript.Echo "Error in starting 1c and parsing: " & Err.Number & vbLf & StrParsing1C
				Err.Clear
				WScript.Quit 1
			End If
			End If

	Next
	'Рекурсивно вызываем функцию для подпапок текущей папки
   ParsingSubFolders Subfolder
  Next
End Sub

'Процедура создадим папки в src если нет
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

Set objFSO = Nothing
WScript.Quit