/**
 * @description       : 
 * @author            : Amit Kumar
 * @group             : 
 * @last modified on  : 07-15-2021
 * @last modified by  : Amit Kumar
 * Modifications Log 
 * Ver   Date         Author       Modification
 * 1.0   06-27-2021   Amit Kumar   Initial Version
**/
public inherited sharing class DataFilterCtrl {
    @AuraEnabled
    public static Boolean deleteTheseRecords(String objectName, List<Id> objectRecordIds){
        try {
            List<String> fields = new List<String>();
            for(Id ids : objectRecordIds){
                fields.add('Id');
            }
            System.debug(fields);
            System.debug(objectRecordIds);
            new DdmObjects(objectName).deleteAll(fields, objectRecordIds).execute();    
            return true;    
        } catch(Exception e) {
            System.debug(e.getMessage());
            return false;    
        }    
    }
    
    @AuraEnabled
    public static List<SObject> getValuesFromObjectWhere(String objectName, List<String> fields, String field, String value, String operation){
        DdmObjects ddm = new DdmObjects(objectName).fields(fields).get();
        if(operation == 'EQ'){
            ddm = ddm.when(field, value);
        }
        else if(operation == 'LT'){
            ddm = ddm.when().field(field).isLessThan(value);
        }
        else if(operation == 'GT'){
            ddm = ddm.when().field(field).isGreaterThan(value);
        }
        else if(operation == 'LTE'){
            ddm = ddm.when().field(field).isLessThanEqual(value);
        }
        else{
            ddm = ddm.when().field(field).isGreaterThanEqual(value);
        }
        System.debug('DDM ===>'+ddm);
        return ddm.execute();
    }
}
