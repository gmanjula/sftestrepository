public class Accounttriggerhelper {
    
    public static void createopportunity(list<account> actlist, map<id,account> actmap ){
        
        list<opportunity> listopp = new list<opportunity>();
        
        for(account ac:actlist){
            
            if(trigger.isinsert && (ac.phone==NULL||ac.phone=='')){ 
                
                ac.phone.addError('please enter phone number in insert' );   
            } 
            else if(trigger.isupdate && (ac.phone==NULL||ac.phone=='')){ 
                
                ac.phone.addError('please enter phone number in update' );   
            }
            else if(trigger.isafter && trigger.isinsert &&(ac.Rating=='Hot')){
                Opportunity op= new Opportunity(); 
                op.Name= ac.Name;
                op.StageName='Prospecting';
                op.Type='Existing Customer - Upgrade';
                op.CloseDate=date.today().addmonths(1);
                op.LeadSource='Web';
                op.accountid= ac.id;
                listopp.add(op);
            }
        } if(!listopp.isEmpty()){
            insert listopp;
        }
        if(trigger.isafter && trigger.isupdate){
            for(opportunity op:[select id,name,accountid,closedate from opportunity where accountid IN: actlist ] ){
                op.Name=actmap.get(op.accountid).Name;
                op.StageName='Needs Analysis';
                op.Type='Existing Customer - Replacement';
                op.CloseDate=date.today().addmonths(2);
                listopp.add(op);
            }
            if(!listopp.isEmpty()){
            update listopp;
        }
        }
        
    }
}