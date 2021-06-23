System.debug((new DDM_ObjectsController()).getAllObjects());

System.debug('SAMPLE= '+(new DDM_ObjectsController()).getAllFieldsOf('AccOUNT'));

System.debug('SAMPLE= '+(new DDM_ObjectsController()).getRequiredFieldsOf('AccOUNT'));

System.debug('SAMPLE= '+(new DDM_ObjectsController()).getFieldsOf('AccOUNT', new List<String>{'Name', 'BillingCountry'}));