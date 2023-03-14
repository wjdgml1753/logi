package kr.co.seoulit.logistics.logiinfosvc.compinfo.controller;

import java.util.ArrayList;
import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.reflect.TypeToken;

import kr.co.seoulit.logistics.logiinfosvc.compinfo.service.CompInfoService;
import kr.co.seoulit.logistics.logiinfosvc.compinfo.to.CodeDetailTO;
import kr.co.seoulit.logistics.logiinfosvc.compinfo.to.CodeTO;
import kr.co.seoulit.logistics.logiinfosvc.compinfo.to.ImageTO;
import kr.co.seoulit.logistics.logiinfosvc.compinfo.to.LatLngTO;

@RestController
@RequestMapping("/compinfo/*")
public class CodeController {
	
	@Autowired
	private CompInfoService compInfoService;
	
	ModelMap map = null;

	private static Gson gson = new GsonBuilder().serializeNulls().create();

	@RequestMapping(value = "/codedetail/list", method = RequestMethod.GET)
	public ModelMap findCodeDetailList(@RequestParam("divisionCodeNo") String CodeDetail) {

		map = new ModelMap();
		try {
			ArrayList<CodeDetailTO> codeLists = compInfoService.getCodeDetailList(CodeDetail);

			map.put("codeList", codeLists);
			map.put("errorCode", 1);
			map.put("errorMsg", "성공");
		} catch (Exception e1) {
			e1.printStackTrace();
			map.put("errorCode", -1);
			map.put("errorMsg", e1.getMessage());
		}
		return map;
	}
//	@RequestMapping(value = "/codedetail/list", method = RequestMethod.GET)
//	public ModelMap findCodeDetailList( HttpServletRequest request, HttpServletResponse response) {
//		String CodeDetail  = request.getParameter("divisionCodeNo");
//		map = new ModelMap();
//		try {
//			ArrayList<CodeDetailTO> codeLists = compInfoService.getCodeDetailList(CodeDetail);
//
//			map.put("codeList", codeLists);
//			map.put("errorCode", 1);
//			map.put("errorMsg", "성공");
//		} catch (Exception e1) {
//			e1.printStackTrace();
//			map.put("errorCode", -1);
//			map.put("errorMsg", e1.getMessage());
//		}
//		return map;
//	}

	@RequestMapping(value = "/codeInfo", method = RequestMethod.POST)
	public ModelMap addCodeInFormation(@RequestParam("newCodeInfo") String newcodeInfo) {

		map = new ModelMap();
		try { 
			ArrayList<CodeTO> CodeTOList = gson.fromJson(newcodeInfo,
				new TypeToken<ArrayList<CodeTO>>() {}.getType());
			
			compInfoService.addCodeInFormation(CodeTOList);
			     
		    map.put("errorCode", 1);
		    map.put("errorMsg", "성공");
		} catch (Exception e1) {
			e1.printStackTrace();
			map.put("errorCode", -1);
			map.put("errorMsg", e1.getMessage());
		}
		return map;
	}

	@RequestMapping(value = "/code/list", method = RequestMethod.GET)
	public ModelMap findCodeList() {
		map = new ModelMap();
		try {
			ArrayList<CodeTO> codeList = compInfoService.getCodeList();

			map.put("codeList", codeList);
			map.put("errorCode", 1);
			map.put("errorMsg", "성공");
		} catch (Exception e1) {
			e1.printStackTrace();
			map.put("errorCode", -1);
			map.put("errorMsg", e1.getMessage());
		}
		return map;
	}

	@RequestMapping(value = "/codedetail2/list", method = RequestMethod.POST)
	public ModelMap findDetailCodeList(@RequestParam("divisionCodeNo") String divisionCode) {

		map = new ModelMap();
		try {
			ArrayList<CodeDetailTO> detailCodeList = compInfoService.getDetailCodeList(divisionCode); 

			map.put("detailCodeList", detailCodeList);
			map.put("errorCode", 1);
			map.put("errorMsg", "성공");
		} catch (Exception e1) {
			e1.printStackTrace();
			map.put("errorCode", -1);
			map.put("errorMsg", e1.getMessage());
		} 
		return map;
	}

