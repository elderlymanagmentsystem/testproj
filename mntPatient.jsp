<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="ems.bean.PcoBean,ems.bean.PatGrpBean,ems.bean.TransBean,ems.bean.ResBean,ems.bean.QuoBean,ems.bean.ZoneBean,ems.bean.BedBean,ems.bean.PatBean,ems.bean.UserBean,ems.bean.LivBean,ems.bean.FuncBean,ems.db.EmsDB,java.math.BigDecimal,ems.util.EmsCommonUtil" import="java.util.ArrayList"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<!DOCTYPE html>
<html>
<title>EMS</title>
<head>
	<%@ include file="/jsp/INC/inc-head.jsp" %>
	<link rel="stylesheet" type="text/css" href="/EMS/css/flatpickr.min.css">
	<script src="/EMS/js/flatpickr.min.js"></script>
	<script src="/EMS/js/flatpickr-zh.js"></script>
	<script src="/EMS/js/calendar.min.js"></script>
</head>

<style>
.flex-container {
  display: flex;
  flex-wrap: wrap;
  background-color: #f1f1f1;
}

.flex-container > div, .fcontainer {
  background-color: Gainsboro ;
  color: black;
  width: 140px;
  margin: 4px;
}

@media only screen and (max-width: 600px) {
    table[id$='ScreenTable'] td {display: table-row;}
    table[id$='ScreenTable'] td:nth-child(even) {font-size:80%; color:blue; font-weight: bold;}
    table[id$='ScreenTable'] {border-collapse: separate; border:1px solid transparent;}
    input[type=text]:not(.search),input[type=password],textarea {min-width:280px}
}
table[id$='ScreenTable'] td:nth-child(odd) {white-space: nowrap}

@media only screen and (max-width: 768px) {
    #bedContainer {width:100%!important;}
    #patientContainer{z-index: 0;position: fixed;top: 20%;left: calc(50% - 165px);word-wrap: break-word;height:60%;display:none;box-shadow: 5px 5px 7px rgba(0, 0, 0, 0.7);}
    #resButton{display:block!important;}
}
#patientContainerTable td:nth-child(odd) {white-space: nowrap}

table[id$='ListTable'] {
	border-collapse: collapse; width:100%;
}
table[id$='ListTable'] tr:not(:first-child){
	cursor:pointer; background-color: WhiteSmoke; border-top: 5px solid white;
}
table[id$='ListTable'] tr:not(:first-child):hover,active{
	background-color: silver!important;
}
table[id$='ListTable'] td {white-space: nowrap; padding: 0 8px;}
</style>
<%
	PatGrpBean patGrpBean = new PatGrpBean();
	if (request.getAttribute("patGrpBean") !=null) 
		patGrpBean = (PatGrpBean) request.getAttribute("patGrpBean"); 

	UserBean userBean = (UserBean) session.getAttribute("userBean");
	ArrayList<OrgBean> accOrgBeanList = userBean.getAccOrgBeanList();
	ArrayList<ZoneBean> zoneBeanList = patGrpBean.getZoneBeanList();
	ArrayList<PatBean> patBeanList = patGrpBean.getPatBeanList();
	ArrayList<ResBean> reserveBeanList = new ArrayList<ResBean>();
	if(patGrpBean.getResGrpBean() !=null && patGrpBean.getResGrpBean().getReserveBeanList() !=null)
		reserveBeanList = patGrpBean.getResGrpBean().getReserveBeanList();
	ArrayList<QuoBean> quoteBeanList = new ArrayList<QuoBean>();
	if(patGrpBean.getQuoGrpBean() !=null && patGrpBean.getQuoGrpBean().getQuoteBeanList() !=null)
		quoteBeanList = patGrpBean.getQuoGrpBean().getQuoteBeanList();
	
	String funcId = (String) request.getAttribute("funcId");
	String enqFuncId = funcId.substring(0,4) + EmsDB.FUNC_ENQ;
	String addFuncId = funcId.substring(0,4) + EmsDB.FUNC_ADD;
	String modFuncId = funcId.substring(0,4) + EmsDB.FUNC_MOD;
	String delFuncId = funcId.substring(0,4) + EmsDB.FUNC_DEL;

%>
<body>

<!-- Menu-->
<%@ include file="/jsp/INC/inc-menu.jsp" %>

<!-- CONTENT START -->
<div class="w3-main" style="margin-left:200px">

<form name="mntPatient" action="mntPatient" method="post">
	<!-- Banner -->
	<%@ include file="/jsp/INC/inc-banner.jsp" %>
	<input type="hidden" name="funcId" value="<%=enqFuncId %>">
