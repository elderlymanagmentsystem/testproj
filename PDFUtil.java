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

import ems.bean.StmtBean;

public class PDFUtil {
	private static ITextRenderer renderer = new ITextRenderer();
	private static String fontPath = EmsCommonUtil.getRuntimePath() + "font" + File.separator + "mingliu.ttf";
	private static String HTML_TAIL = "</body></html>";
	private static String HTML_HEAD = "<!DOCTYPE html><html><head><meta http-equiv='Content-Type' content='text/html; charset=UTF-8'/>"
			+ "<style>"
			+ " body { "
			+ "    font-family: MingLiU; "
			+ " } "
			+ "@page { margin: 12mm; "
			+ " @top-right { "
			+ "     font-family: MingLiU; "
			+ "     font-size: 12px; "
			+ "     vertical-align: text-top; "
			+ "     padding-top: 6mm; "
			+ "	    content: '頁 ' counter(page) '/' counter(pages);"
			+ " } "
			+ " @bottom-left { "
			+ " vertical-align: text-top; "
			+ "    font-family: MingLiU; "
			+ "    font-size: 12px; "
			+ "    white-space: pre-wrap;"
			+ "    content: '{orgChiName} {orgEngName}\\A地址: {orgChiAddr}'"
			+ " } "
			+ " @bottom-right { "
			+ "    font-family: MingLiU; "
			+ "    vertical-align: text-bottom; "
			+ "    white-space: pre-wrap;"
			+ "    font-size: 12px; "
			+ "    content: '\\A電話: {orgTel} 傳真: {orgFax}'"
			+ " } "
			+ "} "
			+ "table {border-collapse: collapse;} "
			+ "table td{border: 1px solid black;} "
			+ "</style>"
			+ "</head><body>";
	
	
	public static boolean gen(String orgChiName, String orgEngName, String orgChiAddr, String orgTel, String orgFax, String htmlContent) {
		if (orgChiName == null) orgChiName = "";
		if (orgEngName == null) orgEngName = "";
		if (orgChiAddr == null) orgChiAddr = "";
		if (orgTel == null) orgTel = "";
		if (orgFax == null) orgFax = "";
		if (htmlContent == null) htmlContent = "";
		String htmlHead = HTML_HEAD.replace("{orgChiName}", orgChiName).replace("{orgEngName}", orgEngName).replace("{orgChiAddr}", orgChiAddr).replace("{orgTel}", orgTel).replace("{orgFax}", orgFax);
		
		try
        {
			String outputFile = "C:\\Users\\patri\\Desktop\\a.pdf";
			OutputStream os = new FileOutputStream(outputFile);
			renderer.getFontResolver().addFont(fontPath, BaseFont.IDENTITY_H, BaseFont.NOT_EMBEDDED);
			renderer.setDocumentFromString(htmlHead+htmlContent+HTML_TAIL);
			renderer.layout();
			renderer.createPDF(os);
			os.close();
			
        }
        catch (Throwable t)
        {
            t.printStackTrace();
            return false;
        }
		return true;
    }
	
	public static String getImgTag(String path){
		return getImgTag(path, 0, 0);
	}
	
	public static String getImgTag(String path, int width, int height){
		FileInputStream fileInputStreamReader = null;
		try {
			File file = new File(EmsCommonUtil.getRuntimePath()+File.separator+"images"+File.separator+path);
			fileInputStreamReader = new FileInputStream(file);
			byte[] bytes = new byte[(int)file.length()];
			fileInputStreamReader.read(bytes);
			fileInputStreamReader.close();
			String temp = (width != 0 && height != 0) ? "' width='" + width + "' height='" + height + "'/>" : "'/>" ;
			return "<img src='data:image/jpg;base64, " + new String(Base64.encodeBytes(bytes)) + temp ;
		} catch (IOException e) {
			e.printStackTrace();
			return "";
		}
    }
	
	// --------template start------- //
	public static void genSTM(ArrayList<StmtBean> stmtBeanList) {
		String STM_HEADER = "<table style='border-bottom: 1pt solid black; font-size: 36px; width:100%; height:60px'>" + 
				"<tr style=\"vertical-align: top;\">" + 
				"	<td style=\"border: none\">訂金收據</td>" + 
				"	<td style=\"border: none\">logo</td>" + 
				"</tr>" + 
				"</table>" + 
				"<br/>";
		String STM_HEAD_DETAIL ="" +
				"<table width='300px'>" +  
				"<col width='50%'/> " +
				"<col width='50%'/> " +
				"<tr>" + 
				"	<td>院友姓名:</td>" + 
				"	<td>{perChiName}</td>" + 
				"</tr>" + 
				"<tr>" + 
				"	<td>收據日期:</td>" + 
				"	<td>{stmDate}</td>" + 
				"</tr>" + 
				"<tr>" + 
				"	<td>收據號碼:</td>" + 
				"	<td>{stmID}</td>" + 
				"</tr>" +
				"</table>" +
				"<br/><br/>";
		String STM_TRX_DETAIL_HEADER ="<table style='width:100%'>" +  
				"<col width='20%'/> " +
				"<col width='20%'/> " +
				"<col width='20%'/> " +
				"<col width='20%'/> " +
				"<col width='20%'/> " +
				"<tr style='background-color:LightBlue'>" + 
				"	<td>日期</td>" + 
				"	<td>帳項</td>" + 
				"	<td>繳費方法</td>" + 
				"	<td>備註</td>" + 
				"	<td>金額(港幣)</td>" + 
				"</tr>"; 
		String STM_TRX_DETAIL_FOOTER = "</table><br/><br/>";
				
		String STM_TRX_DETAIL_REC = 
				"<tr>" + 
				"	<td>{trxDate}</td>" + 
				"	<td>{trxItem}</td>" + 
				"	<td>{trxPayMethod}</td>" + 
				"	<td>{trxRmarks}</td>" + 
				"	<td>{trxAmount}</td>" + 
				"</tr>"; 
		
		String stmTrxDetail = STM_TRX_DETAIL_REC.replace("{trxDate}", "2019-01-01").replace("{trxItem}", "2019-01-01").replace("{trxPayMethod}", "2019-01-01").replace("{trxRmarks}", "2019-01-01").replace("{trxAmount}", "2019-01-01");
		
		
		String stmHeadDetail = STM_HEAD_DETAIL.replace("{perChiName}", "陳大文").replace("{stmDate}", "2019-01-01").replace("{stmID}", "STM100001");
		PDFUtil.gen("香港仔安老院", "GRANYET (ABERDEEN) ELDERLY CARE CENTRE", "香港仔田灣漁歌街5號xxxxxxxx","12345678", "11112222", STM_HEADER+stmHeadDetail+STM_TRX_DETAIL_HEADER+stmTrxDetail+STM_TRX_DETAIL_FOOTER);
	}
	// --------template end------- //
	
	public static void main(String [] args) {
		//PDFUtil.gen("香港仔安老院", "GRANYET (ABERDEEN) ELDERLY CARE CENTRE", "香港仔田灣漁歌街5號xxxxxxxx","12345678", "11112222", "testing1234");
		genSTM(null);
	}
}
