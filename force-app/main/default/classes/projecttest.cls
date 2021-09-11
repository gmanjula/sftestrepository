@istest
public class projecttest {
     private static testmethod void prjcheck(){
        
        client__c cc = new client__c();
        cc.name='google';
        insert cc;
        project__c pr = new project__c();
        pr.name = 'integration';
        pr.client__c= cc.id;
        pr.Client_Appointment__c=datetime.now();
         pr.project_contact_Email_id__c='maj12345j@gmail.com';
        
        insert pr;
         
         pr.name='apple';
         try{
             System.debug('I am in try block');
         update pr;
         } catch(exception e){
             System.debug('I am in catch block');
         }
         
         project__c pr1 = new project__c();
         pr1.name = 'test';
         pr1.work_loaction__c = 'canada';
         pr1.Client_Appointment__c=datetime.now();
         pr1.project_contact_Email_id__c='manjulaec45@gmail.com';
         try{
             System.debug('I am in try block');
         insert pr1;
         } catch(exception e){
             System.debug('I am in catch block');
         }
             
         project__c pr2 = new project__c();
         pr2.name = 'test1';
         pr2.work_loaction__c = 'India';
         pr2.Client_Appointment__c=datetime.now();
         pr2.project_contact_Email_id__c='maj1245j@gmail.com';
         insert pr2;
          string rectypeid= Schema.SObjectType.project__c.getRecordTypeInfosByName().get('Business Analysis Team').getRecordTypeId();
         system.debug('rectypeid' +rectypeid);
         project__c pr3 = new project__c();
         pr3.name = 'test2';
         pr3.work_loaction__c = 'US';
         pr3.Client_Appointment__c=datetime.now();
         pr3.recordtypeid =rectypeid;
         pr3.Status__c='planning';
         pr3.project_contact_Email_id__c='maj1235j@gmail.com';
         insert pr3;
         project__c pr4 = new project__c();
         pr4.name = 'test3';
         pr4.work_loaction__c = 'UK';
         pr4.Client_Appointment__c=datetime.now();
         pr4.RecordTypeId =rectypeid;
         pr4.project_contact_Email_id__c='maj1345j@gmail.com';
         insert pr4;
        
         
         
       }

}