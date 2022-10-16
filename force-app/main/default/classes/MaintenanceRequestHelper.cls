public with sharing class MaintenanceRequestHelper {
    public static void updateWorkOrders() {
        List<Case> newCaseList = new List<Case>();
        Integer avgAmount=10000;

        List<Equipment_Maintenance_Item__c> newEMI = new List<Equipment_Maintenance_Item__c>();
        List<Case> caseList = [SELECT Id,Vehicle__c,Subject,ProductID,Product__c, (SELECT Id FROM Equipment_Maintenance_Items__r) FROM Case WHERE Status='closed' AND Type IN ('Repair', 'Routine Maintenance') AND Id IN :Trigger.new LIMIT 200];
        Map<Id,Equipment_Maintenance_Item__c> equip = new Map<Id,Equipment_Maintenance_Item__c>([SELECT Id, Equipment__c, Quantity__c,Equipment__r.Id,Equipment__r.Maintenance_Cycle__c FROM Equipment_Maintenance_Item__c ]);
        for(Case c: caseList){
            Case newCase = new Case();
            newCase.Type = 'Routine Maintenance';
            newCase.Status = 'New';
            newCase.Vehicle__c = c.Vehicle__c;
            newCase.Subject =  String.isBlank(c.Subject) ? 'Routine Maintenance Request' : c.Subject;
            newCase.Date_Reported__c = Date.today();
            newCase.ProductId = c.ProductId;
            newCase.Product__c = c.Product__c;
            newCase.ParentId = c.Id;


            for(Equipment_Maintenance_Item__c emi : c.Equipment_Maintenance_Items__r ){
                avgAmount = Math.min(avgAmount,Integer.valueOf(equip.get(emi.Id).Equipment__r.Maintenance_Cycle__c));
                newEMI.add(new Equipment_Maintenance_Item__c(
                        Equipment__c = equip.get(emi.Id).Equipment__c,
                        Maintenance_Request__c = c.Id,
                        Quantity__c = equip.get(emi.Id).Quantity__c));
            }
            Date dueDate = Date.today().addDays(avgAmount);
            newCase.Date_Due__c =dueDate;
            newCaseList.add(newCase);

        }
        if(newCaseList.size()>0){
            Database.insert(newCaseList);
        }

        for(Case c2: newCaseList){
            for(Equipment_Maintenance_Item__c emi2 : newEMI){
                if(c2.ParentId == emi2.Maintenance_Request__c){
                    emi2.Maintenance_Request__c = c2.Id;
                }
            }
        }

        if(newEMI.size()>0){
            Database.insert(newEMI);
        }
    }
}