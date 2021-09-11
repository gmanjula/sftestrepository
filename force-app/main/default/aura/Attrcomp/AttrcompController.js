({
	display : function(component, event, helper) {
        
      
        component.set("v.studentname","Seema");
        component.set("v.Age","40");
        component.set("v.course","Childcare");
        component.set("v.salary","6000");
        component.set("v.Exp","6");
        component.set("v.location","Minto");
        var exp1= component.get("v.Exp");
        concole.log("Experience is ----"+exp1);
        var stsalary= component.get("v.salary");
        console.log("salary is-------"+stsalary);
        component.set("v.Bonus","500")
        console.log("Bonus is-----"+v.Bonus);
	}
})