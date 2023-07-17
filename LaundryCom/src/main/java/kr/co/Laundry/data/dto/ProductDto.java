package kr.co.Laundry.data.dto;

import lombok.Data;
import lombok.Getter;
import lombok.Setter;

@Data
@Setter
@Getter
public class ProductDto {
	private int seq;
	private String name;
	private int price;
	private String grp_cd;
	private String grp_name;
	private String reg_dt;
	private String mod_dt;
}
