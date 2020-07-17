/**
*  Name : Test_InterimHandler
*  Author : Ephraim Lintag
*  Created Date : 03/21/2016 - updated staging 03/09
 */
@isTest(SeeAllData=true)

private class Test_InterimHandler{
    
    static testMethod void test_Interim() {
    
        Contact oneContact = new Contact();
        
        oneContact.firstName = 'John';
        oneContact.lastName = 'Smith';
        oneContact.CRS_ID__c = '99978998';
        
        insert oneContact;
        Id rtID= [Select Id From RecordType Where Name = 'SIS Interface Record Type' AND SobjectType = 'Interim__c'].get(0).Id; 
        Interim__c oneInterim = new Interim__c();
        
        oneInterim.External_System_ID__c = 'STRC-01012016-997';
        oneInterim.firstName__c = 'John';
        oneInterim.lastName__c = 'Smith';
        oneInterim.RecordTypeId = rtID;
        insert oneInterim;
        
        oneInterim.Contact__c = oneContact.Id;
        
        update oneInterim;
        
        delete oneInterim;

        /* case 00001202: check fields for unknown values
        *  G.Montero: 07/06/20
        */

        // positive - must insert, status = New

        Interim__c oneInterim1 = new Interim__c();
        
        oneInterim1.firstName__c = 'Joe';
        oneInterim1.lastName__c = 'Smith';
        oneInterim1.External_System_ID__c = 'STRC-case1202-001';
        oneInterim1.Address_1_Line_1__c = 'address';

        insert oneInterim1;

        String stsPositive = [SELECT Id, Status__c FROM Interim__c WHERE External_System_ID__c = 'STRC-case1202-001' LIMIT 1].Status__c; 

        system.assertNotEquals('Manual Review', stsPositive, ' Status cannot be Manual Review');

        // positive 2: middle name and phone, status = New, Reason = blank

        Interim__c oneInterim2 = new Interim__c();

        oneInterim2.firstName__c = 'Joe';
        oneInterim2.lastName__c = 'Smith3';
        oneInterim2.External_System_ID__c = 'STRC-case1202-003';
        oneInterim2.middleName__c = 'None';
        oneInterim2.Phone_1__c = 'Not Applicable';
        oneInterim2.Phone_2__c = 'None';
        oneInterim2.Phone_3__c = 'Unknown';
        oneInterim2.Phone_4__c = 'Not Applicable';
        oneInterim2.Phone_5__c = 'None';

        insert oneInterim2;
        String stsPos2 = [SELECT Id, Status__c FROM Interim__c 
                        WHERE External_System_ID__c = 'STRC-case1202-003' LIMIT 1].Status__c; 

        system.assertNotEquals('Manual Review', stsPos2, ' Status cannot be Manual Review');

        // negative - must set Status to Manual Review and Reason to 'Information Unknown' 

        Interim__c oneInterim3 = new Interim__c();

        oneInterim3.firstName__c = 'Joe';
        oneInterim3.lastName__c = 'Smith2';
        oneInterim3.External_System_ID__c = 'STRC-case1202-002';
        oneInterim3.Address_1_Line_1__c = 'Unknown';

        insert oneInterim3;
        String stsNeg = [SELECT Id, Status__c FROM Interim__c 
                        WHERE External_System_ID__c = 'STRC-case1202-002' LIMIT 1].Status__c; 
        String reasonNeg = [SELECT Id, Manual_Review_Reason__c FROM Interim__c WHERE External_System_ID__c = 'STRC-case1202-002' LIMIT 1].Manual_Review_Reason__c; 

        system.assertEquals('Manual Review', stsNeg, ' Status must be Manual Review: ' + stsNeg);
        system.assertEquals('Information Unknown', reasonNeg, ' Reason must be Information Unknown: ' + reasonNeg);

        // negative for update

        Interim__c interimToUpdate;

        interimToUpdate = [SELECT Id FROM Interim__c WHERE External_System_ID__c = 'STRC-case1202-001' LIMIT 1]; 

        interimToUpdate.firstName__c = 'Unknown';
        interimToUpdate.Status__c = 'New';

        update interimToUpdate;

        String stsNegUpd = [SELECT Id, Status__c FROM Interim__c 
                        WHERE External_System_ID__c = 'STRC-case1202-001' LIMIT 1].Status__c; 
        String reasonNegUpd = [SELECT Id, Manual_Review_Reason__c FROM Interim__c 
                        WHERE External_System_ID__c = 'STRC-case1202-001' LIMIT 1].Manual_Review_Reason__c; 

        system.assertEquals('Manual Review', stsNegUpd, ' Status must be Manual Review: ' + stsNeg);
        system.assertEquals('Information Unknown', reasonNegUpd, ' Reason must be Information Unknown: ' + reasonNeg);
                
    }
    /*
    //Test Controller - VF Page
    static testMethod void myUnitTest() {
        PageReference bioPage = Page.bioChanges;   
        Test.setCurrentPage(bioPage);
        CaseMgmtController cmc = new CaseMgmtController();
        cmc.submitCase(); 
    }*/
}