<%--<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="J2H" tagdir="/WEB-INF/tags" %>
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
        // O setting datapicker
        $(function () {
            // set default dates
            let start = new Date();
            start.setDate(start.getDate() - 365);
            // set end date to max one year period:
            let end = new Date(new Date().setYear(start.getFullYear() + 1));
            // o set searchDate
            $('#datepicker').datepicker({
                todayHiglght: true,
                autoHide: true,
                autoaShow: true,
            });
            // o set searchRangeDate
            $('#fromDate').datepicker({
                startDate: start,
                endDate: end,
                minDate: "-10d",
                todayHiglght: true,
                autoHide: true,
                autoaShow: true,
                // update "toDate" defaults whenever "fromDate" changes
            })
            $('#toDate').datepicker({
                startDate: start,
                endDate: end,
                todayHiglght: true,
                autoHide: true,
                autoaShow: true,
            })
            $('#fromDate').on("change", function () {
                //when chosen from_date, the end date can be from that point forward
                var startVal = $('#fromDate').val();
                $('#toDate').data('datepicker').setStartDate(startVal);
            });
            $('#toDate').on("change", function () {
                //when chosen end_date, start can go just up until that point
                var endVal = $('#toDate').val();
                $('#fromDate').data('datepicker').setEndDate(endVal);
            });

        });
    </script>
    <style>
        .fromToDate {
            margin-bottom: 7px;
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

        #amountList{
            display:none;
        }

        #reverseTypeList{
            display:none;
        }

        @media (min-width: 768px) {
            .modal-xl {
                width: 90%;
                max-width: 1200px;
            }
        }

        /*헤더 여백주기*/
        .ag-header-cell-label {
            justify-content: center;
        }

        .ag-cell-value {
            padding-left: 50px;
        }
    </style>
</head>
<body>

<article class="contract">
    <div class="contract__Title">
        <h5>📦 반품</h5>
        <div style="color: black;">
            <b>납품 날짜</b><br/>
        </div>

        <form autocomplete="off">
            <div class="fromToDate">
                <input type="text" id="fromDate" placeholder="YYYY-MM-DD 📅" size="15" style="text-align: center">
                &nbsp; ~ &nbsp;<input type="text" id="toDate" placeholder="YYYY-MM-DD 📅" size="15"
                                      style="text-align: center">
                &nbsp;&nbsp;&nbsp;&nbsp;<div class="button1" type="button" id="contractCandidateSearchButton">&nbsp;&nbsp;반품
                가능 조회&nbsp;&nbsp;
            </div>
                <div class="button2" type="button" id="ReturnRegistersButton">&nbsp;&nbsp;반품 처리&nbsp;&nbsp;</div>

            </div>

        </form>
        <button class="search" id="amountList" data-toggle="modal"
                data-target="#amountModal">수량
        </button>

        <input type="hidden" button id="mpsModalBtn"></div>
    </div>
</article>
<article class="contractMpsGrid">
    <div align="center">
        <div id="myGrid" class="ag-theme-balham" style="height:50vh; width:auto; text-align: center;"></div>
    </div>
</article>
<br>
<br>
<div>
    <h5><div class="button3" type="button" id="returnListSearchButton"></div>
        <div class="button4" type="button" id="deleteListButton"></div></h5>

</div>

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
                    <label style='font-size: 20px; margin-right: 10px'>반품수량</label>
                    <input type='text' id='returnAmountBox'  autocomplete="off"/><br>
                    <label for='unitPriceOfReturnBox' style='font-size: 20px; margin-right: 10px'>반품단가</label>
                    <input type='text' id='unitPriceOfReturnBox' autocomplete="off" readonly/><br>
                    <label for='sumPriceOfReturnBox' style='font-size: 20px; margin-right: 30px'>합계액  </label>
                    <input type="text" id='sumPriceOfReturnBox' autocomplete="off"/>
                </div>
            </div>
            <div class="modal-footer"> <!-- 모달 아래-->
                <button type="button" id ="amountSave" class="btn btn-default" data-dismiss="modal">Save</button>
                <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
            </div>
        </div>
    </div>
