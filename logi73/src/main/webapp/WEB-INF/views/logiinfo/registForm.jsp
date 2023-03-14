<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Insert title here</title>
<style>
	form{
		margin: 40px 450px;
	}
	td{
		color:black;
	}
	h3{
		color:black;
	}
	fieldset{
		margin:0;
		border: 1px solid white;
	}
		.card1 {
  		background-color: #FFFFFF !important;
  		border-radius: 10px;
	}
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
<script src="https://code.jquery.com/jquery-3.5.0.js"></script>
<script src="https://malsup.github.io/jquery.form.js"></script> 
<script>
   $(document).ready(function() {
      var todayTime = new Date();         
      var rrrr = todayTime.getFullYear();
      var mm = todayTime.getMonth()+1;
      var dd = todayTime.getDate();
      var today = rrrr+"-"+addZeros(mm,2)+"-"+addZeros(dd,2);
      console.log(today);
      $("#date").val(today);
      
      $("#registBoard").click(function(){
         $("#regist_board").submit();
      });
      
      $("#regist_board").ajaxForm({
         dataType: "json",
         success: function(data){ 
            alert(data.errorMsg);
            location.href = "/logiinfo/boardList/view";
         }
      });   
   });

   /* 날짜 자리수 맞춰주는 함수 */
   function addZeros(num, digit) {           
      var zero = '';
       num = num.toString();
       if (num.length < digit) {
          for (i = 0; i < digit - num.length; i++) {
           zero += '0';
          }
       }
       return zero + num;
   }
</script>
</head>
<body>
   <h3><small>&nbsp;</small></h3>
   <center>
      <form id="regist_board" class="" action="/compinfo/board?method=registerBoard" method="post" enctype="multipart/form-data">
         <div class="container wow fadeInDown card1">
         <h5>글쓰기</h5>
         <table class="c1">            
            <tr>   
               <td>이　　　름&nbsp;&nbsp;:&nbsp;&nbsp;&nbsp;&nbsp;
               <input type="text" name="name" value="${sessionScope.empName} ${sessionScope.positionName}">
            </tr>
            <tr>   
               <td>제　　　목&nbsp;&nbsp;:&nbsp;&nbsp;&nbsp;&nbsp;
               <input type="text" name="title" maxlength="20">
               </td>
            </tr>

            <tr>
               <td>작&nbsp;성&nbsp;일&nbsp;자&nbsp;&nbsp;&nbsp;:&nbsp;&nbsp;&nbsp;&nbsp;
               <input type="text" name="reg_date" style="width:137px;" id="date" value="${today}">
               </td>
            </tr>
            <tr>
               <td colspan="4">
                  <textarea cols="100" rows="15" name="content"></textarea>
               </td>


            </tr>
            <tr>
               <td colspan="4">
                  <input type="file"  name="uploadFile" style="margin-right:-80px;"/>
               </td>
            </tr>
            <tr>
               <td colspan="4">

                  <input type="button" class="button1" value="등&nbsp;&nbsp;록" id="registBoard">
                  <input type="reset" class="button2" value="취&nbsp;&nbsp;소">
                  <a href="/logiinfo/boardList/view" style=color:black>목록으로</a>
               </td>
            </tr>

         </table>
         <input type="hidden" name="board_seq" value="${param.board_seq}">
         </div>
      </form>
   </center>
</body>
</html>