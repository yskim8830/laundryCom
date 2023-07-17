package kr.co.Laundry.data.dto;

import lombok.Data;
import lombok.Getter;
import lombok.Setter;

@Data
@Setter
@Getter
public class LoginDto {

	private int seq;
	private String id;
	private String pwd;
	private String name;
	private String grp_id;
	
}
