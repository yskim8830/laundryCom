package kr.co.Laundry.deadline.service;

import java.util.List;
import java.util.Map;

import org.apache.log4j.LogManager;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.co.Laundry.data.dao.ManageDao;
import kr.co.Laundry.data.dao.StockDao;
import kr.co.Laundry.data.dto.RelCntDto;
import kr.co.Laundry.data.dto.RelListDto;
import kr.co.Laundry.data.dto.SalesDto;
import kr.co.Laundry.data.dto.WereCntDto;
import kr.co.Laundry.data.dto.WereListDto;

@Service
public class DeadlineServiceImpl implements DeadlineService {

	// Set logger
	private final Logger logger = LogManager.getLogger(this.getClass());
	
	@Autowired
	private StockDao stockDao;
	@Autowired
	private ManageDao manageDao;
	
	/** 수정 */
	public int modifyStock(Map<String, Object> paramMap) throws Exception{
		int ret = 0;
		ret = stockDao.updateStock(paramMap);
		return ret;
	}
	/** 삭제 */
	public int deleteStock(Map<String, Object> paramMap) throws Exception{
		int ret = 0;
		ret = stockDao.deleteStock(paramMap);
		return ret;
	}
	/** 입고건수 (방문자수,총입고건) */
	public List<WereCntDto> getWereCnt(Map<String, Object> paramMap) throws Exception {
		return manageDao.selectWereCnt(paramMap);
	}
	/** 입고건수 입고항목 */
	public List<WereListDto> getWereList(Map<String, Object> paramMap) throws Exception {
		return manageDao.selectWereList(paramMap);
	}
	/** 출고건수 (방문,배달갯수) */
	public List<RelCntDto> getRelCnt(Map<String, Object> paramMap) throws Exception {
		return manageDao.selectRelCnt(paramMap);
	}
	/** 출고건수 출고항목 */
	public List<RelListDto> getRelList(Map<String, Object> paramMap) throws Exception {
		return manageDao.selectRelList(paramMap);
	}
	/** 매출 정산 */
	public List<SalesDto> getSales(Map<String, Object> paramMap) throws Exception {
		return manageDao.selectSales(paramMap);
	}
}
