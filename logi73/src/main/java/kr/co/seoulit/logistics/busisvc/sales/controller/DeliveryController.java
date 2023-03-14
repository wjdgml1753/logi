package kr.co.seoulit.logistics.busisvc.sales.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import kr.co.seoulit.logistics.busisvc.sales.to.*;
import org.apache.ibatis.annotations.Param;
import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.*;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.reflect.TypeToken;

import kr.co.seoulit.logistics.busisvc.sales.service.SalesService;
import kr.co.seoulit.logistics.busisvc.logisales.to.ContractInfoTO;

@RestController
@RequestMapping("/sales/*")
public class DeliveryController {

    @Autowired
    private SalesService salesService;

    ModelMap map = null;

    private static Gson gson = new GsonBuilder().serializeNulls().create(); // gson은 java에서 json을 파싱하고  속성값이 null 인 속성도 변환
    private CustomerReportTO customerReportTO;
    private ArrayList<ReverseTO> reverseTO;

    @RequestMapping(value = "/delivery/list", method = RequestMethod.GET)
    public ModelMap searchDeliveryInfoList(HttpServletRequest request, HttpServletResponse response) {

        ArrayList<DeliveryInfoTO> deliveryInfoList = null;
        map = new ModelMap();
        try {
            deliveryInfoList = salesService.getDeliveryInfoList();

            map.put("gridRowJson", deliveryInfoList);
            map.put("errorCode", 0);
            map.put("errorMsg", "성공");
        } catch (Exception e1) {
            e1.printStackTrace();
            map.put("errorCode", -1);
            map.put("errorMsg", e1.getMessage());
        }
        return map;
    }

    @RequestMapping(value = "/delivery/batch", method = RequestMethod.POST)
    public ModelMap deliveryBatchListProcess(@RequestParam("batchList") String batchList) {

        map = new ModelMap();
        try {
            List<DeliveryInfoTO> deliveryTOList = gson.fromJson(batchList, new TypeToken<ArrayList<DeliveryInfoTO>>() {
            }.getType());
            HashMap<String, Object> resultMap = salesService.batchDeliveryListProcess(deliveryTOList);

            map.put("result", resultMap);
            map.put("errorCode", 1);
            map.put("errorMsg", "성공");
        } catch (Exception e1) {
            e1.printStackTrace();
            map.put("errorCode", -1);
            map.put("errorMsg", e1.getMessage());

        }
        return map;
    }

    @RequestMapping(value = "/deliver/list/contractavailable", method = RequestMethod.GET)
    public ModelMap searchDeliverableContractList(@RequestParam("ableContractInfo") String ableContractInfo) {
        map = new ModelMap();
        try {
            HashMap<String, String> ableSearchConditionInfo = gson.fromJson(ableContractInfo, new TypeToken<HashMap<String, String>>() {
            }.getType());

            ArrayList<ContractInfoTO> deliverableContractList = null;
            deliverableContractList = salesService.getDeliverableContractList(ableSearchConditionInfo);

            map.put("gridRowJson", deliverableContractList);
            map.put("errorCode", 0);
            map.put("errorMsg", "성공");
        } catch (Exception e1) {
            e1.printStackTrace();
            map.put("errorCode", -1);
            map.put("errorMsg", e1.getMessage());
        }
        return map;
    }

    @RequestMapping(value = "/deliver", method = RequestMethod.POST)
    public ModelMap deliver(@RequestParam("contractDetailNo") String contractDetailNo) {
        map = new ModelMap();
        //try {
            map = salesService.deliver(contractDetailNo);
       /* } catch (Exception e1) {
            e1.printStackTrace();
            map.put("errorCode", -1);
            map.put("errorMsg", e1.getMessage());
        }*/
        return map;
    }

    @RequestMapping(value = "/totalQuaChart", method = RequestMethod.GET)
    public ModelMap getSalesQuaChart() {
        map = new ModelMap();
        try {
            ArrayList<QuarterTO> salesQuaList = salesService.getSalesQuaChart();
            map.put("gridRowJson", salesQuaList);
            map.put("errorCode", 1);
            map.put("errorMsg", "성공");
        } catch (Exception e1) {
            e1.printStackTrace();
            map.put("errorCode", -1);
            map.put("errorMsg", e1.getMessage());
        }
        return map;
    }
    @RequestMapping(value = "/itemChart", method = RequestMethod.GET)
    public ModelMap getItemChart() {

        map = new ModelMap();
        try {
            ArrayList<QuarterTO> salesItemList = salesService.getSalesItemChart();
            map.put("gridRowJson", salesItemList);
            map.put("errorCode", 1);
            map.put("errorMsg", "성공");

        } catch (Exception e1) {
            e1.printStackTrace();
            map.put("errorCode", -1);
            map.put("errorMsg", e1.getMessage());

        }
        return map;
    }

