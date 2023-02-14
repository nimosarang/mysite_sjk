<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8">
<link href="/mysite/assets/css/main.css" rel="stylesheet" type="text/css">
<title>Mysite</title>
</head>
<body>
	<div id="container">
		
		<c:import url="/WEB-INF/views/includes/header.jsp"></c:import>
		<c:import url="/WEB-INF/views/includes/navigation.jsp"></c:import>
		
		<div id="wrapper">
			<div id="content">
				<div id="site-introduction">
					<img style="width: 150px" id="profile" src="/mysite/assets/images/profile1.jpg">
					<h2>
						안녕?
						<br> ${authUser.name} 블로그에 어서와!<br/>
					</h2>
					<p>
						이 블로그는 웹 프로그램밍 실습과제 예제라구
						<br>
						메뉴: 사이트 소개, 방명록, 게시판이 있구요.
						<br>
						JAVA + 데이터베이스 + 웹프로그래밍 수업 내용도 있어요
						<br>
						<br>
						${authUser.name} <a href="/mysite/gb">방명록</a>에 글을 남겨볼까요~?
						<br>
					</p>
				</div>
			</div>
		</div>
		
		<c:import url="/WEB-INF/views/includes/footer.jsp"></c:import>
		
	</div>
</body>
</html>