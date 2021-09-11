trigger phonedupe on Contact (before insert, before update,after update) {

//contacttriggerhelper.dupephone(trigger.new,trigger.isinsert);
//contacttriggerhelper.defaultvaluephonefax(trigger.new);
system.debug('-----contacttriggerhelper.isrec---'+contacttriggerhelper.isrec);
if(trigger.isupdate && trigger.isafter){
if(contacttriggerhelper.isrec){
contacttriggerhelper.leadsourceupdate(trigger.new);
}
}

}