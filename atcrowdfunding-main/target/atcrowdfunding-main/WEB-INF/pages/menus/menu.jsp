<%--
  Created by IntelliJ IDEA.
  User: James Qiu
  Date: 2020/9/19
  Time: 23:38
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
            <div><a class="navbar-brand" style="font-size:32px;" href="#">众筹平台 - 许可维护</a></div>
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
                <div class="panel-heading"><i class="glyphicon glyphicon-th-list"></i> 权限菜单列表 <div style="float:right;cursor:pointer;" data-toggle="modal" data-target="#myModal"><i class="glyphicon glyphicon-question-sign"></i></div></div>
                <div class="panel-body">
                    <ul id="menuTree" class="ztree"></ul>
                </div>
            </div>
        </div>
    </div>
</div>


<%-- 新增子菜单的模态框 --%>
<div class="modal fade" id="addChildMenuModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="exampleModalLabel">新增菜单</h4>
            </div>
            <div class="modal-body">
                <form>
                    <%--  新增菜单的父菜单id通过隐藏域携带  --%>
                    <input type="hidden" name="pid">
                    <div class="form-group">
                        <label for="recipient-name" class="control-label">菜单名称:</label>
                        <input type="text" name="name" class="form-control" id="recipient-name">
                    </div>
                    <div class="form-group">
                        <label for="recipient-name" class="control-label">菜单图标:</label>
                        <input type="text" name="icon" class="form-control" id="recipient-name">
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
                <button type="button" id="addChildMenuModalBtn" class="btn btn-primary">提交</button>
            </div>
        </div>
    </div>
</div>


<%-- 更新菜单的模态框 --%>
<div class="modal fade" id="updateMenuModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="exampleModalLabel2">修改菜单</h4>
            </div>
            <div class="modal-body">
                <form>
                    <%--  新增菜单的父菜单id通过隐藏域携带  --%>
                    <input type="hidden" name="id">
                    <div class="form-group">
                        <label for="recipient-name" class="control-label">菜单名称:</label>
                        <input type="text" name="name" class="form-control" id="update-recipient-name">
                    </div>
                    <div class="form-group">
                        <label for="recipient-name" class="control-label">菜单图标:</label>
                        <input type="text" name="icon" class="form-control" id="update-recipient-icon">
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
                <button type="button" id="updateModalBtn" class="btn btn-primary">提交</button>
            </div>
        </div>
    </div>
</div>


<%@ include file="/WEB-INF/pages/include/base_js.jsp"%>

