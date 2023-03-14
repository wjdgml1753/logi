<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="J2H" tagdir="/WEB-INF/tags" %>   <%--커스텀태그--%>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <script src="https://unpkg.com/ag-grid-community/dist/ag-grid-community.min.noStyle.js"></script>
    <link rel="stylesheet" href="https://unpkg.com/ag-grid-community/dist/styles/ag-grid.css">
    <link rel="stylesheet" href="https://unpkg.com/ag-grid-community/dist/styles/ag-theme-balham.css">

    <script src="${pageContext.request.contextPath}/js/modal.js?v=<%=System.currentTimeMillis()%>" defer></script>
    <script src="${pageContext.request.contextPath}/js/datepicker.js" defer></script>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/datepicker.css">

    <script>
      // O 날짜 설정

      $(function () {

        let start = new Date();     // Date(); 는 밀리초로 나타내는 정수 값을 담습니다.

        start.setDate(start.getDate() - 20);    // getDate(); 는 현재 시간 기준 '일'을 담는다

        let end = new Date(new Date().setYear(start.getFullYear() + 1)); // 기준년도 + 1 ex) 2022 -> 2023

        // o set searchDate
        $('#datepicker').datepicker({
          todayHiglght: true,
          autoHide: true,
          autoShow: false,
        });

        // o set searchRangeDate
        $('#fromDate').datepicker({
          startDate: start,
          endDate: end,
          minDate: "-10d",
          todayHiglght: true,
          autoHide: true,
          autoShow: false,
        })
        $('#toDate').datepicker({
          startDate: start,
          endDate: end,
          todayHiglght: true,
          autoHide: true,
          autoShow: false,
        })

        $('#fromDate').on("change", function(){ // fromdate가 바꼈을때 todate는 fromdate의 value 값을 가지고 시작한다.
          var startVal = $('#fromDate').val(); // val = value 값을 가져옴
          $('#toDate').data('datepicker').setStartDate(startVal);
        });
        $('#toDate').on("change", function(){ // todate가 바꼈을때 fromdate는 todate의  value 값을 가지고 시작한다.
          var endVal = $('#toDate').val(); // val -> value 값을 가져옴
          $('#fromDate').data('datepicker').setEndDate(endVal );
        });

      });
    </script>
    <style>
        .fromToDate {
            display: none; <%-- 아예 그 요소가 존재하지 않았다는 듯 사라진 것처럼 보입니다.--%>
            margin-bottom: 7px;
        }

        #datepicker {
            margin-bottom: 7px;
        }

         button {
            background-color: #506FA9;
            border: none;
            color: white;
            text-align: center;
            text-decoration: none;
            display: inline-block;
            font-size: 14px;
            border-radius: 3px;
            margin-bottom: 10px;
        } 

        .ag-header-cell-label {
            justify-content: center;
        }
             * {
                 margin: 0px;
        }
    </style>

</head>

<body>

<article class="contract">
    <div class="contract__Title">
        <h5>📋 수주 등록</h5>

        <div style="color: black">
            <label for="searchByDateRadio">일자 검색</label>
            <input type="radio" name="searchDateCondition" value="searchByDate" id="searchByDateRadio" checked>
            &nbsp;<label for="searchByPeriodRadio">기간 검색</label>
            <input type="radio" name="searchDateCondition" value="searchByPeriod" id="searchByPeriodRadio">
        </div>

        <form autocomplete="off"><!--  자동완성 기능 해제 -->
            <input type="text" id="datepicker" placeholder="YYYY-MM-DD 📅" size="15" style="text-align: center">
            <div class="fromToDate">
                <input type="text" id="fromDate" placeholder="YYYY-MM-DD 📅" size="15" style="text-align: center">
                &nbsp; ~ &nbsp;<input type="text" id="toDate" placeholder="YYYY-MM-DD 📅" size="15"
                                    style="text-align: center">
            </div>
        </form>
        <button id="contractCandidateSearchButton">수주가능견적조회</button>
        <button class="search" id="contractTypeList" data-toggle="modal"
                data-target="#listModal">수주유형
        </button>
        <button id="estimateDetailButton">견적상세조회</button>
        &nbsp;&nbsp;<button id="contractBatchInsertButton"  style="background-color:#F15F5F" >수주등록</button>
    </div>
