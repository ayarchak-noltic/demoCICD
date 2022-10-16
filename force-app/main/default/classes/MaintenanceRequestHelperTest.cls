@IsTest
public with sharing class MaintenanceRequestHelperTest {
    @IsTest
    public static void BulkTesting() {
        Product2 pt2 = new Product2(Name = 'tester', Maintenance_Cycle__c = 10, Replacement_Part__c = true);

        Database.insert(pt2);


        List<Case> caseList = new List<Case>();
        for (Integer i = 0; i < 300; i++) {
            caseList.add(new Case(
                    Type = 'Routine Maintenance',
                    Status = 'Closed',
                    Subject = 'testing',
                    Date_Reported__c = Date.today(),
                    ProductId = pt2.Id
            ));
        }
        if (caseList.size() > 0) {
            Database.insert(caseList);
            System.debug(pt2.Id);
            System.debug(caseList.size());
        }


        List<Equipment_Maintenance_Item__c> newEMI = new List<Equipment_Maintenance_Item__c>();
        for (Integer i = 0; i < 5; i++) {
            newEMI.add(new Equipment_Maintenance_Item__c(
                    Equipment__c = pt2.id,
                    Maintenance_Request__c = caseList[1].id,
                    Quantity__c = 10));
        }
        if (newEMI.size() > 0) {
            Database.insert(newEMI);
        }

        for (Case c : caseList) {
            c.Subject = 'For Testing';
        }
        Database.update(caseList);
        Integer newcase = [SELECT COUNT() FROM Case WHERE ParentId = :caseList[0].Id];
        System.assertEquals(1, newcase);

    }

    @istest
    public static void positive() {
        Product2 pt2 = new Product2(Name = 'tester', Maintenance_Cycle__c = 10);
        insert pt2;

        Case cParent = new Case(Type = 'Repair', Status = 'Closed', Date_Reported__c = Date.today(),
                ProductId = pt2.Id);
        insert cParent;
        Case cChild = new Case(Type = 'Repair', Status = 'Closed', Date_Reported__c = Date.today(),
                ProductId = pt2.Id, ParentId = cParent.ParentId);
        insert cChild;

        cParent.Subject = 'child refrecer record';
        update cParent;

        Integer newcase = [SELECT COUNT() FROM Case WHERE ParentId = :cParent.Id];
        System.assertEquals(1, newcase);

    }
    @IsTest public static void negetive() {
        Product2 pt2 = new Product2(Name = 'tester', Maintenance_Cycle__c = 10);
        insert pt2;

        Case c = new Case(Type = 'Repair', Status = 'New', Date_Reported__c = Date.today(),
                ProductId = pt2.Id);
        insert c;

        c.Status = 'Working';
        update c;


        Integer newcase = [SELECT COUNT() FROM Case WHERE ParentId = :c.Id];
        System.assertEquals(0, newcase);
    }


}