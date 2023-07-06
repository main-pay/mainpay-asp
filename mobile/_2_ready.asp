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
     ' READY API 호출  (결제창 호출 전처리)    
     '===============================================================================================     
    
    '  API KEY (비밀키)  
    ' - 생성 : http://biz.mainpay.co.kr 고객지원>기술지원>암호화키관리
    ' - 가맹점번호(mbrNo) 생성시 함께 만들어지는 key (테스트 완료후 real 서비스용 발급필요) 
    Dim apiKey : apiKey =  "U1FVQVJFLTEwMDAxMTIwMTgwNDA2MDkyNTMyMTA1MjM0" 
	' <===테스트용 API_KEY입니다. 100011
	
      
     ' API 호출 URL 
     ' ** 테스트 완료후 real 서비스용 URL로 변경 **  
     ' 리얼-URL : https://api-std.mainpay.co.kr 
     ' 개발-URL : https://test-api-std.mainpay.co.kr     
     Dim API_BASE : API_BASE = "https://test-api-std.mainpay.co.kr"

	'===============================================================================================
    '	요청 파라미터 생성 (매뉴얼 참조)
    '===============================================================================================
		
	Dim params      'ready api 호출시에 사용
	Dim readyParams 'session에 저장해 승인시에 사용
	
	' 모듈 버전 정보
	params = params & "version=" & "1.0"
	' 가맹점 아이디(테스트 완료후 real 서비스용 발급필요)
	Dim mbrNo : mbrNo = "100011" 
	params = params & "&mbrNo=" & mbrNo
	' 가맹점 주문번호 (가맹점 고유ID 대체가능) 6byte~20byte
	'Dim mbrRefNo : mbrRefNo = MakeMbrRefNo(mbrNo)	
	Dim mbrRefNo : mbrRefNo = "P000114131"	
	params = params & "&mbrRefNo=" & mbrRefNo                      
	' 지불수단 (CARD:신용카드 | VACCT:가상계좌 채번| ACCT:계좌이체 | HPP:휴대폰소액)
	params = params & "&paymethod=" & request.Form("paymethod")	
	'결제금액 (공급가+부가세)
 	'(## 주의 ##) 페이지에서 전달 받은 값을 그대로 사용할 경우 금액위변조 시도가 가능합니다.
 	'DB에서 조회한 값을 사용 바랍니다. 
	Dim amount : amount = "1004"	
	params = params & "&amount=" & amount	
	'상품명, 특수문자 사용금지, URL인코딩필수 max 30byte
	params = params & "&goodsName=" & Server.URLEncode(request.Form("goodsName")) 'max 30byte
	params = params & "&goodsCode=" & request.Form("goodsCode") 'max 8byte
	'인증결과 수신 및 승인 URL (PG-->상점)
	params = params & "&approvalUrl=" & "https://상점도메인/mobile/_3_approval.asp" '필수변경
	'종료요청 URL (PG-->상점)
	params = params & "&closeUrl=" & "https://상점도메인/mobile/_3_close.asp"  '필수변경
	'고객명 특수문자 사용금지, URL인코딩 필수 max 30byte
	params = params & "&customerName=" & Server.URLEncode("고객명")
	'고객이메일 이메일포멧 체크 필수 max 50byte
	params = params & "&customerEmail=" & "hong@sample.com"
	
	'---------------------------------------------------------
	'요청정보 DB에 저장 (params, apiKey, aid, API_BASE, amount 등)
	'브라우저 cross-domain session, cookie 정책 강화로 session 사용 지양
	'PG로부터 인증결과 수신후 결제승인 요청시에 필요	
	'---------------------------------------------------------
	
	' timestamp max 20byte
	Dim timestamp : timestamp = MakeTimestamp()	
	params = params & "&timestamp=" & timestamp		
	params = params & "&signature=" & MakeSignature(mbrNo, mbrRefNo, amount, apiKey, timestamp) 	

	'===============================================================================================
    'API 호출 
	Dim READY_API_URL : READY_API_URL = API_BASE & "/v1/payment/ready"
	Dim resultJson
	Dim errorMessage
	Dim httpRequest	
	
	'--------------------------------------------------------
	'서버 LOG 저장 (요청, 응답이력을 일자별로 관리)
	'LOGGER.asp 파일에 로그 경로를 지정 할 수 있습니다.
	'실제 존재하는 경로를 지정해야 합니다.
	printLog("[READY_API] "&"[>REQUEST] ["&mbrRefNo&"]"&READY_API_URL&" [params] : "&params)		

	'HTTPS POST Request Excute
	resultJson = HttpPostSend(READY_API_URL, params)
	
	printLog("[READY_API] "&"[<RESPONSE] ["&mbrRefNo&"]"&resultJson)
		
	Dim resultObj, resultCode, resultMessage, aid
	Set resultObj = JSON.parse(join(array(resultJson)))				
	resultCode = resultObj.resultCode
	resultMessage = resultObj.resultMessage	
	
	IF resultCode = "200" THEN
		'READY 호출 성공
		'---------------------------------------------------
		aid  = resultObj.data.aid	
	}
	END IF	

	    
	'===============================================================================================
	'JSON TYPE RESPONSE
	Response.Write resultJson
%>    
