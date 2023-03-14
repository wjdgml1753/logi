<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>

    <script type="text/javascript" src="https://code.jquery.com/jquery-3.5.0.js"></script>
    <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
    <script type="text/javascript" src="https://www.google.com/jsapi?autoload= {'modules':[{'name':'visualization','version':'1.1','packages': ['corechart']}]}"></script>
    <script>


        <%--------------분기별 매출--------------%>

        let salesQuaChart;

        google.charts.load("current", {'packages': ['corechart', 'bar']});
        google.charts.setOnLoadCallback(drawQuaChart);

        /* aJax로 받아오기*/
        $.ajax({
            url: '/sales/totalQuaChart'+
                "?method=getSalesQuaChart",
            dataType: "json",
            method: "GET",
            success: (data) => {
                console.log(data.gridRowJson);
                const salesData = data.gridRowJson;

                /* 받은 JSON을 구글 chart에 맞는 Array형성하기 */
                salesQuaChart = salesData.map((obj) => {
                    const datas = [];

                    datas.push(String(obj.qua));
                    datas.push(parseInt(obj.price));
                    datas.push(parseInt(obj.reverse));
                    return datas;

                });
                salesQuaChart.unshift(['분기', '분기별 매출','반품된 금액']);
                if (data.errorCode != 1) {
                    swal({
                        text: '데이터를 불러드리는데 오류가 발생했습니다.'
                            + data.errorMsg,
                        icon: 'error',
                    });
                    return;
                }
            }
        });

        google.charts.load("current", {'packages': ['bar']});
        google.charts.setOnLoadCallback(drawQuaChart);

        function drawQuaChart() {

            let data = new google.visualization.arrayToDataTable(salesQuaChart);
            let options = {
                chart: {
                    width: 1300,
                    title: '💴 서울IT물류센터 분기별 매출',
                    subtitle: '4분기 실적 이전 분기 대비 10%p 상승 목표'
                },

                titleTextStyle: {
                    fontName: 'Arial',
                    bold: false,
                    fontSize: 28,
                    color: '#494CA2'
                },
                animation: {
                    startup: true,
                    duration: 1000,
                    easing: 'out'
                },
                vAxis: {title:'단위',maxValue:35,minValue:15}, //vAxis는 y축에 대한 옵션이다.
            };

            let comboTotal = new google.charts.Bar(document.getElementById('total'));
            //그래프 format 형식 바꾸기
            comboTotal.draw(data, google.charts.Bar.convertOptions(options));
            let formatter = new google.visualization.NumberFormat({pattern: '###,###원'});
            formatter.format(data, 1);
            formatter.format(data, 2);
        }


        <%--------------품목별 재고량--------------%>

        let stockChart;      // 가공된 데이터를 넣을 전역변수

        google.charts.load('current', {'packages': ['corechart', 'bar']});
        google.charts.setOnLoadCallback(drawItemChart);

        /* ajax로 받아와보기 */
        $.ajax({
            url: '/stock/sto/chart'+
                "?method=getStockChart",
            dataType: "json",
            method: "GET",
            success: (data) => {
                if (data != null) {

                    console.log("????????"+JSON.stringify(data.gridRowJson));
                    stockData = data.gridRowJson;
                    /* 받은 JSON을 구글 chart에 맞는 Array형성하기 */
                    stockChart = stockData.map((obj) => {
                        const datas = [];
                        datas.push(obj.itemName);
                        datas.push(parseInt(obj.stockAmount));
                        datas.push(parseInt(obj.saftyAmount));
                        datas.push(parseInt(obj.allowanceAmount));
                        return datas;
                    })
                    stockChart.unshift(['품목', '전체 재고', '안전 재고', '사용가능 재고']);

                    if (data.errorCode != 1) {
                        swal({
                            text: '데이터를 불러드리는데 오류가 발생했습니다.'
                                + data.errorMsg,
                            icon: 'error',
                        });
                        return;
                    }
                }


            }
        })


        google.charts.load('current', {'packages': ['corechart', 'bar']});
        google.charts.setOnLoadCallback(drawItemChart);

        function drawItemChart() {

            let button = document.getElementById('change-chart');
            let chartDiv = document.getElementById('chart_div');
            let data = google.visualization.arrayToDataTable(stockChart);


            let classicOptions = {
                width: 1300,
                title: ' 🏭 품목별 현 재고량 - 전체재고, 안전재고, 가용재고 ',
                titleTextStyle: {
                    fontName: 'Arial',
                    bold: false,
                    fontSize: 30,
                    color: '#494CA2'
                },
                animation: {
                    startup: true,
                    duration: 1000,
                    easing: 'out'
                }

            };


            function drawClassicChart() {
                let classicChart = new google.visualization.ColumnChart(chartDiv);
                classicChart.draw(data, classicOptions);

            }

            drawClassicChart();
        }
    </script>
</head>
<body>

<div id="total" style="width: 79%; height: 40%; margin:0 auto"></div>
<%--<div id="itemChart" style="width: 100%; height: 50%;"></div>--%>
<div id="chart_div" style="width: 100%; height: 50%;"></div>

</body>
</html>