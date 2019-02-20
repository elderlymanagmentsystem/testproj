package ems.util;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.util.ArrayList;

import org.xhtmlrenderer.pdf.ITextRenderer;
import com.lowagie.text.pdf.BaseFont;
import com.lowagie.text.pdf.codec.Base64;

import ems.bean.OrgBean;
import ems.bean.PatGrpBean;
import ems.bean.ResBean;
import ems.bean.ResGrpBean;
import ems.bean.StmtBean;
import ems.bean.TransBean;
import ems.db.BedDB;
import ems.db.OrgDB;

public class PDFUtil {
	private static ITextRenderer renderer = new ITextRenderer();
	private static String fontPath = EmsCommonUtil.getRuntimePath() + "font" + File.separator + "mingliu.ttf";
	private static String HTML_TAIL = "</body></html>";
	private static String HTML_HEAD = "<!DOCTYPE html><html><head><meta http-equiv='Content-Type' content='text/html; charset=UTF-8'/>"
			+ "<style>"
			+ " body { "
			+ "    font-family: MingLiU; "
			+ " } "
			+ "@page { margin: 10mm; "
			+ " @top-right { "
			+ "     font-family: MingLiU; "
			+ "     font-size: 12px; "
			+ "     vertical-align: text-top; "
			+ "     padding-top: 4mm; "
			+ "	    content: '頁 ' counter(page) '/' counter(pages);"
			+ " } "
			+ " @bottom-left { "
			+ " vertical-align: text-top; "
			+ "    font-family: MingLiU; "
			+ "    font-size: 12px; "
			+ "    white-space: pre-wrap;"
			+ "    content: '${orgChiName}$ ${orgEngName}$\\A地址: ${orgChiAddr}$'"
			+ " } "
			+ " @bottom-right { "
			+ "    font-family: MingLiU; "
			+ "    vertical-align: text-bottom; "
			+ "    white-space: pre-wrap;"
			+ "    font-size: 12px; "
			+ "    content: '\\A電話: ${orgTel}$ 傳真: ${orgFax}$'"
			+ " } "
			+ "} "
			+ "table {border-collapse: collapse;} "
			+ "table td{border: 1px solid black;} "
			+ "</style>"
			+ "</head><body>";
	
	public static boolean gen(String orgId, String path, String htmlContent) {
		/*
		OrgDB orgDB = new OrgDB();
		OrgBean accOrgBean = new OrgBean();
		accOrgBean.setOrgId(orgId);
		orgDB.getOrgBean(accOrgBean);
		
		String orgEngName = accOrgBean.getField("ORG_ENG_NAME").getFormValue();
		String orgChiName = accOrgBean.getField("ORG_CHI_NAME").getFormValue();
		String orgChiAddr = accOrgBean.getField("ORG_CHI_ADDR").getFormValue();
		String orgTel = accOrgBean.getField("ORG_TEL").getFormValue();
		String orgFax = accOrgBean.getField("ORG_FAX").getFormValue();
		return gen(orgChiName, orgEngName, orgChiAddr, orgTel, orgFax, path, htmlContent);
		*/
		return gen("", "", "", "", "", path, htmlContent);
	}
	
	public static boolean gen(String orgChiName, String orgEngName, String orgChiAddr, String orgTel, String orgFax, String path, String htmlContent) {
		if (orgChiName == null) orgChiName = "";
		if (orgEngName == null) orgEngName = "";
		if (orgChiAddr == null) orgChiAddr = "";
		if (orgTel == null) orgTel = "";
		if (orgFax == null) orgFax = "";
		if (htmlContent == null) htmlContent = "";
		String htmlHead = HTML_HEAD.replace("${orgChiName}$", orgChiName).replace("${orgEngName}$", orgEngName).replace("${orgChiAddr}$", orgChiAddr).replace("${orgTel}$", orgTel).replace("${orgFax}$", orgFax);
		htmlHead = htmlHead.replaceAll("\\$\\{([^<]*)\\}\\$", ""); //replace all remaining {} field to empty string
		htmlContent = htmlContent.replaceAll("\\$\\{([^<]*)\\}\\$", ""); //replace all remaining {} field to empty string
		try
        {
			String projectPath ="";
			String runtimePath ="";
			String filename="";
			if (path != null) {
				path = path.replace("/",File.separator);
				projectPath = EmsCommonUtil.getProjPath()+path.substring(0,path.lastIndexOf(File.separator)+1);
				runtimePath = EmsCommonUtil.getRuntimePath()+path.substring(0,path.lastIndexOf(File.separator)+1);
				filename = path.substring(path.lastIndexOf(File.separator)+1,path.length());
			}
			(new File(projectPath)).mkdirs();
			(new File(runtimePath)).mkdirs();
			
			OutputStream os1 = new FileOutputStream(projectPath+filename);
			OutputStream os2 = new FileOutputStream(runtimePath+filename);
			renderer.getFontResolver().addFont(fontPath, BaseFont.IDENTITY_H, BaseFont.NOT_EMBEDDED);
			renderer.setDocumentFromString(htmlHead+htmlContent+HTML_TAIL);
			renderer.layout();
			renderer.createPDF(os1);
			os1.close();
			renderer.createPDF(os2);
			os2.close();
        }
        catch (Throwable t)
        {
            t.printStackTrace();
            return false;
        }
		return true;
    }
	
	public static String getImgTag(String path){
		return getImgTag(path, 0);
	}
	
	public static String getImgTag(String path, int height){
		FileInputStream fileInputStreamReader = null;
		try {
			File file = new File(EmsCommonUtil.getRuntimePath()+File.separator+path);
			fileInputStreamReader = new FileInputStream(file);
			byte[] bytes = new byte[(int)file.length()];
			fileInputStreamReader.read(bytes);
			fileInputStreamReader.close();
			String temp = (height == 0) ? "' style='height: 100%; width: auto'/>" : "' style='height: " + height + "px; width: auto'/>" ;
			return "<img src='data:image/jpg;base64, " + new String(Base64.encodeBytes(bytes)) + temp ;
		} catch (IOException e) {
			e.printStackTrace();
			return "";
		}
    }
	
