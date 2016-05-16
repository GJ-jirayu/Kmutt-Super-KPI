package th.ac.chandra.eduqa.domain;

import java.io.Serializable;
import java.sql.Timestamp;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.NamedQuery;
import javax.persistence.Table;

@Entity
@Table(name="kpi_perspective")
@NamedQuery(name="KpiPerspective.findAll", query="SELECT k FROM KpiPerspective k")
public class KpiPerspective
implements Serializable {
    private static final long serialVersionUID = 1;
    @Id
    @GeneratedValue(strategy=GenerationType.IDENTITY)
    @Column(name="KPI_PERSPECTIVE_ID")
    private Integer perspcId;
    @Column(name="ACADEMIC_YEAR")
    private Integer academicYear;
    @Column(name="KPI_PERSPECTIVE_NAME", unique=true)
    private String perspcName;
    @Column(name="CREATED_BY")
    private String createdBy;
    @Column(name="UPDATED_BY")
    private String updatedBy;
    @Column(name="CREATED_DTTM")
    private Timestamp createdDate;
    @Column(name="UPDATED_DTTM")
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
        return this.updatedBy;
    }

    public void setUpdatedBy(String updatedBy) {
        this.updatedBy = updatedBy;
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