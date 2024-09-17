
<%@ page import="java.io.File" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.UUID" %>
<%@ page import="org.apache.commons.fileupload2.core.DiskFileItemFactory" %>
<%@ page import="org.apache.commons.fileupload2.core.FileItem" %>
<%@ page import="java.nio.file.Paths" %>
<%@ page import="java.nio.charset.Charset" %>
<%@ page import="org.apache.commons.fileupload2.javax.JavaxServletFileUpload" %>


<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2024-09-16
  Time: 16:41
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
</head>
<body>
<%--<%--%>
<%--    request.setCharacterEncoding("UTF-8"); 			// 请求编码--%>
<%--    Scanner scan = new Scanner(request.getInputStream()) ; 	// 二进制数据--%>
<%--    while(scan.hasNext()) { 				// 迭代判断与输出--%>
<%--%>--%>
<%--<%=scan.next()%>--%>
<%--<% } %>--%>
<%!
    public static final long MAX_SIZE = 3145728L; 		// 最大上传数量为3M
    public static final long FILE_MAX_SIZE = 1048576L ; 	// 单个文件允许上传大小为1M
    public static final String TEMP_DIR = "/temp" ; 	// 设置临时目录
    public static final String UPLOAD_DIR = "/upload/" ; // 设置上传目录
    public static final String DEFAULT_ENCODING = "UTF-8" ; 	// 设置参数接收编码
%>
<%
    request.setCharacterEncoding(DEFAULT_ENCODING); 	// 请求编码
    DiskFileItemFactory factory = DiskFileItemFactory.builder().setPath(TEMP_DIR).get();	// 磁盘管理类
//    factory.setRepository(new File(TEMP_DIR)); 		// 设置临时存储目录
    JavaxServletFileUpload fileUpload = new JavaxServletFileUpload(factory); 	// 定义上传处理类
    fileUpload.setSizeMax(MAX_SIZE);    			// 设置允许上传总长度限制
    fileUpload.setFileSizeMax(FILE_MAX_SIZE); 		// 设置单个上传文件的大小限制
    if (fileUpload.isMultipartContent(request)) {   		// 判断当前的表单是否封装
    // FileUpload是对request操作的包装，所以此时需要解析所有的上传参数
    Map<String, List<FileItem>> map = fileUpload.parseParameterMap(request);
    for (Map.Entry<String,List<FileItem>> entry : map.entrySet()) { // 迭代上传项
        String paramName = entry.getKey(); 		// 获取请求参数的名称
        List<FileItem> allItems = entry.getValue();	// 获取请求参数的内容
%>
<p><%=paramName%>：
    <%
        for (FileItem item : allItems) {			// 获取参数内容
            if (item.isFormField()) {   			// 内容为普通文本
                String value = item.getString(Charset.defaultCharset()) ; 	// 参数接收
    %>
    <%=value%>
    <%
            } else {		// 表单未封装
               if (item.getSize() > 0) {			// 有上传的文件
                   String fileName = UUID.randomUUID() + "." + item.getContentType().substring(item.getContentType().lastIndexOf("/") + 1);
                   String filePath = application.getRealPath(UPLOAD_DIR) + fileName;
                   item.write(Paths.get(filePath)); 	// 文件存储
                   item.delete();			// 删除临时文件
    %>
    <img src="<%=request.getContextPath()%>/upload/<%=fileName%>" style="width:150px;">
    <%
               }
            }
        }
    %>
</p>
<%
    }
}
%>
</body>
</html>
