package kr.co.Laundry.cust.service;

import java.util.List;
import java.util.Map;

import kr.co.Laundry.data.dto.CustomerDto;

public interface CustomerService {
	/** 고객 조회 */
	public List<CustomerDto> getCust(Map<String, Object> paramMap) throws Exception;
	/** 고객 등록 및 수정 */
	public int setCust(Map<String, Object> paramMap) throws Exception;
}