	// --------template start------- //
	public static void genDownPaymentSlip(ResGrpBean resGrpBean) {
		TransBean transBean = resGrpBean.getTransBean();
		String perChiName = resGrpBean.getField("PER_CHI_NAME").getFormValue();
		String traDate = transBean.getField("TRA_DATE").getFormValue();
		String traReceiptId = transBean.getField("TRA_RECEIPT_ID").getFormValue();
		String traType = EmsCommonUtil.getTraTypeWording(transBean.getField("TRA_TYPE").getFormValue());
		String traMethod = EmsCommonUtil.getTraMethodWording(transBean.getField("TRA_METHOD").getFormValue());
		String traNote = transBean.getField("TRA_NOTE").getFormValue();
		String traAmount = transBean.getField("TRA_AMOUNT").getFormValue();
		String traPdfFile = transBean.getField("TRA_PDF_FILE").getFormValue();
		
		String HEADER_AND_INFO = "<table style='border-bottom: 1pt solid black; font-size: 36px; width:100%; height:60px'>" + 
				"<tr style='vertical-align: middle;'>" +
				"	<td style='border: none'>訂金收據</td>" + 
				"	<td style='border: none; text-align: right'>${logo}$</td>" + 
				"</tr>" + 
				"</table>" + 
				"<br/>" +
		        "<table width='100%'><tr><td style='border: 0px'>" +
				"<table width='300px' align='right'>" +  
				"<col width='50%'/> " +
				"<col width='50%'/> " +
				"<tr>" + 
				"	<td>院友姓名:</td>" + 
				"	<td>${perChiName}$</td>" + 
				"</tr>" + 
				"<tr>" + 
				"	<td>收據日期:</td>" + 
				"	<td>${traDate}$</td>" + 
				"</tr>" + 
				"<tr>" + 
				"	<td>收據號碼:</td>" + 
				"	<td>${traReceiptId}$</td>" + 
				"</tr>" +
				"</table>" +
				"</td></tr></table>" +
				"<br/><br/>";
		String TRX_DETAIL_HEADER ="<table style='width:100%'>" +  
				"<col width='20%'/> " +
				"<col width='20%'/> " +
				"<col width='20%'/> " +
				"<col width='20%'/> " +
				"<col width='20%'/> " +
				"<tr style='background-color:LightSteelBlue'>" + 
				"	<td>日期</td>" + 
				"	<td>帳項</td>" + 
				"	<td>繳費方法</td>" + 
				"	<td>備註</td>" + 
				"	<td style='text-align: right'>金額(港幣)</td>" + 
				"</tr>"; 
		String TRX_DETAIL_REC = 
				"<tr>" + 
				"	<td>${traDate}$</td>" + 
				"	<td>${traType}$</td>" + 
				"	<td>${traMethod}$</td>" + 
				"	<td>${traNote}$</td>" + 
				"	<td style='text-align: right'>${traAmount}$</td>" + 
				"</tr>";
		String TRX_DETAIL_TOTAL = "<tr>" + 
				"	<td style='border:none;'></td>" + 
				"	<td style='border:none;'></td>" + 
				"	<td style='border:none;'></td>" + 
				"	<td style='background-color:WhiteSmoke; text-align: right'>已付訂金總數</td>" + 
				"	<td style='background-color:WhiteSmoke; text-align: right'>HK$ ${traTotalAmount}$</td>" + 
				"</tr>";
		String TRX_DETAIL_FOOTER = "</table><br/><br/>";
		String REMARKS_AND_STAMP = "<p>注意: 以上已付訂金將不會退回</p><br/><br/><br/>"+
		        "<table width='300px'>" +  
				"<col width='50%'/> " +
				"<col width='50%'/> " +
				"<tr>" + 
				"	<td style='border: none'>公司蓋印:</td>" + 
				"	<td style='border: none; border-bottom: 1pt solid black;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>" + 
				"</tr>" + 
				"</table>";
		String headerAndInfo= HEADER_AND_INFO.replace("${logo}$", getImgTag("file\\org" + resGrpBean.getOrgId() + "\\logo\\img" + resGrpBean.getOrgId() + ".jpg",100)).replace("${perChiName}$", perChiName).replace("${traDate}$", traDate).replace("${traReceiptId}$", traReceiptId);
		String trxDetail = TRX_DETAIL_REC.replace("${traDate}$", traDate).replace("${traType}$", traType).replace("${traMethod}$", traMethod).replace("${traNote}$", traNote).replace("${traAmount}$", traAmount);
		String trxDetailTotal = TRX_DETAIL_TOTAL.replace("${traTotalAmount}$", traAmount);
		PDFUtil.gen(resGrpBean.getOrgId(), traPdfFile, headerAndInfo+TRX_DETAIL_HEADER+trxDetail+trxDetailTotal+TRX_DETAIL_FOOTER+REMARKS_AND_STAMP);
	}
	
	public static void genDepositeSlip(PatGrpBean patGrpBean) {
		TransBean transBean = patGrpBean.getTransBean();
		String perChiName = patGrpBean.getField("PER_CHI_NAME").getFormValue();
		String patId = patGrpBean.getField("PAT_ID").getFormValue();
		String traDate = transBean.getField("TRA_DATE").getFormValue();
		String traReceiptId = transBean.getField("TRA_RECEIPT_ID").getFormValue();
		String traType = EmsCommonUtil.getTraTypeWording(transBean.getField("TRA_TYPE").getFormValue());
		String traMethod = EmsCommonUtil.getTraMethodWording(transBean.getField("TRA_METHOD").getFormValue());
		String traNote = transBean.getField("TRA_NOTE").getFormValue();
		String traAmount = transBean.getField("TRA_AMOUNT").getFormValue();
		String traPdfFile = transBean.getField("TRA_PDF_FILE").getFormValue();
		
		String HEADER_AND_INFO = "<table style='border-bottom: 1pt solid black; font-size: 36px; width:100%; height:60px'>" + 
				"<tr style='vertical-align: middle;'>" +
				"	<td style='border: none'>按金收據</td>" + 
				"	<td style='border: none; text-align: right'>${logo}$</td>" + 
				"</tr>" + 
				"</table>" + 
				"<br/>" +
		        "<table width='100%'><tr><td style='border: 0px'>" +
				"<table width='300px' align='right'>" +  
				"<col width='50%'/> " +
				"<col width='50%'/> " +
				"<tr>" + 
				"	<td>院友姓名:</td>" + 
				"	<td>${perChiName}$</td>" + 
				"</tr>" + 
				"<tr>" + 
				"	<td>院友編號:</td>" + 
				"	<td>${patId}$</td>" + 
				"</tr>" +
				"<tr>" + 
				"	<td>收據日期:</td>" + 
				"	<td>${traDate}$</td>" + 
				"</tr>" + 
				"<tr>" + 
				"	<td>收據號碼:</td>" + 
				"	<td>${traReceiptId}$</td>" + 
				"</tr>" +
				"</table>" +
				"</td></tr></table>" +
				"<br/><br/>";
		String TRX_DETAIL_HEADER ="<table style='width:100%'>" +  
				"<col width='20%'/> " +
				"<col width='20%'/> " +
				"<col width='20%'/> " +
				"<col width='20%'/> " +
				"<col width='20%'/> " +
				"<tr style='background-color:LightSteelBlue'>" + 
				"	<td>日期</td>" + 
				"	<td>帳項</td>" + 
				"	<td>繳費方法</td>" + 
				"	<td>備註</td>" + 
				"	<td style='text-align: right'>金額(港幣)</td>" + 
				"</tr>"; 
		String TRX_DETAIL_REC = 
				"<tr>" + 
				"	<td>${traDate}$</td>" + 
				"	<td>${traType}$</td>" + 
				"	<td>${traMethod}$</td>" + 
				"	<td>${traNote}$</td>" + 
				"	<td style='text-align: right'>${traAmount}$</td>" + 
				"</tr>";
		String TRX_DETAIL_TOTAL = "<tr>" + 
				"	<td style='border:none;'></td>" + 
				"	<td style='border:none;'></td>" + 
				"	<td style='border:none;'></td>" + 
				"	<td style='background-color:WhiteSmoke; text-align: right'>已付按金總數</td>" + 
				"	<td style='background-color:WhiteSmoke; text-align: right'>HK$ ${traTotalAmount}$</td>" + 
				"</tr>";
		String TRX_DETAIL_FOOTER = "</table><br/><br/>";
		String REMARKS_AND_STAMP = "<br/>"+
		        "<table width='300px'>" +  
				"<col width='50%'/> " +
				"<col width='50%'/> " +
				"<tr>" + 
				"	<td style='border: none'>公司蓋印:</td>" + 
				"	<td style='border: none; border-bottom: 1pt solid black;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>" + 
				"</tr>" + 
				"</table>";
		String headerAndInfo= HEADER_AND_INFO.replace("${logo}$", getImgTag("file\\org" + patGrpBean.getOrgId() + "\\logo\\img" + patGrpBean.getOrgId() + ".jpg",100)).replace("${perChiName}$", perChiName).replace("${patId}$", patId).replace("${traDate}$", traDate).replace("${traReceiptId}$", traReceiptId);
		String trxDetail = TRX_DETAIL_REC.replace("${traDate}$", traDate).replace("${traType}$", traType).replace("${traMethod}$", traMethod).replace("${traNote}$", traNote).replace("${traAmount}$", traAmount);
		String trxDetailTotal = TRX_DETAIL_TOTAL.replace("${traTotalAmount}$", traAmount);
		PDFUtil.gen(patGrpBean.getOrgId(), traPdfFile, headerAndInfo+TRX_DETAIL_HEADER+trxDetail+trxDetailTotal+TRX_DETAIL_FOOTER+REMARKS_AND_STAMP);
	}
	
