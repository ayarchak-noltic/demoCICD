@IsTest
private class WarehouseCalloutServiceTest {

    @IsTest static void mainTest() {
        Test.setMock(HttpCalloutMock.class, new WarehouseCalloutServiceMock());
        Test.startTest();
        Id jobID = System.enqueueJob(new WarehouseCalloutService());
        Test.stopTest();
        AsyncApexJob aaj = [SELECT Id, Status, NumberOfErrors FROM AsyncApexJob WHERE Id = :jobID];
        System.assertEquals('Completed', aaj.Status);
        System.assertEquals(0, aaj.NumberOfErrors);
    }
}