trigger showerrorphone on Account (before insert,before update,after insert,after update) {
   
     accounttriggerhelper.createopportunity(trigger.new , trigger.newmap);
}