	public static void genReceiptSlip(ArrayList<StmtBean> stmtBeanList) {
		String HEADER_AND_INFO = "<table style='border-bottom: 1pt solid black; font-size: 36px; width:100%; height:60px'>" + 
				"<tr style='vertical-align: middle;'>" +
				"	<td style='border: none'>付款收據</td>" + 
				"	<td style='border: none; text-align: right'>${logo}$</td>" + 
				"</tr>" + 
				"</table>" + 
				"<br/>" +
		        "<table width='100%'><tr><td style='border: 0px'>" +
				"<table width='300px' align='right'>" +  
				"<col width='50%'/> " +
				"<col width='50%'/> " +
				"<tr>" + 
				"	<td>院友姓名:</td>" + 
				"	<td>${perChiName}$</td>" + 
				"</tr>" + 
				"<tr>" + 
				"	<td>院友編號:</td>" + 
				"	<td>${patId}$</td>" + 
				"</tr>" +
				"<tr>" + 
				"	<td>收據日期:</td>" + 
				"	<td>${stmDate}$</td>" + 
				"</tr>" + 
				"<tr>" + 
				"	<td>收據號碼:</td>" + 
				"	<td>${stmID}$</td>" + 
				"</tr>" +
				"</table>" +
				"</td></tr></table>" +
				"<br/><br/>";
		String TRX_DETAIL_HEADER ="<table style='width:100%'>" +  
				"<col width='20%'/> " +
				"<col width='20%'/> " +
				"<col width='20%'/> " +
				"<col width='20%'/> " +
				"<col width='20%'/> " +
				"<tr style='background-color:LightSteelBlue'>" + 
				"	<td>日期</td>" + 
				"	<td>帳項</td>" + 
				"	<td>繳費方法</td>" + 
				"	<td>備註</td>" + 
				"	<td style='text-align: right'>金額(港幣)</td>" + 
				"</tr>"; 
		String TRX_DETAIL_REC = 
				"<tr>" + 
				"	<td>${trxDate}$</td>" + 
				"	<td>${trxItem}$</td>" + 
				"	<td>${trxPayMethod}$</td>" + 
				"	<td>${trxRmarks}$</td>" + 
				"	<td style='text-align: right'>${trxAmount}$</td>" + 
				"</tr>";
		String TRX_DETAIL_TOTAL = "<tr>" + 
				"	<td style='border:none;'></td>" + 
				"	<td style='border:none;'></td>" + 
				"	<td style='border:none;'></td>" + 
				"	<td style='background-color:WhiteSmoke; text-align: right'>已付總數</td>" + 
				"	<td style='background-color:WhiteSmoke; text-align: right'>HK$ ${trxTotalAmount}$</td>" + 
				"</tr>";
		String TRX_DETAIL_FOOTER = "</table><br/><br/>";
		String REMARKS_AND_STAMP = "<br/>"+
		        "<table width='300px'>" +  
				"<col width='50%'/> " +
				"<col width='50%'/> " +
				"<tr>" + 
				"	<td style='border: none'>公司蓋印:</td>" + 
				"	<td style='border: none; border-bottom: 1pt solid black;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>" + 
				"</tr>" + 
				"</table>";
		String headerAndInfo= HEADER_AND_INFO.replace("${logo}$", getImgTag("file\\org1001\\logo\\img1001.jpg",100)).replace("${perChiName}$", "陳大文").replace("${stmDate}$", "2019-01-01").replace("${stmID}$", "STM100001");
		String trxDetail = TRX_DETAIL_REC.replace("${trxDate}$", "2019-01-01").replace("${trxItem}$", "2019-01-01").replace("${trxPayMethod}$", "2019-01-01").replace("${trxRmarks}$", "2019-01-01").replace("${trxAmount}$", "2019-01-01");
		String trxDetailTotal = TRX_DETAIL_TOTAL.replace("${trxTotalAmount}$", "123.00");
		//PDFUtil.gen("香港仔安老院", "GRANYET (ABERDEEN) ELDERLY CARE CENTRE", "香港仔田灣漁歌街5號xxxxxxxx","12345678", "11112222", headerAndInfo+TRX_DETAIL_HEADER+trxDetail+trxDetailTotal+TRX_DETAIL_FOOTER+REMARKS_AND_STAMP);
	}
	
