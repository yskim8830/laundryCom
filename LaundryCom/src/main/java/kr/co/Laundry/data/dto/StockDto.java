package kr.co.Laundry.data.dto;

import lombok.Data;
import lombok.Getter;
import lombok.Setter;

@Data
@Setter
@Getter
public class StockDto {
	private int seq;
	private String reg_dt;
	private int cust_id;
	private String cust_name;
	private int prod_id;
	private String prod_name;
	private int price;
	private int amount;
	private int total_price;
	private String stock_num;
	private String etc;
	private String rel_dt;
	private String payment;
	private String card;
	private String delivery;
	private String is_release;
	private String is_coupon;
	
}
