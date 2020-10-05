<%--
  Created by IntelliJ IDEA.
  User: James Qiu
  Date: 2020/9/20
  Time: 16:45
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">

    <%@ include file="/WEB-INF/pages/include/base_css.jsp"%>
    <style>
        .tree li {
            list-style-type: none;
            cursor:pointer;
        }
    </style>
</head>

<body>

<nav class="navbar navbar-inverse navbar-fixed-top" role="navigation">
    <div class="container-fluid">
        <div class="navbar-header">
            <div><a class="navbar-brand" style="font-size:32px;" href="user.html">众筹平台 - 用户维护</a></div>
        </div>
        <%@ include file="/WEB-INF/pages/include/manager_loginbar.jsp"%>
    </div>
</nav>

<div class="container-fluid">
    <div class="row">
        <div class="col-sm-3 col-md-2 sidebar">
            <%@ include file="/WEB-INF/pages/include/manager_menu.jsp"%>
        </div>
        <div class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 main">
            <ol class="breadcrumb">
                <li><a href="#">首页</a></li>
                <li><a href="#">数据列表</a></li>
                <li class="active">分配角色</li>
            </ol>
            <div class="panel panel-default">
                <div class="panel-body">
                    <form role="form" class="form-inline">
                        <div class="form-group">
                            <label for="exampleInputPassword1">未分配角色列表</label><br>
                            <select id="unAssignedRolesSel" class="form-control" multiple size="10" style="width:400px;overflow-y:auto;">
                                <c:forEach items="${unassignedRoles}" var="temp">
                                    <option value="${temp.id}">${temp.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="form-group">
                            <ul>
                                <li id="assignRolesToAdmin" class="btn btn-default glyphicon glyphicon-chevron-right"></li>
                                <br>
                                <li id="unAssignRolesToAdmin" class="btn btn-default glyphicon glyphicon-chevron-left"  style="margin-top:20px;"></li>
                            </ul>
                        </div>
                        <div class="form-group" style="margin-left:40px;">
                            <label for="exampleInputPassword1">已分配角色列表</label><br>
                            <select id="assignedRolesSel" class="form-control" multiple size="10" style="width:400px;overflow-y:auto;">
                                <c:forEach items="${assignedRoles}" var="temp">
                                    <option value="${temp.id}">${temp.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>



<%@ include file="/WEB-INF/pages/include/base_js.jsp"%>
<script type="text/javascript">

    //分配角色按钮的单击事件
    $("#assignRolesToAdmin").click(function () {
        //发送请求分配角色： 管理员id和角色id集合参数
        var adminid = "${param.id}";
        var roleidsArr = new Array();
        $("#unAssignedRolesSel option:selected").each(function () {
            /*注意jQuery的选择器查出的是jQuery对象，这个对象是dom对象的集合；
            所以jQuery对象调用each()方法，遍历的是每个dom对象，获取dom对象的值使用.value*/
            var roleid = this.value;
            roleidsArr.push(roleid);
        });
        if(roleidsArr.length==0){
            layer.msg("请选择要分配的角色！！");
            return ;
        }
        var ids = roleidsArr.join();
        $.ajax({
            type:"post",
            url:"${PATH}/admin/assignRolesToAdmin",
            data:{"adminId":adminid , "roleIds":ids},
            success:function (result) {
                if(result=="ok"){
                    layer.msg("角色分配成功");
                    //通过dom操作将选中的option从未选中列表移到选中的列表中
                    $("#unAssignedRolesSel option:selected").appendTo("#assignedRolesSel");
                }
            }
        });
    });


    //取消已分配角色按钮的单击事件
    $("#unAssignRolesToAdmin").click(function () {
        var adminid = "${param.id}";
        var roleidsArr = new Array();
        $("#assignedRolesSel option:selected").each(function () {
            var roleid = this.value;
            roleidsArr.push(roleid);
        });
        if(roleidsArr.length==0){
            layer.msg("请选择要取消的已分配角色！！");
            return ;
        }
        var ids = roleidsArr.join();
        $.ajax({
            type:"post",
            url:"${PATH}/admin/unAssignRolesToAdmin",
            data:{"adminId":adminid , "roleIds":ids},
            success:function (result) {
                if(result=="ok"){
                    layer.msg("取消角色成功");
                    //通过dom操作将选中的option从未选中列表移到选中的列表中
                    $("#assignedRolesSel option:selected").appendTo("#unAssignedRolesSel");
                }
            }
        });
    });


    $(".list-group-item:contains(' 权限管理 ')").removeClass("tree-closed");
    $(".list-group-item:contains(' 权限管理 ') ul").show();
    $(".list-group-item:contains(' 权限管理 ') li :contains('用户维护')").css("color","red");
    $(function () {
        $(".list-group-item").click(function(){
            if ( $(this).find("ul") ) {
                $(this).toggleClass("tree-closed");
                if ( $(this).hasClass("tree-closed") ) {
                    $("ul", this).hide("fast");
                } else {
                    $("ul", this).show("fast");
                }
            }
        });
    });
</script>
</body>
</html>
