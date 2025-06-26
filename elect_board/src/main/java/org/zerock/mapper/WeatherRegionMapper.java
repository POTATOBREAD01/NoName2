package org.zerock.mapper;

import java.util.Map;

public class WeatherRegionMapper {
    public static class RegionInfo {
        public final int nx;
        public final int ny;
        public final String regId;
        public final String stnId;

        public RegionInfo(int nx, int ny, String regId, String stnId) {
            this.nx = nx;
            this.ny = ny;
            this.regId = regId;
            this.stnId = stnId;
        }
    }

    public static final Map<Integer, RegionInfo> regionMap = Map.ofEntries(
        Map.entry(0, new RegionInfo(73, 134, "11D10000", "101")),   // ������
        Map.entry(1, new RegionInfo(60, 120, "11B00000", "108")),   // ��⵵
        Map.entry(2, new RegionInfo(91, 77, "11H20000", "155")),    // ��󳲵�
        Map.entry(3, new RegionInfo(89, 91, "11H10000", "143")),    // ���ϵ�
        Map.entry(4, new RegionInfo(58, 74, "11F20000", "156")),    // ����
        Map.entry(5, new RegionInfo(89, 90, "11H10000", "143")),    // �뱸
        Map.entry(6, new RegionInfo(67, 100, "11C20000", "133")),   // ����
        Map.entry(7, new RegionInfo(98, 76, "11H20000", "159")),    // �λ�
        Map.entry(8, new RegionInfo(60, 127, "11B00000", "108")),   // ����
        Map.entry(9, new RegionInfo(66, 103, "11C20000", "239")),   // ����
        Map.entry(10, new RegionInfo(102, 84, "11H20000", "152")),  // ���
        Map.entry(11, new RegionInfo(55, 124, "11B00000", "112")),  // ��õ
        Map.entry(12, new RegionInfo(51, 67, "11F10000", "165")),   // ���󳲵�
        Map.entry(13, new RegionInfo(63, 89, "11F10000", "146")),   // ����ϵ�
        Map.entry(14, new RegionInfo(52, 38, "11G00000", "184")),   // ����
        Map.entry(15, new RegionInfo(68, 100, "11C20000", "133")),  // ��û����
        Map.entry(16, new RegionInfo(69, 107, "11C10000", "131"))   // ��û�ϵ�
    );
}
