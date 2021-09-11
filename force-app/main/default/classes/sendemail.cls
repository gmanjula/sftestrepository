global class sendemail {
    @InvocableMethod(label='sending email')
      global static void emailalert(list<project__c> newlist){
          
          for(project__c pr:newlist){
            system.debug('project contact email id is---' +pr.project_contact_Email_id__c);
              //system.debug([SELECT Id,Body FROM EmailTemplate WHERE developerName ='Project_Email_alert' limit 1]);
            EmailTemplate et = [SELECT Id, Body FROM EmailTemplate WHERE developerName ='Project_Email_alert' limit 1];
            system.debug('query---'+et);
            system.debug('*****email template****' +et.Body);
            List<string> addresslist = new List<string>();
            list<messaging.SingleEmailMessage> mlist = new list<messaging.SingleEmailMessage>();
            addresslist.add(pr.project_contact_Email_id__c);
            system.debug('...email to send these addressess...'+addresslist);
              
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setTemplateId(et.Id);
           email.setPlainTextBody(et.Body);
            email.setToAddresses(addresslist);
            system.debug('I am in Email alert');
            email.setSenderDisplayName('manju');
            email.setSubject(' Start work on project Name pr.name');
            /*String body = 'Dear team we got new project . ';
            body += 'I confess this will come as a surprise to you.';
            body += 'start working on this new project.';
            email.setHtmlBody(body);*/
            System.debug(' mail is------'+email);
            mlist.add(email);
            system.debug('mail is added to list');
            Messaging.sendEmail(mlist);
        }
    }
    global class project{
        @invocablevariable
        global id projectid;
        @invocablevariable
        global string projectcontactEmailid;
        @invocablevariable
        global date startdate;
        @invocablevariable
        global string name;
        
        
        
    }
}