	public static void genResConfirmSlip(ResGrpBean resGrpBean) {
		
		ResBean resBean = resGrpBean.getResBeanList().get(0);
		TransBean transBean = resGrpBean.getTransBean();
		String perChiName = resGrpBean.getField("PER_CHI_NAME").getFormValue();
		String bedFullName = (new BedDB().getBedFullName(resBean.getBedId()));
		String resStartDate = resBean.getField("RES_START_DATE").getFormValue();
		String resLivingFee = resBean.getField("RES_LIVING_FEE").getFormValue();
		String traAmount = transBean.getField("TRA_AMOUNT").getFormValue();
		String resPdfFile = resBean.getField("RES_PDF_FILE").getFormValue();
		/*
		System.out.println(perChiName);
		System.out.println(bedId);
		System.out.println(resStartDate);
		System.out.println(resLivingFee);
		System.out.println(traAmount);
		System.out.println(resPdfFile);
		String resPdfFile = "file\\org1001\\per100010\\pdf\\a.pdf";
		*/
		
		String HEADER_AND_INFO = "<table style='border-bottom: 1pt solid black; font-size: 36px; width:100%; height:60px'>" + 
				"<tr style='vertical-align: middle;'>" +
				"	<td style='border: none'>訂位確認書</td>" + 
				"	<td style='border: none; text-align: right'>${logo}$</td>" + 
				"</tr>" + 
				"</table>" + 
				"<br/>" +
		        "<table width='100%'><tr><td style='border: 0px'>" +
				"<table width='300px' align='left'>" +  
				"<col width='50%'/> " +
				"<col width='50%'/> " +
				"<tr>" + 
				"	<td>院友姓名:</td>" + 
				"	<td>${perChiName}$</td>" + 
				"</tr>" + 
				"<tr>" + 
				"	<td>床位號碼:</td>" + 
				"	<td>${bedFullName}$</td>" + 
				"</tr>" + 
				"<tr>" + 
				"	<td>訂位日期:</td>" + 
				"	<td>${resStartDate}$</td>" + 
				"</tr>" +
				"</table>" +
				"</td></tr></table>" +
				"<br/><br/>";
		String LIV_FEE_AND_DEPOSITE = "<table style='width:100%'>" +  
				"<col width='15%'/> " +
				"<col width='30%'/> " +
				"<col width='20%'/> " +
				"<col width='35%'/> " +
				"<tr style='text-align: center'> " +
			  	"<td rowspan='3'>院<br/>費<br/>及<br/>按<br/>金</td> " +
			    "<td>收費項目</td> " +
			    "<td colspan='2'>收費</td> " +
			    "</tr> " +
			    "<tr> " +
			    "<td>&shy;&shy;院費</td> " +
			    "<td style='border-right-style: none'>$ ${resLivingFee}$</td> " +
			    "<td style='border-left-style: none'>&#47;月</td> " +
			    "</tr> " +
			    "<tr> " +
			    "<td>&shy;&shy;按金</td> " +
			    "<td colspan='2'>$ ${traAmount}$</td> " +
			    "</tr> "+
				"</table> "+
			    "<br/>"+
				"<br/>";
		
		String nursing = "<table style='width:100%'>" +  
				"<col width='15%'/> " +
				"<col width='30%'/> " +
				"<col width='20%'/> " +
				"<col width='35%'/> " +
				"<tr style='text-align: center'> " +
			  	"<td rowspan='9'>護<br/>理<br/>費</td> " +
			    "<td>收費項目</td> " +
			    "<td colspan='2'>收費</td> " +
			    "</tr> " +
			    "<tr> " +
			    "<td colspan='3'>(A)基本護理</td> " +
			    "</tr> " +
			    "<tr> " +
			    "<td>自理</td> " +
			    "<td colspan='2'></td> " +
			    "</tr> "+
			    "<tr> " +
			    "<td>低度護理</td> " +
			    "<td style='border-right-style: none'>$</td> " +
			    "<td style='border-left-style: none'>&#47;月</td> " +
			    "</tr> "+
			    "<tr> " +
			    "<td>半護理</td> " +
			    "<td style='border-right-style: none'>$</td> " +
			    "<td style='border-left-style: none'>&#47;月</td> " +
			    "</tr> "+
			    "<tr> " +
			    "<td>全護理</td> " +
			    "<td style='border-right-style: none'>$</td> " +
			    "<td style='border-left-style: none'>&#47;月</td> " +
			    "</tr> "+
			    "<tr> " +
			    "<td colspan='3'>(B)特別護理項目</td> " +
			    "</tr> " +
			    "<tr> " +
			    "<td>1</td> " +
			    "<td style='border-right-style: none'>$</td> " +
			    "<td style='border-left-style: none'>&#47;月</td> " +
			    "</tr> "+
			    "<tr> " +
			    "<td>2</td> " +
			    "<td style='border-right-style: none'>$</td> " +
			    "<td style='border-left-style: none'>&#47;月</td> " +
			    "</tr> "+
				"</table> ";
		
		String REMARKS_AND_STAMP = "<p>註: 訂金將保留14日, 過後訂金將不會退還 </p><br/><br/><br/>"+
		        "<table width='100%'>" +  
				"<col width='25%'/> " +
				"<col width='25%'/> " +
				"<col width='25%'/> " +
				"<col width='25%'/> " +
				"<tr>" + 
				"	<td style='border: none'>院舍代表姓名:<br/>&shy;</td>" + 
				"	<td style='border: none'>_______________<br/>&shy;</td>" +
				"	<td style='border: none'>院友/院友家屬姓名:<br/>&shy;</td>" + 
				"	<td style='border: none'>_______________<br/>&shy;</td>" + 
				"</tr>" +
				"<tr>" + 
				"	<td style='border: none'>簽署:<br/>&shy;</td>" + 
				"	<td style='border: none'>_______________<br/>&shy;</td>" + 
				"	<td style='border: none'>簽署:<br/>&shy;</td>" + 
				"	<td style='border: none'>_______________<br/>&shy;</td>" + 
				"</tr>" +
				"<tr>" + 
				"	<td style='border: none'>&shy;<br/>&shy;</td>" + 
				"	<td style='border: none'>&shy;<br/>&shy;</td>" + 
				"	<td style='border: none'>日期:<br/>&shy;</td>" + 
				"	<td style='border: none'>_______________<br/>&shy;</td>" + 
				"</tr>" +
				"</table>";
		
		String headerAndInfo= HEADER_AND_INFO.replace("${logo}$", getImgTag("file\\org" + resGrpBean.getOrgId() + "\\logo\\img" + resGrpBean.getOrgId() + ".jpg",100)).replace("${perChiName}$", perChiName).replace("${bedFullName}$", bedFullName).replace("${resStartDate}$", resStartDate);
		String livFeeAndDeposite = LIV_FEE_AND_DEPOSITE.replace("${resLivingFee}$", resLivingFee).replace("${traAmount}$", traAmount);
		PDFUtil.gen(resGrpBean.getOrgId(), resPdfFile, headerAndInfo+livFeeAndDeposite+nursing+REMARKS_AND_STAMP);
		//String headerAndInfo = HEADER_AND_INFO;
		//String livFeeAndDeposite = LIV_FEE_AND_DEPOSITE;
		//resPdfFile = "file\\org1001\\per100010\\pdf\\a.pdf";
		//gen("A", "A", "A", "A", "A", resPdfFile, headerAndInfo+livFeeAndDeposite+nursing+REMARKS_AND_STAMP);		
	}
	
