<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>스크롤 페이징 템플릿</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/main1.css" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/main2.css" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/main3.css" />
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chartjs-plugin-datalabels@2"></script>
<script src="//code.jquery.com/jquery-migrate-3.5.0.min.js"></script>
<script src="https://code.jquery.com/ui/1.13.2/jquery-ui.min.js"></script>
</head>
<body>
<header>
        <table class='header-table'>
        <tr>
            <td id="one"><p class="current_class navi">Main</p></td>
        </tr>
        <tr>
        	<td id="two"><p class="navi">View Details</p></td>
        </tr>
        <tr>
        	<td id="three"><p class="navi">Download</a></p></td>
        </tr>
        </table>
</header>
<main>
<div id='firstdiv' class='pagediv'>
<div id="main1">
	<div id="menu">
		<div class="menu" id="seoul" data-citycode="8"><h2>서울</h2><p>0GWh</p></div>
		<div class="menu" id="busan" data-citycode="7"><h2>부산</h2><p>0GWh</p></div>
		<div class="menu" id="daegu" data-citycode="5"><h2>대구</h2><p>0GWh</p></div>
		<div class="menu" id="incheon" data-citycode="11"><h2>인천</h2><p>0GWh</p></div>
		<div class="menu" id="daejeon" data-citycode="6"><h2>대전</h2><p>0GWh</p></div>
		<div class="menu" id="gwangju" data-citycode="4"><h2>광주</h2><p>0GWh</p></div>
		<div class="menu" id="ulsan" data-citycode="10"><h2>울산</h2><p>0GWh</p></div>
		<div class="menu" id="sejong" data-citycode="9"><h2>세종</h2><p>0GWh</p></div>
		<div class="menu" id="jeju" data-citycode="14"><h2>제주도</h2><p>0GWh</p></div>
		<div class="menu" id="gyeonggi" data-citycode="1"><h2>경기도</h2><p>0GWh</p></div>
		<div class="menu" id="gyeongnam" data-citycode="2"><h2>경상남도</h2><p>0GWh</p></div>
		<div class="menu" id="gyeongbuk" data-citycode="3"><h2>경상북도</h2><p>0GWh</p></div>
		<div class="menu" id="chungnam" data-citycode="15"><h2>충청남도</h2><p>0GWh</p></div>
		<div class="menu" id="chungbuk" data-citycode="16"><h2>충청북도</h2><p>0GWh</p></div>
		<div class="menu" id="jeonnam" data-citycode="12"><h2>전라남도</h2><p>0GWh</p></div>
		<div class="menu" id="jeonbuk" data-citycode="13"><h2>전라북도</h2><p>0GWh</p></div>
		<div class="menu" id="gangwon" data-citycode="0"><h2>강원도</h2><p>0GWh</p></div>
	</div>
	<div id="main">
		<div id="prevUsageBox">
			<h2>전년도 대비 사용량</h2>
			<canvas id="prevUsageChart" width="870" height="380"></canvas>
		</div>
		<div id="monthUsageBox">
			<h1 id="mainH1">서울 2025년 전력 사용량 분석</h1>
			<div id="chartBox">
				<div id="chart4Box"><canvas id="nowUsageChart" width="200" height="200"></canvas></div>
				<div id="chart5Box"><canvas id="nextUsageChart" width="200" height="200"></canvas></div>
				<div id="nowMonthBox1"><h2 id="nowH21">월 사용량 예측</h2><h2 id="nowH22">0000.00 GWh</h2></div>
				<div id="nowMonthBox2"><h2 id="nowH23">월 사용량 예측</h2><h2 id="nowH24">0000.00 GWh</h2></div>
			</div>
		</div>
		<div id="sMonthUsageBox">
			<h2>최근 6개월 사용량</h2>
			<canvas id="sMonthUsageChart" width="670" height="155"></canvas>
			<h2>최근 5년 6월 사용량</h2>
			<canvas id="monthUsageChart" width="670" height="155"></canvas>
		</div>
		<div id="weatherBox">
			<h2>날씨 예보 : 전력 사용량 예측</h2>
			<table id="weatherTable">
    			<thead>
      				<tr>
        				<th>날짜</th>
						<th>날씨</th>
        				<th>최저기온</th>
        				<th>최고기온</th>
        				<th>전기사용량 예측</th>
      				</tr>
    			</thead>
    			<tbody>
      				<tr id="day1">
        				<td>6/25 (수)</td>
        				<td>☁️ 흐림</td>
        				<td>0℃</td>
        				<td>0℃</td>
        				<td>감소 예상 ↓</td>
      				</tr>
      				<tr id="day2">
        				<td>6/26 (목)</td>
        				<td>🌨️🌧️ 비/눈</td>
        				<td>0℃</td>
        				<td>0℃</td>
        				<td>증가 예상 ↑</td>
      				</tr>
      				<tr id="day3">
        				<td>6/27 (금)</td>
        				<td>☁️ 흐림</td>
        				<td>0℃</td>
        				<td>0℃</td>
        				<td>유지 예상 →</td>
      				</tr>
      				<tr id="day4">
        				<td>6/28 (토)</td>
        				<td>☁️ 흐림</td>
        				<td>0℃</td>
        				<td>0℃</td>
        				<td>증가 예상 ↑</td>
      				</tr>
    			</tbody>
  			</table>
		</div>
	</div>
