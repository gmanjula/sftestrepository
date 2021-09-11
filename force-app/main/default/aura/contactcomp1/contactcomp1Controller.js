({
	show1: function(component, event, helper) {
        console.log('contactcomp1 controller');
        var name1=event.getParam("contactname");
        console.log('retriving the name from event is---'+name1);
        var action=component.get("c.getlist");
        console.log('calling to apex');
        action.setParams({"lname":name1});
        console.log('passing parameters  to apex');
        console.log('callback action');
        action.setCallback(this,function(response){
            var state=response.getState();
            var result=response.getReturnValue();
            console.log('assigning the result from apex class to list attribute');
            component.set("v.mylist",result);
          });
        $A.enqueueAction(action);
	}
})