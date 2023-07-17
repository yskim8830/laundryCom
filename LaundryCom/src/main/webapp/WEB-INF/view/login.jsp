<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<meta charset="UTF-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge" />
	<title>Laundry</title>
	
	<link rel="stylesheet" type="text/css" href="${CTX_PATH}/js/elegant-admin/css/pages/login-register-lock.css"/>
	<jsp:include page="/WEB-INF/view/common/common_include.jsp"></jsp:include>
	<script type="text/javascript">
	
		/* OnLoad Event */
		$(function() {
			// 쿠키값을 가져온다.
			var cookie_user_id = getCookie('EMP_ID');
			if(cookie_user_id != "") {
				$("#EMP_ID").val(cookie_user_id);
				$("#cb_saveId").attr("checked", true);
			}
			$("#EMP_ID").focus();
			// 버튼 이벤트 등록
			fRegisterButtonClickEvent();
			
		});
	
		/** 버튼 이벤트 등록 */
		function fRegisterButtonClickEvent() {
			
		}
		/* 로그인 validation */
		function fValidateLogin() {
	
			var chk = checkNotEmpty(
					[
						[ "EMP_ID", "아이디를 입력해 주세요." ],
						[ "EMP_PWD", "비밀번호를 입력해 주세요." ] 
					]
			);
	
			if (!chk) {
				return;
			}
	
			return true;
		}
		
		/* 로그인 */
		function fLoginProc() {
			if($("#cb_saveId").is(":checked")){ // 저장 체크시
				saveCookie('EMP_ID',$("#EMP_ID").val(),7);
			}else{ // 체크 해제시는 공백
				saveCookie('EMP_ID',"",7);
			}
			
			// vaildation 체크
			if ( ! fValidateLogin() ) {
				return;
			}
			
			var resultCallback = function(data) {
				fLoginProcResult(data);
			};
			
			callAjax("/loginProc.do", "post", "json", true, $("#myForm").serialize(), resultCallback);
		}
		
		/* 로그인 결과 */
		function fLoginProcResult(data) {
			
			if (data.result == "SUCCESS") {
				location.href = "${CTX_PATH}/release/release.do"; 
			} else {
				
				$("<div style='text-align:center;'>" + data.resultMsg + "</div>").dialog({
					modal : true,
					resizable : false,
					buttons : [ {
						text : "확인",
						click : function() {
							$(this).dialog("close");
							$("#EMP_ID").val("");
							$("#EMP_PWD").val("");
							$("#EMP_ID").focus();
						}
					} ]
				});
				$(".ui-dialog-titlebar").hide();
			}		
		}
	</script>
	</head>
	<body class="skin-default card-no-border">
	    <!-- ============================================================== -->
	    <!-- Preloader - style you can find in spinners.css -->
	    <!-- ============================================================== -->
	    <div class="preloader">
	        <div class="loader">
	            <div class="loader__figure"></div>
	            <p class="loader__label">Laundry</p>
	        </div>
	    </div>
	    <!-- ============================================================== -->
	    <!-- Main wrapper - style you can find in pages.scss -->
	    <!-- ============================================================== -->
	    <section id="wrapper">
	        <div class="login-register" style="background-image:url(${CTX_PATH}/js/assets/images/background/login-register.jpg);">
	            <div class="login-box card">
	                <div class="card-body">
	                    <form class="form-horizontal form-material" id="myForm" action=""  method="post" onSubmit="return false;">
	                        <h3 class="box-title m-b-20">로그인</h3>
	                        <div class="form-group ">
	                            <div class="col-xs-12">
	                                <input class="form-control" type="text" id="EMP_ID" name="id" value="admin" required="" placeholder="ID" onkeypress="if(event.keyCode==13) {fLoginProc(); return false;}"> </div>
	                        </div>
	                        <div class="form-group">
	                            <div class="col-xs-12">
	                                <input class="form-control" type="password" id="EMP_PWD" name="pwd" value="admin" required="" placeholder="Password" onkeypress="if(event.keyCode==13) {fLoginProc(); return false;}"> </div>
	                        </div>
	                        <div class="form-group row">
	                            <div class="col-md-12">
	                                <div class="custom-control custom-checkbox">
	                                    <input type="checkbox" id="cb_saveId" class="custom-control-input" onkeypress="if(event.keyCode==13) {fLoginProc(); return false;}">
	                                    <label class="custom-control-label" for="cb_saveId">Remember me</label>
	                                </div>
	                            </div>
	                        </div>
	                        <div class="form-group text-center">
	                            <div class="col-xs-12 p-b-20">
	                                <button class="btn btn-block btn-lg btn-info btn-rounded" onClick="javascript:fLoginProc();" id="btn_login">Log In</button>
	                            </div>
	                        </div>
	                    </form>
	                </div>
	            </div>
	        </div>
	    </section>
	    <!-- ============================================================== -->
	    <!-- End Wrapper -->
	    <!-- ============================================================== -->
	</body>
</html>