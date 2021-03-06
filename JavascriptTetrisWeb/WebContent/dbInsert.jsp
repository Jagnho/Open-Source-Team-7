<%@page import="store.util.JdbcUtils"%>
<%@page import="store.factory.ConnectionFactory"%>
<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>

<%
// 세션에 기록 저장
session.setAttribute("sName", request.getParameter("name"));
session.setAttribute("sScore", Integer.parseInt(request.getParameter("score")));

// DB에 기록 추가
	ConnectionFactory factory = ConnectionFactory.getInstance();
	
	Connection conn = null;
	PreparedStatement pstmt = null;
	int count = 0;
	
	try {
		conn = factory.createConnection();
	
		String sql = "insert into user_tb values(user_seq.nextval, ?, ?)";
		pstmt = conn.prepareStatement(sql);
		
		pstmt.setString(1, request.getParameter("name"));
		pstmt.setInt(2, Integer.parseInt(request.getParameter("score")));
		
		count = pstmt.executeUpdate();
		
	} catch (SQLException e) {
		e.printStackTrace();
	
	} finally {
		JdbcUtils.close(pstmt, conn);
	}
%>

