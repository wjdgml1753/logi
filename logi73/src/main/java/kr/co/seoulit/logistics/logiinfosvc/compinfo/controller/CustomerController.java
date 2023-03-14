package kr.co.seoulit.logistics.logiinfosvc.compinfo.controller;

import java.util.ArrayList;
import java.util.HashMap;

import org.json.JSONObject;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.*;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.reflect.TypeToken;

import kr.co.seoulit.logistics.logiinfosvc.compinfo.service.CompInfoService;
import kr.co.seoulit.logistics.logiinfosvc.compinfo.to.CustomerTO;

@RestController
@RequestMapping("/compinfo/*")
public class CustomerController {

	@Autowired
	private CompInfoService compInfoService;


	ModelMap map = null;
	//GSON 은 자바 라이브러리
	private final static Gson gson = new GsonBuilder().serializeNulls().create(); // 속성값이 null 인 속성도 JSON 변환
	JSONObject json = null;

	@RequestMapping(value = "/customer/list", method = RequestMethod.GET)
	public ModelMap searchCustomerList(HttpServletRequest request, HttpServletResponse response) {
		String searchCondition = request.getParameter("searchCondition");
		String companyCode = request.getParameter("companyCode");
		String workplaceCode = request.getParameter("workplaceCode");
		String itemGroupCode = request.getParameter("itemGroupCode");
		map = new ModelMap();
		ArrayList<CustomerTO> customerList = null;
		try {
			customerList = compInfoService.getCustomerList(searchCondition, companyCode, workplaceCode, itemGroupCode);

			map.put("gridRowJson", customerList);
			map.put("errorCode", 1);
			map.put("errorMsg", "성공!");
		} catch (Exception e1) {
			e1.printStackTrace();
			map.put("errorCode", -1);
			map.put("errorMsg", e1.getMessage());
		}
		return map;
	}

	@RequestMapping(value = "/customer/batch", method = RequestMethod.POST)
	public ModelMap batchListProcess(HttpServletRequest request, HttpServletResponse response) {
		String batchList = request.getParameter("batchList");
		map = new ModelMap();
		try {
			// gson을 쓰는 이유는 넘어오는 값들을 하나하나 담아주기 위함이라고함 분석필요 ㅠ
			// TypeToken 원하는 자료형으로 바꿔줌
			// System.out.println("test : "+cto_list.get(0).getCustomerName());
			ArrayList<CustomerTO> customerList = gson.fromJson(batchList, new TypeToken<ArrayList<CustomerTO>>() {
			}.getType());
			HashMap<String, Object> resultMap = compInfoService.batchCustomerListProcess(customerList);

			map.put("result", resultMap);
			map.put("errorCode", 1);
			map.put("errorMsg", "성공!");
		} catch (Exception e1) {
			e1.printStackTrace();
			map.put("errorCode", -1);
			map.put("errorMsg", e1.getMessage());
		}
		return map;
	}

	@RequestMapping(value = "/customer/allList", method = RequestMethod.GET)
	public ModelMap findCustomerList() {
		map = new ModelMap();
		try {
			ArrayList<CustomerTO> list = compInfoService.findCustomerList();
			map.put("customer", list);
			//System.out.println(list);
		} catch (Exception e) {
			map.put("errorCode", -1);
			map.put("errorMsg", e.getMessage());
		}
		return map;
	}

	@RequestMapping(value = "/customer/registerCustomer", method = RequestMethod.POST)
	public ModelMap registerCustomer(@RequestBody ArrayList<CustomerTO> customerList) {
		try {
			compInfoService.registerCustomer(customerList);
		} catch (Exception e) {
			map.put("errorCode", -1);
			map.put("errorMsg", e.getMessage());
		}
		return map;
	}
	@RequestMapping(value = "/customer/removeCustomer",method = RequestMethod.POST)
	public ModelMap removeCustomer(@RequestParam String deleteCustomer){
		System.out.println(deleteCustomer+"삭제했다!#");
		try {
			compInfoService.removeCustomer(deleteCustomer);
		} catch (Exception e) {
			map.put("errorCode", -1);
			map.put("errorMsg", e.getMessage());
		}
		return map;
	}
}