public with sharing class customcontrol {

    public PageReference save() {
        insert p;
        PageReference pr=new PageReference('/'+p.id);
        return pr;
    }


    public project__C p { get; set; }
    public customcontrol(){
     p= new project__c();
    }
}