</form>
	
	<!-- overlay -->
	<div class="w3-overlay w3-opacity" id="myOverlay" onclick="w3_close()"></div>
	
	<!-- CONTENT -->
	<div class="w3-panel w3-large">
		<!-- Confirm Message -->
		<%@ include file="/jsp/INC/inc-confirmMessage.jsp" %>
		<div id="enqScreen">
			<div class="color1" style="position:relative; padding:4px; display:block" >
			<form name="mntPatient" action="mntPatient" method="post">
				<a class="mc-button color3 w3-right" onclick="showScreen('addDetailScreen');"><i class="fas fa-user-plus"></i>新入住</a>
				<span class="input-container">
			   		<a class="icon"><i class="fas fa-filter fa-fw"></i></a>
			   		<select name="patGrpBean.enqPatType" style="width:150px;">
						<% if(patGrpBean.getEnqPatType().equals("B")){ %>
							<option value="B" selected>床位名稱</option>
						<% }else{ %>
							<option value="B">床位名稱</option>
						<% } %>
						<% if(patGrpBean.getEnqPatType().equals("N")){ %>
							<option value="N" selected>院友姓名</option>
						<% }else{ %>
							<option value="N">院友姓名</option>
						<% } %>
						<% if(patGrpBean.getEnqPatType().equals("S")){ %>
							<option value="S" selected>院友編號</option>
						<% }else{ %>
							<option value="S">院友編號</option>
						<% } %>
						<% if(patGrpBean.getEnqPatType().equals("I")){ %>
							<option value="I" selected>身份證號碼</option>
						<% }else{ %>
							<option value="I">身份證號碼</option>
						<% } %>						   		
					</select>
				</span>
				<span class="input-container"  class="mc-fw">
					<a class="icon"><i class="fas fa-keyboard fa-fw"></i></a>
					<input class="search" type="text" name="patGrpBean.enqPatName" value="<%= patGrpBean.getEnqPatName() %>" maxlength="50" size="18"> 
				</span>
				<a class="mc-button color4" onclick="document.forms[1].submit();"><i class="fas fa-search"></i>搜索</a>
				<input type="hidden" name="funcId" value="<%=enqFuncId %>">
			</form>	
			</div>
		
			<div id="bedContainer" class="w3-left" style="width:calc(100% - 340px);">
			<%  if(patBeanList.size()>0){
			%>
				<div id="bedContainer1" class="w3-panel w3-padding-small" style="border:1px solid silver">
				<div class="flex-container w3-left" style="width:100%;">
			<% 
					for(int i=0;i<patBeanList.size();i++){ 
						PatBean patBean = patBeanList.get(i);
						BedBean bedBean = new BedBean();
						if(patBean.getLivBeanList().size()>0){
							bedBean = patBean.getLivBeanList().get(0).getBedBean();
						}
			%>
					
						<div>
							<div class="color2"><%= bedBean.getBedName() %><span class="w3-right"><% if(patBean.getField("PER_GENDER").getFormValue().equals("M")){ %><i class="fas fa-male w3-text-light-blue fa-fw"></i><% } %><% if(patBean.getField("PER_GENDER").getFormValue().equals("F")){ %><i class="fas fa-female w3-text-red fa-fw"></i><% } %></span></div>
							<% if(patBean!=null && patBean.getPatId().length()>0){ %><a class="mc-resblk-btn" ondblclick="showScreen('enqDetailScreen')" onclick="openPatientContainer(); getAjaxData(<%= patBean.getPatId() %>);"><%= patBean.getField("PER_CHI_NAME").getFormValue() %>&nbsp;</a><% } else { %><a class="mc-resblk-btn">&nbsp;</a><%} %>
						</div>
			   
			<%      } %>
				</div>
				</div>

			<% 
			   }else if(zoneBeanList.size()>0){ 
					for(int i=0;i<zoneBeanList.size();i++){ 
						ZoneBean zoneBean = zoneBeanList.get(i);
			%>
						<div id="bedContainer<%= i+1 %>" class="w3-panel w3-padding-small" style="border:1px solid silver">
							<span class="w3-xlarge"><%= zoneBeanList.get(i).getZoneName() %></span>
							<% if(zoneBean.getBedBeanList().size()>0){ %>
							<div class="flex-container w3-left" style="width:100%;">
							<% for(int j=0;j<zoneBean.getBedBeanList().size();j++){ 
								BedBean bedBean = zoneBean.getBedBeanList().get(j);
								PatBean patBean = new PatBean();
								if(bedBean.getLivBeanList()!=null && bedBean.getLivBeanList().size()>0 && bedBean.getLivBeanList().get(0).getPatBean() !=null){ 
									patBean = bedBean.getLivBeanList().get(0).getPatBean();
								}
							%>
								<div>
									<div class="color2"><%= bedBean.getBedName() %><span class="w3-right"><% if(patBean.getField("PER_GENDER").getFormValue().equals("M")){ %><i class="fas fa-male w3-text-light-blue fa-fw"></i><% } %><% if(patBean.getField("PER_GENDER").getFormValue().equals("F")){ %><i class="fas fa-female w3-text-red fa-fw"></i><% } %></span></div>
									<% if(patBean!=null && patBean.getPatId().length()>0){ %><a class="mc-resblk-btn" ondblclick="showScreen('enqDetailScreen')" onclick="openPatientContainer(); getAjaxData(<%= patBean.getPatId() %>);"><%= patBean.getField("PER_CHI_NAME").getFormValue() %>&nbsp;</a><% } else { %><a class="mc-resblk-btn">&nbsp;</a><%} %>
								</div>
							<% } %>	
							</div>
							<% } %>
						</div>

			<%		}
			   }else{ %>
				<div id="bedContainer1" class="w3-panel w3-padding-small" style="border:1px solid silver">
				<div class="flex-container w3-left w3-xlarge" style="width:100%">
				沒有資料
				</div>
				</div>
			<%  } %>
			</div>
			
			<div id="patientContainer" class="w3-panel w3-padding-small w3-right w3-white" style="width:330px; border:1px solid silver;">
				<table style="width:100%" class="color1">
		  			<col width="15%">
					<col width="70%">
					<col width="15%">
		  			<tr>
		  				<td><a class="mc-button w3-transparent" style="display:none;" onclick="closePatientContainer()" id="resButton">&times;</a></td>
		  				<td class="w3-center">院友基本資料</td>
		  				<td><a class="mc-button color4" onclick="if(document.getElementById('briefPAT_ID').innerHTML!='-'){showScreen('enqDetailScreen');}"><i class="fas fa-file-alt"></i>詳細</a></td>
		  			</tr>
		  		</table>
		  		<div style="overflow-y: auto; height:calc(100% - 40px); display:none;" id="patientContainerLoading">
		  			<table style="width:100%; height:450px; background-color: #f1f1f1;">
		  				<tr>
					    	<td class="w3-center"><span id="patientContainerMsg"></span></td>
					    </tr>
		  			</table>		  		
		  		</div>
		  		<div style="overflow-y: auto; height:calc(100% - 40px); display:block;" id="patientContainerContent">
					<table style="width:100%; height:450px; background-color: #f1f1f1;" id="patientContainerTable">
					  <tr>
					  	<td colspan="2" class="w3-center"><span id="briefPER_IMAGE_LINK"></span></td>
					  </tr>
					  <tr>
					    <td>院友編號</td>
					    <td><span id="briefPAT_ID">-</span></td>
					  </tr>
					  <tr>
					    <td class="mc-bold">姓名</td>
					    <td class="mc-bold"><span id="briefPER_CHI_NAME">-</span></td>
					  </tr>
					  <tr>
					    <td class="mc-bold">床位</td>
					    <td class="mc-bold"><span id="briefBED_FULL_NAME">-</span></td>
					  </tr>
					  <tr>
					    <td>性別</td>
					    <td><span id="briefPER_GENDER">-</span></td>
					  </tr>
					  <tr>
					    <td>身份證號碼</td>
					    <td><span id="briefPER_HKID">-</span></td>
					  </tr>
					  <tr>
					    <td>出生日期</td>
					    <td><span id="briefPER_NBIRTH">-</span></td>
					  </tr>
					  <tr>
					    <td>入住日期</td>
					    <td><span id="briefLIV_START_DATE">-</span></td>
					  </tr>
					  <tr>
					    <td>保證人姓名</td>
					    <td><span id="briefPCO_CHI_NAME">-</span></td>
					  </tr>
					  <tr>
					    <td>保證人關係</td>
					    <td><span id="briefPCO_RELATION">-</span></td>
					  </tr>
					  <tr>
					    <td>保證人電話</td>
					    <td><span id="briefPCO_TEL">-</span></td>
					  </tr>
					  <tr>
					    <td>狀態</td>
					    <td><span id="briefLIV_STATUS">-</span></td>
					  </tr>
					</table>
				</div>
			</div>
		</div>
		
		<form name="mntPatient" action="mntPatient" method="post" enctype="multipart/form-data">
		<div style="display:none" id="addDetailScreen">

			<div class="w3-bar">
				<a class="w3-bar-item w3-button color1 mc-tabBtn" id="addTabBtn1" onclick="switchTabPage('add',1)"><i class="fas fa-file-alt fa-fw"></i></a>
				<a class="w3-bar-item w3-button w3-grey mc-tabBtn" id="addTabBtn2" onclick="switchTabPage('add',2)"><i class="fas fa-copy fa-fw"></i></a>
				<a class="w3-bar-item w3-button w3-grey mc-tabBtn" id="addTabBtn3" onclick="switchTabPage('add',3)"><i class="fas fa-user-friends fa-fw"></i></a>
				<a class="w3-bar-item w3-button w3-grey mc-tabBtn" id="addTabBtn4" onclick="switchTabPage('add',4)"><i class="fas fa-file-invoice-dollar fa-fw"></i></a>
				
			</div>
			<%
			  	QuoBean quoBean = new QuoBean(); 
			  	if(patGrpBean.getQuoBeanList().size()>0){
					quoBean = patGrpBean.getQuoBeanList().get(0);
			  	}
			  	ResBean resBean = new ResBean(); 
			  	if(patGrpBean.getResBeanList().size()>0){
					resBean = patGrpBean.getResBeanList().get(0);
			  	}
			%>

			<div id="addTabPage1">
				<table class="w3-table">
					<tr>
						<th class="color1 w3-xlarge">新入住 - 個人資料<span class="w3-text-red mc-italic"><%=patGrpBean.getMsg() %></span></th>
					</tr>
				</table>
				<table class="w3-table-all" id="addDetailTabPage1ScreenTable">
					<col width="10%">
					<col width="40%">
					<col width="10%">
					<col width="40%">
				<tr><td colspan="4" class="w3-xlarge mc-bold mc-underline">個人資料</td></tr>
				<tr>
			  		<td>訂位編號: <span class="w3-text-red mc-italic"></span></td>
			  		<td><input type="text" name="<%= EmsDB.EM_RES_RECORD[0][0] %>" value="<%=resBean.getField(EmsDB.EM_RES_RECORD[0][0]).getFormValue() %>" maxlength="<%= EmsDB.EM_RES_RECORD[0][3] %>" class="mc-fw" style="max-width:10em">&nbsp;<a class="mc-button color4" onclick="openReserveListScreen()"><i class="fas fa-user-clock"></i>查詢訂位資料</a></td>  
			  		<td>報價編號: <span class="w3-text-red mc-italic"></span></td>
			  		<td><input type="text" name="<%= EmsDB.EM_QUO_RECORD[0][0] %>" value="<%=quoBean.getField(EmsDB.EM_QUO_RECORD[0][0]).getFormValue() %>" maxlength="<%= EmsDB.EM_QUO_RECORD[0][3] %>" class="mc-fw" style="max-width:10em">&nbsp;<a class="mc-button color4" onclick="openQuoteListScreen()"><i class="fas fa-user-clock"></i>查詢報價資料</a></td>  
			  	</tr>
			  	<tr>
			  		<td>中文姓名: <span class="w3-text-red mc-italic"><%=patGrpBean.getField(EmsDB.EM_PER_PERSONAL_PARTICULAR[2][0]).getMsg() %></span></td>
			  		<td><input type="text" name="<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[2][0] %>" value="<%=patGrpBean.getField(EmsDB.EM_PER_PERSONAL_PARTICULAR[2][0]).getFormValue() %>" maxlength="<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[2][3] %>" class="mc-fw" style="max-width:20em"></td> 
			  		<td>英文姓名: <span class="w3-text-red mc-italic"><%=patGrpBean.getField(EmsDB.EM_PER_PERSONAL_PARTICULAR[3][0]).getMsg() %></span></td>
			  		<td><input type="text" name="<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[3][0] %>" value="<%=patGrpBean.getField(EmsDB.EM_PER_PERSONAL_PARTICULAR[3][0]).getFormValue() %>" maxlength="<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[3][3] %>" class="mc-fw" style="max-width:20em"></td>  
			  	</tr>
			  	<tr>
			  		<td>身份證號碼:<span class="w3-text-red mc-italic"><%=patGrpBean.getField(EmsDB.EM_PER_PERSONAL_PARTICULAR[6][0]).getMsg() %></span></td>
			  		<td><input type="text" name="<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[6][0] %>" value="<%=patGrpBean.getField(EmsDB.EM_PER_PERSONAL_PARTICULAR[6][0]).getFormValue() %>" maxlength="<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[6][3] %>" class="mc-fw" style="max-width:20em" placeholder="例:A123456(7)"></td> 
			  		<td>性別: <span class="w3-text-red mc-italic"><%=patGrpBean.getField(EmsDB.EM_PER_PERSONAL_PARTICULAR[7][0]).getMsg() %></span></td>
			  		<td><select name="<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[7][0] %>" style="width:150px;">
						<% if(patGrpBean.getField(EmsDB.EM_PER_PERSONAL_PARTICULAR[7][0]).getFormValue().equals("")){ %>
							<option value="" selected></option>
						<% }else{ %>
							<option value=""></option>
						<% } %>
						<% if(patGrpBean.getField(EmsDB.EM_PER_PERSONAL_PARTICULAR[7][0]).getFormValue().equals("M")){ %>
							<option value="M" selected>男</option>
						<% }else{ %>
							<option value="M">男</option>
						<% } %>
						<% if(patGrpBean.getField(EmsDB.EM_PER_PERSONAL_PARTICULAR[7][0]).getFormValue().equals("F")){ %>
							<option value="F" selected>女</option>
						<% }else{ %>
							<option value="F">女</option>
						<% } %>
				</select></td>  
			  	</tr>
			  	<tr>
			  		<td>出生日期: <span class="w3-text-red mc-italic"><%=patGrpBean.getField(EmsDB.EM_PER_PERSONAL_PARTICULAR[4][0]).getMsg() %></span></td>
			  		<td>
			  			
			  			<div class="flatpickr date-container">
			   				<input type="text" name="<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[4][0] %>" id="add<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[4][0] %>" value="<%=patGrpBean.getField(EmsDB.EM_PER_PERSONAL_PARTICULAR[4][0]).getFormValue() %>" maxlength="<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[4][3] %>" size="12" data-input>
			   				<a class="mc-button-2 icon" data-clear>&times;</a>
						</div>
						<a class="mc-button color4" onclick="lunarToSolar('add<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[5][0] %>', 'add<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[4][0] %>')"><i class="fas fa-exchange-alt"></i>舊曆</a>
			  		</td> 
			  		<td>農曆: <span class="w3-text-red mc-italic"><%=patGrpBean.getField(EmsDB.EM_PER_PERSONAL_PARTICULAR[5][0]).getMsg() %></span></td>
			  		<td>
			  			<div class="flatpickr date-container">
		   					<input type="text" name="<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[5][0] %>" id="add<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[5][0] %>" value="<%=patGrpBean.getField(EmsDB.EM_PER_PERSONAL_PARTICULAR[5][0]).getFormValue() %>" maxlength="<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[5][3] %>" size="12" data-input>
			   				<a class="mc-button-2 icon" data-clear>&times;</a>
						</div>
						<a class="mc-button color4" onclick="solarToLunar('add<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[4][0] %>', 'add<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[5][0] %>')"><i class="fas fa-exchange-alt"></i>新曆</a>
					</td>  
			  	</tr>
			  <tr>
			  	<td><%= EmsDB.EM_PER_PERSONAL_PARTICULAR[8][1] %>: <span class="w3-text-red mc-italic"><%=patGrpBean.getField(EmsDB.EM_PER_PERSONAL_PARTICULAR[8][0]).getMsg() %></span></td>
			  	<td><input type="text" name="<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[8][0] %>" value="<%=patGrpBean.getField(EmsDB.EM_PER_PERSONAL_PARTICULAR[8][0]).getFormValue() %>" maxlength="<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[8][3] %>" class="mc-fw" style="max-width:20em"></td> 
			  	<td><%= EmsDB.EM_PER_PERSONAL_PARTICULAR[9][1] %>: <span class="w3-text-red mc-italic"><%=patGrpBean.getField(EmsDB.EM_PER_PERSONAL_PARTICULAR[9][0]).getMsg() %></span></td>
			  	<td><input type="text" name="<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[9][0] %>" value="<%=patGrpBean.getField(EmsDB.EM_PER_PERSONAL_PARTICULAR[9][0]).getFormValue() %>" maxlength="<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[9][3] %>" class="mc-fw" style="max-width:20em"></td>
			  </tr>
			  <tr>
			  	<td><%= EmsDB.EM_PER_PERSONAL_PARTICULAR[10][1] %>: <span class="w3-text-red mc-italic"><%=patGrpBean.getField(EmsDB.EM_PER_PERSONAL_PARTICULAR[10][0]).getMsg() %></span></td>
			  	<td><textarea name="<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[10][0] %>" rows="4" class="mc-fw" style="max-width:20em"><%=patGrpBean.getField(EmsDB.EM_PER_PERSONAL_PARTICULAR[10][0]).getFormValue() %></textarea></td> 
			  	<td><%= EmsDB.EM_PER_PERSONAL_PARTICULAR[12][1] %>: <span class="w3-text-red mc-italic" id="imageErrMsg1"><%=patGrpBean.getField(EmsDB.EM_PER_PERSONAL_PARTICULAR[12][0]).getMsg() %></span></td>
			  	<td>
			  		<% if(patGrpBean.getField(EmsDB.EM_PER_PERSONAL_PARTICULAR[12][0]).getFormValue().length()>0){ %>
			  		<img src="/EMS/images/<%= patGrpBean.getField(EmsDB.EM_PER_PERSONAL_PARTICULAR[12][0]).getFormValue() %>" class="mc-img">
			  		<% } %>
			  		<input type="file" name="fileUpload" accept="image/jpeg" onchange="validateFileType(this,'imageErrMsg1')" style="max-width:200px"><input type="hidden" name="PER_IMAGE_LINK" value="<%=patGrpBean.getField(EmsDB.EM_PER_PERSONAL_PARTICULAR[12][0]).getFormValue()%>">
			  	</td>
			  </tr>
			</table>
			</div>
			
			<div id="addTabPage2" style="display:none">
				<table class="w3-table">
					<tr>
						<th class="color1 w3-xlarge">新入住 - 其他資料</th>
					</tr>
				</table>
				<table class="w3-table-all" id="addDetailTabPage2ScreenTable">
					<col width="10%">
					<col width="40%">
					<col width="10%">
					<col width="40%">
				  	<tr><td colspan="4" class="w3-xlarge mc-bold mc-underline">床位資料</td></tr>
			  <%	LivBean livBean = new LivBean(); 
			  	if(patGrpBean.getLivBeanList().size()>0){
					livBean = patGrpBean.getLivBeanList().get(0);
			  	}
				  %>
			  
			  	<tr>
			  		<td>床號: <span class="w3-text-red mc-italic"><%=livBean.getField(EmsDB.EM_LIV_RECORD[2][0]).getMsg() %></span></td>
			  		<td>
			  			<select name="<%= EmsDB.EM_LIV_RECORD[2][0] %>">
			  				<option value=""></option>
						<% 
						for(int i=0;i<zoneBeanList.size();i++){ 
								for(int j=0;j<zoneBeanList.get(i).getBedBeanList().size();j++){
									BedBean bedBean = zoneBeanList.get(i).getBedBeanList().get(j);
									if(bedBean.getLivBeanList()==null || bedBean.getLivBeanList().size()==0 ){
										if(bedBean.getZoneId().equals(livBean.getZoneId()) && bedBean.getBedId().equals(livBean.getBedId())){
						%>
			  				<option value="<%= bedBean.getZoneId() %>-<%= bedBean.getBedId() %>" selected><%= bedBean.getBedFullName() %></option>
						<% 				}else{	%>
							<option value="<%= bedBean.getZoneId() %>-<%= bedBean.getBedId() %>"><%= bedBean.getBedFullName() %></option>
						<% 				}
									}
								}
							}
						%>
			  			</select>
			  		</td> 
			  		<td>床位類別: <span class="w3-text-red mc-italic"><%=livBean.getField(EmsDB.EM_LIV_RECORD[9][0]).getMsg() %></span></td>
			  		<td>
			  			<select name="<%= EmsDB.EM_LIV_RECORD[9][0] %>">
						<% if(livBean.getField(EmsDB.EM_LIV_RECORD[9][0]).getFormValue().equals("")){ %>
			  				<option value="" selected></option>
			  			<% }else{ %>
			  				<option value=""></option>
			  			<% } %>
						<% if(livBean.getField(EmsDB.EM_LIV_RECORD[9][0]).getFormValue().equals("A")){ %>
			  				<option value="A" selected>院舍卷</option>
			  			<% }else{ %>
			  				<option value="A">院舍卷</option>
			  			<% } %>
						<% if(livBean.getField(EmsDB.EM_LIV_RECORD[9][0]).getFormValue().equals("B")){ %>
			  				<option value="B" selected>資助住宿暫托照顧服務</option>
			  			<% }else{ %>
			  				<option value="B">資助住宿暫托照顧服務</option>
			  			<% } %>
						<% if(livBean.getField(EmsDB.EM_LIV_RECORD[9][0]).getFormValue().equals("C")){ %>
			  				<option value="C" selected>非資助住宿暫托照顧服務</option>
			  			<% }else{ %>
			  				<option value="C">非資助住宿暫托照顧服務</option>
			  			<% } %>
						<% if(livBean.getField(EmsDB.EM_LIV_RECORD[9][0]).getFormValue().equals("D")){ %>
			  				<option value="D" selected>資助安老宿位</option>
			  			<% }else{ %>
			  				<option value="D">資助安老宿位</option>
			  			<% } %>
						<% if(livBean.getField(EmsDB.EM_LIV_RECORD[9][0]).getFormValue().equals("E")){ %>
			  				<option value="E" selected>非資助安老宿位</option>
			  			<% }else{ %>
			  				<option value="E">非資助安老宿位</option>
			  			<% } %>
						<% if(livBean.getField(EmsDB.EM_LIV_RECORD[9][0]).getFormValue().equals("F")){ %>
			  				<option value="F" selected>私位</option>
			  			<% }else{ %>
			  				<option value="F">私位</option>
			  			<% } %>
						<% if(livBean.getField(EmsDB.EM_LIV_RECORD[9][0]).getFormValue().equals("G")){ %>
			  				<option value="G" selected>買位</option>
			  			<% }else{ %>
			  				<option value="G">買位</option>
			  			<% } %>
						<% if(livBean.getField(EmsDB.EM_LIV_RECORD[9][0]).getFormValue().equals("H")){ %>
			  				<option value="H" selected>長老院舍住宿照顧服務卷</option>
			  			<% }else{ %>
			  				<option value="H">長老院舍住宿照顧服務卷</option>
			  			<% } %>
						<% if(livBean.getField(EmsDB.EM_LIV_RECORD[9][0]).getFormValue().equals("I")){ %>
			  				<option value="I" selected>離院照顧(醫社合作)</option>
			  			<% }else{ %>
			  				<option value="I">離院照顧(醫社合作)</option>
			  			<% } %>
			  				
			  			</select>
			  		</td>  
			  	</tr>
			  	<tr>
			  		<td>入住日期: <span class="w3-text-red mc-italic"><%=livBean.getField(EmsDB.EM_LIV_RECORD[5][0]).getMsg() %></span></td>
			  		<td>
			  			<div class="flatpickr date-container">
		   					<input type="text" name="<%= EmsDB.EM_LIV_RECORD[5][0] %>" value="<%=livBean.getField(EmsDB.EM_LIV_RECORD[5][0]).getFormValue() %>" maxlength="<%=livBean.getField(EmsDB.EM_LIV_RECORD[5][3]) %>" size="12" data-input>
		   					<a class="mc-button-2 icon" data-clear>&times;</a>
						</div>
			  		</td> 
				  	<td><%= EmsDB.EM_LIV_RECORD[7][1] %>: <span class="w3-text-red mc-italic"><%=livBean.getField(EmsDB.EM_LIV_RECORD[7][0]).getMsg() %></span></td>
				  	<td><input type="text" name="<%= EmsDB.EM_LIV_RECORD[7][0] %>" value="<%=livBean.getField(EmsDB.EM_LIV_RECORD[7][0]).getFormValue() %>" maxlength="<%= EmsDB.EM_LIV_RECORD[7][3] %>" class="mc-fw" style="max-width:10em">(港幣)</td>
			  	</tr>
			  	<tr>
				  	<td><%= EmsDB.EM_LIV_RECORD[8][1] %>: <span class="w3-text-red mc-italic"><%=livBean.getField(EmsDB.EM_LIV_RECORD[8][0]).getMsg() %></span></td>
				  	<td colspan="3"><input type="text" name="<%= EmsDB.EM_LIV_RECORD[8][0] %>" value="<%=livBean.getField(EmsDB.EM_LIV_RECORD[8][0]).getFormValue() %>" maxlength="<%= EmsDB.EM_LIV_RECORD[8][3] %>" class="mc-fw" style="max-width:10em">(港幣)</td>
			  	</tr>
			  	<tr><td colspan="4" class="w3-xlarge mc-bold mc-underline">評核資料</td></tr>
			  	<tr>
			  		<td>LDS編號: <span class="w3-text-red mc-italic"><%=patGrpBean.getField(EmsDB.EM_PER_PERSONAL_PARTICULAR[13][0]).getMsg() %></span></td>
			  		<td><input type="text" name="<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[13][0] %>" value="<%=patGrpBean.getField(EmsDB.EM_PER_PERSONAL_PARTICULAR[13][0]).getFormValue() %>" maxlength="<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[13][3] %>" class="mc-fw" style="max-width:10em"></td> 
			  		<td>評核結果: <span class="w3-text-red mc-italic"><%=patGrpBean.getField(EmsDB.EM_PER_PERSONAL_PARTICULAR[14][0]).getMsg() %></span></td>
			  		<td><select name="<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[14][0] %>" style="width:150px;">
						<% if(patGrpBean.getField(EmsDB.EM_PER_PERSONAL_PARTICULAR[14][0]).getFormValue().equals("")){ %>
							<option value="" selected></option>
						<% }else{ %>
							<option value=""></option>
						<% } %>
						<% if(patGrpBean.getField(EmsDB.EM_PER_PERSONAL_PARTICULAR[14][0]).getFormValue().equals("未評核")){ %>
							<option value="未評核" selected>未評核</option>
						<% }else{ %>
							<option value="未評核">未評核</option>
						<% } %>
						<% if(patGrpBean.getField(EmsDB.EM_PER_PERSONAL_PARTICULAR[14][0]).getFormValue().equals("中度機能受損")){ %>
							<option value="中度機能受損" selected>中度機能受損</option>
						<% }else{ %>
							<option value="中度機能受損">中度機能受損</option>
						<% } %>
						<% if(patGrpBean.getField(EmsDB.EM_PER_PERSONAL_PARTICULAR[14][0]).getFormValue().equals("高度機能受損")){ %>
							<option value="高度機能受損" selected>高度機能受損</option>
						<% }else{ %>
							<option value="高度機能受損">高度機能受損</option>
						<% } %>
					</select></td>  
			  	</tr>
			  	<tr>
			  		<td>評核日期: <span class="w3-text-red mc-italic"><%=patGrpBean.getField(EmsDB.EM_PER_PERSONAL_PARTICULAR[15][0]).getMsg() %></span></td>
			  		<td colspan="3"><div class="flatpickr date-container">
			   				<input type="text" name="<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[15][0] %>" id="add<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[15][0] %>" value="<%=patGrpBean.getField(EmsDB.EM_PER_PERSONAL_PARTICULAR[15][0]).getFormValue() %>" maxlength="<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[15][3] %>" size="12" data-input>
			   				<a class="mc-button-2 icon" data-clear>&times;</a>
						</div>
				  	</td> 
			  	</tr>
						<tr>
					  		<td>行動能力 <span class="w3-text-red mc-italic"><%=patGrpBean.getField(EmsDB.EM_PER_PERSONAL_PARTICULAR[16][0]).getMsg() %></span></td>
					  		<td colspan="3"><select name="<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[16][0] %>" style="width:160px">
								<% if(patGrpBean.getField(EmsDB.EM_PER_PERSONAL_PARTICULAR[16][0]).getFormValue().equals("")){ %>
					  				<option value="" selected></option>
					  			<% }else{ %>
					  				<option value=""></option>
					  			<% } %>
								<% if(patGrpBean.getField(EmsDB.EM_PER_PERSONAL_PARTICULAR[16][0]).getFormValue().equals("1")){ %>
					  				<option value="1" selected>1. 行動自如</option>
					  			<% }else{ %>
					  				<option value="1">1. 行動自如</option>
					  			<% } %>
								<% if(patGrpBean.getField(EmsDB.EM_PER_PERSONAL_PARTICULAR[16][0]).getFormValue().equals("2")){ %>
					  				<option value="2" selected>2. 需要幫助</option>
					  			<% }else{ %>
					  				<option value="2">2. 需要幫助</option>
					  			<% } %>
								<% if(patGrpBean.getField(EmsDB.EM_PER_PERSONAL_PARTICULAR[16][0]).getFormValue().equals("3")){ %>
					  				<option value="3" selected>3. 需要助行器</option>
					  			<% }else{ %>
					  				<option value="3">3. 需要助行器</option>
					  			<% } %>
								<% if(patGrpBean.getField(EmsDB.EM_PER_PERSONAL_PARTICULAR[16][0]).getFormValue().equals("4")){ %>
					  				<option value="4" selected>4. 輪椅代步</option>
					  			<% }else{ %>
					  				<option value="4">4. 輪椅代步</option>
					  			<% } %>
								<% if(patGrpBean.getField(EmsDB.EM_PER_PERSONAL_PARTICULAR[16][0]).getFormValue().equals("5")){ %>
					  				<option value="5" selected>5. 長期坐椅</option>
					  			<% }else{ %>
					  				<option value="5">5. 長期坐椅</option>
					  			<% } %>
								<% if(patGrpBean.getField(EmsDB.EM_PER_PERSONAL_PARTICULAR[16][0]).getFormValue().equals("6")){ %>
					  				<option value="6" selected>6. 長期卧床</option>
					  			<% }else{ %>
					  				<option value="6">6. 長期卧床</option>
					  			<% } %>
					  		</select></tr>
						<tr>
							<td>飲食種類</td>
					  		<td colspan="3"><select name="<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[17][0] %>" style="width:160px">
								<% if(patGrpBean.getField(EmsDB.EM_PER_PERSONAL_PARTICULAR[17][0]).getFormValue().equals("")){ %>
					  				<option value="" selected></option>
					  			<% }else{ %>
					  				<option value=""></option>
					  			<% } %>
								<% if(patGrpBean.getField(EmsDB.EM_PER_PERSONAL_PARTICULAR[17][0]).getFormValue().equals("1")){ %>
					  				<option value="1" selected>1. 正餐</option>
					  			<% }else{ %>
					  				<option value="1">1. 正餐</option>
					  			<% } %>
								<% if(patGrpBean.getField(EmsDB.EM_PER_PERSONAL_PARTICULAR[17][0]).getFormValue().equals("2")){ %>
					  				<option value="2" selected>2. 碎餐</option>
					  			<% }else{ %>
					  				<option value="2">2. 碎餐</option>
					  			<% } %>
								<% if(patGrpBean.getField(EmsDB.EM_PER_PERSONAL_PARTICULAR[17][0]).getFormValue().equals("3")){ %>
					  				<option value="3" selected>3. 餬餐</option>
					  			<% }else{ %>
					  				<option value="3">3. 餬餐</option>
					  			<% } %>
								<% if(patGrpBean.getField(EmsDB.EM_PER_PERSONAL_PARTICULAR[17][0]).getFormValue().equals("4")){ %>
					  				<option value="4" selected>4. 管飼</option>
					  			<% }else{ %>
					  				<option value="4">4. 管飼</option>
					  			<% } %>
								<% if(patGrpBean.getField(EmsDB.EM_PER_PERSONAL_PARTICULAR[17][0]).getFormValue().equals("5")){ %>
					  				<option value="5" selected>5. 特別餐</option>
					  			<% }else{ %>
					  				<option value="5">5. 特別餐</option>
					  			<% } %>
							</select> <input type="text" name="<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[18][0] %>" value="<%=patGrpBean.getField(EmsDB.EM_PER_PERSONAL_PARTICULAR[18][0]).getFormValue() %>" maxlength="100" class="mc-fw" style="max-width:20em" placeholder="如選特別餐請註明"></td> 
						</tr>
						<tr>
							<td>護理服務</td>
					  		<td colspan="3"><select name="<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[19][0] %>" style="width:160px">
								<% if(patGrpBean.getField(EmsDB.EM_PER_PERSONAL_PARTICULAR[19][0]).getFormValue().equals("")){ %>
					  				<option value="" selected></option>
					  			<% }else{ %>
					  				<option value=""></option>
					  			<% } %>
								<% if(patGrpBean.getField(EmsDB.EM_PER_PERSONAL_PARTICULAR[19][0]).getFormValue().equals("1")){ %>
					  				<option value="1" selected>1. 需要用尿片</option>
					  			<% }else{ %>
					  				<option value="1">1. 需要用尿片</option>
					  			<% } %>
								<% if(patGrpBean.getField(EmsDB.EM_PER_PERSONAL_PARTICULAR[19][0]).getFormValue().equals("2")){ %>
					  				<option value="2" selected>2. 尿喉護理</option>
					  			<% }else{ %>
					  				<option value="2">2. 尿喉護理</option>
					  			<% } %>
								<% if(patGrpBean.getField(EmsDB.EM_PER_PERSONAL_PARTICULAR[19][0]).getFormValue().equals("3")){ %>
					  				<option value="3" selected>3. 其他造口護理</option>
					  			<% }else{ %>
					  				<option value="3">3. 其他造口護理</option>
					  			<% } %>
								<% if(patGrpBean.getField(EmsDB.EM_PER_PERSONAL_PARTICULAR[19][0]).getFormValue().equals("4")){ %>
					  				<option value="4" selected>4. 其他</option>
					  			<% }else{ %>
					  				<option value="4">4. 其他</option>
					  			<% } %>
							</select> <input type="text" name="<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[20][0] %>" value="<%=patGrpBean.getField(EmsDB.EM_PER_PERSONAL_PARTICULAR[20][0]).getFormValue() %>" maxlength="100" class="mc-fw" style="max-width:20em" placeholder="如選其他請註明"></td> 
						</tr>
						<tr>
							<td>護理程度</td>
					  		<td colspan="3"><select name="<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[21][0] %>" style="width:160px">
								<% if(patGrpBean.getField(EmsDB.EM_PER_PERSONAL_PARTICULAR[21][0]).getFormValue().equals("")){ %>
					  				<option value="" selected></option>
					  			<% }else{ %>
					  				<option value=""></option>
					  			<% } %>
								<% if(patGrpBean.getField(EmsDB.EM_PER_PERSONAL_PARTICULAR[21][0]).getFormValue().equals("1")){ %>
					  				<option value="1" selected>1. 自理</option>
					  			<% }else{ %>
					  				<option value="1">1. 自理</option>
					  			<% } %>
								<% if(patGrpBean.getField(EmsDB.EM_PER_PERSONAL_PARTICULAR[21][0]).getFormValue().equals("2")){ %>
					  				<option value="2" selected>2. 半護理</option>
					  			<% }else{ %>
					  				<option value="2">2. 半護理</option>
					  			<% } %>
								<% if(patGrpBean.getField(EmsDB.EM_PER_PERSONAL_PARTICULAR[21][0]).getFormValue().equals("3")){ %>
					  				<option value="3" selected>3. 全護理</option>
					  			<% }else{ %>
					  				<option value="3">3. 全護理</option>
					  			<% } %>
								<% if(patGrpBean.getField(EmsDB.EM_PER_PERSONAL_PARTICULAR[21][0]).getFormValue().equals("4")){ %>
					  				<option value="4" selected>4. 特別護理</option>
					  			<% }else{ %>
					  				<option value="4">4. 特別護理</option>
					  			<% } %>
							</select></td> 
						</tr>
						<tr>
							<td>媒介</td>
					  		<td colspan="3"><select name="<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[22][0] %>" style="width:160px">
								<% if(patGrpBean.getField(EmsDB.EM_PER_PERSONAL_PARTICULAR[22][0]).getFormValue().equals("")){ %>
					  				<option value="" selected></option>
					  			<% }else{ %>
					  				<option value=""></option>
					  			<% } %>
								<% if(patGrpBean.getField(EmsDB.EM_PER_PERSONAL_PARTICULAR[22][0]).getFormValue().equals("1")){ %>
					  				<option value="1" selected>1. 朋友</option>
					  			<% }else{ %>
					  				<option value="1">1. 朋友</option>
					  			<% } %>
								<% if(patGrpBean.getField(EmsDB.EM_PER_PERSONAL_PARTICULAR[22][0]).getFormValue().equals("2")){ %>
					  				<option value="2" selected>2. 網頁</option>
					  			<% }else{ %>
					  				<option value="2">2. 網頁</option>
					  			<% } %>
								<% if(patGrpBean.getField(EmsDB.EM_PER_PERSONAL_PARTICULAR[22][0]).getFormValue().equals("3")){ %>
					  				<option value="3" selected>3. 廣告</option>
					  			<% }else{ %>
					  				<option value="3">3. 廣告</option>
					  			<% } %>
								<% if(patGrpBean.getField(EmsDB.EM_PER_PERSONAL_PARTICULAR[22][0]).getFormValue().equals("4")){ %>
					  				<option value="4" selected>4. 社工</option>
					  			<% }else{ %>
					  				<option value="4">4. 社工</option>
					  			<% } %>
								<% if(patGrpBean.getField(EmsDB.EM_PER_PERSONAL_PARTICULAR[22][0]).getFormValue().equals("5")){ %>
					  				<option value="5" selected>5. 其他</option>
					  			<% }else{ %>
					  				<option value="5">5. 其他</option>
					  			<% } %>
							</select> <input type="text" name="<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[23][0] %>" value="<%=patGrpBean.getField(EmsDB.EM_PER_PERSONAL_PARTICULAR[23][0]).getFormValue() %>" maxlength="100" class="mc-fw" style="max-width:20em" placeholder="如選其他請註明"></td>
						</tr>
					</table>
			</div>
			<div id="addTabPage3" style="display:none">
				<table class="w3-table">
					<tr>
						<th class="color1 w3-xlarge">新入住 - 親友資料<span class="w3-text-red mc-italic"><%=patGrpBean.getMsg() %></span></th>
					</tr>
				</table>
				<div style="overflow-x:auto;">
					<table id="depositeListTable">
						<tr>
					  		<td>通知順序</td>
					  		<td>名稱</td> 
					  		<td>關係</td>
					  		<td>電話</td>
					  		<td>電郵</td>
						</tr>
						<% 
							PcoBean[] pcoBean = new PcoBean[5];
							
							for(int i=0;i<5;i++){
								if(patGrpBean.getPcoBeanList().size() > i)
									pcoBean[i] = patGrpBean.getPcoBeanList().get(i);
								else
									pcoBean[i] = new PcoBean();
						%>
						<tr id="addPCO<%= i+1 %>">
							<td><%= i+1 %><input type="hidden" name="PCO_SEQ<%= i+1 %>" id="addPCO_SEQ<%= i+1 %>" value="<%= i+1 %>"></td>
							<td><input type="text" name="PCO_CHI_NAME<%= i+1 %>" id="addPCO_CHI_NAME<%= i+1 %>" value="<%=pcoBean[i].getPerBean().getField(EmsDB.EM_PER_PERSONAL_PARTICULAR[2][0]).getFormValue() %>" maxlength="<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[2][3] %>" class="mc-fw" style="max-width:10em"><span class="w3-text-red mc-italic"><%=pcoBean[i].getPerBean().getField(EmsDB.EM_PER_PERSONAL_PARTICULAR[2][0]).getMsg() %></span></td>
							<td>
							<select name="PCO_REL<%= i+1 %>" id="addPCO_REL<%= i+1 %>">
							<% if(pcoBean[i].getField(EmsDB.EM_PCO_PERSONAL_CONTACT[4][0]).getFormValue().equals("")){ %>
			  					<option value=""selected></option>
			  				<% }else{ %>
			  					<option value=""></option>
			  				<% } %>
							<% if(pcoBean[i].getField(EmsDB.EM_PCO_PERSONAL_CONTACT[4][0]).getFormValue().equals("父子")){ %>
								<option value="父子" selected>父子</option>
			  				<% }else{ %>
			  					<option value="父子">父子</option>
			  				<% } %>
							<% if(pcoBean[i].getField(EmsDB.EM_PCO_PERSONAL_CONTACT[4][0]).getFormValue().equals("父女")){ %>
								<option value="父女" selected>父女</option>
			  				<% }else{ %>
			  					<option value="父女">父女</option>
			  				<% } %>
							<% if(pcoBean[i].getField(EmsDB.EM_PCO_PERSONAL_CONTACT[4][0]).getFormValue().equals("母子")){ %>
								<option value="母子" selected>母子</option>
			  				<% }else{ %>
			  					<option value="母子">母子</option>
			  				<% } %>
							<% if(pcoBean[i].getField(EmsDB.EM_PCO_PERSONAL_CONTACT[4][0]).getFormValue().equals("母女")){ %>
								<option value="母女" selected>母女</option>
			  				<% }else{ %>
			  					<option value="母女">母女</option>
			  				<% } %>
							<% if(pcoBean[i].getField(EmsDB.EM_PCO_PERSONAL_CONTACT[4][0]).getFormValue().equals("兄弟")){ %>
								<option value="兄弟" selected>兄弟</option>
			  				<% }else{ %>
			  					<option value="兄弟">兄弟</option>
			  				<% } %>
							<% if(pcoBean[i].getField(EmsDB.EM_PCO_PERSONAL_CONTACT[4][0]).getFormValue().equals("兄妹")){ %>
								<option value="兄妹" selected>兄妹</option>
			  				<% }else{ %>
			  					<option value="兄妹">兄妹</option>
			  				<% } %>
							<% if(pcoBean[i].getField(EmsDB.EM_PCO_PERSONAL_CONTACT[4][0]).getFormValue().equals("姊弟")){ %>
								<option value="姊弟" selected>姊弟</option>
			  				<% }else{ %>
			  					<option value="姊弟">姊弟</option>
			  				<% } %>
							<% if(pcoBean[i].getField(EmsDB.EM_PCO_PERSONAL_CONTACT[4][0]).getFormValue().equals("姊妹")){ %>
								<option value="姊妹" selected>姊妹</option>
			  				<% }else{ %>
			  					<option value="姊妹">姊妹</option>
			  				<% } %>
							<% if(pcoBean[i].getField(EmsDB.EM_PCO_PERSONAL_CONTACT[4][0]).getFormValue().equals("夫婦")){ %>
								<option value="夫婦" selected>夫婦</option>
			  				<% }else{ %>
			  					<option value="夫婦">夫婦</option>
			  				<% } %>
							<% if(pcoBean[i].getField(EmsDB.EM_PCO_PERSONAL_CONTACT[4][0]).getFormValue().equals("前夫")){ %>
								<option value="前夫" selected>前夫</option>
			  				<% }else{ %>
			  					<option value="前夫">前夫</option>
			  				<% } %>
							<% if(pcoBean[i].getField(EmsDB.EM_PCO_PERSONAL_CONTACT[4][0]).getFormValue().equals("前妻")){ %>
								<option value="前妻" selected>前妻</option>
			  				<% }else{ %>
			  					<option value="前妻">前妻</option>
			  				<% } %>
							<% if(pcoBean[i].getField(EmsDB.EM_PCO_PERSONAL_CONTACT[4][0]).getFormValue().equals("女婿")){ %>
								<option value="女婿" selected>女婿</option>
			  				<% }else{ %>
			  					<option value="女婿">女婿</option>
			  				<% } %>
							<% if(pcoBean[i].getField(EmsDB.EM_PCO_PERSONAL_CONTACT[4][0]).getFormValue().equals("媳婦")){ %>
								<option value="媳婦" selected>媳婦</option>
			  				<% }else{ %>
			  					<option value="媳婦">媳婦</option>
			  				<% } %>
							<% if(pcoBean[i].getField(EmsDB.EM_PCO_PERSONAL_CONTACT[4][0]).getFormValue().equals("孫子")){ %>
								<option value="孫子" selected>孫子</option>
			  				<% }else{ %>
			  					<option value="孫子">孫子</option>
			  				<% } %>
							<% if(pcoBean[i].getField(EmsDB.EM_PCO_PERSONAL_CONTACT[4][0]).getFormValue().equals("孫女")){ %>
								<option value="孫女" selected>孫女</option>
			  				<% }else{ %>
			  					<option value="孫女">孫女</option>
			  				<% } %>
							<% if(pcoBean[i].getField(EmsDB.EM_PCO_PERSONAL_CONTACT[4][0]).getFormValue().equals("姪子")){ %>
								<option value="姪子" selected>姪子</option>
			  				<% }else{ %>
			  					<option value="姪子">姪子</option>
			  				<% } %>
							<% if(pcoBean[i].getField(EmsDB.EM_PCO_PERSONAL_CONTACT[4][0]).getFormValue().equals("姪女")){ %>
								<option value="姪女" selected>姪女</option>
			  				<% }else{ %>
			  					<option value="姪女">姪女</option>
			  				<% } %>
							<% if(pcoBean[i].getField(EmsDB.EM_PCO_PERSONAL_CONTACT[4][0]).getFormValue().equals("姪孫")){ %>
								<option value="姪孫" selected>姪孫</option>
			  				<% }else{ %>
			  					<option value="姪孫">姪孫</option>
			  				<% } %>
							<% if(pcoBean[i].getField(EmsDB.EM_PCO_PERSONAL_CONTACT[4][0]).getFormValue().equals("監護人")){ %>
								<option value="監護人" selected>監護人</option>
			  				<% }else{ %>
			  					<option value="監護人">監護人</option>
			  				<% } %>
							<% if(pcoBean[i].getField(EmsDB.EM_PCO_PERSONAL_CONTACT[4][0]).getFormValue().equals("親戚")){ %>
								<option value="親戚" selected>親戚</option>
			  				<% }else{ %>
			  					<option value="親戚">親戚</option>
			  				<% } %>
							<% if(pcoBean[i].getField(EmsDB.EM_PCO_PERSONAL_CONTACT[4][0]).getFormValue().equals("朋友")){ %>
								<option value="朋友" selected>朋友</option>
			  				<% }else{ %>
			  					<option value="朋友">朋友</option>
			  				<% } %>
							<% if(pcoBean[i].getField(EmsDB.EM_PCO_PERSONAL_CONTACT[4][0]).getFormValue().equals("社工")){ %>
								<option value="社工" selected>社工</option>
			  				<% }else{ %>
			  					<option value="社工">社工</option>
			  				<% } %>
							<% if(pcoBean[i].getField(EmsDB.EM_PCO_PERSONAL_CONTACT[4][0]).getFormValue().equals("院友")){ %>
								<option value="院友" selected>院友</option>
			  				<% }else{ %>
			  					<option value="院友">院友</option>
			  				<% } %>
							<% if(pcoBean[i].getField(EmsDB.EM_PCO_PERSONAL_CONTACT[4][0]).getFormValue().equals("其他")){ %>
								<option value="其他" selected>其他</option>
			  				<% }else{ %>
			  					<option value="其他">其他</option>
			  				<% } %>
			  			</select><span class="w3-text-red mc-italic"><%=pcoBean[i].getField(EmsDB.EM_PCO_PERSONAL_CONTACT[4][0]).getMsg() %></span>
							</td>
							<td><input type="text" name="PCO_TEL<%= i+1 %>" id="addPCO_TEL<%= i+1 %>" value="<%=pcoBean[i].getPerBean().getField(EmsDB.EM_PER_PERSONAL_PARTICULAR[8][0]).getFormValue() %>" maxlength="<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[8][3] %>" class="mc-fw" style="max-width:10em"><span class="w3-text-red mc-italic"><%=pcoBean[i].getPerBean().getField(EmsDB.EM_PER_PERSONAL_PARTICULAR[8][0]).getMsg() %></span></td>
							<td><input type="text" name="PCO_EMAIL<%= i+1 %>" id="addPCO_EMAIL<%= i+1 %>" value="<%=pcoBean[i].getPerBean().getField(EmsDB.EM_PER_PERSONAL_PARTICULAR[9][0]).getFormValue() %>" maxlength="<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[9][3] %>" class="mc-fw" style="max-width:10em"><span class="w3-text-red mc-italic"><%=pcoBean[i].getPerBean().getField(EmsDB.EM_PER_PERSONAL_PARTICULAR[9][0]).getMsg() %></span></td>
						</tr>
						<% } %>
					</table>
				</div>
			</div>
			<%
				TransBean transBean = patGrpBean.getTransBean();
				if(transBean == null)
					transBean = new TransBean();
			%>
			<div id="addTabPage4" style="display:none">
				<table class="w3-table">
					<tr>
						<th class="color1 w3-xlarge">新訂位 - 繳交按金<span class="w3-text-red mc-italic"><%=patGrpBean.getMsg() %></span></th>
					</tr>
				</table>
				<table class="w3-table-all" id="addDepositScreenTable">
						<col width="10%">
						<col width="40%">
						<col width="10%">
						<col width="40%">
				  	<tr><td colspan="4" class="w3-xlarge mc-bold mc-underline">繳交按金資料</td></tr>
				  	<tr>
				  		<td>戶口結餘(已繳交訂金將會自動轉成按金):</td>
				  		<td colspan="3"><span id="addRES_BALANCE">-</span></td>
				  	</tr>			  	
				  	<tr>
				  		<td>按金金額: <span class="w3-text-red mc-italic"><%=transBean.getField(EmsDB.EM_TRA_TRANSACTIONS[8][0]).getMsg() %></span></td>
				  		<td><input type="text" name="<%= EmsDB.EM_TRA_TRANSACTIONS[8][0] %>" value="<%=transBean.getField(EmsDB.EM_TRA_TRANSACTIONS[8][0]).getFormValue() %>" maxlength="<%= EmsDB.EM_TRA_TRANSACTIONS[8][3] %>" class="mc-fw" style="max-width:10em">(港幣)</td>
				  		<td>付款方法: <span class="w3-text-red mc-italic"><%=transBean.getField(EmsDB.EM_TRA_TRANSACTIONS[9][0]).getMsg() %></span></td>
				  		<td>
					  		<select name="<%= EmsDB.EM_TRA_TRANSACTIONS[9][0] %>" style="width:150px;">
								<% if(transBean.getField(EmsDB.EM_TRA_TRANSACTIONS[9][0]).getFormValue().equals("")){ %>
									<option value="" selected></option>
								<% }else{ %>
									<option value=""></option>
								<% } %>
								<% if(transBean.getField(EmsDB.EM_TRA_TRANSACTIONS[9][0]).getFormValue().equals("1")){ %>
									<option value="1" selected>現金</option>
								<% }else{ %>
									<option value="1">現金</option>
								<% } %>
								<% if(transBean.getField(EmsDB.EM_TRA_TRANSACTIONS[9][0]).getFormValue().equals("2")){ %>
									<option value="2" selected>支票</option>
								<% }else{ %>
									<option value="2">支票</option>
								<% } %>
						</select>
				  		</td>  
				  	</tr>
				  	<tr>
						<td>入賬日期: <span class="w3-text-red mc-italic"><%=transBean.getField(EmsDB.EM_TRA_TRANSACTIONS[7][0]).getMsg() %></span></td>
				  		<td>
				  			<div class="flatpickr date-container">
			   					<input type="text" name="<%= EmsDB.EM_TRA_TRANSACTIONS[7][0] %>" value="<%=transBean.getField(EmsDB.EM_TRA_TRANSACTIONS[7][0]).getFormValue() %>" maxlength="<%=transBean.getField(EmsDB.EM_TRA_TRANSACTIONS[7][3]) %>" size="12" data-input>
			   					<a class="mc-button-2 icon" data-clear>&times;</a>
							</div>
				  		</td> 
					  	<td>備註: <span class="w3-text-red mc-italic"><%=transBean.getField(EmsDB.EM_TRA_TRANSACTIONS[10][0]).getMsg() %></span></td>
					  	<td><input type="text" name="<%= EmsDB.EM_TRA_TRANSACTIONS[10][0] %>" value="<%=transBean.getField(EmsDB.EM_TRA_TRANSACTIONS[10][0]).getFormValue() %>" maxlength="<%= EmsDB.EM_TRA_TRANSACTIONS[10][3] %>" class="mc-fw" style="max-width:10em"></td>
			  		</tr>
				</table>
			</div>
			<a class="mc-button color4 w3-large" onclick="showConfirmMessage();"><i class="fas fa-check"></i>確定</a>
			<a class="mc-button color4 w3-large" onclick="showScreen('enqScreen');"><i class="fas fa-times"></i>返回</a>
		</div>
		<input type="hidden" name="<%= EmsDB.EM_TRA_TRANSACTIONS[5][0] %>" value="按金">
	  	<input type="hidden" name="<%= EmsDB.EM_TRA_TRANSACTIONS[6][0] %>" value="D">
	  	<input type="hidden" name="<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[24][0] %>" value="Y">
	  	<input type="hidden" name="<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[11][0] %>" value="P">
		<input type="hidden" name="funcId" value="<%=addFuncId %>">
		<input type="hidden" name="<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[0][0] %>" value="<%=patGrpBean.getField(EmsDB.EM_PER_PERSONAL_PARTICULAR[0][0]).getFormValue() %>">
		<input type="hidden" name="<%= EmsDB.EM_PAT_PATIENT_INFO[0][0] %>" value="<%=patGrpBean.getField(EmsDB.EM_PAT_PATIENT_INFO[0][0]).getFormValue() %>">
		<input type="hidden" name="<%= EmsDB.EM_LIV_RECORD[0][0] %>" value="<%=livBean.getField(EmsDB.EM_LIV_RECORD[0][0]).getFormValue() %>">
		</form>
		<div class="w3-panel w3-padding-small w3-right w3-white" style="width:330px; height:350px; border:1px solid silver; z-index: 0;position: fixed;top: 20%;left: calc(50% - 165px);word-wrap: break-word;display:none;box-shadow: 5px 5px 7px rgba(0, 0, 0, 0.7);" id="quoteListScreen">
			<table style="width:100%" class="color1">
	  			<col width="15%">
				<col width="70%">
				<col width="15%">
	  			<tr>
	  				<td><a class="mc-button w3-transparent" style="display:block;" onclick="closeQuoteListScreen()" id="resButton">&times;</a></td>
	  				<td class="w3-center">報價記錄</td>
	  				<td></td>
	  			</tr>
	  		</table>
	  		<div style="overflow-y: auto; height:calc(100% - 40px);">
				<table style="width:100%;" id="quoteListTable">
				  <tr>
					<td>姓名</td>
					<td>身份證號碼</td>
					<td>報價編號</td>
				  </tr>
				  <% for(int i=0;i<quoteBeanList.size();i++){ %>
				  <tr onclick="closeQuoteListScreen();copyQuoteRecord(<%=i%>);getAjaxQuoData(<%=quoteBeanList.get(i).getPerId()%>);">
					<td><%=quoteBeanList.get(i).getPerBean().getField("PER_CHI_NAME").getFormValue() %></td>
					<td><%=quoteBeanList.get(i).getPerBean().getField("PER_HKID").getFormValue() %></td>
					<td><%=quoteBeanList.get(i).getField("QUO_ID").getFormValue() %></td>
				  </tr>
				  <% } %>
				</table>
			</div>
		</div>
		<div class="w3-panel w3-padding-small w3-right w3-white" style="width:330px; height:350px; border:1px solid silver; z-index: 0;position: fixed;top: 20%;left: calc(50% - 165px);word-wrap: break-word;display:none;box-shadow: 5px 5px 7px rgba(0, 0, 0, 0.7);" id="reserveListScreen">
			<table style="width:100%" class="color1">
	  			<col width="15%">
				<col width="70%">
				<col width="15%">
	  			<tr>
	  				<td><a class="mc-button w3-transparent" style="display:block;" onclick="closeReserveListScreen()" id="resButton">&times;</a></td>
	  				<td class="w3-center">訂位記錄</td>
	  				<td></td>
	  			</tr>
	  		</table>
	  		<div style="overflow-y: auto; height:calc(100% - 40px);">
				<table style="width:100%;" id="reserveListTable">
				  <tr>
					<td>姓名</td>
					<td>身份證號碼</td>
					<td>報價編號</td>
				  </tr>
				  <% for(int i=0;i<reserveBeanList.size();i++){ %>
				  <tr onclick="closeReserveListScreen();copyReserveRecord(<%=i%>);getAjaxResData(<%=reserveBeanList.get(i).getPerId()%>);">
					<td><%=reserveBeanList.get(i).getPerBean().getField("PER_CHI_NAME").getFormValue() %></td>
					<td><%=reserveBeanList.get(i).getPerBean().getField("PER_HKID").getFormValue() %></td>
					<td><%=reserveBeanList.get(i).getField("RES_ID").getFormValue() %></td>
				  </tr>
				  <% } %>
				</table>
			</div>
		</div>

		<form name="mntPatient" action="mntPatient" method="post" enctype="multipart/form-data">
		<div style="display:none" id="modDetailScreen">

			<div class="w3-bar">
				<a class="w3-bar-item w3-button color1 mc-tabBtn" id="modTabBtn1" onclick="switchTabPage('mod',1)"><i class="fas fa-file-alt fa-fw"></i></a>
				<a class="w3-bar-item w3-button w3-grey mc-tabBtn" id="modTabBtn2" onclick="switchTabPage('mod',2)"><i class="fas fa-copy fa-fw"></i></a>
				<a class="w3-bar-item w3-button w3-grey mc-tabBtn" id="modTabBtn3" onclick="switchTabPage('mod',3)"><i class="fas fa-user-friends fa-fw"></i></a>
				<a class="w3-bar-item w3-button w3-grey mc-tabBtn" id="modTabBtn4" onclick="switchTabPage('mod',4)"><i class="fas fa-file-invoice-dollar fa-fw"></i></a>
			</div>
			<div id="modTabPage1">
				<table class="w3-table">
					<tr>
						<th class="color1 w3-xlarge">編輯 - 個人資料<span class="w3-text-red mc-italic"><%=patGrpBean.getMsg() %></span></th>
					</tr>
				</table>
				<table class="w3-table-all" id="modDetailTabPage1ScreenTable">
					<col width="10%">
					<col width="40%">
					<col width="10%">
					<col width="40%">
				<tr><td colspan="4" class="w3-xlarge mc-bold mc-underline">個人資料</td></tr>
			  	<tr>
			  		<td>中文姓名: <span class="w3-text-red mc-italic"><%=patGrpBean.getField(EmsDB.EM_PER_PERSONAL_PARTICULAR[2][0]).getMsg() %></span></td>
			  		<td><input type="text" name="<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[2][0] %>" value="<%=patGrpBean.getField(EmsDB.EM_PER_PERSONAL_PARTICULAR[2][0]).getFormValue() %>" maxlength="<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[2][3] %>" class="mc-fw" style="max-width:20em"></td> 
			  		<td>英文姓名: <span class="w3-text-red mc-italic"><%=patGrpBean.getField(EmsDB.EM_PER_PERSONAL_PARTICULAR[3][0]).getMsg() %></span></td>
			  		<td><input type="text" name="<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[3][0] %>" value="<%=patGrpBean.getField(EmsDB.EM_PER_PERSONAL_PARTICULAR[3][0]).getFormValue() %>" maxlength="<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[3][3] %>" class="mc-fw" style="max-width:20em"></td>  
			  	</tr>
			  	<tr>
			  		<td>身份證號碼:<span class="w3-text-red mc-italic"><%=patGrpBean.getField(EmsDB.EM_PER_PERSONAL_PARTICULAR[6][0]).getMsg() %></span></td>
			  		<td><input type="text" name="<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[6][0] %>" value="<%=patGrpBean.getField(EmsDB.EM_PER_PERSONAL_PARTICULAR[6][0]).getFormValue() %>" maxlength="<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[6][3] %>" class="mc-fw" style="max-width:20em" placeholder="例:A123456(7)"></td> 
			  		<td>性別: <span class="w3-text-red mc-italic"><%=patGrpBean.getField(EmsDB.EM_PER_PERSONAL_PARTICULAR[7][0]).getMsg() %></span></td>
			  		<td><select name="<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[7][0] %>" style="width:150px;">
						<% if(patGrpBean.getField(EmsDB.EM_PER_PERSONAL_PARTICULAR[7][0]).getFormValue().equals("")){ %>
							<option value="" selected></option>
						<% }else{ %>
							<option value=""></option>
						<% } %>
						<% if(patGrpBean.getField(EmsDB.EM_PER_PERSONAL_PARTICULAR[7][0]).getFormValue().equals("M")){ %>
							<option value="M" selected>男</option>
						<% }else{ %>
							<option value="M">男</option>
						<% } %>
						<% if(patGrpBean.getField(EmsDB.EM_PER_PERSONAL_PARTICULAR[7][0]).getFormValue().equals("F")){ %>
							<option value="F" selected>女</option>
						<% }else{ %>
							<option value="F">女</option>
						<% } %>
				</select></td>  
			  	</tr>
			  	<tr>
			  		<td>出生日期: <span class="w3-text-red mc-italic"><%=patGrpBean.getField(EmsDB.EM_PER_PERSONAL_PARTICULAR[4][0]).getMsg() %></span></td>
			  		<td>
			  			
			  			<div class="flatpickr date-container">
			   				<input type="text" name="<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[4][0] %>" id="mod<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[4][0] %>" value="<%=patGrpBean.getField(EmsDB.EM_PER_PERSONAL_PARTICULAR[4][0]).getFormValue() %>" maxlength="<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[4][3] %>" size="12" data-input>
			   				<a class="mc-button-2 icon" data-clear>&times;</a>
						</div>
						<a class="mc-button color4" onclick="lunarToSolar('mod<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[5][0] %>', 'mod<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[4][0] %>')"><i class="fas fa-exchange-alt"></i>舊曆</a>
			  		</td> 
			  		<td>農曆: <span class="w3-text-red mc-italic"><%=patGrpBean.getField(EmsDB.EM_PER_PERSONAL_PARTICULAR[5][0]).getMsg() %></span></td>
			  		<td>
			  			<div class="flatpickr date-container">
		   					<input type="text" name="<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[5][0] %>" id="mod<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[5][0] %>" value="<%=patGrpBean.getField(EmsDB.EM_PER_PERSONAL_PARTICULAR[5][0]).getFormValue() %>" maxlength="<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[5][3] %>" size="12" data-input>
			   				<a class="mc-button-2 icon" data-clear>&times;</a>
						</div>
						<a class="mc-button color4" onclick="solarToLunar('mod<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[4][0] %>', 'mod<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[5][0] %>')"><i class="fas fa-exchange-alt"></i>新曆</a>
					</td>  
			  	</tr>
			  <tr>
			  	<td><%= EmsDB.EM_PER_PERSONAL_PARTICULAR[8][1] %>: <span class="w3-text-red mc-italic"><%=patGrpBean.getField(EmsDB.EM_PER_PERSONAL_PARTICULAR[8][0]).getMsg() %></span></td>
			  	<td><input type="text" name="<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[8][0] %>" value="<%=patGrpBean.getField(EmsDB.EM_PER_PERSONAL_PARTICULAR[8][0]).getFormValue() %>" maxlength="<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[8][3] %>" class="mc-fw" style="max-width:20em"></td> 
			  	<td><%= EmsDB.EM_PER_PERSONAL_PARTICULAR[9][1] %>: <span class="w3-text-red mc-italic"><%=patGrpBean.getField(EmsDB.EM_PER_PERSONAL_PARTICULAR[9][0]).getMsg() %></span></td>
			  	<td><input type="text" name="<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[9][0] %>" value="<%=patGrpBean.getField(EmsDB.EM_PER_PERSONAL_PARTICULAR[9][0]).getFormValue() %>" maxlength="<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[9][3] %>" class="mc-fw" style="max-width:20em"></td>
			  </tr>
			  <tr>
			  	<td><%= EmsDB.EM_PER_PERSONAL_PARTICULAR[10][1] %>: <span class="w3-text-red mc-italic"><%=patGrpBean.getField(EmsDB.EM_PER_PERSONAL_PARTICULAR[10][0]).getMsg() %></span></td>
			  	<td><textarea name="<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[10][0] %>" rows="4" class="mc-fw" style="max-width:20em"><%=patGrpBean.getField(EmsDB.EM_PER_PERSONAL_PARTICULAR[10][0]).getFormValue() %></textarea></td> 
			  	<td><%= EmsDB.EM_PER_PERSONAL_PARTICULAR[12][1] %>: <span class="w3-text-red mc-italic" id="imageErrMsg1"><%=patGrpBean.getField(EmsDB.EM_PER_PERSONAL_PARTICULAR[12][0]).getMsg() %></span></td>
			  	<td><span id="mod<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[12][0] %>">
			  		<% if(patGrpBean.getField(EmsDB.EM_PER_PERSONAL_PARTICULAR[12][0]).getFormValue().length()>0){ %>
			  		<img src="/EMS/images/<%= patGrpBean.getField(EmsDB.EM_PER_PERSONAL_PARTICULAR[12][0]).getFormValue() %>" width="200">
			  		<% } %></span>
			  		<input type="file" name="fileUpload" accept="image/jpeg" onchange="validateFileType(this,'imageErrMsg1')" style="max-width:400px"><input type="hidden" name="PER_IMAGE_LINK" value="<%=patGrpBean.getField(EmsDB.EM_PER_PERSONAL_PARTICULAR[12][0]).getFormValue()%>">
			  	</td>
			  </tr>
			</table>
			</div>
			
			<div id="modTabPage2" style="display:none">
				<table class="w3-table">
					<tr>
						<th class="color1 w3-xlarge">編輯 - 其他資料</th>
					</tr>
				</table>
				<table class="w3-table-all" id="modDetailTabPage2ScreenTable">
					<col width="10%">
					<col width="40%">
					<col width="10%">
					<col width="40%">
				  	<tr><td colspan="4" class="w3-xlarge mc-bold mc-underline">床位資料</td></tr>
			  <%	LivBean modLivBean = new LivBean(); 
			  	if(patGrpBean.getLivBeanList().size()>0){
			  		modLivBean = patGrpBean.getLivBeanList().get(0);
			  	} 
				  %>
			  
			  	<tr>
			  		<td>床號: <span class="w3-text-red mc-italic"><%=modLivBean.getField(EmsDB.EM_LIV_RECORD[2][0]).getMsg() %></span></td>
			  		<td>
			  			<select name="<%= EmsDB.EM_LIV_RECORD[2][0] %>">
			  				<option value=""></option>
						<% 
						for(int i=0;i<zoneBeanList.size();i++){ 
								for(int j=0;j<zoneBeanList.get(i).getBedBeanList().size();j++){
									BedBean bedBean = zoneBeanList.get(i).getBedBeanList().get(j);
									if(bedBean.getLivBeanList()==null || bedBean.getLivBeanList().size()==0 ){
										if(bedBean.getZoneId().equals(livBean.getZoneId()) && bedBean.getBedId().equals(livBean.getBedId())){
						%>
			  				<option value="<%= bedBean.getZoneId() %>-<%= bedBean.getBedId() %>" selected><%= bedBean.getBedFullName() %></option>
						<% 				}else{	%>
							<option value="<%= bedBean.getZoneId() %>-<%= bedBean.getBedId() %>"><%= bedBean.getBedFullName() %></option>
						<% 				}
									}
								}
							}
						for(int i=0;i<zoneBeanList.size();i++){ 
							for(int j=0;j<zoneBeanList.get(i).getBedBeanList().size();j++){
								BedBean bedBean = zoneBeanList.get(i).getBedBeanList().get(j);
								if(bedBean.getLivBeanList()!=null && bedBean.getLivBeanList().size()>0 ){
									if(bedBean.getZoneId().equals(livBean.getZoneId()) && bedBean.getBedId().equals(livBean.getBedId())){
						%>
			  				<option value="<%= bedBean.getZoneId() %>-<%= bedBean.getBedId() %>" selected><%= bedBean.getBedFullName() %> <%=bedBean.getLivBeanList().get(0).getPatBean().getField("PER_CHI_NAME").getFormValue() %></option>
						<% 				}else{	%>
							<option value="<%= bedBean.getZoneId() %>-<%= bedBean.getBedId() %>"><%= bedBean.getBedFullName() %> <%=bedBean.getLivBeanList().get(0).getPatBean().getField("PER_CHI_NAME").getFormValue() %></option>
						<% 			}
								}
							}
						}
						%>
			  			</select>

			  		</td> 
			  		<td>床位類別: <span class="w3-text-red mc-italic"><%=modLivBean.getField(EmsDB.EM_LIV_RECORD[9][0]).getMsg() %></span></td>
			  		<td>
			  			<select name="<%= EmsDB.EM_LIV_RECORD[9][0] %>">
						<% if(modLivBean.getField(EmsDB.EM_LIV_RECORD[9][0]).getFormValue().equals("")){ %>
			  				<option value="" selected></option>
			  			<% }else{ %>
			  				<option value=""></option>
			  			<% } %>
						<% if(modLivBean.getField(EmsDB.EM_LIV_RECORD[9][0]).getFormValue().equals("A")){ %>
			  				<option value="A" selected>院舍卷</option>
			  			<% }else{ %>
			  				<option value="A">院舍卷</option>
			  			<% } %>
						<% if(modLivBean.getField(EmsDB.EM_LIV_RECORD[9][0]).getFormValue().equals("B")){ %>
			  				<option value="B" selected>資助住宿暫托照顧服務</option>
			  			<% }else{ %>
			  				<option value="B">資助住宿暫托照顧服務</option>
			  			<% } %>
						<% if(modLivBean.getField(EmsDB.EM_LIV_RECORD[9][0]).getFormValue().equals("C")){ %>
			  				<option value="C" selected>非資助住宿暫托照顧服務</option>
			  			<% }else{ %>
			  				<option value="C">非資助住宿暫托照顧服務</option>
			  			<% } %>
						<% if(modLivBean.getField(EmsDB.EM_LIV_RECORD[9][0]).getFormValue().equals("D")){ %>
			  				<option value="D" selected>資助安老宿位</option>
			  			<% }else{ %>
			  				<option value="D">資助安老宿位</option>
			  			<% } %>
						<% if(modLivBean.getField(EmsDB.EM_LIV_RECORD[9][0]).getFormValue().equals("E")){ %>
			  				<option value="E" selected>非資助安老宿位</option>
			  			<% }else{ %>
			  				<option value="E">非資助安老宿位</option>
			  			<% } %>
						<% if(modLivBean.getField(EmsDB.EM_LIV_RECORD[9][0]).getFormValue().equals("F")){ %>
			  				<option value="F" selected>私位</option>
			  			<% }else{ %>
			  				<option value="F">私位</option>
			  			<% } %>
						<% if(modLivBean.getField(EmsDB.EM_LIV_RECORD[9][0]).getFormValue().equals("G")){ %>
			  				<option value="G" selected>買位</option>
			  			<% }else{ %>
			  				<option value="G">買位</option>
			  			<% } %>
						<% if(modLivBean.getField(EmsDB.EM_LIV_RECORD[9][0]).getFormValue().equals("H")){ %>
			  				<option value="H" selected>長老院舍住宿照顧服務卷</option>
			  			<% }else{ %>
			  				<option value="H">長老院舍住宿照顧服務卷</option>
			  			<% } %>
						<% if(modLivBean.getField(EmsDB.EM_LIV_RECORD[9][0]).getFormValue().equals("I")){ %>
			  				<option value="I" selected>離院照顧(醫社合作)</option>
			  			<% }else{ %>
			  				<option value="I">離院照顧(醫社合作)</option>
			  			<% } %>
			  				
			  			</select>
			  		</td>  
			  	</tr>
			  	<tr>
			  		<td>入住日期: <span class="w3-text-red mc-italic"><%=modLivBean.getField(EmsDB.EM_LIV_RECORD[5][0]).getMsg() %></span></td>
			  		<td>
			  			<div class="flatpickr date-container">
		   					<input type="text" name="<%= EmsDB.EM_LIV_RECORD[5][0] %>" value="<%=modLivBean.getField(EmsDB.EM_LIV_RECORD[5][0]).getFormValue() %>" maxlength="<%=modLivBean.getField(EmsDB.EM_LIV_RECORD[5][3]) %>" size="12" data-input>
		   					<a class="mc-button-2 icon" data-clear>&times;</a>
						</div>
			  		</td> 
				  	<td><%= EmsDB.EM_LIV_RECORD[7][1] %>: <span class="w3-text-red mc-italic"><%=modLivBean.getField(EmsDB.EM_LIV_RECORD[7][0]).getMsg() %></span></td>
				  	<td><input type="text" name="<%= EmsDB.EM_LIV_RECORD[7][0] %>" value="<%=modLivBean.getField(EmsDB.EM_LIV_RECORD[7][0]).getFormValue() %>" maxlength="<%= EmsDB.EM_LIV_RECORD[7][3] %>" class="mc-fw" style="max-width:10em">(港幣)</td>
			  	</tr>
			  	<tr>
				  	<td><%= EmsDB.EM_LIV_RECORD[8][1] %>: <span class="w3-text-red mc-italic"><%=modLivBean.getField(EmsDB.EM_LIV_RECORD[8][0]).getMsg() %></span></td>
				  	<td colspan="3"><input type="text" name="<%= EmsDB.EM_LIV_RECORD[8][0] %>" value="<%=modLivBean.getField(EmsDB.EM_LIV_RECORD[8][0]).getFormValue() %>" maxlength="<%= EmsDB.EM_LIV_RECORD[8][3] %>" class="mc-fw" style="max-width:10em">(港幣)</td>
			  	</tr>

			  	<tr><td colspan="4" class="w3-xlarge mc-bold mc-underline">評核資料</td></tr>
			  	<tr>
			  		<td>LDS編號: <span class="w3-text-red mc-italic"><%=patGrpBean.getField(EmsDB.EM_PER_PERSONAL_PARTICULAR[13][0]).getMsg() %></span></td>
			  		<td><input type="text" name="<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[13][0] %>" value="<%=patGrpBean.getField(EmsDB.EM_PER_PERSONAL_PARTICULAR[13][0]).getFormValue() %>" maxlength="<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[13][3] %>" class="mc-fw" style="max-width:10em"></td> 
			  		<td>評核結果: <span class="w3-text-red mc-italic"><%=patGrpBean.getField(EmsDB.EM_PER_PERSONAL_PARTICULAR[14][0]).getMsg() %></span></td>
			  		<td><select name="<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[14][0] %>" style="width:150px;">
						<% if(patGrpBean.getField(EmsDB.EM_PER_PERSONAL_PARTICULAR[14][0]).getFormValue().equals("")){ %>
							<option value="" selected></option>
						<% }else{ %>
							<option value=""></option>
						<% } %>
						<% if(patGrpBean.getField(EmsDB.EM_PER_PERSONAL_PARTICULAR[14][0]).getFormValue().equals("未評核")){ %>
							<option value="未評核" selected>未評核</option>
						<% }else{ %>
							<option value="未評核">未評核</option>
						<% } %>
						<% if(patGrpBean.getField(EmsDB.EM_PER_PERSONAL_PARTICULAR[14][0]).getFormValue().equals("中度機能受損")){ %>
							<option value="中度機能受損" selected>中度機能受損</option>
						<% }else{ %>
							<option value="中度機能受損">中度機能受損</option>
						<% } %>
						<% if(patGrpBean.getField(EmsDB.EM_PER_PERSONAL_PARTICULAR[14][0]).getFormValue().equals("高度機能受損")){ %>
							<option value="高度機能受損" selected>高度機能受損</option>
						<% }else{ %>
							<option value="高度機能受損">高度機能受損</option>
						<% } %>
					</select></td>  
			  	</tr>
			  	<tr>
			  		<td>評核日期: <span class="w3-text-red mc-italic"><%=patGrpBean.getField(EmsDB.EM_PER_PERSONAL_PARTICULAR[15][0]).getMsg() %></span></td>
			  		<td colspan="3"><div class="flatpickr date-container">
			   				<input type="text" name="<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[15][0] %>" id="mod<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[15][0] %>" value="<%=patGrpBean.getField(EmsDB.EM_PER_PERSONAL_PARTICULAR[15][0]).getFormValue() %>" maxlength="<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[15][3] %>" size="12" data-input>
			   				<a class="mc-button-2 icon" data-clear>&times;</a>
						</div>
				  	</td> 
			  	</tr>
						<tr>
					  		<td>行動能力 <span class="w3-text-red mc-italic"><%=patGrpBean.getField(EmsDB.EM_PER_PERSONAL_PARTICULAR[16][0]).getMsg() %></span></td>
					  		<td colspan="3"><select name="<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[16][0] %>" style="width:160px">
								<% if(patGrpBean.getField(EmsDB.EM_PER_PERSONAL_PARTICULAR[16][0]).getFormValue().equals("")){ %>
					  				<option value="" selected></option>
					  			<% }else{ %>
					  				<option value=""></option>
					  			<% } %>
								<% if(patGrpBean.getField(EmsDB.EM_PER_PERSONAL_PARTICULAR[16][0]).getFormValue().equals("1")){ %>
					  				<option value="1" selected>1. 行動自如</option>
					  			<% }else{ %>
					  				<option value="1">1. 行動自如</option>
					  			<% } %>
								<% if(patGrpBean.getField(EmsDB.EM_PER_PERSONAL_PARTICULAR[16][0]).getFormValue().equals("2")){ %>
					  				<option value="2" selected>2. 需要幫助</option>
					  			<% }else{ %>
					  				<option value="2">2. 需要幫助</option>
					  			<% } %>
								<% if(patGrpBean.getField(EmsDB.EM_PER_PERSONAL_PARTICULAR[16][0]).getFormValue().equals("3")){ %>
					  				<option value="3" selected>3. 需要助行器</option>
					  			<% }else{ %>
					  				<option value="3">3. 需要助行器</option>
					  			<% } %>
								<% if(patGrpBean.getField(EmsDB.EM_PER_PERSONAL_PARTICULAR[16][0]).getFormValue().equals("4")){ %>
					  				<option value="4" selected>4. 輪椅代步</option>
					  			<% }else{ %>
					  				<option value="4">4. 輪椅代步</option>
					  			<% } %>
								<% if(patGrpBean.getField(EmsDB.EM_PER_PERSONAL_PARTICULAR[16][0]).getFormValue().equals("5")){ %>
					  				<option value="5" selected>5. 長期坐椅</option>
					  			<% }else{ %>
					  				<option value="5">5. 長期坐椅</option>
					  			<% } %>
								<% if(patGrpBean.getField(EmsDB.EM_PER_PERSONAL_PARTICULAR[16][0]).getFormValue().equals("6")){ %>
					  				<option value="6" selected>6. 長期卧床</option>
					  			<% }else{ %>
					  				<option value="6">6. 長期卧床</option>
					  			<% } %>
					  		</select></tr>
						<tr>
							<td>飲食種類</td>
					  		<td colspan="3"><select name="<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[17][0] %>" style="width:160px">
								<% if(patGrpBean.getField(EmsDB.EM_PER_PERSONAL_PARTICULAR[17][0]).getFormValue().equals("")){ %>
					  				<option value="" selected></option>
					  			<% }else{ %>
					  				<option value=""></option>
					  			<% } %>
								<% if(patGrpBean.getField(EmsDB.EM_PER_PERSONAL_PARTICULAR[17][0]).getFormValue().equals("1")){ %>
					  				<option value="1" selected>1. 正餐</option>
					  			<% }else{ %>
					  				<option value="1">1. 正餐</option>
					  			<% } %>
								<% if(patGrpBean.getField(EmsDB.EM_PER_PERSONAL_PARTICULAR[17][0]).getFormValue().equals("2")){ %>
					  				<option value="2" selected>2. 碎餐</option>
					  			<% }else{ %>
					  				<option value="2">2. 碎餐</option>
					  			<% } %>
								<% if(patGrpBean.getField(EmsDB.EM_PER_PERSONAL_PARTICULAR[17][0]).getFormValue().equals("3")){ %>
					  				<option value="3" selected>3. 餬餐</option>
					  			<% }else{ %>
					  				<option value="3">3. 餬餐</option>
					  			<% } %>
								<% if(patGrpBean.getField(EmsDB.EM_PER_PERSONAL_PARTICULAR[17][0]).getFormValue().equals("4")){ %>
					  				<option value="4" selected>4. 管飼</option>
					  			<% }else{ %>
					  				<option value="4">4. 管飼</option>
					  			<% } %>
								<% if(patGrpBean.getField(EmsDB.EM_PER_PERSONAL_PARTICULAR[17][0]).getFormValue().equals("5")){ %>
					  				<option value="5" selected>5. 特別餐</option>
					  			<% }else{ %>
					  				<option value="5">5. 特別餐</option>
					  			<% } %>
							</select> <input type="text" name="<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[18][0] %>" value="<%=patGrpBean.getField(EmsDB.EM_PER_PERSONAL_PARTICULAR[18][0]).getFormValue() %>" maxlength="100" class="mc-fw" style="max-width:20em" placeholder="如選特別餐請註明"></td>
						</tr>
						<tr>
							<td>護理服務</td>
					  		<td colspan="3"><select name="<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[19][0] %>" style="width:160px">
								<% if(patGrpBean.getField(EmsDB.EM_PER_PERSONAL_PARTICULAR[19][0]).getFormValue().equals("")){ %>
					  				<option value="" selected></option>
					  			<% }else{ %>
					  				<option value=""></option>
					  			<% } %>
								<% if(patGrpBean.getField(EmsDB.EM_PER_PERSONAL_PARTICULAR[19][0]).getFormValue().equals("1")){ %>
					  				<option value="1" selected>1. 需要用尿片</option>
					  			<% }else{ %>
					  				<option value="1">1. 需要用尿片</option>
					  			<% } %>
								<% if(patGrpBean.getField(EmsDB.EM_PER_PERSONAL_PARTICULAR[19][0]).getFormValue().equals("2")){ %>
					  				<option value="2" selected>2. 尿喉護理</option>
					  			<% }else{ %>
					  				<option value="2">2. 尿喉護理</option>
					  			<% } %>
								<% if(patGrpBean.getField(EmsDB.EM_PER_PERSONAL_PARTICULAR[19][0]).getFormValue().equals("3")){ %>
					  				<option value="3" selected>3. 其他造口護理</option>
					  			<% }else{ %>
					  				<option value="3">3. 其他造口護理</option>
					  			<% } %>
								<% if(patGrpBean.getField(EmsDB.EM_PER_PERSONAL_PARTICULAR[19][0]).getFormValue().equals("4")){ %>
					  				<option value="4" selected>4. 其他</option>
					  			<% }else{ %>
					  				<option value="4">4. 其他</option>
					  			<% } %>
							</select> <input type="text" name="<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[20][0] %>" value="<%=patGrpBean.getField(EmsDB.EM_PER_PERSONAL_PARTICULAR[20][0]).getFormValue() %>" maxlength="100" class="mc-fw" style="max-width:20em" placeholder="如選其他請註明"></td> 
						</tr>
						<tr>
							<td>護理程度</td>
					  		<td colspan="3"><select name="<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[21][0] %>" style="width:160px">
								<% if(patGrpBean.getField(EmsDB.EM_PER_PERSONAL_PARTICULAR[21][0]).getFormValue().equals("")){ %>
					  				<option value="" selected></option>
					  			<% }else{ %>
					  				<option value=""></option>
					  			<% } %>
								<% if(patGrpBean.getField(EmsDB.EM_PER_PERSONAL_PARTICULAR[21][0]).getFormValue().equals("1")){ %>
					  				<option value="1" selected>1. 自理</option>
					  			<% }else{ %>
					  				<option value="1">1. 自理</option>
					  			<% } %>
								<% if(patGrpBean.getField(EmsDB.EM_PER_PERSONAL_PARTICULAR[21][0]).getFormValue().equals("2")){ %>
					  				<option value="2" selected>2. 半護理</option>
					  			<% }else{ %>
					  				<option value="2">2. 半護理</option>
					  			<% } %>
								<% if(patGrpBean.getField(EmsDB.EM_PER_PERSONAL_PARTICULAR[21][0]).getFormValue().equals("3")){ %>
					  				<option value="3" selected>3. 全護理</option>
					  			<% }else{ %>
					  				<option value="3">3. 全護理</option>
					  			<% } %>
								<% if(patGrpBean.getField(EmsDB.EM_PER_PERSONAL_PARTICULAR[21][0]).getFormValue().equals("4")){ %>
					  				<option value="4" selected>4. 特別護理</option>
					  			<% }else{ %>
					  				<option value="4">4. 特別護理</option>
					  			<% } %>
							</select></td> 
						</tr>
						<tr>
							<td>媒介</td>
					  		<td colspan="3"><select name="<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[22][0] %>" style="width:160px">
								<% if(patGrpBean.getField(EmsDB.EM_PER_PERSONAL_PARTICULAR[22][0]).getFormValue().equals("")){ %>
					  				<option value="" selected></option>
					  			<% }else{ %>
					  				<option value=""></option>
					  			<% } %>
								<% if(patGrpBean.getField(EmsDB.EM_PER_PERSONAL_PARTICULAR[22][0]).getFormValue().equals("1")){ %>
					  				<option value="1" selected>1. 朋友</option>
					  			<% }else{ %>
					  				<option value="1">1. 朋友</option>
					  			<% } %>
								<% if(patGrpBean.getField(EmsDB.EM_PER_PERSONAL_PARTICULAR[22][0]).getFormValue().equals("2")){ %>
					  				<option value="2" selected>2. 網頁</option>
					  			<% }else{ %>
					  				<option value="2">2. 網頁</option>
					  			<% } %>
								<% if(patGrpBean.getField(EmsDB.EM_PER_PERSONAL_PARTICULAR[22][0]).getFormValue().equals("3")){ %>
					  				<option value="3" selected>3. 廣告</option>
					  			<% }else{ %>
					  				<option value="3">3. 廣告</option>
					  			<% } %>
								<% if(patGrpBean.getField(EmsDB.EM_PER_PERSONAL_PARTICULAR[22][0]).getFormValue().equals("4")){ %>
					  				<option value="4" selected>4. 社工</option>
					  			<% }else{ %>
					  				<option value="4">4. 社工</option>
					  			<% } %>
								<% if(patGrpBean.getField(EmsDB.EM_PER_PERSONAL_PARTICULAR[22][0]).getFormValue().equals("5")){ %>
					  				<option value="5" selected>5. 其他</option>
					  			<% }else{ %>
					  				<option value="5">5. 其他</option>
					  			<% } %>
							</select> <input type="text" name="<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[23][0] %>" value="<%=patGrpBean.getField(EmsDB.EM_PER_PERSONAL_PARTICULAR[23][0]).getFormValue() %>" maxlength="100" class="mc-fw" style="max-width:20em" placeholder="如選其他請註明"></td>
						</tr>
					</table>
			</div>
			<div id="modTabPage3" style="display:none">
				<table class="w3-table">
					<tr>
						<th class="color1 w3-xlarge">編輯 - 親友資料<span class="w3-text-red mc-italic"><%=patGrpBean.getMsg() %></span></th>
					</tr>
				</table>
				<div style="overflow-x:auto;">
					<table id="depositeListTable">
						<tr>
					  		<td>通知順序</td>
					  		<td>名稱</td> 
					  		<td>關係</td>
					  		<td>電話</td>
					  		<td>電郵</td>
						</tr>
						<% 
							PcoBean[] modPcoBean = new PcoBean[5];
							
							for(int i=0;i<5;i++){
								if(patGrpBean.getPcoBeanList().size() > i)
									modPcoBean[i] = patGrpBean.getPcoBeanList().get(i);
								else
									modPcoBean[i] = new PcoBean();
						%>
						<tr id="modPCO<%= i+1 %>">
							<td><%= i+1 %><input type="hidden" name="PCO_SEQ<%= i+1 %>" id="modPCO_SEQ<%= i+1 %>" value="<%= i+1 %>"></td>
							<td><input type="text" name="PCO_CHI_NAME<%= i+1 %>" id="modPCO_CHI_NAME<%= i+1 %>" value="<%=pcoBean[i].getPerBean().getField(EmsDB.EM_PER_PERSONAL_PARTICULAR[2][0]).getFormValue() %>" maxlength="<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[2][3] %>" class="mc-fw" style="max-width:10em"><span class="w3-text-red mc-italic"><%=pcoBean[i].getPerBean().getField(EmsDB.EM_PER_PERSONAL_PARTICULAR[2][0]).getMsg() %></span></td>
							<td><select name="PCO_REL<%= i+1 %>" id="modPCO_REL<%= i+1 %>">
							<% if(pcoBean[i].getField(EmsDB.EM_PCO_PERSONAL_CONTACT[4][0]).getFormValue().equals("")){ %>
			  					<option value=""selected></option>
			  				<% }else{ %>
			  					<option value=""></option>
			  				<% } %>
							<% if(pcoBean[i].getField(EmsDB.EM_PCO_PERSONAL_CONTACT[4][0]).getFormValue().equals("父子")){ %>
								<option value="父子" selected>父子</option>
			  				<% }else{ %>
			  					<option value="父子">父子</option>
			  				<% } %>
							<% if(pcoBean[i].getField(EmsDB.EM_PCO_PERSONAL_CONTACT[4][0]).getFormValue().equals("父女")){ %>
								<option value="父女" selected>父女</option>
			  				<% }else{ %>
			  					<option value="父女">父女</option>
			  				<% } %>
							<% if(pcoBean[i].getField(EmsDB.EM_PCO_PERSONAL_CONTACT[4][0]).getFormValue().equals("母子")){ %>
								<option value="母子" selected>母子</option>
			  				<% }else{ %>
			  					<option value="母子">母子</option>
			  				<% } %>
							<% if(pcoBean[i].getField(EmsDB.EM_PCO_PERSONAL_CONTACT[4][0]).getFormValue().equals("母女")){ %>
								<option value="母女" selected>母女</option>
			  				<% }else{ %>
			  					<option value="母女">母女</option>
			  				<% } %>
							<% if(pcoBean[i].getField(EmsDB.EM_PCO_PERSONAL_CONTACT[4][0]).getFormValue().equals("兄弟")){ %>
								<option value="兄弟" selected>兄弟</option>
			  				<% }else{ %>
			  					<option value="兄弟">兄弟</option>
			  				<% } %>
							<% if(pcoBean[i].getField(EmsDB.EM_PCO_PERSONAL_CONTACT[4][0]).getFormValue().equals("兄妹")){ %>
								<option value="兄妹" selected>兄妹</option>
			  				<% }else{ %>
			  					<option value="兄妹">兄妹</option>
			  				<% } %>
							<% if(pcoBean[i].getField(EmsDB.EM_PCO_PERSONAL_CONTACT[4][0]).getFormValue().equals("姊弟")){ %>
								<option value="姊弟" selected>姊弟</option>
			  				<% }else{ %>
			  					<option value="姊弟">姊弟</option>
			  				<% } %>
							<% if(pcoBean[i].getField(EmsDB.EM_PCO_PERSONAL_CONTACT[4][0]).getFormValue().equals("姊妹")){ %>
								<option value="姊妹" selected>姊妹</option>
			  				<% }else{ %>
			  					<option value="姊妹">姊妹</option>
			  				<% } %>
							<% if(pcoBean[i].getField(EmsDB.EM_PCO_PERSONAL_CONTACT[4][0]).getFormValue().equals("夫婦")){ %>
								<option value="夫婦" selected>夫婦</option>
			  				<% }else{ %>
			  					<option value="夫婦">夫婦</option>
			  				<% } %>
							<% if(pcoBean[i].getField(EmsDB.EM_PCO_PERSONAL_CONTACT[4][0]).getFormValue().equals("前夫")){ %>
								<option value="前夫" selected>前夫</option>
			  				<% }else{ %>
			  					<option value="前夫">前夫</option>
			  				<% } %>
							<% if(pcoBean[i].getField(EmsDB.EM_PCO_PERSONAL_CONTACT[4][0]).getFormValue().equals("前妻")){ %>
								<option value="前妻" selected>前妻</option>
			  				<% }else{ %>
			  					<option value="前妻">前妻</option>
			  				<% } %>
							<% if(pcoBean[i].getField(EmsDB.EM_PCO_PERSONAL_CONTACT[4][0]).getFormValue().equals("女婿")){ %>
								<option value="女婿" selected>女婿</option>
			  				<% }else{ %>
			  					<option value="女婿">女婿</option>
			  				<% } %>
							<% if(pcoBean[i].getField(EmsDB.EM_PCO_PERSONAL_CONTACT[4][0]).getFormValue().equals("媳婦")){ %>
								<option value="媳婦" selected>媳婦</option>
			  				<% }else{ %>
			  					<option value="媳婦">媳婦</option>
			  				<% } %>
							<% if(pcoBean[i].getField(EmsDB.EM_PCO_PERSONAL_CONTACT[4][0]).getFormValue().equals("孫子")){ %>
								<option value="孫子" selected>孫子</option>
			  				<% }else{ %>
			  					<option value="孫子">孫子</option>
			  				<% } %>
							<% if(pcoBean[i].getField(EmsDB.EM_PCO_PERSONAL_CONTACT[4][0]).getFormValue().equals("孫女")){ %>
								<option value="孫女" selected>孫女</option>
			  				<% }else{ %>
			  					<option value="孫女">孫女</option>
			  				<% } %>
							<% if(pcoBean[i].getField(EmsDB.EM_PCO_PERSONAL_CONTACT[4][0]).getFormValue().equals("姪子")){ %>
								<option value="姪子" selected>姪子</option>
			  				<% }else{ %>
			  					<option value="姪子">姪子</option>
			  				<% } %>
							<% if(pcoBean[i].getField(EmsDB.EM_PCO_PERSONAL_CONTACT[4][0]).getFormValue().equals("姪女")){ %>
								<option value="姪女" selected>姪女</option>
			  				<% }else{ %>
			  					<option value="姪女">姪女</option>
			  				<% } %>
							<% if(pcoBean[i].getField(EmsDB.EM_PCO_PERSONAL_CONTACT[4][0]).getFormValue().equals("姪孫")){ %>
								<option value="姪孫" selected>姪孫</option>
			  				<% }else{ %>
			  					<option value="姪孫">姪孫</option>
			  				<% } %>
							<% if(pcoBean[i].getField(EmsDB.EM_PCO_PERSONAL_CONTACT[4][0]).getFormValue().equals("監護人")){ %>
								<option value="監護人" selected>監護人</option>
			  				<% }else{ %>
			  					<option value="監護人">監護人</option>
			  				<% } %>
							<% if(pcoBean[i].getField(EmsDB.EM_PCO_PERSONAL_CONTACT[4][0]).getFormValue().equals("親戚")){ %>
								<option value="親戚" selected>親戚</option>
			  				<% }else{ %>
			  					<option value="親戚">親戚</option>
			  				<% } %>
							<% if(pcoBean[i].getField(EmsDB.EM_PCO_PERSONAL_CONTACT[4][0]).getFormValue().equals("朋友")){ %>
								<option value="朋友" selected>朋友</option>
			  				<% }else{ %>
			  					<option value="朋友">朋友</option>
			  				<% } %>
							<% if(pcoBean[i].getField(EmsDB.EM_PCO_PERSONAL_CONTACT[4][0]).getFormValue().equals("社工")){ %>
								<option value="社工" selected>社工</option>
			  				<% }else{ %>
			  					<option value="社工">社工</option>
			  				<% } %>
							<% if(pcoBean[i].getField(EmsDB.EM_PCO_PERSONAL_CONTACT[4][0]).getFormValue().equals("院友")){ %>
								<option value="院友" selected>院友</option>
			  				<% }else{ %>
			  					<option value="院友">院友</option>
			  				<% } %>
							<% if(pcoBean[i].getField(EmsDB.EM_PCO_PERSONAL_CONTACT[4][0]).getFormValue().equals("其他")){ %>
								<option value="其他" selected>其他</option>
			  				<% }else{ %>
			  					<option value="其他">其他</option>
			  				<% } %>
			  			</select> <span class="w3-text-red mc-italic"><%=pcoBean[i].getField(EmsDB.EM_PCO_PERSONAL_CONTACT[4][0]).getMsg() %></span>
							</td>
							<td><input type="text" name="PCO_TEL<%= i+1 %>" id="modPCO_TEL<%= i+1 %>" value="<%=pcoBean[i].getPerBean().getField(EmsDB.EM_PER_PERSONAL_PARTICULAR[8][0]).getFormValue() %>" maxlength="<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[8][3] %>" class="mc-fw" style="max-width:10em"><span class="w3-text-red mc-italic"><%=pcoBean[i].getPerBean().getField(EmsDB.EM_PER_PERSONAL_PARTICULAR[8][0]).getMsg() %></span></td>
							<td><input type="text" name="PCO_EMAIL<%= i+1 %>" id="modPCO_EMAIL<%= i+1 %>" value="<%=pcoBean[i].getPerBean().getField(EmsDB.EM_PER_PERSONAL_PARTICULAR[9][0]).getFormValue() %>" maxlength="<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[9][3] %>" class="mc-fw" style="max-width:10em"><span class="w3-text-red mc-italic"><%=pcoBean[i].getPerBean().getField(EmsDB.EM_PER_PERSONAL_PARTICULAR[9][0]).getMsg() %></span></td>
						</tr>
						<% } %>
					</table>
				</div>
			</div>
			<div id="modTabPage4" style="display:none">
				<table class="w3-table">
					<tr>
						<th class="color1 w3-xlarge">編輯 - 追加按金<span class="w3-text-red mc-italic"><%=patGrpBean.getMsg() %></span>
						</th>
					</tr>
				</table>
				<table class="w3-table-all" id="modDepositScreenTable">
						<col width="10%">
						<col width="40%">
						<col width="10%">
						<col width="40%">
				  	<tr><td colspan="4" class="w3-xlarge mc-bold mc-underline">繳交按金資料</td></tr>
				  	<tr>
				  		<td>戶口結餘:</td>
				  		<td colspan="3"><span id="detailLIV_BALANCE">-</span></td>
				  	</tr>			  	
				  	<tr>
				  		<td>追加金額: <span class="w3-text-red mc-italic"><%=transBean.getField(EmsDB.EM_TRA_TRANSACTIONS[8][0]).getMsg() %></span></td>
				  		<td><input type="text" name="<%= EmsDB.EM_TRA_TRANSACTIONS[8][0] %>" value="<%=transBean.getField(EmsDB.EM_TRA_TRANSACTIONS[8][0]).getFormValue() %>" maxlength="<%= EmsDB.EM_TRA_TRANSACTIONS[8][3] %>" class="mc-fw" style="max-width:10em">(港幣)</td>
				  		<td>付款方法: <span class="w3-text-red mc-italic"><%=transBean.getField(EmsDB.EM_TRA_TRANSACTIONS[9][0]).getMsg() %></span></td>
				  		<td>
					  		<select name="<%= EmsDB.EM_TRA_TRANSACTIONS[9][0] %>" style="width:150px;">
								<% if(transBean.getField(EmsDB.EM_TRA_TRANSACTIONS[9][0]).getFormValue().equals("")){ %>
									<option value="" selected></option>
								<% }else{ %>
									<option value=""></option>
								<% } %>
								<% if(transBean.getField(EmsDB.EM_TRA_TRANSACTIONS[9][0]).getFormValue().equals("1")){ %>
									<option value="1" selected>現金</option>
								<% }else{ %>
									<option value="1">現金</option>
								<% } %>
								<% if(transBean.getField(EmsDB.EM_TRA_TRANSACTIONS[9][0]).getFormValue().equals("2")){ %>
									<option value="2" selected>支票</option>
								<% }else{ %>
									<option value="2">支票</option>
								<% } %>
						</select>
				  		</td>  
				  	</tr>
				  	<tr>
						<td>入賬日期: <span class="w3-text-red mc-italic"><%=transBean.getField(EmsDB.EM_TRA_TRANSACTIONS[7][0]).getMsg() %></span></td>
				  		<td>
				  			<div class="flatpickr date-container">
			   					<input type="text" name="<%= EmsDB.EM_TRA_TRANSACTIONS[7][0] %>" value="<%=transBean.getField(EmsDB.EM_TRA_TRANSACTIONS[7][0]).getFormValue() %>" maxlength="<%=transBean.getField(EmsDB.EM_TRA_TRANSACTIONS[7][3]) %>" size="12" data-input>
			   					<a class="mc-button-2 icon" data-clear>&times;</a>
							</div>
				  		</td> 
					  	<td>備註: <span class="w3-text-red mc-italic"><%=transBean.getField(EmsDB.EM_TRA_TRANSACTIONS[10][0]).getMsg() %></span></td>
					  	<td><input type="text" name="<%= EmsDB.EM_TRA_TRANSACTIONS[10][0] %>" value="<%=transBean.getField(EmsDB.EM_TRA_TRANSACTIONS[10][0]).getFormValue() %>" maxlength="<%= EmsDB.EM_TRA_TRANSACTIONS[10][3] %>" class="mc-fw" style="max-width:10em"></td>
			  		</tr>
				</table>
			</div>
			<a class="mc-button color4 w3-large" onclick="showConfirmMessage();"><i class="fas fa-check"></i>確定</a>
			<a class="mc-button color4 w3-large" onclick="showScreen('enqScreen');"><i class="fas fa-times"></i>返回</a>
		</div>
		<input type="hidden" name="<%= EmsDB.EM_TRA_TRANSACTIONS[5][0] %>" value="按金">
	  	<input type="hidden" name="<%= EmsDB.EM_TRA_TRANSACTIONS[6][0] %>" value="D">
	  	<input type="hidden" name="<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[24][0] %>" value="Y">
	  	<input type="hidden" name="<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[11][0] %>" value="P">
		<input type="hidden" name="funcId" value="<%=modFuncId %>">
		<input type="hidden" name="<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[0][0] %>" value="<%=patGrpBean.getField(EmsDB.EM_PER_PERSONAL_PARTICULAR[0][0]).getFormValue() %>">
		<input type="hidden" name="<%= EmsDB.EM_PAT_PATIENT_INFO[0][0] %>" value="<%=patGrpBean.getField(EmsDB.EM_PAT_PATIENT_INFO[0][0]).getFormValue() %>">
		<input type="hidden" name="<%= EmsDB.EM_LIV_RECORD[0][0] %>" value="<%=modLivBean.getField(EmsDB.EM_LIV_RECORD[0][0]).getFormValue() %>">
		</form>
		
		<form name="mntPatient" action="mntPatient" method="post" enctype="multipart/form-data">
		<div style="display:none" id="enqDetailScreen">
			<div class="w3-bar">
				<a class="w3-bar-item w3-button color1 mc-tabBtn" id="enqTabBtn1" onclick="switchTabPage('enq',1)"><i class="fas fa-file-alt fa-fw"></i></a>
				<a class="w3-bar-item w3-button w3-grey mc-tabBtn" id="enqTabBtn2" onclick="switchTabPage('enq',2)"><i class="fas fa-copy fa-fw"></i></a>
				<a class="w3-bar-item w3-button w3-grey mc-tabBtn" id="enqTabBtn3" onclick="switchTabPage('enq',3)"><i class="fas fa-user-friends fa-fw"></i></a>
				<a class="w3-bar-item w3-button w3-grey mc-tabBtn" id="enqTabBtn4" onclick="switchTabPage('enq',4)"><i class="fas fa-file-invoice-dollar fa-fw"></i></a>
				<a class="w3-bar-item w3-button w3-grey mc-tabBtn" id="enqTabBtn5" onclick="switchTabPage('enq',5)"><i class="fas fa-print fa-fw"></i></a>
			</div>
			<div id="enqTabPage1">
				<table class="w3-table">
					<tr>
						<th class="color1 w3-xlarge">院友 - 個人資料
						<a class="mc-button w3-red w3-xlarge w3-right" onclick="showScreen('delPatientScreen');"><i class="fas fa-trash-alt fa-fw"></i>退院</a>
						<i class="w3-right">&nbsp;</i>
						<a class="mc-button color4 w3-xlarge w3-right" onclick="showScreen('modDetailScreen');"><i class="fas fa-edit"></i>編輯</a>
						</th>
					</tr>
				</table>
				<table class="w3-table-all" id="enqDetailTabPage1ScreenTable">
					<col width="10%">
					<col width="40%">
					<col width="10%">
					<col width="40%">
				<tr><td colspan="4" class="w3-xlarge mc-bold mc-underline">個人資料</td></tr>
			  	<tr>
			  		<td>狀態</td>
			  		<td><span id="detailLIV_STATUS">-</span></td> 
			  		<td>入住編號</td>
			  		<td><span id="detailLIV_ID">-</span></td> 
			  	</tr>
			  	<tr>
			  		<td>中文姓名</td>
			  		<td><span id="detailPER_CHI_NAME">-</span></td>
			  		<td>英文姓名</td>
			  		<td><span id="detailPER_ENG_NAME">-</span></td> 
			  	</tr>
			  	<tr>
			  		<td>身份證號碼</td>
			  		<td><span id="detailPER_HKID">-</span></td> 
			  		<td>性別</td>
			  		<td><span id="detailPER_GENDER">-</span></td> 
			  	</tr>
			  	<tr>
			  		<td>出生日期</td>
			  		<td><span id="detailPER_NBIRTH">-</span></td> 
			  		<td>農曆</td>
			  		<td><span id="detailPER_LBIRTH">-</span></td> 
			  	</tr>
			  	<tr>
			  		<td>電話</td>
			  		<td><span id="detailPER_TEL">-</span></td> 
			  		<td>電郵</td>
			  		<td><span id="detailPER_EMAIL">-</span></td> 
			  	</tr>
			  	<tr>
			  		<td>資訊</td>
			  		<td><span id="detailPER_DESC">-</span></td> 
			  		<td>圖檔</td>
			  		<td><span id="detailPER_IMAGE_LINK">-</span></td> 
			  	</tr>
				</table>
			</div>
			<div id="enqTabPage2" style="display:none">
				<table class="w3-table">
					<tr>
						<th class="color1 w3-xlarge">院友 - 其他資料
						<a class="mc-button w3-red w3-xlarge w3-right" onclick="showScreen('delPatientScreen');"><i class="fas fa-trash-alt fa-fw"></i>退院</a>
						<i class="w3-right">&nbsp;</i>
						<a class="mc-button color4 w3-xlarge w3-right" onclick="showScreen('modDetailScreen');"><i class="fas fa-edit"></i>編輯</a>
						</th>
					</tr>
				</table>
				<table class="w3-table-all" id="enqDetailTabPage2ScreenTable">
					<col width="10%">
					<col width="40%">
					<col width="10%">
					<col width="40%">
				  	<tr><td colspan="4" class="w3-xlarge mc-bold mc-underline">床位資料</td></tr>
				  	<tr>
				  		<td>床號</td>
				  		<td><span id="detailBED_FULL_NAME">-</span></td> 
				  		<td>床位類別</td>
				  		<td><span id="detailLIV_TYPE">-</span></td> 
				  	</tr>
				  	<tr>
				  		<td>入住日期</td>
				  		<td><span id="detailLIV_START_DATE">-</span></td> 
					  	<td>床位費</td>
					  	<td><span id="detailLIV_LIVING_FEE">-</span></td>
				  	</tr>
				  	<tr>
				  		<td>護理費</td>
				  		<td colspan="3"><span id="detailLIV_NURSING_FEE">-</span></td> 
				  	</tr>
				  	<tr><td colspan="4" class="w3-xlarge mc-bold mc-underline">評核資料</td></tr>
				  	<tr>
				  		<td>LDS編號</td>
				  		<td><span id="detailPER_LDS_REF">-</span></td> 
				  		<td>評核結果</td>
				  		<td><span id="detailPER_LDS_RESULT">-</span></td> 
				  	</tr>
				  	<tr>
				  		<td>評核日期</td>
				  		<td colspan="3"><span id="detailPER_LDS_DATE">-</span></td> 
				  	</tr>
						<tr>
					  		<td>行動能力</td>
					  		<td colspan="3"><span id="detailPER_ASS1">-</span></td> 
						</tr>
						<tr>
							<td>飲食種類</td>
					  		<td colspan="3"><span id="detailPER_ASS2">-</span><span id="detailPER_ASS2_OTH"></span></td> 
						</tr>
						<tr>
							<td>護理服務</td>
					  		<td colspan="3"><span id="detailPER_ASS3">-</span><span id="detailPER_ASS3_OTH"></span></td> 
						</tr>
						<tr>
							<td>護理程度</td>
					  		<td colspan="3"><span id="detailPER_ASS4">-</span></td> 
						</tr>
						<tr>
							<td>媒介</td>
					  		<td colspan="3"><span id="detailPER_REFERAL">-</span><span id="detailPER_REFERAL_OTH"></span></td>
						</tr>
				</table>
			</div>
			<div id="enqTabPage3" style="display:none">
				<table class="w3-table">
					<tr>
						<th class="color1 w3-xlarge">院友 - 親友資料
						<a class="mc-button w3-red w3-xlarge w3-right" onclick="showScreen('delPatientScreen');"><i class="fas fa-trash-alt fa-fw"></i>退院</a>
						<i class="w3-right">&nbsp;</i>
						<a class="mc-button color4 w3-xlarge w3-right" onclick="showScreen('modDetailScreen');"><i class="fas fa-edit"></i>編輯</a>
						</th>
					</tr>
				</table>
				<div style="overflow-x:auto;">
					<table id="depositeListTable">
						<tr>
					  		<td>通知順序</td>
					  		<td>名稱</td> 
					  		<td>關係</td>
					  		<td>電話</td>
					  		<td>電郵</td>
						</tr>
						<tr id="detailPCO1">
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
						</tr>
						<tr id="detailPCO2">
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
						</tr>
						<tr id="detailPCO3">
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
						</tr>
						<tr id="detailPCO4">
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
						</tr>
						<tr id="detailPCO5">
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
						</tr>
					</table>
				</div>
			</div>
			<div id="enqTabPage4" style="display:none">
				<table class="w3-table">
					<tr>
						<th class="color1 w3-xlarge">按金 - 按金交易記錄
						<a class="mc-button w3-red w3-xlarge w3-right" onclick="showScreen('delPatientScreen');"><i class="fas fa-trash-alt fa-fw"></i>退院</a>
						<i class="w3-right">&nbsp;</i>
						<a class="mc-button color4 w3-xlarge w3-right" onclick="showScreen('modDetailScreen');"><i class="fas fa-edit"></i>編輯</a>
						</th>
					</tr>
				</table>
				<div style="overflow-x:auto;">
				<table id="transListTable">
					<tr>
						<td>入賬日期</td>
						<td>項目</td>
						<td>繳費方法</td>
						<td>交易編號</td>
						<td>金額 (港幣)</td>
						<td>戶口結餘 (港幣)</td>
						<td>備註</td>
					</tr>
				</table>
			</div>
			</div>
			
			<div id="enqTabPage5" style="display:none">
				<table class="w3-table"><tr><th class="color1 w3-xlarge">訂位 - 列印訂位確認書<a class="mc-button color4 w3-right" onclick="printSlip()"><i class="fas fa-print"></i>列印</a></th></tr></table>
				<div style="overflow-x:auto;">
			  		<iframe id="slipFrame" src="/EMS/jsp/INC/slip.html" style="width:100%; border: 0;"></iframe>
			  	</div>				
			</div>
  			<a class="mc-button color4 w3-large" onclick="showScreen('enqScreen');"><i class="fas fa-times"></i>返回</a>
		</div>
		</form>
		
		<form name="mntPatient" action="mntPatient" method="post" enctype="multipart/form-data">
		<div style="display:none" id="delPatientScreen">
			<table class="w3-table-all" id="delPatientScreenTable">
					<col width="10%">
					<col width="40%">
					<col width="10%">
					<col width="40%">
				<tr>
					<th colspan="4" class="color1 w3-xlarge">退院</th>
				</tr>
				<tr><td colspan="4" class="w3-xlarge mc-bold mc-underline">個人資料</td></tr>
				<tr>
			  		<td>訂位狀態:</td>
			  		<td><span id="cancelRES_STATUS">-</span></td> 
			  		<td>訂位編號:</td>
			  		<td><span id="cancelRES_ID">-</span></td>  
			  	</tr>
			  	<tr>
			  		<td>中文姓名:</td>
			  		<td><span id="cancelPER_CHI_NAME">-</span></td> 
			  		<td>英文姓名:</td>
			  		<td><span id="cancelPER_ENG_NAME">-</span></td>  
			  	</tr>
			  	<tr>
			  		<td>身份證號碼:</td>
			  		<td><span id="cancelPER_HKID">-</span></td> 
			  		<td>性別:</td>
			  		<td><span id="cancelPER_GENDER">-</span></td>  
			  	</tr>
			  	<tr>
			  		<td>出生日期:</td>
			  		<td><span id="cancelPER_NBIRTH">-</span></td> 
			  		<td>農曆: <span class="w3-text-red mc-italic"></span></td>
			  		<td><span id="cancelPER_LBIRTH">-</span></td>  
			  	</tr>
			  	<tr><td colspan="4" class="w3-xlarge mc-bold mc-underline">退回訂金資料</td></tr>
			  	<tr>
			  		<td>戶口結餘:</td>
			  		<td><span id="cancelRES_BALANCE">-</span></td>
			  	</tr>			  	
				<tr>
			  		<td>退回訂金金額: <span class="w3-text-red mc-italic"><%=transBean.getField(EmsDB.EM_TRA_TRANSACTIONS[8][0]).getMsg() %></span></td>
			  		<td><input type="text" name="<%= EmsDB.EM_TRA_TRANSACTIONS[8][0] %>" value="<%=transBean.getField(EmsDB.EM_TRA_TRANSACTIONS[8][0]).getFormValue() %>" maxlength="<%= EmsDB.EM_TRA_TRANSACTIONS[8][3] %>" class="mc-fw" style="max-width:10em">(港幣)</td>
			  		<td>付款方法: <span class="w3-text-red mc-italic"><%=transBean.getField(EmsDB.EM_TRA_TRANSACTIONS[9][0]).getMsg() %></span></td>
			  		<td>
				  		<select name="<%= EmsDB.EM_TRA_TRANSACTIONS[9][0] %>" style="width:150px;">
							<% if(transBean.getField(EmsDB.EM_TRA_TRANSACTIONS[9][0]).getFormValue().equals("")){ %>
								<option value="" selected></option>
							<% }else{ %>
								<option value=""></option>
							<% } %>
							<% if(transBean.getField(EmsDB.EM_TRA_TRANSACTIONS[9][0]).getFormValue().equals("1")){ %>
								<option value="1" selected>現金</option>
							<% }else{ %>
								<option value="1">現金</option>
							<% } %>
							<% if(transBean.getField(EmsDB.EM_TRA_TRANSACTIONS[9][0]).getFormValue().equals("2")){ %>
								<option value="2" selected>支票</option>
							<% }else{ %>
								<option value="2">支票</option>
							<% } %>
					</select>
			  		</td>  
			  	</tr>
			  	<tr>
					<td>退回日期: <span class="w3-text-red mc-italic"><%=transBean.getField(EmsDB.EM_TRA_TRANSACTIONS[7][0]).getMsg() %></span></td>
			  		<td>
			  			<div class="flatpickr date-container">
		   					<input type="text" name="<%= EmsDB.EM_TRA_TRANSACTIONS[7][0] %>" value="<%=transBean.getField(EmsDB.EM_TRA_TRANSACTIONS[7][0]).getFormValue() %>" maxlength="<%=transBean.getField(EmsDB.EM_TRA_TRANSACTIONS[7][3]) %>" size="12" data-input>
		   					<a class="mc-button-2 icon" data-clear>&times;</a>
						</div>
			  		</td> 
				  	<td>備註: <span class="w3-text-red mc-italic"><%=transBean.getField(EmsDB.EM_TRA_TRANSACTIONS[10][0]).getMsg() %></span></td>
				  	<td><input type="text" name="<%= EmsDB.EM_TRA_TRANSACTIONS[10][0] %>" value="<%=transBean.getField(EmsDB.EM_TRA_TRANSACTIONS[10][0]).getFormValue() %>" maxlength="<%= EmsDB.EM_TRA_TRANSACTIONS[10][3] %>" class="mc-fw" style="max-width:10em"></td>
				</tr>
			</table>
			<a class="mc-button color4 w3-large" onclick="showConfirmMessage('是否取消訂位?','w');"><i class="fas fa-check"></i>確定</a>
			<a class="mc-button color4 w3-large" onclick="showScreen('enqDetailScreen');"><i class="fas fa-times"></i>返回</a>
		</div>
		<input type="hidden" name="<%= EmsDB.EM_TRA_TRANSACTIONS[5][0] %>" value="按金">
	  	<input type="hidden" name="<%= EmsDB.EM_TRA_TRANSACTIONS[6][0] %>" value="D">
	  	<input type="hidden" name="<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[24][0] %>" value="Y">
	  	<input type="hidden" name="<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[11][0] %>" value="P">
		<input type="hidden" name="funcId" value="<%=delFuncId %>">
		<input type="hidden" name="<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[0][0] %>" value="<%=patGrpBean.getField(EmsDB.EM_PER_PERSONAL_PARTICULAR[0][0]).getFormValue() %>">
		<input type="hidden" name="<%= EmsDB.EM_PAT_PATIENT_INFO[0][0] %>" value="<%=patGrpBean.getField(EmsDB.EM_PAT_PATIENT_INFO[0][0]).getFormValue() %>">
		<input type="hidden" name="<%= EmsDB.EM_LIV_RECORD[0][0] %>" value="<%=livBean.getField(EmsDB.EM_LIV_RECORD[0][0]).getFormValue() %>">
		</form>
				
		
	</div>
