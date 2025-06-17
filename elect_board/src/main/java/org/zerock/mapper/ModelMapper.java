package org.zerock.mapper;

import org.apache.ibatis.annotations.Param;
import org.zerock.domain.GraphmapVO;

public interface ModelMapper {
    // region�� year�� ���⵵ ������ ��������
    public GraphmapVO getPrevYearUsage(@Param("region") String region, @Param("year") String year);
}