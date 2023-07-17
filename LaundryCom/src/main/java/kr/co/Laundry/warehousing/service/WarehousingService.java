package kr.co.Laundry.warehousing.service;

import java.util.List;
import java.util.Map;

import kr.co.Laundry.data.dto.ProductDto;
import kr.co.Laundry.data.dto.ProductGroupDto;

public interface WarehousingService {
	/** 품목 그룹 조회 */
	public List<ProductGroupDto> getGrpProd(Map<String, Object> paramMap) throws Exception;
	/** 품목 조회 */
	public List<ProductDto> getProd(Map<String, Object> paramMap) throws Exception;
	/** 품목 전체조회 */
	public Map<String, Object> getAllProd(Map<String, Object> paramMap) throws Exception;
	/** 입고 */
	public int setStock(Map<String, Object> paramMap) throws Exception;
	/** 품목 추가 */
	public int setProd(Map<String, Object> paramMap) throws Exception;
}
