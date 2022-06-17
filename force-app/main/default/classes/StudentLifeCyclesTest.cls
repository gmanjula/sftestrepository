@isTest
public class StudentLifeCyclesTest {
    
	@isTest
    private static void test1(){
        List<Lead> leadList=new List<Lead>();
        Account acc = new Account(name='test');
        insert acc;
        Contact c1=new Contact(Student_Id__c='123450',LastName='TestCALExists1',Email='test1@email.com',phone='323456789',AccountId=acc.Id);
        insert c1;
        Lead l3=new Lead(LastName='TestLNCExists3',Email='test1@email.com',Company='TestCompany',Phone='884576498',OwnerId=UserInfo.getUserId());
        insert l3;
        leadList.add(l3);
        List<Student_Lifecycle__e> NewPFEventList= new List<Student_Lifecycle__e>();
        for(integer i=0;i<2;i++)
        {
            Student_Lifecycle__e NewPfEvent=new Student_Lifecycle__e();
            NewPfEvent.Application_type__c  = 'Student'+i;
            NewPfEvent.Campus_Location__c  = 'Sydney'+i;
            NewPfEvent.Course_Code__c  = '6543'+i;
            NewPfEvent.Course_Name__c  = 'TestCrs'+i;
            NewPfEvent.Course_Version__c  = '1';
            NewPfEvent.Deakin_Email__c  = 'deakintest'+i+'@email.com';
            NewPfEvent.Email__c  ='test'+i+'@email.com';
            NewPfEvent.Enrolment_Type__c  = 'Cloud';
            NewPfEvent.Event_Type__c  = 'Course Enrolment';
            NewPfEvent.First_Name__c  = 'FName'+i;
            NewPfEvent.International__c  = true;
            NewPfEvent.Last_Name__c  = 'LName'+i;
            NewPfEvent.MailingCity__c  = 'TestCity'+i;
            NewPfEvent.MailingPostalCode__c  = '3130';
            NewPfEvent.MailingState__c  = 'VIC';
            NewPfEvent.MailingStreet__c  =  'StreetAdd'+i;
            NewPfEvent.Middle_Name__c  = 'MName'+i;
            NewPfEvent.MobilePhone__c  = '375384988'+i;
            NewPfEvent.Offer_Date__c  = date.today();
            NewPfEvent.OtherPhone__c  = '375384988'+i;
            NewPfEvent.Phone_Number__c  = '375384988'+i;
            NewPfEvent.Preferred_Name__c  = 'TestName'+i;
            NewPfEvent.Start_Date__c  = date.today()+i;
            NewPfEvent.Status__c  = 'New';
            NewPfEvent.Student_Id__c  = '12345'+i;
            NewPfEvent.JobTitle__c  = 'Mr';
            NewPfEvent.User_name__c  = 'testUserName'+i;             
            NewPFEventList.add(NewPfEvent);

        }
        
        StudentLifeCycles.CreateData(NewPFEventList);
    }
}