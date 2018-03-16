<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8"%>
<html>
<head>
    <script>
        //初始化下拉框
        $('#select_product_category').selectpicker('refresh');

        /******
         * event
         ******/
        //点击查询按钮时
        $("#btn_product_submit").click(function () {
            var product_name = $.trim($("#input_product_name").val());
            var category_id = $("#select_product_category").val();
            //产品状态数组
            var status_array = [];
            $(".radio_isEnabled:checked").each(function () {
                status_array.push($(this).val());
            });
            var lowest_price = $.trim($("#input_product_sale_place").val());
            var highest_price = $.trim($("#input_product_place").val());
            //校验数据合法性
            if((lowest_price !== "" && isNaN(lowest_price)) || (highest_price !== "" && isNaN(highest_price))){
                styleUtil.errorShow($('#text_product_msg'),"产品金额格式有误！");
                return;
            }
            var url = "admin/product/search";
            if(product_name === "" && category_id == 0 && (status_array.length <= 0 || status_array.length >= 3) && lowest_price === "" && highest_price === "") {
                url = "admin/product/searchAll";
            }
            //ajax请求数据
            $.ajax({
                url: url,
                type:"get",
                data: {
                    "product_name":encodeURI(product_name),
                    "product_category.category_id":category_id,
                    "product_sale_price":lowest_price,
                    "product_price":highest_price,
                    "product_isEnabled_array":status_array
                },
                traditional:true,
                success : function (data) {
                    $("#btn_product_submit").val("查询");
                    var table = $("#table_product_list");
                    var tbody = table.children("tbody").first();
                    //清空原有数据
                    tbody.empty();
                    if(data.productList.length>0){
                        for(var i in data.productList){
                            var isEnabledClass;
                            var isEnabled;
                            switch (data.productList[i].product_isEnabled){
                                case 0:
                                    isEnabledClass = "td_success";
                                    isEnabled = "销售中";
                                    break;
                                case 2:
                                    isEnabledClass = "td_warn";
                                    isEnabled = "促销中";
                                    break;
                                default:
                                    isEnabledClass = "td_error";
                                    isEnabled = "停售中";
                                    break;
                            }
                            var product_price = data.productList[i].product_price.toFixed(1);
                            var product_sale_price = data.productList[i].product_sale_price.toFixed(1);
                            var product_id = data.productList[i].product_id;
                            var product_name = data.productList[i].product_name;
                            var product_title = data.productList[i].product_title;
                            var product_create_date = data.productList[i].product_create_date;
                            //显示产品数据
                            tbody.append("<tr><td><input type='checkbox' class='cbx_select' id='cbx_product_select_"+product_id+"'><label for='cbx_product_select_"+product_id+"'></label></td><td>"+product_name+"</td><td>"+product_title+"</td><td>"+product_price+"</td><td>"+product_sale_price+"</td><td>"+product_create_date+"<td><span class='"+isEnabledClass+"'>"+isEnabled+"</span></td><td><span class='td_special'><a href='#'>详情</a></span></td><td hidden>"+product_id+"</td></tr>");
                            //显示产品统计数据
                            $(".data_count_value").first().text(data.productCount);
                        }
                    }
                },
                beforeSend: function () {
                    $("#btn_product_submit").val("查询中...");
                },
                error: function () {

                }
            });
        });
        //点击刷新按钮时
        $("#btn_product_refresh").click(function () {
            //ajax请求数据
            $.ajax({
                url: "admin/product/searchAll",
                type: "get",
                data: null,
                success: function (data) {
                    $("#btn_product_refresh").val("刷新产品列表");
                    var table = $("#table_product_list");
                    var tbody = table.children("tbody").first();
                    //清空原有数据
                    tbody.empty();
                    if (data.productList.length > 0) {
                        for (var i in data.productList) {
                            var isEnabledClass;
                            var isEnabled;
                            switch (data.productList[i].product_isEnabled) {
                                case 0:
                                    isEnabledClass = "td_success";
                                    isEnabled = "销售中";
                                    break;
                                case 2:
                                    isEnabledClass = "td_warn";
                                    isEnabled = "促销中";
                                    break;
                                default:
                                    isEnabledClass = "td_error";
                                    isEnabled = "停售中";
                                    break;
                            }
                            var product_price = data.productList[i].product_price.toFixed(1);
                            var product_sale_price = data.productList[i].product_sale_price.toFixed(1);
                            var product_id = data.productList[i].product_id;
                            var product_name = data.productList[i].product_name;
                            var product_title = data.productList[i].product_title;
                            var product_create_date = data.productList[i].product_create_date;
                            //显示产品数据
                            tbody.append("<tr><td><input type='checkbox' class='cbx_select' id='cbx_product_select_" + product_id + "'><label for='cbx_product_select_" + product_id + "'></label></td><td>" + product_name + "</td><td>" + product_title + "</td><td>" + product_price + "</td><td>" + product_sale_price + "</td><td>" + product_create_date + "<td><span class='" + isEnabledClass + "'>" + isEnabled + "</span></td><td><span class='td_special'><a href='#'>详情</a></span></td><td hidden>" + product_id + "</td></tr>");
                            //显示产品统计数据
                            $(".data_count_value").first().text(data.productCount);
                        }
                    }
                },
                beforeSend: function () {
                    $("#btn_product_refresh").val("刷新列表中...");
                },
                error: function () {

                }
            });
        });
    </script>
    <style rel="stylesheet">
        #text_cut{
            position: relative;
            right: 10px;
            color: #ccc;
        }
        #lbl_product_isEnabled_special{
            margin: 0 20px 0 0;
        }
        .bootstrap-select:not([class*=col-]):not([class*=form-control]):not(.input-group-btn){
            width: 150px;
        }
    </style>
