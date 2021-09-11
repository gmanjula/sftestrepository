trigger addusertogroup on User (after insert,after update) {
    
    addtogroup.assignedtogroup(trigger.newmap.keyset());
}