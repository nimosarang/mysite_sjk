<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8">
    <link href="/mysite/assets/css/board.css" rel="stylesheet" type="text/css">
    <title>Mysite</title>
</head>
<body>
<div id="container">

    <c:import url="/WEB-INF/views/includes/header.jsp"></c:import>
    <c:import url="/WEB-INF/views/includes/navigation.jsp"></c:import>

    <div id="content">
        <div id="board">

            <div class="pager">
                <ul>
                    <c:if test="${ curPageNum > 5 && !empty kwd }">
                        <li><a href="/mysite/board?page=${ blockStartNum - 1 }&kwd=${ kwd }">◀</a></li>
                    </c:if>

                    <c:if test="${ curPageNum > 5 }">
                        <li><a href="/mysite/board?page=${ blockStartNum - 1 }">◀</a></li>
                    </c:if>

                    <c:forEach var="i" begin="${ blockStartNum }" end="${ blockLastNum }">
                        <c:choose>
                            <c:when test="${ i > lastPageNum }">
                                <li>${ i }</li>
                            </c:when>
                            <c:when test="${ i == curPageNum }">
                                <li class="selected">${ i }</li>
                            </c:when>

                            <c:when test="${ !empty kwd}">
                                <li><a href="/mysite/board?a=search&page=${ i }&kwd=${ kwd }">${ i }</a></li>
                            </c:when>

                            <c:otherwise>
                                <li><a href="/mysite/board?page=${ i }">${ i }</a></li>
                            </c:otherwise>

                        </c:choose>
                    </c:forEach>

                    <c:if test="${ lastPageNum > blockLastNum && !empty kwd }">
                        <li><a href="/mysite/board?a=search&page=${ blockLastNum + 1 }&kwd=${ kwd }">▶</a></li>
                    </c:if>

                    <c:if test="${ lastPageNum > blockLastNum }">
                        <li><a href="/mysite/board?page=${ blockLastNum + 1 }">▶</a></li>
                    </c:if>

                </ul>

            </div>

            <%--				세션 정보가 있는 사람만 글쓰게 (로그인 한 사람만)--%>
            <c:if test="${authUser != null }">
                <div class="bottom">
                    <a href="/mysite/board?a=writeform" id="new-book">글쓰기</a>
                </div>
            </c:if>
        </div>
    </div>

    <c:import url="/WEB-INF/views/includes/footer.jsp"></c:import>

</div><!-- /container -->
</body>
</html>

