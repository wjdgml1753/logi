package kr.co.seoulit.logistics.busisvc.logisales.controller;

import kr.co.seoulit.logistics.busisvc.logisales.service.LogisalesService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;

@RestController
@RequestMapping("/logisales/*")
public class ProcessPlanController {
    @Autowired
    private LogisalesService logisalesService;

    ModelMap map=null;

    //private static Gson gson = new GsonBuilder().serializeNulls().create();

    @RequestMapping(value="/processplan/new" , method= RequestMethod.POST)
    public ModelMap processPlan(@RequestBody HashMap<String,String> processMap) {
        //System.out.println(batchList);

        map = new ModelMap();

        try {
            //HashMap<String,String[]> processMap = gson.fromJson(batchList,new TypeToken<HashMap<String,String[]>>() {}.getType()) ;
            // ****batchList 받아온 값을 밑에 변수에 입력****

            System.out.println("processplan 컨트롤러 mapping");
            logisalesService.processPlan(processMap);

            System.out.println("판매계획 등록 버튼 mapping 성공");
        } catch (Exception e1) {
            e1.printStackTrace();
            map.put("errorCode", -1);
            map.put("errorMsg", e1.getMessage());
        }
        return map;
    }
}