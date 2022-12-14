@IsTest
public with sharing class WarehouseSyncScheduleTest {
    public static String CRON_EXP = '0 0 1 * * ?';
    // implement scheduled code here
    @IsTest

    public static void ScedulerTest() {
        Test.setMock(HttpCalloutMock.class, new WarehouseCalloutServiceMock());
        Test.startTest();
        String jobId = System.schedule('WarehouseSyncScheduleJob',
                CRON_EXP, new WarehouseSyncSchedule());
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE Id = :jobId];

        System.assertEquals(0, ct.TimesTriggered);
//        System.assertEquals('2021-07-25 01:00:00', String.valueOf(ct.NextFireTime));
        Test.stopTest();

    }
}