</div>

<J2H:listModal/>

<script>
    const myGrid = document.querySelector("#myGrid");
    const myGrid2 = document.querySelector("#myGrid2");
    const searchByDateRadio = document.querySelector("#searchByDateRadio");
    const startDatePicker = document.querySelector("#fromDate");
    const endDatePicker = document.querySelector("#toDate");
    const returnDate = document.querySelector("#returnDate");
    const amountList = document.querySelector('#amountList');
    const reverseTypeList = document.querySelector("#reverseTypeList");


    // O customerList Grid
    let Column = [
        {
            headerName: "납품번호", field: "deliveryNO", suppressSizeToFit: true, /*headerCheckboxSelection: true,*/
           /* headerCheckboxSelectionFilteredOnly: true,*/
            checkboxSelection: true, width: 200
        },

        {headerName: "납품일자", field: "deliveryDate", width: 250},

        {
            headerName: "반품일자", field: "returnDate", editable: true, cellRenderer: function (params) {
                if (params.value == null) {
                    params.value = "YYYY-MM-DD";
                }
                return '📅 ' + params.value;
            }, cellEditor: 'datePicker1'
        },

        {headerName: "거래처명", field: "customerName"},


        {headerName: "품목코드", field: "itemCode"},

        {headerName: "품목이름", field: "itemName"},

        {headerName: "반품수량 ", field: "returnUnit", width: 130},

        {headerName: "반품단가", field: "returnUnitPrice", width: 200},

        {headerName: "반품 총단가", field: "returnSumPrice"},

        // {headerName: "비고", field: "description", editable: true, hide: false, width: 200},
    ];
    // event.colDef.field
    let rowData = [];
    let contractMpsRowNode;
    let itemRowNode;
    // 첫번째 그리드옵션
    let returnAbleListGridOptions = {
        defaultColDef: {
            flex: 1,
            minWidth: 100,
            resizable: true,
        },
        columnDefs: Column,
        rowSelection: 'single',
        rowData: rowData,
        getRowNodeId: function (data) {
            return data.deliveryNO;
        },
        defaultColDef: {editable: false, resizable: true},
        overlayNoRowsTemplate: "반품 가능한 리스트가 없습니다.",
        onGridReady: function (event) {// onload 이벤트와 유사 ready 이후 필요한 이벤트 삽입한다.
            event.api.sizeColumnsToFit();
        },
        onGridSizeChanged: function (event) {
            event.api.sizeColumnsToFit();
        },

        onRowClicked: function (event) {

            contractMpsRowNode = event;
        },
        getSelectedRowData() {
            let selectedNodes = this.api.getSelectedNodes();
            let selectedData = selectedNodes.map(node => node.data);
            return selectedData;
        },
        getSelectedRowDatas() {
            const selectedDatas = this.api.getSelectedRows();
            return selectedDatas;
        },
        onCellDoubleClicked: (event) => {
            if (event != undefined) {

                let rowNode = returnAbleListGridOptions.api.getDisplayedRowAtIndex(event.rowIndex);  //getDisplayedRowAtIndex: 보이는 줄의 인덱스 얻기
                itemRowNode = rowNode;
                console.log("#########"+itemRowNode.data.customerName);
            }

            if (event.colDef.field == "returnUnit") {
                amountList.click();
            }

            if (event.colDef.field == "reverseTypeName") { // 칼럼명이  contractTypeName 이면
                console.log("수주유형분류 클릭"); // 콘솔출력 하고
                reverseTypeList.click(); // 수주유형분류 를 클릭한다.
            }
        },
        components: {
            datePicker1: getDatePicker()
        }
    }


    ////////////////////////////////////반품 가능 조회/////////////////////////////////////////////////


    const contractCandidateSearchBtn = document.querySelector("#contractCandidateSearchButton");

    contractCandidateSearchBtn.addEventListener("click", () => {
        // o contractDate or dueDateOfContract

        let startDate = startDatePicker.value;
        let endDate = endDatePicker.value;

        // o detect error
        if (startDate == "" || endDate == "") {
            Swal.fire("입력", "시작일자와 종료일자를 입력하셔야합니다.", "info");
            return;
        }
        console.log(startDate);
        console.log(endDate);
        ableContractInfo = {"startDate": startDate, "endDate": endDate};
        ableContractInfo = encodeURI(JSON.stringify(ableContractInfo));
        // o reset Grid

        // o ajax
        let xhr = new XMLHttpRequest();
        xhr.open('GET', "${pageContext.request.contextPath}/sales/ReturnAbleList"
            + "?method=getReturnAbleList"
            + "&ableContractInfo=" + ableContractInfo,
            true);

        xhr.setRequestHeader('Accept', 'application/json');
        xhr.send();
        console.log(xhr + "xhr")
        console.log(xhr);
        xhr.onreadystatechange = () => {
            if (xhr.readyState == 4 && xhr.status == 200) {
                let txt = xhr.responseText;
                txt = JSON.parse(txt);
                console.log(txt);
                let gridRowJson = txt.gridRowJson;  // gridRowJson : 그리드에 넣을 json 형식의 data
                if (gridRowJson == "") {
                    swal.fire("등록가능한 반품이 없습니다.");
                    return;
                }

                console.log("girdRowJson입니다")
                console.log(gridRowJson);
                returnAbleListGridOptions.api.setRowData(gridRowJson);
            }
        }

    });


    /////////////////////////////////////////반품등록///////////////////////////////////////////


    const returnBtn = document.querySelector("#ReturnRegistersButton");

    returnBtn.addEventListener("click", () => {
        //입력받은 재고사용량가지고 DB로 가자

        let selectedNodes = returnAbleListGridOptions.api.getSelectedNodes();
        // o No seleted Nodes
        if (selectedNodes == "") {
            Swal.fire({
                position: "top",
                icon: 'error',
                title: '체크 항목',
                text: '선택된 반품계획이 없습니다.',
            })
            return;
        }
       /* else {
            for (let node of selectedNodes) {
                if (node.data.returnDate == "") {
                    Swal.fire({
                        position: "top",
                        icon: 'error',
                        title: '체크 항목',
                        text: '반품일자를 선택 해 주세요.',
                    })
                    return;
                }
            }
        }*/

        let deliveryNO; // 수주상세 일련번호
        let itemCode; //수주유형
        let returnUnit; // 재고사용량



        selectedNodes.map(selectedData => {
            deliveryNO=selectedData.data.deliveryNO;
            itemCode=selectedData.data.itemCode;
            returnUnit=selectedData.data.returnUnit;

            console.log("$$"+selectedData.data.deliveryNO);
            console.log("##"+selectedData.data.returnUnit);


        });

        let resultArray={"deliveryNO":deliveryNO ,"itemCode":itemCode,"returnUnit":returnUnit};

        resultArray=JSON.stringify(resultArray);

        console.log("$$$$$$$$$$"+resultArray);
        Swal.fire({
            title: '반품계획 등록',
            text:  deliveryNO + "를 등록하시겠습니까?",
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#3085d6',
            cancelButtonColor: '#d33',
            cancelButtonText: '취소',
            confirmButtonText: '확인',
        }).then( (result) => {
            if (result.isConfirmed) {
                let xhr = new XMLHttpRequest();

                //let today = now.getFullYear() + "-" + (now.getMonth() +1 ) + "-" +  now.getDate();
                xhr.open('POST', "${pageContext.request.contextPath}/sales/ReturnRegister?"
                    + "method=registerReturn"
                    //+ "&batchList=" + encodeURI(resultArray),
                    ,true);
                xhr.setRequestHeader('Content-Type', 'application/json');
                xhr.send(resultArray);
                xhr.onreadystatechange = () => {
                    if (xhr.readyState == 4 && xhr.status == 200) {

                        // 데이터 확인
                        let txt = xhr.responseText;
                        txt = JSON.parse(txt);

                        if (txt.errorCode < 0) {
                            Swal.fire("오류", txt.errorMsg, "error");
                            return;
                        }
                        // 초기화
                        returnAbleListGridOptions.api.setRowData([]);


                        Swal.fire({
                            title: "반품등록이 완료되었습니다.",
                            html:"납품 상세 코드 : " + deliveryNO,
                            icon: "success",
                        });
                    }
                };
            }})
    });




    ///////////////////////////////////////////////////////////////////////////
    // O getDataPicker
    function getDatePicker(paramFmt) {
        let _this = this;
        _this.fmt = "yyyy-mm-dd";


        // function to act as a class
        function Datepicker() {
        }

        Datepicker.prototype.init = function (params) {
            // create the cell
            this.autoclose = true;
            this.eInput = document.createElement('input');
            this.eInput.style.width = "100%";
            this.eInput.style.border = "0px";
            this.cell = params.eGridCell;
            this.oldWidth = this.cell.style.width;
            this.cell.style.width = this.cell.previousElementSibling.style.width;
            this.eInput.value = params.value;
            console.log(paramFmt);
            // Setting startDate and endDate
            let _startDate = new Date();
            let _endDate;
            let year = _startDate.getFullYear();              //yyyy
            let month = (1 + _startDate.getMonth());          //M
            month = month >= 10 ? month : '0' + month;  //month 두자리로 저장
            let day = _startDate.getDate();                   //d
            day >= 10 ? day : '0' + day;          //day 두자리로 저장
            _startDate = year + '' + month + '' + day;
            _endDate = _startDate


            $(this.eInput).datepicker({
                startDate: _startDate,
                endDate: _endDate,
                dateFormat: _this.fmt
            }).on('change', function () {
                returnAbleListGridOptions.api.stopEditing();
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

        // any cleanup we need to be done here
        Datepicker.prototype.destroy = function () {
            returnAbleListGridOptions.api.stopEditing();
        };
        return Datepicker;
    }

    // O setup the grid after the page has finished loading
    document.addEventListener('DOMContentLoaded', () => {
        new agGrid.Grid(myGrid, returnAbleListGridOptions);
    })

    //--------------------------------------모달---------------------------------------

    amountList.addEventListener('click', () => { // amountList 을 클릭했을 때 실행되는 메서드
        (returnAbleListGridOptions.getSelectedRowData()).forEach((val)=>{  //val = 선택한 row하나

            document.querySelector("#returnAmountBox").value=val.returnUnit;
            document.querySelector("#unitPriceOfReturnBox").value=val.returnUnitPrice;
            document.querySelector("#sumPriceOfReturnBox").value=
                document.querySelector("#returnAmountBox").value*document.querySelector("#unitPriceOfReturnBox").value;
        })
    });

    $("#amountModal").on('show.bs.modal', function () {

            $('#returnAmountBox, #unitPriceOfReturnBox').on("keyup", function () {
                let sum =  parseInt($('#returnAmountBox').val()) *  parseInt($('#unitPriceOfReturnBox').val());  //sum에는 견적수량과 견적단과가 곱해진 값이 들어간다.
                $('#sumPriceOfReturnBox').val(sum);  //  그러면 합계액에는 위의 sum이 담김
            });
        }
    );

    document.querySelector("#amountSave").addEventListener("click", () => {  //modal창 밑에 있는 Save에 걸리는 이벤트
        if (itemRowNode == undefined) {   return;}
        returnAbleListGridOptions.api.stopEditing();
        itemRowNode.setDataValue("returnUnit", $('#returnAmountBox').val());
        itemRowNode.setDataValue("returnUnitPrice", $('#unitPriceOfReturnBox').val());
        itemRowNode.setDataValue("returnSumPrice", $('#sumPriceOfReturnBox').val());
        let newData = itemRowNode.data; // 바로 위에서 받아온 견적수량,견적단가,합계액의 데이터들이 newData라는 변수명에 담긴다.
        itemRowNode.setData(newData);  // 그러면 itemRowNode에 set해준다.  그 다음 일괄저장으로 출발
    })
</script>
</body>
</html>