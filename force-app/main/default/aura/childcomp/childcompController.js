({
	getname : function(component, event, helper) {
		var evnt= component.getEvent("firstevent");
        evnt.setParams({"studentname":"Manjula"});
        evnt.fire();
	}
})