</head>
<body>
<div class="frm_div text_info">
    <form id="form_product" class="form_main">
        <div class="frm_group">
            <label class="frm_label" id="lbl_product_name" for="input_product_name">产品名称</label>
            <input class="frm_input" id="input_product_name" type="text" maxlength="50"/>
            <label class="frm_label" id="lbl_product_category_id" for="select_product_category">产品类型</label>
            <select class="selectpicker" id="select_product_category" data-size="8">
                <option value="0">全部</option>
                <c:forEach items="${requestScope.categoryList}" var="category">
                    <option value="${category.category_id}">${category.category_name}</option>
                </c:forEach>
            </select>
            <span class="frm_error_msg" id="text_product_msg"></span>
        </div>
        <div class="frm_group">
            <label class="frm_label" id="lbl_product_isEnabled" for="checkbox_product_isEnabled_true">产品状态</label>
            <input class="frm_radio radio_isEnabled" id="checkbox_product_isEnabled_true" name="checkbox_product_isEnabled" type="checkbox" value="0" checked>
            <label class="frm_label" id="lbl_product_isEnabled_true" for="checkbox_product_isEnabled_true">销售中</label>
            <input class="frm_radio radio_isEnabled" id="checkbox_product_isEnabled_false" name="checkbox_product_isEnabled" type="checkbox" value="1" checked>
            <label class="frm_label" id="lbl_product_isEnabled_false" for="checkbox_product_isEnabled_false">停售中</label>
            <input class="frm_radio radio_isEnabled" id="checkbox_product_isEnabled_special" name="checkbox_product_isEnabled" type="checkbox" value="2" checked>
            <label class="frm_label" id="lbl_product_isEnabled_special" for="checkbox_product_isEnabled_special">促销中</label>

            <label class="frm_label"  id="lbl_product_sale_place" for="input_product_sale_place">金额</label>
            <input class="frm_input frm_num"  id="input_product_sale_place" type="text" placeholder="最低价" maxlength="10">
            <span id="text_cut">—</span>
            <input class="frm_input frm_num"  id="input_product_place" type="text" placeholder="最高价" maxlength="10">

            <input class="frm_btn" id="btn_product_submit" type="button" value="查询"/>
            <input class="frm_btn frm_clear" id="btn_clear" type="button" value="重置"/>
        </div>
        <div class="frm_group_last">
            <input class="frm_btn frm_add" id="btn_product_add" type="button" value="添加一件产品"/>
            <input class="frm_btn frm_refresh" id="btn_product_refresh" type="button" value="刷新产品列表"/>
            <span class="frm_error_msg" id="text_tools_msg"></span>
        </div>
    </form>
