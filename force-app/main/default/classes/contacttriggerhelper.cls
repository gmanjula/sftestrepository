public class contacttriggerhelper {
    
    public static boolean isrec=true;
    //adding comment
    //without Vscode
    public static void leadsourceupdate(list<contact> newlst){
        list<contact> conlist = new list<contact>();
        for(contact cc:[select id,lastname,leadsource from contact where id IN:newlst]){
            cc.leadsource='web';
            conlist.add(cc);
        }
        if(!conlist.isEmpty()){
            isrec=false;
            update conlist;
        }
        
    }
      
    
    public static void dupephone(list<contact> newlst, boolean isInert){
        set<string> setofphones=new set<string>();
        map<string,contact> mapcon=new map<string,contact>();
    for(contact con:newlst){
      setofphones.add(con.phone);
      system.debug('----setofphone---'+setofphones);  
    }
     for(contact ph: [select id,phone,lastname  from contact where phone IN:setofphones]){
      mapcon.put(ph.phone,ph);
      system.debug('----mapcontacts---'+mapcon);
     }
     
     for(contact con:newlst){
        if(mapcon.containsKey(con.phone) && trigger.isinsert){
        
          system.debug('---matched---'+con.phone);  
         con.phone.addError('please enter different phone insert');
         
        } else if(mapcon.containsKey(con.phone) && trigger.isupdate && mapcon.get(con.phone).id!= con.id){
        
          system.debug('---matched---'+con.phone);  
         con.phone.addError('please enter different phone in own update');
        } 
     }
    }
    public static void defaultvaluephonefax(list<contact> newlst1 ){
        for(contact ph: newlst1){
            if(ph.Phone==Null){
                ph.Phone='11111111';
            }
            else if(ph.Phone!=Null && ph.Fax==Null){
                ph.Fax=ph.Phone;
            }
        }
    }

}