	@RequestMapping(value = "/code/duplication", method = RequestMethod.GET)
	public ModelMap checkCodeDuplication(@RequestParam("divisionCode") String divisionCode,
										 @RequestParam("newCode") String newDetailCode) {

		map = new ModelMap();
		try {
			Boolean flag = compInfoService.checkCodeDuplication(divisionCode, newDetailCode);

			map.put("result", flag);
			map.put("errorCode", 1);
			map.put("errorMsg", "성공");
		} catch (Exception e1) {
			e1.printStackTrace();
			map.put("errorCode", -1);
			map.put("errorMsg", e1.getMessage());
		}
		return map;
	}

	@RequestMapping(value = "/code/batch", method = RequestMethod.POST)
	public ModelMap batchListProcess(@RequestParam("batchList") String batchList,@RequestParam("tableName") String tableName) {

		map = new ModelMap();
		try {
			ArrayList<CodeTO> codeList = null;
			ArrayList<CodeDetailTO> detailCodeList = null;
			HashMap<String, Object> resultMap = null;
			if (tableName.equals("CODE")) {
				codeList = gson.fromJson(batchList, new TypeToken<ArrayList<CodeTO>>() {
				}.getType());
				resultMap = compInfoService.batchCodeListProcess(codeList);
			} else if (tableName.equals("CODE_DETAIL")) {
				detailCodeList = gson.fromJson(batchList, new TypeToken<ArrayList<CodeDetailTO>>() {
				}.getType());
				resultMap = compInfoService.batchDetailCodeListProcess(detailCodeList);
			}
			map.put("result", resultMap);
			map.put("errorCode", 1);
			map.put("errorMsg", "성공");
		} catch (Exception e1) {
			e1.printStackTrace();
			map.put("errorCode", -1);
			map.put("errorMsg", e1.getMessage());
		} return map;
	}

	
	@RequestMapping(value = "/code", method = RequestMethod.PUT)
	public ModelMap changeCodeUseCheckProcess(@RequestParam("batchList") String batchList) {

		map = new ModelMap();
		try {
			ArrayList<CodeDetailTO> detailCodeList = null;
			HashMap<String, Object> resultMap = null;

			detailCodeList = gson.fromJson(batchList, new TypeToken<ArrayList<CodeDetailTO>>() {
			}.getType());
			resultMap = compInfoService.changeCodeUseCheckProcess(detailCodeList);

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
	
	//창고 위도 경도 가져오기
	@RequestMapping(value = "/code/latlng", method = RequestMethod.GET)
	public ModelMap findLatLngList(@RequestParam("wareHouseCodeNo") String wareHouseCodeNo) {


		map = new ModelMap();

		try {
			ArrayList<LatLngTO> detailCodeList = compInfoService.getLatLngList(wareHouseCodeNo);

			map.put("detailCodeList", detailCodeList);
			map.put("errorCode", 1);
			map.put("errorMsg", "성공");
		} catch (Exception e1) {
			e1.printStackTrace();
			map.put("errorCode", -1);
			map.put("errorMsg", e1.getMessage());
		} 
		return map;
	   }
	   
	 //이미지 띄우기
	@RequestMapping(value = "/code/itemimage", method = RequestMethod.GET)
	public ModelMap findDetailImageList(@RequestParam("itemGroupCodeNo") String itemGroupCodeNo) {


		map = new ModelMap();

		try {
			ArrayList<ImageTO> detailCodeList = compInfoService.getDetailItemList(itemGroupCodeNo);

			map.put("detailCodeList", detailCodeList);
			map.put("errorCode", 1);
			map.put("errorMsg", "성공");
		
		} catch (Exception e1) {
			e1.printStackTrace();
			map.put("errorCode", -1);
			map.put("errorMsg", e1.getMessage());
		} 
		return map;
	   }
	
}
