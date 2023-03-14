<!--
        < 알아두기 >
    Session : 브라우저가 최초로 서버에 요청을 하게 되면 브러우저당 하나씩 메모리 공간을 서버에서 할당, 브라우저가 종료 될때까지 사용할수있다.
    Session Scope : 브라우저가 최초의 요청을 발생시키고 브라우저를 닫을 때 까지 . session영역에 저장되어 있는 데이터나 객체를 자유롭게 사용 가능

    id =  "#", 전부다 // class = "."
-->



<!-- 견적 등록 페이지 -->

<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8"%>
<% request.setCharacterEncoding("UTF-8"); %>
<%@ taglib prefix="J2H" tagdir="/WEB-INF/tags" %>   
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <script src="https://unpkg.com/ag-grid-community/dist/ag-grid-community.min.noStyle.js"></script>
    <link rel="stylesheet" href="https://unpkg.com/ag-grid-community/dist/styles/ag-grid.css">
    <link rel="stylesheet" href="https://unpkg.com/ag-grid-community/dist/styles/ag-theme-balham.css">

    <script src="${pageContext.request.contextPath}/js/datepicker.js" defer></script>
    <script src="${pageContext.request.contextPath}/js/datepickerUse.js" defer></script>
    <script src="${pageContext.request.contextPath}/js/modal.js?v=<%=System.currentTimeMillis()%>" defer></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/datepicker.css">

    <script>
      $(function () { // 함수선언
        let end = new Date(); // Sun Nov 06 10:42:04 KST 2022
        let year = end.getFullYear();              // yyyy
        let month = (1 + end.getMonth());          //M  //getMonth의 반환값이 0~11 이므로 +1을 해줘야함 //
        month = month >= 10 ? month : '0' + month;  //month 두자리로 저장 // 삼항연산자
        let day = end.getDate();                   //d
        day = day >= 10 ? day : '0' + day;          //day 두자리로 저장
        end = year + '' + month + '' + day;         // 결론은 yyyy mm dd

          //datePicker 스타일
        $('#datepicker').datepicker({
          startDate: '-1d',
          endDate: end, // yyyy mm dd
          todayHiglght: true, // 오늘날짜 하이라이트기능
          autoHide: true, // 날짜를 선택한후 달력 숨기기
          //autoShow: true,
        })})
    </script>

    <style>
        /* 모든클래스 전체마진 0px */
        * {
            margin: 0px;
        }

        /* h5 클래스 위아래 마진 3px */
        h5 {
            margin-top: 3px;
            margin-bottom: 3px;
        }

        /* input 클래스 스타일 설정*/
        input {
            padding: 2px 0 2px 0;
            text-align: center;
            border-radius: 3px;
        }

        .ag-header-cell-label {
            justify-content: center;
        }
        .ag-cell-value {
            padding-left: 50px;
        }

        /* estimate 클래스 스타일*/
        .estimate {
            margin-bottom: 10px;
        }

        /* estimateDetail 클래스 스타일*/
        .estimateDetail {
            margin-bottom: 10px;
        }

        /* menuButton 클래스 스타일*/
        .menuButton {
            margin-top: 10px;
        }

        /* menuButton button  클래스 스타일*/
        .menuButton button {
            background-color: #506FA9;
            border: none;
            color: white;
            text-align: center;
            text-decoration: none;
            display: inline-block;
            font-size: 14px;
            border-radius: 3px;
        }

        /* menuButton__selectCode  클래스 스타일*/
        .menuButton__selectCode {
            display: inline-block;
        }
    </style>
</head>

  <!--=====================================================================-->

