@istest
private class opportunityProductEntryTests {
	
    @TestSetup
    static void TestData(){
        //test data
        Product2 pr = new Product2(
            Name = 'product');
            insert pr;     
        //Standard PriceBook and PriceBook Entry
		Id standardpbId = Test.getStandardPricebookId();
        PricebookEntry standardpbe = new PricebookEntry(
                                        Pricebook2Id = standardpbId, Product2Id = pr.Id,
                                        UnitPrice = 10000, IsActive = true);
        insert standardpbe;
        Pricebook2 custompb = new Pricebook2(
        Name = 'pricebook',
        IsActive= true);
        insert custompb;
        
        //Custom PriceBook and Entry        
        PricebookEntry pbe = new PricebookEntry(
            Pricebook2Id = custompb.Id,
            Product2Id = pr.Id,
            UnitPrice = 300,
            IsActive = true
        );
        
        insert pbe;
        

        System.Debug(pbe.Id);
        Account ac = new Account(
        Name = 'Test account');
        insert ac;
        
        Opportunity op = new Opportunity(
        Name = 'Test Opportunity',
        AccountId = ac.Id,
        StageName = 'Prospecting',
        closeDate = date.today().addDays(30));
        insert op;
       
        OpportunityLineItem oplitem = new OpportunityLineItem(
        OpportunityId = op.Id,
        Product2Id = pr.ID,
        PricebookEntryId = pbe.Id,
        Quantity = 2 ,
        TotalPrice = 600);
        try {
            insert oplitem;
        }
        catch (DMLException e) {
            System.debug('The following exception has occurred: ' + e.getMessage());
        }
        system.debug('Opportunity Line item id is' +oplitem.Id);
    }
    @isTest
    static  void theTests(){
        
        // You really should create test data, but I'm going to query instead
        // It's my best shot of avoiding a test failure in most orgs
        // Once you've installed this package though, you might want to write your own tests
        // or at least customize these ones to make them more applicable to your org
         
        
        OpportunityLineItem oli = [select Id, PricebookEntryId, PricebookEntry.Pricebook2Id, PricebookEntry.Name, PriceBookEntry.Product2Id, OpportunityId, Opportunity.AccountId from OpportunityLineItem limit 1];
               
                
        ////////////////////////////////////////
        //  test opportunityProductEntry
        ////////////////////////////////////////
        
        // load the page       
        PageReference pageRef = Page.opportunityProductEntry;
        pageRef.getParameters().put('Id',oli.OpportunityId);
        Test.setCurrentPageReference(pageRef);
        
        // load the extension
        opportunityProductEntryExtension oPEE = new opportunityProductEntryExtension(new ApexPages.StandardController(oli.Opportunity));
        
        // test 'getChosenCurrency' method
        if(UserInfo.isMultiCurrencyOrganization())
            System.assert(oPEE.getChosenCurrency()!='');
        else
            System.assertEquals(oPEE.getChosenCurrency(),'');

        // we know that there is at least one line item, so we confirm
        Integer startCount = oPEE.ShoppingCart.size();
        system.assert(startCount>0);

        //test search functionality without finding anything
        oPEE.searchString = 'michaelforce is a hip cat';
        oPEE.updateAvailableList();
        system.assert(oPEE.AvailableProducts.size()==0);
        
        //test remove from shopping cart
        oPEE.toUnselect = oli.PricebookEntryId;
        oPEE.removeFromShoppingCart();
        system.assert(oPEE.shoppingCart.size()==startCount-1);
        
        //test save and reload extension
        oPEE.onSave();
        oPEE = new opportunityProductEntryExtension(new ApexPages.StandardController(oli.Opportunity));
        system.assert(oPEE.shoppingCart.size()==startCount-1);
        
        // test search again, this time we will find something
        oPEE.searchString = oli.PricebookEntry.Name;
        oPEE.updateAvailableList();
        system.assert(oPEE.AvailableProducts.size()>0);       

        // test add to Shopping Cart function
        oPEE.toSelect = oPEE.AvailableProducts[0].Id;
        oPEE.addToShoppingCart();
        system.assert(oPEE.shoppingCart.size()==startCount);
                
        // test save method - WITHOUT quanitities and amounts entered and confirm that error message is displayed
        oPEE.onSave();
//        system.assert(ApexPages.getMessages().size()>0);
        
        // add required info and try save again
        for(OpportunityLineItem o : oPEE.ShoppingCart){
            o.quantity = 5;
            o.unitprice = 300;
        }
        oPEE.onSave();
        
        // query line items to confirm that the save worked
        opportunityLineItem[] oli2 = [select Id from opportunityLineItem where OpportunityId = :oli.OpportunityId];
        system.assert(oli2.size()==startCount);
        
        // test on new Opp (no pricebook selected) to make sure redirect is happening
        Opportunity newOpp = new Opportunity(Name='New Opp',stageName='Pipeline',Amount=10,closeDate=System.Today()+30,AccountId=oli.Opportunity.AccountId);
        insert(newOpp);
        oPEE = new opportunityProductEntryExtension(new ApexPages.StandardController(newOpp));
//        System.assert(oPEE.priceBookCheck()!=null);
        
        // final quick check of cancel button
        System.assert(oPEE.onCancel()!=null);
        
        
        ////////////////////////////////////////
        //  test redirect page
        ////////////////////////////////////////
        
        // load the page
        pageRef = Page.opportunityProductRedirect;
        pageRef.getParameters().put('Id',oli2[0].Id);
        Test.setCurrentPageReference(pageRef);

        // load the extension and confirm that redirect function returns something
        opportunityProductRedirectExtension oPRE = new opportunityProductRedirectExtension(new ApexPages.StandardController(oli2[0]));
        System.assert(oPRE.redirect()!=null);
     
    }
}