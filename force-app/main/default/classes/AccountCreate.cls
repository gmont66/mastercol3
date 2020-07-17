/* Create Contact and Name, Email, Address, Phone objects if populate
 *
 * By: Stela Zhang
 * UCInnovation
 */

public with sharing class AccountCreate {
    
    public Account accountNew {get; set;}
    public Address__c addressNew {get; set;}
    public Phone__c phoneNew {get; set;}
    private string returnUrl;
    
    /**
     * Definition of the constructor. 
     * Initial all variables.
     *
     * @param      None
     * @return     None
     * @since      1.0
     */ 
    public AccountCreate(ApexPages.StandardController standardController) {
        accountNew = new Account();
        addressNew = new Address__c();
        phoneNew = new Phone__c();
        addressNew.Country__c = 'United States';
        returnUrl = System.currentPageReference().getParameters().get('retURL');
        // Do we need that?
        addressNew.Preferred__c = true;
        phoneNew.Preferred__c = true;      
        addressNew.Status__c = 'Current';
        phoneNew.Status__c = 'Current';      
        
    }
    
    
    /**
     * Cancel button, return to the home page
     *
     * @param                   None
     * @return        PageReference          
     * @since                   1.0
     */ 
    public PageReference cancelEdit() {
        PageReference page;
        page = new PageReference('/001/o');
        if (returnUrl != null && returnUrl != ''){
             return new PageReference(returnUrl);
        }
        page.setRedirect(true);
        return page;
    }
    
    /**
     * Save button, create contact and related object if any populate
     *
     * @param                   None
     * @return        PageReference          
     * @since                   1.0
     */ 
    public PageReference saveAccount() {
        PageReference page;
        
        insert accountNew;
        
        // Phone number can't be blank
    //  if (phoneNew.Phone_Number__c != null && phoneNew.Phone_Number__c != '') {
    //      phoneNew.Account__c = accountNew.Id;
    //      insert phoneNew;
    //  }
        
        // Street, City, State can't be blank
    /*  if (addressNew.Street__c !='' && addressNew.Street__c != null && addressNew.Type__c == null) {
            Error_Message__c errorMessage = Error_Message__c.getValues('Address Type');
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, errorMessage.Message__c));
            return null;
        }
        
        if (addressNew.Street__c != null && addressNew.Street__c != ''
            && addressNew.City__c != null && addressNew.City__c != ''
            && addressNew.State__c != null && addressNew.Country__c != '') {
            addressNew.Account1__c = accountNew.Id;
            insert addressNew;
        }
        */
        
        
        page = new PageReference('/apex/Account?id=' + accountNew.Id + '&sfdc.override=1');
        page.setRedirect(true);
        return page;
    }
    
}