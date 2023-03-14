<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%-- SimpleDateFormat --%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.min.css">
    <style type="text/css">
        .row {
            display: inline-block;
            margin: 50px ;
            width:1000px
        }
        h3 {
            text-align: left;
        }
    </style>
    <script type="text/javascript">
        var board=[];
        var selectValue=5;

        $(document).ready(function () {
            findBoardList(selectValue);

            for(var y=5; y<=20; y+=5){
                $("#selectValue").append($("<option/>").val(y).text(y+"개씩"));
            }
        });



        function findBoardList(selectValue){
            var html="";
            var page="1";
            var result=<%=request.getParameter("pn")%>;
            if(result != null){
                page=result;
            }
            $.ajax({
                method: "GET",
                url:"/compinfo/board/list",
                data: {
                    "method" : "selectBoardList",
                    "pn" : page,
                    "selectValue":selectValue},
                dataType:"json",
                success : function(data){
                    if(data.errorCode < 0){
                        var str = "내부 서버 오류가 발생했습니다\n";
                        str += "관리자에게 문의하세요\n";
                        str += "에러 위치 : " + $(this).attr("id");
                        str += "에러 메시지 : " + data.errorMsg;
                        alert(str);
                        return;
                    }

                    for (var index in data.boardlist){
                        var str="";
                        html += "<tr>";
                        html += "<td>"+data.boardlist[index].board_seq+"</td>";
                        if(data.boardlist[index].reply_level >1){
                            for(var i=1;i<data.boardlist[index].reply_level;i++){
                                str+="↳&nbsp&nbsp";
                            }
                        }
                        html += "<td class='content'>"+"<a href=/logiinfo/boardDetail/view?board_seq="+data.boardlist[index].board_seq+">"+str+data.boardlist[index].title+"</a>"+"</td>";
                        html += "<td>"+data.boardlist[index].name+"</td>";
                        html += "<td>"+data.boardlist[index].reg_date+"</td>";
                        html += "<td>"+data.boardlist[index].hit+"</td>";
                        html += "</tr>";
                    }
                    $("#tbody").empty();
                    $("#tbody").append(html);
                    board=data.board;
                    console.log(board);
                    makePage();
                }
            });
        }

        function makePage(){
            var html="";
            if(board.previous){
                html += "<a href=/logiinfo/boardList/view?pn="+(board.pagenum-1)+">&lt &lt </a>&nbsp&nbsp"
            }
            for(var num=board.startpage; num<(board.endpage)+1 ; num++){
                html += "<a href=/logiinfo/boardList/view?pn="+num+">"+num+"</a>&nbsp&nbsp";
            }
            if(board.next){
                html += "<a href=/logiinfo/boardList/view?pn="+(board.pagenum+1)+">&gt&gt</a>"
            }
            $("#page").empty();
            $("#page").append(html);
        }

        function reFindBoardList(selectValue){
            findBoardList(selectValue);
        }

    </script>
</head>
<body>
<div class="navbar-toggler">
    <div class="row">
        <h3>📅공지사항</h3>
        <table class="table table-striped">
            <tr class="notice_name">
                <th class="text-center" width=10%>번호</th>
                <th class="text-center" width=45%>제목</th>
                <th class="text-center" width=15%>이름</th>
                <th class="text-center" width=20%>작성일</th>
                <th class="text-center" width=10%>조회수</th>
            </tr>
            </thead>
            <tbody id="tbody" align="center"></tbody>
        </table>
        <table class="table" style="float: right">
            <tr>
                <td>
                    <a href="/logiinfo/registForm/view" class="btn btn-secondary btn-primary">글쓰기</a>
                </td>
            </tr>
        </table>
     <%--   <table class="table">
            <td class="text-center">
                <a href="#" class="btn btn-sm btn-primary">이전</a>
                ${curpage } page / ${totalpage } pages
                <a href="#" class="btn btn-sm btn-primary">다음</a>
            </td>
        </table>--%>

</div>
</body>
</html>
