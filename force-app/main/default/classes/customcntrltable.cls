public with sharing class customcntrltable {

    public list<project__c> prjlst1 { get; set; }
    public customcntrltable(){
    prjlst1= new list<project__c>([select id,name,Active_Status__c,status__c,Paid_Budget__c,client__c from project__c]);
     }
    /*public list<project__c> getPrjlst() {
     list<project__c> prjlst= new list<project__c>([select id,name,Active_Status__c,status__c,Paid_Budget__c,client__c from project__c]);
     
        return prjlst;
    }*/

}