package murach.business;

import java.io.Serializable;

public class Survey implements Serializable {
    private String heardFrom;
    private String wantsUpdates;
    private String emailOK;
    private String contactMethod;

    public Survey() {
        this.heardFrom = "";
        this.wantsUpdates = "";
        this.emailOK = "";
        this.contactMethod = "";
    }

    public Survey(String heardFrom, String wantsUpdates, String emailOK, String contactMethod) {
        this.heardFrom = heardFrom;
        this.wantsUpdates = wantsUpdates;
        this.emailOK = emailOK;
        this.contactMethod = contactMethod;
    }

    public String getHeardFrom() {
        return heardFrom;
    }

    public void setHeardFrom(String heardFrom) {
        this.heardFrom = heardFrom;
    }

    public String getWantsUpdates() {
        return wantsUpdates;
    }

    public void setWantsUpdates(String wantsUpdates) {
        this.wantsUpdates = wantsUpdates;
    }

    public String getEmailOK() {
        return emailOK;
    }

    public void setEmailOK(String emailOK) {
        this.emailOK = emailOK;
    }

    public String getContactMethod() {
        return contactMethod;
    }

    public void setContactMethod(String contactMethod) {
        this.contactMethod = contactMethod;
    }

}