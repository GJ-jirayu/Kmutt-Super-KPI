package th.ac.chandra.eduqa.portlet;

import java.sql.Timestamp;
import java.text.ParseException;
import java.util.List;

import javax.portlet.PortletPreferences;
import javax.portlet.PortletRequest;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.multipart.support.ByteArrayMultipartFileEditor;
import org.springframework.web.portlet.bind.PortletRequestDataBinder;
import org.springframework.web.portlet.bind.annotation.RenderMapping;

import com.liferay.portal.kernel.util.WebKeys;
import com.liferay.portal.model.User;

import th.ac.chandra.eduqa.constant.ServiceConstant;
import th.ac.chandra.eduqa.form.KpiPerspectiveForm;
import th.ac.chandra.eduqa.mapper.ResultService;
import th.ac.chandra.eduqa.model.KpiPerspectiveModel;
import th.ac.chandra.eduqa.model.SysYearModel;
import th.ac.chandra.eduqa.service.EduqaService;
import th.ac.chandra.eduqa.xstream.common.Paging;

@Controller("kpiPerspectiveController")
@RequestMapping("VIEW")
@SessionAttributes({ "kpiPerspectiveForm" })
public class KpiPerspectiveController {
	private static final Logger logger = Logger
			.getLogger(KpiPerspectiveController.class);
	@Autowired
	@Qualifier("eduqaServiceWSImpl")
	private EduqaService service;
	
	@SuppressWarnings("unchecked")
	private Integer getCurrentYear(){
		SysYearModel sysYearModel = new SysYearModel();
		List<SysYearModel> sysYears = service.searchSysYear(sysYearModel);
		try{
			sysYearModel = sysYears.get(0);
			return sysYearModel.getMasterAcademicYear();
		}catch(Exception err){
			return 9999;
		}
	}
	
	//SysYearModel sy = service.getSysYear();

	@InitBinder
	public void initBinder(PortletRequestDataBinder binder,
			PortletPreferences preferences) {
		logger.debug("initBinder");
		binder.registerCustomEditor(byte[].class,
				new ByteArrayMultipartFileEditor());
	}

	@SuppressWarnings("unchecked")
	@RequestMapping("VIEW")
	public String listDetail(PortletRequest request, Model model) {
		KpiPerspectiveForm kpiPerspectiveForm = null;
		if (!model.containsAttribute("kpiPerspectiveForm")) {
			kpiPerspectiveForm = new KpiPerspectiveForm();
			model.addAttribute("kpiPerspectiveForm", kpiPerspectiveForm);
		} else {
			kpiPerspectiveForm = (KpiPerspectiveForm) model.asMap().get("kpiPerspectiveForm");
		}
		KpiPerspectiveModel kpiPerspectiveModel = new KpiPerspectiveModel();
		String keySearch = kpiPerspectiveForm.getKeySearch();
		kpiPerspectiveModel.setKeySearch(keySearch);

		Paging page = new Paging(); //default pageNo = 1
		kpiPerspectiveModel.setPaging(page);
		List<KpiPerspectiveModel> perspectives = service.searchKpiPerspective(kpiPerspectiveModel);
		model.addAttribute("perspectives", perspectives);
		model.addAttribute("lastPage", service.getResultPage());
		model.addAttribute("PageCur", "1");
		return "master/KpiPerspective";
	}

	@RequestMapping(params = "action=doInsert")
	public void actionInsert(javax.portlet.ActionRequest request,
			javax.portlet.ActionResponse response,
			@ModelAttribute("kpiPerspectiveForm") KpiPerspectiveForm kpiPerspectiveForm,
			BindingResult result, Model model) {
		User user = (User) request.getAttribute(WebKeys.USER);
		kpiPerspectiveForm.getKpiPerspectiveModel().setPerspcId(null);
		kpiPerspectiveForm.getKpiPerspectiveModel().setAcademicYear(getCurrentYear());
		kpiPerspectiveForm.getKpiPerspectiveModel().setCreatedBy(user.getFullName());
		kpiPerspectiveForm.getKpiPerspectiveModel().setUpdatedBy(user.getFullName());
		
		ResultService rs = service.saveKpiPerspective(kpiPerspectiveForm.getKpiPerspectiveModel());
		String pageNo = kpiPerspectiveForm.getPageNo().toString();
		String pageSize = kpiPerspectiveForm.getPageSize();
		String keySearch = kpiPerspectiveForm.getKeySearch();
		response.setRenderParameter("render", "listPage");
		response.setRenderParameter("keySearch", keySearch);
		response.setRenderParameter("pageNoStr", pageNo);
		response.setRenderParameter("pageSize", pageSize);
		response.setRenderParameter("messageCode", rs.getMsgCode());
		response.setRenderParameter("messageDesc", rs.getMsgDesc());
		//Render to "VIEW"
	}
	
