/**
 * @description       : 
 * @author            : Amit Kumar
 * @group             : 
 * @last modified on  : 06-27-2021
 * @last modified by  : Amit Kumar
 * Modifications Log 
 * Ver   Date         Author       Modification
 * 1.0   06-24-2021   Amit Kumar   Initial Version
**/
import { LightningElement, wire } from 'lwc';
import NoHeader from '@salesforce/resourceUrl/NoHeader';
import MultiLineToast from '@salesforce/resourceUrl/MultiLineToast';
import { loadStyle, loadScript } from 'lightning/platformResourceLoader';
import getAllRequiredFieldsOfObject from '@salesforce/apex/DataSelectorCtrl.getAllRequiredFieldsOfObject';
import getAllFieldsOfObject from '@salesforce/apex/DataSelectorCtrl.getAllFieldsOfObject';
import { publish, MessageContext } from 'lightning/messageService';
import objectsAndFieldsChannel from '@salesforce/messageChannel/objectsAndFields__c';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class DataSelector extends LightningElement {

    allFields = [];
    requiredFields = [];
    selectedObjectValue = undefined;

    selectedFields = [];

    @wire(MessageContext)
    messageContext;

    connectedCallback() {
        loadStyle(this, NoHeader);
        loadStyle(this, MultiLineToast);
    }

    handleObjectSelected(event) {
        this.selectedObjectValue = event.detail;
        this.selectedFields = [];
        this.requiredFields = [];
        this.allFields = [];
        this.getAllFieldsOfObject();
    }

    getAllFieldsOfObject() {
        getAllRequiredFieldsOfObject({ objectName: this.selectedObjectValue })
        .then(result => {
                for (const r in result)
                {
                    this.requiredFields = [...this.requiredFields, result[r]];
                }
                getAllFieldsOfObject({ objectName: this.selectedObjectValue })
                    .then(res => {
                        for (const r in res)
                        {
                            this.allFields = [...this.allFields, { label: res[r], value: res[r] }];
                        }
                    })
                    .catch(err => {
                        console.log(err);
                    });
            })
            .catch(error => {
                console.log(error);
            });
    }

    handleFieldsChange(event) {
        this.selectedFields = event.detail.value;
        console.log(this.selectedFields);
    }

    handleShowRecordsClick(event) {
        if (this.selectedFields.length > 0)
        {
            const objectLoad = { objectName: this.selectedObjectValue, listOfFields: this.selectedFields.join() };
            publish(this.messageContext, objectsAndFieldsChannel, objectLoad);
        }
        else
        {
            this.showError('Please choose fields before showing record!');
        }
    }

    handleResetRecordsClick(event) {
        
    }

    handleResetFiltersClick(event) {

    }
    
    showMessage(message){
        const evt = new ShowToastEvent({
            title: 'SUCCESS',
            message: message,
            variant: 'success',
        });
        this.dispatchEvent(evt);
    }
    
    showError(message){
        const evt = new ShowToastEvent({
            title: 'ERROR',
            message: message,
            variant: 'error',
        });
        this.dispatchEvent(evt);
    }
}