</div>
</div>
<div id='seconddiv' class='pagediv'>
<div class="fullwide">
	<div class='middle left'>
		<div class="middle map">
			<object class='svg-map' type="image/svg+xml"
				data="${pageContext.request.contextPath}/resources/static/svg/southKoreaLow5.svg"> 브라우저가 SVG를 지원하지 않습니다. </object>
			<img
				src="${pageContext.request.contextPath}/resources/static/southKoreaLow5.png"
				class="oversvg">
		</div>
		<div class='left-down'>
			<div id="yearButtons" class="year-buttons">
			<table id='year-table'>
				<tr>
				<td><button type="button" data-year="2015" class="year-btn">2015</button></td>
				<td><button type="button" data-year="2016" class="year-btn">2016</button></td>
				<td><button type="button" data-year="2017" class="year-btn">2017</button></td>
				<td><button type="button" data-year="2018" class="year-btn">2018</button></td>
				</tr>
				<tr>
				<td><button type="button" data-year="2019" class="year-btn">2019</button></td>
				<td><button type="button" data-year="2020" class="year-btn">2020</button></td>
				<td><button type="button" data-year="2021" class="year-btn">2021</button></td>
				<td><button type="button" data-year="2022" class="year-btn">2022</button></td>
				</tr>
				<tr>
				<td><button type="button" data-year="2023" class="year-btn">2023</button></td>
				<td><button type="button" data-year="2024" class="year-btn">2024</button></td>
				<td><button type="button" data-year="2025" class="year-btn">2025</button></td>
				<td><button type="button" data-year="2026" class="year-btn">2026</button></td>
				</tr>
				<tr>
				<td><button type="button" data-year="2027" class="year-btn">2027</button></td>
				<td><button type="button" data-year="2028" class="year-btn">2028</button></td>
				<td><button type="button" data-year="2029" class="year-btn">2029</button></td>
				<td><button type="button" data-year="2030" class="year-btn">2030</button></td>
				</tr>
			</table>
			</div>
		</div>
	</div>
	<div class='up'>
		<div class="middle chart">
			<h2 id="usageTitle" class='div-main-h2'>${year}년 ${region} 월별 전력 사용량 그래프</h2> <label class='annotation'>(단위/GWh)</label>
			<div id="selectBox">
				<label class='select-label2'>도시:</label> 
				<select id="citySelect" class='select2' style="color:black;">
					<option value="강원도">강원도</option>
					<option value="경기도">경기도</option>
					<option value="경상남도">경상남도</option>
					<option value="경상북도">경상북도</option>
					<option value="광주">광주</option>
					<option value="대구">대구</option>
					<option value="대전">대전</option>
					<option value="부산">부산</option>
					<option value="서울">서울</option>
					<option value="세종">세종</option>
					<option value="울산">울산</option>
					<option value="인천">인천</option>
					<option value="전라남도">전라남도</option>
					<option value="전라북도">전라북도</option>
					<option value="제주도">제주도</option>
					<option value="충청남도">충청남도</option>
					<option value="충청북도">충청북도</option>
				</select> &nbsp; <label for="predictionType" class='select-label2'>모델&nbsp;<input type='button' value='?' class='explain-button' style="color:black;"> :</label>
				
				<select id="predictionType" class='select2' style="color:black;">
					<option value="short">단기 모델</option>
					<option value="long">장기 모델</option>
				</select>
				
				<div id="modelExplainBox" class="explain-box" style="display:none; color:black;">
    				• <b style="color:black;">단기 모델</b> : 직전 1년치 월별 사용량을 입력값으로 삼아<br>다음 1년을 예측합니다. 예상 정확도가 높습니다.<br>
    				• <b style="color:black;">장기 모델</b> : 시·도별 월별 전력 사용량으로 장기적인<br>추세를 예측합니다. 예상 정확도는 단기 모델에 비해 낮습니다.<br>
				</div>
			</div>
			<canvas id="usageChart" width="600px" height="370px"></canvas>
		</div>
		<div class='middle down'>
			<h2 id='totalTitle' class='div-main-h2'>2015년 강원도 총 전력 사용량</h2> <label class='annotation'>(단위/GWh)&nbsp;&nbsp;&nbsp;&nbsp; <br>※총 예측 사용량은 그 해의 실제 사용량이 존재하지 않으면 그 해 전체, 존재하면 존재하는 달 까지만 합산됩니다.</label><br>
			<div id='t-text-container'>
				<div class='t-text tt1'>
				<h2 id='totalUse' class='t-h2'></h2>
					총 전력 사용량
				</div>
				<div class='t-text tt2'>
					<h2 id='totalPre' class='t-h2'></h2>
					총 예측 사용량
				</div>
			</div>
			<canvas id="totalChart" width="600px" height="130px"></canvas>
		</div>
	</div>
		<div class="middle right">
			<div class='left-up'>
				<p class="donut-title">도시별 총 전력<br>실제 사용량 비교</p>
  				<canvas id="usageDonutChart" width="460px" height="465px"></canvas>
			</div>
			<div class='left-up'>
				<p class="donut-title">도시별 총 전력<br>예측 사용량 비교</p>
  				<canvas id="usageDonutChart2" width="460px" height="465px"></canvas>
			</div>
		</div>
	</div>
