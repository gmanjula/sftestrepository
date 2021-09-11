({
	show : function(component, event, helper) {
        //getting lastname and firstname 
        var stlname= component.find("lname").get("v.value");
        var stfname= component.find("fname").get("v.value");
		var action=component.get("c.getName");
        action.setParams( {"firstname":stfname, "lastname":stlname});
        action.setCallback(this,function(response){
            var state=response.getState();
            if(state=='SUCCESS'){
                var result=response.getReturnValue();
                component.set("v.Name",result);
            }else{
                console.log('Error');
            }
        });
        $A.enqueueAction(action);
  	}
})