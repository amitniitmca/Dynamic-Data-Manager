/**
 * @description       :
 * @author            : Amit Kumar
 * @group             :
 * @last modified on  : 06-25-2021
 * @last modified by  : Amit Kumar
 * Modifications Log
 * Ver   Date         Author       Modification
 * 1.0   06-23-2021   Amit Kumar   Initial Version
 **/
public inherited sharing class DDM_ObjectsController{
	public class InvalidObjectException extends Exception{
	}

	public List<String> getAllObjects(){
		Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
		Set<String> keys = gd.keySet();
		List<String> listObject = new List<String>();
		for (String key : keys){
			listObject.add(String.valueOf(gd.get(key)));
		}
		return listObject;
	}

	public List<String> getAllFieldsOf(String objectName){
		String[] types = new String[]{objectName};
		Schema.DescribeSobjectResult[] results;
		try{
			results = Schema.describeSObjects(types);
		} catch (System.InvalidParameterValueException e){
			throw new InvalidObjectException('ERROR: "' + objectName + '" is not a valid Object Name. Please consult with Administrator!');
		}
		Map<String, Schema.SObjectField> fsMap = results[0].fields.getMap();
		Set<String> keys = fsMap.keySet();
		List<String> listFields = new List<String>();
		for (String key : keys){
			listFields.add(String.valueOf(fsMap.get(key)));
		}
		return listFields;
	}
	
	public String getFieldTypeOf(String objectName, String fieldName){
		String[] types = new String[]{objectName};
		Schema.DescribeSobjectResult[] results;
		try{
			results = Schema.describeSObjects(types);
		} catch (System.InvalidParameterValueException e){
			throw new InvalidObjectException('ERROR: "' + objectName + '" is not a valid Object Name. Please consult with Administrator!');
		}
		return String.valueOf(results[0].fields.getMap().get(fieldName).getDescribe().getType());
	}

	public List<String> getRequiredFieldsOf(String objectName){
		String[] types = new String[]{objectName};
		Schema.DescribeSobjectResult[] results;
		try{
			results = Schema.describeSObjects(types);
		} catch (System.InvalidParameterValueException e){
			throw new InvalidObjectException('ERROR: "' + objectName + '" is not a valid Object Name. Please consult with Administrator!');
		}
		Map<String, Schema.SObjectField> fsMap = results[0].fields.getMap();
		Set<String> keys = fsMap.keySet();
		List<String> listFields = new List<String>();
		for (String key : keys){
			Schema.DescribeFieldResult desribeResult = fsMap.get(key).getDescribe();
			if (desribeResult.isCreateable() && !desribeResult.isNillable() && !desribeResult.isDefaultedOnCreate()){
				listFields.add(String.valueOf(fsMap.get(key)));
			}
		}
		return listFields;
	}

	public List<String> getFieldsof(String objectName, List<String> fields){
		String[] types = new String[]{objectName};
		Schema.DescribeSobjectResult[] results;
		try{
			results = Schema.describeSObjects(types);
		} catch (System.InvalidParameterValueException e){
			throw new InvalidObjectException('ERROR: "' + objectName + '" is not a valid Object Name. Please consult with Administrator!');
		}
		Map<String, Schema.SObjectField> fsMap = results[0].fields.getMap();
		Set<String> keys = fsMap.keySet();
		List<String> listFields = new List<String>();
		for (String key : keys){
			if (checkForPresenceIgnoringCase(fields, key)){
				listFields.add(String.valueOf(fsMap.get(key)));
			}
		}
		if (listFields.size() == 0)
			return null;
		return listFields;
	}

	public SObject getStandardObjectFor(String objectName){
		try{
			return Schema.getGlobalDescribe().get(objectName).newSObject();
		} catch (NullPointerException npe){
			throw new InvalidObjectException('ERROR: "' + objectName + '" is not a valid Object Name. Please consult with Administrator!');
		}
	}

	private static Boolean checkForPresenceIgnoringCase(List<String> fields, String value){
		Boolean flag = false;
		for (String field : fields){
			if (field.equalsIgnoreCase(value)){
				flag = true;
				break;
			}
		}
		return flag;
	}
	
	
}