</div>

<!-- 3페이지 -->
<div id='thirddiv' class="pagediv">
<div id="page1" class="container">

    <!-- 조회 UI -->
    <div id="searchForm">
        <!-- 연도, 지역, 그래프 표시 가로 배치 -->
        <div class="form-group flex-row" style="display: flex; align-items: center; gap: 20px;">
            <!-- 연도 선택 -->
            <div class="multi-select" tabindex="0">
                <div class="select-box">연도 선택</div>
                <div class="checkbox-list">
                    <c:forEach var="y" begin="2015" end="2030">
                        <label class="checkbox-item">
                            <input type="checkbox" name="years" value="${y}" 
                                ${selectedYears != null && selectedYears.contains(y.toString()) ? "checked" : ""} />
                            ${y}년
                        </label>
                    </c:forEach>
                </div>
            </div>

            <!-- 지역 선택 -->
            <div>
                <label>지역 선택:</label>
                <select name="region">
    <option value="" disabled selected>-- 지역을 선택하세요 --</option>
    <option value="all">전체</option>
    <c:forEach var="r" items="${regionList}">
        <option value="${r}">${r}</option>
    </c:forEach>
</select>
            </div>

            <!-- 그래프 표시 -->
            <div>
                <label>그래프 표시:</label>
                <select id="graphToggle" onchange="toggleGraphVisibility()">
                    <option value="both">모두 표시</option>
                    <option value="usage">실제 사용량만 표시</option>
                    <option value="predicted">예측 사용량(단기 + 장기)만 표시</option>
                    <option value="predicted_short">단기 예측 사용량만 표시</option>
                    <option value="predicted_long">장기 예측 사용량만 표시</option>
                </select>
            </div>
        </div>

        <div class="form-group">
            <button id="searchBtn" type="button">조회</button>
            <button id="downloadBtn" type="button">그래프 다운로드</button>
        </div>
    </div>

    <!-- 선택 정보 표시 -->
    <div class="info-group">
        <div class="info-card">
            <h3>선택한 정보</h3>
            <p id="selectedYearsDisplay"><strong>선택한 연도:</strong> 연도가 선택되지 않았습니다.</p>
            <p id="selectedRegionDisplay"><strong>선택한 지역:</strong> 선택한 지역이 없습니다.</p>
        </div>
    </div>

    <!-- 차트 영역 -->
    <div class="chart-row three-charts">
        <!-- 단기 예측 -->
        <div class="chart-container" style="position: relative;">
            <h3>단기 예측 전력 사용량 미리보기(실제 사용량 포함)</h3>
            <canvas id="predictedChart"></canvas>
            <div id="predictedChartOverlay" class="chart-overlay">지역, 연도를 선택해주세요.</div>
        </div>

        <!-- 장기 예측 -->
        <div class="chart-container" style="position: relative;">
            <h3>장기 예측 전력 사용량 미리보기(실제 사용량 포함)</h3>
            <canvas id="longTermChart"></canvas>
            <div id="longTermChartOverlay" class="chart-overlay">지역, 연도를 선택해주세요.</div>
        </div>

        <!-- 실제 사용량 -->
        <div class="chart-container" style="position: relative;">
            <div class="chart-header" 
                style="display: flex; align-items: center; justify-content: space-between; margin-bottom: 10px; padding: 5px 20px 0 10px;">
                <h3 style="margin: 0;">월별 전력 사용량 미리보기</h3>
                <div class="form-group" style="margin: 0;">
                    <label for="chartType" style="margin-right: 8px;">그래프 타입:</label>
                    <select id="chartType" onchange="updateChartType()">
                        <option value="bar">막대 그래프</option>
                        <option value="line">선형 그래프</option>
                    </select>
                </div>
            </div>
            <canvas id="usageChart"></canvas>
            <div id="usageChartOverlay" class="chart-overlay">실제 전력 사용량이 없습니다.</div>
        </div>
    </div>
