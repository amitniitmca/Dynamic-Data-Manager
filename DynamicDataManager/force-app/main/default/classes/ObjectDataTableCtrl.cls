/**
 * @description       : 
 * @author            : Amit Kumar
 * @group             : 
 * @last modified on  : 06-25-2021
 * @last modified by  : Amit Kumar
 * Modifications Log 
 * Ver   Date         Author       Modification
 * 1.0   06-25-2021   Amit Kumar   Initial Version
**/
public inherited sharing class ObjectDataTableCtrl {
    @AuraEnabled
    public static List<SObject> getValuesFrom(String objectName, List<String> fields){
        try {
            List<SObject> objectsList = new DdmObjects(objectName).fields(fields).get().execute();
            return objectsList;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    @AuraEnabled
    public static List<String> getFieldTypeForFields(String objectName, List<String> fields){
        try {
            List<String> typeList = new List<String>();
            for(String field : fields){
                String typeName = new DDM_ObjectsController().getFieldTypeOf(objectName, field);
                typeList.add(typeName);
            } 
            return typeList;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}