<script type="text/javascript">

    initZtree();
    function initZtree(){
        $.ajax({
            type:"get",
            url:"${PATH}/menu/getMenus",
            success:function (menus) {
                console.log(menus);
                //异步加载数据成功，解析菜单集合形成菜单树;
                menus.push({id:0 , name:"系统权限菜单",icon:"glyphicon glyphicon glyphicon-tasks"});
                var setting = {
                    view: {

                        addDiyDom: function(treeId , treeNode){
                            //treeNode:包含数据源数据()+ztree生成的属性(tId:当前树节点的id)
                            //console.log(treeNode);
                            $("#"+treeNode.tId+"_ico").remove();//移除当前树节点显示图标的span标签
                            $("#"+treeNode.tId+"_span").before("<span class='"+treeNode.icon+"'></span>");
                        },

                        addHoverDom: function(treeId, treeNode){
                            var aObj = $("#" + treeNode.tId + "_a"); // tId = permissionTree_1, ==> $("#permissionTree_1_a")
                            //aObj.attr("href", "javascript:;");
                            if (treeNode.editNameFlag || $("#btnGroup"+treeNode.tId).length>0) return;
                            var s = '<span id="btnGroup'+treeNode.tId+'">';
                            if ( treeNode.level == 0 ) {//根节点
                                //新增按钮
                                s += '<a onclick="addChildMenu('+treeNode.id+')" href="javascript:void(0)" class="btn btn-info dropdown-toggle btn-xs" style="margin-left:10px;padding-top:0px;" href="#" >&nbsp;&nbsp;<i class="fa fa-fw fa-plus rbg "></i></a>';
                            } else if ( treeNode.level == 1 ) {//枝节点
                                //更新按钮
                                s += '<a onclick="updateMenu('+treeNode.id+')" href="javascript:void(0)" class="btn btn-info dropdown-toggle btn-xs" style="margin-left:10px;padding-top:0px;"  href="#" title="修改权限信息">&nbsp;&nbsp;<i class="fa fa-fw fa-edit rbg "></i></a>';
                                if (treeNode.children.length == 0) {//如果TMenu类的子菜单集合的属性不是children需要修改为自己的属性
                                    //删除按钮
                                    s += '<a onclick="deleteMenu('+treeNode.id+')" href="javascript:void(0)" class="btn btn-info dropdown-toggle btn-xs" style="margin-left:10px;padding-top:0px;" href="#" >&nbsp;&nbsp;<i class="fa fa-fw fa-times rbg "></i></a>';
                                }
                                //新增按钮
                                s += '<a  onclick="addChildMenu('+treeNode.id+')" href="javascript:void(0)" class="btn btn-info dropdown-toggle btn-xs" style="margin-left:10px;padding-top:0px;" href="#" >&nbsp;&nbsp;<i class="fa fa-fw fa-plus rbg "></i></a>';
                            } else if ( treeNode.level == 2 ) {//叶子节点
                                //修改按钮
                                s += '<a onclick="updateMenu('+treeNode.id+')" href="javascript:void(0)" class="btn btn-info dropdown-toggle btn-xs" style="margin-left:10px;padding-top:0px;"  href="#" title="修改权限信息">&nbsp;&nbsp;<i class="fa fa-fw fa-edit rbg "></i></a>';
                                //删除按钮
                                s += '<a onclick="deleteMenu('+treeNode.id+')" href="javascript:void(0)" class="btn btn-info dropdown-toggle btn-xs" style="margin-left:10px;padding-top:0px;" href="#">&nbsp;&nbsp;<i class="fa fa-fw fa-times rbg "></i></a>';
                            }

                            s += '</span>';
                            aObj.after(s);
                        },
                        //鼠标离开树节点时的回调函数
                        removeHoverDom: function (treeId , treeNode) {
                            $("#btnGroup"+treeNode.tId).remove();
                        }
                    },
                    data: {
                        key: {
                            url: "asdasfasfsa"
                        },
                        simpleData: {
                            enable: true,
                            pIdKey: "pid" //数据源加载时，根据pid属性形成父子结构
                        }
                    }
                };

                var zNodes = menus;
                var $zTreeObj = $.fn.zTree.init($("#menuTree"), setting, zNodes);
                $zTreeObj.expandAll(true);
            }
        });
    }

    //新增子菜单
    function addChildMenu(id){
        //注意，这里取的是当前标签的id，但是这个id将作为新创建的标签的pid存储，这样新创建的标签就是当前标签的子标签了
        $("#addChildMenuModal form input[name='pid']").val(id);
        //显示新增模态框
        $("#addChildMenuModal").modal("show");
    }

    //为新增子菜单的模态框提交按钮绑定单击事件
    $("#addChildMenuModalBtn").click(function () {
        $.ajax({
            type:"post",
            url:"${PATH}/menu/addMenu",
            data:$("#addChildMenuModal form").serialize(),
            success:function (result) {
                if(result=="ok"){
                    //关闭模态框
                    $("#addChildMenuModal").modal("hide");
                    //刷新ztree树
                    initZtree();
                    layer.msg("新增菜单成功");
                }
            }
        });
    });


    //更新当前菜单
    function updateMenu(id){
        //为新增子菜单的模态框提交按钮绑定单击事件
        //注意，这里和新增子标签不一样，这取的是当前标签的id，赋给的修改的也是id的属性而不是pid，底层mapper也是根据此id去update的；
        $("#updateMenuModal form input[name='id']").val(id);
        $.ajax({
            type:"post",
            url:"${PATH}/menu/getMenu",
            data:{"id":id},
            success:function (result) {
                $("#update-recipient-name").val(result.name);
                $("#update-recipient-icon").val(result.icon);

                $("#updateMenuModal").modal("toggle");
            }
        });
    }
    //为修改的模态框的提交按钮绑定单击事件
    $("#updateModalBtn").click(function () {

        $.ajax({
            type:"post",
            url:"${PATH}/menu/updateMenu",
            data:$("#updateMenuModal form").serialize(),
            success:function (result) {
                if(result=="ok"){
                    $("#updateMenuModal").modal("toggle");
                    //刷新ztree树
                    initZtree();
                    layer.msg("修改菜单成功");
                }
                else{
                    $("#updateMenuModal").modal("toggle");
                    layer.msg(result.msg)
                }
            }
        });
    });


    //删除当前菜单
    function deleteMenu(id){
        layer.confirm("你确定要删除吗？",{icon:3},function () {
            $.ajax({
                type:"get",
                url:"${PATH}/menu/deleteMenu",
                data:{"id":id},
                success:function (result) {
                    if(result == "ok"){
                        layer.msg("删除成功");
                        initZtree();
                    }
                    else{
                        layer.msg(result.msg)
                    }
                }
            });
        })
    }



    //当前页面所在模块的菜单自动展开+模块标签高亮显示
    $(".list-group-item:contains(' 权限管理 ')").removeClass("tree-closed");
    $(".list-group-item:contains(' 权限管理 ') ul").show();   $(".list-group-item:contains(' 权限管理 ') li :contains('菜单维护')").css("color","red");
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