</div>
</div>
</main>
<script>
  Chart.register(ChartDataLabels);
</script>
<script src="${pageContext.request.contextPath}/resources/js/main1.js"></script>
<script id="initData"
        data-year="<c:out value='${year != null ? year : "2015"}'/>"
        data-region="<c:out value='${region != null ? region : "서울"}'/>">
        const base = '${pageContext.request.contextPath}';
</script>
<script src="${pageContext.request.contextPath}/resources/js/main2.js"></script>
<!-- 3페이지 스크립트 -->
<script>
//==== 전역 변수 및 초기값 ====
let usageChart = null;      // 실제 사용량 차트 객체
let predictedChart = null;  // 단기 예측 차트 객체
let longTermChart = null;   // 장기 예측 차트 객체
let chartType = 'bar';      // 기본 차트 타입
let globalChartData = [];   // 서버에서 받아온 전체 차트 데이터
let allDataMap = {};

const cityEncodeMap = {
  "강원도": 0, "경기도": 1, "경상남도": 2, "경상북도": 3, "광주": 4,
  "대구": 5, "대전": 6, "부산": 7, "서울": 8, "세종": 9,
  "울산": 10, "인천": 11, "전라남도": 12, "전라북도": 13, "제주도": 14,
  "충청남도": 15, "충청북도": 16
};

const monthLabels = [
  '1월', '2월', '3월', '4월', '5월', '6월',
  '7월', '8월', '9월', '10월', '11월', '12월'
];
console.log(document.querySelector('select[name="region"]').value);
// ==== 함수들 ====

// 차트 타입 변경 시 호출
function updateChartType() {
  chartType = document.getElementById('chartType').value;
  if (usageChart) {
    usageChart.destroy();
    drawActualUsageChart(globalChartData || []);
  }
}

// 그래프 표시 옵션에 따라 차트 표시/숨김 처리
function toggleGraphVisibility() {
  const container = document.getElementById('page1');
  const selected = container.querySelector('#graphToggle').value;

  const usageContainer = container.querySelector('#usageChart').parentElement;
  const predictedContainer = container.querySelector('#predictedChart').parentElement;
  const longTermContainer = container.querySelector('#longTermChart').parentElement;

  usageContainer.style.display = 'none';
  predictedContainer.style.display = 'none';
  longTermContainer.style.display = 'none';

  if (selected === 'usage') {
    usageContainer.style.display = 'block';
  } else if (selected === 'predicted') {
    predictedContainer.style.display = 'block';
    longTermContainer.style.display = 'block';
  } else if (selected === 'predicted_short') {
    predictedContainer.style.display = 'block';
  } else if (selected === 'predicted_long') {
    longTermContainer.style.display = 'block';
  } else if (selected === 'both') {
    usageContainer.style.display = 'block';
    predictedContainer.style.display = 'block';
    longTermContainer.style.display = 'block';
  }

  const visibleCharts = [usageContainer, predictedContainer, longTermContainer].filter(c => c.style.display === 'block');
  const count = visibleCharts.length;

  if (count === 1) {
    visibleCharts[0].style.flexBasis = '100%';
    visibleCharts[0].style.maxWidth = '100%';
  } else if (count === 2) {
    visibleCharts.forEach(c => {
      c.style.flexBasis = '49%';
      c.style.maxWidth = '49%';
    });
  } else if (count === 3) {
    visibleCharts.forEach(c => {
      c.style.flexBasis = '32%';
      c.style.maxWidth = '32%';
    });
  }

  [usageContainer, predictedContainer, longTermContainer].forEach(c => {
    if (c.style.display !== 'block') {
      c.style.flexBasis = '';
      c.style.maxWidth = '';
    }
  });
}