    @RequestMapping(value = "/SalesStatus", method = RequestMethod.GET)
    public ModelMap getSalesStatus(HttpServletRequest request, HttpServletResponse response,
                                   @RequestParam("ableContractInfo") String ableContractInfo) {
        System.out.println("연결 잘 됨");
        map = new ModelMap();

        JSONObject json = new JSONObject(ableContractInfo);
        String startDate = (String) json.get("startDate");
        String endDate = (String) json.get("endDate");
        try {
            ArrayList<SalesStatusTO> salesStatusList = null;
            salesStatusList = salesService.getSalesStatus(startDate, endDate);
            map.put("gridRowJson", salesStatusList);
            map.put("errorCode", 1);
            map.put("errorMsg", "성공");
        } catch (Exception e1) {
            e1.printStackTrace();
            map.put("errorCode", -1);
            map.put("errorMsg", e1.getMessage());
        }
        return map;

    }

    @RequestMapping(value = "/CustomerReport", method = RequestMethod.GET)
    public ModelMap getCustomerReport(String ableContractInfo) {
        salesService.deleteCustomerReport(customerReportTO);
        map = new ModelMap();

        ArrayList<CustomerReportTO> customerReportTOList = new ArrayList<>();
        JSONArray json = new JSONArray(ableContractInfo);
        for (Object jsonobj : json) {
            JSONObject obj = (JSONObject) jsonobj;
            String contractDate = (String) obj.get("contractDate");
            String contractNo = (String) obj.get("contractNo");
            String customerName = (String) obj.get("customerName");
            String deliveryDate = (String) obj.get("deliveryDate");
            String sumPrice = (String) obj.get("sumPrice");
            String netIncome = (String) obj.get("netIncome");
            String status = (String) obj.get("status");

            CustomerReportTO customerReportTO = new CustomerReportTO();

            customerReportTO.setContractDate(contractDate);
            customerReportTO.setContractNo(contractNo);
            customerReportTO.setCustomerName(customerName);
            customerReportTO.setDeliveryDate(deliveryDate);
            customerReportTO.setSumPrice(sumPrice);
            customerReportTO.setNetIncome(netIncome);
            customerReportTO.setStatus(status);
            customerReportTOList.add(customerReportTO);
        }

        for (CustomerReportTO customerReportTO : customerReportTOList) {
            try {
                salesService.getCustomerReport(customerReportTO);
                map.put("errorCode", 1);
                map.put("errorMsg", "성공");

            } catch (Exception e1) {
                e1.printStackTrace();
                map.put("errorCode", -1);
                map.put("errorMsg", e1.getMessage());
            }
        }
        return map;

    }
    //반품가능조회
    @RequestMapping(value = "/ReturnAbleList", method = RequestMethod.GET)

    public ModelMap getReturnAbleList(@RequestParam("ableContractInfo") String ableContractInfo) {
        System.out.println("연결 잘 됨");
        map = new ModelMap();
        JSONObject json = new JSONObject(ableContractInfo);
        String startDate = (String) json.get("startDate");
        String endDate = (String) json.get("endDate");
        try {
            ArrayList<ReverseTO> returnList = salesService.getReturnAbleList(startDate, endDate);
            map.put("gridRowJson", returnList);
            map.put("errorCode", 1);
            map.put("errorMsg", "성공");
        } catch (Exception e1) {
            e1.printStackTrace();
            map.put("errorCode", -1);
            map.put("errorMsg", e1.getMessage());
        }
        return map;
    }
    // 반품등록
    @RequestMapping(value = "/ReturnRegister", method = RequestMethod.POST)

    public ModelMap registerReturn(@RequestBody HashMap<String,String> returnMap) {
        map = new ModelMap();
       try {
           salesService.insertReturnList(returnMap);
           map.put("errorCode", 1);
           map.put("errorMsg", "성공");
       }catch (Exception e1){
           e1.printStackTrace();
           map.put("errorCode", -1);
           map.put("errorMsg", e1.getMessage());
       }
        return map;
    }
    //반품 조회
    @RequestMapping(value="/ReturnList" , method=RequestMethod.GET)
    public ModelMap getReturnList() {
        map = new ModelMap();
        try {
            ArrayList<ReverseTO> ReturnList = salesService.getReturnList();

            map.put("gridRowJson", ReturnList);
            map.put("errorCode", 1);
            map.put("errorMsg", "성공");
        } catch (Exception e1) {
            e1.printStackTrace();
            map.put("errorCode", -1);
            map.put("errorMsg", e1.getMessage());
        }
        return map;
    }

   /* @RequestMapping(value = "DeleteReturnList", method = RequestMethod.GET)
    public ModelMap getDeleteReturnList(@Param("ableReturnInfo") String ableReturnInfo) {
        map = new ModelMap();
        try {
            ArrayList<ReverseTO> reverseTO = gson.fromJson(ableReturnInfo, new TypeToken<ArrayList<ReverseTO>>() {
            }.getType());
            salesService.getDeleteReturnList(reverseTO);
            map.put("errorCode", 1);
            map.put("errorMsg", "성공");
        } catch (Exception e1) {
            e1.printStackTrace();
            map.put("errorCode", -1);
            map.put("errorMsg", e1.getMessage());
        }
        return map;
    }*/




}