	public static void genStmtSlip(PatGrpBean patGrpBean) {
		/*
		TransBean transBean = patGrpBean.getTransBean();
		String perChiName = patGrpBean.getField("PER_CHI_NAME").getFormValue();
		String patId = patGrpBean.getField("PAT_ID").getFormValue();
		String traDate = transBean.getField("TRA_DATE").getFormValue();
		String traReceiptId = transBean.getField("TRA_RECEIPT_ID").getFormValue();
		String traType = EmsCommonUtil.getTraTypeWording(transBean.getField("TRA_TYPE").getFormValue());
		String traMethod = EmsCommonUtil.getTraMethodWording(transBean.getField("TRA_METHOD").getFormValue());
		String traNote = transBean.getField("TRA_NOTE").getFormValue();
		String traAmount = transBean.getField("TRA_AMOUNT").getFormValue();
		String traPdfFile = transBean.getField("TRA_PDF_FILE").getFormValue();
		*/
		
		
		String HEADER_AND_INFO = "<table style='font-size: 20px; width:100%; height:60px'>" + 
				"<col width='50%'/> " +
				"<col width='50%'/> " +
				"<tr style='vertical-align: center;'>" +
				"	<td style='border: none; text-align: left'>${logo}$</td>" + 
				"	<td style='border: none;'>&shy;&shy;&shy;月結單<br/>MONTHLY STATEMENT</td>" + 
				"</tr>" + 
				"</table>" + 
				"<br/>" +
				"<table width='100%'>" +  
				"<col width='40%'/> " +
				"<col width='15%'/> " +
				"<col width='15%'/> " +
				"<col width='15%'/> " +
				"<col width='15%'/> " +
				"<tr>" + 
				"	<td rowspan='2' style='border: 0px'></td>" +
				"	<td style='border: 0px'>院友編號:<br/>&shy;</td>" + 
				"	<td style='border: 0px'>${perChiName}$<br/>&shy;</td>" + 
				"	<td style='border: 0px'>床位號碼:<br/>&shy;</td>" + 
				"	<td style='border: 0px'>${perChiName}$<br/>&shy;</td>" + 
				"</tr>" + 
				"<tr>" + 
				"	<td style='border: 0px'>截數日期:<br/>&shy;</td>" + 
				"	<td style='border: 0px'>${patId}$<br/>&shy;</td>" + 
				"	<td style='border: 0px'>到期付款日:<br/>&shy;</td>" + 
				"	<td style='border: 0px'>${patId}$<br/>&shy;</td>" + 
				"</tr>" +
				"<tr>" + 
				"	<td rowspan='2'>院友姓名: ${perChiName}$</td>" +
				"	<td style='border: 0px'>總結欠帳項:<br/>&shy;</td>" + 
				"	<td colspan='3' style='border: 0px'>${traDate}$<br/>&shy;</td>" + 
				"</tr>" + 
				"<tr>" + 
				"	<td colspan='4' style='border: 0px'>*提醒:必須在 60 天內付款。過期付款，可被加收利息</td>" + 
				"</tr>" +
				"</table>" +
				"<table style='border: none; width:100%;'><tr style='border: none;'><td style='border: none; border-bottom: 0.5pt solid black;'>&shy;</td></tr></table>"+
				"<br/>";
		
		String TRX_DETAIL_HEADER ="<table style='width:100%'>" +  
				"<col width='15%'/> " +
				"<col width='15%'/> " +
				"<col width='5%'/> " +
				"<col width='20%'/> " +
				"<col width='15%'/> " +
				"<col width='15%'/> " +
				"<col width='15%'/> " +
				"<tr style='background-color:LightSteelBlue'>" + 
				"	<td>日期</td>" + 
				"	<td>收費項目</td>" + 
				"	<td></td>" + 
				"	<td>備註</td>" + 
				"	<td>該付</td>" + 
				"	<td>己付</td>" + 
				"	<td style='text-align: right'>結餘</td>" + 
				"</tr>"; 
		String TRX_DETAIL_REC = 
				"<tr>" + 
				"	<td>${traDate}$</td>" + 
				"	<td>${traType}$</td>" + 
				"	<td>${traMethod}$</td>" + 
				"	<td>${traNote}$</td>" + 
				"	<td style='text-align: right'>${traAmount}$</td>" + 
				"</tr>";
		String TRX_DETAIL_TOTAL = "<tr>" + 
				"	<td style='border:none;' colspan='5'>如有查詢 ，可聯絡本院辨事處 。   電話 : xxxx xxxx</td>" +
				"	<td style='background-color:WhiteSmoke; text-align: right'>總結欠</td>" + 
				"	<td style='background-color:WhiteSmoke; text-align: right'>HK$ ${traTotalAmount}$</td>" + 
				"</tr>";
		String TRX_DEPOSITE = "<tr>" + 
				"	<td style='border:none;' colspan='5'>&nbsp;</td>" +
				"	<td style='border:none; text-align: right' colspan='2'>(己付按金: HK$ ${traDeposite}$)</td>" +
				"</tr>";
		String TRX_DETAIL_FOOTER = "</table><br/><br/>";
		
		String REMAINING_AMOUNT ="<table style='width:100%; text-align: center'>" +  
				"<col width='25%'/> " +
				"<col width='25%'/> " +
				"<col width='25%'/> " +
				"<col width='25%'/> " +
				"<tr>" + 
				"	<td>本月</td>" + 
				"	<td>30 - 60 天</td>" + 
				"	<td>60 - 90 天</td>" +
				"	<td>應付金額</td>" + 
				"</tr>"+
				"<tr>" + 
				"	<td>HK$ ${current}$</td>" + 
				"	<td>HK$ ${30-60}$</td>" + 
				"	<td>HK$ ${60-90}$</td>" +
				"	<td>HK$ ${shouldPay}$</td>" +
				"</tr>"+
				"</table><br/><br/>";
		
		String REMARKS = "<table width='65%'>" +  
					"<tr><td style='border: none; background-color:LightSteelBlue;color:white;'>繳款細則</td></tr>" + 
					"<tr><td style='border: none; border-bottom: 0.5pt solid black;'>付款方法: 現金 &#47; 轉賬 &#47; 支票 &#47; 現金支票 &#47; FPS</td></tr>" + 
					"<tr><td style='border: none; border-bottom: 0.5pt solid black;'>支票抬頭 : JACKSON xxx xxxx LIMITED</td></tr>" +
					"<tr><td style='border: none; border-bottom: 0.5pt solid black;'>南洋銀行: 043-xxx-x-123456</td></tr>" +
					"<tr><td style='border: none; border-bottom: 0.5pt solid black;'>FPS ID: 123456</td></tr>" +
					"<tr><td style='border: none; border-bottom: 0.5pt solid black;'>* 如客人親身入賬或經銀行轉賬，煩請傳真入數記錄至本院舍</td></tr>" +
					"<tr><td style='border: none; border-bottom: 0.5pt solid black;'>(入數記錄請註明院友姓名及付款月份)*</td></tr>" +
				"</table>";
		String headerAndInfo= HEADER_AND_INFO.replace("${logo}$", getImgTag("file\\org" + patGrpBean.getOrgId() + "\\logo\\img" + patGrpBean.getOrgId() + ".jpg",100)).replace("${perChiName}$", "a").replace("${patId}$", "123").replace("${traDate}$", "2011-01-01").replace("${traReceiptId}$", "100001");
		//String trxDetail = TRX_DETAIL_REC.replace("${traDate}$", traDate).replace("${traType}$", traType).replace("${traMethod}$", traMethod).replace("${traNote}$", traNote).replace("${traAmount}$", traAmount);
		//String trxDetailTotal = TRX_DETAIL_TOTAL.replace("${traTotalAmount}$", traAmount);
		
		String traPdfFile = "file\\org1001\\per100010\\pdf\\a.pdf";
		//PDFUtil.gen(patGrpBean.getOrgId(), traPdfFile, headerAndInfo);
		PDFUtil.gen(patGrpBean.getOrgId(), traPdfFile, headerAndInfo+TRX_DETAIL_HEADER+TRX_DETAIL_REC+TRX_DETAIL_TOTAL+TRX_DEPOSITE+TRX_DETAIL_FOOTER+REMAINING_AMOUNT+REMARKS);
	}
	