// 실제 사용량 차트 그리기
function drawActualUsageChart(chartData) {
  const container = document.getElementById('page1');
  const canvas = container.querySelector('#usageChart');
  const overlay = container.querySelector('#usageChartOverlay');

  const selectedYears = Array.from(container.querySelectorAll('input[name="years"]:checked')).map(input => input.value);
  const selectedRegion = container.querySelector('select[name="region"]').value;

  if (!selectedRegion || selectedRegion === '' || selectedYears.length === 0) {
    canvas.classList.add('blur');
    overlay.textContent = '지역,연도를 선택해주세요.';
    overlay.classList.add('show');
    if (usageChart) {
      usageChart.destroy();
      usageChart = null;
    }
    return;
  }

  const filteredData = chartData.filter(item =>
    item.region === selectedRegion &&
    selectedYears.includes(String(item.year)) &&
    item.monthlyData &&
    item.monthlyData.some(value => value != null)
  );

  const colors = [
    'rgba(255, 99, 132, 0.5)',
    'rgba(54, 162, 235, 0.5)',
    'rgba(255, 206, 86, 0.5)',
    'rgba(75, 192, 192, 0.5)',
    'rgba(153, 102, 255, 0.5)',
    'rgba(255, 159, 64, 0.5)'
  ];

  const datasets = filteredData.map((item, idx) => ({
    label: item.year + "년 " + item.region,
    data: item.monthlyData,
    backgroundColor: colors[idx % colors.length],
    borderColor: colors[idx % colors.length].replace('0.5', '1'),
    borderWidth: 2,
    type: chartType,
    fill: chartType === 'line' ? false : true,
    tension: 0.3
  }));

  if (usageChart) usageChart.destroy();

  if (datasets.length === 0) {
    canvas.classList.add('blur');
    overlay.textContent = '실제 전력 사용량이 없습니다.';
    overlay.classList.add('show');
    usageChart = null;
    return;
  } else {
    canvas.classList.remove('blur');
    overlay.classList.remove('show');
  }

  const ctx = canvas.getContext('2d');
  usageChart = new Chart(ctx, {
    type: chartType,
    data: {
      labels: monthLabels,
      datasets: datasets
    },
    options: {
      responsive: true,
      maintainAspectRatio: false,
      plugins: {
        title: { display: true, text: '월별 전력 사용량' },
        legend: { position: 'top' }
      },
      scales: {
        y: {
          beginAtZero: true,
          title: { display: true, text: '사용량 (GWh)' }
        }
      }
    }
  });
}

// 전년도 사용량 가져오기
async function fetchPrevUsage(region, year, month) {
  const url = new URL('/getPrevUsage', window.location.origin);
  url.searchParams.append('region', region);
  url.searchParams.append('year', year);
  url.searchParams.append('month', month);

  try {
    const res = await fetch(url.toString());
    if (!res.ok) throw new Error(`HTTP error! status: ${res.status}`);

    // XML 텍스트로 받기
    const text = await res.text();

    // XML 파싱
    const parser = new DOMParser();
    const xmlDoc = parser.parseFromString(text, "application/xml");

    // <usage> 태그 값을 가져오기
    const usageNode = xmlDoc.querySelector("usage");
    const usage = usageNode ? parseFloat(usageNode.textContent) : 0;

    return usage;
  } catch (e) {
    console.error("[prevUsage fetch error]", e);
    return 0;
  }
}

// 단기 예측 API 호출
async function fetchShortTermPrediction(year, region, actualMonthlyData) {

  const cityEncoded = cityEncodeMap[region] ?? 0;
  const preds = [];

  for (let month = 1; month <= 12; month++) {

    const prevYear = year - 1;
    const prev_usage = await fetchPrevUsage(region, prevYear, month);

    const requestBody = {
      city_encoded: cityEncoded,
      year: year - 2014,
      month: month,
      prev_usage: prev_usage
    };

    try {
      const res = await fetch('http://localhost:8000/model/short', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(requestBody)
      });
      const json = await res.json();


      preds.push(json.prediction);

    } catch (e) {
      preds.push(null);
    }
  }

  return preds;
}



