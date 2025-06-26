package org.zerock.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.zerock.domain.DailyWeatherVO;
import org.zerock.service.WeatherService;

import java.util.List;

@RestController
@RequestMapping("/weather")
public class WeatherController {

    @Autowired
    private WeatherService weatherService;

    /**
     * �ܱ⿹�� ��ȸ (GET)
     * @param citycode ���� �ڵ�
     * @param baseDate �������� (yyyyMMdd)
     * @return DailyWeatherVO ����Ʈ�� JSON���� ��ȯ, ���� �� 500 ���� ��ȯ
     */
    @GetMapping("/short")
    public ResponseEntity<List<DailyWeatherVO>> getShortWeather(
            @RequestParam int citycode,
            @RequestParam String baseDate) {

        try {
            List<DailyWeatherVO> data = weatherService.getShortTermWeatherVO(citycode, baseDate);
            return ResponseEntity.ok(data);
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(500).build();
        }
    }
}