</div>
<!-- CONTENT END -->

</body>

<script>
flatpickr(".flatpickr", {
	wrap:true,
	"locale": "zh",
	disableMobile: "true"
});

setTitle("<%=userBean.getRolBean().getFuncBean(funcId).getField("FUN_NAVI").getFormValue() %>");
setMenuButtonGlow("<%=funcId%>");
<% if(funcId!=null && funcId.length()>=6){
	if(funcId.substring(0,2).equals("01")){
%>
ddlFunc('ddlMntOrg');
<%	}else if(funcId.substring(0,2).equals("02")){ %>
ddlFunc('ddlMntRes');
<%	}else if(funcId.substring(0,2).equals("03")){ %>

<%	}else if(funcId.substring(0,2).equals("04")){ %>
ddlFunc('ddlMntSet');
<%
	}
}
%>

<% if(funcId.equals(addFuncId)){ %>
showScreen('addDetailScreen');
<% }else if(funcId.equals(modFuncId)){ %>
showScreen('modDetailScreen');
<% }else{ %>
showScreen('enqScreen');
<% } %>

var reserveBeanList = [ 
	<% for(int i=0;i<reserveBeanList.size();i++){ %>
	{
		<% for(int j=0;j<reserveBeanList.get(i).getFields().size();j++){
			String fieldName = reserveBeanList.get(i).getFields().get(j).getName();%>
			<%=fieldName%>:"<%=reserveBeanList.get(i).getFields().get(j).getFormValue()%>",
		<%}%>
		<% for(int j=0;j<reserveBeanList.get(i).getPerBean().getFields().size();j++){
			String fieldName = reserveBeanList.get(i).getPerBean().getFields().get(j).getName();%>
			<%=fieldName%>:"<%=reserveBeanList.get(i).getPerBean().getFields().get(j).getFormValue()%>",
		<%}%>
		<% for(int j=0;j<reserveBeanList.get(i).getBedBean().getFields().size();j++){
			String fieldName = reserveBeanList.get(i).getBedBean().getFields().get(j).getName();%>
			<%=fieldName%>:"<%=reserveBeanList.get(i).getBedBean().getFields().get(j).getFormValue()%>",
		<%}%>
		
		BED_FULL_NAME : "<%=  reserveBeanList.get(i).getBedBean().getBedFullName()  %>",
		
		PCO_CHI_NAME : [
		<% for(int j=0;j<reserveBeanList.get(i).getPerBean().getPcoBeanList().size();j++){
				String fieldValue = reserveBeanList.get(i).getPerBean().getPcoBeanList().get(j).getPerBean().getField("PER_CHI_NAME").getFormValue();
		%>
				"<%= fieldValue %>"
				<% if(j<reserveBeanList.get(i).getPerBean().getPcoBeanList().size()-1){ %>
					,		
				<% } %>
		<%	
		}%>
		], 
		
		PCO_REL : [
			<% for(int j=0;j<reserveBeanList.get(i).getPerBean().getPcoBeanList().size();j++){
					String fieldValue = reserveBeanList.get(i).getPerBean().getPcoBeanList().get(j).getField("PCO_REL").getFormValue();
			%>
					"<%= fieldValue %>"
					<% if(j<reserveBeanList.get(i).getPerBean().getPcoBeanList().size()-1){ %>
						,		
					<% } %>
			<%	
			}%>
			], 
			
		PCO_TEL : [
		<% for(int j=0;j<reserveBeanList.get(i).getPerBean().getPcoBeanList().size();j++){
				String fieldValue = reserveBeanList.get(i).getPerBean().getPcoBeanList().get(j).getPerBean().getField("PER_TEL").getFormValue();
		%>
				"<%= fieldValue %>"
				<% if(j<reserveBeanList.get(i).getPerBean().getPcoBeanList().size()-1){ %>
					,		
				<% } %>
		<%	
		}%>
		], 

		PCO_EMAIL : [
		<% for(int j=0;j<reserveBeanList.get(i).getPerBean().getPcoBeanList().size();j++){
				String fieldValue = reserveBeanList.get(i).getPerBean().getPcoBeanList().get(j).getPerBean().getField("PER_EMAIL").getFormValue();
		%>
				"<%= fieldValue %>"
				<% if(j<reserveBeanList.get(i).getPerBean().getPcoBeanList().size()-1){ %>
					,		
				<% } %>
		<%	
		}%>
		],
		
		TRA_ID : [
		<% for(int j=0;j<reserveBeanList.get(i).getPerBean().getTransBeanList().size();j++){
				String fieldValue = reserveBeanList.get(i).getPerBean().getTransBeanList().get(j).getField("TRA_ID").getFormValue();
		%>
				"<%= fieldValue %>"
				<% if(j<reserveBeanList.get(i).getPerBean().getTransBeanList().size()-1){ %>
					,		
				<% } %>
		<%	
		}%>
		],
			
		TRA_DATE : [
		<% for(int j=0;j<reserveBeanList.get(i).getPerBean().getTransBeanList().size();j++){
				String fieldValue = reserveBeanList.get(i).getPerBean().getTransBeanList().get(j).getField("TRA_DATE").getFormValue();
		%>
				"<%= fieldValue %>"
				<% if(j<reserveBeanList.get(i).getPerBean().getTransBeanList().size()-1){ %>
					,		
				<% } %>
		<%	
		}%>
		],
				
		TRA_NAME : [
			<% for(int j=0;j<reserveBeanList.get(i).getPerBean().getTransBeanList().size();j++){
					String fieldValue = reserveBeanList.get(i).getPerBean().getTransBeanList().get(j).getField("TRA_NAME").getFormValue();
			%>
					"<%= fieldValue %>"
					<% if(j<reserveBeanList.get(i).getPerBean().getTransBeanList().size()-1){ %>
						,		
					<% } %>
			<%	
			}%>
			],
					
		TRA_AMOUNT : [
			<%  BigDecimal resBal = new BigDecimal(0);
				for(int j=0;j<reserveBeanList.get(i).getPerBean().getTransBeanList().size();j++){
					
					if(reserveBeanList.get(i).getPerBean().getTransBeanList().get(j).getField("TRA_AMOUNT").getValue() != null)
						resBal = resBal.add((BigDecimal)reserveBeanList.get(i).getPerBean().getTransBeanList().get(j).getField("TRA_AMOUNT").getValue());
					
					String fieldValue = reserveBeanList.get(i).getPerBean().getTransBeanList().get(j).getField("TRA_AMOUNT").getFormValue();
					
			%>
					"<%= fieldValue %>"
					<% if(j<reserveBeanList.get(i).getPerBean().getTransBeanList().size()-1){ %>
						,		
					<% } %>
			<%	
			}%>
			],
					
		TRA_METHOD : [
		<% for(int j=0;j<reserveBeanList.get(i).getPerBean().getTransBeanList().size();j++){
				String fieldValue = reserveBeanList.get(i).getPerBean().getTransBeanList().get(j).getField("TRA_METHOD").getFormValue();
				if("1".equals(fieldValue))
					fieldValue  = "現金";
				else if("2".equals(fieldValue))
					fieldValue  = "支票";
		%>
				"<%= fieldValue %>"
				<% if(j<reserveBeanList.get(i).getPerBean().getTransBeanList().size()-1){ %>
					,		
				<% } %>
		<%	
		}%>
		],
						
		TRA_NOTE : [
		<% for(int j=0;j<reserveBeanList.get(i).getPerBean().getTransBeanList().size();j++){
				String fieldValue = reserveBeanList.get(i).getPerBean().getTransBeanList().get(j).getField("TRA_NOTE").getFormValue();
		%>
				"<%= fieldValue %>"
				<% if(j<reserveBeanList.get(i).getPerBean().getTransBeanList().size()-1){ %>
					,		
				<% } %>
		<%	
		}%>
		],
		
		
		RES_BALANCE :"<%=resBal%>"

	}
	<% if(i!=reserveBeanList.size()-1){ %>,<% } %>
	<% } %>];


