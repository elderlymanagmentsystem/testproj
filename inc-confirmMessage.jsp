<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<div id="confirmMessage">
	<div class="w3-white" style="position:fixed; opacity:0.5; width:100%; height:100%; top: 43px; z-index: 90"></div>
	<div class="w3-container w3-centered w3-teal w3-round-xlarge" style="position:fixed; top:40%; left: 50%; transform: translateX(-50%); z-index: 91; box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.5), 0 6px 20px 0 rgba(0, 0, 0, 0.2)">
		<table>
			<tr>
				<td colspan="2" nowrap><span class="w3-xxxlarge"><i class="fas fa-question-circle" style="vertical-align: middle;"></i></span> <span class="w3-xlarge">是否確定？</span></td>
			</tr>
			<tr>
				<td>
					<span onclick="document.getElementById('confirmMessage').style.display='none'" class="w3-button w3-orange w3-round-large"><i class="fas fa-check"></i> 確定</span>
				</td>
				<td>
					<span onclick="document.getElementById('confirmMessage').style.display='none'" class="w3-button w3-orange w3-round-large"><i class="fas fa-times"></i> 取消</span>
				</td>
			</tr>
		</table>
	</div>
</div>

