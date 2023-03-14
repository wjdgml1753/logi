package kr.co.seoulit.logistics.prodcsvc.production.controller;

import java.util.ArrayList;
import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.*;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.reflect.TypeToken;

import kr.co.seoulit.logistics.busisvc.logisales.to.ContractDetailInMpsAvailableTO;
import kr.co.seoulit.logistics.prodcsvc.production.service.ProductionService;
import kr.co.seoulit.logistics.prodcsvc.production.to.MpsTO;
import kr.co.seoulit.logistics.prodcsvc.production.to.SalesPlanInMpsAvailableTO;

@RestController
@RequestMapping("/production/*")
public class MpsController {

	@Autowired
	private ProductionService productionService;
	
	ModelMap map = null;

	private static Gson gson = new GsonBuilder().serializeNulls().create();

	@RequestMapping(value="/mps/list", method=RequestMethod.GET)
	public ModelMap searchMpsInfo(@RequestParam("startDate") String startDate,
								  @RequestParam("endDate") String endDate,
								  @RequestParam("includeMrpApply") String includeMrpApply) {

		map = new ModelMap();
		try {
			ArrayList<MpsTO> mpsTOList = productionService.getMpsList(startDate, endDate, includeMrpApply);

			map.put("gridRowJson", mpsTOList);
			map.put("errorCode", 1);
			map.put("errorMsg", "성공");
		} catch (Exception e1) {
			e1.printStackTrace();
			map.put("errorCode", -1);
			map.put("errorMsg", e1.getMessage());
		} 
		return map;
	}

	@RequestMapping(value="/mps/contractdetail-available", method=RequestMethod.GET)
	public ModelMap searchContractDetailListInMpsAvailable(@RequestParam("searchCondition") String searchCondition,
														   @RequestParam("startDate") String startDate,
														   @RequestParam("endDate") String endDate) {

		map = new ModelMap();
		try {
			ArrayList<ContractDetailInMpsAvailableTO> contractDetailInMpsAvailableList = 
					productionService.getContractDetailListInMpsAvailable(searchCondition, startDate, endDate);
			map.put("gridRowJson", contractDetailInMpsAvailableList);
			map.put("errorCode", 1);
			map.put("errorMsg", "성공");
		} catch (Exception e1) {
			e1.printStackTrace();
			map.put("errorCode", -1);
			map.put("errorMsg", e1.getMessage());
		}
		return map;
	}

	@RequestMapping(value="/mps/contractdetail-processplanavailable", method=RequestMethod.GET)
	public ModelMap searchContractDetailListInProcessPlanAvailable(@RequestParam("searchCondition") String searchCondition,
																   @RequestParam("startDate") String startDate,
																   @RequestParam("endDate") String endDate) {

		map = new ModelMap();
		try {
			ArrayList<ContractDetailInMpsAvailableTO> contractDetailInMpsAvailableList =
					productionService.getContractDetailListInProcessPlanAvailable(searchCondition, startDate, endDate);
			map.put("gridRowJson", contractDetailInMpsAvailableList);
			map.put("errorCode", 1);
			map.put("errorMsg", "성공");
		} catch (Exception e1) {
			e1.printStackTrace();
			map.put("errorCode", -1);
			map.put("errorMsg", e1.getMessage());
		}
		return map;
	}

	@RequestMapping(value="/mps/salesplan-available", method=RequestMethod.GET)
	public ModelMap searchSalesPlanListInMpsAvailable(@RequestParam("searchCondition") String searchCondition,
													  @RequestParam("startDate") String startDate,
													  @RequestParam("endDate") String endDate) {

		map = new ModelMap();
		try {
			ArrayList<SalesPlanInMpsAvailableTO> salesPlanInMpsAvailableList = 
					productionService.getSalesPlanListInMpsAvailable(searchCondition, startDate, endDate);

			map.put("gridRowJson", salesPlanInMpsAvailableList);
			map.put("errorCode", 1);
			map.put("errorMsg", "성공");
		} catch (Exception e1) {
			e1.printStackTrace();
			map.put("errorCode", -1);
			map.put("errorMsg", e1.getMessage());
		}
		return map;
	}

	@RequestMapping(value="mps/contractdetail", method=RequestMethod.PUT)
	public ModelMap convertContractDetailToMps(@RequestBody ArrayList<ContractDetailInMpsAvailableTO> contractDetailInMpsAvailableList) {
		//String batchList = request.getParameter("batchList");
		map = new ModelMap();
		/*ArrayList<ContractDetailInMpsAvailableTO> contractDetailInMpsAvailableList = gson.fromJson(batchList,
				new TypeToken<ArrayList<ContractDetailInMpsAvailableTO>>() {}.getType());*/
		try {
			HashMap<String, Object> resultMap = productionService
					.convertContractDetailToMps(contractDetailInMpsAvailableList);

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

/*	@RequestMapping(value="/mps/salesplan", method=RequestMethod.PUT)
	public ModelMap convertSalesPlanToMps(HttpServletRequest request, HttpServletResponse response) {
		String batchList = request.getParameter("batchList");
		map = new ModelMap();
		try {
			ArrayList<SalesPlanInMpsAvailableTO> salesPlanInMpsAvailableList = gson.fromJson(batchList,
					new TypeToken<ArrayList<SalesPlanInMpsAvailableTO>>() {
					}.getType());
			HashMap<String, Object> resultMap = productionService.convertSalesPlanToMps(salesPlanInMpsAvailableList);

			map.put("result", resultMap);
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
