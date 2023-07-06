<% @CODEPAGE="65001" language="VBScript" %>
<!--#include file="UTIL.asp"-->
<!--#include file="JSON2.asp"-->
<!--#include file="LOGGER.asp"-->

<%		
    Response.Expires = -1
    Response.AddHeader "Pragma", "No-Cache"
    Response.AddHeader "Cache-Control", "No-Store"
	Response.CharSet = "UTF-8"
	
    '===============================================================================================
	' 구매자 인증이 완료될 경우 PG사에서 호출하는 페이지 입니다. 	     
	' PG로 부터 전달 받은 인증값을 받아 다시 PG로 승인요청을 합니다.	
	'===============================================================================================
	 
	Dim aid, authToken, merchantData
	aid = Request.QueryString("aid")
	authToken = Request.QueryString("authToken")
	merchantData = Request.QueryString("merchantData")
	payType = Request.QueryString("payType")

	printLog("[ApprovalUrl][receive] "&" aid:"&aid&" authToken:"&authToken&" merchantData:"&merchantData)
	
	'===============================================================================================
	' reay에서 DB에 저장한 요청정보 값 조회해서 사용하세요.
	'===============================================================================================
	Dim apiKey : apiKey =  "U1FVQVJFLTEwMDAxMTIwMTgwNDA2MDkyNTMyMTA1MjM0"
	Dim API_BASE : API_BASE = "https://test-api-std.mainpay.co.kr"
	
	Dim params      
	params = params & "version=" & "V001"
	Dim mbrNo : mbrNo = "100011" 
	params = params & "&mbrNo=" & mbrNo
	'Dim mbrRefNo : mbrRefNo = MakeMbrRefNo(mbrNo)	
	Dim mbrRefNo : mbrRefNo = "P000115001"	
	params = params & "&mbrRefNo=" & mbrRefNo                      
	params = params & "&paymethod=" & "CARD"	
	Dim amount : amount = "1004"	
	params = params & "&amount=" & amount	
	params = params & "&goodsName=" & Server.URLEncode("카약-슬라이더406")
	params = params & "&goodsCode=" & "GOOD0001"
	params = params & "&approvalUrl=" & "https://상점도메인/pc/_3_approval.asp"
	params = params & "&closeUrl=" & "https://상점도메인/pc/_3_close.asp"
	params = params & "&customerName=" & Server.URLEncode("고객명")
	params = params & "&customerEmail=" & "test@spc.co.kr"
	Dim timestamp : timestamp = MakeTimestamp()	
	params = params & "&timestamp=" & timestamp		
	params = params & "&signature=" & MakeSignature(mbrNo, mbrRefNo, amount, apiKey, timestamp) 
	
	'===============================================================================================
	'승인요청 파라미터 생성
	'ready에서 생성한 요청 파라미터에 인증 데이터 및 검증용 파라미터 추가
	params = params&"&aid="&aid
	params = params&"&authToken="&authToken
	params = params&"&payType="&payType

	''===============================================================================================
	'' *** PG서버로 승인 PAY_API호출 
	''=============================================================================================== 	
	Dim PAY_API_URL : PAY_API_URL = API_BASE & "/v1/payment/pay"
	Dim resultJson
	
	printLog("[PAY_API] "&"[>REQUEST] ["&mbrRefNo&"] "&PAY_API_URL&" [params] : "&params)		

	'HTTPS POST Request Excute
	resultJson = HttpPostSend(PAY_API_URL, params)
	
	printLog("[PAY_API] "&"[<RESPONSE] ["&mbrRefNo&"] "&resultJson)
		
	Dim resultObj, resultCode, resultMessage
	Set resultObj = JSON.parse(join(array(resultJson)))				
	resultCode = resultObj.resultCode
	resultMessage = resultObj.resultMessage	
	
	IF resultCode = "200" THEN
		'API_API 호출 성공 (응답 파라미터 매뉴얼 참조)
		'---------------------------------------------------
		refNo  = resultObj.data.refNo	
		tranDate  = resultObj.data.tranDate
		mbrRefNo  = resultObj.data.mbrRefNo		
		applNo  = resultObj.data.applNo
		payType  = resultObj.data.payType
	}
	END IF	
		
	'결제결과 화면 표시
	Response.Write "[PAY_API 호출결과] <br>"&resultJson
%>
<!DOCTYPE html>
<html>
<head>
<META http-equiv="Expires" content="-1"> 
<META http-equiv="Pragma" content="no-cache"> 
<META http-equiv="Cache-Control" content="No-Cache"> 
</head>
<body>
<script>
/* 결제 완료 페이지 처리 */
var resultCode = "<%=resultCode %>";
var resultMessage = "<%=resultMessage %>";
alert("resultCode = " + resultCode + ", resultMessage = " + resultMessage);

/* 현재 팝업 닫기*/
//Mainpay.close(true);
</script>
</body>
</html>