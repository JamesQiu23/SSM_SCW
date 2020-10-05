<%--
  Created by IntelliJ IDEA.
  User: James Qiu
  Date: 2020/9/17
  Time: 15:24
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <title>Title</title>
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
        table tbody tr:nth-child(odd){background:#F4F4F4;}
        table tbody td:nth-child(even){color:#C00;}
    </style>
</head>

<body>

<nav class="navbar navbar-inverse navbar-fixed-top" role="navigation">
    <div class="container-fluid">
        <div class="navbar-header">
            <div><a class="navbar-brand" style="font-size:32px;" href="#">众筹平台 - 角色维护</a></div>
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
            <div class="panel panel-default">
                <div class="panel-heading">
                    <h3 class="panel-title"><i class="glyphicon glyphicon-th"></i> 数据列表</h3>
                </div>
                <div class="panel-body">
                    <form class="form-inline" role="form" style="float:left;">
                        <div class="form-group has-feedback">
                            <div class="input-group">
                                <div class="input-group-addon">查询条件</div>
                                <input name="condition" class="form-control has-success" type="text" placeholder="请输入查询条件">
                            </div>
                        </div>
                        <button id="queryRolesBtn" type="button" class="btn btn-warning"><i class="glyphicon glyphicon-search"></i> 查询</button>
                    </form>
                    <button type="button" id="batchDelRolesBtn" class="btn btn-danger" style="float:right;margin-left:10px;"><i class=" glyphicon glyphicon-remove"></i> 删除</button>
                    <button type="button" id="showAddRoleModalBtn" class="btn btn-primary" style="float:right;"><i class="glyphicon glyphicon-plus"></i> 新增</button>
                    <br>
                    <hr style="clear:both;">
                    <div class="table-responsive">
                        <table class="table  table-bordered">

                            <thead>
                            <tr >
                                <th width="30">#</th>
                                <th width="30"><input type="checkbox"></th>
                                <th>名称</th>
                                <th width="100">操作</th>
                            </tr>
                            </thead>


                            <tbody>

                            </tbody>
                                <%--待动态创建角色标签--%>
                            <tfoot>
                            <tr >
                                <td colspan="6" align="center">
                                    <ul class="pagination">
                                        <%--待动态创建分页标签--%>
                                    </ul>
                                </td>
                            </tr>
                            </tfoot>


                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<%--新增角色的模态框--%>
<div class="modal fade" id="addRoleModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="exampleModalLabel">新增角色</h4>
            </div>
            <div class="modal-body">
                <form>
                    <div class="form-group">
                        <label for="recipient-name" class="control-label">角色名:</label>
                        <input name="roleName" type="text" class="form-control" id="recipient-name">
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
                <button type="button" id="addRoleBtn" class="btn btn-primary">点击新增</button>
            </div>
        </div>
    </div>
</div>


<%--修改角色的模态框--%>
<div class="modal fade" id="updateRoleModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="exampleModalLabel2">修改角色名</h4>
            </div>
            <div class="modal-body">
                <form>
                    <div class="form-group">
                        <label for="recipient-name" class="control-label">角色名:</label>
                        <input name="roleName" type="text" class="form-control" id="recipient-updateRoleName">
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
                <button type="button" id="updateRoleModalBtn" class="btn btn-primary">点击修改</button>
            </div>
        </div>
    </div>
</div>



<%@ include file="/WEB-INF/pages/include/base_js.jsp"%>
<script type="text/javascript">
    getRoles(1,"");//第一次跳到这页面时必然没有按条件，所有直接条件处为null；
    // 但是之后为每个跳页绑定的单击事件都会查一下条件输入框的内容再跳转到目标页数

    var pageNum;
    var condition;
    var updateRoleid;


    function getRoles(pageNum, condition){
        $("tbody").empty();
        $("tfoot ul").empty();
        $.ajax({
            url:"${PATH}/role/getRoles",
            type:"get",
            data:{"pageNum":pageNum,"condition":condition},
            success:function (pageInfo) {
                // console.log(pageInfo);
                initRoleList(pageInfo);
                initRoleNav(pageInfo);

                /*被后面的动态委派替代*/
                /*$(".navA").click(function () {
                    var pageNum = $(this).attr("pageNum");
                    getRoles(pageNum,"");
                });*/

                //为每个角色的修改按钮绑定单击事件
                $(".updateRoleBtn").click(function () {
                    updateRoleid = $(this).attr("roleid");
                    $.ajax({
                        type:"get",
                        url:"${PATH}/role/getRoleById",
                        data:{"id":updateRoleid},
                        success:function (result) {
                            $("#recipient-updateRoleName").val(result.name);
                            $("#updateRoleModal").modal("toggle");
                            }
                        });
                });
            }
        });
    }


    function initRoleList(pageInfo){
        /* $("<div>这是个动态创建的标签</div>").appendTo("body");*/
        $.each(pageInfo.list, function (index) {
            $('<tr>' +
                '<td>'+(index+1)+'</td>' +
                '<td><input roleid="'+this.id+'"  type="checkbox"></td>' +
                '<td>'+this.name+'</td>' +
                '<td>' +
                '<button roleid="'+this.id+'" type="button" class="btn btn-success btn-xs"><i class=" glyphicon glyphicon-check"></i></button>' +
                '<button roleid="'+this.id+'" type="button" class="btn btn-primary btn-xs updateRoleBtn"><i class=" glyphicon glyphicon-pencil"></i></button>' +
                '<button roleid="'+this.id+'" type="button" class="btn btn-danger btn-xs  deleteRoleBtn"><i class=" glyphicon glyphicon-remove"></i></button>' +
                '</td>' +
                '</tr>').appendTo("tbody");
        });

        //全选框带动复选框
        $("table thead :checkbox").click(function () {
            $("table tbody :checkbox").prop("checked",this.checked)
        });
        //全部的复选框带动全选
        $("table tbody :checkbox").click(function () {  //为bbdoy内的每个复选框都绑定单击事件
            var length = $("table tbody :checkbox").length;
            var beChecked = $("table tbody :checkbox:checked").length;
            $("table thead :checkbox").prop("checked",length==beChecked);
        });
    }

    function initRoleNav(pageInfo){
        /*上一页*/
        if(pageInfo.isFirstPage){
            $('<li class="disabled"><a href="javascript:void(0)">上一页</a></li>').appendTo("tfoot ul");
        }else{
            $('<li><a class="navA" pageNum="'+(pageInfo.pageNum-1)+'"  href="javascript:void(0)">上一页</a></li>').appendTo("tfoot ul");
        }
        /*中间页*/
        $.each(pageInfo.navigatepageNums, function () {
            if(pageInfo.pageNum == this){
                $('<li class="active"><a href="javascript:void(0)">'+this+'<span class="sr-only">(current)</span></a></li>').appendTo("tfoot ul");
            }else{
                $('<li><a class="navA" pageNum="'+this+'" href="javascript:void(0)">'+this+'</a></li>').appendTo("tfoot ul");
            }
        });
        /*下一页*/
        if(pageInfo.isLastPage){
            $('<li class="disabled"><a href="javascript:void(0)">下一页</a></li>').appendTo("tfoot ul");
        }else{
            $('<li><a class="navA" pageNum="'+(pageInfo.pageNum+1)+'"  href="javascript:void(0)">下一页</a></li>').appendTo("tfoot ul");
        }
    }

    $("tfoot").delegate(".navA","click",function () {
        pageNum = $(this).attr("pageNum");
        condition = $("input[name='condition']").val();
        getRoles(pageNum,condition); //每次点击跳转页面，都会想查那个框是否有内容，有则跳到带条件查询的那一页
    });

/*///////////////上////////////////////////*/
    //带条件查询点击的"查询按钮"，绑定单击事件
    $("#queryRolesBtn").click(function () {
        var condition = $("input[name='condition']").val();
        getRoles(1,condition)
    });


    $("tbody").delegate(".deleteRoleBtn","click",function () {
        var $tr = $(this).parents("tr");
        var roleid = $(this).attr("roleid");

        layer.confirm("确定要删除吗？",{title:"删除提示","icon":3}, function () {
            $.ajax({
                url:"${PATH}/role/delete",
                type:"get",
                data:{"id":roleid},
                success:function (result) {
                    if(result == "ok"){
                        layer.msg("删除成功");
                        $tr.remove();
                        //我加入这句是为了使每次删除后都从数据库再获取一次，并且留在当前页才能看到效果；
                        getRoles(pageNum,condition);
                    }
                }
            });
        })
    });


    $("#batchDelRolesBtn").click(function () {
        var $checkedList = $("table tbody :checkbox:checked");
        var checkedArray = new Array();
        $checkedList.each(function () {
            var thisAttr = $(this).attr("roleid");
            checkedArray.push(thisAttr);
        });

        layer.confirm("真的要删除选中的吗？", {icon:3}, function () {
            $.ajax({
                type:"get",
                url:"${PATH}/role/batchDelRoles",
                data:{"ids":checkedArray.join(",")},
                success:function (result) {
                    if(result == "ok"){
                        layer.msg("批量删除成功！");
                        getRoles(pageNum,condition);
                    }
                }
            });
        })
    });

    //为新增按钮设置调用显示模态框
    $("#showAddRoleModalBtn").click(function () {
        $("#addRoleModal").modal("toggle");
    });


    //为新增模态框的新增按钮设置点击事件
    $("#addRoleBtn").click(function () {
        var roleName = $("#recipient-name").val();
        $.ajax({
            type:"post",
            url:"${PATH}/role/addRole",
            data:{"name":roleName},
            success:function (result) {
                if(result == "ok"){
                    layer.msg("添加成功");
                    $("#addRoleModal").modal("toggle");
                    //添加后默认重新查找显示所有roles，并跳转到最后一页；
                    getRoles(10000,null);
                }
            }
        });
    });

    //为修改模态框的提交按钮绑定单击事件
    $("#updateRoleModalBtn").click(function () {
        var roleName = $("#recipient-updateRoleName").val();
        $.ajax({
            type:"post",
            url:"${PATH}/role/updateRole",
            data:{"id":updateRoleid ,"name":roleName},
            success:function (result) {
                if(result == "ok"){
                    layer.msg("修改成功");
                    $("#updateRoleModal").modal("toggle");
                    //添加后默认重新查找显示所有roles，并跳转到最后一页；
                    getRoles(pageNum,condition);
                }
            }
        });
    });



/*/////////////////下////////////////////////*/
    //当前页面所在模块的菜单自动展开+模块标签高亮显示
    $(".list-group-item:contains(' 权限管理 ')").removeClass("tree-closed");
    $(".list-group-item:contains(' 权限管理 ') ul").show();
    $(".list-group-item:contains(' 权限管理 ') li :contains('角色维护')").css("color","red");
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

    $("tbody .btn-success").click(function(){
        window.location.href = "assignPermission.html";
    });

</script>
</body>
</html>
