@isTest
public class DeleteCampusServicesRecords_Test {
    // Init Test Data
        @TestSetup
        static void TestData()
        {
             Date curDate = Date.valueOf(date.today());
            Time myTime = Time.newInstance(1, 2, 55, 0);
            Campus_Services_Trace__c cst = new Campus_Services_Trace__c(
        	First_Name__c='firstName',
        	Last_Name__c='lastName',
        	Contact_Number__c='contactno',
        	Email__c='email@test.com',
        	Location__c='location',
            Date__c= curDate
            //Text_Time__c = String.myTime
           	);            
            insert cst;
            Datetime xdays = Datetime.now().addDays(-31);
			Test.setCreatedDate(cst.Id, xdays); 
            
            
        
        }
    
     public static testmethod void testone()
        {
            Test.startTest();
            DeleteCampusServicesRecordsSchedule SchedBatch =new DeleteCampusServicesRecordsSchedule();
            String CRON_EXP = '0 0 0 25 9 ? *';
            String JobId=system.schedule('Test Scheduled Batch', CRON_EXP, SchedBatch);
            CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
            System.assertEquals(CRON_EXP, ct.CronExpression);
            System.assertEquals(0, ct.TimesTriggered);
            Test.stopTest();
        }
    @isTest
    private static void testBatch(){
        Test.startTest();
        DeleteCampusServicesRecords batch = new DeleteCampusServicesRecords();
        Database.executeBatch(batch);
        Test.stopTest();
    }

}