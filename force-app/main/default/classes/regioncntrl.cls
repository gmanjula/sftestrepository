public with sharing class regioncntrl {

    public Boolean showphone { get; set; }

    public Account ac { get; set; }
    public regioncntrl(){
     ac=new account();
     showphone=false;
    }

    public PageReference prioritychanged() {
       if(ac.CustomerPriority__c=='High'){
          showphone=true;
       }
       else{
         showphone=false;
       }
        return null;
    }

}