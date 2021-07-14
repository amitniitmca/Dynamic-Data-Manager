/**
 * @description       : 
 * @author            : Amit Kumar
 * @group             : 
 * @last modified on  : 06-27-2021
 * @last modified by  : Amit Kumar
 * Modifications Log 
 * Ver   Date         Author       Modification
 * 1.0   06-27-2021   Amit Kumar   Initial Version
**/
public inherited sharing class DataFilterCtrl {
    @AuraEnabled(cacheable=true)
    public static Boolean deleteTheseRecords(String objectName, List<Id> objectRecordIds){
        try {
            for(Id recId : objectRecordIds){
                List<SObject> accounts = (List<SObject>)new DdmObjects(objectName)
                                                            .deleteWhen('Id', recId)
                                                            .execute();
                
            }
            return true;    
        } catch(Exception e) {
            System.debug(e.getMessage());
            return false;    
        }
        
    }
}
