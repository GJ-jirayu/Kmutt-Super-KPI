<%@ include file="/WEB-INF/jsp/include.jsp"%>
<%@ page contentType="text/html; charset=utf-8"%>
<%@ page import="javax.portlet.PortletURL"%>
<%@ taglib prefix="chandraFn" uri="http://localhost:8080/web/function" %>

<portlet:actionURL var="formActionSubmitFilter">
	<portlet:param name="action" value="doSubmitFilter" />
</portlet:actionURL>
<portlet:actionURL var="formActionTarget">
	<portlet:param name="action" value="doAssignTarget" />
</portlet:actionURL>
<portlet:resourceURL var="doSearchOrg" id="doSearchOrg"></portlet:resourceURL>
<portlet:resourceURL var="doInsertResult" id="doInsertResult"></portlet:resourceURL>
<portlet:resourceURL var="doReloadResult" id="doReloadResult"></portlet:resourceURL>

<portlet:resourceURL var="dofindOrgByUserName" id="dofindOrgByUserName" ></portlet:resourceURL>
<portlet:resourceURL var="requestOrgFaculty" id="requestOrgFaculty" ></portlet:resourceURL>
<portlet:resourceURL var="dofindOrgByOrgId" id="dofindOrgByOrgId" ></portlet:resourceURL>
<portlet:resourceURL var="requestOrgCourse" id="requestOrgCourse" ></portlet:resourceURL>


