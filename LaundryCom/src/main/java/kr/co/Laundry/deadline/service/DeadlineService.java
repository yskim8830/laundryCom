package kr.co.Laundry.deadline.service;

import java.util.List;
import java.util.Map;

import kr.co.Laundry.data.dto.RelCntDto;
import kr.co.Laundry.data.dto.RelListDto;
import kr.co.Laundry.data.dto.SalesDto;
import kr.co.Laundry.data.dto.WereCntDto;
import kr.co.Laundry.data.dto.WereListDto;

public interface DeadlineService {
	/** 수정 */
	public int modifyStock(Map<String, Object> paramMap) throws Exception;
	/** 삭제 */
	public int deleteStock(Map<String, Object> paramMap) throws Exception;
	/** 입고건수 (방문자수,총입고건) */
	public List<WereCntDto> getWereCnt(Map<String, Object> paramMap) throws Exception;
	/** 입고건수 입고항목 */
	public List<WereListDto> getWereList(Map<String, Object> paramMap) throws Exception;
	/** 출고건수 (방문,배달갯수) */
	public List<RelCntDto> getRelCnt(Map<String, Object> paramMap) throws Exception;
	/** 출고건수 출고항목 */
	public List<RelListDto> getRelList(Map<String, Object> paramMap) throws Exception;
	/** 매출 정산 */
	public List<SalesDto> getSales(Map<String, Object> paramMap) throws Exception;
}
