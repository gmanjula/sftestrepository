@istest
public class testclass {
    private static testmethod void chec(){
        contact cc=new contact();
        cc.LastName ='test sujesh';
        insert cc;
       batchdelete bb=new batchdelete();
        database.executebatch(bb);
    }
    
}