package kr.co.Laundry.data.dao;

import java.util.List;
import java.util.Map;

import kr.co.Laundry.data.dto.DeadlineDto;
import kr.co.Laundry.data.dto.StockDto;

public interface StockDao {
	/** 입고 조회 */
	public List<StockDto> selectStock(Map<String, Object> paramMap);
	/** 입고 조회 */
	public List<DeadlineDto> selectStockCnt(Map<String, Object> paramMap);
	/** 신규입고 저장 */
	public int insertStock(Map<String, Object> paramMap);
	/** 입고 수정 */
	public int updateStock(Map<String, Object> paramMap);
	/** 출고 처리 */
	public int updateRelStock(Map<String, Object> paramMap);
	/** 입고 삭제 */
	public int deleteStock(Map<String, Object> paramMap);
	
}
