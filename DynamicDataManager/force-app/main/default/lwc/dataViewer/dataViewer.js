/**
 * @description       : 
 * @author            : Amit Kumar
 * @group             : 
 * @last modified on  : 06-26-2021
 * @last modified by  : Amit Kumar
 * Modifications Log 
 * Ver   Date         Author       Modification
 * 1.0   06-25-2021   Amit Kumar   Initial Version
**/
import { LightningElement, wire, track } from 'lwc';
import { subscribe, unsubscribe, APPLICATION_SCOPE, MessageContext } from 'lightning/messageService';
import objectsAndFieldsChannel from '@salesforce/messageChannel/objectsAndFields__c';

export default class DataViewer extends LightningElement {
    @wire(MessageContext)
    messageContext;
    
    objectName = undefined;
    objectFields = undefined;
    
    crdStatus = false;
    erdStatus = true;
    drdStatus = true;
    rsdStatus = true;
    numberOfSelectedRows = 0;
    
    connectedCallback(){
        this.subscribeMC();
    }
    subscribeMC() {
        if (!this.subscription) {
            this.subscription = subscribe(
                this.messageContext,
                objectsAndFieldsChannel,
                (message) => this.handleMessage(message),
                { scope: APPLICATION_SCOPE }
            );
        }
    }

    handleMessage(message) {
        this.objectName = message.objectName;
        this.objectFields = message.listOfFields;
        // console.log(this.objectFields);
        this.template.querySelector('c-object-data-table').objectName = this.objectName;
        this.template.querySelector('c-object-data-table').fieldList = this.objectFields;
        this.template.querySelector('c-object-data-table').getFieldTypes();
        console.log(this.template.querySelector('c-data-filter').fields);
        this.template.querySelector('c-data-filter').fields = this.objectFields;
        console.log(this.template.querySelector('c-data-filter').fields);
        this.template.querySelector('c-data-filter').loadTheFields();
    }
    
    unsubscribeMC() {
        unsubscribe(this.subscription);
        this.subscription = null;
    }

    disconnectedCallback() {
        this.unsubscribeMC();
    }
    
    handleSelectionChanged(event){
        const selectedRows = event.detail;
        if(selectedRows === 0){
            this.crdStatus = false;
            this.erdStatus = true;
            this.drdStatus = true;
            this.rsdStatus = true;
        }
        else if(selectedRows === 1){
            this.crdStatus = true;
            this.erdStatus = false;
            this.drdStatus = false;
            this.rsdStatus = false;
        }
        else{
            this.crdStatus = true;
            this.erdStatus = true;
            this.drdStatus = false;
            this.rsdStatus = false;
        }
    }
}