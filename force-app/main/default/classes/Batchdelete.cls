global class Batchdelete implements database.batchable<sobject> {
    
    global database.QueryLocator start(database.BatchableContext bc){
        
        return database.getQueryLocator('select id,lastname from contact where name like\'test%\'');
             
    }
    global  void execute(database.BatchableContext bc , list<contact> conlist){
        delete conlist;
    }
    global void finish(database.BatchableContext bc){
        //'creating a mail list');
        list<messaging.SingleEmailMessage> mlist = new list<messaging.SingleEmailMessage>();
        //system.debug('creating a single email');
        messaging.SingleEmailMessage mail = new messaging.SingleEmailMessage();
        //system.debug('setting up mail details sender,body,subject');
        mail.setSubject('The Batch delete is finished');
        list<string> addresslist = new list<string>();
        addresslist.add('manjulaec45@gmail.com');
        mail.setToAddresses(addresslist);
        mail.setSenderDisplayName('this is a batch delete');
        String body = 'Dear man our batch apex execution is completed . ';
        body += 'I confess this will come as a shock to you.';
        body += 'I am John Alliston CEO of the Bank of Nigeria.';
        mail.setHtmlBody(body);
       // system.debug('adding  mails to the list');
        mlist.add(mail);
       // system.debug('sending all mails in the list');
        messaging.sendEmail(mlist);
    }
}