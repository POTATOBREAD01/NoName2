<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page session="false"%>
<html>
<head>
<title>Home</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/home.css" />
</head>
<body>
	<div class="fullwide">
		<div class="middle map">
			<div class="year-select-container">
				<label for="yearSelect" class='select-label'>연도 선택: </label> <select id="yearSelect" class='select'>
					<option value="2014" <c:if test="${year == 2014}">selected</c:if>>2014</option>
					<option value="2015" <c:if test="${year == 2015}">selected</c:if>>2015</option>
					<option value="2016" <c:if test="${year == 2016}">selected</c:if>>2016</option>
					<option value="2017" <c:if test="${year == 2017}">selected</c:if>>2017</option>
					<option value="2018" <c:if test="${year == 2018}">selected</c:if>>2018</option>
					<option value="2019" <c:if test="${year == 2019}">selected</c:if>>2019</option>
					<option value="2020" <c:if test="${year == 2020}">selected</c:if>>2020</option>
					<option value="2021" <c:if test="${year == 2021}">selected</c:if>>2021</option>
					<option value="2022" <c:if test="${year == 2022}">selected</c:if>>2022</option>
					<option value="2023" <c:if test="${year == 2023}">selected</c:if>>2023</option>
					<option value="2024" <c:if test="${year == 2024}">selected</c:if>>2024</option>
					<option value="2025" <c:if test="${year == 2025}">selected</c:if>>2025</option>
					<option value="2026" <c:if test="${year == 2026}">selected</c:if>>2026</option>
					<option value="2027" <c:if test="${year == 2027}">selected</c:if>>2027</option>
					<option value="2028" <c:if test="${year == 2028}">selected</c:if>>2028</option>
					<option value="2029" <c:if test="${year == 2029}">selected</c:if>>2029</option>
				</select>
			</div>
			<object class='svg-map' type="image/svg+xml"
				data="${pageContext.request.contextPath}/resources/static/svg/southKoreaLow.svg"
				width="600" height="800"> 브라우저가 SVG를 지원하지 않습니다. </object>
			<img
				src="${pageContext.request.contextPath}/resources/static/southKoreaLow.png"
				class="oversvg">
		</div>
		<div class='up'>
		<div class="middle chart">
			<h2 id="usageTitle" class='div-main-h2'>${year}년 ${region} 월별 전력 사용량 그래프</h2> <label class='annotation'>(단위/GWh)</label>
			<div id="selectBox">
				<label class='select-label2'>도시:</label> <select id="citySelect" class='select2'>
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
				</select> &nbsp; <label for="predictionType" class='select-label2'>모델&nbsp;<input type='button' value='?' class='explain-button'> :</label>
				
				<select id="predictionType" class='select2'>
					<option value="short">단기 모델</option>
					<option value="long">장기 모델</option>
				</select>
				
				<div id="modelExplainBox" class="explain-box" style="display:none; color:black;">
    				• <b>단기 모델</b> : 직전 1년치 월별 사용량을 입력값으로 삼아<br>다음 1년을 예측합니다. 예상 정확도가 높습니다.<br>
    				• <b>장기 모델</b> : 시·도별 월별 전력 사용량으로 장기적인<br>추세를 예측합니다. 예상 정확도는 단기 모델에 비해 낮습니다.<br>
				</div>
			</div>
			<canvas id="usageChart" width="600" height="300"></canvas>
			
		</div>
		<div class='middle down'>
		<h2 id='totalTitle' class='div-main-h2'>2014년 강원도 총 전력 사용량</h2> <label class='annotation'>(단위/GWh)&nbsp;&nbsp;&nbsp;&nbsp; <br>※총 예측 사용량은 그 해의 실제 사용량이 존재하지 않으면 그 해 전체, 존재하면 존재하는 달 까지만 합산됩니다.</label><br>
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
		<canvas id="totalChart" width="600" height="120"></canvas>
		</div>
		</div>
	</div>
	<script
		src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
	<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
	<script>
	let svgDoc = null;
	var sumVal = 0;
	var sumPre = 0;
	let totalChart;
