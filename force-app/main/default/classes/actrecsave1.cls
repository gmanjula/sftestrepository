public with sharing class actrecsave1 {

    public PageReference cancel() {
        
    PageReference pp= new PageReference('/apex/actcustomcntrlcreate');
        return pp;
    }


    public PageReference saveandnew() {
        account aa=new account();
    aa.name=actname;
    aa.rating=actrating;
    aa.phone=actphone;
    insert aa;
    PageReference pp= new PageReference('/apex/actcustomcntrlcreate');
        return pp;
    }


    public PageReference save() {
    
    account aa=new account();
    aa.name=actname;
    aa.rating=actrating;
    aa.phone=actphone;
    insert aa;
    PageReference pp= new PageReference('/'+aa.id);
        return pp;
    }


    public String actphone { get; set; }

    public String actrating { get; set; }

    public String actname { get; set; }
}