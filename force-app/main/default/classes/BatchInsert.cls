Global class BatchInsert Implements database.batchable<sobject>{
    
    global list<contact> start(database.BatchableContext bc){
        list<contact> clist= new list<contact>();
        for(integer i=1;i<101;i++){
            contact c = new contact();	
            c.lastname = 'test sujesh' + i ;
            c.phone = '9876543' + i;
            c.fax = '1234' + i;
            clist.add(c);
        }
        return clist;
    }
    global void execute(database.BatchableContext bc, list<contact> conlist){
        insert conlist;
    }
    global void finish(database.BatchableContext bc){
        system.debug('creating a mail list');
        list<messaging.SingleEmailMessage> mlist = new list<messaging.SingleEmailMessage>();
        system.debug('creating a single email');
        messaging.SingleEmailMessage mail = new messaging.SingleEmailMessage();
        system.debug('setting up mail details sender,body,subject');
        mail.setSubject('The Batch insert is finished');
        list<string> addresslist = new list<string>();
        addresslist.add('manjulaec45@gmail.com');
        mail.setToAddresses(addresslist);
        mail.setSenderDisplayName('this is a batch');
        String body = 'Dear man our batch apex execution is completed . ';
        body += 'I confess this will come as a surprise to you.';
        body += 'I am John Alliston CEO of the Bank of Nigeria.';
        mail.setHtmlBody(body);
        system.debug('adding  mails to the list');
        mlist.add(mail);
        system.debug('sending all mails in the list');
        messaging.sendEmail(mlist);
    }
}