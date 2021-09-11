public with sharing class Projectrecsave {

    public String prjstate { get; set; }

    



    public String prjphone { get; set; }

    public String prjlocationcoutry { get; set; }

    public String prjactivestatus { get; set; }

    public String prjemailid { get; set; }

    public String prjname { get; set; }

    

         
         

    public PageReference cancel() {
        return null;
    }


    public PageReference saveandnew() {
        return null;
    }


    public PageReference Quicksave() {
    
      project__C pr = new project__c();
       pr.name=prjname;
       pr.project_contact_Email_id__c = prjemailid;
       insert pr;
        
        pagereference pp=new pagereference('/'+pr.id);
        return null;
    }


    public PageReference save() {
      
       project__c pr = new project__c();
       
       pr.name=prjname;
       
      
       pr.project_contact_Email_id__c=prjemailid;
       system.debug('project details----'+pr.project_contact_Email_id__c);
       system.debug('project name----'+prjname);
         system.debug('project details----'+prjemailid);
       insert pr;
        pagereference pp=new pagereference('/'+pr.id);
        return pp;
    }
     
  
}