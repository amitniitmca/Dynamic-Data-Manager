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

export default class CreateNewRecordModal extends LightningElement {
    @api objectApiName;
    @api isVisible;
    @api objectFields;
    fieldList = [];
    
    connectedCallback(){
        if(this.objectFields){
            this.fieldList = this.objectFields.split(",");
        }
    }
    
    handleCancel(){
        const myevent = new CustomEvent("close");
        this.dispatchEvent(myevent);
    }
    
    handleSuccess(event){
        const source = event.target;
        const myevent = new CustomEvent('create', {detail: source.recordId});
        this.dispatchEvent(myevent);
    }
}