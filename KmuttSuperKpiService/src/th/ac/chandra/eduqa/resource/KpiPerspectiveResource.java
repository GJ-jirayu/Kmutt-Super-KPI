package th.ac.chandra.eduqa.resource;

import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.apache.log4j.Logger;
import org.hibernate.exception.ConstraintViolationException;
import org.restlet.representation.Representation;
import org.restlet.representation.Variant;
import org.restlet.resource.ResourceException;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;

import th.ac.chandra.eduqa.constant.ServiceConstant;
import th.ac.chandra.eduqa.domain.KpiPerspective;
import th.ac.chandra.eduqa.model.KpiPerspectiveModel;
import th.ac.chandra.eduqa.service.EduqaService;
import th.ac.chandra.eduqa.xstream.common.ImakeMessage;
import th.ac.chandra.eduqa.xstream.common.ImakeResultMessage;
import th.ac.chandra.eduqa.xstream.common.Paging;

public class KpiPerspectiveResource extends BaseResource {
	private static final Logger logger = Logger.getLogger(ServiceConstant.LOG_APPENDER);
	
	@Autowired
	@Qualifier("eduqaServiceJpaImpl")
	private EduqaService service;
	//private ConsultantReportService consultantReportService;
	private com.thoughtworks.xstream.XStream xstream; 
	public KpiPerspectiveResource() {
		super();
	}

	@Override
	protected void doInit() throws ResourceException {
		// TODO Auto-generated method stub
		super.doInit();
		logger.debug("into doInit");
	}
	
