public with sharing class objwrapper {

    public list<childwrapper> lstobj { get; set; }
    
    public class childwrapper{
     public Boolean check{get; set;}
     public account act{get; set;} 
     public project__c prj{get; set;}
     public contact emp{get; set;}
    
       public childwrapper(Boolean b,Account a, Contact c,project__c p){
            check=b;
            act=a;
            emp=c;
            prj=p;
       }
    }
    public objwrapper(){
       lstobj= new list<childwrapper>();
       list<account> aclst= new list<account>([select id, name,phone from account limit 10]);
       list<contact> conlst= new list<contact>([select id,lastname,phone from contact limit 15]);
       list<project__c> prjlst=new list<project__c>([select id,name,client__c from project__c limit 15]);
        for(integer i=0;i<10;i++){
         lstobj.add(new childwrapper(false,aclst[i],conlst[i],prjlst[i]));
        }
    }
}