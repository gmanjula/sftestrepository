({
	invoke: function (component, event, helper) {
		component.set('v.columns', [
			{label: 'LastName', fieldName: 'LastName', type: 'text'},
			{label: 'Phone ', fieldName: 'Phone', type: 'text'},
			{label: 'Fax', fieldName: 'fax', type: 'text'}
			]);
	},
	
		searchcontact : function(component) {
		var action = component.get('c.getcontact');
        action.setParams({
           
            amt : component.get("v.con.Name")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if ( state === 'SUCCESS' && component.isValid() ) {
                var pagesize = component.get("v.pagesize");
                component.set('v.contactlist', response.getReturnValue());
                component.set("v.totalRecords", component.get("v.contactlist").length);
                component.set("v.startpage", 0);                
                component.set("v.lastpage", pagesize - 1);
                var PagList = [];
                for ( var i=0; i< pagesize; i++ ) {
                    if ( component.get("v.contactlist").length> i )
                        PagList.push(response.getReturnValue()[i]);    
                }
                component.set('v.PaginationList', PagList);
            } else {
                alert('ERROR');
            }
        });
        $A.enqueueAction(action);
 },
 next: function (component, event, helper) {
  var sObjectList = component.get("v.contactlist");
        var end = component.get("v.lastpage");
        var start = component.get("v.startpage");
        var pagesize1 = component.get("v.pagesize");
        var PagList = [];
        var counter = 0;
        for ( var i = end + 1; i < end + pagesize1 + 1; i++ ) {
            if ( sObjectList.length > i ) {
                PagList.push(sObjectList[i]);
            }
            counter ++ ;
        }
        start = start + counter;
        end = end + counter;
        component.set("v.startpage", start);
        component.set("v.lastpage", end);
        component.set('v.PaginationList', PagList);
 },
 previous: function (component, event, helper) {
  var sObjectList = component.get("v.contactlist");
        var end = component.get("v.lastpage");
        var start = component.get("v.startpage");
        var pagesize2 = component.get("v.pagesize");
        var PagList = [];
        var counter = 0;
        for ( var i= start-pagesize2; i < start ; i++ ) {
            if ( i > -1 ) {
                PagList.push(sObjectList[i]);
                counter ++;
            } else {
                start++;
            }
        }
        start = start - counter;
        end = end - counter;
        component.set("v.startpage", start);
        component.set("v.lastpage", end);
        component.set('v.PaginationList', PagList);
 }

})