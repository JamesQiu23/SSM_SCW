<%--
  Created by IntelliJ IDEA.
  User: xugang2
  Date: 2020/9/13
  Time: 14:54
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<script src="jquery/jquery-2.1.1.min.js"></script>
<script src="bootstrap/js/bootstrap.min.js"></script>
<script src="script/docs.min.js"></script>
<script src="layer/layer.js"></script>
<script src="script/back-to-top.js"></script>
<script src="ztree/jquery.ztree.all-3.5.min.js"></script>


<script type="text/javascript">
    $("#logoutBtn").click(function () {
        layer.confirm("您确认退出吗?" , {"title":"注销提示:" , "icon":3},function () {
            <%--window.location.href = "${PATH}/admin/logout";--%>
            $("#logoutform").submit();
        })
    });
</script>