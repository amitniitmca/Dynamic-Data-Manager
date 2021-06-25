// System.debug((new DDM_ObjectsController()).getAllObjects());

// System.debug('SAMPLE= '+(new DDM_ObjectsController()).getAllFieldsOf('AccOUNT'));

// System.debug('SAMPLE= '+(new DDM_ObjectsController()).getRequiredFieldsOf('AccOUNT'));

// System.debug('SAMPLE= '+(new DDM_ObjectsController()).getFieldsOf('AccOUNT', new List<String>{'Name', 'BillingCountry'}));

// System.debug('SAMPLE= '+(new DDM_ObjectsController()).getStandardObjectFor('contract'));

// List<Account> accounts = (List<Account>)new DdmObjects('Account')
//                                             .get()
//                                             .execute();
// System.debug(accounts);

List<Account> accounts = (List<Account>)new DdmObjects('Account')
                                            .fields(new List<String>{'Name', 'IsDeleted' ,'Rating'})
                                            .get()
                                            .execute();
System.debug(accounts);

// List<Account> accounts = (List<Account>)new DdmObjects('Account')
//                                             .get()
//                                             .when('Rating', 'Hot')
//                                             .execute();
// System.debug(accounts);
// System.debug(accounts.size());

// List<Account> accounts = (List<Account>)new DdmObjects('Account')
//                                             .fields(new List<String>{'Name', 'IsDeleted' ,'Rating'})
//                                             .get()
//                                             .when('Id', '0010w00000g8HARAA2')
//                                             .execute();
// System.debug(accounts);
// System.debug(accounts.size());

// List<Account> accounts = (List<Account>)new DdmObjects('Account')
//                                             .fields(new List<String>{'Name', 'IsDeleted' ,'Rating'})
//                                             .get()
//                                             .whenAND(new List<String>{'Rating', 'AccountNumber'}, new List<Object>{'Hot', '123456'})
//                                             .execute();
// System.debug(accounts);
// System.debug(accounts.size());

// List<Account> accounts = (List<Account>)new DdmObjects('Account')
//                                             .fields(new List<String>{'Name', 'Rating'})
//                                             .values(new List<Object>{'Vikas Kumar', 'Hot'})
//                                             .modifyWhen('Id', '0010w00000g8HDLAA2')
//                                             .execute();
// System.debug(accounts);

// List<Account> accounts = (List<Account>)new DdmObjects('Account')
//                                         .fields(new List<String>{'AccountNumber', 'Rating'})
//                                         .values(new List<Object>{'123456', 'Hot'})
//                                         .put()
//                                         .execute();
// System.debug(accounts);

// List<Account> accounts = (List<Account>)new DdmObjects('Account')
//                                             .deleteWhen('Id', '0010w00000g8HDLAA2')
//                                             .execute();
// System.debug('SAMPLE ===> ' + accounts);

System.debug(new DDM_ObjectsController().getFieldTypeOf('Account','BillingAddress'));