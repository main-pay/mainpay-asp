
<%
				
	Public Sub printLog(message)
		'로그경로 (하위디렉토리를 반드시 만들어야 합니다.)
		Dim LOG_PATH : LOG_PATH = "C:\logs\mainpay-"	
		
		Dim fs, objFile
		Set fs = Server.CreateObject( "Scripting.FileSystemObject" )
		'Set objFile = fs.OpenTextFile( LOG_PATH & Date & ".log", 8, true, -2 )
		Set objFile = fs.OpenTextFile( LOG_PATH & Date & ".log", 8, true, -2 )
		objFile.writeLine("["&Now&"] "&message)
		objFile.close 
	End Sub		
	
%>
