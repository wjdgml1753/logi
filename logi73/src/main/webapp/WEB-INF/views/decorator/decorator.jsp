<%-- <알아두기>
     id는 #, class 는 .
--%>

<!-- java의 import 같은 느낌-->
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%> <!--html 의 인코딩을 utf-8로 하겠다-->
<%@ taglib prefix="decorator" uri="http://www.opensymphony.com/sitemesh/decorator"%> <!--JSTL문법. decorator 라이브러리를 쓸 경우 많이쓴다-->
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%> <!-- JSTL문법. core 라이브러리를 쓸 경우 많이쓴다-->

<!doctype html>

<html>
<head>
    <title>jeonghee_logi</title>
    <meta charset="utf-8"> <!--<meta> 태그는 해당 문서에 대한 정보인 메타데이터(metadata)를 정의할 때 사용합니다.-->
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <link rel="preconnect" href="https://fonts.gstatic.com"> <!--<link> 태그의 rel 속성은 현재 문서와 외부 리소스 사이의 연관 관계를 명시합니다.-->
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@500&display=swap" rel="stylesheet"> <!--스타일 시트(stylesheet)로 사용할 외부 리소스를 불러옴(폰트).-->
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css"><!--스타일 시트(stylesheet)로 사용할 외부 리소스를 불러옴(font-awesome.min.css).-->
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@10"></script> <!-- 이쁜 알림창 SWEET ALERT 사용하기위한 선언 -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"> <!--스타일 시트(stylesheet)로 사용할 내부(css폴더) 리소스를 불러옴.-->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.min.css"> <!--스타일 시트(stylesheet)로 사용할 (css폴더) 리소스를 불러옴(부트스트랩).-->
    <script src="${pageContext.request.contextPath}/js/jquery-3.3.1.min.js"></script> <!-- 내부라이브러리(js) 사용을 위한 선언.j쿼리 -->
    <script src="${pageContext.request.contextPath}/js/popper.js"></script><!-- 내부라이브러리(js) 사용을 위한 선언.popper-->
    <script src="${pageContext.request.contextPath}/js/bootstrap.min.js"></script><!-- 내부라이브러리(js) 사용을 위한 선언.부트스트랩 -->

    <script src="https://unpkg.com/ag-grid-community/dist/ag-grid-community.min.noStyle.js"></script>
    <!-- Include the core CSS, this is needed by the grid -->
    <link rel="stylesheet" href="https://unpkg.com/ag-grid-community/styles/ag-grid.css"/>
    <!-- Include the theme CSS, only need to import the theme you are going to use -->
    <link rel="stylesheet" href="https://unpkg.com/ag-grid-community/styles/ag-theme-alpine.css"/>
    <link rel="stylesheet" href="https://unpkg.com/ag-grid-community/dist/styles/ag-theme-balham.css" />

    <!-- 선택된요소에 우선 순위가 지정된 font family 이름과 generic family 이름을 지정할 수 있게 해줌 -->
    <!--아래여백 15px 고정 -->
    <style type="text/css">
        h5 {font-family: 'Noto Sans KR', sans-serif;}
        .img {margin-bottom: 15px !important;}
    </style>


    <!--사이트매쉬사용. 요청한 페이지의 헤드부분은 다 여기 삽임됨 -->
    <sitemesh:write property='head'/>
</head>

<body>