$(document).ready(function() {
	const cityCodeMap = {
		"강원도": 0,
	    "경기도": 1,
	    "경상남도": 2,
	    "경상북도": 3,
	    "광주": 4,
	    "대구": 5,
	    "대전": 6,
	    "부산": 7,
	    "서울": 8,
	    "세종": 9,
	    "울산": 10,
	    "인천": 11,
	    "전라남도": 12,
	    "전라북도": 13,
	    "제주도": 14,
	    "충청남도": 15,
	    "충청북도": 16
	};

	const regionMap = {
	    "Seoul": "서울",
	    "Busan": "부산",
	    "Daegu": "대구",
	    "Incheon": "인천",
	    "Gwangju": "광주",
	    "Daejeon": "대전",
	    "Ulsan": "울산",
	    "Gyeonggi": "경기도",
	    "Gangwon": "강원도",
	    "North Chungcheong": "충청북도",
	    "South Chungcheong": "충청남도",
	    "North Jeolla": "전라북도",
	    "South Jeolla": "전라남도",
	    "North Gyeongsang": "경상북도",
	    "South Gyeongsang": "경상남도",
	    "Jeju": "제주도",
	    "Sejong": "세종"
	};
	const regionMapReverse = {};
	for (const eng in regionMap) {
	    regionMapReverse[regionMap[eng]] = eng;
	}
	
	const base = '${pageContext.request.contextPath}';

	let year = '<c:out value="${year != null ? year : '2023'}"/>';
	let currentRegionKor = '<c:out value="${region != null ? region : '서울'}"/>';
	let currentRegionEng = regionMapReverse[currentRegionKor];

	const ctx = document.getElementById('usageChart').getContext('2d');
	let usageData = new Array(12).fill(null);
	let predictionData = new Array(12).fill(null);

	// 차트 초기화: 두 개 데이터셋 (실제, 예측)
	const chart = new Chart(ctx, {
	    
	    data: {
	    	labels: ["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"],
	      	datasets: [
	        {
	          type: 'bar',
	          label: '실제 월별 전력 사용량',
	          data: usageData,
	          borderColor: 'rgba(75, 192, 192, 1)',
	          backgroundColor: 'rgba(75, 192, 192, 0.5)',
	          fill: false,
	          tension: 0.1,
	          yAxisID: 'y',
	        },
	        {
	          type: 'line',
	          label: '예측 월별 전력 사용량',
	          data: predictionData,
	          borderColor: 'rgba(255, 99, 132, 1)',
	          backgroundColor: 'rgba(255, 99, 132, 1)',
	          fill: false,
	          tension: 0.1,
	          yAxisID: 'y',
	        }
	        ]
	    },
	    options: {
	    	scales: {
	    		x: {
	    			ticks: {
	    				color:'#ececec'
	    			}
	    		},
	        	y: {
	          		beginAtZero: true,
		        	ticks: {
		        		color:'#ececec',
		                stepSize:1000 // 눈금 간격 설정
		              }
	        	}
	      	},
	      	plugins: {
	      	    legend: {
	      	      	labels: {
	      	        	color: '#ececec' // 범례 항목 글자 색
	      	      	}
	      	    }
	      	}
	    }
	});

	// 실제 사용량 데이터 불러오기 및 차트 업데이트
	function fetchUsageData(year, regionKor) {
		return fetch(base + '/api/usage/' + year + '?region=' + encodeURIComponent(regionKor))
	    .then(res => res.json())
	    .then(json => {
	    	sumVal=0;
	        usageData = json.monthlyUsage;
	        chart.data.datasets[0].data = usageData;

	        for(i=0;i<=chart.data.datasets[0].data.length-1;i++){
	        	sumVal+=chart.data.datasets[0].data[i]*100
	        	
	        }
	        chart.update();
	    })
	    .catch(err => {
	        /* console.error("실제 사용량 데이터 로딩 실패", err);
	        alert("실제 사용량 데이터 로딩 실패"); */
	        for(i=0;i<=11;i++){
	        	chart.data.datasets[0].data[i]=0;
	        }
	        sumVal=0;
	        chart.update();
	    });
	}

	// 예측 데이터 불러오기 (단기 or 장기)
	function fetchPredictionData(year, regionKor, predictionType) {
		const cityEncoded = cityCodeMap[regionKor];
  		if (cityEncoded === undefined) {
    		alert('알 수 없는 도시명입니다.');
    	return Promise.reject('Unknown city');
  	}

  	let predictions = new Array(12).fill(null);

  	if (predictionType === 'short') {
    	// 단기 모델: 각 월별 이전 사용량 받아서 예측 요청
    	const promises = [];
    	for (let month = 1; month <= 12; month++) {
      		const promise = $.ajax({
        		url: '/getPrevUsage',
        		method: 'GET',
        		dataType: 'json',
        		data: { region: regionKor, year: year, month: month }
      		}).then(prevUsage => {
        		const usage = prevUsage.usage;
        	if (!usage || usage === 0) {
          		predictions[month - 1] = null;
          		return;
        	}
        	const data = {
          		city_encoded: cityEncoded,
          		year: year-2014,
          		month: month,
          		prev_usage: usage
        	};
	        return $.ajax({
          		url: '/modelShort',
          		method: 'POST',
          		contentType: 'application/json',
          		data: JSON.stringify(data)
        	}).then(response => {
          		predictions[month - 1] = response.prediction;
        	}).catch(() => {
          		predictions[month - 1] = null;
        	});
      	}).catch(() => {
        	predictions[month - 1] = null;
      	});
      		promises.push(promise);
    	}
    return Promise.all(promises).then(() => {
    	//갱신마다 초기화
    	sumPre=0;
      	predictionData = predictions;
      	chart.data.datasets[1].data = predictionData;
      	if(chart.data.datasets[0].data[0]!=0){
      		for(i=0;i<=chart.data.datasets[1].data.length-1;i++){
          		//총 예측 사용량은 실제 사용량이 존재하는 월까지만 합산
          		if(chart.data.datasets[0].data[i]!=0){
          			sumPre+=chart.data.datasets[1].data[i]*100
          		}
          		//실체 사용량이 0인 i달일 떄
          		else{
          				sumPre+=0;
          		}
            }
      	}
      	else{
      		for(i=0;i<=chart.data.datasets[1].data.length-1;i++){
      			sumPre+=chart.data.datasets[1].data[i]*100
      		}
      	}
      	chart.update();
    });
  	} else if (predictionType === 'long') {
    	// 장기 모델: 바로 예측 요청
    	const promises = [];
    	for (let month = 1; month <= 12; month++) {
      		const data = {
        		city_encoded: cityEncoded,
        		year: year,
        		month: month
      		};
      		const promise = $.ajax({
        		url: '/modelLong',
        		method: 'POST',
        		contentType: 'application/json',
        		data: JSON.stringify(data)
      		}).then(response => {
        		predictions[month - 1] = response.prediction;
      		}).catch(() => {
        		predictions[month - 1] = null;
      		});
      		promises.push(promise);
    		}
    return Promise.all(promises).then(() => {
    	//갱신마다 초기화
    	sumPre=0;
      	predictionData = predictions;
      	chart.data.datasets[1].data = predictionData;
      	//1월 실제 사용량이 0이 아닐 때 (그 해의 실제 사용량이 전부 비어있지 않을 때)
      	if(chart.data.datasets[0].data[0]!=0){
      		for(i=0;i<=chart.data.datasets[1].data.length-1;i++){
          		//총 예측 사용량은 실제 사용량이 존재하는 월까지만 합산
          		if(chart.data.datasets[0].data[i]!=0){
          			sumPre+=chart.data.datasets[1].data[i]*100
          		}
          		else{
          				sumPre+=0;
          		}
            }
      	}
      	//1월 실제 사용량이 0일 때 (그 해의 실제 사용량이 전부 비어있을 때)
      	else{
      		for(i=0;i<=chart.data.datasets[1].data.length-1;i++){
      			sumPre+=chart.data.datasets[1].data[i]*100
      		}
      	}
      	chart.update();
    });
	}
	}

	// refreshAll 함수에서 Promise 체인으로 처리
	function refreshAll() {
		const predictionType = $('#predictionType').val();
		  fetchUsageData(year, currentRegionKor)
		    .then(() =>
		      fetchPredictionData(year, currentRegionKor, predictionType)
		    )
		    .then(() => {
		      updateTotalChart();   // ⬅️ 합계 그래프 출력
		    })
		    .catch(() => {
		      alert('데이터 로딩 실패');
		    });
	}
	// 연도 선택 변경
	$('#yearSelect').on('change', function() {
	    year = $(this).val();
	    
	$('#usageTitle').text(year+'년 '+currentRegionKor+" 월별 전력 사용량 그래프")
	$('#totalTitle').text(year+'년 '+currentRegionKor+" 총 전력 사용량")
	    refreshAll();
	});

	// 예측 타입 변경
	$('#predictionType').on('change', function() {
		refreshAll();
	});
	$('#citySelect').on('change', function() {
		const selectedKor = $(this).val();
		if (!selectedKor) return;

		currentRegionKor = selectedKor;
		currentRegionEng = regionMapReverse[selectedKor];
		$('#usageTitle').text(year+'년 '+currentRegionKor+" 월별 전력 사용량 그래프");
		$('#totalTitle').text(year+'년 '+currentRegionKor+" 총 전력 사용량");
		refreshAll();
	});
	$('#citySelect').val(currentRegionKor);
	
	waitForSvgAndBind();
	refreshAll(); 
	// SVG 지도 내 지역 클릭 시
	function bindRegionEvents(doc) {
    svgDoc = doc; // 전역 저장
    const regions = svgDoc.querySelectorAll('.land');
    regions.forEach(path => {
        path.style.cursor = 'pointer';
        path.addEventListener('click', () => {
            const eng = path.getAttribute('title');
            currentRegionEng = eng;
            currentRegionKor = regionMap[eng];
            if (!currentRegionKor) return;

            $('#citySelect').val(currentRegionKor);
            $('#usageTitle').text(year + '년 ' + currentRegionKor + " 월별 전력 사용량 그래프");
            $('#totalTitle').text(year+'년 '+currentRegionKor+" 총 전력 사용량");
            refreshAll();
            applySvgSelection(currentRegionEng);
        });
    });
	}

	function applySvgSelection(regionEng) {
    	if (!svgDoc) return;
    	const paths = svgDoc.querySelectorAll('.land');
    	paths.forEach(p => {
        	const title = p.getAttribute('title');
        	p.classList.remove('selectedsvg', 'elsesvg');
        if (title === regionEng) {
            p.classList.add('selectedsvg');
        } else {
            p.classList.add('elsesvg');
        }
    });
	}

	$('#citySelect').on('change', function() {
    	const selectedKor = $(this).val();
    	if (!selectedKor) return;

    	currentRegionKor = selectedKor;
    	currentRegionEng = regionMapReverse[selectedKor];

    	$('#usageTitle').text(year + '년 ' + currentRegionKor + " 월별 전력 사용량 그래프");
    	$('#totalTitle').text(year+'년 '+currentRegionKor+" 총 전력 사용량");
    	refreshAll();
    	applySvgSelection(currentRegionEng); // ✅ SVG 강조 적용
	});

	// SVG object 감시 및 이벤트 바인딩
	function waitForSvgAndBind() {
  		const svgObj = document.querySelector('.svg-map');
  	if (!svgObj) {
    	console.error('SVG object not found');
    return;
  	}

  	/* ① load 이벤트가 미래에 올 수도 있으니 일단 등록 */
  	svgObj.addEventListener('load', () => tryBind(svgObj));

  	/* ② 이미 load 가 끝났거나, load 전에 캐싱돼 버린 경우 대비
        → 일정 시간 동안 주기적으로 contentDocument 를 확인 */
  	const MAX_TRY   = 20;   // 최대 2초 (20 × 100 ms)
  	let   tryCount  = 0;
  	const timer = setInterval(() => {
	    if (tryBind(svgObj) || ++tryCount >= MAX_TRY) {
      	clearInterval(timer);   // 성공했거나, 2초가 지나면 멈춤
    	}
  	}, 100);
	}

	/* 실제 바인딩: 성공하면 true, 아직 준비 안 됐으면 false */
	function tryBind(svgObj) {
  		const svgDoc = svgObj.contentDocument;
  	if (!svgDoc) return false;

  	/* 중복 바인딩 방지: 한 번이라도 성공했으면 바로 true */
  	if (svgDoc.__bound) return true;
  	svgDoc.__bound = true;          // 플래그 달아두기

  	injectSvgStyles(svgDoc);
  	bindRegionEvents(svgDoc);
  	return true;
	}

	function injectSvgStyles(svgDoc) {
		const style = svgDoc.createElementNS('http://www.w3.org/2000/svg', 'style');
		style.textContent = `
			.selectedsvg {
				stroke: rgba(255, 50, 50, 0.75);
				stroke-width: 2px;
			}
			.elsesvg {
				opacity: 0.4;
			}
		`;
	svgDoc.documentElement.appendChild(style);
	}

	const totalCtx = document
	.getElementById('totalChart')
	.getContext('2d');

	totalChart = new Chart(totalCtx, {
		type: 'bar',
	  	data: {
	    	labels: ['총 전력 사용량'],
	    	datasets: [
	    {
	        label: '실제 총 사용량',
	        data: [0],
	        backgroundColor: 'rgba(75, 192, 192, 0.5)',
	        borderColor: 'rgba(75, 192, 192, 1)',
	        borderWidth: 1
	    },
	    {
	        label: '예측 총 사용량',
	        data: [0],
	        backgroundColor: 'rgba(255, 99, 132, 0.5)',
	        borderColor: 'rgba(255, 99, 132, 1)',
	        borderWidth: 1
	    }
	    ]
	    },
	  	options: {
			indexAxis: 'y',
	    scales: {
	      	y: {
	        	beginAtZero: true,
	        	ticks: {
	                color: '#ececec' // X축 텍스트 색상
	              }
	      	},
	      	x: {
	      		ticks: {
	      	        color: '#ececec' // X축 텍스트 색상
	      	    }
	      	}
	    },
	    plugins: {
      	    legend: {
      	      	labels: {
      	        	color: '#ececec' // 범례 항목 글자 색
      	      	}
      	    }
      	}
	  	}
	});
	
	function updateTotalChart() {
		  totalChart.data.datasets[0].data[0] = sumVal/100;
		  totalChart.data.datasets[1].data[0] = sumPre/100;
		  $('#totalUse').text(totalChart.data.datasets[0].data[0]);
		  $('#totalPre').text(totalChart.data.datasets[1].data[0]);
		  totalChart.update();
	}
	
	$('.explain-button').on('click', function (e) {
	    e.stopPropagation();                 // ← 문서 클릭 이벤트로 전파되지 않게
	    $('#modelExplainBox').slideToggle(200);
	});

	// ② 박스 안을 눌러도 닫히지 않도록 전파 차단
	$('#modelExplainBox').on('click', function (e) {
	    e.stopPropagation();
	});

	// ③ 문서 아무 곳이나 클릭했을 때 박스가 열려 있으면 닫기
	$(document).on('click', function (e) {
	    // 클릭된 요소가 explain‑box나 버튼 계통이 아니면 → 닫기
	    if (!$(e.target).closest('#modelExplainBox, .explain-button').length) {
	        $('#modelExplainBox').slideUp(200);   // 이미 닫혀 있으면 무시
	    }
	});
	
});
	
	
</script>
</body>
</html>