var quoteBeanList = [ 
	<% for(int i=0;i<quoteBeanList.size();i++){ %>
	{
		<% for(int j=0;j<quoteBeanList.get(i).getFields().size();j++){
			String fieldName = quoteBeanList.get(i).getFields().get(j).getName();%>
			<%=fieldName%>:"<%=quoteBeanList.get(i).getFields().get(j).getFormValue()%>",
		<%}%>
		<% for(int j=0;j<quoteBeanList.get(i).getPerBean().getFields().size();j++){
			String fieldName = quoteBeanList.get(i).getPerBean().getFields().get(j).getName();%>
			<%=fieldName%>:"<%=quoteBeanList.get(i).getPerBean().getFields().get(j).getFormValue()%>",
		<%}%>
		<% for(int j=0;j<quoteBeanList.get(i).getBedBean().getFields().size();j++){
			String fieldName = quoteBeanList.get(i).getBedBean().getFields().get(j).getName();%>
			<%=fieldName%>:"<%=quoteBeanList.get(i).getBedBean().getFields().get(j).getFormValue()%>",
		<%}%>
		
		BED_FULL_NAME : "<%=  quoteBeanList.get(i).getBedBean().getBedFullName()  %>",
		
		PCO_CHI_NAME : [
		<% for(int j=0;j<quoteBeanList.get(i).getPerBean().getPcoBeanList().size();j++){
				String fieldValue = quoteBeanList.get(i).getPerBean().getPcoBeanList().get(j).getPerBean().getField("PER_CHI_NAME").getFormValue();
		%>
				<%= fieldValue %>
				<% if(j<quoteBeanList.get(i).getPerBean().getPcoBeanList().size()-1){ %>
					,		
				<% } %>
		<%	
		}%>
		], 
		
		PCO_REL : [
			<% for(int j=0;j<quoteBeanList.get(i).getPerBean().getPcoBeanList().size();j++){
					String fieldValue = quoteBeanList.get(i).getPerBean().getPcoBeanList().get(j).getField("PCO_REL").getFormValue();
			%>
					<%= fieldValue %>
					<% if(j<quoteBeanList.get(i).getPerBean().getPcoBeanList().size()-1){ %>
						,		
					<% } %>
			<%	
			}%>
			], 
			
		PCO_TEL : [
		<% for(int j=0;j<quoteBeanList.get(i).getPerBean().getPcoBeanList().size();j++){
				String fieldValue = quoteBeanList.get(i).getPerBean().getPcoBeanList().get(j).getPerBean().getField("PER_TEL").getFormValue();
		%>
				<%= fieldValue %>
				<% if(j<quoteBeanList.get(i).getPerBean().getPcoBeanList().size()-1){ %>
					,		
				<% } %>
		<%	
		}%>
		], 

		PCO_EMAIL : [
		<% for(int j=0;j<quoteBeanList.get(i).getPerBean().getPcoBeanList().size();j++){
				String fieldValue = quoteBeanList.get(i).getPerBean().getPcoBeanList().get(j).getPerBean().getField("PER_EMAIL").getFormValue();
		%>
				<%= fieldValue %>
				<% if(j<quoteBeanList.get(i).getPerBean().getPcoBeanList().size()-1){ %>
					,		
				<% } %>
		<%	
		}%>
		]
	}
	<% if(i!=quoteBeanList.size()-1){ %>,<% } %>
	<% } %>];


