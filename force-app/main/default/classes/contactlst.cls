public class contactlst {
    
    @AuraEnabled
    public static list<contact> getcontact( string con){
        string name= con +'%' ;
        list<contact> conlist= new list<contact>([select id, lastname,phone,fax from contact where lastname like 'name']);
        return conlist;
        
    }

}