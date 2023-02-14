<%@ page import="java.util.List" %>
<%@ page import="com.javaex.dao.BoardDao" %>
<%@ page import="com.javaex.dao.BoardDaoImpl" %>
<%@ page import="com.javaex.vo.BoardVo" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    request.setCharacterEncoding("UTF-8");

    int nowPage = 1; // 현재페이지

    BoardDao dao = new BoardDaoImpl();
    String strPg = request.getParameter("pg"); //list.jsp?pg=?

    int rowSize = 3; //한페이지에 보여줄 글의 수
    int pg = 1; //페이지 , list.jsp로 넘어온 경우 , 초기값 =1

    String keyWord = "", keyField = "";
    if (request.getParameter("keyWord") != null) {
        keyWord = request.getParameter("keyWord");
        keyField = request.getParameter("keyField");
    }

    if (request.getParameter("nowPage") != null) {
        nowPage = Integer.parseInt(request.getParameter("nowPage"));
    }

    if(strPg != null){ //list.jsp?pg=2
        pg = Integer.parseInt(strPg); //.저장
    }

    int from = (pg * rowSize) - (rowSize-1); //(1*3)-(3-1)=3-2=1 //from
    int to=(pg * rowSize); //(1*3) = 3 //to

    List<BoardVo> list = dao.getList(from, to, keyField, keyWord);

    int total = dao.getTotal(); //총 게시물 수
    int allPage = (int) Math.ceil(total/(double)rowSize); //페이지수
    int block = 3; //한페이지에 보여줄  범위 << [1] [2] [3] [4] [5] [6] [7] [8] [9] [10] >>

    System.out.println("전체 페이지수 : "+allPage);
    System.out.println("현재 페이지 : "+ strPg);


    int fromPage = ((pg-1)/block*block)+1;  //보여줄 페이지의 시작
    int toPage = ((pg-1)/block*block)+block; //보여줄 페이지의 끝
    if(toPage> allPage){ // 예) 20>17
        toPage = allPage;
    }


//    BoardDao paging = new BoardDaoImpl();
//    int total = paging.getTotal(); //총 게시물
//    int allPage = (int) Math.ceil(total / (double) numPerPage); //페이지수
//    int block = 3; //한페이지에 보여줄 범위 << [1] [2] [3] >>
//    int fromPage = ((nowPage - 1) / block * block) + 1; // 보여줄 페이지의 시작
//    int toPage = ((nowPage - 1) / block * block) + block; //보여줄 페이지의 끝
//    if (toPage > allPage) { //예 20>17
//        toPage = allPage;
//    }
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
            <%--				<form id="search_form" action="" method="post">--%>
            <%--					<input type="text" id="kwd" name="kwd" value="">--%>
            <%--					<input type="submit" value="찾기">--%>
            <%--				</form>--%>
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
                <table width="600">
                    <tr>
                        <td align="center">
                            <%
                                if (pg > block) { //처음, 이전 링크

                            %>
                            [<a href="list.jsp?pg=1">◀◀</a>]
                            [<a href="list.jsp?pg=<%=fromPage-1%>">◀</a>]
                            <%
                            } else {
                            %>
                            [<span style="color:gray">◀◀</span>]
                            [<span style="color:gray">◀</span>]
                            <%
                                }
                            %>


                            <%
                                for (int i = fromPage; i <= toPage; i++) {
                                    if (i == pg) {
                            %>
                            [<%=i%>]

                            <%
                            } else {
                            %>
                            [<a href="list.jsp?pg=<%=i%>"><%=i%>
                        </a>]
                            <%
                                    }
                                }

                            %>


                            <%
                                if (toPage < allPage) { //다음, 이후 링크

                            %>
                            [<a href="list.jsp?pg=<%=toPage+1%>">▶</a>]
                            [<a href="list.jsp?pg=<%=allPage%>">▶▶</a>]

                            <%
                            } else {
                            %>

                            [<span style="color:gray">▶</span>]
                            [<span style="color:gray">▶▶</span>]
                            <%
                                }
                            %>


                        </td>
                    </tr>
                </table>
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
		
