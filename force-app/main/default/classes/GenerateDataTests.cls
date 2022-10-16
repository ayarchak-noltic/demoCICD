@IsTest
public class GenerateDataTests {

    @IsTest
    static void test_initialization_works() {
        Test.startTest();
            GenerateData.init();
        Test.stopTest();

        // The following simple counts are fine
        System.assert([SELECT COUNT() FROM Boat__c] > 0, 'No Boat__c were found');
        System.assert([SELECT COUNT() FROM BoatType__c] > 0, 'No BoatType__c were found');
        System.assert([SELECT COUNT() FROM Account] == 1, 'No Account was found');
        System.assert([SELECT COUNT() FROM Contact] > 0, 'No Contacts found');
    }
    
    @IsTest
    static void test_getLengthForBoatType_NoType(){
        Integer boatLength = GenerateData.getLengthForBoatType('');
        System.assertEquals(20, boatLength, 'The boat length was calculated wrongly.');
    }
    @IsTest
    static void test_getPriceForBoatType_NoType(){
        Integer boatPrice = GenerateData.getPriceForBoatType('');
        System.assertEquals(15000, boatPrice, 'The boat price was calculated wrongly.');
    }


}