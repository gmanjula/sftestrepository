public class extensionstdreclist {

    public extensionstdreclist(ApexPages.StandardController stdcontroller) {

    }

    public list<project__c> prjlist{get; set;}
    
    public extensionstdreclist(){
        prjlist = new list<project__c>();
        prjlist =[select id, name,client__c,Start_Date__c,Active_Status__c,Client_Appointment__c from project__C limit 10];
    }

}