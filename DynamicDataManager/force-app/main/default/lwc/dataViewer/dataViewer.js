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
import { LightningElement, wire, track } from 'lwc';
import { subscribe, unsubscribe, APPLICATION_SCOPE, MessageContext } from 'lightning/messageService';
import objectsAndFieldsChannel from '@salesforce/messageChannel/objectsAndFields__c';

export default class DataViewer extends LightningElement {
    @wire(MessageContext)
    messageContext;
    
    objectName = undefined;
    objectFields = undefined;
    
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
        console.log(this.objectFields);
        this.template.querySelector('c-object-data-table').objectName = this.objectName;
        this.template.querySelector('c-object-data-table').fieldList = this.objectFields;
        this.template.querySelector('c-object-data-table').getFieldTypes();
    }
    
    unsubscribeMC() {
        unsubscribe(this.subscription);
        this.subscription = null;
    }

    disconnectedCallback() {
        this.unsubscribeMC();
    }
}