package kr.co.Laundry.data.dto;

import lombok.Data;
import lombok.Getter;
import lombok.Setter;

@Data
@Setter
@Getter
public class RelListDto {
	private String name;
	private int price;
	private int cnt;
}