// 단기 예측 차트 그리기
async function drawPredictedUsageChart(chartData) {
const selectedYears = Array.from(document.querySelectorAll('input[name="years"]:checked')).map(input => input.value);
const selectedRegion = document.querySelector('select[name="region"]').value;

const canvas = document.getElementById('predictedChart');
const predictedContainer = canvas.parentElement;
const overlayId = 'predictedChartOverlay';
let overlay = document.getElementById(overlayId);

if (!overlay) {
 overlay = document.createElement('div');
 overlay.id = overlayId;
 overlay.className = 'chart-overlay';
 predictedContainer.appendChild(overlay);
}

if (!selectedRegion || selectedRegion === "" || selectedYears.length === 0) {
 overlay.textContent = '지역,연도를 선택해주세요.';
 overlay.classList.add('show');
 canvas.classList.add('blur');
 if (predictedChart) {
   predictedChart.destroy();
   predictedChart = null;
 }
 return;
}

// 2026년 3월까지 예측 가능 체크
if (selectedYears.some(year => Number(year) > 2027) || selectedYears.includes('2027')) {
 overlay.textContent = '2026년 3월까지 예측이 가능합니다.';
 overlay.classList.add('show');
 canvas.classList.add('blur');
 if (predictedChart) {
   predictedChart.destroy();
   predictedChart = null;
 }
 return;
}

overlay.classList.remove('show');
canvas.classList.remove('blur');

const yearSet = new Set(), regionSet = new Set();
chartData.forEach(d => {
 yearSet.add(String(d.year));
 regionSet.add(d.region);
});

const years = Array.from(yearSet).sort();
const regions = Array.from(regionSet).sort();
const datasets = [];
const predictionPromises = [];

function findActualData(region, year) {
 return chartData.find(d => d.region === region && String(d.year) === String(year));
}

regions.forEach(region => {
 years.forEach(year => {
   const actualDataObj = findActualData(region, year);
   if (!actualDataObj) return;

   predictionPromises.push(
     fetchShortTermPrediction(Number(year), region, actualDataObj.monthlyData)
       .then(predictedArray => ({
         year,
         region,
         predictedArray,
         actualData: actualDataObj.monthlyData
       }))
   );
 });
});

const allPredictions = await Promise.all(predictionPromises);

const colors = ['rgba(255, 99, 132)', 'rgba(54, 162, 235)', 'rgba(255, 206, 86)'];
const labels = ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'];

allPredictions.forEach((pred, idx) => {
 const labelPrefix = pred.year + "년 " + pred.region;

 datasets.push({
   label: labelPrefix + " 예측",
   data: pred.predictedArray,
   backgroundColor: colors[idx % colors.length],
   borderColor: colors[idx % colors.length].replace('0.7', '1'),
   borderWidth: 2,
   type: 'line',
   fill: false,
   tension: 0.3,
   pointRadius: 3,
   pointHoverRadius: 6,
 });

 datasets.push({
   label: labelPrefix + " 실제",
   data: pred.actualData,
   backgroundColor: colors[idx % colors.length].replace('0.7', '0.3'),
   borderColor: colors[idx % colors.length].replace('0.7', '0.5'),
   borderWidth: 1,
   type: 'bar',
   barPercentage: 0.4,
   categoryPercentage: 0.5,
 });
});

const ctx = canvas.getContext('2d');
if (predictedChart) predictedChart.destroy();
predictedChart = new Chart(ctx, {
 type: 'bar',
 data: { labels, datasets },
 options: {
   responsive: true,
   maintainAspectRatio: false,
   plugins: {
     title: { display: true, text: '단기 예측 사용량 vs 실제 사용량' },
     legend: { position: 'top' }
   },
   scales: {
     y: {
       title: { display: true, text: '사용량 (gWh)' }
     }
   }
 }
});
}

// 장기 예측 API 호출
async function fetchLongTermPrediction(year, region, actualMonthlyData) {
const cityEncoded = cityEncodeMap[region] ?? 0;
const preds = [];

for (let month = 1; month <= 12; month++) {
 const prevYear = year - 1;
 const key = prevYear + "_" + region;
 let prev_usage = null;

 if (allDataMap[key]) {
   prev_usage = allDataMap[key][month - 1];
 } else {
   prev_usage = month === 1 ? actualMonthlyData[11] : actualMonthlyData[month - 2];
 }

 const requestBody = {
   city_encoded: cityEncoded,
   year: year,
   month,
   prev_usage
 };

 try {
   const res = await fetch('http://localhost:8000/model/long', {
     method: 'POST',
     headers: { 'Content-Type': 'application/json' },
     body: JSON.stringify(requestBody)
   });
   if (!res.ok) {
     preds.push(null);
     continue;
   }
   const json = await res.json();
   preds.push(json.prediction);
 } catch (e) {
   console.error(`[장기예측 오류] ${region} ${year} ${month}`, e);
   preds.push(null);
 }
}
return preds;
}

