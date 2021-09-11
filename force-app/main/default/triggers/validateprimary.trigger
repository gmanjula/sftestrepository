trigger validateprimary on Address__c (before insert,before update) {

    list<Address__c> addlist= [select Account__c,primary_address__c from Address__c]; 
        system.debug(' validate address list' +addlist);
        system.debug('  address list size' +addlist.size());
        
      set<Id> accset = new set<Id>() ;
      for ( Address__c s : trigger.new ){
      if(s.Account__c != null)
         accSet.add(s.Account__c);
      }
      // system.dbug(' set of accounts' +accset);

     for(Address__c ad:trigger.new){
      //system.debug(' in for a loop' +addlist.size());
      if(addlist.size()==0){
           system.debug(' in a if loop');
          ad.primary_address__c=true;
     }
     if(ad.primary_address__c=true){
     
     }
     for(Address__c prad:[select id, name, primary_address__c from  Address__c  where  primary_address__c=true ]){
       prad.primary_address__c=false;
       addlist.add(prad);
     }
     update addlist;
    }
      
    
}