function openPatientContainer() {
	document.getElementById("patientContainer").style.display = "block";
}
function closePatientContainer() {
	document.getElementById("patientContainer").style.display = "none";
}
function openQuoteListScreen() {
	document.getElementById("quoteListScreen").style.display = "block";
}
function closeQuoteListScreen() {
	document.getElementById("quoteListScreen").style.display = "none";
}
function openReserveListScreen() {
	document.getElementById("reserveListScreen").style.display = "block";
}
function closeReserveListScreen() {
	document.getElementById("reserveListScreen").style.display = "none";
}
function solarToLunar(fromId, toId){
	var fromDate = document.getElementById(fromId).value;
	if (fromDate == null || fromDate.length < 10) return;
	var lunarDate = calendar.solar2lunar(fromDate.substring(0,4),parseInt(fromDate.substring(5,7)),parseInt(fromDate.substring(8,10)));
	document.getElementById(toId).value = lunarDate.lYear + '-' + padzero(lunarDate.lMonth,2) + '-' + padzero(lunarDate.lDay,2);
}
function lunarToSolar(fromId, toId){
	var fromDate = document.getElementById(fromId).value;
	if (fromDate == null || fromDate.length < 10) return;
	var solarDate = calendar.lunar2solar(fromDate.substring(0,4),parseInt(fromDate.substring(5,7)),parseInt(fromDate.substring(8,10)));
	document.getElementById(toId).value = solarDate.cYear + '-' + padzero(solarDate.cMonth,2) + '-' + padzero(solarDate.cDay,2);
}

