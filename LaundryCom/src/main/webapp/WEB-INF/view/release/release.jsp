<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html lang="ko" >
<head>
	<meta charset="UTF-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge" />
	<title>Laundry admin</title>
	<jsp:include page="/WEB-INF/view/common/common_include.jsp"></jsp:include>
	<%@include file="release.hbs" %>
	<script type="text/javascript">
	var init = false;
	/** OnLoad event */ 
	$(function() {
		// 조회
// 		fShowCust();
		// 셀렉트 이벤트 등록
		fRegisterOnchangeEvent();
		$('input[name="tel_3"]').focus();
	});
	/** change 이벤트 등록 */
	function fRegisterOnchangeEvent() {
		$('.mydatepicker, #datepicker').datepicker({
			format: 'yyyy/mm/dd',
			autoclose: true,
			todayHighlight: true,
			language: "kr"
		}).datepicker("setDate",'now');


		$("#relDateBtn").on('click',function(){
			$('input[name="relDate"]').datepicker('show');
		});
		
		$("#custForm input").keydown(function(e){
			if(e.keyCode == 13){
				fShowCust();
				e.preventDefault();
			}
		});
		
		$("#checkRel").on('click',function(){
			if($('#custForm input[name="id"]').val() != ''){
				fGetStockById($('#custForm input[name="id"]').val());				
			}
		});
	}
	/** 고객 조회 */
	function fShowCust() {
		
		var param = $( "#custForm input").filter(function () {
	        return !!this.value;
	    }).serialize();

	    if(param == ""){
	    	swal({
			    title: "검색어를 입력해주세요.",
			    type: "warning",
			 },
			function(){
				return false;
			});
		}else{
			var resultCallback = function(data) {
				//console.log(data.listModel);
				$("#data-form").empty();
				var html = Handlebars.compile($("#data-form-template").html())({
					listModel: data.listModel,
				});
				$("#data-form").html(html);
				//console.log("successs!");
			};
			
			callAjax("/customer/custList.do", "post", "json", true, param, resultCallback);
		}
	}
	/** 고객 선택 */
	function fGetCust(id) {
		
		var param = {id : id};
		
		var resultCallback = function(data) {
			//console.log(data.listModel);
			$('#custForm input[name="id"]').val(data.listModel[0].id);
			$('#custForm input[name="tel_1"]').val(data.listModel[0].tel_1);
			$('#custForm input[name="tel_2"]').val(data.listModel[0].tel_2);
			$('#custForm input[name="tel_3"]').val(data.listModel[0].tel_3);
			$('#custForm input[name="addr"]').val(data.listModel[0].addr);
			$('#custForm input[name="name"]').val(data.listModel[0].name);
			//console.log("successs!");
			fGetStockById(id); //입고내역 조회
		};
		
		callAjax("/customer/custList.do", "post", "json", true, param, resultCallback);
	}
	/** 고객 저장 */
	function fSetCust() { 

		if($('#custForm input[name="id"]').val() !=""){
			$('#custForm input[name="oper"]').val("edit");
		}else{
			$('#custForm input[name="oper"]').val("add");
		}
		
		var param = $( "#custForm input").filter(function () {
		        return !!this.value;
		    }).serialize();
		
		var resultCallback = function(data) {
			if (data.result == "SUCCESS") {
				swal({
				    title: data.resultMsg,
				    type: "success",
				 });
				fInit();
			}else{
				swal('Warning',data.resultMsg);
			}
			//console.log("successs!");
		};
		
		callAjax("/customer/setCust.do", "post", "json", true, param, resultCallback);
	}

	function fInit() {
		$('#custForm input[name="id"]').val("");
		$('#custForm input[name="tel_1"]').val("");
		$('#custForm input[name="tel_2"]').val("");
		$('#custForm input[name="tel_3"]').val("");
		$('#custForm input[name="addr"]').val("");
		$('#custForm input[name="name"]').val("");
		$('input[name="tel_3"]').focus();
		
		$('#stock-table').bootstrapTable('removeAll');
	}

	function fGetStockById(id){
		
		var is_release = "N";
		
		if($("#checkRel").is(":checked")){
			is_release = "";
		}else{
			is_release = "N";
		}
		
		var param = {cust_id : id
				, is_release : is_release};
		
		var resultCallback = function(data) {
			 $("#stock-table").bootstrapTable({
                 data: data.listModel
             });
			 $('#stock-table').bootstrapTable('load', data.listModel);
		};
		
		callAjax("/release/stockList.do", "post", "json", true, param, resultCallback);
	}

	function fSetRelease(){
		//sweet alert confirm
		swal({
		    title: "선택한 품목을 출고 하시겠습니까?",
		    type: "warning",
		    showCancelButton: true,
		    confirmButtonColor: '#DD6B55',
		    closeOnConfirm: false
		 },
		 function(isConfirm){
			if (!isConfirm){
				return;		
		    }
			swal({
			    title: "카드로 출고할까요?",
			    type: "warning",
			    showCancelButton: true,
			    confirmButtonColor: '#DD6B55',
			    closeOnConfirm: false
			 },
			 function(isConfirm){
				var isCardC = 'C';
				if (!isConfirm){
					isCardC = 'P';
			    }
				var resultCallback = function(data) {
					if (data.result == "SUCCESS") {
						swal({
						    title: data.resultMsg,
						    type: "success",
						 },
						function(){
							//location.href = "/release/release.do";
							fGetStockById($('#custForm input[name="id"]').val());
						});
					}else{
						swal('Warning',data.resultMsg);
					}

					fGetStockById($('#custForm input[name="id"]').val());
					//console.log("successs!");
				};
				
				$('#stock-table tbody tr').each(function(index,value){
					if($(this).hasClass("selected") == true){
						var param = {seq : $(this).attr('data_id')
								, card : isCardC};
						callAjax("/release/setRelStock.do", "post", "json", true, param, resultCallback);
					}
				});
			});
			//data.push(sltData);
			//console.log(sltData);
		});
	}
	function rowAttr(row,index){
		return {data_id : row.seq};
	}
	function formatterComma(value, row, index, field) {
		return comma(value);
	}
	function formatterPayment(value, row, index, field) {
		return value === 'P' ? '선불' : '후불';
	}
	function formatterCard(value, row, index, field) {
		return value === 'P' ? '현금' : '카드';
	}
	function formatterDelivery(value, row, index, field) {
		return value === 'S' ? '방문' : '배달';
	}
	</script>
