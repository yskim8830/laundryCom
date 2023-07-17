package kr.co.Laundry.release.service;

import java.util.List;
import java.util.Map;

import org.apache.log4j.LogManager;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.co.Laundry.data.dao.ProductDao;
import kr.co.Laundry.data.dao.StockDao;
import kr.co.Laundry.data.dto.DeadlineDto;
import kr.co.Laundry.data.dto.ProductGroupDto;
import kr.co.Laundry.data.dto.StockDto;

@Service
public class ReleaseServiceImpl implements ReleaseService {

	// Set logger
	private final Logger logger = LogManager.getLogger(this.getClass());
	
	@Autowired
	private ProductDao productDao;
	@Autowired
	private StockDao stockDao;
	
	/** 품목 그룹 조회 */
	public List<ProductGroupDto> getGrpProd(Map<String, Object> paramMap) throws Exception{
		return productDao.selectGrpProd(paramMap);
	}
	/** 입고 조회 */
	public List<StockDto> getStock(Map<String, Object> paramMap) throws Exception{
		return stockDao.selectStock(paramMap);
	}
	/** 입고 조회 */
	public List<DeadlineDto> getStockCnt(Map<String, Object> paramMap) throws Exception{
		return stockDao.selectStockCnt(paramMap);
	}
	/** 출고 */
	public int modifyStock(Map<String, Object> paramMap) throws Exception{
		int ret = 0;
		ret = stockDao.updateRelStock(paramMap);
		return ret;
	}
}
