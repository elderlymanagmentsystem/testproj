<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="ems.bean.PatBean,ems.bean.BedBean,ems.bean.CitemBean,ems.bean.CperBean,ems.bean.PatGrpBean,ems.bean.AccGrpBean,ems.bean.PerBean,ems.bean.UserBean,ems.bean.FuncBean,ems.db.EmsDB,ems.util.EmsCommonUtil" import="java.util.ArrayList"%>
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

@media only screen and (max-width: 600px) {
    table[id$='ScreenTable'] td {display: table-row;}
    table[id$='ScreenTable'] td:nth-child(even) {font-size:80%; color:blue; font-weight: bold;}
    table[id$='ScreenTable'] {border-collapse: separate; border:1px solid transparent;}
    input[type=text]:not(.search),input[type=password],textarea {min-width:280px}
}

table[id$='ScreenTable'] td:nth-child(odd) {white-space: nowrap}

</style>

<%

PatGrpBean patGrpBean = new PatGrpBean();
if (request.getAttribute("patGrpBean") !=null) 
	patGrpBean = (PatGrpBean) request.getAttribute("patGrpBean"); 

UserBean userBean = (UserBean) session.getAttribute("userBean");
ArrayList<OrgBean> accOrgBeanList = userBean.getAccOrgBeanList();
ArrayList<PatBean> patBeanList = patGrpBean.getPatBeanList();

AccGrpBean accGrpBean = patGrpBean.getAccGrpBean();
if(accGrpBean == null)
	accGrpBean = new AccGrpBean();
ArrayList<CitemBean> citemBeanList = new ArrayList<CitemBean>();
if(accGrpBean.getCitemBeanList() !=null)
	citemBeanList = accGrpBean.getCitemBeanList();
