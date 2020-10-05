<%--
  Created by IntelliJ IDEA.
  User: James Qiu
  Date: 2020/9/14
  Time: 18:41
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<div class="tree">
    <ul style="padding-left:0px;" class="list-group">
        <c:forEach items="${sessionScope.pMenus}" var="temp">
            <c:choose>
                <c:when test="${empty temp.children}">
                    <li class="list-group-item tree-closed" >
                        <a href="${PATH}/${temp.url}"><i class="${temp.icon}"></i>${temp.name}</a>
                    </li>
                </c:when>
                <c:otherwise>
                    <li class="list-group-item tree-closed">
                        <span><i class="${temp.icon}"></i> ${temp.name} <span class="badge" style="float:right">${temp.children.size()}</span></span>
                        <ul style="margin-top:10px;display:none;">
                            <c:forEach items="${temp.children}" var="child">
                                <li style="height:30px;">
                                    <a href="${PATH}/${child.url}"><i class="${child.icon}"></i> ${child.name}</a>
                                </li>
                            </c:forEach>
                        </ul>
                    </li>
                </c:otherwise>
            </c:choose>
        </c:forEach>


    </ul>
</div>
