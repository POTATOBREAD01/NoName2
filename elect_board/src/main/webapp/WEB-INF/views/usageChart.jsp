<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>전력 사용량 비교</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <link rel="stylesheet" type="text/css" href="/resources/css/styles.css">
</head>
<body>
<div class="container">

    <!-- 조회 폼 -->
    <form id="searchForm" method="get" action="/usageChart">
        <div class="form-group">
            <label>연도 선택:</label>
            <button type="button" id="toggleYearsBtn">연도 선택 펼치기</button>
            <div class="checkbox-group" id="yearsCheckboxGroup"
                 style="max-height: 0; overflow: hidden; transition: max-height 0.5s ease;">
                <c:forEach var="y" begin="2015" end="2026">
                    <label class="checkbox-item">
                        <input type="checkbox" name="years" value="${y}"
                               <c:if test="${selectedYears != null and selectedYears.contains(y.toString())}">checked</c:if> />
                        ${y}년
                    </label>
                </c:forEach>
            </div>
        </div>

        <div class="form-group inline-group">
            <label>지역 선택:</label>
            <select name="region">
                <option value="" disabled <c:if test="${empty selectedRegion}">selected</c:if>>
    -- 지역을 선택하세요 --
</option>
<option value="all" <c:if test="${selectedRegion == 'all'}">selected</c:if>>전체</option>
<c:forEach var="r" items="${regionList}">
    <option value="${r}" <c:if test="${selectedRegion == r}">selected</c:if>>${r}</option>
</c:forEach>
            </select>

            <label style="margin-left: 20px;">그래프 표시:</label>
            <select id="graphToggle" onchange="toggleGraphVisibility()">
                <option value="both">모두 표시</option>
                <option value="usage">실제 사용량만 표시</option>
                <option value="predicted">예측 사용량(단기 + 장기)만 표시</option>
                <option value="predicted_short">단기 예측 사용량만 표시</option>
                <option value="predicted_long">장기 예측 사용량만 표시</option>
            </select>
        </div>

        <div class="form-group">
            <input type="submit" value="조회" />
            <button id="downloadBtn" type="button">그래프 다운로드</button>
        </div>
    </form>

    <!-- 선택 정보 표시 -->
    <div class="info-group">
        <div class="info-card">
            <h3>선택한 정보</h3>
            <p><strong>선택한 연도:</strong>
                <c:choose>
                    <c:when test="${empty selectedYears}">연도가 선택되지 않았습니다.</c:when>
                    <c:otherwise>
                        <c:forEach var="year" items="${selectedYears}">
                            ${year}<c:if test="${!year.equals(selectedYears[selectedYears.size()-1])}">, </c:if>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </p>
            <p><strong>선택한 지역:</strong>
                <c:choose>
                    <c:when test="${empty selectedRegion}">선택한 지역이 없습니다.</c:when>
                    <c:when test="${selectedRegion == 'all'}">전체</c:when>
                    <c:otherwise>${selectedRegion}</c:otherwise>
                </c:choose>
            </p>
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
            <div class="chart-header" style="display: flex; align-items: center; justify-content: space-between; margin-bottom: 10px;">
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