ArrayList<CitemBean> citemCatBeanList = new ArrayList<CitemBean>();
if(accGrpBean.getCitemCatBeanList() !=null)
	citemCatBeanList = accGrpBean.getCitemCatBeanList();


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
<div class="w3-main" style="margin-left:200px;">
<form name="mntPatAcc" action="mntPatAcc" method="post">
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
			<form name="mntPatAcc" action="mntPatAcc" method="post">
				<span class="input-container">
			   		<a class="icon"><i class="fas fa-user-tag"></i></a>
			   		<select name="patGrpBean.enqLivStatus" style="width:150px;">
						<% if(patGrpBean.getEnqLivStatus().equals("N")){ %>
							<option value="Y">入住中</option>
							<option value="N" selected>已退院</option>
						<% }else{ %>
							<option value="Y" selected>入住中</option>
							<option value="N">已退院</option>
						<% } %>
					</select>
				</span>
				<span class="input-container">
			   		<a class="icon"><i class="fas fa-filter fa-fw"></i></a>
			   		<select name="patGrpBean.enqPatType" style="width:150px;">
						<% if(patGrpBean.getEnqPatType().equals("N")){ %>
							<option value="N" selected>姓名</option>
						<% }else{ %>
							<option value="N">姓名</option>
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
			
			<div style="overflow-x:auto;">
				<table id="userListTable">
					<tr>
						<td>姓名</td>
						<td>身份證號碼</td>
						<td>性別</td>
						<td>床位</td>
						<td>狀態</td>
						<td>院友編號</td>
					</tr>
					
			<%  if(patBeanList.size()>0){
					for(int i=0;i<patBeanList.size();i++){ 
						PatBean patBean = patBeanList.get(i);
						BedBean bedBean = new BedBean();
						if(patBean.getLivBeanList().size()>0){
							bedBean = patBean.getLivBeanList().get(0).getBedBean();
						}
			%>
					<tr onclick="showScreen('enqDetailScreen');setActiveRecord(<%=i%>);getAjaxData(<%=patBean.getPatId()%>);">
						<td><%=patBean.getField("PER_CHI_NAME").getFormValue() %></td>
						<td><%=patBean.getField("PER_HKID").getFormValue() %></td>
						<td><% if(patBean.getField("PER_GENDER").getFormValue().equals("M")){ %><i class="fas fa-male w3-text-light-blue fa-fw"></i><% } %><% if(patBean.getField("PER_GENDER").getFormValue().equals("F")){ %><i class="fas fa-female w3-text-red fa-fw"></i><% } %></td>
						<td><%= bedBean.getBedName() %></td>
						<td><% if(patBean.getLivBeanList().get(0).getField("LIV_STATUS").getFormValue().equals("Y")){ %>入住中<% }else{ %>已退院<% } %></td>						
						<td><%=patBean.getPatId() %></td>
					</tr>
			<%      } 
			 	} 
			 %>					
				</table>
			</div>
		</div>

		<form name="mntPatAcc" action="mntPatAcc" method="post">
		<div style="display:none" id="addDetailScreen">
			<table class="w3-table">
				<tr>
					<th class="color1 w3-xlarge">院友會計 - 新增帳項<span class="w3-text-red mc-italic"><%=patGrpBean.getMsg() %></span></th>
				</tr>
			</table>
			<table class="w3-table-all" id="addDetailTabPage1ScreenTable">
				<col width="10%">
				<col width="40%">
				<col width="10%">
				<col width="40%">
				<tr><td colspan="4" class="w3-xlarge mc-bold mc-underline">個人資料</td></tr>
			  	<tr>
			  		<td>狀態</td>
			  		<td><span id="addLIV_STATUS">-</span></td> 
			  		<td>入住編號</td>
			  		<td><span id="addPAT_ID">-</span></td> 
			  	</tr>
			  	<tr>
			  		<td>中文姓名</td>
			  		<td><span id="addPER_CHI_NAME">-</span></td>
			  		<td>身份證號碼</td>
			  		<td><span id="addPER_HKID">-</span></td>  
			  	</tr>
			  	<tr><td colspan="4" class="w3-xlarge mc-bold mc-underline">帳項資料</td></tr>
			  	<tr>
			  		<td>分類 <span class="w3-text-red mc-italic"><%=patGrpBean.getCperBean().getField(EmsDB.EM_CHC_CHARGE_CAT[0][0]).getMsg() %></span></td>
			  		<td colspan="3">
			  			<select name="<%= EmsDB.EM_CHC_CHARGE_CAT[0][0] %>" id="add<%= EmsDB.EM_CHC_CHARGE_CAT[0][0] %>" onchange="setAddSubType('add<%= EmsDB.EM_CHC_CHARGE_CAT[0][0] %>','add<%= EmsDB.EM_CHP_CHARGE_PERSON[3][0] %>',this.selectedIndex)">		   		
						</select>
					</td>
			  	</tr>
			  	<tr>
			  		<td>項目 <span class="w3-text-red mc-italic"><%=patGrpBean.getCperBean().getField(EmsDB.EM_CHP_CHARGE_PERSON[3][0]).getMsg() %></span></td>
			  		<td colspan="3">
			  			<select name="<%= EmsDB.EM_CHP_CHARGE_PERSON[3][0] %>" id="add<%= EmsDB.EM_CHP_CHARGE_PERSON[3][0] %>" onchange="setAddPrice('add<%= EmsDB.EM_CHC_CHARGE_CAT[0][0] %>','add<%= EmsDB.EM_CHP_CHARGE_PERSON[3][0] %>');">
						</select>
					</td>
			  	</tr>
			  	<tr>
			  		<td>帳項性質 <span class="w3-text-red mc-italic"><%=patGrpBean.getCperBean().getField(EmsDB.EM_CHP_CHARGE_PERSON[4][0]).getMsg() %></span></td>
			  		<td colspan="3">
			  			<select name="<%= EmsDB.EM_CHP_CHARGE_PERSON[4][0] %>" id="add<%= EmsDB.EM_CHP_CHARGE_PERSON[4][0] %>">
			  			<% if(patGrpBean.getCperBean().getField(EmsDB.EM_CHP_CHARGE_PERSON[4][0]).getFormValue().equals("O")){ %>
			  				<option value="O" selected>一次性</option>
			  				<option value="M">每月</option>
			  			<% }else if(patGrpBean.getCperBean().getField(EmsDB.EM_CHP_CHARGE_PERSON[4][0]).getFormValue().equals("M")){ %>
			  				<option value="O">一次性</option>
			  				<option value="M" selected>每月</option>
			  			<% }else{ %>
			  				<option value="O">一次性</option>
			  				<option value="M">每月</option>
			  			<% } %>
			  			</select>
			  		</td>
			  	</tr>
			  	<tr>
			  		<td>開始/入賬日期 <span class="w3-text-red mc-italic"><%=patGrpBean.getCperBean().getField(EmsDB.EM_CHP_CHARGE_PERSON[8][0]).getMsg() %></span></td>
			  		<td><div class="flatpickr date-container"><input type="text" name="<%= EmsDB.EM_CHP_CHARGE_PERSON[8][0] %>" id="add<%= EmsDB.EM_CHP_CHARGE_PERSON[8][0] %>" value="<%=patGrpBean.getCperBean().getField(EmsDB.EM_CHP_CHARGE_PERSON[8][0]).getFormValue() %>" maxlength="<%= EmsDB.EM_CHP_CHARGE_PERSON[8][3] %>" size="12" data-input><a class="mc-button-2 icon" data-clear>&times;</a></div></td>
			  		<td>結束日期 <span class="w3-text-red mc-italic"><%=patGrpBean.getCperBean().getField(EmsDB.EM_CHP_CHARGE_PERSON[9][0]).getMsg() %></span></td>
			  		<td><div class="flatpickr date-container"><input type="text" name="<%= EmsDB.EM_CHP_CHARGE_PERSON[9][0] %>" id="add<%= EmsDB.EM_CHP_CHARGE_PERSON[9][0] %>" value="<%=patGrpBean.getCperBean().getField(EmsDB.EM_CHP_CHARGE_PERSON[9][0]).getFormValue() %>" maxlength="<%= EmsDB.EM_CHP_CHARGE_PERSON[9][3] %>" size="12" data-input><a class="mc-button-2 icon" data-clear>&times;</a></div></td>
			  	</tr>
			  	<tr>
			  		<td>繳款至 <span class="w3-text-red mc-italic"><%=patGrpBean.getCperBean().getField(EmsDB.EM_CHP_CHARGE_PERSON[10][0]).getMsg() %></span></td>
			  		<td colspan="3"><input type="text" name="<%= EmsDB.EM_CHP_CHARGE_PERSON[10][0] %>" id="add<%= EmsDB.EM_CHP_CHARGE_PERSON[10][0] %>" value="<%=patGrpBean.getCperBean().getField(EmsDB.EM_CHP_CHARGE_PERSON[10][0]).getFormValue() %>" maxlength="<%= EmsDB.EM_CHP_CHARGE_PERSON[10][3] %>" size="12" readOnly style="background-color:silver"></td>
			  	</tr>
			  	<tr>
			  		<td>單價(港幣) <span class="w3-text-red mc-italic"><%=patGrpBean.getCperBean().getField(EmsDB.EM_CHP_CHARGE_PERSON[6][0]).getMsg() %></span></td>
			  		<td><input name="<%= EmsDB.EM_CHP_CHARGE_PERSON[6][0] %>" id="add<%= EmsDB.EM_CHP_CHARGE_PERSON[6][0] %>" type="tel" pattern="[0-9]*"  maxlength="10" size="10" value="<%= patGrpBean.getCperBean().getField(EmsDB.EM_CHP_CHARGE_PERSON[6][0]).getFormValue() %>" onchange="setAddPrice('add<%= EmsDB.EM_CHC_CHARGE_CAT[0][0] %>','add<%= EmsDB.EM_CHP_CHARGE_PERSON[3][0] %>');"/></td>
			  		<td>數量 <span class="w3-text-red mc-italic"><%=patGrpBean.getCperBean().getField(EmsDB.EM_CHP_CHARGE_PERSON[5][0]).getMsg() %></span></td>
			  		<td><input name="<%= EmsDB.EM_CHP_CHARGE_PERSON[5][0] %>" id="add<%= EmsDB.EM_CHP_CHARGE_PERSON[5][0] %>" type="tel" pattern="[0-9]*"  maxlength="5" size="3" value="<%= patGrpBean.getCperBean().getField(EmsDB.EM_CHP_CHARGE_PERSON[5][0]).getFormValue() %>" onchange="setAddPrice('add<%= EmsDB.EM_CHC_CHARGE_CAT[0][0] %>','add<%= EmsDB.EM_CHP_CHARGE_PERSON[3][0] %>');"/></td>
			  	</tr>
			  	<tr>
			  		<td>金額(港幣) <span class="w3-text-red mc-italic"><%=patGrpBean.getCperBean().getField(EmsDB.EM_CHP_CHARGE_PERSON[7][0]).getMsg() %></span></td>
			  		<td><input name="<%= EmsDB.EM_CHP_CHARGE_PERSON[7][0] %>" id="add<%= EmsDB.EM_CHP_CHARGE_PERSON[7][0] %>" type="tel" pattern="[0-9]*"  maxlength="10" size="10" value="<%= patGrpBean.getCperBean().getField(EmsDB.EM_CHP_CHARGE_PERSON[7][0]).getFormValue() %>"/></td>
			  		<td>備註 <span class="w3-text-red mc-italic"><%=patGrpBean.getCperBean().getField(EmsDB.EM_CHP_CHARGE_PERSON[11][0]).getMsg() %></span></td>
			  		<td><input type="text" name="<%= EmsDB.EM_CHP_CHARGE_PERSON[11][0] %>"  value="<%= patGrpBean.getCperBean().getField(EmsDB.EM_CHP_CHARGE_PERSON[11][0]).getFormValue() %>" maxlength="<%= EmsDB.EM_CHP_CHARGE_PERSON[11][3] %>" class="mc-fw" style="max-width:20em"></td>
			  	</tr>
			</table>
			<input type="hidden" name="funcId" value="<%=addFuncId %>">
			<input type="hidden" name="<%= EmsDB.EM_CHP_CHARGE_PERSON[2][0] %>" value="<%=patGrpBean.getCperBean().getPerId() %>">
			<a class="mc-button color4 w3-large" onclick="showConfirmMessage();"><i class="fas fa-check"></i>確定</a>
			<a class="mc-button color4 w3-large" onclick="showScreen('enqScreen');"><i class="fas fa-times"></i>返回</a>
		</div>
		</form>

		<form name="mntPatAcc" action="mntPatAcc" method="post">
		<div style="display:none" id="modDetailScreen">
			<table class="w3-table">
				<tr>
					<th class="color1 w3-xlarge">院友會計 - 編輯帳項<span class="w3-text-red mc-italic"><%=patGrpBean.getMsg() %></span></th>
				</tr>
			</table>
			<table class="w3-table-all" id="modDetailTabPage1ScreenTable">
				<col width="10%">
				<col width="40%">
				<col width="10%">
				<col width="40%">
				<tr><td colspan="4" class="w3-xlarge mc-bold mc-underline">個人資料</td></tr>
			  	<tr>
			  		<td>狀態</td>
			  		<td><span id="modLIV_STATUS">-</span></td> 
			  		<td>入住編號</td>
			  		<td><span id="modPAT_ID">-</span></td> 
			  	</tr>
			  	<tr>
			  		<td>中文姓名</td>
			  		<td><span id="modPER_CHI_NAME">-</span></td>
			  		<td>身份證號碼</td>
			  		<td><span id="modPER_HKID">-</span></td>  
			  	</tr>
			  	<tr><td colspan="4" class="w3-xlarge mc-bold mc-underline">帳項資料</td></tr>
			  	<tr>
			  		<td>分類 <span class="w3-text-red mc-italic"><%=patGrpBean.getCperBean().getField(EmsDB.EM_CHC_CHARGE_CAT[0][0]).getMsg() %></span></td>
			  		<td colspan="3">
			  			<select name="<%= EmsDB.EM_CHC_CHARGE_CAT[0][0] %>" id="mod<%= EmsDB.EM_CHC_CHARGE_CAT[0][0] %>" onchange="setModSubType('mod<%= EmsDB.EM_CHC_CHARGE_CAT[0][0] %>','mod<%= EmsDB.EM_CHP_CHARGE_PERSON[3][0] %>',this.selectedIndex)">		   		
						</select>
					</td>
			  	</tr>
			  	<tr>
			  		<td>項目 <span class="w3-text-red mc-italic"><%=patGrpBean.getCperBean().getField(EmsDB.EM_CHP_CHARGE_PERSON[3][0]).getMsg() %></span></td>
			  		<td colspan="3">
			  			<select name="<%= EmsDB.EM_CHP_CHARGE_PERSON[3][0] %>" id="mod<%= EmsDB.EM_CHP_CHARGE_PERSON[3][0] %>" onchange="setModPrice('mod<%= EmsDB.EM_CHC_CHARGE_CAT[0][0] %>','mod<%= EmsDB.EM_CHP_CHARGE_PERSON[3][0] %>');">
						</select>
					</td>
			  	</tr>
			  	<tr>
			  		<td>帳項性質 <span class="w3-text-red mc-italic"><%=patGrpBean.getCperBean().getField(EmsDB.EM_CHP_CHARGE_PERSON[4][0]).getMsg() %></span></td>
			  		<td colspan="3">
			  			<select name="<%= EmsDB.EM_CHP_CHARGE_PERSON[4][0] %>" id="mod<%= EmsDB.EM_CHP_CHARGE_PERSON[4][0] %>">
			  			<% if(patGrpBean.getCperBean().getField(EmsDB.EM_CHP_CHARGE_PERSON[4][0]).getFormValue().equals("O")){ %>
			  				<option value="O" selected>一次性</option>
			  				<option value="M">每月</option>
			  			<% }else if(patGrpBean.getCperBean().getField(EmsDB.EM_CHP_CHARGE_PERSON[4][0]).getFormValue().equals("M")){ %>
			  				<option value="O">一次性</option>
			  				<option value="M" selected>每月</option>
			  			<% }else{ %>
			  				<option value="O">一次性</option>
			  				<option value="M">每月</option>
			  			<% } %>
			  			</select>
			  		</td>
			  	</tr>
			  	<tr>
			  		<td>開始/入賬日期 <span class="w3-text-red mc-italic"><%=patGrpBean.getCperBean().getField(EmsDB.EM_CHP_CHARGE_PERSON[8][0]).getMsg() %></span></td>
			  		<td><div class="flatpickr date-container"><input type="text" name="<%= EmsDB.EM_CHP_CHARGE_PERSON[8][0] %>" id="mod<%= EmsDB.EM_CHP_CHARGE_PERSON[8][0] %>" value="<%=patGrpBean.getCperBean().getField(EmsDB.EM_CHP_CHARGE_PERSON[8][0]).getFormValue() %>" maxlength="<%= EmsDB.EM_CHP_CHARGE_PERSON[8][3] %>" size="12" data-input><a class="mc-button-2 icon" data-clear>&times;</a></div></td>
			  		<td>結束日期 <span class="w3-text-red mc-italic"><%=patGrpBean.getCperBean().getField(EmsDB.EM_CHP_CHARGE_PERSON[9][0]).getMsg() %></span></td>
			  		<td><div class="flatpickr date-container"><input type="text" name="<%= EmsDB.EM_CHP_CHARGE_PERSON[9][0] %>" id="mod<%= EmsDB.EM_CHP_CHARGE_PERSON[9][0] %>" value="<%=patGrpBean.getCperBean().getField(EmsDB.EM_CHP_CHARGE_PERSON[9][0]).getFormValue() %>" maxlength="<%= EmsDB.EM_CHP_CHARGE_PERSON[9][3] %>" size="12" data-input><a class="mc-button-2 icon" data-clear>&times;</a></div></td>
			  	</tr>
			  	<tr>
			  		<td>繳款至 <span class="w3-text-red mc-italic"><%=patGrpBean.getCperBean().getField(EmsDB.EM_CHP_CHARGE_PERSON[10][0]).getMsg() %></span></td>
			  		<td colspan="3"><input type="text" name="<%= EmsDB.EM_CHP_CHARGE_PERSON[10][0] %>" id="mod<%= EmsDB.EM_CHP_CHARGE_PERSON[10][0] %>" value="<%=patGrpBean.getCperBean().getField(EmsDB.EM_CHP_CHARGE_PERSON[10][0]).getFormValue() %>" maxlength="<%= EmsDB.EM_CHP_CHARGE_PERSON[10][3] %>" size="12" readOnly style="background-color:silver"></td>
			  	</tr>
			  	<tr>
			  		<td>單價(港幣) <span class="w3-text-red mc-italic"><%=patGrpBean.getCperBean().getField(EmsDB.EM_CHP_CHARGE_PERSON[6][0]).getMsg() %></span></td>
			  		<td><input name="<%= EmsDB.EM_CHP_CHARGE_PERSON[6][0] %>" id="mod<%= EmsDB.EM_CHP_CHARGE_PERSON[6][0] %>" type="tel" pattern="[0-9]*"  maxlength="10" size="10" value="<%= patGrpBean.getCperBean().getField(EmsDB.EM_CHP_CHARGE_PERSON[6][0]).getFormValue() %>" onchange="setModPrice('mod<%= EmsDB.EM_CHC_CHARGE_CAT[0][0] %>','mod<%= EmsDB.EM_CHP_CHARGE_PERSON[3][0] %>');"/></td>
			  		<td>數量 <span class="w3-text-red mc-italic"><%=patGrpBean.getCperBean().getField(EmsDB.EM_CHP_CHARGE_PERSON[5][0]).getMsg() %></span></td>
			  		<td><input name="<%= EmsDB.EM_CHP_CHARGE_PERSON[5][0] %>" id="mod<%= EmsDB.EM_CHP_CHARGE_PERSON[5][0] %>" type="tel" pattern="[0-9]*"  maxlength="5" size="3" value="<%= patGrpBean.getCperBean().getField(EmsDB.EM_CHP_CHARGE_PERSON[5][0]).getFormValue() %>" onchange="setModPrice('mod<%= EmsDB.EM_CHC_CHARGE_CAT[0][0] %>','mod<%= EmsDB.EM_CHP_CHARGE_PERSON[3][0] %>');"/></td>
			  	</tr>
			  	<tr>
			  		<td>金額(港幣) <span class="w3-text-red mc-italic"><%=patGrpBean.getCperBean().getField(EmsDB.EM_CHP_CHARGE_PERSON[7][0]).getMsg() %></span></td>
			  		<td><input name="<%= EmsDB.EM_CHP_CHARGE_PERSON[7][0] %>" id="mod<%= EmsDB.EM_CHP_CHARGE_PERSON[7][0] %>" type="tel" pattern="[0-9]*"  maxlength="10" size="10" value="<%= patGrpBean.getCperBean().getField(EmsDB.EM_CHP_CHARGE_PERSON[7][0]).getFormValue() %>"/></td>
			  		<td>備註 <span class="w3-text-red mc-italic"><%=patGrpBean.getCperBean().getField(EmsDB.EM_CHP_CHARGE_PERSON[11][0]).getMsg() %></span></td>
			  		<td><input type="text" name="<%= EmsDB.EM_CHP_CHARGE_PERSON[11][0] %>"  value="<%= patGrpBean.getCperBean().getField(EmsDB.EM_CHP_CHARGE_PERSON[11][0]).getFormValue() %>" maxlength="<%= EmsDB.EM_CHP_CHARGE_PERSON[11][3] %>" class="mc-fw" style="max-width:20em"></td>
			  	</tr>
			</table>
			<input type="hidden" name="funcId" value="<%=modFuncId %>">
			<input type="hidden" name="<%= EmsDB.EM_CHP_CHARGE_PERSON[0][0] %>" value="<%=patGrpBean.getCperBean().getCperId() %>">
			<input type="hidden" name="<%= EmsDB.EM_CHP_CHARGE_PERSON[2][0] %>" value="<%=patGrpBean.getCperBean().getPerId() %>">
			<a class="mc-button color4 w3-large" onclick="showConfirmMessage();"><i class="fas fa-check"></i>確定</a>
			<a class="mc-button color4 w3-large" onclick="showScreen('enqDetailScreen');"><i class="fas fa-times"></i>返回</a>
		</div>
		</form>

		<form name="mntPatAcc" action="mntPatAcc" method="post">
		<div style="display:none" id="delDetailScreen">
			<table class="w3-table">
				<tr>
					<th class="color1 w3-xlarge">院友會計 - 帳項<span class="w3-text-red mc-italic"><%=patGrpBean.getMsg() %></span>
						<span id="delButton"><a class="mc-button w3-red w3-xlarge w3-right" onclick="showConfirmMessage('是否取消該項目?','w');"><i class="fas fa-trash-alt fa-fw"></i>刪除</a></span>
						<i class="w3-right">&nbsp;</i>
						<a class="mc-button color4 w3-xlarge w3-right" onclick="showScreen('modDetailScreen');"><i class="fas fa-edit"></i>編輯</a>
					</th>
				</tr>
			</table>
			<table class="w3-table-all" id="delDetailTabPage1ScreenTable">
				<col width="10%">
				<col width="40%">
				<col width="10%">
				<col width="40%">
				<tr><td colspan="4" class="w3-xlarge mc-bold mc-underline">個人資料</td></tr>
			  	<tr>
			  		<td>狀態</td>
			  		<td><span id="delLIV_STATUS">-</span></td> 
			  		<td>入住編號</td>
			  		<td><span id="delPAT_ID">-</span></td> 
			  	</tr>
			  	<tr>
			  		<td>中文姓名</td>
			  		<td><span id="delPER_CHI_NAME">-</span></td>
			  		<td>身份證號碼</td>
			  		<td><span id="delPER_HKID">-</span></td>  
			  	</tr>
			  	<tr><td colspan="4" class="w3-xlarge mc-bold mc-underline">帳項資料</td></tr>
			  	<tr>
			  		<td>分類 <span class="w3-text-red mc-italic"><%=patGrpBean.getCperBean().getField(EmsDB.EM_CHC_CHARGE_CAT[0][0]).getMsg() %></span></td>
			  		<td colspan="3"><span id="delCHC_NAME">-</span></td>
			  	</tr>
			  	<tr>
			  		<td>項目 <span class="w3-text-red mc-italic"><%=patGrpBean.getCperBean().getField(EmsDB.EM_CHP_CHARGE_PERSON[3][0]).getMsg() %></span></td>
			  		<td colspan="3"><span id="delCHI_NAME">-</span></td>
			  	</tr>
			  	<tr>
			  		<td>帳項性質 <span class="w3-text-red mc-italic"><%=patGrpBean.getCperBean().getField(EmsDB.EM_CHP_CHARGE_PERSON[4][0]).getMsg() %></span></td>
			  		<td colspan="3"><span id="delCHP_NATURE">-</span></td>
			  	</tr>
			  	<tr>
			  		<td>開始/入賬日期 <span class="w3-text-red mc-italic"><%=patGrpBean.getCperBean().getField(EmsDB.EM_CHP_CHARGE_PERSON[8][0]).getMsg() %></span></td>
			  		<td><span id="delCHP_START_DATE">-</span></td>
			  		<td>結束日期 <span class="w3-text-red mc-italic"><%=patGrpBean.getCperBean().getField(EmsDB.EM_CHP_CHARGE_PERSON[9][0]).getMsg() %></span></td>
			  		<td><span id="delCHP_END_DATE">-</span></td>
			  	</tr>
			  	<tr>
			  		<td>繳款至 <span class="w3-text-red mc-italic"><%=patGrpBean.getCperBean().getField(EmsDB.EM_CHP_CHARGE_PERSON[10][0]).getMsg() %></span></td>
			  		<td colspan="3"><span id="delCHP_CURRENT_PAY_DATE">-</span></td>
			  	</tr>
			  	<tr>
			  		<td>單價(港幣) <span class="w3-text-red mc-italic"><%=patGrpBean.getCperBean().getField(EmsDB.EM_CHP_CHARGE_PERSON[6][0]).getMsg() %></span></td>
			  		<td><span id="delCHP_UNIT_PRICE">-</span></td>
			  		<td>數量 <span class="w3-text-red mc-italic"><%=patGrpBean.getCperBean().getField(EmsDB.EM_CHP_CHARGE_PERSON[5][0]).getMsg() %></span></td>
			  		<td><span id="delCHP_QUANTITY">-</span></td>
			  	</tr>
			  	<tr>
			  		<td>金額(港幣) <span class="w3-text-red mc-italic"><%=patGrpBean.getCperBean().getField(EmsDB.EM_CHP_CHARGE_PERSON[7][0]).getMsg() %></span></td>
			  		<td><span id="delCHP_AMOUNT">-</span></td>
			  		<td>備註 <span class="w3-text-red mc-italic"><%=patGrpBean.getCperBean().getField(EmsDB.EM_CHP_CHARGE_PERSON[11][0]).getMsg() %></span></td>
			  		<td><span id="delCHP_REMARK">-</span></td>
			  	</tr>
			</table>
			<input type="hidden" name="funcId" value="<%=delFuncId %>">
			<input type="hidden" name="<%= EmsDB.EM_CHP_CHARGE_PERSON[0][0] %>" value="<%=patGrpBean.getCperBean().getCperId() %>">
			<input type="hidden" name="<%= EmsDB.EM_CHP_CHARGE_PERSON[2][0] %>" value="<%=patGrpBean.getCperBean().getPerId() %>">
			<a class="mc-button color4 w3-large" onclick="showConfirmMessage();"><i class="fas fa-check"></i>確定</a>
			<a class="mc-button color4 w3-large" onclick="showScreen('enqScreen');"><i class="fas fa-times"></i>返回</a>
		</div>
		</form>

		<form name="mntPatAcc" action="mntPatAcc" method="post">
		<div style="display:none" id="enqDetailScreen">
			<table class="w3-table">
				<tr>
					<th class="color1 w3-xlarge">院友會計 - 帳項
					<a class="mc-button color4 w3-right" onclick="showScreen('addDetailScreen');"><i class="fas fa-comment-dollar"></i>新增帳項</a>
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
		  		<td><span id="detailPAT_ID">-</span></td> 
		  	</tr>
		  	<tr>
		  		<td>中文姓名</td>
		  		<td><span id="detailPER_CHI_NAME">-</span></td>
		  		<td>身份證號碼</td>
		  		<td><span id="detailPER_HKID">-</span></td>  
		  	</tr>
			</table>
			<br>
			<table class="w3-table">
				<tr>
					<th class="color1 w3-large">帳項性質 - 每月</th>
				</tr>
			</table>
			<div style="overflow-x:auto; overflow-y: auto; height:200px">
				<table id="mItemListTable">
					<tr>
				  		<td>項目</td> 
				  		<td>金額(港幣)</td>
				  		<td>開始日期</td>
				  		<td>結束日期</td>
				  		<td>繳款至</td>
				  		<td>備註</td>
					</tr>
				</table>
			</div>
			
			<table class="w3-table">
				<tr>
					<th class="color1 w3-large">帳項性質 - 一次性</th>
				</tr>
			</table>
			<div style="overflow-x:auto; overflow-y: auto; height:200px">
				<table id="oItemListTable">
					<tr>
				  		<td>項目</td> 
				  		<td>數量</td>
				  		<td>單價(港幣)</td>
				  		<td>金額(港幣)</td>
				  		<td>入帳日期</td>
				  		<td>備註</td>
					</tr>
				</table>
			</div>
			<a class="mc-button color4 w3-large" onclick="showScreen('enqScreen');"><i class="fas fa-times"></i>返回</a>
		</div>
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
ddlFunc('ddlMntAcc');
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


var itemList = [
	         {type: "", val: "", subType: [{}]},
<% 
	String catId = "";
	String catName = "";
	String itemId = "";
	String itemName = "";
	String itemPrice = "";
	for(int i=0;i<citemBeanList.size();i++){
		CitemBean citemBean = citemBeanList.get(i);
		if(!citemBean.getCitemCatId().equals(catId) ){
			catId = citemBean.getCitemCatId();
			catName = citemBean.getField("CHC_NAME").getFormValue();
%>			
		{type: "<%= catName %>", val: <%= catId %>, subType: [
<%
		}
			itemId = citemBean.getCitemId();
			itemName = citemBean.getField("CHI_NAME").getFormValue();
			itemPrice = citemBean.getField("CHI_UNIT_PRICE").getFormValue();
%>
				{item: "<%=itemName %>", val: <%=itemId %>, price: "<%=itemPrice %>"}
<%
		if(i+1<citemBeanList.size() && citemBeanList.get(i+1).getCitemCatId().equals(catId)){
%>
				,
<%
		}else{
%>
		]}
<%
			if(i+1<citemBeanList.size()){
%>
,
<%
			}
		}
	}
%>
     ];

var obj;

var patBeanList = [ 
	<% for(int i=0;i<patBeanList.size();i++){ %>
	{
		<% for(int j=0;j<patBeanList.get(i).getFields().size();j++){
			String fieldName = patBeanList.get(i).getFields().get(j).getName();%>
			<%=fieldName%>:"<%=patBeanList.get(i).getFields().get(j).getFormValue()%>",
		<%}%>
		<% for(int j=0;j<patBeanList.get(i).getLivBeanList().get(0).getFields().size();j++){
			String fieldName = patBeanList.get(i).getLivBeanList().get(0).getFields().get(j).getName();%>
			<%=fieldName%>:"<%=patBeanList.get(i).getLivBeanList().get(0).getFields().get(j).getFormValue()%>",
		<%}%>
		
		CHP_ID : [
		<% for(int j=0;j<patBeanList.get(i).getCperBeanList().size();j++){
				String fieldValue = patBeanList.get(i).getCperBeanList().get(j).getField("CHP_ID").getFormValue();
		%>
				"<%= fieldValue %>"
				<% if(j<patBeanList.get(i).getCperBeanList().size()-1){ %>
					,		
				<% } %>
		<%	
		}%>
		]

	}
	<% if(i!=patBeanList.size()-1){ %>,<% } %>
	<% } %>];


function setActiveRecord(recordNum){

	document.getElementById("detailPAT_ID").innerHTML = patBeanList[recordNum].<%= EmsDB.EM_PAT_PATIENT_INFO[0][0] %>;
	document.getElementById("addPAT_ID").innerHTML = patBeanList[recordNum].<%= EmsDB.EM_PAT_PATIENT_INFO[0][0] %>;
	document.getElementById("modPAT_ID").innerHTML = patBeanList[recordNum].<%= EmsDB.EM_PAT_PATIENT_INFO[0][0] %>;
	document.getElementById("delPAT_ID").innerHTML = patBeanList[recordNum].<%= EmsDB.EM_PAT_PATIENT_INFO[0][0] %>;
	
	if(patBeanList[recordNum].<%= EmsDB.EM_LIV_RECORD[12][0] %> == 'Y'){
		document.getElementById("detailLIV_STATUS").className = 'w3-text-green mc-bold';
		document.getElementById("detailLIV_STATUS").innerHTML = "入住中";
		document.getElementById("addLIV_STATUS").className = 'w3-text-green mc-bold';
		document.getElementById("addLIV_STATUS").innerHTML = "入住中";
		document.getElementById("modLIV_STATUS").className = 'w3-text-green mc-bold';
		document.getElementById("modLIV_STATUS").innerHTML = "入住中";
		document.getElementById("delLIV_STATUS").className = 'w3-text-green mc-bold';
		document.getElementById("delLIV_STATUS").innerHTML = "入住中";
	}else{
		document.getElementById("detailLIV_STATUS").className = 'w3-text-red mc-bold';
		document.getElementById("detailLIV_STATUS").innerHTML = "已退院";
		document.getElementById("addLIV_STATUS").className = 'w3-text-red mc-bold';
		document.getElementById("addLIV_STATUS").innerHTML = "已退院";
		document.getElementById("modLIV_STATUS").className = 'w3-text-red mc-bold';
		document.getElementById("modLIV_STATUS").innerHTML = "已退院";
		document.getElementById("delLIV_STATUS").className = 'w3-text-red mc-bold';
		document.getElementById("delLIV_STATUS").innerHTML = "已退院";
	}
	document.getElementById("detailPER_CHI_NAME").innerHTML = patBeanList[recordNum].<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[2][0] %>;
	document.getElementById("addPER_CHI_NAME").innerHTML = patBeanList[recordNum].<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[2][0] %>;
	document.getElementById("modPER_CHI_NAME").innerHTML = patBeanList[recordNum].<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[2][0] %>;
	document.getElementById("delPER_CHI_NAME").innerHTML = patBeanList[recordNum].<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[2][0] %>;
	document.getElementById("detailPER_HKID").innerHTML = patBeanList[recordNum].<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[6][0] %>;
	document.getElementById("addPER_HKID").innerHTML = patBeanList[recordNum].<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[6][0] %>;
	document.getElementById("modPER_HKID").innerHTML = patBeanList[recordNum].<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[6][0] %>;
	document.getElementById("delPER_HKID").innerHTML = patBeanList[recordNum].<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[6][0] %>;

	document.forms[2].<%= EmsDB.EM_CHP_CHARGE_PERSON[2][0] %>.value = patBeanList[recordNum].<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[0][0] %>;
	document.forms[3].<%= EmsDB.EM_CHP_CHARGE_PERSON[2][0] %>.value = patBeanList[recordNum].<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[0][0] %>;
	document.forms[4].<%= EmsDB.EM_CHP_CHARGE_PERSON[2][0] %>.value = patBeanList[recordNum].<%= EmsDB.EM_PER_PERSONAL_PARTICULAR[0][0] %>;
	
}

function setActiveItem(recordNum){
	if(obj.cperCurrPayDate[recordNum] == null || obj.cperCurrPayDate[recordNum].length == 0)
		document.getElementById("delButton").style.display = "block";
	else
		document.getElementById("delButton").style.display = "none";
	
	document.forms[3].<%= EmsDB.EM_CHC_CHARGE_CAT[0][0] %>.value = obj.cperItemCatId[recordNum];
	setModSubType('mod<%= EmsDB.EM_CHC_CHARGE_CAT[0][0] %>','mod<%= EmsDB.EM_CHP_CHARGE_PERSON[3][0] %>',document.getElementById("mod<%=EmsDB.EM_CHC_CHARGE_CAT[0][0]%>").selectedIndex);
	document.forms[3].<%= EmsDB.EM_CHP_CHARGE_PERSON[0][0] %>.value = obj.cperId[recordNum];
	document.forms[3].<%= EmsDB.EM_CHP_CHARGE_PERSON[3][0] %>.value = obj.cperItemId[recordNum];
	document.forms[3].<%= EmsDB.EM_CHP_CHARGE_PERSON[4][0] %>.value = obj.cperNature[recordNum];
	document.forms[3].<%= EmsDB.EM_CHP_CHARGE_PERSON[5][0] %>.value = obj.cperQuantity[recordNum];
	document.forms[3].<%= EmsDB.EM_CHP_CHARGE_PERSON[6][0] %>.value = obj.cperUnitPrice[recordNum];
	document.forms[3].<%= EmsDB.EM_CHP_CHARGE_PERSON[7][0] %>.value = obj.cperAmount[recordNum];
	document.forms[3].<%= EmsDB.EM_CHP_CHARGE_PERSON[8][0] %>.value = obj.cperStartDate[recordNum];
	document.forms[3].<%= EmsDB.EM_CHP_CHARGE_PERSON[9][0] %>.value = obj.cperEndDate[recordNum];
	document.forms[3].<%= EmsDB.EM_CHP_CHARGE_PERSON[10][0] %>.value = obj.cperCurrPayDate[recordNum];
	document.forms[3].<%= EmsDB.EM_CHP_CHARGE_PERSON[11][0] %>.value = obj.cperRemark[recordNum];
	
	document.getElementById("delCHC_NAME").innerHTML = obj.cperItemCatName[recordNum];
	document.forms[4].<%= EmsDB.EM_CHP_CHARGE_PERSON[0][0] %>.value = obj.cperId[recordNum];
	document.getElementById("delCHI_NAME").innerHTML = obj.cperItemName[recordNum];
	document.getElementById("delCHP_NATURE").innerHTML = obj.cperNature[recordNum];
	document.getElementById("delCHP_QUANTITY").innerHTML = obj.cperQuantity[recordNum];
	document.getElementById("delCHP_UNIT_PRICE").innerHTML = obj.cperUnitPrice[recordNum];
	document.getElementById("delCHP_AMOUNT").innerHTML = obj.cperAmount[recordNum];
	document.getElementById("delCHP_START_DATE").innerHTML = obj.cperStartDate[recordNum];
	document.getElementById("delCHP_END_DATE").innerHTML = obj.cperEndDate[recordNum];
	document.getElementById("delCHP_CURRENT_PAY_DATE").innerHTML = obj.cperCurrPayDate[recordNum];
	document.getElementById("delCHP_REMARK").innerHTML = obj.cperRemark[recordNum];
	
	
}

function getAjaxData(enqPatId){
	var xhr = new XMLHttpRequest();
	xhr.open('GET', 'getAjaxPat?patGrpBean.enqPatId='+enqPatId);
	xhr.onload = function() {
	    if (xhr.status === 200) {
	        obj = JSON.parse(xhr.responseText);	 
	        while (document.getElementById("mItemListTable").rows.length > 1){
	    		document.getElementById("mItemListTable").deleteRow(document.getElementById("mItemListTable").rows.length-1);
	    	}
	        while (document.getElementById("oItemListTable").rows.length > 1){
	    		document.getElementById("oItemListTable").deleteRow(document.getElementById("oItemListTable").rows.length-1);
	    	}
        	if(obj.cperId!=null && obj.cperId.length>0){
	        	for(i=0;i<obj.cperId.length;i++){
	        		var a = null;
	        		a = i.toString();
	        		
					if(obj.cperNature[i] == "M"){
	        			var row = document.getElementById("mItemListTable").insertRow(-1);
	        			row.setAttribute("data-myID", i);
	        			row.onclick = function (){ showScreen("modDetailScreen");setActiveItem(this.getAttribute("data-myID")); };
	                	row.innerHTML = "<td>"+obj.cperItemName[i]+"</td><td>"+obj.cperQuantity[i]+"</td><td>"+obj.cperUnitPrice[i]+"</td><td>"+obj.cperAmount[i]+"</td><td>"+obj.cperStartDate[i]+"</td><td>"+obj.cperRemark[i]+"</td>";
					}else{
						var row = document.getElementById("oItemListTable").insertRow(-1);
						row.setAttribute("data-myID", i);
						row.onclick = function (){ showScreen("modDetailScreen");setActiveItem(this.getAttribute("data-myID")); };
	                	row.innerHTML = "<td>"+obj.cperItemName[i]+"</td><td>"+obj.cperQuantity[i]+"</td><td>"+obj.cperUnitPrice[i]+"</td><td>"+obj.cperAmount[i]+"</td><td>"+obj.cperStartDate[i]+"</td><td>"+obj.cperRemark[i]+"</td>";
					}
	        	}
        	}
        	
	    }
	};
	xhr.send();
}


function clearSelect(el){
	while (el.options.length > 0){
		el.remove(0);
	}
}

function setAddType(elementId1){
	var el1 = document.getElementById(elementId1);
	clearSelect(el1);
	for(i=0;i<itemList.length;i++){
		var option = document.createElement("option");
		option.text = itemList[i].type;
		option.value = itemList[i].val;
		el1.add(option); 
	}
	var selectedCitemCatId = "<%= patGrpBean.getCperBean().getField(EmsDB.EM_CHC_CHARGE_CAT[0][0]).getFormValue() %>";
	if(selectedCitemCatId!=null && selectedCitemCatId != ""){
		document.getElementById("add<%=EmsDB.EM_CHC_CHARGE_CAT[0][0]%>").value = selectedCitemCatId;

		setAddSubType('add<%= EmsDB.EM_CHC_CHARGE_CAT[0][0] %>','add<%= EmsDB.EM_CHP_CHARGE_PERSON[3][0] %>',document.getElementById("add<%=EmsDB.EM_CHC_CHARGE_CAT[0][0]%>").selectedIndex);
		
		var selectedCitemId = "<%= patGrpBean.getCperBean().getField(EmsDB.EM_CHP_CHARGE_PERSON[3][0]).getFormValue() %>";
		if(selectedCitemId!=null && selectedCitemId != ""){
			document.getElementById("add<%=EmsDB.EM_CHP_CHARGE_PERSON[3][0]%>").value = selectedCitemId;
		}
	
		document.getElementById("add<%=EmsDB.EM_CHP_CHARGE_PERSON[5][0]%>").value = "<%= patGrpBean.getCperBean().getField(EmsDB.EM_CHP_CHARGE_PERSON[5][0]).getFormValue() %>";
		document.getElementById("add<%=EmsDB.EM_CHP_CHARGE_PERSON[6][0]%>").value = "<%= patGrpBean.getCperBean().getField(EmsDB.EM_CHP_CHARGE_PERSON[6][0]).getFormValue() %>";
		document.getElementById("add<%=EmsDB.EM_CHP_CHARGE_PERSON[7][0]%>").value = "<%= patGrpBean.getCperBean().getField(EmsDB.EM_CHP_CHARGE_PERSON[7][0]).getFormValue() %>";
		
		<% for(int i=0;i<patBeanList.size();i++){ 
				if(patBeanList.get(i).getPerId().equals(patGrpBean.getCperBean().getPerId())){
		%>
		setActiveRecord(<%=i%>);
		<% 		}
			} 
		%>
	}


}

function setModType(elementId1){
	var el1 = document.getElementById(elementId1);
	clearSelect(el1);
	for(i=0;i<itemList.length;i++){
		var option = document.createElement("option");
		option.text = itemList[i].type;
		option.value = itemList[i].val;
		el1.add(option); 
	}
	var selectedCitemCatId = "<%= patGrpBean.getCperBean().getField(EmsDB.EM_CHC_CHARGE_CAT[0][0]).getFormValue() %>";
	if(selectedCitemCatId!=null && selectedCitemCatId != ""){
		document.getElementById("mod<%=EmsDB.EM_CHC_CHARGE_CAT[0][0]%>").value = selectedCitemCatId;

		setModSubType('mod<%= EmsDB.EM_CHC_CHARGE_CAT[0][0] %>','mod<%= EmsDB.EM_CHP_CHARGE_PERSON[3][0] %>',document.getElementById("mod<%=EmsDB.EM_CHC_CHARGE_CAT[0][0]%>").selectedIndex);
		
		var selectedCitemId = "<%= patGrpBean.getCperBean().getField(EmsDB.EM_CHP_CHARGE_PERSON[3][0]).getFormValue() %>";
		if(selectedCitemId!=null && selectedCitemId != ""){
			document.getElementById("mod<%=EmsDB.EM_CHP_CHARGE_PERSON[3][0]%>").value = selectedCitemId;
		}
	
		document.getElementById("mod<%=EmsDB.EM_CHP_CHARGE_PERSON[5][0]%>").value = "<%= patGrpBean.getCperBean().getField(EmsDB.EM_CHP_CHARGE_PERSON[5][0]).getFormValue() %>";
		document.getElementById("mod<%=EmsDB.EM_CHP_CHARGE_PERSON[6][0]%>").value = "<%= patGrpBean.getCperBean().getField(EmsDB.EM_CHP_CHARGE_PERSON[6][0]).getFormValue() %>";
		document.getElementById("mod<%=EmsDB.EM_CHP_CHARGE_PERSON[7][0]%>").value = "<%= patGrpBean.getCperBean().getField(EmsDB.EM_CHP_CHARGE_PERSON[7][0]).getFormValue() %>";
		
	}

}

function setAddSubType(elementId1,elementId2,ind){
	var el2 = document.getElementById(elementId2);
	clearSelect(el2);
	for(i=0;i<itemList[ind].subType.length;i++){
		var option = document.createElement("option");
		option.text = itemList[ind].subType[i].item;
		option.value = itemList[ind].subType[i].val;
		el2.add(option); 
	}
	document.getElementById("add<%= EmsDB.EM_CHP_CHARGE_PERSON[6][0] %>").value = itemList[ind].subType[0].price;
	setAddPrice(elementId1,elementId2);
}

function setModSubType(elementId1,elementId2,ind){
	var el2 = document.getElementById(elementId2);
	clearSelect(el2);
	for(i=0;i<itemList[ind].subType.length;i++){
		var option = document.createElement("option");
		option.text = itemList[ind].subType[i].item;
		option.value = itemList[ind].subType[i].val;
		el2.add(option); 
	}
	document.getElementById("mod<%= EmsDB.EM_CHP_CHARGE_PERSON[6][0] %>").value = itemList[ind].subType[0].price;
	setModPrice(elementId1,elementId2);
}

function setAddPrice(elementId1,elementId2){
	var el1 = document.getElementById(elementId1);
	var el2 = document.getElementById(elementId2);
	document.getElementById("add<%= EmsDB.EM_CHP_CHARGE_PERSON[7][0] %>").value = document.getElementById("add<%= EmsDB.EM_CHP_CHARGE_PERSON[6][0] %>").value * document.getElementById("add<%= EmsDB.EM_CHP_CHARGE_PERSON[5][0] %>").value;
} 

function setModPrice(elementId1,elementId2){
	var el1 = document.getElementById(elementId1);
	var el2 = document.getElementById(elementId2);
	document.getElementById("mod<%= EmsDB.EM_CHP_CHARGE_PERSON[7][0] %>").value = document.getElementById("mod<%= EmsDB.EM_CHP_CHARGE_PERSON[6][0] %>").value * document.getElementById("mod<%= EmsDB.EM_CHP_CHARGE_PERSON[5][0] %>").value;
} 



setAddType("add<%= EmsDB.EM_CHC_CHARGE_CAT[0][0] %>");
setModType("mod<%= EmsDB.EM_CHC_CHARGE_CAT[0][0] %>");

</script>
</html>
