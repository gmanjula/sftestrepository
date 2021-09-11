public class contactlist {
    @AuraEnabled
    public static list<contact> getlist(string lname){
        
        return [select name,AccountId,phone,fax from contact where name=:lname];
    }

}