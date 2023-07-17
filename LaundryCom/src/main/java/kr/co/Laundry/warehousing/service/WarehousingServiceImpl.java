package kr.co.Laundry.warehousing.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.LogManager;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.co.Laundry.data.dao.ProductDao;
import kr.co.Laundry.data.dao.StockDao;
import kr.co.Laundry.data.dto.ProductDto;
import kr.co.Laundry.data.dto.ProductGroupDto;

@Service
public class WarehousingServiceImpl implements WarehousingService {

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
	/** 품목 조회 */
	public List<ProductDto> getProd(Map<String, Object> paramMap) throws Exception{
		return productDao.selectProd(paramMap);
	}
	public Map<String, Object> getAllProd(Map<String, Object> paramMap) throws Exception{
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		List<ProductGroupDto> listGrpModel = getGrpProd(paramMap);
		for(ProductGroupDto model : listGrpModel) {
			Map<String, Object> paramMap2 =  new HashMap<String, Object>();
			paramMap2.put("grp_cd", model.getGrp_cd());	
			resultMap.put(model.getGrp_cd(), productDao.selectProd(paramMap2));
		}
		
		return resultMap;
	}
	
	/** 입고 */
	public int setStock(Map<String, Object> paramMap) throws Exception{
		int ret = 0;
		ret = stockDao.insertStock(paramMap);
		return ret;
	}
	
	/** 품목 추가 */
	public int setProd(Map<String, Object> paramMap) throws Exception{
		int ret = 0;
		ret = productDao.insertProd(paramMap);
		return ret;
	}
}
