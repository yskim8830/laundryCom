package kr.co.Laundry.data.dao;

import java.util.List;
import java.util.Map;

import kr.co.Laundry.data.dto.CustomerDto;

public interface CustomerDao {
	/** 고객 조회 */
	public List<CustomerDto> selectCust(Map<String, Object> paramMap);
	/** 중복 고객 조회 */
	public int selectCustCnt(Map<String, Object> paramMap);
	/** 신규고객 저장 */
	public int insertCust(Map<String, Object> paramMap);
	/** 기존고객 정보수정 */
	public int updateCust(Map<String, Object> paramMap);
}