<!-- 세션 아이디가 있을때 -->
<c:if test="${sessionID != null }">

    <div class="wrapper d-flex align-items-stretch">

        <!--<nav> 태그는 다른 페이지 또는 현재 페이지의 다른 부분과 연결되는 네비게이션 링크(navigation links)들의 집합을 정의할 때 사용-->
        <nav id="sidebar">

            <div class="p-4 pt-5">
                <a href="/hello3/view" class="img logo rounded-circle mb-5" style="background-image: url('${pageContext.request.contextPath}${sessionScope.image}');"></a>
                <p style="text-align: center"> 💼 ${sessionScope.empName} ${sessionScope.positionName}님 환영합니다.</p>

                <!--모든 메뉴 셋팅-->
                <div> ${sessionScope.allMenuList} </div>

                <div class="footer">

                    <!--<p></p> 태그는 paragraph, 즉 문단의 약자로, 하나의 문단을 만들 때 쓰입니다.-->
                    <p>서울특별시 강서구 양천로 47길 12
                        <br/>마곡보타닉 투웨니퍼스트
                    </p>

                    <p>Tel : 010 - 4804 - 1753
                        <br/>Email : wjdgml1753@naver.com
                    </p>

                    <br>

                </div>


                <!-- Weather widget by https://meteodays.com 날씨위젯 시작-->
                <a id="ms-informer-link-fd537d57dcc6e80e7fb99569c5c67f22" class="ms-informer-link" href="https://meteodays.com/ko/weather/overview/chinju">진주시 날씨</a>
                <script class="ms-informer-script" src="https://meteodays.com/ko/informer/script/fd537d57dcc6e80e7fb99569c5c67f22"></script>
                <!-- 날씨 위젯 끝 -->

            </div>
        </nav>

        <!-- Page Content  -->
        <div id="content" class="p-1 p-md-3">
                ${sessionScope.allMenuList_b}
            <nav class="navbar navbar-expand-sm navbar-light bg-light">
                <div class="container-fluid">

                    <!--ㅁ-->
                    <button type="button" id="sidebarCollapse" class="btn btn-primary">
                        <i class="fa fa-bars"></i>
                        <span class="sr-only">Toggle Menu</span>
                    </button>

                    <!-- 메뉴 토글 버튼  -->
                    <button class="btn btn-dark d-inline-block d-lg-none ml-auto" type="button" data-toggle="collapse" data-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
                        <i class="fa fa-bars"></i>
                    </button>

                    <!-- nav 메뉴 -->
                    <div class="collapse navbar-collapse" id="navbarSupportedContent">
                            ${sessionScope.navMenuList}
                    </div>

                    <!--nav link(서브네임 등 있는곳)-->
                    <div class="navbar-header">
                        <a class="nav-link" href="${pageContext.request.contextPath}/hr/logout">로그아웃</a>
                    </div>

                </div>
            </nav>
                    <!--모든바디태그는 데코레이터에 삽입된다-->
            <sitemesh:write property='body'/>
        </div>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', () => { // 문서가 완전히 구문해석되고 지연된 모든 스크립트 및 다운로드가 실행가능했을때 발생.
            let menuList = new Array(); //

            <c:forEach var="menu" items="${sessionScope.authorityGroupMenuList}"> // 권한있는 메뉴들 반복문
            menuList.push("${menu}"); //반복된 menu들을 menu리스트에 대입
            <%--console.log("${menu}");--%>
            </c:forEach> // 반복문 끝
            console.log(menuList+"menulist");

            <%--     id는 #, class 는 .    --%>
            $(".m").on('click', function (event) { // m이 있는 클래스를 클릭했을때 일어나는 이벤트를 ex)menu
                console.log("this.id"+ this.id)
                if(!menuList.includes(this.id)){ //  메뉴리스트가 없는곳에 아이디가 포함되어있으면 스왈창 띄움
                    swal.fire({
                        text: "접근권한이 없습니다.",
                        icon: "error",
                    });
                    return false; // 뒤로 리턴
                }
            });
        });
    </script>
</c:if>


<c:if test="${sessionID == null}">  <!-- 세션아이디가 null이면 loginfo/loginForm/view로 다시이동 한다.-->
    <script>
        location.href="${pageContext.request.contextPath}/logiinfo/loginForm/view"
    </script>
</c:if>


<script src="https://unpkg.com/@ag-grid-enterprise/all-modules@24.1.0/dist/ag-grid-enterprise.min.js"></script>

<script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>