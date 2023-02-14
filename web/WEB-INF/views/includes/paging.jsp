<%@ page import="com.javaex.dao.BoardDao" %>
<%@ page import="java.util.List" %>
<%@ page import="com.javaex.dao.BoardDaoImpl" %>
<%@ page import="com.javaex.vo.BoardVo" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    BoardDao dao = new BoardDaoImpl();
    String strPg = request.getParameter("reload=true&a=list&nowPage"); //board? reload=true&a=list&nowPage

    int rowSize = 5; //한페이지에 보여줄 글의 수
    int nowPage = 1; //페이지 , list.jsp로 넘어온 경우 , 초기값 =1

    if (strPg != null) { //board? reload=true&a=list&nowPage=2
        nowPage = Integer.parseInt(strPg); //.저장
    }

    int from = (nowPage * rowSize) - (rowSize - 1); //(1*5)-(5-1) = 5-4 = 1 //from
    int to = (nowPage * rowSize); // (1 * 5 ) = 5 //to

    String keyField = request.getParameter("keyField");
    String keyWord = request.getParameter("keyWord");

    if (request.getParameter("nowPage") != null) {
        nowPage = Integer.parseInt(request.getParameter("nowPage"));
    }

    List<BoardVo> list = dao.getList(from, to, keyField, keyWord);

    int total = dao.getTotal(); //총 게시물 수
    int allPage = (int) Math.ceil(total / (double) rowSize); //페이지수
    int block = 5; //한페이지에 보여줄  범위 << [1] [2] [3] [4] [5] >>

    System.out.println("전체 페이지수 : " + allPage);
    System.out.println("현제 페이지 : " + strPg);

    int fromPage = ((nowPage - 1) / block * block) + 1;  //보여줄 페이지의 시작
    int toPage = ((nowPage - 1) / block * block) + block; //보여줄 페이지의 끝
    if (toPage > allPage) { // 예) 20>17
        toPage = allPage;
    }
    System.out.println("페이지시작 : " + fromPage + " / 페이지 끝 :" + toPage);
%>
<html>
<head>
    <title>Title</title>
</head>
<body>
<table width="600">
    <tr>
        <td align="center">
            <%
                if (nowPage > block) { //처음, 이전 링크
            %>
            [<a href="board?reload=true&a=list&nowPage=1">◀◀</a>]
            [<a href="board?reload=true&a=list&nowPage=<%=fromPage-1%>">◀</a>]
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
                    if (i == nowPage) {
            %>
            [<%=i%>]
            <%
            } else {
            %>
            [<a href="board?reload=true&a=list&nowPage=<%=i%>"><%=i%>
        </a>]
            <%
                    }
                }
            %>
            <%
                if (toPage < allPage) { //다음, 이후 링크
            %>
            [<a href="board?reload=true&a=list&nowPage=<%=toPage+1%>">▶</a>]
            [<a href="board?reload=true&a=list&nowPage=<%=allPage%>">▶▶</a>]

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

</body>
</html>