</div>
<div class="data_count_div text_info">
    <svg class="icon" viewBox="0 0 1024 1024" version="1.1" xmlns="http://www.w3.org/2000/svg" p-id="2522">
            <path d="M401.976676 735.74897c-88.721671 0-172.124196-34.635845-234.843656-97.526197-62.724577-62.86784-97.271394-146.453537-97.271394-235.358379s34.546817-172.490539 97.276511-235.361449c62.715367-62.887282 146.117892-97.522104 234.838539-97.522104 88.719624 0 172.135452 34.633798 234.881518 97.522104 62.704111 62.875003 97.235578 146.4607 97.235578 235.361449 0 88.901773-34.530444 172.487469-97.231485 235.358379C574.112128 701.116195 490.6963 735.74897 401.976676 735.74897zM401.976676 121.204479c-75.012438 0-145.533584 29.290093-198.572568 82.474386-109.585861 109.834524-109.585861 288.539602-0.004093 398.36901 53.043077 53.188386 123.564223 82.47848 198.577684 82.47848 75.015507 0 145.553027-29.291117 198.620663-82.47848C710.126918 492.220514 710.126918 313.511343 600.593246 203.678866 547.530726 150.496619 476.992183 121.204479 401.976676 121.204479z" p-id="2523" fill="#FF7874">
            </path>
            <path d="M932.538427 958.228017c-6.565533 0-13.129019-2.508123-18.132986-7.52437L606.670661 642.206504c-9.989515-10.014074-9.969049-26.231431 0.045025-36.220946s26.230408-9.969049 36.220946 0.045025l307.73478 308.497143c9.989515 10.014074 9.969049 26.231431-0.045025 36.220946C945.627537 955.735244 939.081447 958.228017 932.538427 958.228017z" p-id="2524">
            </path>
        </svg>
    <span class="data_count_title">查看合计</span>
    <span>产品总数:</span>
    <span class="data_count_value">${requestScope.productCount}</span>
    <span class="data_count_unit">件</span>
</div>
<table class="table_normal" id="table_product_list">
    <thead>
    <tr>
        <th><input type="checkbox" class="cbx_select" id="cbx_select_all"><label for="cbx_select_all"></label></th>
        <th>产品名称</th>
        <th>产品标题</th>
        <th>原价</th>
        <th>促销价</th>
        <th>创建时间</th>
        <th>上架状态</th>
        <th>操作</th>
        <th hidden>产品ID</th>
    </tr>
    </thead>
    <tbody>
    <c:forEach items="${requestScope.productList}" var="product">
        <tr>
            <td><input type="checkbox" class="cbx_select" id="cbx_product_select_${product.product_id}"><label for="cbx_product_select_${product.product_id}"></label></td>
            <td>${product.product_name}</td>
            <td>${product.product_title}</td>
            <td>${product.product_price}</td>
            <td>${product.product_sale_price}</td>
            <td>${product.product_create_date}</td>
            <td>
                <c:choose>
                    <c:when test="${product.product_isEnabled==0}"><span class="td_success">销售中</span></c:when>
                    <c:when test="${product.product_isEnabled==2}"><span class="td_warn">促销中</span></c:when>
                    <c:otherwise><span class="td_error">停售中</span></c:otherwise>
                </c:choose>
            </td>
            <td><span class="td_special"><a href="#">详情</a></span></td>
            <td hidden><span class="product_id">${product.product_id}</span></td>
        </tr>
    </c:forEach>
    </tbody>
</table>
</body>
</html>
