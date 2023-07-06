<% @CODEPAGE="65001" language="VBScript" %>
<!--#include file="UTIL.asp"-->
<!--#include file="JSON2.asp"-->
<!--#include file="LOGGER.asp"-->

<%			
    Response.Expires = -1
    Response.AddHeader "Pragma", "No-Cache"
    Response.AddHeader "Cache-Control", "No-Store"
    Response.ContentType = "application/json"
	Response.CharSet = "UTF-8"

	'===============================================================================================
    ' CANCEL API 호출  (결제 취소 처리)    
    '===============================================================================================     
    
    ' API KEY (비밀키)  
    ' - 생성 : http://biz.mainpay.co.kr 고객지원>기술지원>암호화키관리
    ' - 가맹점번호(mbrNo) 생성시 함께 만들어지는 key (테스트 완료후 real 서비스용 발급필요) 
    Dim apiKey : apiKey =  "U1FVQVJFLTEwMDAxMTIwMTgwNDA2MDkyNTMyMTA1MjM0" 
	' <===테스트용 API_KEY입니다. 100011
	
    
    ' API 호출 URL
    ' ** 테스트 완료후 real 서비스용 URL로 변경 **  
    ' 리얼-URL : https://relay.mainpay.co.kr/v1/api/payments/payment/cancel
    ' 개발-URL : https://dev-relay.mainpay.co.kr/v1/api/payments/payment/cancel 
    Dim CANCEL_API_URL : CANCEL_API_URL = "https://dev-relay.mainpay.co.kr/v1/api/payments/payment/cancel"

	'=================================================================================================
	' 요청 파라미터 생성
	'=================================================================================================
	
	Dim params      'CANCEL API 호출 시 사용
	
	' 모듈 버전 정보
	params = params & "version=" & "1.0"
	' 가맹점 아이디(테스트 완료후 real 서비스용 발급필요)
	Dim mbrNo : mbrNo = "100011"
	params = params & "&mbrNo=" & mbrNo
	' 가맹점 주문번호 (가맹점 고유ID 대체가능) 6byte~20byte
	Dim mbrRefNo : mbrRefNo = MakeMbrRefNo(mbrNo)
	params = params & "&mbrRefNo=" & mbrRefNo     
	' 원거래번호 (결제완료시에 수신한 값)
	Dim orgRefNo : orgRefNo = "123456789012"
	params = params & "&orgRefNo=" & orgRefNo
	' 원거래일자(결제완료시에 수신한 값) YYMMDD
	Dim orgTranDate : orgTranDate = "180912"
	params = params & "&orgTranDate=" & orgTranDate
	' 지불수단 (CARD:신용카드|VACCT:가상계좌|ACCT:계좌이체|HPP:휴대폰소액)*
	Dim paymethod : paymethod = "CARD"
	params = params & "&paymethod=" & paymethod
	' 결제된금액
	Dim amount : amount = "500"
	params = params & "&amount=" & amount
	' 결제타입 ( 결제완로시에 받은 값)
	Dim payType : payType = "I"
	params = params & "&payType=" & payType
	' 망취소 유무(Y:망취소, N:일반취소) (주문번호를 이용한 망취소시에 사용)
	Dim isNetCancel : isNetCancel = "N"
	params = params & "&isNetCancel=" & isNetCancel
	'고객명 특수문자 사용금지, URL인코딩 필수 max 30byte
	Dim customerName : customerName = Server.URLEncode("고객명")
	params = params & "&customerName=" & customerName
	'고객이메일 이메일포멧 체크 필수 max 50byte
	Dim customerEmail : customerEmail = "hong@sample.com"
	params = params & "&customerEmail=" & customerEmail
	
	' timestamp max 20byte
	Dim timestamp : timestamp = MakeTimestamp()	
	params = params & "&timestamp=" & timestamp		
	params = params & "&signature=" & MakeSignature(mbrNo, mbrRefNo, amount, apiKey, timestamp) 
	
	'===============================================================================================
    'API 호출 
	Dim resultJson
	Dim errorMessage
	Dim httpRequest	
	
	'--------------------------------------------------------
	'서버 LOG 저장 (요청, 응답이력을 일자별로 관리)
	'LOGGER.asp 파일에 로그 경로를 지정 할 수 있습니다.
	'실제 존재하는 경로를 지정해야 합니다.
	printLog("[CANCEL_API] "&"[>REQUEST] ["&mbrRefNo&"]"&CANCEL_API_URL&" [params] : "&params)		

	'HTTPS POST Request Excute
	resultJson = HttpPostSend(CANCEL_API_URL, params)
	
	printLog("[CANCEL_API] "&"[<RESPONSE] ["&mbrRefNo&"]"&resultJson)
		
	Dim resultObj, resultCode, resultMessage
	Set resultObj = JSON.parse(join(array(resultJson)))				
	resultCode = resultObj.resultCode
	resultMessage = resultObj.resultMessage	
	
	IF resultCode = "200" THEN
		'CANCEL API 호출 성공
		'---------------------------------------------------
		'하단 Response.Write resultJson 참고하여 데이터 저장
	
	END IF	

	    
	'===============================================================================================
	'JSON TYPE RESPONSE
	Response.Write resultJson

%>	
	
	
	
	
	
	
	
	
	
	
	