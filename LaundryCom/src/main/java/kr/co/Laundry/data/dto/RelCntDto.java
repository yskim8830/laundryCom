package kr.co.Laundry.data.dto;

import lombok.Data;
import lombok.Getter;
import lombok.Setter;

@Data
@Setter
@Getter
public class RelCntDto {
	private int visitCnt;
	private int deliveryCnt;
}
