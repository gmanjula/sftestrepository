global class AccountPACStatusUpdateBatch implements Database.Batchable<sObject>,Database.stateful{
    public Boolean isError=false;
    global String Query;
    global String objName;    
    List<Error__c> ErrorList=new List<Error__c>(); 
    global AccountPACStatusUpdateBatch(String q1)
    {
          // get all PAC records where contract status is Active
 	      Query= 'select Id,contract_status__c,Contract__c, Partner__c from Partner_and_Contract__c where contract_status__c = \'Active\' limit 40000';
          objName ='Partner_and_Contract__c';
 	 }
 	 
    global AccountPACStatusUpdateBatch(){
          // get all account records which has PAC Status as Active
          Query='select Id,Name, PAC_Status__c, RecordType.DeveloperName from Account where RecordType.DeveloperName = \'Partner_Account2\' and PAC_Status__c = \'Active\' limit 40000';
          objName ='Account';
  	   }
    
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        System.debug('Query is:'+Query);
        return Database.getQueryLocator(Query);
    }
    
    global void execute(Database.BatchableContext bc, List<sObject> scope){
        
            
		System.debug('Entered execute:'+Query);
        List<Account> updeventobj=new List<Account>();
        If(objName == 'Account'){ 
            for(sObject updateAcc:scope)
            { 
                Id objId = updateAcc.Id;
			//	SObject record = objId.getSObjectType().newSObject(objId); 
                Account record = (Account)objId.getSObjectType().newSObject(objId);
                record.put('PAC_Status__c','');
             //updateAcc.PAC_Status__c='';
              updeventobj.add(record);
         	}            
                        
            List<Database.SaveResult> srlist=new List<Database.SaveResult>();
        	srlist=Database.update(updeventobj);
         	for(Database.SaveResult ceRes:srlist)
        	{
            if(!ceRes.isSuccess()) {
                // Record error Details
                String errorMessage =  ceRes.getErrors().size() > 0 ? ceRes.getErrors()[0].getMessage() : 'Account - Update PAC Status to NULL Failed on Account Records';
                ErrorList.add(new Error__c(ErrorMessage__c=ceRes.getErrors()[0].getMessage(),
                                           Record_Id__c=ceRes.getId(),
                                           StackTraceString__c=JSON.serializePretty(ceRes.getErrors())));          
             }
        }
            
        }else{
            Set<Id> AIDs = new Set<Id>();
            Sobject SitEduTestEvent;
        	for( sObject AccID:scope)
       		 {
              Id pId = (Id)AccID.get('Partner__c');
                AIDs.add(pId);
           	    System.debug('AccIDs '+AIDs);
        	}
        	String accountQueryStr= 'SELECT Id,PAC_Status__c FROM Account where ID IN :AIDs limit 40000'; 
            List<Account> updatePACStatus = (List<Account>)(Database.query(accountQueryStr)); 
            System.debug('updatePACStatus '+ updatePACStatus);
        	updatePACStatus = (List<Account>)(Database.query(accountQueryStr));
            for(Account aAccount:updatePACStatus){
           		 aAccount.PAC_Status__c='Active';
           		 updeventobj.add(aAccount);
        	}   
            List<Database.SaveResult> PACStatuslist=new List<Database.SaveResult>();
        	PACStatuslist=Database.update(updeventobj);
         	for(Database.SaveResult ceRes:PACStatuslist)
        	{
            if(!ceRes.isSuccess()) {
                // Record error Details 
                String errorMessage =  ceRes.getErrors().size() > 0 ? ceRes.getErrors()[0].getMessage() : 'Partner_and_Contract__c - Update PAC Status to Active Failed on Account Records';
                ErrorList.add(new Error__c(ErrorMessage__c=ceRes.getErrors()[0].getMessage(),
                                           Record_Id__c=ceRes.getId(),
                                           StackTraceString__c=JSON.serializePretty(ceRes.getErrors())));   
            }
            }
        }   
    
       
    }
   global void finish(Database.BatchableContext bc) {
        System.debug('Final isError Value'+isError); 
       If(objName == 'Account'){ 
        Database.executeBatch(new AccountPACStatusUpdateBatch('Partner_and_Contract__c'));
       }
        
    }
}