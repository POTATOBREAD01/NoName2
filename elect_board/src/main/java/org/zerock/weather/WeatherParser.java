package org.zerock.weather;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.zerock.domain.DailyWeatherVO;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.stream.Collectors;

public class WeatherParser {

    /**
     * JSON ���ڿ��� �Ľ��Ͽ� ���� ���� �ִ� 4��ġ �ܱ⿹�� ����Ʈ ��ȯ
     * @param jsonString ���û �ܱ⿹�� JSON ����
     * @return DailyWeatherVO ����Ʈ
     * @throws Exception �Ľ� ���н� ���� �߻�
     */
    public List<DailyWeatherVO> parseShortTermForecast(String jsonString) throws Exception {
        ObjectMapper mapper = new ObjectMapper();
        JsonNode root = mapper.readTree(jsonString);

        // JSON ���: response > body > items > item (�迭)
        JsonNode items = root.path("response")
                             .path("body")
                             .path("items")
                             .path("item");

        // Map<��¥, Map<ī�װ�, List<��>>> ���·� �з�
        Map<String, Map<String, List<String>>> dailyCategoryValues = new HashMap<>();

        for (JsonNode item : items) {
            String date = item.get("fcstDate").asText();
            String category = item.get("category").asText();
            String value = item.get("fcstValue").asText();

            dailyCategoryValues.putIfAbsent(date, new HashMap<>());
            Map<String, List<String>> catMap = dailyCategoryValues.get(date);

            catMap.putIfAbsent(category, new ArrayList<>());
            catMap.get(category).add(value);
        }

        List<DailyWeatherVO> result = new ArrayList<>();
        DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyyMMdd");

        String todayString = LocalDate.now().format(dtf);

        // ��¥ ���� �� ���� ���� �ִ� 4��ġ ó��
        List<String> sortedDates = new ArrayList<>(dailyCategoryValues.keySet());
        sortedDates.sort(Comparator.naturalOrder());

        for (String date : sortedDates.stream().limit(4).collect(Collectors.toList())) {
            Map<String, List<String>> catMap = dailyCategoryValues.get(date);

            List<String> tmxList = catMap.getOrDefault("TMX", Collections.emptyList());
            List<String> tmnList = catMap.getOrDefault("TMN", Collections.emptyList());

            Integer maxTemp = null;
            Integer minTemp = null;

            try {
                if (!tmxList.isEmpty()) {
                    maxTemp = (int) Math.round(Double.parseDouble(tmxList.get(0)));
                }

                if (!tmnList.isEmpty()) {
                    minTemp = (int) Math.round(Double.parseDouble(tmnList.get(0)));
                } else {
                    // ���� ��¥�̰� TMN ������ 0500�� TMP ������ ��ü
                    if (date.equals(todayString)) {
                        List<String> tmpList = catMap.getOrDefault("TMP", Collections.emptyList());
                        if (!tmpList.isEmpty()) {
                            minTemp = (int) Math.round(Double.parseDouble(tmpList.get(0)));
                        }
                    }
                }
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }

            List<String> skyList = catMap.getOrDefault("SKY", Collections.emptyList());
            String skyCode = getMostFrequentCode(skyList);
            String sky = convertSkyCodeToString(skyCode);

            List<String> ptyList = catMap.getOrDefault("PTY", Collections.emptyList());
            String ptyCode = getMostFrequentCode(ptyList);
            String precipitation = convertPtyCodeToString(ptyCode);

            DailyWeatherVO vo = new DailyWeatherVO();
            vo.setDate(LocalDate.parse(date, dtf).toString()); // yyyy-MM-dd �������� ��ȯ
            vo.setMaxTemperature(maxTemp);
            vo.setMinTemperature(minTemp);
            vo.setSky(sky);
            vo.setPrecipitation(precipitation);

            result.add(vo);
        }

        return result;
    }

    /**
     * ����Ʈ���� ���� �󵵰� ���� �ڵ� ��ȯ (������ "0")
     */
    private String getMostFrequentCode(List<String> codes) {
        if (codes.isEmpty()) return "0";

        Map<String, Long> freqMap = new HashMap<>();
        for (String c : codes) {
            freqMap.put(c, freqMap.getOrDefault(c, 0L) + 1);
        }

        return freqMap.entrySet()
                      .stream()
                      .max(Map.Entry.comparingByValue())
                      .get()
                      .getKey();
    }

    /**
     * SKY �ڵ� �� ���� ���ڿ� ��ȯ
     */
    private String convertSkyCodeToString(String code) {
        switch (code) {
            case "1": return "����";
            case "3": return "��������";
            case "4": return "�帲";
            default: return "�˼�����";
        }
    }

    /**
     * PTY �ڵ� �� ���� ���� ���ڿ� ��ȯ
     */
    private String convertPtyCodeToString(String code) {
        switch (code) {
            case "0": return "����";
            case "1": return "��";
            case "2": return "��/��";
            case "3": return "��";
            case "4": return "�ҳ���";
            default: return "�˼�����";
        }
    }
}
