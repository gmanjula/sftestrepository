trigger projectNoNameCange on project__c (before update,before insert,after insert) {
   
    if(trigger.isupdate){
       projecttriggerhandler.stateupdate(trigger.new , trigger.oldmap);
    }
   /* if(trigger.isinsert && trigger.isbefore){
      projecttriggerhandler.dupeemail(trigger.new);
    }*/
     if(trigger.isafter){
         
     System.debug('before calling email alert');
     //sendemail.emailalert(trigger.new);
     System.debug('after calling email alert');
     }
    
}