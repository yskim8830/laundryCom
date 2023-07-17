package kr.co.Laundry.data.dao;

import java.util.List;
import java.util.Map;

import kr.co.Laundry.data.dto.RelCntDto;
import kr.co.Laundry.data.dto.RelListDto;
import kr.co.Laundry.data.dto.SalesDto;
import kr.co.Laundry.data.dto.WereCntDto;
import kr.co.Laundry.data.dto.WereListDto;

public interface ManageDao {
	/** 입고건수 (방문자수,총입고건) */
	public List<WereCntDto> selectWereCnt(Map<String, Object> paramMap);
	/** 입고건수 입고항목 */
	public List<WereListDto> selectWereList(Map<String, Object> paramMap);
	/** 출고건수 (방문,배달갯수) */
	public List<RelCntDto> selectRelCnt(Map<String, Object> paramMap);
	/** 출고건수 출고항목 */
	public List<RelListDto> selectRelList(Map<String, Object> paramMap);
	/** 매출 정산 */
	public List<SalesDto> selectSales(Map<String, Object> paramMap);
	
}
