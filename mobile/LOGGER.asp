
<%
				
	Public Sub printLog(message)
		'�αװ�� (�������丮�� �ݵ�� ������ �մϴ�.)
		Dim LOG_PATH : LOG_PATH = "C:\logs\mainpay-"	
		
		Dim fs, objFile
		Set fs = Server.CreateObject( "Scripting.FileSystemObject" )
		'Set objFile = fs.OpenTextFile( LOG_PATH & Date & ".log", 8, true, -2 )
		Set objFile = fs.OpenTextFile( LOG_PATH & Date & ".log", 8, true, -2 )
		objFile.writeLine("["&Now&"] "&message)
		objFile.close 
	End Sub		
	
%>