// 장기 예측 차트 그리기
async function drawLongTermUsageChart(chartData) {
const selectedYears = Array.from(document.querySelectorAll('input[name="years"]:checked')).map(input => input.value);
const selectedRegion = document.querySelector('select[name="region"]').value;

const canvas = document.getElementById('longTermChart');
const chartContainer = canvas.parentElement;
const overlayId = 'longTermChartOverlay';
let overlay = document.getElementById(overlayId);

if (!overlay) {
 overlay = document.createElement('div');
 overlay.id = overlayId;
 overlay.className = 'chart-overlay';
 chartContainer.appendChild(overlay);
}

if (!selectedRegion || selectedRegion === "" || selectedYears.length === 0) {
 overlay.textContent = '지역,연도를 선택해주세요.';
 overlay.classList.add('show');
 canvas.classList.add('blur');
 if (longTermChart) {
   longTermChart.destroy();
   longTermChart = null;
 }
 return;
}

overlay.classList.remove('show');
canvas.classList.remove('blur');

const yearSet = new Set(), regionSet = new Set();
chartData.forEach(d => {
 yearSet.add(String(d.year));
 regionSet.add(d.region);
});

const years = Array.from(yearSet).sort();
const regions = Array.from(regionSet).sort();
const filteredRegions = selectedRegion === 'all' ? regions : [selectedRegion];
const filteredYears = selectedYears;

const predictionPromises = [];

function findActualData(region, year) {
 return chartData.find(d => d.region === region && String(d.year) === String(year));
}

filteredRegions.forEach(region => {
 filteredYears.forEach(year => {
   const actualDataObj = findActualData(region, year);
   if (!actualDataObj) return;

   predictionPromises.push(
     fetchLongTermPrediction(Number(year), region, actualDataObj.monthlyData)
       .then(predictedArray => ({
         year,
         region,
         predictedArray,
         actualData: actualDataObj.monthlyData
       }))
   );
 });
});

const allPredictions = await Promise.all(predictionPromises);

const colors = ['rgba(75, 192, 192)', 'rgba(153, 102, 255)', 'rgba(255, 159, 64)'];
const datasets = [];

const labels = ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'];

allPredictions.forEach((pred, idx) => {
 const labelPrefix = pred.year + "년 " + pred.region;

 datasets.push({
   label: labelPrefix + " 예측",
   data: pred.predictedArray,
   backgroundColor: colors[idx % colors.length],
   borderColor: colors[idx % colors.length].replace('0.7', '1'),
   borderWidth: 2,
   type: 'line',
   fill: false,
   tension: 0.3,
   pointRadius: 3,
   pointHoverRadius: 6,
 });

 datasets.push({
   label: labelPrefix + " 실제",
   data: pred.actualData,
   backgroundColor: colors[idx % colors.length].replace('0.7', '0.3'),
   borderColor: colors[idx % colors.length].replace('0.7', '0.5'),
   borderWidth: 1,
   type: 'bar',
   barPercentage: 0.4,
   categoryPercentage: 0.5,
 });
});

const ctx = canvas.getContext('2d');
if (longTermChart) longTermChart.destroy();
longTermChart = new Chart(ctx, {
 type: 'bar',
 data: {
   labels,
   datasets
 },
 options: {
   responsive: true,
   maintainAspectRatio: false,
   plugins: {
     title: { display: true, text: '장기 예측 사용량 vs 실제 사용량' },
     legend: { position: 'top' }
   },
   scales: {
     y: {
       title: { display: true, text: '사용량 (gWh)' }
     }
   }
 }
});
}

// 선택된 연도, 지역 화면에 표시
function updateSelectedInfo(years, region) {
  const yearsElem = document.getElementById('selectedYearsDisplay');
  const regionElem = document.getElementById('selectedRegionDisplay');

  if (!years || years.length === 0) {
    yearsElem.innerHTML = '<strong>선택한 연도:</strong> 연도가 선택되지 않았습니다.';
  } else {
    yearsElem.innerHTML = '<strong>선택한 연도:</strong> ' + years.join(', ') + '년';
  }

  if (!region || region.trim() === '') {
    regionElem.innerHTML = '<strong>선택한 지역:</strong> 선택한 지역이 없습니다.';
  } else if (region === 'all') {
    regionElem.innerHTML = '<strong>선택한 지역:</strong> 전체';
  } else {
    regionElem.innerHTML = '<strong>선택한 지역:</strong> ' + region;
  }
}

// ==== 초기화 및 이벤트 바인딩 ====