</article>


<article class="contractGrid"> <!--myGrid 그리드 선언-->
    <div align="center">
        <div id="myGrid" class="ag-theme-balham" style="height:20vh; width:auto; text-align: center;"></div>
    </div>
</article>


<div>
    <h5>📋 견적 상세</h5>
</div>


<article class="estimateDetailGrid"><!--myGrid2 그리드 선언-->
    <div align="center" class="ss">
        <div id="myGrid2" class="ag-theme-balham" style="height:30vh;width:auto;"></div>
    </div>
</article>





<J2H:listModal/>


<script>
    // 변수 선언 , 이 document.querySelector 는 문서 내에서 지정된 선택기 또는 선택기 그룹과 일치하는 querySelector() 첫 번째 항목을 반환
  const myGrid = document.querySelector("#myGrid");
  const myGrid2 = document.querySelector("#myGrid2");
  const searchByDateRadio = document.querySelector("#searchByDateRadio");
  const searchByPeriodRadio = document.querySelector("#searchByPeriodRadio");
  const datepicker = document.querySelector("#datepicker");
  const fromToDate = document.querySelector(".fromToDate");
  const startDatePicker = document.querySelector("#fromDate");
  const endDatePicker = document.querySelector("#toDate");
  const searchBtn = document.querySelector("#contractCandidateSearchButton");
  const contractTypeList = document.querySelector("#contractTypeList");
  const estimateDetailBtn = document.querySelector("#estimateDetailButton");
  const contractBatchInsertBtn = document.querySelector("#contractBatchInsertButton");

  searchByDateRadio.addEventListener("click", () => { // 일자검색을 클릭했을때 발생하는 이벤트
    datepicker.style.display = "inline-block"; // daterpick의 스타일은 inline-block로
    fromToDate.style.display = "none"; // fromToDate의 스타일은 없음으로

  });
  searchByPeriodRadio.addEventListener("click", () => { // 기간검색을 클릭했을때 발생하는 이벤트
    datepicker.style.display = "none"; // Daterpick의 스타일은 none로
    fromToDate.style.display = "inline-block"; // fromeToDate 스타일은 inline-block로

  });
   
  // O customerList Grid
  let contractColumn = [ //그리드 안에 컬럼 명시
    {headerName: ' ', checkboxSelection: true,  width: 50, cellStyle: {'textAlign': 'center'}, headerCheckboxSelection: true }, // 체크박스 기능 추가
    {headerName: "견적일련번호", field: "estimateNo"},
    {headerName: "수주유형분류", field: "contractTypeName", editable: true}, // editable = 수정가능하게
    {headerName: "수주유형분류", field: "contractType", editable: true, hide:true},
    {headerName: "거래처이름", field: "customerName" },
    {headerName: "거래처코드", field: "customerCode",hide:true},
    {headerName: "수주요청자", field: "contractRequester", editable: true},

      // cellRenderer은 코드인 경우 코드의 값으로 전환해야 하고 필요한 경우 그래프나 아이콘, 이미지 등으로 보여 줘야 할 때도 있습니다.
      // 그런 경우 cellRenderer를 이용해서 표현할 수 있습니다.
    {headerName: "견적일자", field: "estimateDate",  cellRenderer: function (params) {
            if (params.value == "") { params.value = "YYYY-MM-DD";}
        return '📅 ' + params.value;
      }},

    {headerName: "유효일자", field: "effectiveDate",  cellRenderer: function (params) {
        if (params.value == "") { params.value = "YYYY-MM-DD";}
        return '📅 ' + params.value;
      }},

    {headerName: "견적담당자명", field: "estimateRequester"},

    {headerName: "견적담당자코드", field: "personCodeInCharge",hide :true},

    {headerName: "비고", field: "description", editable: true}
    
  ];


  // 칼럼 선언
  let rowData = []; // 변수 배열선언
  let contractRowNode; // 변수선언
  let contractGridOptions = { // ContractGrid 옵션 주기
    columnDefs: contractColumn, // 칼럼정의는 contractColumn
    rowSelection: 'multiple', // 로우 여러개 선택
    rowData: rowData,
    getRowNodeId: function (data) { // 원하는 값을 반환하는  것이지만 여기서는 // estimanteNo를 반환하는 메서드
      return data.estimateNo;
    },

    defaultColDef: {editable: false, resizable : true}, // 기본 칼럼 옵션을 수정불가, 리사이즈 가능하게

    overlayNoRowsTemplate: "수주 가능한 견적이 없습니다.", // 아무 줄이 없을때 표시되는 오버레이메세지

    onGridReady: function (event) { // 행 넓이 자동 조절 기능메서드 여기선 그리드가 준비되었을때 쓰인다.// onload 이벤트와 유사 ready 이후 필요한 이벤트 삽입한다.
      event.api.sizeColumnsToFit();
    },

    onGridSizeChanged: function (event) { // 똑같은 행넓이 자동 조절 기능메서드, 하지만 여기선 그리드 사이즈가 바뀌였을때 쓰인다//
      event.api.sizeColumnsToFit();
    },
    onCellEditingStarted: (event) => { // 만약 칼럼필드명이 contractTypeName 일때 실행되는 메서드
      if (event.colDef.field == "contractTypeName") { // 칼럼명이  contractTypeName 이면
          console.log("수주유형분류 클릭"); // 콘솔출력 하고
        contractTypeList.click(); // 수주유형분류 를 클릭한다.
        }
    },

    onCellDoubleClicked: (event) => { // 만약 이벤트를 정의하지않았을때 일어나는 메서드
        if (event != undefined) { // 이벤트가 발생할때
            console.log("더블클릭"); // 콘솔출력 하고
          estimateDetailBtn.click(); // 견적상세버튼을 클릭한다
        }
     },
    getSelectedRowData() { // 줄을 선택했을때 발생하는 이벤트
      let selectedNodes = this.api.getSelectedNodes(); // 여기서 사용된 api는 getSelectedNodes다. getSelectedNodes는 선택된노드목록을 반환한다.
      let selectedData = selectedNodes.map(node => node.data); // 노드의 데이터를 map에 담고 그걸 변수에 담는다
      return selectedData; // 반환
    }
  }

  // O 수주 가능 견적 조회
  let estimateDetailList = []; // 변수 배열선언
  searchBtn.addEventListener("click", () => { // 견적조회버튼을 눌렀을때 실행되는 메서드
    let searchCondition = document.querySelector("#searchByDateRadio").checked; // 일자 검색이 체크되어있는것이 serchCondition이다.

    let startDate = (searchCondition) ? datepicker.value : startDatePicker.value;
      // serchCondition이 참이면(체크되어있으면) 달력의값이 startDate가 되고,
      // 거짓이면(체크되어있지않으면) 달력의 시작날짜가 startDate가 된다.

    let endDate = (searchCondition) ? datepicker.value : endDatePicker.value;
      // serchCondition이 참이면(체크되어있으면) 달력의값이 endDate가 되고,
      // 거짓이면(체크되어있지않으면) 달력의 마지막날짜가 endDate가 된다.



    contractGridOptions.api.setRowData([]);
      // contratcGridOptions에 setRowData라는 api메서드 사용 // 배열값을 rowid의 row에 업데이트한다.
      // 지금 이 경우는 빈 배열을 셋팅했다. 즉 초기화 과정이다

     estDetailGridOptions.api.setRowData([]);
     // 위와 동일

     estimateDetailList = [];
     //초기화 셋팅

    // ajax
    let xhr = new XMLHttpRequest();
    xhr.open('GET', "${pageContext.request.contextPath}/logisales/estimate/list/contractavailable?"
        // get방식으로 logisales/estimate/list/contractavailable 콘트롤러의

        + "method=searchEstimateInContractAvailable"
        // searchEstimateInContractAvailable 메서드 사용

        + "&startDate=" + startDate
        // startDate를 넘겨주고

        + "&endDate=" + endDate,
        // endDate도 같이 넘겨준다.
        true);

    xhr.setRequestHeader('Accept', 'application/json');
    // http요청의 헤더값 Accept에 'application/json'를 셋팅해주고

    xhr.send();
    // 이런식으로 open() -> setRequestHeader()-> send() 과정을 거쳐야함

    console.log("xhr")
    console.log(xhr)

    xhr.onreadystatechange = () => { // xhr의 onreadystatechange 메서드
      if (xhr.readyState == 4 && xhr.status == 200) { // xhr이 성공일때
        let txt = xhr.responseText; // xhr의 responseText를 txt에 담고
        txt = JSON.parse(txt); // JSON 문자열을 JavaScript 객체로 변환하여 txt 에 담음
          // console.log("txt")
          // console.log(txt)

        if (txt.gridRowJson == "") { // 만약 txt의 gridRosJson이 빈값이면
          swal.fire("수주 가능 견적이 없습니다."); // swal창 뜸
          return;
        } else if (txt.errorCode < 0) { // 또는 errorCode 음수면은
          swal.fire("알림", txt.erroMsg, "error"); // 에러 swal창 뜸
          return;
        }

        contractGridOptions.api.setRowData(txt.gridRowJson); // gridRowJson의 배열값을 contractGridOption에 rowid의 row에 업데이트한다.

        txt.gridRowJson.map((unit, idx) => {
          [].forEach.bind(unit.estimateDetailTOList)((val) => {    // [].forEach == Array.prototype.forEach
            estimateDetailList.push(val); // estDetailGrid에서 사용하기 위해 담음
              console.log("***************************")
              console.log(JSON.stringify(val))
          });
        });
      }
    }
  });

  // o if customer modal hide, next cell
  $("#listModal").on('hide.bs.modal', function () {
    contractGridOptions.api.stopEditing(); // 수정을 금지하고
    console.log("모달 더블클릭"); // 콘솔출력
      console.log(contractRowNode);
    if (contractRowNode != undefined) { // rowNode(contractRowNode)가 정의되었으면(선택되었으면)
      setDataOnCustomerName(); // 메서드 실행.바로 밑에있음
    }
  });

  // o change customerName cell
  function setDataOnCustomerName() {
    let to = transferVar(); // modal.js에 있는 함수 실행. to라는 변수에 저장
    if(to==undefined){ // to가 정의되지않았으면
       return; // 리턴
    }
    contractRowNode.setDataValue("contractType", to.detailCode);
      // rowNode(contractRowNode)가 정의되었으면(선택되었으면)(330줄) contratctType과 to의 detailcode를 셋팅

    let newData = contractRowNode.data;
    // contractRowNode의 data를 newData 라는 변수에 저장

    contractRowNode.setData(newData);
    // 다시 셋팅
  }