	public static void genLivConfirmSlip(PatGrpBean patGrpBean) {
		/*
		TransBean transBean = patGrpBean.getTransBean();
		String perChiName = patGrpBean.getField("PER_CHI_NAME").getFormValue();
		String patId = patGrpBean.getField("PAT_ID").getFormValue();
		String traDate = transBean.getField("TRA_DATE").getFormValue();
		String traReceiptId = transBean.getField("TRA_RECEIPT_ID").getFormValue();
		String traType = EmsCommonUtil.getTraTypeWording(transBean.getField("TRA_TYPE").getFormValue());
		String traMethod = EmsCommonUtil.getTraMethodWording(transBean.getField("TRA_METHOD").getFormValue());
		String traNote = transBean.getField("TRA_NOTE").getFormValue();
		String traAmount = transBean.getField("TRA_AMOUNT").getFormValue();
		String traPdfFile = transBean.getField("TRA_PDF_FILE").getFormValue();
		*/
		/*
		System.out.println(perChiName);
		System.out.println(bedId);
		System.out.println(resStartDate);
		System.out.println(resLivingFee);
		System.out.println(traAmount);
		System.out.println(resPdfFile);
		String resPdfFile = "file\\org1001\\per100010\\pdf\\a.pdf";
		*/
		
		String HEADER_AND_INFO = "<table style='font-size: 36px; width:100%; height:60px'>" + 
				"<tr style='vertical-align: middle;'>" +
				"	<td style='border: none'>入住收費協議</td>" + 
				"	<td style='border: none; text-align: right'>${logo}$</td>" + 
				"</tr>" + 
				"</table>" + 
		        "<table width='100%'>" +
				"<col width='8%'/> " +
				"<col width='35%'/> " +
				"<col width='55%'/> " +
		        "<tr><td style='border: 0px'></td><td style='border: 0px'>" +
				"<table style='width:100%;'>" +  
				"<col width='45%'/> " +
				"<col width='55%'/> " +
				"<tr>" + 
				"	<td>院友姓名:</td>" + 
				"	<td>${perChiName}$</td>" + 
				"</tr>" + 
				"<tr>" + 
				"	<td>身份證號碼:</td>" + 
				"	<td>${bedFullName}$</td>" + 
				"</tr>" +
				"<tr>" + 
				"	<td>床位號碼:</td>" + 
				"	<td>${bedFullName}$</td>" + 
				"</tr>" +
				"<tr>" + 
				"	<td>入住日期:</td>" + 
				"	<td>${resStartDate}$</td>" + 
				"</tr>" +
				"</table>" +
				"</td><td style='border: 0px'></td></tr></table>" +
				"<br/>";
		String LIV_FEE = "<table style='width:100%'>" +  
				"<col width='8%'/> " +
				"<col width='10%'/> " +
				"<col width='25%'/> " +
				"<col width='12%'/> " +
				"<col width='8%'/> " +
				"<col width='37%'/> " +
				"<tr style='text-align: center'> " +
			  	"<td rowspan='3'>A</td> " +
			  	"<td rowspan='3'>院<br/>費<br/>及<br/>按<br/>金</td> " +
			    "<td>收費項目</td> " +
			    "<td colspan='2'>收費</td> " +
			    "<td>內容說明</td> " +
			    "</tr><tr> " +
			    "<td>&shy;1. 院費</td> " +
			    "<td style='border-right-style: none'>$ ${resLivingFee}$</td> " +
			    "<td style='border-left-style: none'>&#47;月</td> " +
			    "<td>住不足一個月，仍按整月收取院費。若長者入住醫院而未有辦理退住本院手續，則仍需依時繳交本院全數院費。</td> " +
			    "</tr> " +
			    "<tr> " +
			    "<td>&shy;2. 床位附加費</td> " +
			    "<td style='border-right-style: none'>$ ${resLivingFee}$</td> " +
			    "<td style='border-left-style: none'>&#47;月</td> " +
			    "<td></td> " +
			    "</tr> "+
				"</table> "+
			    "<br/>";
	
	String NURSING_FEE = "<table style='width:100%'>" +  
				"<col width='8%'/> " +
				"<col width='10%'/> " +
				"<col width='25%'/> " +
				"<col width='12%'/> " +
				"<col width='8%'/> " +
				"<col width='37%'/> " +
				"<tr style='text-align: center'> " +
			  	"<td rowspan='9'>B</td> " +
			  	"<td rowspan='9'>護<br/>理<br/>費</td> " +
			    "<td>收費項目</td> " +
			    "<td colspan='2'>收費</td> " +
			    "<td>內容說明</td> " +
			    "</tr><tr> " +
			    "<td>(A)基本護理</td> " +
			    "<td colspan='2'></td> " +
			    "<td colspan='2'></td> " +
			    "</tr> " +
			    "<tr> " +
			    "<td>自理</td> " +
			    "<td style='border-right-style: none'>${resLivingFee}$</td> " +
			    "<td style='border-left-style: none'>&#47;</td> " +
			    "<td></td> " +
			    "</tr> "+
			    "<tr>"+
			    "<td>低度護理</td> " +
			    "<td style='border-right-style: none'>$</td> " +
			    "<td style='border-left-style: none'>&#47;月</td> " +
			    "<td></td> " +
			    "</tr> "+
			    "<tr> " +
			    "<td>半護理</td> " +
			    "<td style='border-right-style: none'>$</td> " +
			    "<td style='border-left-style: none'>&#47;月</td> " +
			    "<td></td> " +
			    "</tr> "+
			    "<tr> " +
			    "<td>全護理</td> " +
			    "<td style='border-right-style: none'>$</td> " +
			    "<td style='border-left-style: none'>&#47;月</td> " +
			    "<td></td> " +
			    "</tr> "+
			    "<tr> " +
			    "<td colspan='4'>(B)特別護理項目</td> " +
			    "</tr> " +
			    "<tr> " +
			    "<td>1</td> " +
			    "<td style='border-right-style: none'>$</td> " +
			    "<td style='border-left-style: none'>&#47;月</td> " +
			    "<td></td> " +
			    "</tr> "+
			    "<tr> " +
			    "<td>2</td> " +
			    "<td style='border-right-style: none'>$</td> " +
			    "<td style='border-left-style: none'>&#47;月</td> " +
			    "<td></td> " +
			    "</tr> "+
				"</table> "+
			    "<br/>";
	
		String FIXED_FEE = "<table style='width:100%'>" +  
				"<col width='8%'/> " +
				"<col width='10%'/> " +
				"<col width='25%'/> " +
				"<col width='12%'/> " +
				"<col width='8%'/> " +
				"<col width='37%'/> " +
				"<tr style='text-align: center'> " +
			  	"<td rowspan='7'>C</td> " +
			  	"<td rowspan='7'>恆<br/>常<br/>收<br/>費</td> " +
			    "<td>收費項目</td> " +
			    "<td colspan='2'>收費標準</td> " +
			    "<td>內容說明</td> " +
			    "</tr>" +
			    "<tr>"+
			    "<td>尿片費 (包月)</td> " +
			    "<td style='border-right-style: none'>$</td> " +
			    "<td style='border-left-style: none'>&#47;月</td> " +
			    "<td></td> " +
			    "</tr> "+
			    "<tr> " +
			    "<td>冷氣費</td> " +
			    "<td style='border-right-style: none'>$</td> " +
			    "<td style='border-left-style: none'>&#47;月</td> " +
			    "<td>每年5-10月份收取冷氣費。</td> " +
			    "</tr> "+
			    "<tr> " +
			    "<td>電費</td> " +
			    "<td style='border-right-style: none'>$</td> " +
			    "<td style='border-left-style: none'>&#47;月</td> " +
			    "<td></td> " +
			    "</tr> "+
			    "<tr> " +
			    "<td>租借費用</td> " +
			    "<td style='border-right-style: none'>$</td> " +
			    "<td style='border-left-style: none'>&#47;月</td> " +
			    "<td></td> " +
			    "</tr> "+
			    "<tr> " +
			    "<td></td> " +
			    "<td style='border-right-style: none'>$</td> " +
			    "<td style='border-left-style: none'>&#47;月</td> " +
			    "<td></td> " +
			    "</tr> "+
			    "<tr> " +
			    "<td></td> " +
			    "<td style='border-right-style: none'>$</td> " +
			    "<td style='border-left-style: none'>&#47;月</td> " +
			    "<td></td> " +
			    "</tr> "+
				"</table> "+
			    "<br/>";
		
		String NON_FIXED_FEE = "<table style='width:100%'>" +  
				"<col width='8%'/> " +
				"<col width='10%'/> " +
				"<col width='25%'/> " +
				"<col width='12%'/> " +
				"<col width='8%'/> " +
				"<col width='37%'/> " +
			    "<tr> " +
			    "<td rowspan='2' style='text-align: center'>D</td> " +
			  	"<td rowspan='2' style='text-align: center'>非<br/>恆<br/>常<br/>收<br/>費</td> " +
			    "<td>活動費用</td> " +
			    "<td colspan='2'></td> " +
			    "<td>其他如外出旅遊、特別生日會、茶樓飲茶及一些特殊的醫護項目等收費活動，本院會提前以口頭或書面通知院友及家屬，由其自由選擇是否參予。</td> " +
			    "</tr> "+
			    "<tr> " +
			    "<td>什項費用</td> " +
			    "<td colspan='2'></td> " +
			    "<td>其他一般雜費可參考【主要雜費價目表】，費用以實報實銷形式計算。</td> " +
			    "</tr> "+
				"</table> ";
		
		String REMARKS_AND_STAMP = "<br/>&shy;&shy;&shy;註: 項目A, B, C將構成每月收費一部份 <br/><br/><br/>"+
		        "<table width='100%'>" +  
				"<col width='25%'/> " +
				"<col width='25%'/> " +
				"<col width='25%'/> " +
				"<col width='25%'/> " +
				"<tr>" + 
				"	<td style='border: none'>院舍代表姓名:<br/>&shy;</td>" + 
				"	<td style='border: none'>_______________<br/>&shy;</td>" +
				"	<td style='border: none'>院友/院友家屬姓名:<br/>&shy;</td>" + 
				"	<td style='border: none'>_______________<br/>&shy;</td>" + 
				"</tr>" +
				"<tr>" + 
				"	<td style='border: none'>簽署:<br/>&shy;</td>" + 
				"	<td style='border: none'>_______________<br/>&shy;</td>" + 
				"	<td style='border: none'>簽署:<br/>&shy;</td>" + 
				"	<td style='border: none'>_______________<br/>&shy;</td>" + 
				"</tr>" +
				"<tr>" + 
				"	<td style='border: none'>&shy;<br/>&shy;</td>" + 
				"	<td style='border: none'>&shy;<br/>&shy;</td>" + 
				"	<td style='border: none'>日期:<br/>&shy;</td>" + 
				"	<td style='border: none'>_______________<br/>&shy;</td>" + 
				"</tr>" +
				"</table>";
		
		String traPdfFile = "file\\org1001\\per100010\\pdf\\a.pdf";
		String headerAndInfo= HEADER_AND_INFO.replace("${logo}$", getImgTag("file\\org" + patGrpBean.getOrgId() + "\\logo\\img" + patGrpBean.getOrgId() + ".jpg",100)).replace("${perChiName}$", "aaa");
		PDFUtil.gen(patGrpBean.getOrgId(), traPdfFile, headerAndInfo+LIV_FEE+NURSING_FEE+FIXED_FEE+NON_FIXED_FEE+REMARKS_AND_STAMP);
		//String headerAndInfo = HEADER_AND_INFO;
		//String livFeeAndDeposite = LIV_FEE_AND_DEPOSITE;
		//resPdfFile = "file\\org1001\\per100010\\pdf\\a.pdf";
		//gen("A", "A", "A", "A", "A", resPdfFile, headerAndInfo+livFeeAndDeposite+nursing+REMARKS_AND_STAMP);		
	}
	
	
	public static void genQuitConfirmSlip(PatGrpBean patGrpBean) {
		/*
		TransBean transBean = patGrpBean.getTransBean();
		String perChiName = patGrpBean.getField("PER_CHI_NAME").getFormValue();
		String patId = patGrpBean.getField("PAT_ID").getFormValue();
		String traDate = transBean.getField("TRA_DATE").getFormValue();
		String traReceiptId = transBean.getField("TRA_RECEIPT_ID").getFormValue();
		String traType = EmsCommonUtil.getTraTypeWording(transBean.getField("TRA_TYPE").getFormValue());
		String traMethod = EmsCommonUtil.getTraMethodWording(transBean.getField("TRA_METHOD").getFormValue());
		String traNote = transBean.getField("TRA_NOTE").getFormValue();
		String traAmount = transBean.getField("TRA_AMOUNT").getFormValue();
		String traPdfFile = transBean.getField("TRA_PDF_FILE").getFormValue();
		*/
		/*
		System.out.println(perChiName);
		System.out.println(bedId);
		System.out.println(resStartDate);
		System.out.println(resLivingFee);
		System.out.println(traAmount);
		System.out.println(resPdfFile);
		String resPdfFile = "file\\org1001\\per100010\\pdf\\a.pdf";
		*/
		
		String HEADER_AND_INFO = "<table font-size: 36px; width:100%; height:60px'>" + 
				"<tr style='vertical-align: middle;'>" +
				"	<td style='border: none'>退院確認書</td>" + 
				"	<td style='border: none; text-align: right'>${logo}$</td>" + 
				"</tr>" + 
				"</table>" + 
				"<br/>" +
		        "<table width='100%'><tr><td style='border: 0px'>" +
				"<table width='600px'>" +  
				"<col width='25%'/> " +
				"<col width='25%'/> " +
				"<col width='25%'/> " +
				"<col width='25%'/> " +
				"<tr>" + 
				"	<td>院友編號:</td>" + 
				"	<td>${perChiName}$</td>" + 
				"	<td colspan='2' style='border: none'></td>" + 
				"</tr>" + 
				"<tr>" + 
				"	<td>院友姓名:</td>" + 
				"	<td>${bedFullName}$</td>" +
				"	<td colspan='2' style='border: none'></td>" + 
				"</tr>" + 
				"<tr>" + 
				"	<td>身份證號碼:</td>" + 
				"	<td>${resStartDate}$</td>" +
				"	<td colspan='2' style='border: none'></td>" + 
				"</tr>" +
				"</table><br/>"+
				"<table width='600px'>" +  
				"<col width='25%'/> " +
				"<col width='25%'/> " +
				"<col width='25%'/> " +
				"<col width='25%'/> " +
				"<tr>" + 
				"	<td>通知退院日期:</td>" + 
				"	<td>${resStartDate}$</td>" +
				"	<td>最後1天入住日期:</td>" + 
				"	<td>${resStartDate}$</td>" +
				"</tr>" +
				"</table>" +
				"</td></tr></table>" +
				"<br/>";
		
		String REMARKS = "有關院友的退院結算如下:<br/><br/>未繳款項:";
		
		String TRX_DETAIL_HEADER ="<table style='width:100%'>" +  
				"<col width='15%'/> " +
				"<col width='15%'/> " +
				"<col width='25%'/> " +
				"<col width='15%'/> " +
				"<col width='10%'/> " +
				"<col width='20%'/> " +
				"<tr style='background-color:LightSteelBlue'>" + 
				"	<td>日期</td>" + 
				"	<td>收費項目</td>" + 
				"	<td>備註</td>" + 
				"	<td>該付</td>" + 
				"	<td>己付</td>" + 
				"	<td style='text-align: right'>結餘</td>" + 
				"</tr>"; 
		String TRX_DETAIL_REC = 
				"<tr>" + 
				"	<td>${trxDate}$</td>" + 
				"	<td>${trxItem}$</td>" + 
				"	<td>${trxPayMethod}$</td>" + 
				"	<td>${trxRmarks}$</td>" + 
				"	<td>${trxRmarks}$</td>" + 
				"	<td style='text-align: right'>${trxAmount}$</td>" + 
				"</tr>";
		String TRX_DETAIL_TOTAL = "<tr>" + 
				"	<td style='border:none;' colspan='4'></td>" + 
				"	<td style='background-color:WhiteSmoke; text-align: right'>總結欠</td>" + 
				"	<td style='background-color:WhiteSmoke; text-align: right'>HK$ ${trxTotalAmount}$</td>" + 
				"</tr></table><br/><br/>";
		
		String STAMP = "<table width='100%'>" +  
				"<col width='25%'/> " +
				"<col width='25%'/> " +
				"<col width='25%'/> " +
				"<col width='25%'/> " +
				"<tr>" + 
				"	<td style='border: none'>支票金額:<br/>&shy;</td>" + 
				"	<td style='border: none'>_______________ <br/>&shy;</td>" +
				"	<td style='border: none'>支票日期:<br/>&shy;</td>" + 
				"	<td style='border: none'>_______________ <br/>&shy;</td>" +
				"</tr>" +
				"<tr>" + 
				"	<td style='border: none'>抬頭:<br/>&shy;</td>" + 
				"	<td style='border: none'>_______________ <br/>&shy;</td>" + 
				"	<td style='border: none'>支票銀行:<br/>&shy;</td>" + 
				"	<td style='border: none'>_______________ <br/>&shy;</td>" +
				"</tr>" +
				"<tr>" + 
				"	<td style='border: none'>支票號碼:<br/>&shy;</td>" + 
				"	<td style='border: none'>_______________ <br/>&shy;</td>" + 
				"	<td style='border: none' colspan='2'><br/>&shy;</td>" +
				"</tr>" +
				"</table><br/><br/>"+
				"<table width='100%'>" +  
				"<col width='25%'/> " +
				"<col width='25%'/> " +
				"<col width='25%'/> " +
				"<col width='25%'/> " +
				"<tr>" + 
				"	<td style='border: none'>主管/院長簽名:<br/>&shy;</td>" + 
				"	<td style='border: none'>_______________ <br/>&shy;</td>" +
				"	<td style='border: none'>簽收人簽署或指模:<br/>&shy;</td>" + 
				"	<td style='border: none'>_______________ <br/>&shy;</td>" + 
				"</tr>" +
				"<tr>" + 
				"	<td style='border: none' colspan='2'><br/>&shy;</td>" +
				"	<td style='border: none'>簽收人姓名:<br/>&shy;</td>" + 
				"	<td style='border: none'>_______________ <br/>&shy;</td>" + 
				"</tr>" +
				"<tr>" + 
				"	<td style='border: none'>日期:<br/>&shy;</td>" + 
				"	<td style='border: none'>_______________ <br/>&shy;</td>" + 
				"	<td style='border: none'>日期:<br/>&shy;</td>" + 
				"	<td style='border: none'>_______________ <br/>&shy;</td>" + 
				"</tr>" +
				"</table>";
		
		String traPdfFile = "file\\org1001\\per100010\\pdf\\a.pdf";
		String headerAndInfo= HEADER_AND_INFO.replace("${logo}$", getImgTag("file\\org" + patGrpBean.getOrgId() + "\\logo\\img" + patGrpBean.getOrgId() + ".jpg",100)).replace("${perChiName}$", "aaa");
		PDFUtil.gen(patGrpBean.getOrgId(), traPdfFile, headerAndInfo+REMARKS+TRX_DETAIL_HEADER+TRX_DETAIL_REC+TRX_DETAIL_TOTAL+STAMP);
		//String headerAndInfo = HEADER_AND_INFO;
		//String livFeeAndDeposite = LIV_FEE_AND_DEPOSITE;
		//resPdfFile = "file\\org1001\\per100010\\pdf\\a.pdf";
		//gen("A", "A", "A", "A", "A", resPdfFile, headerAndInfo+livFeeAndDeposite+nursing+REMARKS_AND_STAMP);		
	}
	// --------template end------- //
	
	public static void main(String [] args) {
		PatGrpBean patGrpBean = new PatGrpBean();
		patGrpBean.setOrgId("1001");
		//PDFUtil.gen("香港仔安老院", "GRANYET (ABERDEEN) ELDERLY CARE CENTRE", "香港仔田灣漁歌街5號xxxxxxxx","12345678", "11112222", "testing1234");
		//genDownPaymentSlip(null);
		//genDepositeSlip(null);
		//genReceiptSlip(null);
		//genResConfirmSlip(null);
		genStmtSlip(patGrpBean);
		//genLivConfirmSlip(patGrpBean);
		//genQuitConfirmSlip(patGrpBean);
	}
}