window.addEventListener('DOMContentLoaded', () => {
  // 초기 차트 그리기 (빈 데이터)
  drawActualUsageChart([]);
  drawPredictedUsageChart([]);
  drawLongTermUsageChart([]);

  toggleGraphVisibility();

  // 연도 선택 UI (다중 선택) jQuery로 처리한 예시 (만약 jQuery 안쓰면 순수 JS로 교체 필요)
  const $multiSelect = $('.multi-select');
  const $selectBox = $multiSelect.find('.select-box');
  const $checkboxList = $multiSelect.find('.checkbox-list');

  $selectBox.on('click', e => {
    e.stopPropagation();
    $checkboxList.toggleClass('expanded');
  });

  $checkboxList.on('click', e => e.stopPropagation());

  $checkboxList.find('input[type=checkbox]').on('change', function () {
    const selected = [];
    $checkboxList.find('input[type=checkbox]:checked').each(function () {
      selected.push($(this).val());
    });
    if (selected.length) {
      $selectBox.text(selected.join(', ') + '년');
    } else {
      $selectBox.text('연도 선택');
    }
  });

  $(document).on('click', () => {
    if ($checkboxList.hasClass('expanded')) {
      $checkboxList.removeClass('expanded');
    }
  });

  $multiSelect.on('keydown', e => {
    if (e.key === 'Escape' || e.key === 'Tab') {
      if ($checkboxList.hasClass('expanded')) {
        $checkboxList.removeClass('expanded');
      }
    }
  });

  // 초기 선택 연도 반영
  const initSelected = [];
  $checkboxList.find('input[type=checkbox]:checked').each(function () {
    initSelected.push($(this).val());
  });
  if (initSelected.length) {
    $selectBox.text(initSelected.join(', ') + '년');
  } else {
    $selectBox.text('연도 선택');
  }

  // 조회 버튼 이벤트
 document.getElementById('searchBtn').addEventListener('click', async () => {
  // 연도 체크박스 선택값
  const selectedYears = Array.from(document.querySelectorAll('input[name="years"]:checked')).map(cb => cb.value);
  // 지역 선택값
  const selectedRegion = document.querySelector('select[name="region"]').value;

  if (!selectedRegion || selectedYears.length === 0) {
    alert('지역과 연도를 선택하세요.');
    updateSelectedInfo([], '');
    return;
    
    
  }
  updateSelectedInfo(selectedYears, selectedRegion);

  // API 호출
  try {
    const params = new URLSearchParams();
    selectedYears.forEach(y => params.append('years', y));
    params.append('region', selectedRegion);

    const res = await fetch('/usageChart?' + params.toString());
    if (!res.ok) throw new Error('네트워크 응답 오류');

    const data = await res.json();
    globalChartData = data.chartData;


    // 차트 그리기
    drawActualUsageChart(globalChartData);
    drawPredictedUsageChart(globalChartData);
    drawLongTermUsageChart(globalChartData);

  } catch (e) {
    console.error(e);
    alert('데이터를 불러오는 중 오류가 발생했습니다.');
  }
});

  // 그래프 표시 토글
  document.getElementById('graphToggle').addEventListener('change', toggleGraphVisibility);

  // 차트 타입 변경
  document.getElementById('chartType').addEventListener('change', updateChartType);

  // 그래프 다운로드 버튼 이벤트
  document.getElementById('downloadBtn').addEventListener('click', () => {
    const selected = document.getElementById('graphToggle').value;

    function downloadChartImage(chart, filename) {
      const url = chart.toBase64Image();
      const a = document.createElement('a');
      a.href = url;
      a.download = filename;
      a.click();
    }

    switch (selected) {
      case 'usage':
        if (!usageChart) return alert('실제 전력 사용량 그래프가 없습니다.');
        if (document.getElementById('usageChart').classList.contains('blur')) {
          alert('실제 사용량 그래프가 블러 처리 되어 다운로드할 수 없습니다.');
          return;
        }
        downloadChartImage(usageChart, '실제_전력_사용량.png');
        break;

      case 'predicted':
        if (!predictedChart && !longTermChart) return alert('예측 그래프가 없습니다.');
        if (predictedChart) downloadChartImage(predictedChart, '단기_예측_전력_사용량.png');
        if (longTermChart) downloadChartImage(longTermChart, '장기_예측_전력_사용량.png');
        break;

      case 'predicted_short':
        if (!predictedChart) return alert('단기 예측 그래프가 없습니다.');
        downloadChartImage(predictedChart, '단기_예측_전력_사용량.png');
        break;

      case 'predicted_long':
        if (!longTermChart) return alert('장기 예측 그래프가 없습니다.');
        downloadChartImage(longTermChart, '장기_예측_전력_사용량.png');
        break;

      case 'both':
        if (usageChart && !document.getElementById('usageChart').classList.contains('blur')) {
          downloadChartImage(usageChart, '실제_전력_사용량.png');
        }
        if (predictedChart) downloadChartImage(predictedChart, '단기_예측_전력_사용량.png');
        if (longTermChart) downloadChartImage(longTermChart, '장기_예측_전력_사용량.png');
        break;
    }
  });
});


window.addEventListener('DOMContentLoaded', () => {
	drawActualUsageChart([]);
	drawPredictedUsageChart([]);
	drawLongTermUsageChart([]);
	});
</script>
</body>
</html>