<script type="text/javascript"
	src="${springMacroRequestContext.contextPath}/assets/js/calendar/WdatePicker.js"></script>
<section id="widget-grid-reportagentkpi">
	<div class="row">
		<article class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
			<div></div>
			<br />
			<div class="jarviswidget jarviswidget-color-blueDark" id="wid-id-3"
				data-widget-editbutton="false" data-widget-deletebutton="false"
				data-widget-colorbutton="false" data-widget-collapsed="false">
				<header>
					<span class="widget-icon"> <i class="fa fa-table"></i>
					</span>
					<h2>坐席-KPI报表</h2>
				</header>
				<div>
					<div class="jarviswidget-editbox"></div>
					<div class="widget-body no-padding">
						<div class="widget-body-toolbar">
							<label class="input col col-1">报表选择</label> <label
								class="input col col-2" style="width:5%;"> <select id="selectionReport"
								name="selectionReport" style="height: 35px;"> <#list
									selectionDates?keys as key> <#if selectionDate??> <#if
									key==selectionDate>
									<option value="${key}" selected="selected">${selectionDates[key]}</option>
									<#else>
									<option value="${key}">${selectionDates[key]}</option> </#if>
									<#else>
									<option value="${key}">${selectionDates[key]}</option> </#if>
									</#list>
							</select>
							</label>
							<label id="timeSty">
								<label class="input col col-1">开始时间</label> <label
									class="input col col-2"><input id="startTime"
									name="startTime" style="height: 35px;"
									value="${((startTime)?string('yyyy-MM-dd'))!''}" type="text"
									class="ui_input_text 400w"
									onclick="WdatePicker({dateFmt:'yyyy-MM-dd',maxDate:'#F{$dp.$D(\'endTime\')}'});"
									placeholder="开始时间" /> </label> <label class="input col col-1">结束时间 </label>
								<label class="input col col-2"><input id="endTime"
									name="endTime" style="height: 35px;"
									value="${((endTime)?string('yyyy-MM-dd'))!''}" type="text"
									class="ui_input_text 400w"
									onclick="WdatePicker({dateFmt:'yyyy-MM-dd',minDate:'#F{$dp.$D(\'startTime\')}'});"
									placeholder="结束时间" /> </label> 
							</label>
								坐席号 <input type="text" id="name" name="name" style="height: 35px;" value="${name!''}"  />
							<button class="btn btn-primary" id="dosearch">查询</button>
							<button class="btn btn-success" id="export">导出数据</button>
						</div>
						<div class="smart-form">
							<table id="reportagentkpiTable"
								class="table table-striped table-hover">
							</table>
						</div>
						<input type="hidden" id="js" name="js" value="" />
					</div>
				</div>
			</div>
		</article>
	</div>

	<div id="reportagentkpiforModel"></div>
</section>