<html lang="en">
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta name="description" content="">
<meta name="author" content="">
<!-- Bootstrap core CSS -->
<link rel="stylesheet" href="<c:url value="/resources/bootstrap/css/bootstrap.min.css"/>" type="text/css" />
<script src="<c:url value="/resources/js/jquery-1.11.2.min.js"/>"></script>
<script src="<c:url value="/resources/js/confirm-master/jquery.confirm.min.js"/>"></script> 
<script	src="<c:url value="/resources/js/smoothness/jquery-ui-1.9.1.custom.min.js"/>"></script>
<link rel="stylesheet" href="<c:url value="/resources/css/smoothness/jquery-ui-1.9.1.custom.min.css"/>" />
<script src="<c:url value="/resources/bootstrap/js/bootstrap.min.js"/>"></script>
<script	src="<c:url value="/resources/bootstrap/js/bootstrap-typeahead.min.js"/>"></script>
<link rel="stylesheet" type="text/css" href="<c:url value="/resources/css/override-portlet-aui.css"/>" />
<link rel="stylesheet" type="text/css" href="<c:url value="/resources/css/override-jqueryui.css"/>" />
<link rel="stylesheet"href="<c:url value="/resources/css/common-element.css"/>"type="text/css" />
<link rel="stylesheet" href="<c:url value="/resources/css/style.css"/>" type="text/css" />
<script type="text/javascript"> 
    	$( document ).ready(function() {
    		if(!${not empty pageMessage}){
    			$('#pageMessage').css("display","none");
    		}
    		/*$("#assignKpi").accordion({
    			 heightStyle: "content",
    			 collapsible: true
    		});*/
    		// initial active select
    		ToggleEnableSelection();
    		renderParameterCtrl(getUserRoleLevelID());
    		KpiResultDefalutValueTemp();
    		if(${currentGroupId} != 0){ $("#groupId").val(${currentGroupId}); }
    		if(${currentPerspectiveId} != 0){$("#perspectiveId").val(${currentPerspectiveId}); }

    		$(".kpiWeight").forceNumeric();
    		$("#checkAll").click(function () {
				$('input:checkbox').not(this).prop('checked', this.checked);
			});

    	});

    	function ToggleEnableSelection(){
    		var filterUniversity  = $("#filterUni");
    		var filterFaculity  = $("#filterFac");
    		var filterCourse = $("#filterCou");
    		var filterLevel = $('#assignKpi_filter select#level').val();

			if(filterLevel==1){ 
				filterUniversity.prop("disabled",false); 
				filterFaculity.prop("disabled",true); 
				filterCourse.prop("disabled",true); 
			}else if(filterLevel==2){ 
				filterUniversity.prop("disabled",false);
				filterFaculity.prop("disabled",false); 
				filterCourse.prop("disabled",true); 
			}else if(filterLevel==3){ 
				filterUniversity.prop("disabled",false); 
				filterFaculity.prop("disabled",false); 
				filterCourse.prop("disabled",false); 
			}
    	}

		function getUserRoleLevelID(){
			var userRoleLevel;
			$.ajax({ 
				dataType:'json',
				url: "<%=dofindOrgByUserName%>",
				async: false,
				data: { },
				success: function(data){
					userRoleLevel = data["userRoleId"][0]["levelId"];
				}
			});
			return userRoleLevel;
		}

		function renderParameterCtrl(userLevelId){
			var paramLevel = $('#assignKpi_filter select#level').val();
			var paramUniversity  = $("#filterUni");
			var paramFaculty  =  $("#filterFac");
			var paramCourse = $("#filterCou");

	        //ตรวจสอบสิทธิ์ของผู้ใชงานและทำการส้ราง Parameter ตามสิทธิ์
	        if(userLevelId == 1){
	          if(paramLevel == 1){
	            //Do not thing

	          }else if(paramLevel == 2){
	            //Generate paramFaculty and set defalut value
	            ParamChange(paramUniversity, 'university');
	            if(${currentFaculty} != 0){
	              paramFaculty.val(${currentFaculty});
	            }

	          }else if(paramLevel == 3){
	            //Generate paramFaculty and set defalut value
	            ParamChange(paramUniversity, 'university');
	            if(${currentFaculty} != 0){
	              paramFaculty.val(${currentFaculty});
	            }

	            //Generate paramCoures and set defalut value
	            ParamChange(paramFaculty, 'faculty');
	            if(${currentCourse} != 0){
	              paramCourse.val(${currentCourse});
	            }
	          }

	        }

	        else if(userLevelId == 2){ 
	          $("#level option[value=1]").prop("disabled", true);
	          if(paramLevel == 2){
	            //Generate paramFaculty and set defalut value
	            ParamChange(paramUniversity, 'university');
	            if(${currentFaculty} != 0){
	              paramFaculty.val(${currentFaculty});
	            }

	          }else if(paramLevel == 3){
	            //Generate paramFaculty and set defalut value
	            ParamChange(paramUniversity, 'university');
	            if(${currentFaculty} != 0){
	              paramFaculty.val(${currentFaculty});
	            }

	            //Generate paramCoures and set defalut value
	            ParamChange(paramFaculty, 'faculty');
	            if(${currentCourse} != 0){
	              paramCourse.val(${currentCourse});
	            }
			}

	        }else if(userLevelId==3){
	          $('select#level option[value=1]').prop("disabled", true);
	          $('select#level option[value=2]').prop("disabled", true);         
	          $.ajax({ 
	              dataType:'json',
	              url: "<%=dofindOrgByOrgId%>",
	              data: { 'orgId': $('input#idenOrgId').val() },
	              success: function(data){ 
	                //Generate paramFaculty             
	                facultyOpt = $("<option value=\""+data["facultyCourseList"][0]["facultyCode"]
	                  +"\"></option>").html(data["facultyCourseList"][0]["facultyName"]);
	                paramFaculty.empty().append(facultyOpt);

	                //Generate paramCourse
	                courseOpt = $("<option value=\""+data["facultyCourseList"][0]["courseCode"]
	                  +"\"></option>").html(data["facultyCourseList"][0]["courseName"]);
	                paramCourse.empty().append(courseOpt);
	              }
	            });
	        }
		}

		function ParamLevelChange(el){
	        ToggleEnableSelection();
	        var paramLevelVal = $('#assignKpi_filter select#level').val();
			var paramUniversityEl  = $("#filterUni");
			var paramFacultyEl  =  $("#filterFac");
			var paramCourseEl = $("#filterCou");
	        if(paramLevelVal==1){
	          paramFacultyEl.val(0);
	          paramCourseEl.val(0);
	          paramFacultyEl.find("option").attr("disabled", "disabled");
	          paramCourseEl.find("option").attr("disabled", "disabled");
	        }else if(paramLevelVal==2){
	          paramCourseEl.find("option").attr("disabled", "disabled");
	          ParamChange(paramUniversityEl, "university");
	        }else if(paramLevelVal==3){ 
	          ParamChange(paramUniversityEl, 'university');
	          ParamChange(paramFacultyEl, 'faculty');
	        }
		}

		function ParamChange(el, changeType){

        var sups = ["university","faculty","course"];
        var value = $(el).val();
        var elUniversity  = $("#filterUni");
		var elFaculty  =  $("#filterFac");
		var elCouse = $("#filterCou");

        if(changeType == sups[0]){ // university change
        	$.ajax({ 
        		dataType:'json',
            	url: "<%=requestOrgFaculty%>",
            	async: false,
            	data: { 'levelId': value , 'university':elUniversity.val()  } ,
            	success: function(data){
              		GenParamFacultyList(elFaculty,data["lists"]);
              		var x = [];
              		GenParamCourseList(elCouse,x);
            	}
          	});
        }else if(changeType == sups[1]){ // faculty change
          	$.ajax({ 
            dataType:'json',
            url: "<%=requestOrgCourse%>",
            data: { 'levelId': value , 'university':elUniversity.val(), 'faculty': elFaculty.val()  } ,
            async: false,            
            success: function(data){
            //  alert(JSON.stringify(data));
              if($('select#level').val() == "3"){
                GenParamCourseList(elCouse,data["lists"]);

                //Remove class redBorder if not null value    
                if(elCouse.val() != null){
                  elCouse.removeClass("redBorder");
                } 
              }
            }
          });
        }else if(changeType == sups[2]){ 
          //Remove class redBorder if not null value  
          if(elCouse.val() != null){
            elCouse.removeClass("redBorder");
          }
        }
      }

		function GenParamFacultyList(target,data){
			//  var target = $('#'+elFaculty);
			target.empty();
			var opt;
			for(var i=0; i<data.length; i++){
				opt = $("<option value=\'"+data[i]["id"]+"\'></option>").html(data[i]['name']);
				target.append(opt);
			}
		}

		function GenParamCourseList(target,data){
			// var target = $('#'+elCourse);
			target.empty();
			var opt; //= $("<option value='0'></option>").html("");
			target.append(opt);
			for(var i=0;i<data.length;i++){
				if(!(jQuery.isEmptyObject(data[i]))){
					opt = $("<option value=\""+data[i]['id']+"\"></option>").html(data[i]['name']);
					target.append(opt);
				}         
			} 
		}

   	 	function actTarget(el){
   	 		var kpiId = parseInt($(el).parent('td').parent('tr').children('tbody tr td:nth-child(1)').html());
   	 		$('#kpiListForm #kpiId').val(kpiId);
	   	 	$('#kpiListForm').attr("action","<%=formActionTarget%>");
			$('#kpiListForm').submit();
   	 	}
   	 	function submitFilter(){
	   	 	$('#hierarchyAuthorityForm').attr("action","<%=formActionSubmitFilter%>");
			$('#hierarchyAuthorityForm').submit(); 	 			
   	 	}
   	 	function clearOption(elName){
   	 		var defaultOpt = $("<option></option>").html("");
   	 		var target = $("#"+elName);
   	 		target.empty();
   	 		target.append(defaultOpt);
   	 	}
   	 	function createOption(targetId,lists){
   	 		var target = $("select#"+targetId);
   	 		target.empty();
   	 		var opt = $("<option></option>").html("");
   	 		target.append(opt);
   	 		for(var i=0;i<lists.length;i++){
   	 			var opt = $("<option></option>");
   	 			opt.attr("value",lists[i]["orgCode"]);
   	 			opt.html(lists[i]["orgDesc"]);
   	 			target.append(opt);
   	 		}
   	 	}

   	 	function beforeInsertResult(){
   	 		/*ทำการวนหา kpi ที่ถูกเลือกและดึงค่าถ่วงน้ำหนักมาคำนวนดูว่ารวมกันแล้วเท่ากับหนึ่งร้อยหรือไม่*/
   	 		/*และทำการส่งค่าถ่วงน้ำหนัก ไปทำการบันทึกลงตาราง*/
   	 		var currentWeightValArr = [];
   	 		var childClassArr = [];
   	 		var sumValue = null;
   	 		$("#assignKpi table.tableGridLv>tbody>tr").each(function(){
   	 			var elNormal = $(this).children("td:nth-child(2)").children('input[type="checkbox"]');
   	 			var elParent = $(this).children("td:nth-child(2)").children('input[type="checkbox"].parent');
   	 			var elChild = $(this).children("td:nth-child(2)").children('input[type="checkbox"].child');
   	 			var values = $(this).children("td:nth-child(7)").children('input[type="number"]').val();
   	   	 		var kpiIds = $(this).children("td:nth-child(1)").html();

   	   	 		// Get kpi selected: ดึง kpi_id และ value ทั้งหมดตามที่ user ลเือก //
   	   	 		if(elNormal.is(':checked')){
   	   	 			currentWeightValArr.push($.trim(kpiIds)+":"+values);
   	   	 		}

   	   	 		// Sum parent kpi //
   	 			if(elParent.is(':checked')){   	   	 			
   	 				sumValue = sumValue + parseFloat(values);

   	 			}else{
   	 				elParent.parent().parent().children("td:nth-child(7)").children('input[type="number"]').val(0.00);
   	 			}

   	 			// ในกรณีที่มี kpi ย่อยให้ืำการตรวจสอบการกำหนดค่าของ weight ของ kpi นั้น ๆ ก่อน //
   	 			if(elChild.is(':checked')){   	 				
   	 				// find uniqe parent kpi //
   	 				var classNameArr = elChild.attr("class").split(" ");;
   	 				if(jQuery.inArray(classNameArr[0], childClassArr) == -1){
   	 					childClassArr.push(classNameArr[0]);
   	 				}
   	 				console.log("childClassArr:"+childClassArr);
   	 			}
   	 		});

   	 		// ตรวจสอบ parent kpi ว่ามีข้อมูล wight ครอบ 100 แล้วหรือไม่ //
   	 		// Null คือ usre ไม่ได้เลอก kpi ไดเลยจึงสามารถให้ดำเนินงานต่อได้ //
   	 		if(sumValue == null || sumValue == 100){
   	 			var sumChildValue = null;
   	 			var insertFlag = false;

   	 			// ตรวจอสอบค่าถ่วงน้ำหนักของ child kpi โดยแบ่งกลุ่มตาม parent kpi ต้องเท่ากับ 100 //
   	 			$.each(childClassArr, function(key, value){
					var elParentClass = "parent"+value.substring(value.search("-"));   	 				
   	 				var kpiParentName = $('input[type="checkbox"].'+elParentClass).parent().parent().children("td:nth-child(3)").html();
   	 				sumChildValue = null; 
   	 				// get value by element class //
   	 				$('input[type="checkbox"].'+value).each(function(){
   	 					var childValue = 
   	 						$(this).parent().parent().children("td:nth-child(7)").children('input[type="number"]').val();
   	 					var childKpiId= $(this).parent().parent().children("td:nth-child(1)").html();
   	 					sumChildValue = sumChildValue+parseFloat(childValue);
   	 				});

   	 				if(sumChildValue == null || sumChildValue == 100){
   	 					insertFlag = true;
   	 				}else{
   	 					insertFlag = false;
   	 					$.confirm({
					   	     text: 'ค่าถ่วงน้ำหนักตัวบ่งชี้ย่อย ของตัวบ่งชี้ <br/>"'
					   	     	+kpiParentName+'" <br/>รวมกันต้องเท่ากับ 100',
					   	     title: "บันทึก กำหนดตัวบ่งชี้",
					   	     confirm: function(button) {		 
					   	     	// nothing to do
					   	     },
					   	     cancel: function(button) {
					   	         // nothing to do
					   	     },
					   	     confirmButton: "ตกลง",
					   	     cancelButton: "ยกเลืก",
					   	     post: true,
					   	     confirmButtonClass: "btn-primary",
					   	     cancelButtonClass: "btn-danger",
					   	     dialogClass: "modal-dialog modal-lg" // Bootstrap classes for large modal
						});
			   	 		$(".btn-danger").hide();
   	 				}
   	 			});
   	 			if(childClassArr.length == 0){ insertFlag = true;}
   	 			if(insertFlag === true){insertResult(currentWeightValArr);}

   	 		}else{
	   	 		$.confirm({
			   	     text: "ค่าถ่วงน้ำหนักรวมกันต้องเท่ากับ 100",
			   	     title: "บันทึก กำหนดตัวบ่งชี้",
			   	     confirm: function(button) {		 
			   	     	// nothing to do
			   	     },
			   	     cancel: function(button) {
			   	         // nothing to do
			   	     },
			   	     confirmButton: "ตกลง",
			   	     cancelButton: "ยกเลืก",
			   	     post: true,
			   	     confirmButtonClass: "btn-primary",
			   	     cancelButtonClass: "btn-danger",
			   	     dialogClass: "modal-dialog modal-lg" // Bootstrap classes for large modal
				});
	   	 		$(".btn-danger").hide();
   	 		}
   	 	}


   	 	function insertResult(currentWeightValArr){
   	 		var currentValArr = [];
   	 		$("#assignKpi table.tableGridLv>tbody>tr").each(function(){
   	 			if($(this).children("td:nth-child(2)").children('input[type="checkbox"]').is(':checked')){
   	   	 			currentValArr.push($(this).children("td:nth-child(1)").html());	
   	 			}
   	 		});

   	 		/*ทำการหาข้อมูลที่ต้องการจะลบ (Base - Current)*/
   	 		var baseValArr = $("input#cbxBaseVal").val().split("-");
   	 		var deleteVal = [];
   	 		$.each( baseValArr, function( key, value ) {
			    var index = $.inArray( value, currentValArr );
			    if( index == -1 ) {
			        deleteVal.push(value);
			    }
			});

			/*ทำการหาข้อมูลที่ต้องการ insert (Base - Current)*/
			var insertVal = [];
			$.each( currentValArr, function( key, value ) {
			    /*var index = $.inArray( value, baseValArr );
			    if( index == -1 ) {*/
			        insertVal.push(value);
			    /*}*/
			});

   	 		var orgId = $("#kpiListForm #orgId").val();
	   	 	$.ajax({
	   	 		dataType: "json",
	   	 		url:"<%=doInsertResult%>",
	   	 		data: { "orgId":orgId ,
	   	 			"deleteKpis":deleteVal.join("-"), 
	   	 			"insertKpis":insertVal.join("-"),
	   	 			"kpiWeights":currentWeightValArr.join("-")
	   	 		},	 		
	   	 		async: false,
	   	 		success:function(data){
	   	 			console.log(JSON.stringify(data));
	   	 			if(data['header']['success']>0){
		   	 			$('#pageMessage').html('บันทึกสำเร็จ');
		   	 			$('#pageMessage').removeClass();
		   	 			$('#pageMessage').addClass("alert");
		   	 			toggleSetTargetBtn();	 			
	   	 			}else{
		   	 			$('#pageMessage').html('บันทึกผิดพลาด '+data['header']['status']);
		   	 			$('#pageMessage').removeClass();
		   	 			$('#pageMessage').addClass("alert alert-danger");
	   	 			}
	   	 			$('div#pageMessage').focus();
	   	 			$('div#pageMessage').css( "display", "block" ).fadeOut( 5000 );
	   	 		}
	   	 	});

	   	 	KpiResultDefalutValueTemp();
   	 	}

   	 	function reloadResult(){
   	 		var orgId = $("#kpiListForm #orgId").val();
	   	 	$.ajax({
	   	 		dataType: "json",
	   	 		url:"<%=doReloadResult%>",
				data : {"orgId" : orgId},
					success : function(data) {
						if (data['header']['success'] > 0) {
							$(
									'#assignKpi table tbody tr input[type="checkbox"]')
									.prop('checked', false);
							var kpiIds = data['content']['lists'].split('-');
							for (var i = 0; i < kpiIds.length; i++) {
								$(
										'#assignKpi table tbody tr#r'
												+ kpiIds[i]).children(
										'td:nth-child(2)').children(
										'input[type="checkbox"]').prop(
										'checked', true);
							}
							$('#pageMessage').html('โหลดค่าเริ่มต้นสำเร็จ');
							$('#pageMessage').removeClass()
							$('#pageMessage').addClass("alert");
							toggleSetTargetBtn();
						} else {
							$('#pageMessage').html('โหลดค่าเริ่มต้นผิดพลาด');
							$('#pageMessage').removeClass();
							$('#pageMessage').addClass("alert alert-danger");
						}
						$('div#pageMessage').focus();
						$('div#pageMessage').css("display", "block").fadeOut( 5000 );

					}
				});
	}

	function toggleSetTargetBtn() {
		$('#assignKpi table tbody tr').each(
				function() {
					if ($(this).children('td:nth-child(2)').children(
							'input[type="checkbox"]').is(':checked')) {
						$(this).find('a').show();
					} else {
						$(this).find('a').hide();
					}
				});
	}

	function KpiResultDefalutValueTemp(){
		var arId = [];
   	 	$("#assignKpi table.tableGridLv>tbody>tr").each(function(){
   	 		if($(this).children("td:nth-child(2)").children('input[type="checkbox"]').is(':checked')){
   	   			arId.push($(this).children("td:nth-child(1)").html());	
   	 		}
   	 	});
   	 	$("input#cbxBaseVal").empty().val(arId.join('-'));
	}

	jQuery.fn.forceNumeric = function () {
		return this.each(function () {
			$(this).keydown(function (e) {
			var key = e.which || e.keyCode;

			if (!e.shiftKey && !e.altKey && !e.ctrlKey &&
				// numbers   
				key >= 48 && key <= 57 ||
				// Numeric keypad
				key >= 96 && key <= 105 ||
				// comma, period and minus, . on keypad
				key == 190 || key == 188 || key == 109 || key == 110 ||
				// Backspace and Tab and Enter
				key == 8 || key == 9 || key == 13 ||
				// Home and End
				key == 35 || key == 36 ||
				// left and right arrows
				key == 37 || key == 39 ||
				// Del and Ins
				key == 46 || key == 45)
				return true;

				return false;
			});
		});
	}
	
