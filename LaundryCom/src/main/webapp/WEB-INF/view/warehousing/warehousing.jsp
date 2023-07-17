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
	<%@include file="warehousing.hbs" %>
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
		
		$('input[name="stockDate"]').datepicker({
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
		}).datepicker("setDate","+2d");

		$("#stockDateBtn").on('click',function(){
			$('input[name="stockDate"]').datepicker('show');
		});

		$("#relDateBtn").on('click',function(){
			$('input[name="relDate"]').datepicker('show');
		});
		
		$("#custForm input").keydown(function(e){
			if(e.keyCode == 13){
				fShowCust();
				e.preventDefault();
			}
		});

		//품목 count up and down
		$(document).on('click','.bt_up',function(){
			var n = $('.bt_up').index(this);
			var num = $("input[name='num']:eq("+n+")").val();
			num = $("input[name='num']:eq("+n+")").val(num*1+1);
			if(!$(this).parents('tr').children().find('input[type="checkbox"]').is(':checked')){
				$(this).parents('tr').children().find('input[type="checkbox"]').prop('checked',true);
			}
		});
		$(document).on('click','.bt_down',function(){ 
			var n = $('.bt_down').index(this);
			var num = $("input[name='num']:eq("+n+")").val();
			num = $("input[name='num']:eq("+n+")").val(num*1-1 < 0 ? 0:num*1-1);
			if(num.val() == '0'){
				$(this).parents('tr').children().find('input[type="checkbox"]').prop('checked',false);
			}
		});
		//체크박스를 체크하면 cnt 1 올림
		$(document).on('click','.bt_chk',function(){ 
			var n = $('.bt_chk').index(this);
			var num = $("input[name='num']:eq("+n+")").val();
			if($(this).is(":checked")){
				num = $("input[name='num']:eq("+n+")").val(num == 0 ? 1:0);
			}else{
				num = $("input[name='num']:eq("+n+")").val(0);
			}
		});
		
		//switch 옵션
		$(".bt-switch input[type='checkbox']").bootstrapSwitch({
			onSwitchChange: function(event, state) { 
				//updateDataActive(this.value, state);
			}
		});

		//수량 변경시 총금액 수정
		$(document).on('change',"td[name='amount']",function(){
			var amount = $(this).text();
			if(!$.isNumeric(amount)){
				return false;
			}
			var price = Number(uncomma($(this).parents('tr').find('td[name="price"]').text().replace('원','')));
			var tPrice = $(this).parents('tr').find('td[name="tPrice"]').text(comma(amount*price)+'원');
			fGetTotalPrice();
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
	}
	//모달 오픈
	function openModal() {
		/* if($('#custForm input[name="id"]').val() == ''){
			swal('Warning',"먼저 고객을 조회하여 선택해주세요.");
			return false;
		} */

		$("#responsive-modal").modal('show');
		fShowProd();
	}
	/** 품목 조회 */
	function fShowProd() {

		var resultCallback = function(data) {
			//console.log(data.listGrpModel);
			//console.log(data.listModel);
			$("#data-add").empty();
			var html = Handlebars.compile($("#data-prod-template").html())({
				listModel: data.listModel,
				listGrpModel : data.listGrpModel
			});
			$("#data-add").html(html);
			//console.log("successs!");
		};
		
		callAjax("/warehousing/prodList.do", "post", "json", true, "", resultCallback);
	}
	/** 선택한 품목 테이블에 놓기*/
	function fSetProdData(){
		//입고될 데이터
		var data = new Array();
		
		var sltData = new Object();
		$('#data-add-form table').each(function(index){
			//수량을 체크한 품목만 map 에 담음
			if($(this).find('input[type="checkbox"]').is(':checked')){
				
				$(this).find('td input').each(function(i,v){
					//alert('i: '+ i + ', v: ' + v);
					switch(i){
						case 0 :
							sltData.id = v.value;
						case 1 :
							sltData.name = v.value;
						case 2 :
							sltData.price = v.value;
						case 3 :
							sltData.amount = v.value;
						default : 
							return;
					}
				});
				data.push(sltData);
				sltData = new Object();
			}
		});
		//console.log(data);
		if(!init)$('#data-warehousing').empty();
		init = true;
		var str = '';
		
		$.each(data,function(i,v){
			//console.log(v);
			str +='<tr id="tr_'+v.id+'">';
			str +='	<td name="prodName">'+v.name+'</td>';
			str +='	<td name="amount">'+v.amount+'</td>';
			str +='	<td name="price">'+comma(v.price)+'원</td>';
			str +='	<td name="tPrice">'+comma(v.amount * v.price)+'원</td>';
			str +='	<td name="stockNum"></td>';
			str +='	<td name="etc"></td>';
			str +='	<td><input type="checkbox" name="isCoupon"></td>';
			str +='	<td><button type="button" class="btn btn-danger" onClick="fDelItem(\'tr_'+v.id+'\');"><i class="mdi mdi-delete"></i> 삭제</button></td>';
			str +='</tr>';
		});
		$('#data-warehousing').append(str);
		
		//editable
	    $('#mainTable').editableTableWidget();

	    $('table td').on('click keypress dblclick', function(evt, val) {
		    var $attr = $(this).attr('name');
		    if($attr == 'row') return false;
		    else if($attr == 'prodName') return false;
		    else if($attr == 'price') return false;
		    else if($attr == 'tPrice') return false;
	    });
	    
	    fGetTotalPrice();

	    $("#responsive-modal").modal('hide');
	}
	//입고항목 삭제하기
	function fDelItem(id){
		$('#'+id).remove();
		fGetTotalPrice();
	}
	//총 금액 계산하기
	function fGetTotalPrice(){
		var totalPrice = 0;
		$('#mainTable td').each(function(i,v){
			if($(this).attr('name') == 'tPrice'){
				totalPrice += Number(uncomma(v.innerText));
			}
		});
		$('input[name="totalAmt"]').val(comma(totalPrice));
	}
	//작성한 내용 지우기 위해 새로고침
	function fReset(){
		//sweet alert confirm
		swal({
		    title: "작성한 내용을 삭제 하시겠습니까?",
		    type: "warning",
		    showCancelButton: true,
		    confirmButtonColor: '#DD6B55',
		    closeOnConfirm: false
		 },
		 function(isConfirm){
			if (!isConfirm){
				return;		
		    }
			location.href = "/warehousing/warehousing.do"; 
		});
	}
	//입고하기
	function fSetWarehousing(){
		if($('#custForm input[name="id"]').val() == ''){
			swal('Warning',"먼저 고객을 조회하여 선택해주세요.");
			return false;
		}

		if($('#mainTable td').length <= 0){
			swal('Warning',"입고 항목을 추가 해주세요.");
			return false;
		}

		//sweet alert confirm
		swal({
		    title: "입고 하시겠습니까?",
		    type: "warning",
		    showCancelButton: true,
		    confirmButtonColor: '#DD6B55',
		    closeOnConfirm: false
		 },
		 function(isConfirm){
			if (!isConfirm){
				return;		
		    }
			var data = new Array();
			var sltData = new Object();

			var resultCallback = function(data) {
				if (data.result == "SUCCESS") {
					swal({
					    title: data.resultMsg,
					    type: "success",
					 },
					function(){
						location.href = "/warehousing/warehousing.do"; 
					});
				}else{
					swal('Warning',data.resultMsg);
				}
				//console.log("successs!");
				sltData = new Object();
			};
			
			$('#data-ware-form table tbody tr').each(function(index,value){
				sltData.cust_id = $('#custForm input[name="id"]').val();
				sltData.payment = $('input[name="payment"]').prop("checked") == true ? "P" : "A"; // 'P:선불,A:후불'
				sltData.card = $('input[name="card"]').prop("checked") == true ? "C" : "P"; // 'P:현금,C:카드'
				sltData.delivery = $('input[name="delivery"]').prop("checked") == true ? "S" : "D"; // 'S:방문,D:배달'
				sltData.rel_dt = $('input[name="relDate"]').val();
				//
				sltData.prod_id = value.id.replace('tr_','');
				
				$(this).find('td').each(function(i,v){
// 					alert('i: '+ i + ', v: ' + v.innerText);
					switch(i){
						case 0 :
							sltData.prodName = v.innerText;
						case 1 :
							sltData.amount = v.innerText;
						case 2 :
							sltData.price = uncomma(v.innerText.replace('원',''));
						case 3 :
							sltData.tPrice = uncomma(v.innerText.replace('원',''));
						case 4 :
							sltData.stockNum = v.innerText;
						case 5 :
							sltData.etc = v.innerText;
						case 6 :
							sltData.is_coupon = $(this).children().prop("checked") == true ? "Y" : "N";
						default : 
							return;
					}
				});
				var param = sltData;

				callAjax("/warehousing/setStock.do", "post", "json", true, param, resultCallback);
			});
			//data.push(sltData);
			//console.log(sltData);
		});
	}
	
	function fSetProduct(){
		//alert($("#prodTab").tab('show'));
		var grp_cd = $('#prodTab').find('.active').attr('href').replace('#_','');
		var grp_name = $('#prodTab').find('.active').children(".hidden-xs-down").html();
		var name = $('#_'+grp_cd).find("#newProdNm").val();
		var price =  $('#_'+grp_cd).find("#newProdPrc").val();
		//sweet alert confirm
		swal({
		    title: "새 상품을 추가 하시겠습니까?",
		    type: "warning",
		    showCancelButton: true,
		    confirmButtonColor: '#DD6B55',
		    closeOnConfirm: true
		 },
		 function(isConfirm){
			if (!isConfirm){
				return;		
		    }
			if(name == ''){
				swal('Warning','상품명을 입력해주세요.');
				return;
			}
			if(price == ''){
				swal('Warning','상품가격을 입력해주세요.');
				return;
			}
			
			var resultCallback = function(data) {
				if (data.result == "SUCCESS") {
					fShowProd();
				}else{
					swal('Warning',data.resultMsg);
				}
			};
			
			var param = {
					grp_cd : grp_cd
					, grp_name : grp_name
					, name : name
					, price : price
					};
			callAjax("/warehousing/setProd.do", "post", "json", true, param, resultCallback);
		});
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
						            <li class="nav-item"> <a href="javascript:void(0);" class="nav-link active" aria-expanded="false"><i class="mdi mdi-arrow-down-bold-circle-outline"></i> 입고</a> </li>
						            <li class="nav-item"> <a href="/release/release.do" class="nav-link" aria-expanded="false"><i class="mdi mdi-arrow-up-bold-circle-outline"></i> 출고</a> </li>
						            <li class="nav-item"> <a href="/deadline/deadline.do" class="nav-link" aria-expanded="false"><i class="mdi mdi-arrow-up-bold-circle-outline"></i> 관리</a> </li>
						        </ul>
						    </div>
						</div>
					</div>
					<div class="col-md-1">
						<div class="d-flex justify-content-end align-items-center">
							<button type="button" class="btn btn-lg btn-info" style="margin-top: 20px; margin-right: 10px;" onclick="openModal();">
								<i class="fa fa-plus-circle"></i> 품목추가
							</button>
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
						                    </tr>
						                </thead>
						                <tbody>
											<tr>
												<td colspan="6">고객을 조회해 주세요.</td>
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
								<div class="form-inline m-t-5 m-b-5" style="float:right;">
							        <div class="input-group" style="margin-right: 87px;">
										<div class="input-group-prepend">
											<span class="input-group-text">입고일자</span>
										</div>
										<input type="text" name="stockDate" class="form-control mydatepicker" placeholder="YYYY/MM/DD"/>
										<div class="input-group-append">
										    <span class="input-group-text" id="stockDateBtn"><i class="icon-calender"></i></span>
										</div>
									</div>
									<div class="input-group" style="margin-right: 55px;">
										<div class="input-group-prepend">
											<span class="input-group-text">출고예정일자</span>
										</div>
										<input type="text" name="relDate" class="form-control mydatepicker" placeholder="YYYY/MM/DD"/>
										<div class="input-group-append">
										    <span class="input-group-text" id="relDateBtn"><i class="icon-calender"></i></span>
										</div>
									</div>
									<div class="button-group m-t-5" style="margin-right: 50px;">
								        <button type="button" class="btn btn-info" onClick="fSetWarehousing();"><i class="fa fa-save"></i> 입고</button>
										<button type="button" class="btn btn-danger" onClick="fReset();"><i class="mdi mdi-delete"></i> 삭제</button>
									</div>
							    </div>
							    <div class="form-inline" style="float:right;">
							        <div class="input-group" style="margin-right: 50px;">
							        	<div class="input-group-prepend">
											<span class="input-group-text">총 금액&nbsp; &nbsp;</span>
										</div>
										 <input class="form-control" type="text" name="totalAmt" readonly/>
									</div>
									<div class="input-group" style="margin-right: 50px;">
										<div class="input-group-prepend">
											<span class="input-group-text">지불방식</span>
										</div>
										<div class="bt-switch"><input type="checkbox" data-on-color="primary" data-on-text="선불" data-off-color="danger" data-off-text="후불" data-size="normal" name="payment" checked/></div>
									</div>
									<div class="input-group" style="margin-right: 50px;">
										<div class="input-group-prepend">
											<span class="input-group-text">카드여부</span>
										</div>
										<div class="bt-switch"><input type="checkbox" data-on-color="primary" data-on-text="카드" data-off-color="danger" data-off-text="현금" data-size="normal" name="card"/></div>
									</div>
									<div class="input-group" style="margin-right: 50px;">
										<div class="input-group-prepend">
											<span class="input-group-text">배달</span>
										</div>
										<div class="bt-switch"><input type="checkbox" data-on-color="primary" data-on-text="방문" data-off-color="danger" data-off-text="배달" data-size="normal" name="delivery" checked/></div>
									</div>
							    </div>
						    </div>
						</div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-12">
                        <div class="card">
                            <div class="card-body">
                                <h6 class="card-title">입고품목</h6>
                                <form id="data-ware-form" onSubmit="return false;">
	                                <table id="mainTable" class="table table-striped" data-height="320" data-mobile-responsive="true">
	                                    <thead>
	                                        <tr>
	                                            <th>품목명</th>
	                                            <th>수량</th>
	                                            <th>단가</th>
	                                            <th>금액</th>
	                                            <th>입고번호</th>
	                                            <th>비고</th>
	                                            <th>쿠폰사용</th>
	                                            <th></th>
	                                        </tr>
	                                    </thead>
	                                    <tbody id="data-warehousing">
	                                        <tr>
	                                        </tr>
	                                    </tbody>
	                                </table>
                                </form>
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
			                <h4 class="modal-title">품목 추가</h4>
			                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
			            </div>
			            <div class="modal-body" id="data-add">
			                <form id="data-add-form" onSubmit="fSetProdData(); return false;">
			                    <!-- Nav tabs -->
                                <ul class="nav nav-tabs" role="tablist">
                                    <li class="nav-item"> <a class="nav-link active" data-toggle="tab" href="#home" role="tab"><span class="hidden-sm-up"><i class="ti-home"></i></span> <span class="hidden-xs-down">Home</span></a> </li>
                                    <li class="nav-item"> <a class="nav-link" data-toggle="tab" href="#profile" role="tab"><span class="hidden-sm-up"><i class="ti-user"></i></span> <span class="hidden-xs-down">Profile</span></a> </li>
                                    <li class="nav-item"> <a class="nav-link" data-toggle="tab" href="#messages" role="tab"><span class="hidden-sm-up"><i class="ti-email"></i></span> <span class="hidden-xs-down">Messages</span></a> </li>
                                </ul>
                                <!-- Tab panes -->
                                <div class="tab-content tabcontent-border">
                                    <div class="tab-pane active" id="home" role="tabpanel">1</div>
                                    <div class="tab-pane  p-20" id="profile" role="tabpanel">2</div>
                                    <div class="tab-pane p-20" id="messages" role="tabpanel">3</div>
                                </div>
			                </form>
			            </div>
			            <div class="modal-footer">
			                <button type="button" class="btn btn-default waves-effect" data-dismiss="modal"><i class="fa fa-window-close-o"></i> 닫기</button>
			                <button type="button" class="btn btn-info waves-effect waves-light" onClick="fSetProdData();"><i class="fa fa-save"></i> 추가</button>
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