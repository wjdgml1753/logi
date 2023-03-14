package kr.co.seoulit.logistics.busisvc.sales.to;

import kr.co.seoulit.logistics.logiinfosvc.compinfo.to.BaseTO;
import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper = false)
public class ReverseTO extends BaseTO {
    private String deliveryNO; // 납품번호

    private String deliveryDate; // 납품날짜

    private String returnDate; // 반품날짜

    private String customerName;// 거래처명

    private String itemCode;

    private String itemName; // 품목이름

    private String returnUnit; // 반품수량

    private String returnUnitPrice; // 반품단가

    private String returnSumPrice; // 반품총금액

}