<body>
<article class="estimate">
    <div class="estimate_Title">
        <h5>📋 견적등록</h5>
        <span style="color: black">견적등록일자</span><br/>

        <%--        datepicker 삽입--%>
        <input type="text" id="datepicker" placeholder="YYYY-MM-DD👀" size="15" autocomplete="off" style="text-align: center">

                <%--    menubutton 삽입--%>
                 <div class="menuButton">

                    <%--견적추가 클릭시 줄 추가--%>
                     <button id="estimateInsertButton" onclick="addRow(this)">견적추가</button>

                    <%--견적삭제 클릭시 현재 줄 삭제--%>
                     <button id="estimateDeleteButton" onclick="deleteRow(this)">견적삭제</button>

                        <%--일괄저장 버튼 및 스타일 지정--%>
                     <button id="batchSaveButton" style=" float:right;  background-color:#F15F5F"  >일괄저장</button> <%--699줄-->

                        <%--거래처코드 버튼 및 클릭시 모달창 뜨게( ->  id 는 #이므로 #customerList 에 있는 목록 출력 )--%>
                        <div class="menuButton__selectCode">
                         <button class="search" id="customerList" data-toggle="modal"
                                    data-target="#listModal">거래처코드
                         </button>
                     </div>
                 </div>
    </div>
</article>



<%-- <알아두기>
    HTML <article> 요소는 문서, 페이지, 애플리케이션, 또는 사이트 안에서 독립적으로 구분해 배포하거나 재사용할 수 있는 구획을 나타냅니다--%>

<article class="estimateGrid">
    <div align="center">

        <!--myGrid가 자리 및 스타일 셋팅-->
        <div id="myGrid" class="ag-theme-balham" style="height:100px; width:auto; text-align: center;"></div> <%--밑에 선언 --%>
    </div>
</article>



<article class="estimateDetail">
    <div class="estimateDetail__Title">
        <h5>📋 견적상세등록</h5>
        <div class="menuButton">

                <%--    견적상세추가 클릭시 줄 추가--%>
               <button id="estimateDetailInsertButton" onclick="addRow(this)">견적상세추가</button>

                <%--    견적삭제 클릭시 현재 줄 삭제--%>
               <button id="estimateDetailDeleteButton" onclick="deleteRow(this)">견적상세삭제</button>

                    <%--품목코드,단위코드,수량 클릭시 모달창 뜨게 ( -> id 는 #이므로 #itemList 에 있는 목록 출력 ...이하 동일) --%>
               <div class="menuButton__selectCode">
                         <button class="search" id="itemList" data-toggle="modal"
                                       data-target="#listModal">품목코드
                         </button   >
                         <button class="search" id="unitList" data-toggle="modal"
                                      data-target="#listModal">단위코드
                         </button>
                         <button class="search" id="amountList" data-toggle="modal"
                                       data-target="#amountModal">수량
                         </button>
            </div>
        </div>
    </div>
</article>


<article class="estimateDetailGrid">
    <div align="center" class="ss">
        <!--myGrid2가 들어갈 자리 -->
        <div id="myGrid2" class="ag-theme-balham" style="height:50vh;width:auto;"></div>
    </div>
</article>

<!-- 조회 모달 -->
 <J2H:listModal/>

<%--Amount Modal--%>
<div class="modal fade" id="amountModal" role="dialog">
    <div class="modal-dialog">

        <!-- Modal content-->
        <div class="modal-content">

            <!-- 모달 헤더- -->
            <div class="modal-header">
                <h5 class="modal-title">AMOUNT</h5>
                <button type="button" class="" data-dismiss="modal" style="padding-top: 0.5px">&times;</button>
            </div>

            <!-- 모달 바디- -->
            <div class="modal-body">
                <div style="width:auto; text-align:left">
                       <label style='font-size: 20px; margin-right: 10px'>견적수량</label>
                       <input type='text' id='estimateAmountBox'  autocomplete="off"/><br>
                       <label for='unitPriceOfEstimateBox' style='font-size: 20px; margin-right: 10px'>견적단가</label>
                       <input type='text' id='unitPriceOfEstimateBox' autocomplete="off"/><br>
                       <label for='sumPriceOfEstimateBox' style='font-size: 20px; margin-right: 30px'>합계액  </label>
                       <input type="text" id='sumPriceOfEstimateBox' autocomplete="off"/>
                </div>
            </div>
            <div class="modal-footer"> <!-- 모달 아래-->
                <button type="button" id ="amountSave" class="btn btn-default" data-dismiss="modal">Save</button>
                <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
            </div>
        </div>
    </div>
</div>

<!--  ============================================================================================================ -->

<script>
     // 변수 선언 , 이 document.querySelector 는 문서 내에서 지정된 선택기 또는 선택기 그룹과 일치하는 querySelector() 첫 번째 항목을 반환
     const myGrid = document.querySelector('#myGrid');
     const myGrid2 = document.querySelector('#myGrid2');
     const datepicker = document.querySelector('#datepicker');
     const customerList = document.querySelector('#customerList');
     const itemList = document.querySelector('#itemList');
     const unitList = document.querySelector('#unitList');
     const amountList = document.querySelector('#amountList');
     const batchSaveButton = document.querySelector("#batchSaveButton");

     // 브라우저가 로드되기 전에 밑에 agGrid,agGrid2가 먼저 로드된다. 이것이 DOMContentLoaded
     document.addEventListener('DOMContentLoaded', () => {
         new agGrid.Grid(myGrid, estGridOptions); // 첫번째 Grid에 estGridOptions이 걸림
          new agGrid.Grid(myGrid2, estDetailGridOptions);  // 두번째 Grid에 estDetailGridOptions가 걸림.
      })
  //================================================================================

     let parameter;
  // O DATEPICKER    =>
  function getDatePicker(paramFmt) {
         console.log("$$$$$$$"+paramFmt);
    let _this = this;
    _this.fmt = "yyyy-mm-dd"; // 포맷형식
    console.log(_this);


    // function to act as a class
    function Datepicker() {
    }

    // gets called once before the renderer is used
    Datepicker.prototype.init = function (params) {
      // create the cell
        parameter=params;
      this.autoclose = true;
      this.eInput = document.createElement('input');
      this.eInput.style.width = "100%";
      this.eInput.style.border = "0px";
      this.cell = params.eGridCell;
      this.oldWidth = this.cell.style.width;
      this.cell.style.width = this.cell.previousElementSibling.style.width;
      this.eInput.value = params.value;


      //  startDate , endDate 셋팅
      let _startDate = datepicker.value; // 달력의 클릭된 값을 startDate 변수에 담음
      let _endDate = new Date(_startDate); // startDate값을 숫자로 변환하여 endDate에 담음
      let days = 14;

        // paramFmt == "dueDateOfEstimate" 셋팅
      if (paramFmt == "dueDateOfEstimate") { // 만약 paramFmt가 "dueDateOfEstimate"라면
        _startDate = new Date(_startDate) // startDate 값은 숫자로 변환하여 담고
        days = 9;                       // 매개변수 day에 9를 담는다.
        _startDate.setTime(_startDate.getTime() + days * 86400000); // startDate에 셋팅된 값은 9 * 1일(86400000 밀리초)
        let dd = _startDate.getDate();
        let mm = _startDate.getMonth( ) + 1; //January is 0! -> +1 = 1
        let yyyy = _startDate.getFullYear();
        _startDate = yyyy + '-' + mm + '-' + dd;
        console.log(_startDate);
        _endDate = new Date(_startDate);
        days = 19;
      }

      //endDate 셋팅
      _endDate.setTime(_endDate.getTime() + days * 86400000); // 9+19=28days
      let dd = _endDate.getDate();
      let mm = _endDate.getMonth() + 1; //0부터 시작한다 ex) January is 0!
      let yyyy = _endDate.getFullYear();
      _endDate = yyyy + '-' + mm + '-' + dd;

      $(this.eInput).datepicker({
        dateFormat: _this.fmt,
        startDate: _startDate,
        endDate: _endDate,
      }).on('change', function () {

        estGridOptions.api.stopEditing(); // 셀 편집기가 그리드에 편집을 중지하도록 함
        estDetailGridOptions.api.stopEditing();
        $(".datepicker-container").hide();
      });
    };

    // gets called once when grid ready to insert the element
    Datepicker.prototype.getGui = function () {
      return this.eInput;
    };

    // focus and select can be done after the gui is attached
    Datepicker.prototype.afterGuiAttached = function () {
     this.eInput.focus();
      console.log(this.eInput.value);
    };

    // returns the new value after editing
    Datepicker.prototype.getValue = function () {
      console.log(this.eInput);
      return this.eInput.value;
    };

    // datePick의 destroy메서드는 estGridOptions 옵션을 가지고 있는 그리드를 수정금지시킨다.
    Datepicker.prototype.destroy = function () {
      estGridOptions.api.stopEditing();
    };
    return Datepicker;
  }
  
  // =======  estColum 견적등록 그리드선언==========================================
  let estColumn = [
    {headerName: "거래처명", field: "customerName", editable: true},

    {headerName: "거래처코드", field: "customerCode", editable: true, hide: true},

    {headerName: "견적일자", field: "estimateDate"},

    {headerName: "유효일자", field: "effectiveDate", editable: true, cellRenderer: function (params) {
        if (params.value == "") { params.value = "YYYY-MM-DD";}
        return '📅 ' + params.value;
      }, cellEditor: 'datePicker1' // datePick1을 씀
    },

    {headerName: "견적담당자", field: "personNameCharge", editable: true},

    {headerName: "견적담당자코드", field: "personCodeInCharge", hide: true},

    {headerName: "견적요청자", field: "estimateRequester", editable: true},

    {headerName: "비고", field: "description", editable: true},

    {headerName: "status", field: "status", hide : true},

  ];

  let estRowData = [];

  // myGridoptions 첫번째(estGridOptions)  옵션 설정
  let estGridOptions = {
    columnDefs: estColumn, // 칼럼은 estColumn
    rowSelection: 'multiple', // 복수선택
    rowData: estRowData, //rowData는 배열( [] )

    getRowNodeId: function (data) { // 견적날짜를 반환하는 메서드
      return data.estimateDate;
    },

    defaultColDef: {editable: false}, // ColDef는 기본적으로 수정불가

    overlayNoRowsTemplate: "추가된 견적이 없습니다.", // 아무 그리드가 없을때 "추가된 견적이 없습니다."오버레이표시

    onGridReady: function (event) {// onload 이벤트와 유사 ready 이후 필요한 이벤트 삽입한다. 보통 그리드 자동 사이즈 등을 지정한다.
      event.api.sizeColumnsToFit();
    },

    onGridSizeChanged: function (event) { // 위와 상동
      event.api.sizeColumnsToFit();
    },

    onCellEditingStarted: (event) => { // 거래처명을 클릭했을 때 걸려있는 이벤트
      if (event.colDef.field == "customerName") { //만약 필드이름이 cutomerName거래처명인 경우 밑의 click메서드 실행
        customerList.click();
      }
    },

     getSelectedRowData() { // 로우를 선택한 값을 맵에담고 리턴
      let selectedNodes = this.api.getSelectedNodes();
      let selectedData = selectedNodes.map(node => node.data);
      return selectedData;
    },

    components: { // getDatePicker의 "effectiveDate"변수사용 -> 그러나 effectiveDate 변수가 없기때문에 전역변수 사용( day = 5)
      datePicker1: getDatePicker("effectiveDate"), //
    }

  }


  // estimateDetail Grid  견적상세등록 그리드 선언
  let estDetailColumn = [

    {headerName: "품목코드", field: "itemCode",  suppressSizeToFit: true, editable: true, suppressSizeToFit: true, headerCheckboxSelection: true,
      headerCheckboxSelectionFilteredOnly: true,
      checkboxSelection: true},

    {headerName: "품목명", field: "itemName"},

    {headerName: "단위", field: "unitOfEstimate"},

    {headerName: "납기일", field: "dueDateOfEstimate", editable: true, cellRenderer: function (params) {
        if (params.value == "") { params.value = "YYYY-MM-DD";}
        return '📅 ' + params.value;
      }, cellEditor: getDatePicker("dueDateOfEstimate")/*'datePicker2'*/}, //  datePick2를 사용

    {headerName: "견적수량", field: "estimateAmount", editable: true},

    {headerName: "견적단가", field: "unitPriceOfEstimate", hide: false},

    {headerName: "합계액", field: "sumPriceOfEstimate"},

    {headerName: "비고", field: "description", editable: true},

    {headerName: "status", field: "status", hide : true},

    {headerName: "beforeStatus", field: "beforeStatus", hide: true},

  ];
  let itemRowNode;

  let estDetailRowData = [];

    //======= myGrid2options ======두번째그리드 옵션==========================
  let estDetailGridOptions = {

    columnDefs: estDetailColumn, // columDef는 estDetailColum을 쓴다

    rowSelection: 'multiple', // 로우 복수선택가능

    rowData: estDetailRowData, // rowData는  estDetailRowData 사용 ( 배열 [] )

    defaultColDef: {editable: false}, //기본옵션으로 수정금지로 설정

    overlayNoRowsTemplate: "추가된 견적상세가 없습니다.", // 아무 그리드가 없을때 "추가된 견적상세가 없습니다." 오버레이 표시

    onGridReady: function (event) { // onload 이벤트와 유사 ready 이후 필요한 이벤트 삽입한다. 보통 그리드 자동 사이즈 등을 지정한다.
      event.api.sizeColumnsToFit();
    },
    onGridSizeChanged: function (event) {
      event.api.sizeColumnsToFit();
    },
    onCellDoubleClicked: (event) => {
      if (event != undefined) {

        let rowNode = estDetailGridOptions.api.getDisplayedRowAtIndex(event.rowIndex);  //getDisplayedRowAtIndex: 보이는 줄의 인덱스 얻기
        //console.log("rowNode = "+JSON.stringify(rowNode));
        itemRowNode = rowNode;
      }

      if (event.colDef.field == "itemCode" || event.colDef.field == "itemName") { //  || A OR B     // 필드가 품목코드 및 품목이름일때
        itemList.click(); // itemList의 클릭메서드 호출

      } else if (event.colDef.field == "unitOfEstimate") { // 필드가 견적수량일때
        unitList.click(); // unitList의 클릭메서드 호출

      } else if (event.colDef.field == "estimateAmount") { // 필드가 견적단가 일때
        amountList.click(); // amountList의 의 클릭메서드 호출
      }
    },
    onRowSelected: function (event) { // 로우를 선택했을때
      console.log("event" + event); // 콘솔 출력
    },
    onSelectionChanged(event) { // 선택된 로우에서 다른 로우로 바꿨을때
      console.log("onSelectionChanged" + event); // 콘솔 출력
    }

  }

// ====================================================================================================================
   // O add and Delete function 추가,삭제버튼 함수

  function addRow(event) {  // o 견적추가버튼
    if (event.id == "estimateInsertButton") {
         if (datepicker.value == "") { // 예외처리와 흡사 , 값이 없으면
              Swal.fire({
                text: "견적일자를 등록하셔야합니다.",
                icon: "info",
              });
              return;

         }  else if (estGridOptions.api.getDisplayedRowCount() > 0) {   // 견적추가를 제대로 하나 하지 않고 버튼을 또 누를 경우
              Swal.fire({ //아직 처리하지 않은 견적이 있으면 그리드에 행이 남아있기 때문이다. 
                text: "처리하지 않은 견적이 있습니다.", 
                icon: "info",
              });
              return;
      } 
      
      let row = {     // 그냥 견적추가, 값을 받아오는 아이
        estimateDate: datepicker.value,  // estimateDate: 견적일자
        personCodeInCharge: "${sessionScope.empCode}",  // personCodeInCharge: 견적담당자코드  위에서 선언되어 있는 거 찾아오면 됨.
        personNameCharge: "${sessionScope.empName}",   // 'ag-Grid에 띄워지는 아이들의 값을 받아온다'고 볼 수 있다.
        effectiveDate: "", // 빈칸
            estimateRequester: "${sessionScope.empName}",
        description: "", // 빈칸
        status: "INSERT" // "insert"
      };
      estGridOptions.api.updateRowData({add: [row]});  // 위에서 받아온 값을 updateRowData에 추가시킨다. 이렇게 되면 agGrid의 형태가띄워지게 된다.
    }
        // 이 위까지는 견적추가 이벤트

    // 여기부터 견적상세추가버튼 이벤트가 실행
    else if (event.id == "estimateDetailInsertButton") { //견적상세추가버튼일때
      console.log(event.innerText);
      let estDate = estGridOptions.getSelectedRowData(); // 첫번째그리드옵션으로 선택된로우의 값을 estDate 저장
      console.log(estDate); // 선택된 로우값 콘솔창 출력
      if (estDate.length == 0) { // 첫번째 그리드에서 가져온 값들의 길이값이 0일 경우
        Swal.fire({
          text: "견적 상세를 추가할 행을 선택 하세요.",
          icon: "info",
        })
        return;
      }

      let rowNode = estGridOptions.api.getRowNode(datepicker.value); // 첫번째그리드옵션으로 선택된 로우의 노드(달력값)을 rowNode에 저장
      console.log("견적상세" + rowNode.data); // ex) 견적상세 : 2022-02-14 <-- 콘솔로그 출력

      if (rowNode.data.customerName == undefined) { // 만약 선택된 노드(고객명)이 undefined일때
        Swal.fire({
          text: "견적 거래처 코드를 등록하셔야 합니다.",
          icon: "info",
        })
        return;
      }

      if (rowNode.data.effectiveDate == "") { //
        Swal.fire({
          text: "견적 유효일자를 등록하셔야 합니다.",
          icon: "info",
        })
        return;
      }
      
      let row = { // 버튼을 누르자마자 빈 그리드가 위치 되어지기 때문에 다 공백처리로 빈 값을 넣어놓는다고 볼 수 있다
       itemCode: "",
        dueDateOfEstimate: "",
        unitOfEstimate: "EA",
        status: "INSERT",
        description: "",
        beforeStatus: "",
        estimateAmount: "",
      };
      estDetailGridOptions.api.updateRowData({add: [row]});  // 여기에 다가 위의 변수들을 넣어준다. 하지만 이 상태에서 견적상세등록 칸에 ag-Grid가 들어가는 건 아니다.
    }
  }
//---------------------------------------------------------------------------------------
  function deleteRow(event) { // o 견적삭제 버튼
    let selected = estGridOptions.api.getFocusedCell();
    if (selected == undefined) {
      Swal.fire({
        text: "선택한 행이 없습니다.",
        icon: "info",
      })
      return;
    }
    if (event.id == "estimateDeleteButton") {
      estGridOptions.rowData.splice(selected.rowIndex, 1);
      estGridOptions.api.setRowData(estGridOptions.rowData);
    } else if (event.id == "estimateDetailDeleteButton"){
      console.log("견적상세삭제");
      let selectedRows = estDetailGridOptions.api.getSelectedRows();
      console.log("선택된 행" + selectedRows );
      selectedRows.forEach( function(selectedRow, index) {
        console.log(selectedRow);
   //     detailItemCode.splice(detailItemCode.indexOf(selectedRow.itemCode), 1); // 배열요소 제거
        estDetailGridOptions.api.updateRowData({remove: [selectedRow]});
      });
    }
  }
  //=========================견적추가, 견적삭제 버튼 끝===========================================================
  //O Button Click event
  // o ListModal Click 
  
  customerList.addEventListener('click', () => { // customerList 을 클릭했을 때 실행되는 메서드
         getListData("CL-01"); // ()안에 있는 값을 인자값으로 들고 getListData메서드를 찾으러 출발~
          $("#listModalTitle").text("CUSTOMER CODE");
  });


  itemList.addEventListener('click', () => { // itemList 를 클릭했을때 실행되는 메서드
   getListData("IT-_I");  // IT-_1 을 인자값으로 들고 출발
    $("#listModalTitle").text("ITEM CODE");
  });
  
  unitList.addEventListener('click', () => { // unitList 을 클릭했을 때 실행되는 메서드
      getListData("UT");
       $("#listModalTitle").text("UNIT CODE");
     });
  
  amountList.addEventListener('click', () => { // amountList 을 클릭했을 때 실행되는 메서드
    console.log(itemRowNode);
    if (itemRowNode == undefined) {return;}
    if (itemRowNode.data.itemCode != undefined) {
      getStandardUnitPrice(itemRowNode.data.itemCode, "EA");
    }
  });
  //--------------------------------------------------------------------------------------------
 // 각 모달에 걸리는 메서드 호출 => function
  // o if customer modal hide, next cell
  $("#listModal").on('hide.bs.modal', function () {
     if( $("#listModalTitle").text() == "CUSTOMER CODE"){
          
          estGridOptions.api.stopEditing(); // 수정 정지
          let rowNode = estGridOptions.api.getRowNode(datepicker.value);
          console.log("rowNode:" + rowNode);
          if (rowNode != undefined) { // rowNode가 없는데 거래처 코드 탐색시 에러
            setDataOnCustomerName();
          }          
     } else if( $("#listModalTitle").text() == "ITEM CODE" ){
          if (itemRowNode != undefined) { // rowNode가 없는데 거래처 코드 탐색시 에러
              setDataOnItemName();
          }
     }
  });
  
//o change customerName cell
  function setDataOnCustomerName() {
    let rowNode = estGridOptions.api.getRowNode(datepicker.value);
    let to = transferVar();
    rowNode.setDataValue("customerName", to.detailCodeName);
    rowNode.setDataValue("customerCode", to.detailCode);
    let newData = rowNode.data;
    rowNode.setData(newData);
  }

  function setDataOnItemName() { // setDataOnItemName 메서드 선언
    estDetailGridOptions.api.stopEditing();
    let to = transferVar();

    itemRowNode.setDataValue("itemCode", to.detailCode);
    itemRowNode.setDataValue("itemName", to.detailCodeName);
    let newData = itemRowNode.data;
    itemRowNode.setData(newData);
    console.log(itemRowNode.data);
  }
  //-------------------------------------------------------------------------------------------------
  
  
  // 모달이 띄워졌을때, 기존의 값을 to에 세팅 
     $("#listModal").on('show.bs.modal', function () { 
       let existingData;
        if( $("#listModalTitle").text() == "CUSTOMER CODE"){
             if(estGridOptions.api.getDisplayedRowCount()!=0){
                let rowNode = estGridOptions.api.getRowNode(datepicker.value);
                existingData = {"detailCode":rowNode.data.customerCode, "detailCodeName":rowNode.data.customerName};
             }  
        } else if( $("#listModalTitle").text() == "ITEM CODE" ){
             if (itemRowNode != undefined) { // rowNode가 없는데 거래처 코드 탐색시 에러
                existingData = {"detailCode":itemRowNode.data.itemCode, "detailCodeName":itemRowNode.data.itemName};
             }
        }
        to = existingData;
     });  
  
  $("#amountModal").on('show.bs.modal', function () {
    $('#estimateAmountBox').val("");
    $('#sumPriceOfEstimateBox').val("");
    $('#estimateAmountBox, #unitPriceOfEstimateBox').on("keyup", function() {  //estimateAmountBox, #unitPriceOfEstimateBox 견적수량과 합계액
      let sum = $('#estimateAmountBox').val() * $('#unitPriceOfEstimateBox').val();  //sum에는 견적수량과 견적단과가 곱해진 값이 들어간다.
      $('#sumPriceOfEstimateBox').val(sum);  //  그러면 합계액에는 위의 sum이 담김
    });
  });
  
  $("#amountModal").on('shown.bs.modal', function () {  // 실행하고자 하는 jQuery 코드
     $('#estimateAmountBox').focus(); //포커스를 얻었을 때 어떤 행위하기=> 견적수량 칸을 더블클릭해서 모달창이 띄워졌으면 바로 견적수량에 포커스가 위치하게 된다.
  })
  
  document.querySelector("#amountSave").addEventListener("click", () => {  //modal창 밑에 있는 Save에 걸리는 이벤트
    if (itemRowNode == undefined) {   return;}
    estDetailGridOptions.api.stopEditing();
    itemRowNode.setDataValue("estimateAmount", $('#estimateAmountBox').val());
    itemRowNode.setDataValue("unitPriceOfEstimate", $('#unitPriceOfEstimateBox').val());
    itemRowNode.setDataValue("sumPriceOfEstimate", $('#sumPriceOfEstimateBox').val());
    let newData = itemRowNode.data; // 바로 위에서 받아온 견적수량,견적단가,합계액의 데이터들이 newData라는 변수명에 담긴다.
    itemRowNode.setData(newData);  // 그러면 itemRowNode에 set해준다.  그 다음 일괄저장으로 출발
  })

 // ================================================================================================================
//  ======================일괄저장======================================================================
  // 일괄저장 <= 선택된 항목만 저장
  batchSaveButton.addEventListener("click", () => {  //일괄저장을 클릭했을때
    let newEstimateRowValue = estGridOptions.getSelectedRowData(); // '견적추가'그리드 배열을 'newEstimateRowValue 로 리턴받음
    console.log(newEstimateRowValue); // 콘솔로 견적추가 그리드 배열을 출력
    let selectedRows = estDetailGridOptions.api.getSelectedRows();  // '견적상세추가'그리드 배열 리턴 받음
      console.log(selectedRows); // 콘솔로 견적상세추가 그리드 배열을 출력
    if(selectedRows.length==0){ // 견적 상세 그리드가 없으면
       Swal.fire({              // 에러메세지창 출력
            text: "선택한 행이 없습니다.",
            icon: "info",
          })
       return;
    }
    if (newEstimateRowValue == "") {
      Swal.fire({
        text: "상세 견적을 추가하지 않았습니다",
        icon: "info",
      })
      return;

    } else if (newEstimateRowValue[0].customerCode == '' || newEstimateRowValue[0].effectiveDate == '') {  //거래처명값의 0번째와 유효일자 둘 중에 하나라도 충족되지 않을 경우
      Swal.fire({
        text: "거래처명과, 유효일자는 필수항목입니다.",
        icon: "info",
      })
      return ;
    }
    for(index in selectedRows){  // 선택된 행들 예로들면, 견적추가에서 한 행, 견적상세 추가 이렇게 한 행 있다고 하면, 총 인덱스 번호가 0,1 로 잡힌다.
       selectedRow=selectedRows[index];
       console.log(index);//현재는 0만 출력됨, 무조건 첫번째 행 데이터값만 가져온다는 말, 인덱스값이 상세추가의 선택된 그리드 행만큼 숫자가 늘어나야됨
       console.log(selectedRow);
       if (selectedRow.itemCode == ""   // 견적상세에서 품목코드
            || selectedRow.dueDateOfEstimate == ""  // 납기일
            || selectedRow.estimateAmount == "") {   // 견적수량  중에 하나라도 만족하지 않을 경우
      Swal.fire({
        text: "견적상세의 품목코드, 단위, 납기일, 견적수량은 필수항목입니다.",
        icon: "info",
      })
      return;
    }else if (selectedRow == null) {  // 단 한행이라도 없을 경우=> 즉 상세견적을 추가하지 않을 경우
        Swal.fire({
            text: "상세 견적을 추가하지 않았습니다",
            icon: "info",
          })
       return;
    }//////////// / 여기까지가 에러처리 /////////


    }  
   //console.log(estGridOptions.getSelectedRowData())
    newEstimateRowValue = estGridOptions.getSelectedRowData()[0];  // 일단 견적상세(estGridOptions)그리드에서 첫번째 선택된 행의 데이터를 newEstimateRowValue에 담는다.

    newEstimateRowValue.estimateDetailTOList = selectedRows;

                                                                                                                      // *** 상세추가그리드 부분을 estimateDetailTOList에 담아서 위의 추가 그리드에 합쳐준 다음 일괄저장으로 같이 데이터를 넘겨준다고 생각하면 된다. ***
    newEstimateRowValue = JSON.stringify(newEstimateRowValue);  // 받아온 값들을 JSON형태로 바꾸어준다고 생각=> 문자열로 변환
      console.log("newEstimateRowValue"+newEstimateRowValue);
    Swal.fire({
      title: "견적을 등록하시겠습니까?",
      icon: 'warning',
      showCancelButton: true,
      confirmButtonColor: '#3085d6',
      cancelButtonColor: '#d33',
      cancelButtonText: '취소',
      confirmButtonText: '확인',
    }).then( (result) => {  // 위 SWAL창이 뜬 다음
      if (result.isConfirmed) {  //결과가 컨펌이 되었을 경우
        let xhr = new XMLHttpRequest();
        xhr.open('POST', "${pageContext.request.contextPath}/logisales/estimate/new?method=addNewEstimate&estimateDate=" // 위의 값들을 리퀘스트매핑 밸류값 logisales/estimate/new를 호출시켜서 던질거임
          + datepicker.value + "&newEstimateInfo=" + encodeURI(newEstimateRowValue), // 날짜값+""&newEstimateInfo="uri인코딩된주소를 던짐
          true);
        xhr.setRequestHeader('Accept', 'application/json');// (헤더이름,헤더값) HTTP요청 헤더에 포함하고자 하는 헤더 이름과 그 값인데 전에 무조건 open()뒤에는 send()메소드를 써주어야 한다.
        xhr.send();
        xhr.onreadystatechange = () => {  //callback함수 사용
         if (xhr.readyState == 4 && xhr.status == 200) { // 숫자값에 따라 처리상태가 달라지는 것. xhr.readyState == 4 : 데이터를 전부 받은 상태,완료되었다.xhr.status == 200 : 서버로부터의 응답상태가 요청에 성공하였다는 의미.
          // 초기화 
          estGridOptions.api.setRowData([]);
          estDetailGridOptions.api.setRowData([]);
          let txt = xhr.responseText;
          txt = JSON.parse(txt);
          let resultMsg = // 초기화가 완료되었으면 이 결과 메세지를 반환
              "<h5>< 견적 등록 내역 ></h5>"
              + "새로운 견적번호 : <b>" + txt.result.newEstimateNo + "</b></br>"
              + "견적상세번호 : <b>" + txt.result.INSERT  + "</b></br>"
              + "위와 같이 작업이 처리되었습니다";
          Swal.fire({
            title: "견적등록이 완료되었습니다.",
            html: resultMsg,
            icon: "success",
          });
        }
      }; 
    }})
  })
</script>
</body>
</html>