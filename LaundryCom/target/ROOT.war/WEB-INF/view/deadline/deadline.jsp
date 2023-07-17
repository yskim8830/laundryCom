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
	<%@include file="deadline.hbs" %>
	<script type="text/javascript">
	var init = false;
	/** OnLoad event */ 
	$(function() {	
		// 셀렉트 이벤트 등록
		fRegisterOnchangeEvent();

		fGetStockByDateRange();
	});
	/** change 이벤트 등록 */
	function fRegisterOnchangeEvent() {
		$('input[name="stockSatDate"], input[name="stockEndDate"]').datepicker({
			format: 'yyyy/mm/dd',
			autoclose: true,
			todayHighlight: true,
			language: "kr"
		}).datepicker("setDate",'now');
		
		$('input[name="relDate"]').datepicker({
			format: 'yyyy/mm/dd',
			autoclose: true,
			todayHighlight: true,
			language: "kr"
		}).datepicker("setDate","now");

		$("#stockSatDateBtn").on('click',function(){
			$('input[name="stockSatDate"]').datepicker('show');
		});
		$("#stockEndDateBtn").on('click',function(){
			$('input[name="stockEndDate"]').datepicker('show');
		});
		$("#relDateBtn").on('click',function(){
			$('input[name="relDate"]').datepicker('show');
		});
		
	}
	
	function fGetStockByDateRange(){

		var param = {start_date : $('input[name="stockSatDate"]').val()
				, end_date : $('input[name="stockEndDate"]').val()
				, is_release : $('#isRelease').val()	
				, payment : $('#isPayment').val()
				, card : $('#isCard').val()
				, delivery : $('#isDelivery').val()	
		};
		
		var resultCallback = function(data) {
			 $('#stock-table').bootstrapTable('load', data.listModel);
			//editable
			 $('#stock-table').editableTableWidget();

			 $('table td').on('click keypress dblclick', function() {
				if(this.cellIndex != 8){
					return false;
				}
				/* else if(this.cellIndex == 10){
					$(this).datepicker({
						format: 'yyyy/mm/dd',
						autoclose: true,
						todayHighlight: true,
						language: "kr"
					}).datepicker("setDate",this.innerText).datepicker('show');
				} */
			 });
			 $('#totalCnt').text(formatterComma(data.listModelCount[0].totalCnt));
			 $('#totalAmt').text(formatterComma(data.listModelCount[0].totalAmt));
			 
		};
		
		callAjax("/release/stockList.do", "post", "json", true, param, resultCallback);
	}

	function fSetRelease(){
		//sweet alert confirm
		swal({
		    title: "선택한 품목을 저장 하시겠습니까?",
		    type: "warning",
		    showCancelButton: true,
		    confirmButtonColor: '#DD6B55',
		    closeOnConfirm: false
		 },
		 function(isConfirm){
			if (!isConfirm){
				return;		
		    }
		    
			var resultCallback = function(data) {
				if (data.result == "SUCCESS") {
					swal({
					    title: data.resultMsg,
					    type: "success",
					 },
					function(){
						//location.href = "/release/release.do";
						fGetStockByDateRange()
					});
				}else{
					swal('Warning',data.resultMsg);
				}
				//console.log("successs!");
			};
			
			$('#stock-table tbody tr').each(function(index,value){
				if($(this).hasClass("selected") == true){
					var param = {
						seq : $(this).attr('data_id')
						, stock_num : this.cells[8].innerText
						, etc : this.cells[9].innerText
						, rel_dt : this.cells[10].innerText
						, payment : this.cells[11].innerText == '선불' ? 'P' : 'A'
						, card : this.cells[12].innerText == '현금' ? 'P' : 'C'
						, delivery : this.cells[13].innerText == '방문' ? 'S' : 'D'
						, is_release : this.cells[14].innerText
					};
					callAjax("/deadline/setStock.do", "post", "json", true, param, resultCallback);
				}
			});
			//data.push(sltData);
			//console.log(sltData);
		});
	}
	
	function fDelRelease(){
		//sweet alert confirm
		swal({
		    title: "선택한 품목을 영구 삭제 하시겠습니까?",
		    type: "warning",
		    showCancelButton: true,
		    confirmButtonColor: '#DD6B55',
		    closeOnConfirm: false
		 },
		 function(isConfirm){
			if (!isConfirm){
				return;		
		    }
		    
			var resultCallback = function(data) {
				if (data.result == "SUCCESS") {
					swal({
					    title: data.resultMsg,
					    type: "success",
					 },
					function(){
						//location.href = "/release/release.do";
						fGetStockByDateRange()
					});
				}else{
					swal('Warning',data.resultMsg);
				}
				//console.log("successs!");
			};
			
			$('#stock-table tbody tr').each(function(index,value){
				if($(this).hasClass("selected") == true){
					var param = {
						seq : $(this).attr('data_id')
					};
					callAjax("/deadline/delStock.do", "post", "json", true, param, resultCallback);
				}
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
	function formatterCoupon(value, row, index, field) {
		return value === 'Y' ? '쿠폰사용' : '';
	}
	
	//모달 오픈
	function openModal() {
		$("#responsive-modal").modal('show');
		fShowStat();
	}
	
	/** 정산 */
	function fShowStat() {
		var param = {
			start_date : $('input[name="stockSatDate"]').val()
			, end_date : $('input[name="stockEndDate"]').val()
		};
		var resultCallback = function(data) {
			var dates = '';
			if(param.start_date == param.end_date){
				dates = param.start_date;
			}else{
				dates = param.start_date +' ~ '+ param.end_date;
			}
			$("#data-stat").empty();
			var html = Handlebars.compile($("#data-stat-template").html())({
				wereCnt: data.wereCnt
				,wereList : data.wereList
				,relCnt : data.relCnt
				,relList : data.relList
				,salesList : data.salesList
				,dates : dates 
			});
			$("#data-stat").html(html);
		};
		callAjax("/deadline/statList.do", "post", "json", true, param, resultCallback);
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
						            <li class="nav-item"> <a href="/release/release.do" class="nav-link" aria-expanded="false"><i class="mdi mdi-arrow-up-bold-circle-outline"></i> 출고</a> </li>
						        	<li class="nav-item"> <a href="javascript:void(0);" class="nav-link active" aria-expanded="false"><i class="mdi mdi-arrow-up-bold-circle-outline"></i> 관리</a> </li>
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
					<div class="col-12">
						<div class="card">
							<div class="card-body">
								<div class="form-inline m-t-5 m-b-5" style="float: right;">
									<div class="input-group" style="margin-right: 5px;">
										<div class="input-group-prepend">
											<span class="input-group-text">출고여부</span>
										</div>
                                        <select class="form-control" id="isRelease">
                                            <option value="">전체</option>
                                            <option value="N">미출고</option>
                                            <option value="Y">출고완료</option>
                                        </select>
									</div>
									<div class="input-group" style="margin-right: 5px;">
										<div class="input-group-prepend">
											<span class="input-group-text">지불방식</span>
										</div>
                                        <select class="form-control" id="isPayment">
                                            <option value="">전체</option>
                                            <option value="P">선불</option>
                                            <option value="A">후불</option>
                                        </select>
									</div>
									<div class="input-group" style="margin-right: 5px;">
										<div class="input-group-prepend">
											<span class="input-group-text">결제수단</span>
										</div>
                                        <select class="form-control" id="isCard">
                                            <option value="">전체</option>
                                            <option value="P">현금</option>
                                            <option value="C">카드</option>
                                        </select>
									</div>
									<div class="input-group" style="margin-right: 5px;">
										<div class="input-group-prepend">
											<span class="input-group-text">수령방식</span>
										</div>
                                        <select class="form-control" id="isDelivery">
                                            <option value="">전체</option>
                                            <option value="S">방문</option>
                                            <option value="D">배달</option>
                                        </select>
									</div>
									<div class="input-group" style="margin-right: 5px;">
										<div class="input-group-prepend">
											<span class="input-group-text">입고일</span>
										</div>
										<input type="text" name="stockSatDate" class="form-control mydatepicker" placeholder="YYYY/MM/DD"/>
										<div class="input-group-append">
										    <span class="input-group-text" id="stockSatDateBtn"><i class="icon-calender"></i></span>
										</div>
										~
										<input type="text" name="stockEndDate" class="form-control mydatepicker" placeholder="YYYY/MM/DD"/>
										<div class="input-group-append">
										    <span class="input-group-text" id="stockEndDateBtn"><i class="icon-calender"></i></span>
										</div>
									</div>
									<div class="button-group m-t-5" style="margin-right: 5px;">
								        <button type="button" class="btn btn-info" onClick="fGetStockByDateRange();"><i class="fa fa-search"></i> 조회</button>
								        <button type="button" class="btn btn-primary" onClick="openModal();"><i class="mdi mdi-elevation-rise"></i> 정산</button>
									</div>
								</div>
								<!-- <div class="form-inline m-t-5 m-b-5" style="float: right;">
							        <div class="input-group" style="margin-right: 5px;">
										<div class="input-group-prepend">
											<span class="input-group-text">출고일자</span>
										</div>
										<input type="text" name="relDate" class="form-control mydatepicker" placeholder="YYYY/MM/DD"/>
										<div class="input-group-append">
										    <span class="input-group-text" id="relDateBtn"><i class="icon-calender"></i></span>
										</div>
									</div>
									<div class="button-group m-t-5" style="margin-right: 50px;">
								        <button type="button" class="btn btn-info" onClick="fSetRelease();"><i class="fa fa-save"></i> 저장</button>
								        <button type="button" class="btn btn-danger" onClick="fDelRelease();"><i class="mdi mdi-delete"></i> 삭제</button>
									</div>
							    </div> -->
						    </div>
						</div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-12">
                        <div class="card">
                            <div class="card-body" >
                                <h6 class="card-title">품목</h6>
                                <div class="form-inline m-t-5 m-b-5" style="float: right;">
	                                <div class="button-group m-t-5" style="float:right;margin-right: 5px;">
								        <button type="button" class="btn btn-danger" onClick="fDelRelease();"><i class="mdi mdi-delete"></i> 삭제</button>
									</div>
	                            </div>
                                <table id="stock-table" data-toggle="table" data-click-to-select="true"  data-row-attributes="rowAttr">
                                    <thead>
                                        <tr>
											<th data-checkbox="true"></th>
											<th data-field="seq" >입고번호</th>
											<th data-field="reg_dt" >입고일</th>
											<th data-field="cust_id" >회원번호</th>
											<th data-field="cust_name" >회원명</th>
											<th data-field="prod_name" >품목명</th>
											<th data-field="amount" >수량</th>
											<th data-field="total_price" data-formatter="formatterComma" >금액</th>
											<th data-field="stock_num" >입고번호</th>
											<th data-field="etc" >비고</th>
											<th data-field="rel_dt" >출고예정</th>
											<th data-field="payment" data-formatter="formatterPayment" >지불방식</th>
											<th data-field="card" data-formatter="formatterCard" >결제수단</th>
											<th data-field="delivery" data-formatter="formatterDelivery" >수령방식</th>
											<th data-field="is_coupon" data-formatter="formatterCoupon" >쿠폰사용</th>
											<th data-field="is_release" >출고여부</th>
                                        </tr>
                                    </thead>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-12">
                        <div class="card">
                            <div class="card-body">
                                <table data-toggle="table" data-row-attributes="rowAttr">
                                    <thead>
                                        <tr>
											<th>품목건수</th>
											<th>금액</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                    	<tr>
                                    		<td id="totalCnt">0</td>
                                    		<td id="totalAmt">0</td>
                                    	</tr>
                                    </tbody>
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
            <div id="responsive-modal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" style="display: none;">
			    <div class="modal-dialog" style="max-width:1400px;">
			        <div class="modal-content">
			            <div class="modal-header">
			                <h4 class="modal-title">정산</h4>
			                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
			            </div>
			            <div class="modal-body" id="data-stat">
				            
			            </div>
			            <div class="modal-footer">
			                <button type="button" class="btn btn-default waves-effect" data-dismiss="modal"><i class="fa fa-window-close-o"></i> 닫기</button>
			                
			            </div>
			        </div>
			    </div>
			</div>
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