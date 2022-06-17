public class CourseEnrolmentTriggerHandler {
    public static void setAccountStatusAndSubStatus(List<Course_Enrolment__c> triggeredRecordList){
        Set<Id> leadIds = new Set<Id>();
        Set<Id> contactIds = new Set<Id>();
        List<Error__c> errorList = new List<Error__c>();
        Set<Id> lifeCyceIdsReprocess = new Set<Id>();
        
        Map<Lead,List<Course_Enrolment__c>> courseEnrolmentsByLead = new Map<Lead,List<Course_Enrolment__c>>();
        Map<Contact,List<Course_Enrolment__c>> courseEnrolmentsByContact = new Map<Contact,List<Course_Enrolment__c>>();
        Map<String,Course_Title__c> courseTitleByCourseCode = new Map<String,Course_Title__c>();
        try{
            for(Course_Enrolment__c courseEnrolment : triggeredRecordList){
                if(!String.isEmpty(courseEnrolment.Contact__c)){//FIRST TO CHECK SINCE CONTACT ID IS THE MAIN PRIORITY (IF LEAD CONVERSION HAS ALREADY TAKEN PLACE)
                    contactIds.add(courseEnrolment.Contact__c);
                }
                else if(!String.isEmpty(courseEnrolment.Lead__c)){//SECOND TO CHECK SINCE LEAD ID IS PRESENT (IF LEAD CONVERSION HAS NOT TAKEN PLACE)
                    leadIds.add(courseEnrolment.Lead__c);
                }
            }
            
            if(!contactIds.isEmpty() || !leadIds.isEmpty()){//CHECK WHETHER THE TRIGGERED RECORDS HAS PARENT LEAD OR CONTACT
                String key = '';
                Map<String,Callista_Status_Precedence__mdt> precedenceRecordByStatus = new Map<String,Callista_Status_Precedence__mdt>();
                Map<Integer,Callista_Status_Precedence__mdt> precedenceRecordByPrecedenceNumber = new Map<Integer,Callista_Status_Precedence__mdt>();
                
                for(Callista_Status_Precedence__mdt precedenceMetadataRec : [SELECT Id, Account_Status__c, Account_Substatus__c, Precedence__c, Status_Explanation__c, 
                                                                             Callista_Status__c FROM Callista_Status_Precedence__mdt]){
                                                                                 key = !String.isEmpty(precedenceMetadataRec.Status_Explanation__c) ? precedenceMetadataRec.Callista_Status__c + precedenceMetadataRec.Status_Explanation__c : precedenceMetadataRec.Callista_Status__c;
                                                                                 precedenceRecordByStatus.put(key,precedenceMetadataRec);
                                                                                 precedenceRecordByPrecedenceNumber.put(Integer.valueOf(precedenceMetadataRec.Precedence__c),precedenceMetadataRec);
                                                                                 
                                                                             }
                
                //QUERY COURSE CODE
                List<Course_Title__c> courseNames = new List<Course_Title__c>();
                
                for(Course_Title__c courseCode : [SELECT Name, Course_Code__c, FutureLearn__c, Case_Managed_course__c, Suite__c FROM Course_Title__c LIMIT 50000]){
                    courseTitleByCourseCode.put(courseCode.Course_Code__c,courseCode);//VALUE IS TO TITLECASE
                }
                
                List<Lead> leadsToBeUpdated = new List<Lead>();
                List<Contact> contactsToBeUpdated = new List<Contact>();
                
                UtilityClass.WrapperClassCourseOfferings mapCourseOfferingWrapper = new UtilityClass.WrapperClassCourseOfferings();
                mapCourseOfferingWrapper = UtilityClass.getRelatedCourseOffering(leadIds,contactIds);
                
                UtilityClass.WrapperClassCourseApplication mapCourseApplicationWrapper = new UtilityClass.WrapperClassCourseApplication();
                mapCourseApplicationWrapper = UtilityClass.getRelatedCourseApplication(leadIds,contactIds);
                
                UtilityClass.WrapperClassCourseEnrolment mapCourseEnrolmentWrapper = new UtilityClass.WrapperClassCourseEnrolment();
                mapCourseEnrolmentWrapper = UtilityClass.getRelatedCourseEnrolment(leadIds,contactIds);
                
                
                UtilityClass.CourseOfferingPrecedence getPrecedenceWrapperOffering = new UtilityClass.CourseOfferingPrecedence();
                getPrecedenceWrapperOffering = UtilityClass.getCourseOfferingWithLeastPrecedence(mapCourseOfferingWrapper.courseOfferingsByLead, mapCourseOfferingWrapper.courseOfferingsByContact, precedenceRecordByStatus);
                
                
                UtilityClass.CourseApplicationPrecedence getPrecedenceWrapperApplication = new UtilityClass.CourseApplicationPrecedence();
                getPrecedenceWrapperApplication = UtilityClass.getCourseApplicationWithLeastPrecedence(mapCourseApplicationWrapper.courseApplicationsByLead, mapCourseApplicationWrapper.courseApplicationsByContact, precedenceRecordByStatus);
                
                
                UtilityClass.CourseEnrolmentPrecedence getPrecedenceWrapperEnrolment = new UtilityClass.CourseEnrolmentPrecedence();
                getPrecedenceWrapperEnrolment = UtilityClass.getCourseEnrolmentWithLeastPrecedence(mapCourseEnrolmentWrapper.courseEnrolmentsByLead, mapCourseEnrolmentWrapper.courseEnrolmentsByContact, precedenceRecordByStatus);
                System.debug('getPrecedenceWrapperEnrolment Value: ' + getPrecedenceWrapperEnrolment);
                //LOOPS ON LEADS BASED FROM TRIGGERED COURSE ENROLMENT RECORDS
                for(Lead leadRecord : mapCourseEnrolmentWrapper.courseEnrolmentsByLead.keySet()){
                    Integer courseOfferingPrecedence;
                    Integer courseEnrolmentPrecedence;
                    Integer courseApplicationPrecedence;
                    
                    List<Integer> precedenceValues = new List<Integer>();
                    if(getPrecedenceWrapperOffering.leastPrecedenceByLeadOrContactId.containsKey(leadRecord.Id)){
                        courseOfferingPrecedence = getPrecedenceWrapperOffering.leastPrecedenceByLeadOrContactId.get(leadRecord.Id);
                        precedenceValues.add(courseOfferingPrecedence);
                    }
                    if(getPrecedenceWrapperApplication.leastPrecedenceByLeadOrContactId.containsKey(leadRecord.Id)){
                        courseApplicationPrecedence = getPrecedenceWrapperApplication.leastPrecedenceByLeadOrContactId.get(leadRecord.Id);
                        precedenceValues.add(courseApplicationPrecedence);
                    }
                    if(getPrecedenceWrapperEnrolment.leastPrecedenceByLeadOrContactId.containsKey(leadRecord.Id)){
                        courseEnrolmentPrecedence = getPrecedenceWrapperEnrolment.leastPrecedenceByLeadOrContactId.get(leadRecord.Id);
                        precedenceValues.add(courseEnrolmentPrecedence);
                    }
                    
                    //System.debug('Precedence Values: ' + precedenceValues);
                    //Minimum Value Checker 
                    Integer minVal;
                    for(Integer counter =0 ; counter < precedenceValues.size() ; counter++){
                        if(minVal == null){
                            minVal = precedenceValues.get(counter);
                        }
                        else{
                            minVal = precedenceValues.get(counter) < minVal ? precedenceValues.get(counter) : minVal;
                        }
                    }
                    
                    //System.debug('Minimum Precedence: ' + minVal);
                    //CHECKING WHETHER ITS COURSE OFFERING, COURSE ENROLMENT, OR COURSE APPLICATION
                    String courseCode = '';
                    if(minVal != null){
                        if(courseOfferingPrecedence == minVal){
                            //System.debug('Course Offering has least precedence');
                            courseCode = getPrecedenceWrapperOffering.leastCourseOfferingByLeadOrContactId.get(leadRecord.Id).Course_Code__c;
                            
                            leadRecord.Account_Status__c =  precedenceRecordByPrecedenceNumber.containsKey(minVal) ? precedenceRecordByPrecedenceNumber.get(minVal).Account_Status__c : '';
                            leadRecord.Account_Substatus__c = precedenceRecordByPrecedenceNumber.containsKey(minVal) ? precedenceRecordByPrecedenceNumber.get(minVal).Account_Substatus__c : '';
                            leadRecord.FutureLearn__c = courseTitleByCourseCode.containsKey(courseCode) ? courseTitleByCourseCode.get(courseCode).FutureLearn__c : false;
                            leadRecord.CM_course_applied__c = courseTitleByCourseCode.containsKey(courseCode) ? courseTitleByCourseCode.get(courseCode).Case_Managed_Course__c : false;//UAT UPDATE
                            leadRecord.Inferred_Course__c = courseTitleByCourseCode.containsKey(courseCode) ? UtilityClass.ToTitleCase(courseTitleByCourseCode.get(courseCode).Name) : '';
                            leadRecord.Course_Category__c = courseTitleByCourseCode.containsKey(courseCode) ? courseTitleByCourseCode.get(courseCode).Suite__c : ''; //UAT UPDATE
                            leadRecord.Course_Applied__c = getPrecedenceWrapperOffering.leastCourseOfferingByLeadOrContactId.get(leadRecord.Id).Course_Name__c;//UAT UPDATE
                        } 
                        else if(courseApplicationPrecedence == minVal){
                           // System.debug('Course Application has least precedence');
                            courseCode = getPrecedenceWrapperApplication.leastCourseApplicationByLeadOrContactId.get(leadRecord.Id).Course_Code__c;
                            
                            leadRecord.Account_Status__c =  precedenceRecordByPrecedenceNumber.containsKey(minVal) ? precedenceRecordByPrecedenceNumber.get(minVal).Account_Status__c : '';
                            leadRecord.Account_Substatus__c = precedenceRecordByPrecedenceNumber.containsKey(minVal) ? precedenceRecordByPrecedenceNumber.get(minVal).Account_Substatus__c : '';
                            leadRecord.FutureLearn__c = courseTitleByCourseCode.containsKey(courseCode) ? courseTitleByCourseCode.get(courseCode).FutureLearn__c : false;
                            leadRecord.CM_course_applied__c = courseTitleByCourseCode.containsKey(courseCode) ? courseTitleByCourseCode.get(courseCode).Case_Managed_Course__c : false;//UAT UPDATE
                            leadRecord.Inferred_Course__c = courseTitleByCourseCode.containsKey(courseCode) ? UtilityClass.ToTitleCase(courseTitleByCourseCode.get(courseCode).Name) : '';
                            leadRecord.Course_Category__c = courseTitleByCourseCode.containsKey(courseCode) ? courseTitleByCourseCode.get(courseCode).Suite__c : ''; //UAT UPDATE
                            leadRecord.Course_Applied__c = getPrecedenceWrapperApplication.leastCourseApplicationByLeadOrContactId.get(leadRecord.Id).Course_Name__c;//UAT UPDATE
                        }
                        else if(courseEnrolmentPrecedence == minVal){
                            //System.debug('Course Enrolment has least precedence');
                            courseCode = getPrecedenceWrapperEnrolment.leastCourseEnrolmentByLeadOrContactId.get(leadRecord.Id).Course_Code__c;
                            
                            leadRecord.Account_Status__c =  precedenceRecordByPrecedenceNumber.containsKey(minVal) ? precedenceRecordByPrecedenceNumber.get(minVal).Account_Status__c : '';
                            leadRecord.Account_Substatus__c = precedenceRecordByPrecedenceNumber.containsKey(minVal) ? precedenceRecordByPrecedenceNumber.get(minVal).Account_Substatus__c : '';
                            leadRecord.FutureLearn__c = courseTitleByCourseCode.containsKey(courseCode) ? courseTitleByCourseCode.get(courseCode).FutureLearn__c : false;
                            leadRecord.CM_course_applied__c = courseTitleByCourseCode.containsKey(courseCode) ? courseTitleByCourseCode.get(courseCode).Case_Managed_Course__c : false; //UAT UPDATE
                            leadRecord.Inferred_Course__c = courseTitleByCourseCode.containsKey(courseCode) ? UtilityClass.ToTitleCase(courseTitleByCourseCode.get(courseCode).Name) : '';
                            leadRecord.Course_Category__c = courseTitleByCourseCode.containsKey(courseCode) ? courseTitleByCourseCode.get(courseCode).Suite__c : ''; //UAT UPDATE
                            leadRecord.Course_Applied__c = getPrecedenceWrapperEnrolment.leastCourseEnrolmentByLeadOrContactId.get(leadRecord.Id).Course_Name__c;//UAT UPDATE
                        }
                    }
                    leadsToBeUpdated.add(leadRecord);
                }
                
                //LOOPS ON CONTACTS BASED FROM TRIGGERED COURSE OFFERING RECORDS
                for(Contact conRecord : mapCourseEnrolmentWrapper.courseEnrolmentsByContact.keySet()){
                    Integer courseOfferingPrecedence;
                    Integer courseEnrolmentPrecedence;
                    Integer courseApplicationPrecedence;
                    
                    List<Integer> precedenceValues = new List<Integer>();
                    if(getPrecedenceWrapperOffering.leastPrecedenceByLeadOrContactId.containsKey(conRecord.Id)){
                        courseOfferingPrecedence = getPrecedenceWrapperOffering.leastPrecedenceByLeadOrContactId.get(conRecord.Id);
                        precedenceValues.add(courseOfferingPrecedence);
                    }
                    if(getPrecedenceWrapperApplication.leastPrecedenceByLeadOrContactId.containsKey(conRecord.Id)){
                        courseApplicationPrecedence = getPrecedenceWrapperApplication.leastPrecedenceByLeadOrContactId.get(conRecord.Id);
                        precedenceValues.add(courseApplicationPrecedence);
                    }
                    if(getPrecedenceWrapperEnrolment.leastPrecedenceByLeadOrContactId.containsKey(conRecord.Id)){
                        courseEnrolmentPrecedence = getPrecedenceWrapperEnrolment.leastPrecedenceByLeadOrContactId.get(conRecord.Id);
                        precedenceValues.add(courseEnrolmentPrecedence);
                    }
                    
                    //Minimum Value Checker
                    Integer minVal;
                    for(Integer counter =0 ; counter < precedenceValues.size() ; counter++){
                        if(minVal == null){
                            minVal = precedenceValues.get(counter);
                        }
                        else{
                            minVal = precedenceValues.get(counter) < minVal ? precedenceValues.get(counter) : minVal;
                        }
                    }
                    
                    //System.debug('Minimum Precedence: ' + minVal);
                    //CHECKING WHETHER ITS COURSE OFFERING, COURSE ENROLMENT, OR COURSE APPLICATION
                    String courseCode = '';
                    if(minVal != null){
                        if(courseOfferingPrecedence == minVal){
                            //System.debug('Course Offering has least precedence');
                            courseCode = getPrecedenceWrapperOffering.leastCourseOfferingByLeadOrContactId.get(conRecord.Id).Course_Code__c;
                            
                            conRecord.Account_Status__c =  precedenceRecordByPrecedenceNumber.containsKey(minVal) ? precedenceRecordByPrecedenceNumber.get(minVal).Account_Status__c : '';
                            conRecord.Account_Substatus__c = precedenceRecordByPrecedenceNumber.containsKey(minVal) ? precedenceRecordByPrecedenceNumber.get(minVal).Account_Substatus__c : '';
                            conRecord.FutureLearn__c = courseTitleByCourseCode.containsKey(courseCode) ? courseTitleByCourseCode.get(courseCode).FutureLearn__c : false;
                            conRecord.Case_Managed_Course__c = courseTitleByCourseCode.containsKey(courseCode) ? courseTitleByCourseCode.get(courseCode).Case_Managed_Course__c : false;
                            conRecord.Inferred_Course__c = courseTitleByCourseCode.containsKey(courseCode) ? UtilityClass.ToTitleCase(courseTitleByCourseCode.get(courseCode).Name) : '';
                        } 
                        else if(courseApplicationPrecedence == minVal){
                            //System.debug('Course Application has least precedence');
                            courseCode = getPrecedenceWrapperApplication.leastCourseApplicationByLeadOrContactId.get(conRecord.Id).Course_Code__c;
                            
                            conRecord.Account_Status__c =  precedenceRecordByPrecedenceNumber.containsKey(minVal) ? precedenceRecordByPrecedenceNumber.get(minVal).Account_Status__c : '';
                            conRecord.Account_Substatus__c = precedenceRecordByPrecedenceNumber.containsKey(minVal) ? precedenceRecordByPrecedenceNumber.get(minVal).Account_Substatus__c : '';
                            conRecord.FutureLearn__c = courseTitleByCourseCode.containsKey(courseCode) ? courseTitleByCourseCode.get(courseCode).FutureLearn__c : false;
                            conRecord.Case_Managed_Course__c = courseTitleByCourseCode.containsKey(courseCode) ? courseTitleByCourseCode.get(courseCode).Case_Managed_Course__c : false;
                            conRecord.Inferred_Course__c = courseTitleByCourseCode.containsKey(courseCode) ? UtilityClass.ToTitleCase(courseTitleByCourseCode.get(courseCode).Name) : '';
                        }
                        else if(courseEnrolmentPrecedence == minVal){
                            //System.debug('Course Enrolment has least precedence');
                            courseCode = getPrecedenceWrapperEnrolment.leastCourseEnrolmentByLeadOrContactId.get(conRecord.Id).Course_Code__c;
                            
                            conRecord.Account_Status__c =  precedenceRecordByPrecedenceNumber.containsKey(minVal) ? precedenceRecordByPrecedenceNumber.get(minVal).Account_Status__c : '';
                            conRecord.Account_Substatus__c = precedenceRecordByPrecedenceNumber.containsKey(minVal) ? precedenceRecordByPrecedenceNumber.get(minVal).Account_Substatus__c : '';
                            conRecord.FutureLearn__c = courseTitleByCourseCode.containsKey(courseCode) ? courseTitleByCourseCode.get(courseCode).FutureLearn__c : false;
                            conRecord.Case_Managed_Course__c = courseTitleByCourseCode.containsKey(courseCode) ? courseTitleByCourseCode.get(courseCode).Case_Managed_Course__c : false;
                            conRecord.Inferred_Course__c = courseTitleByCourseCode.containsKey(courseCode) ? UtilityClass.ToTitleCase(courseTitleByCourseCode.get(courseCode).Name) : '';
                        }
                    }
                    contactsToBeUpdated.add(conRecord);
                }
                
                
                if(!leadsToBeUpdated.isEmpty()){
                    Set<Id> failedCourseEnrolmentIds = new Set<Id>();
                    List<Database.SaveResult> updateLeadResult = new List<Database.SaveResult>(Database.update(leadsToBeUpdated,false));//INSERT NEW LEADS
                   
                    UtilityClass.ErrorHandlingWrapper errorHandlingValues = new UtilityClass.ErrorHandlingWrapper();
                   
                    errorHandlingValues = UtilityClass.checkErrorsOnDML(updateLeadResult, leadsToBeUpdated, new List<Contact>(), new List<Course_Offering__c>(),
                                                                        new List<Course_Enrolment__c>(), new List<Course_Application__c>(), true);    
                    ErrorList.addAll(errorHandlingValues.errors);
                    failedCourseEnrolmentIds.addAll(errorHandlingValues.failedIds);
                   
                    for(Integer counter = 0 ; counter < leadsToBeUpdated.size(); counter++){
                        if(failedCourseEnrolmentIds.contains(leadsToBeUpdated.get(counter).Id)){//IF THE ID OF THE LEAD IS IN THE SET OF FAILED LEAD IDS
                            lifeCyceIdsReprocess.add(leadsToBeUpdated.get(counter).TEMP_Lifecycle_Id__c);  
                        }
                    }
                    
                    
                    //System.debug('Leads to be updated: ' + leadsToBeUpdated);
                }
                if(!contactsToBeUpdated.isEmpty()){
                    Set<Id> failedCourseEnrolmentIds = new Set<Id>();
                    List<Database.SaveResult> updateContactResult = new List<Database.SaveResult>(Database.update(contactsToBeUpdated,false));//INSERT NEW LEADS
                   
                    UtilityClass.ErrorHandlingWrapper errorHandlingValues = new UtilityClass.ErrorHandlingWrapper();
                   
                    errorHandlingValues = UtilityClass.checkErrorsOnDML(updateContactResult, new List<Lead>(), contactsToBeUpdated, new List<Course_Offering__c>(),
                                                                        new List<Course_Enrolment__c>(), new List<Course_Application__c>(), true);    
                    ErrorList.addAll(errorHandlingValues.errors);
                    failedCourseEnrolmentIds.addAll(errorHandlingValues.failedIds);
                   
                    for(Integer counter = 0 ; counter < contactsToBeUpdated.size(); counter++){
                        if(failedCourseEnrolmentIds.contains(contactsToBeUpdated.get(counter).Id)){//IF THE ID OF THE LEAD IS IN THE SET OF FAILED LEAD IDS
                            lifeCyceIdsReprocess.add(contactsToBeUpdated.get(counter).TEMP_Lifecycle_Id__c);  
                        }
                    }
                    
                   // System.debug('Contacts to be updated: ' + contactsToBeUpdated);
                }
                
                List<Student_Lifecycles__c> lifecyclesToBeProcessed = new List<Student_Lifecycles__c>();
                if(!lifeCyceIdsReprocess.isEmpty()){
                    for(Student_Lifecycles__c lifecycleRec : [SELECT Id, Child_Course_Failed__c FROM Student_Lifecycles__c WHERE Id IN: lifeCyceIdsReprocess]){
                        lifecycleRec.Child_Course_Failed__c = true;
                        lifecyclesToBeProcessed.add(lifecycleRec);
                    }
                }
               
                if(!lifecyclesToBeProcessed.isEmpty()){
                    UPDATE lifecyclesToBeProcessed;
                }
                if(!errorList.isEmpty()){
                    INSERT errorList;
                }
            }
        }
        Catch(Exception e){
            //System.debug('Exception Found on Course Application Enrolment Handler');
            List<Error__c> err=new List<Error__c>();
            err.add(new Error__c(ErrorMessage__c='Exception Found on  Course Application Enrolment Handler'+e.getMessage(), lineNumber__c=e.getLineNumber()));
            insert err;  
        }
    }
}