</script>
<style type="text/css">
	/* (1)+5 td*/
	#assignKpi table.tableGridLv td:nth-child(1) {
		display: none
	}

	#assignKpi table.tableGridLv td:nth-child(2) {
		width: 10%;
	}

	#assignKpi table.tableGridLv td:nth-child(3) {
		width: 40%
	}

	#assignKpi table.tableGridLv td:nth-child(4) {
		width: 10%;
	}

	#assignKpi table.tableGridLv td:nth-child(5) {
		width: 10%;
	}

	#assignKpi table.tableGridLv td:nth-child(6) {
		width: 10%;
	}

	#assignKpi table.tableGridLv td:nth-child(7) {
		width: 10%;
		padding: 0px;
	}   
	#assignKpi table.tableGridLv td:nth-child(8) {
		width: 10%;
	} 
	#assignKpi table.tableGridLv td:nth-child(7) input{
		border-width: 0px 0px 1px 0px;
		background-color: transparent;
	}  
	.center {text-align: center;}
	input[type="checkbox"].child{ margin-left: 50px; }
</style>
</head>

<body>
	<!-- Input สำหรับเก็บ kpi_result id เดิมที่มีอยู่ใน database -->
	<input type="hidden" id="cbxBaseVal" value=""></input> <br/>
	<%-- 
	Debug information 
	userDetail: ${userDetail} <br/>
	currentFaculty: ${currentFaculty} <br/>
	currentCourse: ${currentCourse} <br/> 
	--%>

	<div id="assignKpiList" class="box bg" style="-top:50px;">
		<div id="assignKpi_filter" class="boxHeader">
			<form:form id="hierarchyAuthorityForm"
				modelAttribute="hierarchyAuthorityForm" method="post"
				name="hierarchyAuthorityForm" action="${formActionSubmitFilter}"
				enctype="multipart/form-data">
				<form:input type="hidden" id="idenOrgId" path="orgId" />

				<span>ระดับตัวบ่งชี้: </span>
				<form:select path="level" class="input-medium wid"
					onchange="ParamLevelChange(this)">
					<form:options items="${levelList}" />
				</form:select>

				<span style="display: none;">เป้าประสงค์: </span>
				<form:select id="groupId" path="groupId" class="input-xlarge wid" style="display: none;">
					<form:options items="${groupLists}" />
				</form:select>

				<span style="display: none;">มุมมอง: </span>
				<form:select id="perspectiveId" path="perspectiveId" class="input-large wid" style="display: none;">
					<form:options items="${perLists}" />
				</form:select>
				<br/>

				<span>สถาบัน/มหาวิทยาลัย: </span>
				<form:select class="wid input-large" id="filterUni" path="university"
					onchange="ParamChange(this,'university')">
					<form:options items="${uniList}" />
				</form:select>

				<span>คณะ: </span>
				<form:select class="wid input-xlarge" id="filterFac" path="faculty"
					onchange="ParamChange(this,'faculty')">
					<!-- Generate option by GenParamFacultyList(). -->
				</form:select>

				<span>หลักสูตร: </span>
				<form:select class="wid input-xlarge" id="filterCou" path="course">
					<!-- Generate option by GenParamCourseList(). -->
				</form:select>

				<input type="button" value="เรียกดู" onclick="submitFilter()" class="btn btn-primary" 
				style="margin-bottom: 10px;"/>
			</form:form>
		</div>
		
		<form:form id="kpiListForm" modelAttribute="kpiListForm" method="post"
			name="kpiListForm" action="${formActionNew}"
			enctype="multipart/form-data">
			<form:input type="hidden" id="pageNo" path="pageNo" />
			<form:input type="hidden" id="keySearch" path="keySearch" />
			<form:input type="hidden" id="kpiId" path="kpiId" />
			<form:input type="hidden" id="orgId" path="orgId" />
		</form:form>

		<div id="assignKpi">
		<c:if test="${not empty resultKpis}">
			<div class="table-responsive">
				<table class="tableGridLv hoverTable">
					<thead>
						<tr>
							<th style="display: none;">รหัสตัวบ่งชี้</th>
							<th style="text-align: center"> 
								<input type="checkbox" id="checkAll" style="margin: 0px;"> เลือก
							</th>
							<th>ชื่อตัวบ่งชี้</td>
							<th>ประเภทปฏิทิน</td>
							<th class="center">ช่วงเวลา</th>
							<th class="center">หน่วยวัด</th>
							<th class="center">ค่าถ่วงน้ำหนัก</th>
							<th class="center">เป้าหมาย</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach items="${resultKpis}" var="kpi" varStatus="loop">
							<tr id="r${kpi.kpiId}">
								<td style="display: none;">${kpi.kpiId}</td>
								<td style="text-align: center">
								<c:choose>
									<c:when test="${empty kpi.parentKpiId}">
										<c:choose>
											<c:when test="${kpi.resultId>0}">
												<input type="checkbox" name="isUsed" class="parent-${kpi.kpiId} parent" value="1" checked>
											</c:when>
											<c:otherwise>
												<input type="checkbox" name="isUsed" class="parent-${kpi.kpiId} parent" value="1">
											</c:otherwise>
										</c:choose>
									</c:when>
									<c:otherwise>
										<c:choose>
											<c:when test="${kpi.resultId>0}">
												<input type="checkbox" name="isUsed" class="child-${kpi.parentKpiId} child" value="1" checked>
											</c:when>
											<c:otherwise>
												<input type="checkbox" name="isUsed" class="child-${kpi.parentKpiId} child" value="1">
											</c:otherwise>
										</c:choose>
									</c:otherwise>
								</c:choose>									
								</td>
								<td>${chandraFn:nl2br(kpi.kpiName)}</td>
								<td class="center">${chandraFn:nl2br(kpi.calendarTypeName)}</td>
								<td class="center">${chandraFn:nl2br(kpi.periodName)}</td>
								<td class="center">${chandraFn:nl2br(kpi.kpiUomName)}</td>
								<td class="center" valign="midden">
									<input id="kpiWeight-${kpi.kpiId}" class="input-mini kpiWeight" type="number" 
									value="${kpi.kpiWeight}" step="0.25" max="100"/>							
								</td>
								<td class="center">
									<c:choose>
										<c:when test="${kpi.resultId>0}">												
											<c:choose>
												<c:when test="${not empty kpi.targetValue && kpi.targetValue > 0}">
													<a href="#" class="icon" onClick="actTarget(this)">
														<img src="<c:url value="/resources/images/edited-assign.png"/>" width="25" height="25">
													</a>
												</c:when>
												<c:otherwise>
													<a href="#" class="icon" onClick="actTarget(this)">
													<img src="<c:url value="/resources/images/edited.png"/>" width="25" height="25">
													</a>
												</c:otherwise>
											</c:choose>
										</c:when>
										<c:otherwise>
											<a href="#" class="icon" onClick="actTarget(this)" style="display: none">
												<img src="<c:url value="/resources/images/edited.png"/>" width="22" height="22">
											</a>
										</c:otherwise>
									</c:choose>
								</td>
							</tr>
						</c:forEach>
					</tbody>
				</table>
			</div>
		</c:if>
		</div>

		<div style="text-align:center;padding:25px 10px 25px 10px;">		
			<input type="button" class="btn btn-success" onclick="beforeInsertResult()" value="บันทึก" style="margin-right:10px"/>
			<input type="button" class="btn btn-inverse" onclick="reloadResult()" value="กลับสู่ค่าเริ่มต้น"> 
		</div>
		<div style="text-align:center;" >
			<div id="pageMessage" class="alert alert-success"> <strong> ${pageMessage} </strong> </div>
		</div>
</body>
</html>