package kr.co.seoulit.logistics.busisvc.sales.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import kr.co.seoulit.logistics.busisvc.sales.to.*;
import org.springframework.ui.ModelMap;

import kr.co.seoulit.logistics.busisvc.logisales.to.ContractInfoTO;

public interface SalesService {

	// SalesPlanApplicationServiceImpl
	public ArrayList<ContractInfoTO> getDeliverableContractList(HashMap<String,String> ableSearchConditionInfo);

	public ArrayList<SalesPlanTO> getSalesPlanList(String dateSearchCondition, String startDate, String endDate);

	public HashMap<String, Object> batchSalesPlanListProcess(ArrayList<SalesPlanTO> salesPlanTOList);

	public HashMap<String, Object> batchDeliveryListProcess(List<DeliveryInfoTO> deliveryTOList);

	public ModelMap deliver(String contractDetailNo);

	public ArrayList<DeliveryInfoTO> getDeliveryInfoList();

	public ArrayList<QuarterTO> getSalesQuaChart();

	public ArrayList<QuarterTO> getSalesItemChart();


	public ArrayList<SalesStatusTO> getSalesStatus(String startDate,String endDate);

	void getCustomerReport(CustomerReportTO customerReportTO);

	void deleteCustomerReport(CustomerReportTO customerReportTO);

	ArrayList<ReverseTO> getReturnAbleList(String startDate, String endDate);

	void insertReturnList(HashMap<String,String> returnMap);

	public ArrayList<ReverseTO> getReturnList();

	void getDeleteReturnList(ArrayList<ReverseTO> reverseTO);

}