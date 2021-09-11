public class projecttriggerhandler {
        
     public static void stateupdate(list<project__c> newlist , map<id,project__c> oldmap){
        for(project__c pp:newlist){
            system.debug('..trigger.oldmap.get(pr.id)..'+oldmap.get(pp.id));
            system.debug('..trigger.oldmap.get(pr.id).name..'+oldmap.get(pp.id).name);
            system.debug('----name---' +pp.name);
            if(trigger.isupdate && pp.name!=oldmap.get(pp.id).name){
              pp.name.addError('No name change is allowed');
            }
            if(pp.work_loaction__c!=NULL && pp.State__c==NULL){
                if(pp.work_loaction__c=='Australia'){
                    pp.State__c='NSW';
                }
                else if(pp.work_loaction__c=='Canada'){
                    pp.State__c='Ontario';
                }
                else if(pp.work_loaction__c=='India'){
                    pp.State__c='AP';
                }
                else if(pp.work_loaction__c=='UK'){
                    pp.State__c='Northwest';
                }
                else if(pp.work_loaction__c=='US'){
                    pp.State__c='Florida'; 
                }
                    
            }
        }
    }
    public static void dupeemail(list<project__c> newlist1){
        set<string> setofemail = new set<string>();
        map<string,project__c> mapprj = new map<string,project__c>();
        for(project__c pr:newlist1){
            setofemail.add(pr.project_contact_Email_id__c);
            system.debug('...setofemail...'+setofemail);
        }
        
        for(project__c pr:[select id,project_contact_Email_id__c,Name from project__c where project_contact_Email_id__c IN:setofemail ]){
          mapprj.put(pr.project_contact_Email_id__c,pr);
            system.debug('....map of projects' +mapprj);
        }
        for(project__c p1:newlist1){
            system.debug('....current email id...' +p1.project_contact_Email_id__c);
            if(mapprj.containskey(p1.project_contact_Email_id__c) && trigger.isinsert){
                p1.project_contact_Email_id__c.addError('Email already exist please enter differerent email');
            }
        }
    }

}