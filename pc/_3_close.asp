<% @CODEPAGE="65001" language="VBScript" %>
<%
		Response.Expires = -1
    Response.AddHeader "Pragma", "No-Cache"
    Response.AddHeader "Cache-Control", "No-Store"	
		Response.CharSet = "UTF-8"
	'********************************************************************************	
	'  결제창 종료시에 PG사에서 호출하는 페이지 입니다.
	'  상점에서 필요한 로직 추가	
	'********************************************************************************/
%>
<!DOCTYPE html>
<html>
<head>
<META http-equiv="Expires" content="-1"> 
<META http-equiv="Pragma" content="no-cache"> 
<META http-equiv="Cache-Control" content="No-Cache"> 
</head>
<body>
종료페이지
</body>
</html>