<script>
    // 서버에서 전달받은 JSON 문자열을 자바스크립트 객체로 변환
    const chartData = JSON.parse('${chartDataJson}');
    const allDataMap = JSON.parse('${allDataMapJson}');

    // 차트 x축 라벨 (월)
    const labels = ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'];

    // 지역명을 숫자 코드로 매핑 (예측 API 요청에 사용)
    const cityEncodeMap = {
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

    // 기본 차트 타입 (bar, line 중 선택 가능)
    let chartType = 'bar';
    let usageChart = null;      // 실제 사용량 차트 객체
    let predictedChart = null;  // 단기 예측 차트 객체
    let longTermChart = null;   // 장기 예측 차트 객체

    // 차트 타입 변경 시 호출: 기존 차트 모두 파괴 후 재생성
    function updateChartType() {
        chartType = document.getElementById('chartType').value;
        if (usageChart) usageChart.destroy();

        drawActualUsageChart();
    }

    // 그래프 표시 옵션에 따라 차트 표시/숨김 처리
    function toggleGraphVisibility() {
    const selected = document.getElementById('graphToggle').value;

    const usageContainer = document.getElementById('usageChart').parentElement;
    const predictedContainer = document.getElementById('predictedChart').parentElement;
    const longTermContainer = document.getElementById('longTermChart').parentElement;

    // 초기화: 모두 숨김
    usageContainer.style.display = 'none';
    predictedContainer.style.display = 'none';
    longTermContainer.style.display = 'none';

    // 표시할 차트 보이기
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

    // 보이는 차트들을 배열에 담기
    const visibleCharts = [usageContainer, predictedContainer, longTermContainer].filter(c => c.style.display === 'block');

    // 보이는 차트 개수에 따라 flex-basis와 max-width 설정
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

    // 나머지 숨겨진 차트 스타일 초기화
    [usageContainer, predictedContainer, longTermContainer].forEach(c => {
        if (c.style.display !== 'block') {
            c.style.flexBasis = '';
            c.style.maxWidth = '';
        }
    });
}



    // 실제 사용량 차트 그리기 함수
    function drawActualUsageChart() {
    const colors = ['rgba(255, 99, 132, 0.5)', 'rgba(54, 162, 235, 0.5)',
        'rgba(255, 206, 86, 0.5)', 'rgba(75, 192, 192, 0.5)',
        'rgba(153, 102, 255, 0.5)', 'rgba(255, 159, 64, 0.5)'];

    // 선택된 연도 및 지역 값 가져오기 (필요에 따라 맞게 조정)
    const selectedYears = Array.from(document.querySelectorAll('input[name="years"]:checked')).map(input => input.value);
    const selectedRegion = document.querySelector('select[name="region"]').value;

    // 지역 또는 연도 미선택 시 안내 메시지 표시
    if (!selectedRegion || selectedRegion === "") {
        document.getElementById('usageChart').style.filter = 'blur(4px)';
        const overlay = document.getElementById('usageChartOverlay');
        overlay.textContent = '지역,연도를 선택해주세요.';
        overlay.classList.add('show');
        if (usageChart) {
            usageChart.destroy();
            usageChart = null;
        }
        return;
    }
    if (selectedYears.length === 0) {
        document.getElementById('usageChart').style.filter = 'blur(4px)';
        const overlay = document.getElementById('usageChartOverlay');
        overlay.textContent = '지역,연도를 선택해주세요.';
        overlay.classList.add('show');
        if (usageChart) {
            usageChart.destroy();
            usageChart = null;
        }
        return;
    }

    // 월별 데이터가 하나라도 존재하는 데이터만 필터링
    const filteredData = chartData.filter(item => 
        item.monthlyData && item.monthlyData.some(value => value != null)
    );

    // 필터링된 데이터로 차트 데이터셋 구성
    const datasets = filteredData.map((item, idx) => ({
        label: item.year + "년 " + item.region,
        data: item.monthlyData,
        backgroundColor: colors[idx % colors.length],
        borderColor: colors[idx % colors.length].replace('0.5', '1'),
        borderWidth: 1,
        type: chartType,
        fill: chartType === 'line' ? false : true,
    }));

    const ctx = document.getElementById('usageChart').getContext('2d');
    if (usageChart) usageChart.destroy();

    // 데이터가 없으면 차트 블러 처리 및 메시지 표시
    if (datasets.length === 0) {
    const usageCanvas = document.getElementById('usageChart');
    usageCanvas.classList.add('blur');  // 캔버스만 blur 처리

    const overlay = document.getElementById('usageChartOverlay');
    overlay.classList.add('show');
    usageChart = null;
    return;
} else {
    const usageCanvas = document.getElementById('usageChart');
    usageCanvas.classList.remove('blur'); // blur 해제

    const overlay = document.getElementById('usageChartOverlay');
    overlay.classList.remove('show');
}

    // 차트 생성
    usageChart = new Chart(ctx, {
        type: chartType,
        data: { labels, datasets },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                title: { display: true, text: '월별 전력 사용량' },
                legend: { position: 'bottom' }
            },
            scales: {
                y: { beginAtZero: true, title: { display: true, text: '사용량 (gWh)' } }
            }
        }
    });
}


    // 단기 예측 API 호출 함수
    async function fetchShortTermPrediction(year, region, actualMonthlyData) {
        const cityEncoded = cityEncodeMap[region] ?? 0;
        const preds = [];

        // 1월부터 12월까지 예측
        for (let month = 1; month <= 12; month++) {
            const prevYear = year - 1;
            const key = prevYear + "_" + region;
            let prev_usage = null;

            // 이전 연도 사용량 데이터를 찾음
            if (allDataMap[key]) {
                prev_usage = allDataMap[key][month - 1];
            } else {
                // 데이터 없으면 실제 데이터에서 이전 달 사용량 참고 (1월은 12월로)
                prev_usage = month === 1 ? actualMonthlyData[11] : actualMonthlyData[month - 2];
            }

            // API 요청용 데이터 객체 생성
            const requestBody = {
                city_encoded: cityEncoded,
                year: year - 2014,   // 예: 2015년 → 1
                month,
                prev_usage
            };

            try {
                // FastAPI 단기 예측 엔드포인트 호출
                const res = await fetch('http://localhost:8000/model/short', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify(requestBody)
                });
                const json = await res.json();
                preds.push(json.prediction);
            } catch (e) {
                console.error(`[단기예측 오류] ${region} ${year} ${month}`, e);
                preds.push(null);
            }
        }
        return preds;
    }

    // 장기 예측 API 호출 함수 (단기와 구조 유사)
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
                    console.error('HTTP error:', res.status);
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

    // 단기 예측 차트 그리기 함수
    async function drawPredictedUsageChart() {
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
        overlay.textContent = '지역, 연도를 선택해주세요.';
        predictedContainer.appendChild(overlay);
    }

    if (!selectedRegion || selectedRegion === "") {
        overlay.textContent = '지역,연도를 선택해주세요.';
        overlay.classList.add('show');
        canvas.classList.add('blur');
        if (predictedChart) {
            predictedChart.destroy();
            predictedChart = null;
        }
        return;
    }

    if (selectedYears.length === 0) {
        overlay.textContent = '지역,연도를 선택해주세요.';
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

    // 단기 예측은 전체 지역/연도 돌림 (수정 원하면 알려주세요)
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

    const colors = ['rgba(255, 99, 132, 0.7)', 'rgba(54, 162, 235, 0.7)', 'rgba(255, 206, 86, 0.7)'];
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
                legend: { position: 'bottom' }
            },
            scales: {
                y: {
                    title: { display: true, text: '사용량 (gWh)' }
                }
            }
        }
    });
}



    async function drawLongTermUsageChart() {
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

        // 지역 또는 연도 미선택 시 처리
        if (!selectedRegion || selectedRegion === "") {
            overlay.textContent = '지역,연도를 선택해주세요.';
            overlay.classList.add('show');
            canvas.classList.add('blur');
            if (longTermChart) {
                longTermChart.destroy();
                longTermChart = null;
            }
            return;
        }

        if (selectedYears.length === 0) {
            overlay.textContent = '지역,연도를 선택해주세요.';
            overlay.classList.add('show');
            canvas.classList.add('blur');
            if (longTermChart) {
                longTermChart.destroy();
                longTermChart = null;
            }
            return;
        }

        // 선택이 완료된 경우: 오버레이와 블러 제거
        overlay.classList.remove('show');
        canvas.classList.remove('blur');

        // ===== 데이터 준비 =====
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
        const colors = ['rgba(75, 192, 192, 0.7)', 'rgba(153, 102, 255, 0.7)', 'rgba(255, 159, 64, 0.7)'];
        const datasets = [];

        // ✅ 이게 빠지면 오류 발생함
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
                    legend: { position: 'bottom' }
                },
                scales: {
                    y: {
                        title: { display: true, text: '사용량 (gWh)' }
                    }
                }
            }
        });
    }



    // 페이지 초기화 함수
    async function init() {
        drawActualUsageChart();          // 실제 사용량 차트
        await drawPredictedUsageChart(); // 단기 예측 차트
        await drawLongTermUsageChart();  // 장기 예측 차트
    }

    window.onload = function() {

        // 연도 선택 펼치기/접기 토글 버튼 이벤트
        document.getElementById('toggleYearsBtn').addEventListener('click', () => {
        	const container = document.getElementById('yearsCheckboxGroup');
        	const toggleBtn = document.getElementById('toggleYearsBtn');

        	if (container.style.maxHeight && container.style.maxHeight !== '0px') {
        	    // 펼쳐져 있으면 접기
        	    container.style.maxHeight = '0';
        	    container.style.padding = '0 10px';
        	    toggleBtn.textContent = '연도 선택 펼치기';
        	} else {
        	    // 접혀 있으면 펼치기
        	    container.style.maxHeight = container.scrollHeight + 'px';
        	    container.style.padding = '10px';
        	    toggleBtn.textContent = '연도 선택 접기';
        	}
        });

        toggleGraphVisibility(); // 그래프 표시 상태 초기화

        // 그래프 다운로드 버튼 이벤트
        document.getElementById('downloadBtn').addEventListener('click', () => {
            const selected = document.getElementById('graphToggle').value;

            const usageCanvas = document.getElementById('usageChart');
            const isUsageBlurred = usageCanvas.style.filter.includes('blur');

            switch(selected) {
                case 'usage':
                    // 실제 사용량 그래프가 블러 처리 되면 다운로드 불가
                    if (isUsageBlurred) {
                        alert('실제 사용량 그래프가 블러 처리 되어 다운로드할 수 없습니다.');
                        return;
                    }
                    if (usageChart) {
                        const url = usageChart.toBase64Image();
                        const a = document.createElement('a');
                        a.href = url;
                        a.download = '실제_전력_사용량.png';
                        a.click();
                    } else {
                        alert('실제 전력 사용량 그래프가 없습니다.');
                    }
                    break;

                case 'predicted':
                    if (!predictedChart && !longTermChart) {
                        alert('예측 그래프가 없습니다.');
                        return;
                    }
                    // 단기 예측 차트 다운로드
                    if (predictedChart) {
                        const url = predictedChart.toBase64Image();
                        const a = document.createElement('a');
                        a.href = url;
                        a.download = '단기_예측_전력_사용량.png';
                        a.click();
                    }
                    // 장기 예측 차트 다운로드
                    if (longTermChart) {
                        const url = longTermChart.toBase64Image();
                        const a = document.createElement('a');
                        a.href = url;
                        a.download = '장기_예측_전력_사용량.png';
                        a.click();
                    }
                    break;

                case 'predicted_short':
                    if (predictedChart) {
                        const url = predictedChart.toBase64Image();
                        const a = document.createElement('a');
                        a.href = url;
                        a.download = '단기_예측_전력_사용량.png';
                        a.click();
                    } else {
                        alert('단기 예측 그래프가 없습니다.');
                    }
                    break;

                case 'predicted_long':
                    if (longTermChart) {
                        const url = longTermChart.toBase64Image();
                        const a = document.createElement('a');
                        a.href = url;
                        a.download = '장기_예측_전력_사용량.png';
                        a.click();
                    } else {
                        alert('장기 예측 그래프가 없습니다.');
                    }
                    break;

                case 'both':
                    if (!isUsageBlurred && usageChart) {
                        const url = usageChart.toBase64Image();
                        const a = document.createElement('a');
                        a.href = url;
                        a.download = '실제_전력_사용량.png';
                        a.click();
                    }
                    if (predictedChart) {
                        const url = predictedChart.toBase64Image();
                        const a = document.createElement('a');
                        a.href = url;
                        a.download = '단기_예측_전력_사용량.png';
                        a.click();
                    }
                    if (longTermChart) {
                        const url = longTermChart.toBase64Image();
                        const a = document.createElement('a');
                        a.href = url;
                        a.download = '장기_예측_전력_사용량.png';
                        a.click();
                    }
                    break;


            }
        });
        
        document.getElementById('searchForm').addEventListener('submit', function(e) {
            const regionSelect = document.querySelector('select[name="region"]');
            const selectedRegion = regionSelect.value;
            const checkedYears = document.querySelectorAll('input[name="years"]:checked');

            // 지역 선택 안 했을 경우
            if (!selectedRegion || selectedRegion === '') {
                alert('지역을 선택해주세요.');
                regionSelect.focus();
                e.preventDefault(); // form 제출 막기
                return;
            }

            // 연도 1개도 체크 안 했을 경우
            if (checkedYears.length === 0) {
                alert('최소 1개 이상의 연도를 선택해주세요.');
                e.preventDefault(); // form 제출 막기
                return;
            }
        });    
    };
</script>


<c:if test="${not empty chartDataJson}">
    <script>
        // 페이지에 차트 데이터가 존재할 때만 차트 그리기
        window.addEventListener('DOMContentLoaded', function () {
            init();
        });
    </script>
</c:if>
</body>
</html>
