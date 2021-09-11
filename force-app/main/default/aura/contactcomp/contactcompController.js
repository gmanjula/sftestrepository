({
	submit : function(component, event, helper) {
		var conname= component.find("name").get("v.value");
        console.log('The input name is----'+conname);
        var evnt=component.getEvent("listofcontact");
        evnt.setParams({"contactname":conname});
        evnt.fire();
	}
})