function copyQuoteRecord(recordNum){
	
	for(i=0;i<quoteBeanList[recordNum].PCO_CHI_NAME.length;i++){
   			document.getElementById("addPCO_CHI_NAME"+(i+1)).value = quoteBeanList[recordNum].PCO_CHI_NAME[i];
   			document.getElementById("addPCO_REL"+(i+1)).value = quoteBeanList[recordNum].PCO_REL[i];
   			document.getElementById("addPCO_TEL"+(i+1)).value = quoteBeanList[recordNum].PCO_TEL[i];
   			document.getElementById("addPCO_EMAIL"+(i+1)).value = quoteBeanList[recordNum].PCO_EMAIL[i];
	}	
	document.forms[2].<%= EmsDB.EM_QUO_RECORD[0][0] %>.value = quoteBeanList[recordNum].<%=EmsDB.EM_QUO_RECORD[0][0] %>;
	document.forms[2].<%= EmsDB.EM_RES_RECORD[0][0] %>.value = "";
	document.forms[2].<%= EmsDB.EM_LIV_RECORD[2][0] %>.value = quoteBeanList[recordNum].<%=EmsDB.EM_QUO_RECORD[3][0] %>+"-"+quoteBeanList[recordNum].<%=EmsDB.EM_QUO_RECORD[2][0] %>;
    document.forms[2].<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[0][0] %>.value = quoteBeanList[recordNum].<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[0][0] %>;
	document.forms[2].<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[2][0] %>.value = quoteBeanList[recordNum].<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[2][0] %>;
    document.forms[2].<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[3][0] %>.value = quoteBeanList[recordNum].<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[3][0] %>;
	document.forms[2].<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[4][0] %>.value = quoteBeanList[recordNum].<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[4][0] %>;
	document.forms[2].<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[5][0] %>.value = quoteBeanList[recordNum].<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[5][0] %>;
    document.forms[2].<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[6][0] %>.value = quoteBeanList[recordNum].<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[6][0] %>;
    document.forms[2].<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[7][0] %>.value = quoteBeanList[recordNum].<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[7][0] %>;
    document.forms[2].<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[8][0] %>.value = quoteBeanList[recordNum].<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[8][0] %>;
    document.forms[2].<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[9][0] %>.value = quoteBeanList[recordNum].<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[9][0] %>;
    document.forms[2].<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[10][0] %>.value = quoteBeanList[recordNum].<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[10][0] %>;
    if(quoteBeanList[recordNum].<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[12][0] %> != ""){
        document.forms[2].<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[12][0] %>.value = quoteBeanList[recordNum].<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[12][0] %>;
		
    }else{
    	document.forms[2].<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[12][0] %>.value = "";
    }
    document.forms[2].<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[13][0] %>.value = quoteBeanList[recordNum].<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[13][0] %>;
    document.forms[2].<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[14][0] %>.value = quoteBeanList[recordNum].<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[14][0] %>;
    document.forms[2].<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[15][0] %>.value = quoteBeanList[recordNum].<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[15][0] %>;
    document.forms[2].<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[16][0] %>.value = quoteBeanList[recordNum].<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[16][0] %>;
    document.forms[2].<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[17][0] %>.value = quoteBeanList[recordNum].<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[17][0] %>;
    document.forms[2].<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[18][0] %>.value = quoteBeanList[recordNum].<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[18][0] %>;
    document.forms[2].<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[19][0] %>.value = quoteBeanList[recordNum].<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[19][0] %>;
    document.forms[2].<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[20][0] %>.value = quoteBeanList[recordNum].<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[20][0] %>;
    document.forms[2].<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[21][0] %>.value = quoteBeanList[recordNum].<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[21][0] %>;
    document.forms[2].<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[22][0] %>.value = quoteBeanList[recordNum].<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[22][0] %>;
    document.forms[2].<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[23][0] %>.value = quoteBeanList[recordNum].<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[23][0] %>;
    document.forms[2].<%= EmsDB.EM_LIV_RECORD[5][0] %>.value = quoteBeanList[recordNum].<%= EmsDB.EM_QUO_RECORD[5][0] %>;
    document.forms[2].<%= EmsDB.EM_LIV_RECORD[7][0] %>.value = quoteBeanList[recordNum].<%= EmsDB.EM_QUO_RECORD[7][0] %>;
    document.forms[2].<%= EmsDB.EM_LIV_RECORD[8][0] %>.value = quoteBeanList[recordNum].<%= EmsDB.EM_QUO_RECORD[8][0] %>;
	document.forms[2].<%= EmsDB.EM_LIV_RECORD[9][0] %>.value = quoteBeanList[recordNum].<%= EmsDB.EM_QUO_RECORD[9][0] %>;


}

