package kr.co.Laundry.release.service;

import java.util.List;
import java.util.Map;

import kr.co.Laundry.data.dto.DeadlineDto;
import kr.co.Laundry.data.dto.StockDto;

public interface ReleaseService {
	/** 입고 조회 */
	public List<StockDto> getStock(Map<String, Object> paramMap) throws Exception;
	/** 입고 조회 */
	public List<DeadlineDto> getStockCnt(Map<String, Object> paramMap) throws Exception;
	/** 출고 */
	public int modifyStock(Map<String, Object> paramMap) throws Exception;
}
