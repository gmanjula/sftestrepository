public class auraexample {
    @AuraEnabled
    public static string getName(string firstname, string lastname){
        string name = lastname +'-'+firstname;
        return name;
    }

}