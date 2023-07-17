package kr.co.Laundry.data.dto;

import lombok.Data;
import lombok.Getter;
import lombok.Setter;

@Data
@Setter
@Getter
public class SalesDto {
	private int totalAmt;
	private int payTotalAmt;
	private int cardTotalAmt;
	private int preAmt;
	private int prePayAmt;
	private int preCardAmt;
	private int aftAmt;
	private int aftPayAmt;
	private int aftCardAmt;
}