<script type="application/javascript">
	

    var oTable ='';

    $(document).ready(function() {
    	$("#selectionReport").select2({
    		width:"100%"
    	})
//         pageSetUp();
//         gettitleshow();
        initTable();
    });
    
    function gettitleshow(){
    	var url=getContext() + "report/reportagentkpi/menushow"
    	$.post(url,function(data){
     		$("#titleshow").html(data.titleshow);
    	},'json');
    }
    
    $("#selectionReport").change(function (){
    	var selectionReport=$("#selectionReport").val();
    	if (selectionReport=='1') {
    		$("#timeSty").empty();
    		var sb="<label class='input col col-1'>开始时间</label> <label class='input col col-2'> <input id='startTime' name='startTime' style='height:35px;' value='${((startTime)?string('yyyy'))!''}' type='text' class='ui_input_text 400w'  onclick=\"WdatePicker({dateFmt:'yyyy',maxDate:'#F{$dp.$D(\\'endTime\\')}'});\" placeholder='选择年份'/></label>";
    		sb+="<label class='input col col-1'>结束时间</label> <label class='input col col-2'> <input id='endTime' name='endTime' style='height:35px;' value='${((endTime)?string('yyyy'))!''}' type='text' class='ui_input_text 400w'  onclick=\"WdatePicker({dateFmt:'yyyy',minDate:'#F{$dp.$D(\\'startTime\\')}'});\" placeholder='选择年份'/></label>";
    		$("#timeSty").append(sb);
    		refresh();
		}else if(selectionReport=='2'){
			$("#timeSty").empty();
			var sb="<label class='input col col-1'>开始时间</label> <label class='input col col-2'> <input id='startTime' name='startTime' style='height:35px;' value='${((startTime)?string('yyyy-MM'))!''}' type='text' class='ui_input_text 400w'  onclick=\"WdatePicker({dateFmt:'yyyy-MM',maxDate:'#F{$dp.$D(\\'endTime\\')}'});\" placeholder='选择年月'/></label>";
    		sb+="<label class='input col col-1'>结束时间</label> <label class='input col col-2'> <input id='endTime' name='endTime' style='height:35px;' value='${((endTime)?string('yyyy-MM'))!''}' type='text' class='ui_input_text 400w'  onclick=\"WdatePicker({dateFmt:'yyyy-MM',minDate:'#F{$dp.$D(\\'startTime\\')}'});\" placeholder='选择年月'/></label>";
    		$("#timeSty").append(sb);
    		refresh();
		}else if(selectionReport=='4'){
			$("#timeSty").empty();
			var sb="<label class='input col col-1'>开始时间</label> <label class='input col col-2'> <input id='startTime' name='startTime' style='height:35px;' value='${((startTime)?string('yyyy-MM-dd'))!''}' type='text' class='ui_input_text 400w'  onclick=\"WdatePicker({dateFmt:'yyyy-MM-dd',maxDate:'#F{$dp.$D(\\'endTime\\')}'});\" placeholder='选择时间'/></label>";
    		sb+="<label class='input col col-1'>结束时间</label> <label class='input col col-2'> <input id='endTime' name='endTime' style='height:35px;' value='${((endTime)?string('yyyy-MM-dd'))!''}' type='text' class='ui_input_text 400w'  onclick=\"WdatePicker({dateFmt:'yyyy-MM-dd',minDate:'#F{$dp.$D(\\'startTime\\')}'});\" placeholder='选择时间'/></label>";
    		$("#timeSty").append(sb);
    		refresh();
		}else if(selectionReport=='5'){
			$("#timeSty").empty();
			var sb="<label class='input col col-1'>开始时间</label> <label class='input col col-2'> <input id='startTime' name='startTime' style='height:35px;' value='${((startTime)?string('yyyy-MM-dd'))!''}' type='text' class='ui_input_text 400w'  onclick=\"WdatePicker({dateFmt:'yyyy-MM-dd',maxDate:'#F{$dp.$D(\\'endTime\\')}'});\" placeholder='选择时间'/></label>";
    		sb+="<label class='input col col-1'>结束时间</label> <label class='input col col-2'> <input id='endTime' name='endTime'  style='height:35px;' value='${((endTime)?string('yyyy-MM-dd'))!''}' type='text' class='ui_input_text 400w'  onclick=\"WdatePicker({dateFmt:'yyyy-MM-dd',minDate:'#F{$dp.$D(\\'startTime\\')}'});\" placeholder='选择时间'/></label>";
    		$("#timeSty").append(sb);
    		refresh();
		}
    });
    
    
    
    function GetDateDiff(sDate1, sDate2){ 
		var aDate, oDate1, oDate2, iDays;
	    aDate = sDate1.split("-");
	    oDate1 = new Date(aDate[1] + '-' + aDate[2] + '-' + aDate[0]);  //转换为yyyy-MM-dd格式
	    aDate = sDate2.split("-");
	    oDate2 = new Date(aDate[1] + '-' + aDate[2] + '-' + aDate[0]);
	    iDays = parseInt(Math.abs(oDate1 - oDate2) / 1000 / 60 / 60 / 24); //把相差的毫秒数转换为天数
	    return iDays;  // 返回相差天数
	}
    
    function GetDateDiffaa(sDate1, sDate2){ 
		var aDate, oDate1, oDate2, iDays;
	    aDate = sDate1.split("-");
	    oDate1 = new Date(aDate[0] + '-' + aDate[1]);  //转换为yyyy-MM-dd格式
	    aDate = sDate2.split("-");
	    oDate2 = new Date(aDate[0] + '-' + aDate[1]);
	    iDays = parseInt(Math.abs(oDate1 - oDate2) / 1000 / 60 / 60 / 24); //把相差的毫秒数转换为天数
	    return iDays;  // 返回相差天数
	}
    
   
    $("#dosearch").click(function (){
    	
    	
    	var stime = $("#startTime").val();
		var etime = $("#endTime").val();     	
		var c = new Date();
    	var selectionReport = $("#selectionReport").val();
    	if (selectionReport == '1') {
    		if(stime == ''){
				$("#startTime").val(c.format("yyyy"));
			}
			if(etime == ''){
				$("#endTime").val(c.format("yyyy"));
			}
			if((etime - stime) > 0){
				alert("请选择当年内的时间进行查询！！");
				return false;
			}
    	}else if(selectionReport == '2'){
    		if(stime == ''){
				$("#startTime").val(c.format("yyyy-MM"));
			};
			if(etime == ''){
				$("#endTime").val(c.format("yyyy-MM"));
			}
			if(GetDateDiffaa(stime, etime) > 366){
				alert("请选择12个月以内的时间进行查询！！");
				return false;
			}
    	}else if(selectionReport == '4'){
    		if(stime == ''){
				$("#startTime").val(c.format("yyyy-MM-dd"));
			};
			if(etime == ''){
				$("#endTime").val(c.format("yyyy-MM-dd"));
			}
			if(GetDateDiff(stime, etime) > 30){
				alert("请选择一个月以内的时间进行查询！！");
				return false;
			}
    	}
    	
    	
    	oTable.DataTable().ajax.reload(null,false);;
    });
    
    function getResult(){
    	refresh();
    }
    
    function refresh(){
    	oTable.DataTable().ajax.reload(null,false);;
    }

    function initTable(){
        
        oTable = $('#reportagentkpiTable').dataTable({
	    	"dom" :"t" + "<'dt-toolbar-footer'<'col-sm-6 col-xs-12'i><'col-xs-12 col-sm-6 text-right'lp>>",
			"autoWidth" : true,
			"ordering" : true,
			"serverSide" : true,
			"processing" : true,
			"searching" : false,
			"pageLength" : 10,
			"lengthMenu" : [ 10, 15, 20, 25, 30 ],
		 	"language": {
		         "url" : getContext() + "public/dataTables.cn.txt"
		     },
		    "ajax":{
		    	"url" : getContext() + "report/reportagentkpi/data",
		    	"type":"POST",
		    	"data" :function(param){
		    		param.selectionReport = $("#selectionReport").val(),
		    		param.startTime = $("#startTime").val(),
		    		param.endTime = $("#endTime").val(),
		    		param.name = $("#name").val()
		    	}
		    },
		 	"paging" :true,
			"pagingType" :"bootstrap",
			"lengthChange" : true,
			"order" : [[ "0", "desc"]],
			"columns" : [
				   { "title" : "时间", "data" : "timestamp"},
				   { "title" : "坐席号", "data" : "name"},
				   { "title" : "在线时长", "data" : "online_time"},
				   { "title" : "总评分", "data" : "score_sum"},
				   { "title" : "平均评分", "data" : "score_avg"},
				   	<#if state_1??><#if (state_1=="1")>
				   		{ "title" : "置忙时长1(${name_1})", "data" : "busy_1"},
				   	</#if></#if>
				   	<#if state_2??><#if (state_2=="1")>
				   		{ "title" : "置忙时长2(${name_2})", "data" : "busy_2"},
				   	</#if></#if>
				   	<#if state_3??><#if (state_3=="1")>
				   		{ "title" : "置忙时长3(${name_3})", "data" : "busy_3"},
				   	</#if></#if>
				   	<#if state_4??><#if (state_4=="1")>
			   			{ "title" : "置忙时长4(${name_4})", "data" : "busy_4"},
			   	   	</#if></#if>
			   	   	<#if state_5??><#if (state_5=="1")>
			   	 		{ "title" : "置忙时长5(${name_5})", "data" : "busy_5"},
					</#if></#if>
					<#if state_6??><#if (state_6=="1")>
						{ "title" : "置忙时长6(${name_6})", "data" : "busy_6"},
					</#if></#if>
					<#if state_7??><#if (state_7=="1")>
						{ "title" : "置忙时长7(${name_7})", "data" : "busy_7"},
					</#if></#if>
					<#if state_8??><#if (state_8=="1")>
						{ "title" : "置忙时长8(${name_8})", "data" : "busy_8"},
					</#if></#if>
					<#if state_9??><#if (state_9=="1")>
						{ "title" : "置忙时长9(${name_9})", "data" : "busy_9"},
					</#if></#if>
					<#if state_10??><#if (state_10=="1")>
						{ "title" : "置忙时长10(${name_10})", "data" : "busy_10"}
					</#if></#if>
			],
		});
        
    }
  $("#export").click(function(){
	    
		var url = getContext()+"report/reportagentkpi/export?";
    	var selectionReport = $("#selectionReport").val();
    	var startTime = $("#startTime").val();
    	var endTime = $("#endTime").val();
    	var name = $("#name").val();
    	
    	if(selectionReport!= null && selectionReport!=''){url += "&selectionReport=" + selectionReport ;}
    	if(startTime!= null && startTime!=''){url += "&startTime=" + startTime ;}
    	if(endTime!= null && endTime!=''){url += "&endTime=" + endTime ;}
    	if(name!= null && name!=''){url += "&name=" + name ;}
    	
    	window.location.href=url;
	})

</script>