//견적 상세 페이지
  let estDetailColumn = [ // 칼럼정의
    {headerName: "견적상세일련번호", field: "estimateDetailNo",  suppressSizeToFit: true},
    {headerName: "품목코드", field: "itemCode",  suppressSizeToFit: true, editable: true},
    {headerName: "품목명", field: "itemName"},
    {headerName: "단위", field: "unitOfEstimate",},
    {headerName: "납기일", field: "dueDateOfEstimate", editable: true, cellRenderer: function (params) {
        if (params.value == "") { params.value = "YYYY-MM-DD";}
        return '📅 ' + params.value;
      }, cellEditor: 'datePicker'},
    {headerName: "견적수량", field: "estimateAmount"},
    {headerName: "견적단가", field: "unitPriceOfEstimate"},
    {headerName: "합계액", field: "sumPriceOfEstimate"},
    {headerName: "비고", field: "description"}
  ];
  let estDetailrowData = []; // 변수 배열로초기화

  let itemRowNode; // 변수 선언

  let estDetailGridOptions = {

    columnDefs: estDetailColumn, // 칼럼은 estDetailColumn 으로

    rowSelection: 'multiple', // 복수선택 가능하게

    rowData: estDetailrowData, // rowData는 배열로 초기화된 값으로 세팅

    defaultColDef: {editable: false, resizable : true},

    overlayNoRowsTemplate: "견적상세 버튼으로 내용을 조회해주세요.",

    onGridReady: function (event) {// 행 넓이 자동 조절 기능메서드 여기선 그리드가 준비되었을때 쓰인다.// onload 이벤트와 유사 ready 이후 필요한 이벤트 삽입한다.
      event.api.sizeColumnsToFit();
    },
    onGridSizeChanged: function (event) {// 똑같은 행넓이 자동 조절 기능메서드, 하지만 여기선 그리드 사이즈가 바뀌였을때 쓰인다//
      event.api.sizeColumnsToFit();
    },
    onCellDoubleClicked: (event) => { // 메서드선언
      if (event != undefined) { // 이벤트가 정의되었으면
        console.log("IN onRowSelected"); // 콘솔출력
        let rowNode = estDetailGridOptions.api.getDisplayedRowAtIndex(event.rowIndex); // api사용하여 event의 rowindex를 rowNode에 담음
        console.log(rowNode);// 콘솔출력
        itemRowNode = rowNode; // rownode를 itemRowNode 변수에 담음
      }
    },
    onRowSelected: function (event) { // 로우가 선택되었을때 메서드
      console.log(event); // 콘솔출력
    },
    onSelectionChanged(event) {// 클릭한 그리드가 다른 그리드로 클릭되었을때
      console.log("onSelectionChanged" + event); // 콘솔출력
    },
    components: {
      datePicker: getDatePicker("dueDateOfEstimate") // getDatePicker함수 dueDateOfEstimate를 datePicker에 저장. 바로밑에 나옴
    },
  }

  // O getDataPicker
  function getDatePicker(paramFmt) { // getDatePicker 함수선언
    let _this = this;
    _this.fmt = "yyyy-mm-dd";

    // function to act as a class
    function Datepicker() {
    }

    // gets called once before the renderer is used
    Datepicker.prototype.init = function (params) { // 렌더러를 사용하기전에 한번 호출되는 메서드

      // create the cell // 이하 옵션들
      this.autoclose = true;
      this.eInput = document.createElement('input');
      this.eInput.style.width = "100%";
      this.eInput.style.border = "0px";
      this.cell = params.eGridCell;
      this.oldWidth = this.cell.style.width;
      this.cell.style.width = this.cell.previousElementSibling.style.width;
      this.eInput.value = params.value;

      $(this.eInput).datepicker({
        dateFormat: _this.fmt // 날짜형식은 "yyyy-mm-dd"
      }).on('change', function () { // 바뀌었을때
        estDetailGridOptions.api.stopEditing(); // 수정금지후
        $(".datepicker-container").hide(); // datePicker 숨김
      });
    };

    // gets called once when grid ready to insert the element
    Datepicker.prototype.getGui = function () { // 그리드가 요소를 삽입할 준비가 되면 한 번 호출하는 메서드
      return this.eInput; //위의 eInput
    };

    // focus and select can be done after the gui is attached
    Datepicker.prototype.afterGuiAttached = function () { // gui를 붙인후 포커스와 선택을 할수있는 메서드
      this.eInput.focus();
      console.log(this.eInput.value);
    };

    // returns the new value after editing
    Datepicker.prototype.getValue = function () { // 편집후 새 값을 반환하는 메서드
      console.log(this.eInput);
      return this.eInput.value;
    };

    // any cleanup we need to be done here
    Datepicker.prototype.destroy = function () { // 모든걸 클린하게한후 수정정지하는 메서드
      estDetailGridOptions.api.stopEditing();
    };

    return Datepicker; // 반환
  }


  // O select estimateDetail
    // 견적상세버튼
  estimateDetailBtn.addEventListener("click", () => { // 견적상세버튼을 클릭했을때 메서드
	estDetailGridOptions.api.setRowData([]); // 빈 배열을 셋팅
    let selectedNodes = contractGridOptions.api.getSelectedNodes(); // 선택한 로우의 노드값을 selectedNodes에 저장
    if (selectedNodes == "") { // 만약 selectedNodes가 빈값이면
      Swal.fire({ // 스왈창 출력
        position: "top",
        icon: 'error',
        title: '체크 항목',
        text: '선택한 행이 없습니다.',
      })
      return;
    }
    else{ // 빈값이 아니면
    	let addList=[]; //addList라는 배열 선언
    	// console.log(selectedNodes[0].data);
	    estimateDetailList.map((unit, idx) => {//이 부분을 수정 해야 하네..
	        selectedNodes.forEach(function(e,i,c){
	           if (unit.estimateNo == e.data.estimateNo) {
	              addList.push(unit);
	        }
	      })
	    });
	    estDetailGridOptions.api.setRowData(addList); // addList를 다시 로우에 셋팅
    }

  })

  // O select contract type
  contractTypeList.addEventListener("click", () => { // 수주유형 버튼을 클릭했을때
    getListData("CT");//modal.js에서 getListDate 메서드 사용. 상세코드를 가져옴
    $("#listModalTitle").text("CONTRACT TYPE"); // 모달타이틀 이름을 contract type으로 설정
  }, {once: true});

  // O register contract
  contractBatchInsertBtn.addEventListener("click", () => { //수주등록 버튼을 클릭했을때
    let selectedNodes = contractGridOptions.api.getSelectedNodes();  // 선택한 로우의 노드값을 selectedNodes에 저장
    // o No seleted Nodes
    if (selectedNodes == "") { // 만약 selectedNodes가 빈값이면
      Swal.fire({ // 스왈창 출력
        position: "top",
        icon: 'error',
        title: '체크 항목',
        text: '선택한 행이 없습니다.',
      })
      return;
    }

    let newEstimateRowValues= contractGridOptions.api.getSelectedNodes(); //견적상세가 여러개가 있을 수 있으니 배열에 값을 담는다.
    let estimateNo=[]; //견적번호 담을 곳
    let contractType=[]; //수주 유형 담을 곳
    let contractRequester=[]; //수주 요청자 담을 곳
    let discription =[]; //비고 담을 곳
    let personCodeInCharge=[]; //견적 담당자 코드 담을 곳
    let contractDate=[];//수주 날짜 담을 곳- 이게 없으니까 프로시저를 돌릴 수가 없음.
    let customerCode=[]; //거래처코드 담을곳.
    
    let now = new Date(); // Date(); 는 밀리초로 나타내는 정수 값을 담습니다

    let today = now.getFullYear() + "-" + (now.getMonth() +1 ) + "-" +  now.getDate();
    // 오늘은 YYYY-MM-DD
    
    let noti = []; // 빈 배열 초기화


    newEstimateRowValues.map(selectedData => { // 선택된 로우가 map에 담는다
       estimateNo.push(selectedData.data.estimateNo); // 견적번호도 담고
       contractType.push(selectedData.data.contractType); // 수주유형도 담고
       personCodeInCharge.push("${sessionScope.empCode}"); // 견적담당자코드에 현재세션의 empcode를 담고
       contractDate.push(today); // 수주날짜에 오늘날짜를 담고(YYYY-MM-DD)
       customerCode.push(selectedData.data.customerCode); // 수주코드도 담고
       
       if(selectedData.data.contractRequester != null) // 수주요청자가 있으면
          contractRequester.push(selectedData.data.contractRequester); // 수주요청자를 담고
       else 
          contractRequester.push('null'); // 없으면 null
       
       if(selectedData.data.discription != null) // 비고가 null이 아니면
          description.push(selectedData.data.discription); // 비고도 넣는다
       else
          discription.push('null'); // null이면 null을 넣는다
       
       noti.push(estimateNo); // 견적번호를 noti라는 배열에 담는다
    });
    
    let resultArray={"estimateNo":estimateNo ,"contractType":contractType,"contractRequester":contractRequester,"personCodeInCharge":personCodeInCharge,"discription":discription,"contractDate":contractDate,"customerCode":customerCode};

    resultArray=JSON.stringify(resultArray); // JavaScript 값이나 객체를 JSON 문자열로 변환합니다


    if (selectedNodes[0].data.contractType == undefined) { // 수주유형이 정의되지 않았을때
      Swal.fire({ // 스왈창 출력
        position: "top",
        icon: 'error',
        title: '체크 항목',
        text: '수주유형을 입력해야합니다.',
      })
      return;
    }
     Swal.fire({ // 수주유형이 정의되었으면
      title: '수주 등록', // 스왈창 출력
      text:  noti[0] + "를 등록하시겠습니까?", // noti(견적번호)를 등록하시겠습니까?
      icon: 'warning',
      showCancelButton: true,
      confirmButtonColor: '#3085d6',
      cancelButtonColor: '#d33',
      cancelButtonText: '취소',
      confirmButtonText: '확인',
    }).then( (result) => {
      if (result.isConfirmed) { //확인버튼을 눌렀을때

      let xhr = new XMLHttpRequest();

      xhr.open('POST', "${pageContext.request.contextPath}/logisales/contract/new?" // 컨트롤러
          + "method=addNewContract" //  메서드사용
          + "&batchList=" + encodeURI(resultArray), // batchList도 uri인코딩 넘겨주고
          true);

      xhr.setRequestHeader('Accept', 'application/json'); // 헤더의 Accept에 application/json 셋팅

      xhr.send(); // 전송

      xhr.onreadystatechange = () => {

        if (xhr.readyState == 4 && xhr.status == 200) { // 성공일때

          // 초기화
          contractGridOptions.api.setRowData([]); // 각 옵션의 로우값을 빈배열로 셋팅
          estDetailGridOptions.api.setRowData([]);  // 각 옵션의 로우값을 빈배열로 셋팅

          let txt = xhr.responseText; // responseText를 txt에 담고
          txt = JSON.parse(txt); // JSON 문자열을 JavaScript 객체로 변환하여 txt 에 담음

          if (txt.errorCode < 0) {
            Swal.fire("오류", txt.errorMsg, "error"); // 스왈창 발생
            return;
          }
           console.log(txt.gridRowJson);
           let conDNStr=""; // 빈값 선언
          const conDetailList = Object.values(txt.gridRowJson); // 어레이라이크를 배열형태로 바꿔줌
            console.log("**********")
          console.log(conDetailList)
          for(let i=0;i<conDetailList.length;i++){
             if(conDetailList[i]!=undefined){
                conDNStr+=conDetailList[i].contractDetailNo;
                 conDNStr+="<br>"
                 console.log(conDetailList[i].contractDetailNo);
             }
          }
          console.log(conDNStr);
          console.log("수주 완료");
          let resultMsg =
              "<h5>< 수주 등록 내역 ></h5><br>"
              + txt.errorMsg+"<br>"
              +"수주 상세 번호 :"
              +   conDNStr
              + "<br>위와 같이 작업이 처리되었습니다";
          Swal.fire({
            title: "수주등록이 완료되었습니다.",
            html: resultMsg,
            icon: "success",
          });
        } 
      };
    }}) 
  });

  // O setup the grid after the page has finished loading
  document.addEventListener('DOMContentLoaded', () => {
      // 제일중요한 것!! // 브라우저가 로드되기 전에 밑에 옵션들로 셋팅된 myGrid,myGrid2가 먼저 로드된다.

    new agGrid.Grid(myGrid, contractGridOptions);
    new agGrid.Grid(myGrid2, estDetailGridOptions);
  })
</script>
</body>
</html>