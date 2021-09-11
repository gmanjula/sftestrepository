({
    display: function(component, event, helper) {
        var stname=component.get("v.studentname");
        console.log("student name is--------"+stname);
        component.set("v.studentname","sushmita");
        component.set("v.Age","39");
        component.set("v.course","individual");
        component.set("v.salary","7000");
        component.set("v.Exp","7");
        component.set("v.location","sevenhills");
       
        var stname1=component.get("v.studentname");
        console.log("student name is--------"+stname1);
         var stsalary=component.get("v.salary");
        console.log("salary is--------"+stsalary);
        var stexp=component.get("v.Exp");
		console.log("Experience is--------"+stexp);
        var stbonus=0;
        if(stexp>5){
            stbonus=stsalary*0.30;
        }else{
            stbonus=stsalary*0.20;
        }
        component.set("v.Bonus",stbonus);
        console.log("Bonus is--------"+stbonus);
    },
    showname: function(component, event, helper) {
        var stlname= component.find("lname").get("v.value");
        var stfname= component.find("fname").get("v.value");
        var name1= stfname+'-'+stlname;
        console.log("student lastname is-----",+stlname);
        console.log("student firstname is-----",+stfname);
        component.find("name").set("v.value",name1);
        console.log("student fullname is-----",+name1);
    }
    
    })