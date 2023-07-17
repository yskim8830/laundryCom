$(document).ready(function() {
	
	//var tdW = 100% - 10;
	//$('td').find('.p94').css('width', tdW);
	
	
	/*****수정 20151215******/
//	var conInH = $('#container li.contents div.content').height();
//	//var conInH = $('#container ul').height();
//	//var conH = $(document).height();
//	//var lnbH = $(document).height();
//	
//	$('#container li.lnb').css('height', conInH +116);
//	$('#container li.contents').css('height', conInH +116);
//	$('#container li.contents div.content').css('height', conInH);
	/**************************/
	
	// LNB 메뉴
	$('ul.lnbMenu li dl dd').hide(); // 이미 없애놓음

	$('ul.lnbMenu a.lnbBtn').click(function(e) {
		e.preventDefault();
		
		if ($("ul.lnbMenu a.lnbBtn").hasClass("on")) {
			$("ul.lnbMenu a.lnbBtn").removeClass("on")
			$("ul.lnbMenu a.lnbBtn").parents("dl").children("dd").slideUp();
		};
		
		$(this).parents("dl").children("dd").slideDown();
		$(this).addClass("on");
	});
	
	
	//qna table
	$("table.qna tr.view").hide();
	$("#tab01").show();
	$('table.qna td a.viewOpen').click(function(e) {
		e.preventDefault();

		$('table.qna tr.view').hide();
		$(this).parents("tr").next("tr.view").show();
	});

});


