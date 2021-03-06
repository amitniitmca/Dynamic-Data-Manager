/**
 * @description       : This class is used to perform CRUD operation on Salesforce Object
 * @author            : Amit Kumar
 * @group             :
 * @last modified on  : 08-02-2021
 * @last modified by  : Amit Kumar
 * Modifications Log
 * Ver   Date         Author       Modification
 * 1.0   06-23-2021   Amit Kumar   Initial Version
 **/
public inherited sharing class DdmObjects{
	public class InvalidQueryTypeException extends Exception{
	}

	private enum QueryType{
		SELECT_QUERY, 
		INSERT_QUERY, 
		UPDATE_QUERY, 
		DELETE_QUERY,
		DELETE_QUERY_ALL
	}
	List<SObject> listOfObjects = null;
	private String objectName = null;
	private SObject standardObject = null;
	private List<SObject> standardObjects = null;
	private List<String> objectFields = null;
	private List<Object> objectValues = null;
	private String getQuery = null;
	private QueryType type = null;
	
	public DdmObjects(String objectName){
		this.objectName = objectName;
	}

	public DdmObjects fields(List<String> fields){
		this.objectFields = fields;
		return this;
	}

	public DdmObjects when(){
		if (this.getQuery == null){
			throw new InvalidQueryTypeException('ERROR: Please call get method before calling when!');
		} else{
			this.getQuery += ' WHERE ';
		}
		return this;
	}

	public DdmObjects field(String field){
		if (this.getQuery == null){
			throw new InvalidQueryTypeException('ERROR: Please call get method before calling when and field!');
		} else if (!this.getQuery.contains('WHERE')){
			throw new InvalidQueryTypeException('ERROR: Please call when method before calling field!');
		} else{
			this.getQuery += field + ' ';
		}
		return this;
	}

	public DdmObjects isGreaterThan(Object val){
		if (this.getQuery == null){
			throw new InvalidQueryTypeException('ERROR: Please call get and when method before calling isGreaterThan!');
		} else {
			this.getQuery += ' > '+val;
		}
		return this;
	}

	public DdmObjects isGreaterThanEqual(Object val){
		if (this.getQuery == null){
			throw new InvalidQueryTypeException('ERROR: Please call get and when method before calling isGreaterThanEqual!');
		} else {
			this.getQuery += ' >= '+val;
		}
		return this;
	}

	public DdmObjects isLessThan(Object val){
		if (this.getQuery == null){
			throw new InvalidQueryTypeException('ERROR: Please call get and when method before calling isLessThan!');
		} else {
			this.getQuery += ' < '+val;
			System.debug('Inside else if');
		}
		System.debug('DDM => '+this.getQuery);
		return this;
	}

	public DdmObjects isLessThanEqual(Object val){
		if (this.getQuery == null){
			throw new InvalidQueryTypeException('ERROR: Please call get and when method before calling isLessThanEqual!');
		} else {
			this.getQuery += ' <= '+val;
		}
		return this;
	}

	public DdmObjects with(){
		if (this.getQuery == null){
			throw new InvalidQueryTypeException('ERROR: Please call get and when method before calling isGreaterThan!');
		} else{
			this.getQuery += 'OR ';
		}
		return this;
	}

	public DdmObjects stictlyWith(){
		if (this.getQuery == null){
			throw new InvalidQueryTypeException('ERROR: Please call get and when method before calling isGreaterThan!');
		} else{
			this.getQuery += 'AND ';
		}
		return this;
	}

	public DdmObjects when(String field, Object value){
		if (this.getQuery == null){
			throw new InvalidQueryTypeException('ERROR: Please call get method before calling when!');
		} else{
			this.getQuery += 'WHERE ' + field + ' =';
			if (value instanceof Id || value instanceof String){
				this.getQuery += ' \'' + value + '\'';
			} else{
				this.getQuery += ' ' + value + ' ';
			}
		}
		return this;
	}

	public DdmObjects whenOR(List<String> fields, List<Object> values){
		if (this.getQuery == null){
			throw new InvalidQueryTypeException('ERROR: Please call get method before calling when!');
		} else if (fields.size() == 0 || values.size() == 0){
			throw new InvalidQueryTypeException('ERROR: Please provide list of fields and values for them!');
		} else if (fields.size() != values.size()){
			throw new InvalidQueryTypeException('ERROR: Please provide all the values for the given fields only!');
		} else{
			this.getQuery += 'WHERE ';
			Integer max = fields.size();
			String whenString = '';
			for (Integer index = 0; index < max; index++){
				whenString += fields.get(index)+' =';
				if (values[index] instanceof Id || values[index] instanceof String){
					whenString += ' \'' + values[index]+'\'';
				} else{
					whenString += ' ' + values[index]+' ';
				}
				if (index < max - 1){
					whenString += 'OR ';
				}
			}
			this.getQuery += whenString;
		}
		return this;
	}

	public DdmObjects whenAND(List<String> fields, List<Object> values){
		if (this.getQuery == null){
			throw new InvalidQueryTypeException('ERROR: Please call get method before calling when!');
		} else if (fields.size() == 0 || values.size() == 0){
			throw new InvalidQueryTypeException('ERROR: Please provide list of fields and values for them!');
		} else if (fields.size() != values.size()){
			throw new InvalidQueryTypeException('ERROR: Please provide all the values for the given fields only!');
		} else{
			this.getQuery += 'WHERE ';
			Integer max = fields.size();
			String whenString = '';
			for (Integer index = 0; index < max; index++){
				whenString += fields.get(index)+' =';
				if (values[index] instanceof Id || values[index] instanceof String){
					whenString += ' \'' + values[index]+'\'';
				} else{
					whenString += ' ' + values[index]+' ';
				}
				if (index < max - 1){
					whenString += ' AND ';
				}
			}
			this.getQuery += whenString;
		}
		return this;
	}

	public DdmObjects get(){
		this.getQuery = 'SELECT ';
		if (this.objectFields == null){
			this.objectFields = new DDM_ObjectsController( ).getAllFieldsOf(this.objectName);
		}
		String strFields = getCSV(this.objectFields);
		this.getQuery += strFields + ' FROM ' + this.objectName + ' ';
		this.type = QueryType.SELECT_QUERY;
		return this;
	}

	public DdmObjects values(List<Object> values){
		if (this.objectFields == null){
			throw new InvalidQueryTypeException('ERROR: Please provide fields first before providing values!');
		} else if (values.size() == 0){
			throw new InvalidQueryTypeException('ERROR: Please provide some values to insert!');
		} else if (values.size() != this.objectFields.size()){
			throw new InvalidQueryTypeException('ERROR: Please provide all the values for the given fields only!');
		} else{
			this.objectValues = values;
		}
		return this;
	}

	public DdmObjects put(){
		if (this.objectFields == null){
			throw new InvalidQueryTypeException('ERROR: Please provide fields to insert value for!');
		} else if(!isRequiredFieldsPresent(this.objectName, this.objectFields)){
            throw new InvalidQueryTypeException('ERROR: Please provide required fields of object "'+this.objectName+'" to insert value for!');
        } else if (this.objectValues == null){
			throw new InvalidQueryTypeException('ERROR: Please provide values for the given fields!');
		} else{
			standardObject = new DDM_ObjectsController( ).getStandardObjectFor(this.objectName);
			for (Integer index = 0; index < this.objectFields.size(); index++){
				standardObject.put(this.objectFields[index], this.objectValues[index]);
			}
			this.type = QueryType.INSERT_QUERY;
		}
		return this;
	}

	public DdmObjects modifyWhen(String field, String value){
		if (this.objectFields == null){
			throw new InvalidQueryTypeException('ERROR: Please provide fields to insert value for!');
		} else if (this.objectValues == null){
			throw new InvalidQueryTypeException('ERROR: Please provide values for the given fields!');
		} else{
			String query = 'SELECT ' + getCSV(this.objectFields)+' FROM ' + this.objectName + ' WHERE ' + field + '= :value';
			this.standardObjects = Database.query(query);
			this.type = QueryType.UPDATE_QUERY;
		}
		return this;
	}

	public DdmObjects deleteWhen(String field, String value){
		String query = 'SELECT Id FROM ' + this.objectName + ' WHERE ' + field + '= :value';
		this.standardObjects = Database.query(query);
		this.type = QueryType.DELETE_QUERY;
		return this;
	}
	
	public DdmObjects deleteAll(List<String> fields, List<Object> values){
		if(fields.size() == 0 || values.size() == 0){
			throw new InvalidQueryTypeException('ERROR: Please provide key fields and values for deletion!');
		}
		else if(fields.size() !=  values.size()){
			throw new InvalidQueryTypeException('ERROR: Please provide values for all the specified fields!');
		}
		else{
			this.listOfObjects = new  List<SObject>();
			for(Integer index = 0; index < fields.size(); index++){
				String fname = fields.get(index);
				Object val = values.get(index);
				List<SObject> objs = new DdmObjects(this.objectName).get().when(fname, val).execute();
				this.listOfObjects.addAll(objs);
			}
			this.type = QueryType.DELETE_QUERY_ALL;
			return this;
		}
	}
	
	public List<SObject> execute(){
		if (this.type == null){
			throw new InvalidQueryTypeException('ERROR: Please choose a query with get, insert, update or delete methods!');
		} else if (this.type == QueryType.SELECT_QUERY){
			try{
				return Database.query(this.getQuery);
			} catch (QueryException qe){
				throw new InvalidQueryTypeException('ERROR: Please take care of "' + qe.getMessage()+'"!');
			}
		} else if (this.type == QueryType.INSERT_QUERY){
			List<SObject> listObject = new List<SObject>();
			listObject.add(this.standardObject);
			INSERT this.standardObject;
			return listObject;
		} else if (this.type == QueryType.UPDATE_QUERY){
			for (SObject stdObject : this.standardObjects){
				for (Integer index = 0; index < this.objectFields.size(); index++){
					stdObject.put(this.objectFields[index], this.objectValues[index]);
				}
			}
			UPSERT this.standardObjects;
			return this.standardObjects;
		} else if(this.type == QueryType.DELETE_QUERY){
			DELETE this.standardObjects;
			return this.standardObjects;
		} 
		else{
			DELETE this.listOfObjects;
			return this.listOfObjects;
		}
	}

	private static String getCSV(List<String> stringList){
		String str = '';
		if (!stringList.contains('Id')){
			str += 'Id, ';
		}
		for (String s : stringList){
			str += s + ', ';
		}
		Integer index = str.lastIndexOf(',');
		str = str.substring(0, index);
		return str;
	}
    
    private static Boolean isRequiredFieldsPresent(String obName, List<String> stringList){
        List<String> requiredFields = new DDM_ObjectsController().getRequiredFieldsOf(obName);
        Integer count = 0;
        for(String reqField : requiredFields){
            if(stringList.contains(reqField)){
                count++;
            }
        }
        return count == requiredFields.size();
    }
}