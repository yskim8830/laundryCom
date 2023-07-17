package kr.co.Laundry.data.dao;

import java.util.List;
import java.util.Map;

import kr.co.Laundry.data.dto.ProductDto;
import kr.co.Laundry.data.dto.ProductGroupDto;

public interface ProductDao {
	/** 품목 그룹 조회 */
	public List<ProductGroupDto> selectGrpProd(Map<String, Object> paramMap);
	/** 품목 조회  */
	public List<ProductDto> selectProd(Map<String, Object> paramMap);
	/** 신규품목 저장 */
	public int insertProd(Map<String, Object> paramMap);
	/** 기존품목 정보수정 */
	public int updateProd(Map<String, Object> paramMap);
}
