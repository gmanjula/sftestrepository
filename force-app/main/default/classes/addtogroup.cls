public class addtogroup {
    
    @future
    public static void assignedtogroup(set<id> userid){
         list<user> userlist=[select id,Name,Username from user where id IN: userid];
         Group g = [SELECT Id, DeveloperName FROM Group where developername='test_group'];
         list<groupmember> groupmemberlist = new list<groupmember>();
        
  
          for (user u: userlist){
              
              groupmember gm = new groupmember();
             
                  gm.GroupId = g.id;
                  gm.UserOrGroupId=u.id;
              groupmemberlist.add(gm);
              system.debug('.... group memebers....'+groupmemberlist);
           
        }
        insert groupmemberlist;
    }
}