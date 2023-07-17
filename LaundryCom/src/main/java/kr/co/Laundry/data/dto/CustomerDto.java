package kr.co.Laundry.data.dto;

import lombok.Data;
import lombok.Getter;
import lombok.Setter;

@Data
@Setter
@Getter
public class CustomerDto {
	private int id;
	private String name;
	private String addr;
	private String tel_1;
	private String tel_2;
	private String tel_3;
	private String reg_dt;
	private String mod_dt;
	private String lately_dt;
	private String release_dt;
}