	@RequestMapping(params = "action=doEdit")
	public void actionUpdate(javax.portlet.ActionRequest request,
			javax.portlet.ActionResponse response,
			@ModelAttribute("kpiPerspectiveForm") KpiPerspectiveForm kpiPerspectiveForm,
			BindingResult result, Model model) throws ParseException {
		User user = (User) request.getAttribute(WebKeys.USER);
		String pageNo = kpiPerspectiveForm.getPageNo().toString();
		String createStr = kpiPerspectiveForm.getCreateDate();
		Timestamp timestamp = Timestamp.valueOf(createStr);
		
		kpiPerspectiveForm.getKpiPerspectiveModel().setAcademicYear(getCurrentYear());
		kpiPerspectiveForm.getKpiPerspectiveModel().setUpdatedBy(user.getFullName());
		kpiPerspectiveForm.getKpiPerspectiveModel().setCreatedDate(timestamp);	
		
		ResultService rs = service.updateKpiPerspective(kpiPerspectiveForm.getKpiPerspectiveModel());

		response.setRenderParameter("render", "listPage");
		response.setRenderParameter("keySearch", kpiPerspectiveForm.getKeySearch());
		response.setRenderParameter("pageNoStr", pageNo);
		response.setRenderParameter("pageSize", kpiPerspectiveForm.getPageSize());
		response.setRenderParameter("messageCode", rs.getMsgCode());
		response.setRenderParameter("messageDesc", rs.getMsgDesc());
	}
	
	@RequestMapping(params = "action=doDelete")
	public void actionDelete(javax.portlet.ActionRequest request,
			javax.portlet.ActionResponse response,
			@ModelAttribute("kpiPerspectiveForm") KpiPerspectiveForm kpiPerspectiveForm,
			BindingResult result, Model model) {
		KpiPerspectiveModel kpiPerspectiveModel = new KpiPerspectiveModel();
		kpiPerspectiveModel.setPerspcId(kpiPerspectiveForm.getKpiPerspectiveModel().getPerspcId());		
		String messageDesc ="";
		String messageCode ="";
		int recoedCount=service.deleteKpiPerspective(kpiPerspectiveModel);
		if(recoedCount == -9){			
			messageDesc = ServiceConstant.ERROR_CONSTRAINT_VIOLATION_MESSAGE_CODE;
			messageCode = "0";
		}
		//Render to list page.
		String pageNo = kpiPerspectiveForm.getPageNo().toString();
		String pageSize = kpiPerspectiveForm.getPageSize();
		String keySearch = kpiPerspectiveForm.getKeySearch();
		response.setRenderParameter("render", "listPage");
		response.setRenderParameter("keySearch", keySearch);
		response.setRenderParameter("pageNoStr", pageNo);
		response.setRenderParameter("pageSize", pageSize);
		response.setRenderParameter("messageCode", messageCode);
		response.setRenderParameter("messageDesc", messageDesc);
	}

	@RequestMapping(params = "action=doSearch")
	public void actionSearch(javax.portlet.ActionRequest request,
			javax.portlet.ActionResponse response,
			@ModelAttribute("kpiPerspectiveForm") KpiPerspectiveForm kpiPerspectiveForm,
			BindingResult result, Model model) {
		String keySearch = kpiPerspectiveForm.getKeySearch();
		String pageSize = kpiPerspectiveForm.getPageSize();
		response.setRenderParameter("render", "listSearch");
		response.setRenderParameter("keySearch", keySearch);
		response.setRenderParameter("pageSize", pageSize);
	}
	
