package kr.co.Laundry.data.dto;

import lombok.Data;
import lombok.Getter;
import lombok.Setter;

@Data
@Setter
@Getter
public class WereCntDto {
	private int custCnt;
	private int prodCnt;
	private int coupon; //쿠폰사용입고건
}
