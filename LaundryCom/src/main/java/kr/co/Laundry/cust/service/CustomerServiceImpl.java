package kr.co.Laundry.cust.service;

import java.util.List;
import java.util.Map;

import org.apache.log4j.LogManager;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.co.Laundry.data.dao.CustomerDao;
import kr.co.Laundry.data.dto.CustomerDto;

@Service
public class CustomerServiceImpl implements CustomerService {

	// Set logger
	private final Logger logger = LogManager.getLogger(this.getClass());
	
	@Autowired
	private CustomerDao customerDao;
	
	/** 고객 조회 */
	public List<CustomerDto> getCust(Map<String, Object> paramMap) throws Exception{

		return customerDao.selectCust(paramMap);
	}
	/** 고객 등록 및 수정 */
	public int setCust(Map<String, Object> paramMap) throws Exception{
		int ret = 0;
		String oper = (String)paramMap.get("oper");
		if(oper.equals("add")) {
			int custCnt = customerDao.selectCustCnt(paramMap);
			if(custCnt < 1) {
				ret = customerDao.insertCust(paramMap);
			}else {
				ret = -99;
			}
		}else if(oper.equals("edit")) {			
			ret = customerDao.updateCust(paramMap);
		} 
		return ret;
	}
}