	@RequestMapping(params = "action=doListPage")
	public void actionListPage(javax.portlet.ActionRequest request,
			javax.portlet.ActionResponse response,
			@ModelAttribute("kpiPerspectiveForm") KpiPerspectiveForm kpiPerspectiveForm,
			BindingResult result, Model model) {
		String pageNo = kpiPerspectiveForm.getPageNo().toString();
		String pageSize = kpiPerspectiveForm.getPageSize();
		String keySearch = kpiPerspectiveForm.getKeySearch();
		response.setRenderParameter("render", "listPage");
		response.setRenderParameter("keySearch", keySearch);
		response.setRenderParameter("pageNoStr", pageNo);
		response.setRenderParameter("pageSize", pageSize);
		response.setRenderParameter("messageDesc", "");
		response.setRenderParameter("messageCode", "");
	}
	
	@RequestMapping(params = "action=doPageSize")
	public void actionPageSize(javax.portlet.ActionRequest request,
			javax.portlet.ActionResponse response,
			@ModelAttribute("kpiPerspectiveForm") KpiPerspectiveForm kpiPerspectiveForm,
			BindingResult result, Model model) {
		String pageSize = kpiPerspectiveForm.getPageSize();
		String keySearch = kpiPerspectiveForm.getKeySearch();
		response.setRenderParameter("render", "listPage");
		response.setRenderParameter("keySearch", keySearch);
		response.setRenderParameter("pageNoStr", "1");
		response.setRenderParameter("pageSize", pageSize);
		response.setRenderParameter("messageDesc", "");
		response.setRenderParameter("messageCode", "");
	}

	@SuppressWarnings("unchecked")
	@RequestMapping("VIEW")
	@RenderMapping(params = "render=listSearch")
	public String RenderSearch(@RequestParam("keySearch") String keySearch,
			@RequestParam("pageSize") int pageSize, Model model) {
		KpiPerspectiveModel kpiPerspectiveModel = new KpiPerspectiveModel();
		kpiPerspectiveModel.setKeySearch(keySearch);
		Paging page = new Paging(); //default pageNo = 1
		kpiPerspectiveModel.setPaging(page);
		kpiPerspectiveModel.getPaging().setPageSize(pageSize);
		List<KpiPerspectiveModel> perspectives = service.searchKpiPerspective(kpiPerspectiveModel);
		model.addAttribute("perspectives", perspectives);
		model.addAttribute("lastPage", service.getResultPage());
		model.addAttribute("PageCur", 1);
		model.addAttribute("pageSize", pageSize);
		model.addAttribute("keySearch", keySearch);
		return "master/KpiPerspective";
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping("VIEW")
	@RenderMapping(params = "render=listPage")
	public String RenderListPage(@RequestParam("keySearch") String keySearch,
			@RequestParam("pageNoStr") String pageNoStr,
			@RequestParam("pageSize") int pageSize,
			@RequestParam("messageDesc") String messageDesc,
			@RequestParam("messageCode") String messageCode, 
			Model model) {
		KpiPerspectiveModel kpiPerspectiveModel = new KpiPerspectiveModel();
		kpiPerspectiveModel.setKeySearch(keySearch);
		Paging page = new Paging(Integer.parseInt(pageNoStr), 10, "ASC");
		kpiPerspectiveModel.setPaging(page);
		kpiPerspectiveModel.getPaging().setPageSize(pageSize);
		List<KpiPerspectiveModel> perspectives = service.searchKpiPerspective(kpiPerspectiveModel);
		model.addAttribute("perspectives", perspectives);
		model.addAttribute("keySearch", keySearch);
		model.addAttribute("lastPage", service.getResultPage());
		model.addAttribute("PageCur", pageNoStr);
		model.addAttribute("pageSize", pageSize);
		model.addAttribute("messageCode", messageCode);
		model.addAttribute("messageDesc", messageDesc);
		return "master/KpiPerspective";
	}
}
