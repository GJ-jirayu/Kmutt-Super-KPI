package th.ac.chandra.eduqa.model;

import com.thoughtworks.xstream.annotations.XStreamAlias;
import java.io.Serializable;
import java.sql.Timestamp;
import th.ac.chandra.eduqa.xstream.common.ImakeXML;

@XStreamAlias(value="KpiPerspectiveModel")
public class KpiPerspectiveModel
extends ImakeXML
implements Serializable {
    private static final long serialVersionUID = 1;
    private Integer perspcId;
    private Integer academicYear;
    private String perspcName;
    private String createdBy;
    private String UpdatedBy;
    private Timestamp createdDate;
    private Timestamp updatedDate;

    public Integer getPerspcId() {
        return this.perspcId;
    }

    public void setPerspcId(Integer perspcId) {
        this.perspcId = perspcId;
    }

    public Integer getAcademicYear() {
        return this.academicYear;
    }

    public void setAcademicYear(Integer academicYear) {
        this.academicYear = academicYear;
    }

    public String getPerspcName() {
        return this.perspcName;
    }

    public void setPerspcName(String perspcName) {
        this.perspcName = perspcName;
    }

    public String getCreatedBy() {
        return this.createdBy;
    }

    public void setCreatedBy(String createdBy) {
        this.createdBy = createdBy;
    }

    public String getUpdatedBy() {
        return this.UpdatedBy;
    }

    public void setUpdatedBy(String updatedBy) {
        this.UpdatedBy = updatedBy;
    }

    public Timestamp getCreatedDate() {
        return this.createdDate;
    }

    public void setCreatedDate(Timestamp createdDate) {
        this.createdDate = createdDate;
    }

    public Timestamp getUpdatedDate() {
        return this.updatedDate;
    }

    public void setUpdatedDate(Timestamp updatedDate) {
        this.updatedDate = updatedDate;
    }
}