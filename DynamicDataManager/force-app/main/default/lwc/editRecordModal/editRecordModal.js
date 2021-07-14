/**
 * @description       : 
 * @author            : Amit Kumar
 * @group             : 
 * @last modified on  : 06-27-2021
 * @last modified by  : Amit Kumar
 * Modifications Log 
 * Ver   Date         Author       Modification
 * 1.0   06-26-2021   Amit Kumar   Initial Version
**/
import { LightningElement, api } from 'lwc';

export default class EditRecordModal extends LightningElement {
    @api isVisible;
    @api objectRecordId;
    @api objectApiName;
    @api objectFields;
    fieldList=[];
    
    connectedCallback(){
        if(this.objectFields){
            this.fieldList = this.objectFields.split(",");
        }
    }
    
    handleSubmit(event){
        event.preventDefault();
        this.template.querySelector('lightning-record-form').submit();
        this.resetTheForm();
        const source = event.target;
        const myevent = new CustomEvent('edited', {detail: source.recordId});
        this.dispatchEvent(myevent);
    }
    
    handleReset(){
        this.resetTheForm();
        const myevent = new CustomEvent('closed');
        this.dispatchEvent(myevent);
    }
    
    resetTheForm(){
        const inputFields = this.template.querySelectorAll('lightning-input-field');
        if (inputFields) {
            inputFields.forEach(field => {
                field.reset();
            });
        }
    }
}