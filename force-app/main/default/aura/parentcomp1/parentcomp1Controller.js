({
	show : function(component, event, helper) {
        var name=event.getParam("studentname");
        component.set("v.myname",name);
        console.log("name");
		
	}
})