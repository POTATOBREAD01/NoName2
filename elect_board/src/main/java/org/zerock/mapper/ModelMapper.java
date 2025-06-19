package org.zerock.mapper;

import org.apache.ibatis.annotations.Param;
import org.zerock.domain.GraphmapVO;

public interface ModelMapper {
    // ���� ��뷮 ��������(1����)
    public GraphmapVO getPrevYearUsage(@Param("region") String region, @Param("year") String year);
    // ���� ��뷮 ��������(1~12��)
    GraphmapVO selectMonthlyUsageByYear(@Param("region") String region, @Param("year") int year);
}