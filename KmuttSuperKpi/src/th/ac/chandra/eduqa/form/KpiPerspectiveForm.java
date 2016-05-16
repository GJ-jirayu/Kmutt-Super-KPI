package th.ac.chandra.eduqa.form;

import java.io.Serializable;

import th.ac.chandra.eduqa.model.KpiPerspectiveModel;

public class KpiPerspectiveForm extends CommonForm implements Serializable{

	private static final long serialVersionUID = -6498711139841794347L;

	private KpiPerspectiveModel kpiPerspectiveModel;
	private String createDate;
	private String pageSize = "10";
	
	public String getPageSize() {
		return pageSize;
	}
	public void setPageSize(String pageSize) {
		this.pageSize = pageSize;
	}
	public KpiPerspectiveForm(KpiPerspectiveModel KpiPerspectiveModel) {
		super();
		this.kpiPerspectiveModel = KpiPerspectiveModel;
	}
	public KpiPerspectiveForm() {
		super();
		kpiPerspectiveModel=new KpiPerspectiveModel();
	}
	public KpiPerspectiveModel getKpiPerspectiveModel() {
		return kpiPerspectiveModel;
	}
	public void setKpiPerspectiveModel(KpiPerspectiveModel KpiPerspectiveModel) {
		this.kpiPerspectiveModel = KpiPerspectiveModel;
	}
	
	public String getCreateDate() {
		return createDate;
	}
	public void setCreateDate(String createDate) {
		this.createDate = createDate;
	}
	
}