function copyReserveRecord(recordNum){
	
	
	for(i=0;i<reserveBeanList[recordNum].PCO_CHI_NAME.length;i++){
   			document.getElementById("addPCO_CHI_NAME"+(i+1)).value = reserveBeanList[recordNum].PCO_CHI_NAME[i];
   			document.getElementById("addPCO_REL"+(i+1)).value = reserveBeanList[recordNum].PCO_REL[i];
   			document.getElementById("addPCO_TEL"+(i+1)).value = reserveBeanList[recordNum].PCO_TEL[i];
   			document.getElementById("addPCO_EMAIL"+(i+1)).value = reserveBeanList[recordNum].PCO_EMAIL[i];
	}	


	document.forms[2].<%= EmsDB.EM_RES_RECORD[0][0] %>.value = reserveBeanList[recordNum].<%=EmsDB.EM_RES_RECORD[0][0] %>;
	document.forms[2].<%= EmsDB.EM_QUO_RECORD[0][0] %>.value = "";
	document.forms[2].<%= EmsDB.EM_LIV_RECORD[2][0] %>.value = reserveBeanList[recordNum].<%=EmsDB.EM_RES_RECORD[3][0] %>+"-"+reserveBeanList[recordNum].<%=EmsDB.EM_RES_RECORD[2][0] %>;
	document.forms[2].<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[0][0] %>.value = reserveBeanList[recordNum].<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[0][0] %>;
	document.forms[2].<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[2][0] %>.value = reserveBeanList[recordNum].<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[2][0] %>;
    document.forms[2].<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[3][0] %>.value = reserveBeanList[recordNum].<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[3][0] %>;
	document.forms[2].<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[4][0] %>.value = reserveBeanList[recordNum].<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[4][0] %>;
	document.forms[2].<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[5][0] %>.value = reserveBeanList[recordNum].<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[5][0] %>;
    document.forms[2].<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[6][0] %>.value = reserveBeanList[recordNum].<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[6][0] %>;
    document.forms[2].<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[7][0] %>.value = reserveBeanList[recordNum].<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[7][0] %>;
    document.forms[2].<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[8][0] %>.value = reserveBeanList[recordNum].<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[8][0] %>;
    document.forms[2].<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[9][0] %>.value = reserveBeanList[recordNum].<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[9][0] %>;
    document.forms[2].<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[10][0] %>.value = reserveBeanList[recordNum].<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[10][0] %>;
    if(reserveBeanList[recordNum].<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[12][0] %> != ""){
        document.forms[2].<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[12][0] %>.value = reserveBeanList[recordNum].<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[12][0] %>;
		
    }else{
    	document.forms[2].<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[12][0] %>.value = "";
    }
    document.forms[2].<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[13][0] %>.value = reserveBeanList[recordNum].<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[13][0] %>;
    document.forms[2].<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[14][0] %>.value = reserveBeanList[recordNum].<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[14][0] %>;
    document.forms[2].<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[15][0] %>.value = reserveBeanList[recordNum].<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[15][0] %>;
    document.forms[2].<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[16][0] %>.value = reserveBeanList[recordNum].<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[16][0] %>;
    document.forms[2].<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[17][0] %>.value = reserveBeanList[recordNum].<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[17][0] %>;
    document.forms[2].<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[18][0] %>.value = reserveBeanList[recordNum].<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[18][0] %>;
    document.forms[2].<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[19][0] %>.value = reserveBeanList[recordNum].<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[19][0] %>;
    document.forms[2].<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[20][0] %>.value = reserveBeanList[recordNum].<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[20][0] %>;
    document.forms[2].<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[21][0] %>.value = reserveBeanList[recordNum].<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[21][0] %>;
    document.forms[2].<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[22][0] %>.value = reserveBeanList[recordNum].<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[22][0] %>;
    document.forms[2].<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[23][0] %>.value = reserveBeanList[recordNum].<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[23][0] %>;
    document.forms[2].<%= EmsDB.EM_LIV_RECORD[5][0] %>.value = reserveBeanList[recordNum].<%= EmsDB.EM_RES_RECORD[5][0] %>;
    document.forms[2].<%= EmsDB.EM_LIV_RECORD[7][0] %>.value = reserveBeanList[recordNum].<%= EmsDB.EM_RES_RECORD[7][0] %>;
    document.forms[2].<%= EmsDB.EM_LIV_RECORD[8][0] %>.value = reserveBeanList[recordNum].<%= EmsDB.EM_RES_RECORD[8][0] %>;
	document.forms[2].<%= EmsDB.EM_LIV_RECORD[9][0] %>.value = reserveBeanList[recordNum].<%= EmsDB.EM_RES_RECORD[9][0] %>;

	document.getElementById("addRES_BALANCE").innerHTML = reserveBeanList[recordNum].RES_BALANCE;

}

