package org.zerock.domain;

import lombok.Data;

@Data
public class DailyWeatherVO { 
    private String date;             // yyyy-MM-dd ����
    private Integer maxTemperature; // �ְ���
    private Integer minTemperature; // �������
    private String sky;              // ����, ��������, �帲
    private String precipitation;    // ��, ��, ���� ��
}