package kr.co.seoulit.logistics.busisvc.sales.mapper;

import java.util.ArrayList;
import java.util.HashMap;

import kr.co.seoulit.logistics.busisvc.sales.to.*;
import org.apache.ibatis.annotations.Mapper;

import org.apache.ibatis.annotations.Param;

@Mapper
public interface DeliveryMapper {

    public ArrayList<DeliveryInfoTO> selectDeliveryInfoList();

    public void deliver(HashMap<String, Object> map);

    public void insertDeliveryResult(DeliveryInfoTO TO);

    public void updateDeliveryResult(DeliveryInfoTO TO);

    public void deleteDeliveryResult(DeliveryInfoTO TO);

    public ArrayList<QuarterTO> selectSalesQuaChart();

    public ArrayList<QuarterTO> selectSalesItemChart();

    public ArrayList<SalesStatusTO> selectSalesStatus(@Param("start") String startDate, @Param("end")  String endDate);

    public void insertCustomerList(CustomerReportTO customerReportTO);

    public void deleteCustomerList(CustomerReportTO customerReportTO);

    public ArrayList<ReverseTO> selectReturnAbleList(@Param("start") String startDate, @Param("end")  String endDate);

    public void insertReturnList(HashMap<String,String> returnMap);

    public ArrayList<ReverseTO> selectReturnList();

    public void deleteReturnList(ReverseTO to);
}
