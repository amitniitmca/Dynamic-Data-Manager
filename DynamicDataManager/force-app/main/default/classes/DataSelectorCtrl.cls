/**
 * @description       : 
 * @author            : Amit Kumar
 * @group             : 
 * @last modified on  : 06-25-2021
 * @last modified by  : Amit Kumar
 * Modifications Log 
 * Ver   Date         Author       Modification
 * 1.0   06-24-2021   Amit Kumar   Initial Version
**/
public inherited sharing class DataSelectorCtrl {
    @AuraEnabled(cacheable=true)
    public static List<String> getAllStandardObjects(){
        try {
            return new DDM_ObjectsController().getAllObjects();
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    @AuraEnabled(cacheable=true)
    public static List<String> getAllRequiredFieldsOfObject(String objectName){
        try {
            return new DDM_ObjectsController().getRequiredFieldsOf(objectName);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    @AuraEnabled(cacheable=true)
    public static List<String> getAllFieldsOfObject(String objectName){
        try {
            return new DDM_ObjectsController().getAllFieldsOf(objectName);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    
}