	@Override
	protected Representation post(Representation entity, Variant variant)
			throws ResourceException {
		//logger.debug("into Post ConsultantReportResource 2");
		InputStream in = null;
		try {
			in = entity.getStream();
			xstream.processAnnotations(KpiPerspectiveModel.class);// or xstream.autodetectAnnotations(true); (Auto-detect  Annotations)
			KpiPerspectiveModel xsource = new KpiPerspectiveModel();
			Object xtarget = xstream.fromXML(in);
			if (xtarget != null) {
				xsource = (KpiPerspectiveModel) xtarget;
				if (xsource != null) {
					KpiPerspective domain = new KpiPerspective();
					BeanUtils.copyProperties(xsource,domain); 
					
					if (xsource.getServiceName() != null && xsource.getServiceName().length()!=0) {	
						String serviceName = xsource.getServiceName();
						if(serviceName.equals(ServiceConstant.PERSPECTIVE_FIND_BY_ID)){
							domain = service.findKpiPerspectiveById(xsource.getPerspcId());
							if(domain!=null){
								ImakeResultMessage imakeMessage = new ImakeResultMessage();
								List<KpiPerspectiveModel> models = new ArrayList<KpiPerspectiveModel>(1);
								KpiPerspectiveModel model = new KpiPerspectiveModel();
								BeanUtils.copyProperties(domain,model);	
								model.setPagging(null);
								models.add(model);
								imakeMessage.setResultListObj(models);
								return getRepresentation(entity, imakeMessage, xstream);
							}
						}
						else if(serviceName.equals(ServiceConstant.PERSPECTIVE_SAVE)){
							ImakeResultMessage resultMsg = new ImakeResultMessage();
							ImakeMessage msg = new ImakeMessage();
							java.sql.Timestamp now= new java.sql.Timestamp(new Date().getTime());
							domain.setCreatedDate(now);
							domain.setUpdatedDate(now);
							Integer updateRecord=service.saveKpiPerspective(domain);
							if(updateRecord>0){
								msg.setMsgCode(ServiceConstant.RESULT_OK);
								msg.setMsgDesc(ServiceConstant.MESSAGE_SAVE_SUCCESS);
							}else{
								msg.setError(true);
								msg.setMsgCode(ServiceConstant.RESULT_ERROR);
								msg.setMsgDesc(ServiceConstant.MESSAGE_DUPLICATE);
							}
							resultMsg.setResultMessage(msg);
							return getRepresentation(entity, resultMsg, xstream);
						}
						else if(serviceName.equals(ServiceConstant.PERSPECTIVE_UPDATE)){
							ImakeResultMessage resultMsg = new ImakeResultMessage();
							ImakeMessage msg = new ImakeMessage();
							java.sql.Timestamp updatedDate = new java.sql.Timestamp(new Date().getTime());
							domain.setUpdatedDate(updatedDate);
							Integer updateRecord=service.updateKpiPerspective(domain);
							if(updateRecord>0){
								msg.setMsgCode(ServiceConstant.RESULT_OK);
								msg.setMsgDesc(ServiceConstant.MESSAGE_UPDATE_SUCCESS);
							}else{
								msg.setError(true);
								msg.setMsgCode(ServiceConstant.RESULT_ERROR);
								msg.setMsgDesc(ServiceConstant.MESSAGE_DUPLICATE);
							}
							resultMsg.setResultMessage(msg);
							return getRepresentation(entity, resultMsg, xstream);
						}
						else if(serviceName.equals(ServiceConstant.PERSPECTIVE_DELETE)){
							//int updateRecord=service.deleteKpiPerspective(domain);
							//return returnUpdateRecord(entity,xsource,updateRecord);
							int updateRecord=0;
							try{
								updateRecord=service.deleteKpiPerspective(domain);								
							}catch(Exception e){
								Throwable t = e.getCause();
							    while ((t != null) && !(t instanceof ConstraintViolationException)) {
							        t = t.getCause();
							    }							  
							    if (t instanceof ConstraintViolationException) {
							    	updateRecord=-9;
							    }
							}
							return returnUpdateRecord(entity,xsource,updateRecord);
						}
						
						else if(serviceName.equals(ServiceConstant.PERSPECTIVE_SEARCH)){
							Paging page = xsource.getPaging(); 
							@SuppressWarnings("rawtypes")
							List result = (List) service.searchKpiPerspective(domain, page,xsource.getKeySearch());
							if (result != null && result.size() == 2) {
								java.util.ArrayList<KpiPerspective> domains = (java.util.ArrayList<KpiPerspective>) result.get(0); //get dataList
								String domains_size = (String) result.get(1);  // get meta
								ImakeResultMessage imakeMessage = new ImakeResultMessage();

								List<KpiPerspectiveModel> models = new ArrayList<KpiPerspectiveModel>();
								if (domains_size != null && domains_size.length()!=0)
									imakeMessage.setMaxRow(domains_size);
								if (domains != null && domains.size() > 0) {
									models = getModels(domains);
								}
								imakeMessage.setResultListObj(models);
								return getRepresentation(entity, imakeMessage, xstream);
							}
						}
					} else {
					}
					// end serviceName case handle
				}
			}
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			logger.debug(" into Finally Call");
			try {
				if (in != null)
					in.close();

			} catch (IOException e) {
				e.printStackTrace();
			}
		}
		return null;
	
	}
	private List<KpiPerspectiveModel> getModels(	java.util.ArrayList<KpiPerspective> domains) {
		List<KpiPerspectiveModel> models = new ArrayList<KpiPerspectiveModel>(domains.size());
		for (KpiPerspective domain : domains) {
			KpiPerspectiveModel model =new KpiPerspectiveModel ();
			BeanUtils.copyProperties(domain, model);
			model.setPagging(null);
			models.add(model);
		}
		return models;
	}
	private Representation returnUpdateRecord(Representation entity,KpiPerspectiveModel model,int updateRecord){
		ImakeResultMessage imakeMessage = new ImakeResultMessage();
		List<KpiPerspectiveModel> xsources = new ArrayList<KpiPerspectiveModel>(1);
		model.setUpdateRecord(updateRecord);
		xsources.add(model);
		imakeMessage.setResultListObj(xsources);
		return getRepresentation(entity, imakeMessage, xstream);
	}
 
	@Override
	protected Representation get(Variant variant) throws ResourceException {
		//System.out.println("aoe->"+service.listJournalPaperAll());
		 return null;
	} 
	public com.thoughtworks.xstream.XStream getXstream() {
		return xstream;
	}

	public void setXstream(com.thoughtworks.xstream.XStream xstream) {
		this.xstream = xstream;
	}

}
