/**
 * @description       : 
 * @author            : Amit Kumar
 * @group             : 
 * @last modified on  : 06-23-2021
 * @last modified by  : Amit Kumar
 * Modifications Log 
 * Ver   Date         Author       Modification
 * 1.0   06-23-2021   Amit Kumar   Initial Version
 **/
public inherited sharing class DdmObjects {
    public class InvalidQueryTypeException extends Exception{}
    private enum QueryType{
        SELECT_QUERY,
        INSERT_QUERY,
        UPDATE_QUERY,
        DELETE_QUERY
    }
    
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
    
    public DdmObjects when(String field){
        if(this.getQuery == null){
            throw new InvalidQueryTypeException('ERROR: Please call get method before calling when!');
        }
        else{
            this.getQuery += ' WHERE '+field+ ' ';
        }
        return this;
    }
    
    public DdmObjects isGreaterThan(Object value){
        if(this.getQuery == null){
            throw new InvalidQueryTypeException('ERROR: Please call get and when method before calling isGreaterThan!');
        }
        else if(value instanceOf Integer || value instanceOf Double || value instanceOf Date || value instanceOf Datetime){
            this.getQuery += ' > '+value;
        }
        return this;
    }
    
    public DdmObjects isGreaterThanEqual(Object value){
        if(this.getQuery == null){
            throw new InvalidQueryTypeException('ERROR: Please call get and when method before calling isGreaterThanEqual!');
        }
        else if(value instanceOf Integer || value instanceOf Double || value instanceOf Date || value instanceOf Datetime){
            this.getQuery += ' >= '+value;
        }
        return this;
    }
    
    public DdmObjects isLessThan(Object value){
        if(this.getQuery == null){
            throw new InvalidQueryTypeException('ERROR: Please call get and when method before calling isLessThan!');
        }
        else if(value instanceOf Integer || value instanceOf Double || value instanceOf Date || value instanceOf Datetime){
            this.getQuery += ' < '+value;
        }
        return this;
    }
    
    public DdmObjects isLessThanEqual(Object value){
        if(this.getQuery == null){
            throw new InvalidQueryTypeException('ERROR: Please call get and when method before calling isLessThanEqual!');
        }
        else if(value instanceOf Integer || value instanceOf Double || value instanceOf Date || value instanceOf Datetime){
            this.getQuery += ' <= '+value;
        }
        return this;
    }
    
    public DdmObjects with(){
        if(this.getQuery == null){
            throw new InvalidQueryTypeException('ERROR: Please call get and when method before calling isGreaterThan!');
        }
        else {
            this.getQuery += 'OR ';
        }
        return this;
    }
    
    public DdmObjects stictlyWith(){
        if(this.getQuery == null){
            throw new InvalidQueryTypeException('ERROR: Please call get and when method before calling isGreaterThan!');
        }
        else {
            this.getQuery += 'AND ';
        }
        return this;
    }
    
    public DdmObjects when(String field, Object value){
        if(this.getQuery == null){
            throw new InvalidQueryTypeException('ERROR: Please call get method before calling when!');
        }
        else{
            this.getQuery += 'WHERE '+field+' =';
            if(value instanceof Id || value instanceof String){
                this.getQuery += ' \''+value+'\'';
            }
            else{
                this.getQuery += ' '+value+' ';
            }
        }
        System.debug('WHEN Q ===> '+this.getQuery);
        return this;
    }
    
    public DdmObjects whenOR(List<String> fields, List<Object> values){
        if(this.getQuery == null){
            throw new InvalidQueryTypeException('ERROR: Please call get method before calling when!');
        }
        else if(fields.size() == 0 || values.size() == 0){
            throw new InvalidQueryTypeException('ERROR: Please provide list of fields and values for them!');
        }
        else if(fields.size() != values.size()){
            throw new InvalidQueryTypeException('ERROR: Please provide all the values for the given fields only!');
        }
        else{
            this.getQuery += 'WHERE ';
            Integer max = fields.size();
            String whenString = '';
            for(Integer index = 0; index < max; index++){
                whenString += fields.get(index)+' =';
                if(values[index] instanceof Id || values[index] instanceof String){
                    whenString += ' \''+values[index]+'\'';
                }
                else{
                    whenString += ' '+values[index]+' ';
                }
                if(index < max-1){
                    whenString += 'OR ';
                }
            }
            this.getQuery += whenString;
        }
        return this;
    }
    
    public DdmObjects whenAND(List<String> fields, List<Object> values){
        if(this.getQuery == null){
            throw new InvalidQueryTypeException('ERROR: Please call get method before calling when!');
        }
        else if(fields.size() == 0 || values.size() == 0){
            throw new InvalidQueryTypeException('ERROR: Please provide list of fields and values for them!');
        }
        else if(fields.size() != values.size()){
            throw new InvalidQueryTypeException('ERROR: Please provide all the values for the given fields only!');
        }
        else{
            this.getQuery += 'WHERE ';
            Integer max = fields.size();
            String whenString = '';
            for(Integer index = 0; index < max; index++){
                whenString += fields.get(index)+' =';
                if(values[index] instanceof Id || values[index] instanceof String){
                    whenString += ' \''+values[index]+'\'';
                }
                else{
                    whenString += ' '+values[index]+' ';
                }
                if(index < max-1){
                    whenString += 'AND ';
                }
            }
            this.getQuery += whenString;
        }
        System.debug('WHEN Q ===> '+this.getQuery);
        return this;
    }
    
    public DdmObjects get(){
        this.getQuery = 'SELECT ';
        if(this.objectFields == null){
            this.objectFields = new DDM_ObjectsController().getAllFieldsOf(this.objectName);
        }
        String strFields = getCSV(this.objectFields); 
        this.getQuery += strFields +' FROM '+this.objectName+' ';
        this.type = QueryType.SELECT_QUERY;
        return this;    
    }
    
    public DdmObjects values(List<Object> values){
        if(this.objectFields == null){
            throw new InvalidQueryTypeException('ERROR: Please provide fields first before providing values!');
        }
        else if(values.size() == 0){
            throw new InvalidQueryTypeException('ERROR: Please provide some values to insert!');
        }
        else if(values.size() != this.objectFields.size()){
            throw new InvalidQueryTypeException('ERROR: Please provide all the values for the given fields only!');
        }
        else{
            this.objectValues = values;
        }
        return this;
    }
    
    public DdmObjects put(){
        if(this.objectFields == null){
            throw new InvalidQueryTypeException('ERROR: Please provide fields to insert value for!');
        }
        else if(this.objectValues == null){
            throw new InvalidQueryTypeException('ERROR: Please provide values for the given fields!');
        }
        else{
            standardObject = new DDM_ObjectsController().getStandardObjectFor(this.objectName);
            for(Integer index =0; index < this.objectFields.size(); index++){
                standardObject.put(this.objectFields[index], this.objectValues[index]);
            }
            this.type = QueryType.INSERT_QUERY;
        }
        return this;
    }
    
    public DdmObjects modifyWhen(String field, String value){
        if(this.objectFields == null){
            throw new InvalidQueryTypeException('ERROR: Please provide fields to insert value for!');
        }
        else if(this.objectValues == null){
            throw new InvalidQueryTypeException('ERROR: Please provide values for the given fields!');
        }
        else{
            this.standardObjects = new DdmObjects(this.objectName).fields(this.objectFields).get().when(field, value).execute();
            System.debug('HAHAHAHAH ===> '+this.standardObjects);
            this.type = QueryType.UPDATE_QUERY;
        }
        return this;
    }
    
    public List<SObject> execute(){
        if(this.type == null){
            throw new InvalidQueryTypeException('ERROR: Please choose a query with get, insert, update or delete methods!');
        }
        else if(this.type == QueryType.SELECT_QUERY){
            try{
                return Database.query(this.getQuery);
            }
            catch(QueryException qe){
                throw new InvalidQueryTypeException('ERROR: Please take care of "'+qe.getMessage()+'"!');
            }
        }
        else if(this.type == QueryType.INSERT_QUERY){
            List<SObject> listObject = new List<SObject>();
            listObject.add(this.standardObject);
            INSERT this.standardObject;
            return listObject;
        }
        else if(this.type == QueryType.UPDATE_QUERY){
            List<SObject> updatedObjects = new List<SObject>();
            for(SObject stdObject : this.standardObjects){
                for(Integer index; index < this.objectFields.size(); index++){
                    stdObject.put(this.objectFields[index], this.objectValues[index]);
                }
                updatedObjects.add(stdObject);
            }
            UPDATE updatedObjects;
            System.debug('HIHIHIHIHIHIIH => '+updatedObjects);
            return updatedObjects;
        }
        else{
            return null;
        }
    }
    
    private static String getCSV(List<String> stringList){
        String str = '';
        if(!stringList.contains('Id')){
            str += 'Id, ';
        }
        for(String s : stringList){
            str += s+', ';
        }
        Integer index = str.lastIndexOf(',');
        str = str.substring(0, index);
        return str;
    }
    
}
