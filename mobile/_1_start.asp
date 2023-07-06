<% @CODEPAGE="65001" language="VBScript" %>
<!--#include file="UTIL.asp"-->
<%
	Response.Expires = -1
    Response.AddHeader "Pragma", "No-Cache"
    Response.AddHeader "Cache-Control", "No-Store"	
	Response.CharSet = "UTF-8"

	
	Dim READY_API_URL 
	READY_API_URL = "_2_ready.asp"
%>

<!DOCTYPE html>
<html>
<head>
<META name="viewport" content="width=device-width, user-scalable=no">
<META http-equiv="Expires" content="-1"> 
<META http-equiv="Pragma" content="no-cache"> 
<META http-equiv="Cache-Control" content="No-Cache"> 
<script src="https://api-std.mainpay.co.kr/js/mainpay.mobile-1.0.js"></script>

<script type='text/javascript'> 
	var READY_API_URL = "<%=READY_API_URL%>";
	function payment() {		
		var request = mainpay_ready(READY_API_URL); 
		request.done(function(response) {
			if (response.resultCode == '200') {
				/* 결제창 호출 */
				location.href = response.data.nextMobileUrl; // *주의* PC와 Mobile은 URL이 상이합니다.
				return false;
			}
			alert("ERROR : "+JSON.stringify(response));			 				
		});		
	}
	window.onpopstate = function(){ history.go(-1)};
</script>  
</head>
<body>
	<p>Mobile 버전 샘플 주문페이지</p>
	<div>
		<!-- id 고정 -->
		<form id="MAINPAY_FORM">
			지불수단 <input type="text" name="paymethod" value="CARD"> <br>
			상품코드 <input type="text" name="goodsCode" value="GOOD0001"> <br> 
			상품명칭 <input type="text" name="goodsName" value="카약-슬라이더406"> <br><br>
		</form>
		<button type="button" class="btn_submit" onclick="payment()">결제요청</button>
	</div>
	<div>
	</div>
</body>
</html>

