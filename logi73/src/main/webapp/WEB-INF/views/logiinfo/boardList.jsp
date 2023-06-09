<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="kr.co.seoulit.logistics.logiinfosvc.compinfo.to.BoardTO" %>
<%@ page import="kr.co.seoulit.logistics.logiinfosvc.compinfo.to.ListFormTO"%>
<%@ page import="java.util.ArrayList" %>
<c:set var="boardlist" value="${requestScope.boardlist}" />
<html>
<head>
<style type="text/css">
	td { font-size:0.8em; }
	.card1 { background-color: #FFFFFF !important; border-radius: 10px; }
	th{ font-weight: bold; }
	hr { height: 20px; background-color: #5D5D5D; }
	h3  { font-weight: bold; }
  	.content{ text-align:left;}
	.button1 {
		background-color: #506FA9;
		border: none;
		color: white;
		text-align: center;
		text-decoration: none;
		display: inline-block;
		font-size: 17px;
		border-radius: 3px;
		margin-bottom: 10px;
	}

	.button2 {
		background-color: #dc3170;
		border: none;
		color: white;
		text-align: center;
		text-decoration: none;
		display: inline-block;
		font-size: 17px;
		border-radius: 3px;
		margin-bottom: 10px;
	}

	.button3 {
		background-color: #506FA9;
		border: none;
		color: white;
		text-align: center;
		text-decoration: none;
		display: inline-block;
		font-size: 17px;
		padding-bottom: 4px;
		padding-top: 4px;
		border-radius: 3px;
		margin-bottom: 20px;
	}
	.button4 {
		background-color: #dc3170;
		border: none;
		color: white;
		text-align: center;
		text-decoration: none;
		display: inline-block;
		padding-bottom: 4px;
		padding-top: 4px;
		font-size: 17px;
		border-radius: 3px;
		margin-bottom: 10px;
	}
</style>
<!-- Bootstrap CSS -->
<%--<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.0/dist/css/bootstrap.min.css" --%>
<%--	integrity="sha384-GJzZqFGwb1QTTN6wy59ffF1BuGJpLSa9DkKMp0DgiMDm4iYMj70gZWKYbI706tWS" --%>
<%--	crossorigin="anonymous">--%>


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
		console.log("$$$$"+result);
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
	<h3><small>&nbsp;</small></h3>
	<div class="container wow fadeInDown">
		<div class="card1">
			<div class="card-body">
				<h3 class="display-10 text-dark font-weight-bold">게시판목록[${sessionScope.empName}${sessionScope.positionName}]
				</h3>
				<div class="col text-left">
				<div class="col col-sm-2 ">
					<select class="form-control" id="selectValue" onchange="reFindBoardList(this.value)">
					</select>
				</div>
				<h6><small>&nbsp;</small></h6>
				</div>
				<div class="table-responsive">
					<table class="table text-center table-striped table-bordered table-sm" id="dtBasicExample">
						<thead>
							<tr>
								<th class="th-sm font-weight-bold text-dark" width="15%">번호</th>
								<th class="th-sm font-weight-bold text-dark" width="40%">제목</th>
								<th class="th-sm font-weight-bold text-dark" width="15%">작성자</th>
								<th class="th-sm font-weight-bold text-dark" width="15%">작성일자</th>
								<th class="th-sm font-weight-bold text-dark" width="15%">조회수</th>
							</tr>
						</thead>
						<tbody id="tbody"></tbody>
					</table>
					<div id="page"></div>
				</div>
				<hr/>
				<div class="col text-right">
					<form action="/logiinfo/registForm/view">
						<input type="hidden" name="board_seq" value="0">
						<input class="btn btn-outline dark-text font-weight-bold text-dark" type="submit" value="글쓰기">
					</form>
				</div>
			</div>
		</div>
	</div>
</body>
</html>