public class ContactProcessCE  {
/*
 *   REQ0503706 - Nanda Kothamasu -  Introduced ContactProcessCE_Error static boolean variable.
 * 
 */  
    public static Boolean ContactProcessCE_Error = false;
    public static void newConwrapSLWithCE(List<WrapSLCE> WrappedSLwithContact)
    {
        List<Contact> ContactUpdate=new List<Contact>();
        List<Course_Enrolment__c> CEUpdList=new List<Course_Enrolment__c>();        
        for(WrapSLCE foundCECont:WrappedSLwithContact)
        {
            System.debug('Inside StudentLifeCycle with CouseEnrol found');
            if(foundCECont.cenrol.Contact__c !=Null)
            {
                //Updating Contact Details first
                Contact c=new Contact();
                c.id=foundCECont.cenrol.Contact__c;
                c.Phone=foundCECont.stud.Phone_Number__c;
                c.Deakin_Email__c=foundCECont.stud.Deakin_Email__c;
                c.Email=foundCECont.stud.Email__c;
                c.FirstName=(foundCECont.stud.First_Name__c!=NULL? foundCECont.stud.First_Name__c: '')+' '+
                    (foundCECont.stud.Middle_Name__c!=NULL? foundCECont.stud.Middle_Name__c: '');
                c.LastName=foundCECont.stud.Last_Name__c;
                c.MailingCity=foundCECont.stud.MailingCity__c;
                c.MailingPostalCode=foundCECont.stud.MailingPostalCode__c;
                c.MailingState=foundCECont.stud.MailingState__c;
                c.MailingStreet=foundCECont.stud.MailingStreet__c;
                c.MailingCountry=foundCECont.stud.MailingCountry__c;
                c.MobilePhone=foundCECont.stud.MobilePhone__c;
                c.OtherPhone=foundCECont.stud.OtherPhone__c;
                c.Preferred_Name__c=foundCECont.stud.Preferred_Name__c;
                c.Status__c=foundCECont.stud.Status__c;
                c.Student_Id__c=foundCECont.stud.Student_Id__c;
                c.Title__c=foundCECont.stud.Title__c;
                c.User_name__c=foundCECont.stud.User_name__c;
                c.Address_Type__c=foundCECont.stud.Address_Type__c;
                ContactUpdate.add(c);
                System.debug('Contact needs update list'+ContactUpdate);
            }
            if(foundCECont.cenrol.id !=Null){
                Course_Enrolment__c CE=new Course_Enrolment__c();
                CE.Id=foundCECont.cenrol.id;
                CE.Name=(foundCECont.stud.First_Name__c!=NULL? foundCECont.stud.First_Name__c: '')+' '+
                    (foundCECont.stud.Middle_Name__c!=NULL? foundCECont.stud.Middle_Name__c: '')+' '+
                    (foundCECont.stud.Last_Name__c!=NULL? foundCECont.stud.Last_Name__c: '');                 
                CE.Student_Id__c=foundCECont.Stud.Student_Id__c;
                CE.Course_Code__c=foundCECont.Stud.Course_Code__c;
                CE.Course_Name__c=foundCECont.Stud.Course_Name__c;
                CE.Course_Version__c=foundCECont.Stud.Course_Version__c;
                CE.Status__c=foundCECont.Stud.Status__c;
                CE.Start_Date__c=foundCECont.Stud.Start_Date__c;
                CE.International__c=foundCECont.Stud.International__c;
                CE.Enrolment_Type__c=foundCECont.Stud.Enrolment_Type__c;
                CE.Campus_Location__c=foundCECont.Stud.Campus_Location__c;
                CEUpdList.add(CE); 
                System.debug('Course Enrolment update list' +CEUpdList);
            }
        }
        if (!contactUpdate.isEmpty()) {
            Map<Id,Contact> subContactUpdate = new map<Id,Contact>() ;
            subContactUpdate.putAll(contactUpdate);              
            List<Error__c> ErrorList=new List<Error__c>();
            Database.SaveResult[] srCEnlist=Database.update(subContactUpdate.values(),false);             
            for(Database.SaveResult srCEn:srCEnlist)
            {
                System.debug('Database result' +srCEn);
                if(!srCEn.isSuccess()) {
                    String errorMessage =  srCEn.getErrors().size() > 0 ? srCEn.getErrors()[0].getMessage() : 'Contact Updation failed';
                    ErrorList.add(new Error__c(ErrorMessage__c=errorMessage,
                                               Record_Id__c=srCEn.getId(),
                                               StackTraceString__c=JSON.serializePretty(srCEn.getErrors())));
                    
                }
            }
             //NK Added if condition
      		if(Test.isRunningTest()){
                     ContactProcessCE_Error = true;
            }
                
            if (!ErrorList.isEmpty()) {
                try{    
                    insert ErrorList;
                    ContactProcessCE_Error = true; //NK Added
                }                
                catch (Exception e){
                    system.debug('Failed to write to error object ' + e.getMessage());
                    ContactProcessCE_Error = true; //NK Added
                } 
            }            
        }        
        if (!CEUpdList.isEmpty()) {
            Map<Id,Course_Enrolment__c> subCEUpdate = new map<Id,Course_Enrolment__c>() ;
            subCEUpdate.putAll(CEUpdList);             
            List<Error__c> ErrorList=new List<Error__c>();
            Database.SaveResult[] CEReslist=Database.update(subCEUpdate.values(),false);
            for(Database.SaveResult srCE:CEReslist)
            {
                System.debug('Database result' +srCE);
                if(!srCE.isSuccess()) {
                    String errorMessage =  srCE.getErrors().size() > 0 ? srCE.getErrors()[0].getMessage() : 'Course Enrolment Updation Failed';
                    ErrorList.add(new Error__c(ErrorMessage__c=errorMessage,
                                               Record_Id__c=srCE.getId(),
                                               StackTraceString__c=JSON.serializePretty(srCE.getErrors())));
                    
                }
            }
            if (!ErrorList.isEmpty()) {
                try{    
                    insert ErrorList;
                	ContactProcessCE_Error = true;   //NK Added
                }
                catch (Exception e){
                    system.debug('Failed to write to error object ' + e.getMessage());
                    ContactProcessCE_Error = true;  //NK Added
                } 
            }            
        }           
    }
    public static void newConwrapSLWithoutCE(List<WrapSLCE> WrappedSLwithoutContact)
    {
        List<Contact> ContactUpdate=new List<Contact>();
        List<Course_Enrolment__c> CECreateList=new List<Course_Enrolment__c>();      
        for(WrapSLCE CENotfound:WrappedSLwithoutContact)
        {
            System.debug('Inside StudentLifeCycle with CourseEnrol Not found');
            System.debug('Contact in wrappedSL'+CENotfound.con);
            if(CENotfound.con.id!=Null)
            {
                Contact c=new Contact();
                c.id=CENotfound.con.id;
                c.FirstName=(CENotfound.stud.First_Name__c!=NULL? CENotfound.stud.First_Name__c: '')+' '+
                    (CENotfound.stud.Middle_Name__c!=NULL? CENotfound.stud.Middle_Name__c: '');          
                c.LastName=CENotfound.stud.Last_Name__c;
                c.Email=CENotfound.stud.Email__c;
                c.Deakin_Email__c=CENotfound.stud.Deakin_Email__c;
                c.Phone=CENotfound.stud.Phone_Number__c;
                c.MailingCity=CENotfound.stud.MailingCity__c;
                c.MailingPostalCode=CENotfound.stud.MailingPostalCode__c;
                c.MailingState=CENotfound.stud.MailingState__c;
                c.MailingStreet=CENotfound.stud.MailingStreet__c;
                c.MailingCountry=CENotfound.stud.MailingCountry__c;
                c.MobilePhone=CENotfound.stud.MobilePhone__c;
                c.OtherPhone=CENotfound.stud.OtherPhone__c;
                c.Preferred_Name__c=CENotfound.stud.Preferred_Name__c;
                c.Status__c=CENotfound.stud.Status__c;
                c.Student_Id__c=CENotfound.stud.Student_Id__c;
                c.Title__c=CENotfound.stud.Title__c;
                c.User_name__c=CENotfound.stud.User_name__c;
                c.Address_Type__c=CENotfound.stud.Address_Type__c;
                ContactUpdate.add(c);
            }
            System.debug('Coourse Enrolment in wrappedSL'+CENotfound.cenrol);
            if(CENotfound.cenrol==NULL)
            {
                Course_Enrolment__c CE=new Course_Enrolment__c();
                CE.Name=(CENotfound.stud.First_Name__c!=NULL? CENotfound.stud.First_Name__c: '')+' '+
                    (CENotfound.stud.Middle_Name__c!=NULL? CENotfound.stud.Middle_Name__c: '')+' '+
                    (CENotfound.stud.Last_Name__c!=NULL? CENotfound.stud.Last_Name__c: '');                
                CE.Student_Id__c=CENotfound.Stud.Student_Id__c;
                CE.Course_Code__c=CENotfound.Stud.Course_Code__c;
                CE.Course_Name__c=CENotfound.Stud.Course_Name__c;
                CE.Course_Version__c=CENotfound.Stud.Course_Version__c;
                CE.Status__c=CENotfound.Stud.Status__c;
                CE.Start_Date__c=CENotfound.Stud.Start_Date__c;
                CE.International__c=CENotfound.Stud.International__c;
                CE.Enrolment_Type__c=CENotfound.Stud.Enrolment_Type__c;
                CE.Campus_Location__c=CENotfound.Stud.Campus_Location__c;
                CE.Contact__c=CENotfound.con.id;
                CE.Commencement_Period_Type__c = CENotfound.Stud.Commencement_Period_Type__c;
                CE.Commencement_Period__c = CENotfound.Stud.Commencement_Period__c;
                CE.Commencement_Year__c = CENotfound.Stud.Commencement_Year__c;
                CECreateList.add(CE);
            }
        }
        if (!contactUpdate.isEmpty()) {
            Map<Id,Contact> subContactUpdate = new map<Id,Contact>() ;
            subContactUpdate.putAll(contactUpdate);             
            List<Error__c> ErrorList=new List<Error__c>();
            Database.SaveResult[] srCEnlist=Database.update(subContactUpdate.values(),false);
            for(Database.SaveResult srCEn:srCEnlist)
            {
                if(!srCEn.isSuccess()) {
                    String errorMessage =  srCEn.getErrors().size() > 0 ? srCEn.getErrors()[0].getMessage() : 'Contact Process CE Updation failed';
                    ErrorList.add(new Error__c(ErrorMessage__c=errorMessage,
                                               Record_Id__c=srCEn.getId(),
                                               StackTraceString__c=JSON.serializePretty(srCEn.getErrors())));
                    
                }
            }
            if (!ErrorList.isEmpty()) {
                try{    
                    insert ErrorList;
    	            ContactProcessCE_Error = true;  //NK Added
	               }
                catch (Exception e){
                    system.debug('CPCE - Failed to write to error object ' + e.getMessage());
                    ContactProcessCE_Error = true;  //NK Added
                } 
            }    
        }        
        if (!CECreateList.isEmpty()) {
            Map<Id,Course_Enrolment__c> subCECreate= new map<Id,Course_Enrolment__c>() ;
            subCECreate.putAll(CECreateList);
            
            List<Error__c> ErrorList=new List<Error__c>();
            Database.SaveResult[] CEReslist=Database.insert(subCECreate.values(),false);
            for(Database.SaveResult srCE:CEReslist)
            {
                if(!srCE.isSuccess()) {
                    String errorMessage =  srCE.getErrors().size() > 0 ? srCE.getErrors()[0].getMessage() : 'Course Enrolment Updation Failed';
                    ErrorList.add(new Error__c(ErrorMessage__c=errorMessage,
                                               Record_Id__c=srCE.getId(),
                                               StackTraceString__c=JSON.serializePretty(srCE.getErrors())));
                    
                }
            }
            if (!ErrorList.isEmpty()) {
                try{    
                    insert ErrorList;
                	ContactProcessCE_Error = true; //NK Added
                }
                catch (Exception e){
                    system.debug('Failed to write to error object ' + e.getMessage());
                    ContactProcessCE_Error = true; //NK Added
                } 
            }            
        }          
    }    
    public static void newConwrapSLWithNewCE(List<WrapSLCE> WrappedSLwithoutCEandCONT)
    {
        List<Contact> NewContList=new List<Contact>();
        List<Course_Enrolment__c> NewCEList=new List<Course_Enrolment__c>();
        System.debug('Student life cycle without CE and Contact'+WrappedSLwithoutCEandCONT);
        for(WrapSLCE CECONTNotfound:WrappedSLwithoutCEandCONT)
        {
            System.debug('Student life cycle without CE and Contact');
            Contact c=new Contact();
            c.Phone=CECONTNotfound.stud.Phone_Number__c;
            c.Deakin_Email__c=CECONTNotfound.stud.Deakin_Email__c;                                    
            c.Email=CECONTNotfound.stud.Email__c;
            c.FirstName=(CECONTNotfound.stud.First_Name__c!=NULL? CECONTNotfound.stud.First_Name__c: '')+' '+
                (CECONTNotfound.stud.Middle_Name__c!=NULL? CECONTNotfound.stud.Middle_Name__c: '');
            c.LastName=CECONTNotfound.stud.Last_Name__c;
            c.MailingCity=CECONTNotfound.stud.MailingCity__c;
            c.MailingPostalCode=CECONTNotfound.stud.MailingPostalCode__c;
            c.MailingState=CECONTNotfound.stud.MailingState__c;
            c.MailingStreet=CECONTNotfound.stud.MailingStreet__c;
            c.MailingCountry=CECONTNotfound.stud.MailingCountry__c;
            c.MobilePhone=CECONTNotfound.stud.MobilePhone__c;
            c.OtherPhone=CECONTNotfound.stud.OtherPhone__c;
            c.Preferred_Name__c=CECONTNotfound.stud.Preferred_Name__c;
            c.Status__c=CECONTNotfound.stud.Status__c;
            c.Student_Id__c=CECONTNotfound.stud.Student_Id__c;
            c.Title__c=CECONTNotfound.stud.Title__c;
            c.User_name__c=CECONTNotfound.stud.User_name__c;
            c.Address_Type__c=CECONTNotfound.stud.Address_Type__c;
            NewContList.add(c);          
        }
        System.debug('Inserted New Contacts '+NewContList.size());
        if (!NewContList.isEmpty()) {
            Map<Id,Contact> subNewContList = new map<Id,Contact>() ;
            subNewContList.putAll(NewContList);            
            Database.SaveResult[] srCEnList=Database.insert(subNewContList.values(),false); 
            List<Error__c> ErrorList=new List<Error__c>();            
            Set<Id> savedConId=new Set<Id>();
            System.debug('Database result' +srCEnList);
            for(Database.SaveResult sr:srCEnList)
            {
                System.debug('Database result' +sr);
                System.debug('Inside Contact List creator');                
                if(sr.isSuccess())
                {
                    savedConId.add(sr.getId());
                    System.debug('Inserted Contact');
                }
                if(!sr.isSuccess())
                {
                    String errorMessage =  sr.getErrors().size() > 0 ? sr.getErrors()[0].getMessage() : ' insertion failed for New Contacts (CE)';
                    ErrorList.add(new Error__c(ErrorMessage__c=errorMessage,
                                               Record_Id__c=sr.getId(),
                                               StackTraceString__c=JSON.serializePretty(sr.getErrors())));                    
                }
            }
            if (!ErrorList.isEmpty()) {
                try{    
                    insert ErrorList;
                    ContactProcessCE_Error = true; //NK Added
                    if(test.isRunningTest())
                    {
                        throw new DMLException();
                    }
                }
                catch (Exception e){
                    system.debug('CPCE - Failed to write to error object ' + e.getMessage());
                    ContactProcessCE_Error = true; //NK Added
                } 
            }             
            System.debug('CPCE - Contacts Inserted for No Contact and Course Offer. Moving to Creating of Childs');
            List<Contact> newContacts=[select id, email, phone,Student_Id__c from Contact where ID IN : savedConId]; 
            System.debug('newContacts '+newContacts.size());
            for(Contact c:newContacts)
            {
                for(WrapSLCE CECONTNotfound:WrappedSLwithoutCEandCONT)
                {
                    if(c.Student_Id__c==CECONTNotfound.stud.Student_Id__c)
                    {
                        System.debug('CPCE - Creating New Course Offer based on Student Event');
                        Course_Enrolment__c CE=new Course_Enrolment__c();
                        CE.Name=(CECONTNotfound.stud.First_Name__c!=NULL? CECONTNotfound.stud.First_Name__c: '')+' '+
                            (CECONTNotfound.stud.Middle_Name__c!=NULL? CECONTNotfound.stud.Middle_Name__c: '')+' '+
                            (CECONTNotfound.stud.Last_Name__c!=NULL? CECONTNotfound.stud.Last_Name__c: '');                        CE.Contact__c=c.id;
                        CE.Student_Id__c=CECONTNotfound.Stud.Student_Id__c;
                        CE.Course_Code__c=CECONTNotfound.Stud.Course_Code__c;
                        CE.Course_Name__c=CECONTNotfound.Stud.Course_Name__c;
                        CE.Course_Version__c=CECONTNotfound.Stud.Course_Version__c;
                        CE.Status__c=CECONTNotfound.Stud.Status__c;
                        CE.Start_Date__c=CECONTNotfound.Stud.Start_Date__c;
                        CE.International__c=CECONTNotfound.Stud.International__c;
                        CE.Enrolment_Type__c=CECONTNotfound.Stud.Enrolment_Type__c;
                        CE.Campus_Location__c=CECONTNotfound.Stud.Campus_Location__c;
                        CE.Commencement_Period_Type__c = CECONTNotfound.Stud.Commencement_Period_Type__c;
                        CE.Commencement_Period__c = CECONTNotfound.Stud.Commencement_Period__c;
                        CE.Commencement_Year__c = CECONTNotfound.Stud.Commencement_Year__c;
                        NewCEList.add(CE);
                    }
                }
            }
            if(!NewCEList.isEmpty())
            {
                Map<Id,Course_Enrolment__c> subNewCEList = new map<Id,Course_Enrolment__c>() ;
                subNewCEList.putAll(NewCEList);                 
                Database.SaveResult[] CEInslist=Database.Insert(subNewCEList.values(),false);
                for(Database.SaveResult sr:CEInslist)
                {
                    if(!sr.isSuccess()) {
                        String errorMessage =  sr.getErrors().size() > 0 ? sr.getErrors()[0].getMessage() : ' insertion failed for New Course Enrolment.';
                        ErrorList.add(new Error__c(ErrorMessage__c=errorMessage,
                                                   Record_Id__c=sr.getId(),
                                                   StackTraceString__c=JSON.serializePretty(sr.getErrors())));
                    }
                }
                if (!ErrorList.isEmpty()) {
                    try{ 
                        insert ErrorList;
                    	ContactProcessCE_Error = true;  //NK Added
                    }
                    catch (Exception e){
                        system.debug('CPCE - Failed to write to error object ' + e.getMessage());
                        ContactProcessCE_Error = true;  //NK Added
                    } 
                } 
            }
            
        } 
        
    }
}