function getAjaxQuoData(enqPerId){
	var xhr = new XMLHttpRequest();
	xhr.open('GET', 'getAjaxPer?quoGrpBean.enqPerId='+enqPerId);
	xhr.onload = function() {
	    if (xhr.status === 200) {
	        var obj = JSON.parse(xhr.responseText);
        	for(i=0;i<5;i++){
       			document.getElementById("detailPCO"+(i+1)).innerHTML = "<td></td><td></td><td></td><td></td><td></td>";
        	}
        	
        	for(i=0;i<obj.pcoChiName.length;i++){
       			document.getElementById("detailPCO"+(i+1)).innerHTML = "<td>"+obj.pcoSeq[i]+"</td><td>"+obj.pcoChiName[i]+"</td><td>"+obj.pcoRel[i]+"</td><td>"+obj.pcoTel[i]+"</td><td>"+obj.pcoEmail[i]+"</td>";
       			document.getElementById("addPCO_CHI_NAME"+(i+1)).value = obj.pcoChiName[i];
       			document.getElementById("addPCO_REL"+(i+1)).value = obj.pcoRel[i];
       			document.getElementById("addPCO_TEL"+(i+1)).value = obj.pcoTel[i];
       			document.getElementById("addPCO_EMAIL"+(i+1)).value = obj.pcoEmail[i];
        	}
        	
	    }
	};
	xhr.send();
}

function getAjaxResData(enqPerId){
	var xhr = new XMLHttpRequest();
	xhr.open('GET', 'getAjaxPer?resGrpBean.enqPerId='+enqPerId);
	xhr.onload = function() {
	    if (xhr.status === 200) {
	        var obj = JSON.parse(xhr.responseText);
        	for(i=0;i<5;i++){
       			document.getElementById("detailPCO"+(i+1)).innerHTML = "<td></td><td></td><td></td><td></td><td></td>";
        	}
        	
        	for(i=0;i<obj.pcoChiName.length;i++){
       			document.getElementById("detailPCO"+(i+1)).innerHTML = "<td>"+obj.pcoSeq[i]+"</td><td>"+obj.pcoChiName[i]+"</td><td>"+obj.pcoRel[i]+"</td><td>"+obj.pcoTel[i]+"</td><td>"+obj.pcoEmail[i]+"</td>";
       			document.getElementById("addPCO_CHI_NAME"+(i+1)).value = obj.pcoChiName[i];
       			document.getElementById("addPCO_REL"+(i+1)).value = obj.pcoRel[i];
       			document.getElementById("addPCO_TEL"+(i+1)).value = obj.pcoTel[i];
       			document.getElementById("addPCO_EMAIL"+(i+1)).value = obj.pcoEmail[i];
        	}
        	
	    }
	};
	xhr.send();
}

function getAjaxData(enqPatId){
	var xhr = new XMLHttpRequest();
	document.getElementById("patientContainerLoading").style.display = "block";
	document.getElementById("patientContainerContent").style.display = "none";
	document.getElementById("patientContainerMsg").innerHTML = '<i class="fas fa-spinner fa-spin fa-5x"></i>';
	xhr.open('GET', 'getAjaxPat?patGrpBean.enqPatId='+enqPatId);
	xhr.onload = function() {
	    if (xhr.status === 200) {
	        var obj = JSON.parse(xhr.responseText);
	        
	        if(obj.perImageLink != ""){
		        document.getElementById("briefPER_IMAGE_LINK").innerHTML = "<img src='/EMS/images/"+obj.perImageLink+"' width='200'>";
		        document.getElementById("detailPER_IMAGE_LINK").innerHTML = "<img src='/EMS/images/"+obj.perImageLink+"' width='200'>";
		        document.getElementById("mod<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[12][0] %>").innerHTML = "<img src='/EMS/images/"+obj.perImageLink+"' width='200'>";
		        document.forms[3].<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[12][0] %>.value = obj.perImageLink;
				
	        }else{
	        	document.getElementById("briefPER_IMAGE_LINK").innerHTML = "";
	        	document.getElementById("detailPER_IMAGE_LINK").innerHTML = "";
	        	document.getElementById("mod<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[12][0] %>").innerHTML = "";
	        	document.forms[3].<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[12][0] %>.value = "";
	        }
	        
	        document.getElementById("detailLIV_ID").innerHTML = obj.livId;
        	document.forms[3].<%= EmsDB.EM_LIV_RECORD[0][0] %>.value = obj.livId;
	        
	        document.getElementById("briefPER_CHI_NAME").innerHTML = obj.perChiName;
	        document.getElementById("detailPER_CHI_NAME").innerHTML = obj.perChiName;
	        document.forms[3].<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[2][0] %>.value = obj.perChiName;
	    	
	        document.getElementById("detailPER_ENG_NAME").innerHTML = obj.perEngName;
	        document.forms[3].<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[3][0] %>.value = obj.perEngName;
	        
	        document.getElementById("briefPAT_ID").innerHTML = obj.patId;
	        document.forms[3].<%= EmsDB.EM_PAT_PATIENT_INFO[0][0] %>.value = obj.patId;
	        
	        document.getElementById("briefBED_FULL_NAME").innerHTML = obj.bedFullName;
	        document.getElementById("detailBED_FULL_NAME").innerHTML = obj.bedFullName;
	    	
	        document.forms[3].<%= EmsDB.EM_LIV_RECORD[2][0] %>.value = obj.livZoneId+"-"+obj.livBedId;
	        
	        if(obj.livStatus == 'Y'){
	        	document.getElementById("briefLIV_STATUS").className = 'w3-text-green mc-bold';
	        	document.getElementById("briefLIV_STATUS").innerHTML = "入住中";
	        	document.getElementById("detailLIV_STATUS").className = 'w3-text-green mc-bold';
	        	document.getElementById("detailLIV_STATUS").innerHTML = "入住中";
	        }else{
	        	document.getElementById("briefLIV_STATUS").className = 'w3-text-red mc-bold';
	        	document.getElementById("briefLIV_STATUS").innerHTML = "已退院";
	        	document.getElementById("detailLIV_STATUS").className = 'w3-text-red mc-bold';
	        	document.getElementById("detailLIV_STATUS").innerHTML = "已退院";
	        }
	        
	        if(obj.perGender == 'M'){
		        document.getElementById("briefPER_GENDER").innerHTML = '男';
		        document.getElementById("detailPER_GENDER").innerHTML = '男';
	        }else if(obj.perGender == 'F'){
	        	document.getElementById("briefPER_GENDER").innerHTML = '女';
	        	document.getElementById("detailPER_GENDER").innerHTML = '女';
	        }else{
	        	document.getElementById("briefPER_GENDER").innerHTML = '';
	        	document.getElementById("detailPER_GENDER").innerHTML = '';
	        }
	        document.forms[3].<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[7][0] %>.value = obj.perGender;
	    	
	        document.getElementById("briefPER_HKID").innerHTML = obj.perHKID;
	        document.getElementById("detailPER_HKID").innerHTML = obj.perHKID;
	        document.forms[3].<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[6][0] %>.value = obj.perHKID;

	        document.getElementById("briefPER_NBIRTH").innerHTML = obj.perNBirth +" ("+getAge(obj.perNBirth) +"歲)";
	        document.getElementById("detailPER_NBIRTH").innerHTML = obj.perNBirth +" ("+getAge(obj.perNBirth) +"歲)";
	        document.forms[3].<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[4][0] %>.value = obj.perNBirth;
	        
	        document.getElementById("briefLIV_START_DATE").innerHTML = obj.livStartDate;
	        document.getElementById("detailLIV_START_DATE").innerHTML = obj.livStartDate;
	        document.forms[3].<%= EmsDB.EM_LIV_RECORD[5][0] %>.value = obj.livStartDate;
			
	        document.getElementById("detailLIV_LIVING_FEE").innerHTML = obj.livLivingFee+"(港幣)";
	        document.forms[3].<%= EmsDB.EM_LIV_RECORD[7][0] %>.value = obj.livLivingFee;

	        document.getElementById("detailLIV_NURSING_FEE").innerHTML = obj.livNursingFee+"(港幣)";
	        document.forms[3].<%= EmsDB.EM_LIV_RECORD[8][0] %>.value = obj.livNursingFee;
	        
	        document.getElementById("detailPER_TEL").innerHTML = obj.perTel;
	        document.forms[3].<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[8][0] %>.value = obj.perTel;
	        document.getElementById("detailPER_EMAIL").innerHTML = obj.perEmail;
	        document.forms[3].<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[9][0] %>.value = obj.perEmail;
	        document.getElementById("detailPER_DESC").innerHTML = obj.perDesc;
	        document.forms[3].<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[10][0] %>.value = obj.perDesc;
	        document.getElementById("briefPCO_CHI_NAME").innerHTML = obj.pcoChiName[0];
        	document.getElementById("briefPCO_RELATION").innerHTML = obj.pcoRel[0];
        	document.getElementById("briefPCO_TEL").innerHTML = obj.pcoTel[0];

        	document.getElementById("detailPER_LBIRTH").innerHTML = obj.perLBirth;
        	document.forms[3].<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[5][0] %>.value = obj.perLBirth;
	        
			if(obj.livType == "A")
        		document.getElementById("detailLIV_TYPE").innerHTML = "院舍卷";
			else if(obj.livType == "B")
        		document.getElementById("detailLIV_TYPE").innerHTML = "資助住宿暫托照顧服務";
			else if(obj.livType == "C")
        		document.getElementById("detailLIV_TYPE").innerHTML = "非資助住宿暫托照顧服務";
			else if(obj.livType == "D")
        		document.getElementById("detailLIV_TYPE").innerHTML = "資助安老宿位";
			else if(obj.livType == "E")
        		document.getElementById("detailLIV_TYPE").innerHTML = "非資助安老宿位";
			else if(obj.livType == "F")
        		document.getElementById("detailLIV_TYPE").innerHTML = "私位";
			else if(obj.livType == "G")
        		document.getElementById("detailLIV_TYPE").innerHTML = "買位";
			else if(obj.livType == "H")
        		document.getElementById("detailLIV_TYPE").innerHTML = "長老院舍住宿照顧服務卷";
			else if(obj.livType == "I")
        		document.getElementById("detailLIV_TYPE").innerHTML = "離院照顧(醫社合作)";
			else
				document.getElementById("detailLIV_TYPE").innerHTML = "";
			document.forms[3].<%= EmsDB.EM_LIV_RECORD[9][0] %>.value = obj.livType;
			
        	document.getElementById("detailPER_LDS_REF").innerHTML = obj.perLDSRef;
        	document.forms[3].<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[13][0] %>.value = obj.perLDSRef;
	        document.getElementById("detailPER_LDS_RESULT").innerHTML = obj.perLDSResult;
	        document.forms[3].<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[14][0] %>.value = obj.perLDSResult;
	        document.getElementById("detailPER_LDS_DATE").innerHTML = obj.perLDSDate;
	        document.forms[3].<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[15][0] %>.value = obj.perLDSDate;
	        
	        if(obj.perAss1 == ""){
	        	document.getElementById("detailPER_ASS1").innerHTML = "";
	        }else if(obj.perAss1 == "1"){
	        	document.getElementById("detailPER_ASS1").innerHTML = "1. 行動自如";
	        }else if(obj.perAss1 == "2"){
	        	document.getElementById("detailPER_ASS1").innerHTML = "2. 需要幫助";
	        }else if(obj.perAss1 == "3"){
	        	document.getElementById("detailPER_ASS1").innerHTML = "3. 需要助行器";
	        }else if(obj.perAss1 == "4"){
	        	document.getElementById("detailPER_ASS1").innerHTML = "4. 輪椅代步";
	        }else if(obj.perAss1 == "5"){
	        	document.getElementById("detailPER_ASS1").innerHTML = "5. 長期坐椅";
	        }else if(obj.perAss1 == "6"){
	        	document.getElementById("detailPER_ASS1").innerHTML = "6. 長期卧床";
	        }
	        document.forms[3].<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[16][0] %>.value = obj.perAss1;
	        

	        if(obj.perAss2 == ""){
	        	document.getElementById("detailPER_ASS2").innerHTML = "";
	        }else if(obj.perAss2 == "1"){
	        	document.getElementById("detailPER_ASS2").innerHTML = "1. 正餐";
	        }else if(obj.perAss2 == "2"){
	        	document.getElementById("detailPER_ASS2").innerHTML = "2. 碎餐";
	        }else if(obj.perAss2 == "3"){
	        	document.getElementById("detailPER_ASS2").innerHTML = "3. 餬餐";
	        }else if(obj.perAss2 == "4"){
	        	document.getElementById("detailPER_ASS2").innerHTML = "4. 管飼";
	        }else if(obj.perAss2 == "5"){
	        	document.getElementById("detailPER_ASS2").innerHTML = "5. 特別餐";
	        }
	        document.forms[3].<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[17][0] %>.value = obj.perAss2;

	        document.getElementById("detailPER_ASS2_OTH").innerHTML = obj.perAss2Oth;
	        document.forms[3].<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[18][0] %>.value = obj.perAss2Oth;


	        if(obj.perAss3 == ""){
	        	document.getElementById("detailPER_ASS3").innerHTML = "";
	        }else if(obj.perAss3 == "1"){
	        	document.getElementById("detailPER_ASS3").innerHTML = "1. 需要用尿片";
	        }else if(obj.perAss3 == "2"){
	        	document.getElementById("detailPER_ASS3").innerHTML = "2. 尿喉護理";
	        }else if(obj.perAss3 == "3"){
	        	document.getElementById("detailPER_ASS3").innerHTML = "3. 其他造口護理";
	        }else if(obj.perAss3 == "4"){
	        	document.getElementById("detailPER_ASS3").innerHTML = "4. 其他";
	        }
	        document.forms[3].<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[19][0] %>.value = obj.perAss3;

	        document.getElementById("detailPER_ASS3_OTH").innerHTML = obj.perAss3Oth;
	        document.forms[3].<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[20][0] %>.value = obj.perAss3Oth;


	        if(obj.perAss4 == ""){
	        	document.getElementById("detailPER_ASS4").innerHTML = "";
	        }else if(obj.perAss4 == "1"){
	        	document.getElementById("detailPER_ASS4").innerHTML = "1. 自理";
	        }else if(obj.perAss4 == "2"){
	        	document.getElementById("detailPER_ASS4").innerHTML = "2. 半護理";
	        }else if(obj.perAss4 == "3"){
	        	document.getElementById("detailPER_ASS4").innerHTML = "3. 全護理";
	        }else if(obj.perAss4 == "4"){
	        	document.getElementById("detailPER_ASS4").innerHTML = "4. 特別護理";
	        }
	        document.forms[3].<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[21][0] %>.value = obj.perAss4;

	        
	        if(obj.perReferal == ""){
	        	document.getElementById("detailPER_REFERAL").innerHTML = "";
	        }else if(obj.perReferal == "1"){
	        	document.getElementById("detailPER_REFERAL").innerHTML = "1. 朋友";
	        }else if(obj.perReferal == "2"){
	        	document.getElementById("detailPER_REFERAL").innerHTML = "2. 網頁";
	        }else if(obj.perReferal == "3"){
	        	document.getElementById("detailPER_REFERAL").innerHTML = "3. 廣告";
	        }else if(obj.perReferal == "4"){
	        	document.getElementById("detailPER_REFERAL").innerHTML = "4. 社工";
	        }else if(obj.perReferal == "5"){
	        	document.getElementById("detailPER_REFERAL").innerHTML = "5. 其他";
	        }
	        document.forms[3].<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[22][0] %>.value = obj.perReferal;

	        document.getElementById("detailPER_REFERAL_OTH").innerHTML = obj.perReferalOth;
	        document.forms[3].<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[23][0] %>.value = obj.perReferalOth;

	        
	        
        	for(i=0;i<5;i++){
       			document.getElementById("detailPCO"+(i+1)).innerHTML = "<td></td><td></td><td></td><td></td><td></td>";
        	}
        	
        	for(i=0;i<obj.pcoChiName.length;i++){
       			document.getElementById("detailPCO"+(i+1)).innerHTML = "<td>"+obj.pcoSeq[i]+"</td><td>"+obj.pcoChiName[i]+"</td><td>"+obj.pcoRel[i]+"</td><td>"+obj.pcoTel[i]+"</td><td>"+obj.pcoEmail[i]+"</td>";
       			document.getElementById("modPCO_CHI_NAME"+(i+1)).value = obj.pcoChiName[i];
       			document.getElementById("modPCO_REL"+(i+1)).value = obj.pcoRel[i];
       			document.getElementById("modPCO_TEL"+(i+1)).value = obj.pcoTel[i];
       			document.getElementById("modPCO_EMAIL"+(i+1)).value = obj.pcoEmail[i];
        	}
        	
        	document.forms[3].<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[0][0] %>.value = obj.perId;
        	
        	document.getElementById("transListTable").innerHTML = "<tr><td>入賬日期</td><td>項目</td><td>繳費方法</td><td>交易編號</td><td>金額 (港幣)</td><td>戶口結餘 (港幣)</td><td>備註</td></tr>";
        	
        	for(i=0;i<obj.traId.length;i++){
        		document.getElementById("transListTable").innerHTML = document.getElementById("transListTable").innerHTML + "<tr><td>"+obj.traDate[i]+"</td><td>"+obj.traName[i]+"</td><td>"+obj.traMethod[i]+"</td><td>"+obj.traId[i]+"</td><td>"+obj.traAmount[i]+"</td><td>"+obj.accBal+"</td><td>"+obj.traNote[i]+"</td></tr>";
        	}
    		document.getElementById("detailLIV_BALANCE").innerHTML = obj.accBal;

        	
	        document.getElementById("patientContainerLoading").style.display = "none";
	        document.getElementById("patientContainerContent").style.display = "block";
	    }
	    else {
	    	document.getElementById("patientContainerMsg").innerHTML = "載入失敗";
	    }
	};
	xhr.send();
}

function getAge(dob){
	
	var age = "";
	if(dob.length == 10){
		var year = Number(dob.substr(0, 4));
		var month = Number(dob.substr(5, 2)) - 1;
		var day = Number(dob.substr(8, 2));
		var today = new Date();
		age = today.getFullYear() - year;
		if (today.getMonth() < month || (today.getMonth() == month && today.getDate() < day)) {
		  age--;
		}
	}
	
	return age;
	
}

function setSlipFrame(){
	var iframe = document.frames ? document.frames["slipFrame"] : document.getElementById("slipFrame");
	var ifWin = iframe.contentWindow || iframe;
	var slipContent = ifWin.document.getElementById('slipContent');
	if (slipContent == null) {
		setTimeout(setSlipFrame, 1000);
		return false;
	}
	slipContent.innerHTML="\
	<table style='border:1px solid black; width:100%' id='slipTable'>\
		<tr>\
			<td style='text-align:center; font-size:24px'>訂位確認書</td>\
		</tr>\
		<tr>\
			<td style='text-align:center;'>姓名:　陳大文</td>\
		</tr>\
	</table>\
	<footer></footer>\
	";
}
setTimeout(setSlipFrame, 1000);

function printSlip()
    {
        var iframe = document.frames ? document.frames['slipFrame'] : document.getElementById('slipFrame');
        var ifWin = iframe.contentWindow || iframe;
        iframe.focus();
        ifWin.printPage();
    }

</script>

</html>
