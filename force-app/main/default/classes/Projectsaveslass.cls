public class Projectsaveslass {
    
    public project__c prjrec{ get; set;}
    
    public Projectsaveslass(){
        prjrec = new project__c();
    }
    
    public pagereference saveproject(){
        insert prjrec;
        return new pagereference('/'+prjrec.Id);
    }

}