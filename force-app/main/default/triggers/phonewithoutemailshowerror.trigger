trigger phonewithoutemailshowerror on project__c (before insert,before update) {

      for(project__c pr:trigger.new){
         
            if( pr.project_phone__c!=NULL ){
            
                if(pr.project_contact_Email_id__c== NULL){
                   
                   pr.addError('Email is mandatory when phone number is there');
                }
            
            }
            
      }

}