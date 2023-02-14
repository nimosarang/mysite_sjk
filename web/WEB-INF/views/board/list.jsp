<%@ page import="java.util.List" %>
<%@ page import="com.javaex.dao.BoardDao" %>
<%@ page import="com.javaex.dao.BoardDaoImpl" %>
<%@ page import="com.javaex.vo.BoardVo" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    request.setCharacterEncoding("UTF-8");

    int nowPage = 1; // 현재페이지

    String keyWord = "", keyField = "";
    if (request.getParameter("keyWord") != null) {
        keyWord = request.getParameter("keyWord");
        keyField = request.getParameter("keyField");
    }

    if (request.getParameter("nowPage") != null) {
        nowPage = Integer.parseInt(request.getParameter("nowPage"));
    }

%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8">
    <link href="/mysite/assets/css/board.css" rel="stylesheet" type="text/css">

    <script type="text/javascript">
        function list(page) {
            document.getElementsByName("nowPage")[0].value = page;
            document.getElementsByName("nowPage")[1].value = page;
            document.listFrm.action = "board";
            document.listFrm.submit();
        }

        function check() {
            document.searchFrm.action = "board";
            document.searchFrm.submit();
        }
    </script>

    <title>Mysite</title>
</head>
<body>
<div id="container">

    <c:import url="/WEB-INF/views/includes/header.jsp"></c:import>
    <c:import url="/WEB-INF/views/includes/navigation.jsp"></c:import>

    <div id="content">
        <div id="board">

            <table class="tbl-ex">
                <tr>
                    <th>번호</th>
                    <th>제목</th>
                    <th>글쓴이</th>
                    <th>조회수</th>
                    <th>작성일</th>
                    <th>&nbsp;</th>
                </tr>
                <c:forEach items="${list }" var="vo">
                    <tr>
                        <td>${vo.no }</td>
                        <td><a href="/mysite/board?a=read&no=${vo.no }">${vo.title }</a></td>
                        <td>${vo.userName }</td>
                        <td>${vo.hit }</td>
                        <td>${vo.regDate }</td>
                        <td>
                            <c:if test="${authUser.no == vo.userNo }">
                                <a href="/mysite/board?a=delete&no=${vo.no }" class="del">삭제</a>
                            </c:if>
                        </td>
                    </tr>
                </c:forEach>
            </table>

            <div class="pager">
                <c:import url="/WEB-INF/views/includes/paging.jsp"></c:import>

<%--                <ul>--%>
<%--                    <li><a href="">◀</a></li>--%>
<%--                    <li><a href="javascript:list('1')">1</a></li>--%>
<%--                    <li><a href="javascript:list('2')">2</a></li>--%>
<%--                    <li><a href="javascript:list('3')">3</a></li>--%>
<%--                    <li><a href="javascript:list('4')">4</a></li>--%>
<%--                    <li><a href="javascript:list('5')">5</a></li>--%>
<%--                    <li><a href="">▶</a></li>--%>
<%--                </ul>--%>
            </div>

            <form name="searchFrm" method="get">
                <table width="600">
                    <tr>
                        <td align="center" valign="bottom">
                            <select name="keyField" size="1">
                                <option value="name"> 이 름</option>
                                <option value="title"> 제 목</option>
                                <option value="content"> 내 용</option>
                            </select>
                            <input size="16" name="keyWord">
                            <input type="button" value="찾기" onClick="javascript:check()">
                            <input type="hidden" name="nowPage" value="1">
                            <input type="hidden" name="a" value="list">
                        </td>
                    </tr>
                </table>
            </form>
            <c:if test="${authUser != null }">
                <div class="bottom">
                    <a href="/mysite/board?a=writeform" id="new-book">글쓰기</a>
                </div>
            </c:if>
        </div>
    </div>
    <form name="listFrm" method="get">
        <input type="hidden" name="reload" value="true">
        <input type="hidden" name="a" value="list">
        <input type="hidden" name="nowPage" value="<%=nowPage%>">
        <input type="hidden" name="keyField" value="<%=keyField%>">
        <input type="hidden" name="keyWord" value="<%=keyWord%>">
    </form>
    <c:import url="/WEB-INF/views/includes/footer.jsp"></c:import>

</div><!-- /container -->
</body>
</html>		
		