</head>

<body class="skin-default-dark fix-header single-column card-no-border fix-sidebar">
    <!-- ============================================================== -->
    <!-- Preloader - style you can find in spinners.css -->
    <!-- ============================================================== -->
    <div class="preloader">
        <div class="loader">
            <div class="loader__figure"></div>
            <p class="loader__label">Laundry admin</p>
        </div>
    </div>
    <!-- ============================================================== -->
    <!-- Main wrapper - style you can find in pages.scss -->
    <!-- ============================================================== -->
    <div id="main-wrapper">
        <!-- ============================================================== -->
        <!-- Page wrapper  -->
        <!-- ============================================================== -->
        <div class="page-wrapper">
            <!-- ============================================================== -->
            <!-- Container fluid  -->
            <!-- ============================================================== -->
            <div class="container-fluid">
                <!-- ============================================================== -->
                <!-- Bread crumb and right sidebar toggle -->
                <!-- ============================================================== -->
                <div class="row">
                    <div class="col-md-11">
						<div class="card">
							<div class="card-body">
						        <ul class="nav nav-pills">
						            <li class="nav-item"> <a href="/warehousing/warehousing.do" class="nav-link" aria-expanded="false"><i class="mdi mdi-arrow-down-bold-circle-outline"></i> 입고</a> </li>
						            <li class="nav-item"> <a href="javascript:void(0);" class="nav-link active" aria-expanded="false"><i class="mdi mdi-arrow-up-bold-circle-outline"></i> 출고</a> </li>
						        	<li class="nav-item"> <a href="/deadline/deadline.do" class="nav-link" aria-expanded="false"><i class="mdi mdi-arrow-up-bold-circle-outline"></i> 관리</a> </li>
						        </ul>
						    </div>
						</div>
					</div>
                </div>
                <!-- ============================================================== -->
                <!-- End Bread crumb and right sidebar toggle -->
                <!-- ============================================================== -->
                <!-- ============================================================== -->
                <!-- Start Page Content -->
                <!-- ============================================================== -->
                <div class="row">
                    <div class="col-md-4">
						<div class="card">
						    <div class="card-body" style="height: 290px;">
                                <h6 class="card-title">고객조회</h6>
						        <form class="form" id="custForm" onSubmit="return false;">
						        	<input type="hidden" name="id"/>
						        	<input type="hidden" name="oper"/>
						            <div class="form-group m-t-10 row">
						                <label for="example-text-input" class="col-2 col-form-label">전   화</label>
						                <div class="col-10">
							                <div class="input-group">
							                    <input class="form-control" type="text" name="tel_1" maxlength="3">&nbsp;<b>-</b>&nbsp;
							                    <input class="form-control" type="text" name="tel_2" maxlength="4">&nbsp;<b>-</b>&nbsp;
							                    <input class="form-control" type="text" name="tel_3" maxlength="4">
						                    </div>
						                </div>
						            </div>
						            <div class="form-group row">
						                <label for="example-search-input" class="col-2 col-form-label">주   소</label>
						                <div class="col-10">
						                    <input class="form-control" type="text" name="addr">
						                </div>
						            </div>
						            <div class="form-group row">
						                <label for="example-email-input" class="col-2 col-form-label">고객명</label>
						                <div class="col-10">
						                    <input class="form-control" type="text" name="name">
						                </div>
						            </div>
						        </form>
						        <div class="button-group" style="float:right;">
							        <button type="button" class="btn btn-info" onClick="fSetCust();">
										<i class="fa fa-save"></i>
										저장
									</button>
									<button type="button" class="btn btn-info" onClick="fShowCust();">
										<i class="fa fa-search"></i>
										조회
									</button>
									<button type="button" class="btn btn-secondary" onClick="fInit();">
										<i class="fa fa-window-close-o"></i>
										초기화
									</button>
								</div>
						    </div>
						</div>
                    </div>
                    <div class="col-md-8" id="data-form">
                    	<div class="card">
					        <div class="card-body">
					            <h6 class="card-title">고객리스트</h6>
					            <div class="table-responsive" style="overflow: auto;height: 220px;">
						            <table class="table table-hover">
						                <thead>
						                    <tr>
						                        <th>ID</th>
						                        <th>고객명</th>
						                        <th>전화번호</th>
						                        <th>주소</th>
						                        <th>등록일</th>
	                        					<th>최근방문일</th>
	                        					<th>최근출고일</th>
						                    </tr>
						                </thead>
						                <tbody>
											<tr>
												<td colspan="7">고객을 조회해 주세요.</td>
											</tr>
						                </tbody>
						            </table>
					            </div>
					        </div>
					    </div>
                    </div>
                </div>
                <div class="row">
					<div class="col-12">
						<div class="card">
							<div class="card-body">
								<div class="form-inline m-t-5 m-b-5" style="float: right;">
									<div class="input-group" style="margin-right: 5px;">
										<label class="btn btn-info active">
                                            <input type="checkbox" id="checkRel" class="filled-in chk-col-light-blue">
                                            <label class="" for="checkRel"> 출고된항목 같이보기</label>
                                        </label>
									</div>
							        <div class="input-group" style="margin-right: 50px;">
										<div class="input-group-prepend">
											<span class="input-group-text">출고일자</span>
										</div>
										<input type="text" name="relDate" class="form-control mydatepicker" placeholder="YYYY/MM/DD"/>
										<div class="input-group-append">
										    <span class="input-group-text" id="relDateBtn"><i class="icon-calender"></i></span>
										</div>
									</div>
									<div class="button-group m-t-5" style="margin-right: 50px;">
								        <button type="button" class="btn btn-info" onClick="fSetRelease();"><i class="fa fa-save"></i> 출고</button>
									</div>
							    </div>
						    </div>
						</div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-12">
                        <div class="card">
                            <div class="card-body" >
                                <h6 class="card-title">입고품목</h6>
                                <table id="stock-table" data-toggle="table" data-click-to-select="true" data-height="320" data-row-attributes="rowAttr">
                                    <thead>
                                        <tr>
											<th data-checkbox="true"></th>
											<th data-field="reg_dt" >입고일</th>
											<th data-field="seq" data-visible="false" >품목ID</th>
											<th data-field="prod_name" >품목명</th>
											<th data-field="amount" >수량</th>
											<th data-field="total_price" data-formatter="formatterComma" >금액</th>
											<th data-field="stock_num" >입고번호</th>
											<th data-field="etc" >비고</th>
											<th data-field="rel_dt" >출고예정</th>
											<th data-field="payment" data-formatter="formatterPayment" >지불</th>
											<th data-field="card" data-formatter="formatterCard" >카드</th>
											<th data-field="delivery" data-formatter="formatterDelivery" >수령방식</th>
											<th data-field="is_release" >출고여부</th>
                                        </tr>
                                    </thead>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- row -->
                <!-- ============================================================== -->
                <!-- End PAge Content -->
                <!-- ============================================================== -->
            </div>
            <!-- ============================================================== -->
            <!-- End Container fluid  -->
            <!-- ============================================================== -->
        </div>
        <!-- ============================================================== -->
        <!-- End Page wrapper  -->
        <!-- ============================================================== -->
    </div>
    <!-- ============================================================== -->
    <!-- End Wrapper -->
    <!-- ============================================================== -->
</body>
</html>