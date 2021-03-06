/**
 * @description       : 
 * @author            : Amit Kumar
 * @group             : 
 * @last modified on  : 07-15-2021
 * @last modified by  : Amit Kumar
 * Modifications Log 
 * Ver   Date         Author       Modification
 * 1.0   06-26-2021   Amit Kumar   Initial Version
**/
import { LightningElement, api } from 'lwc';
import MultiLineToast from '@salesforce/resourceUrl/MultiLineToast';
import { loadStyle, loadScript } from 'lightning/platformResourceLoader';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import deleteTheseRecords from '@salesforce/apex/DataFilterCtrl.deleteTheseRecords';
import getValuesFromObjectWhere from '@salesforce/apex/DataFilterCtrl.getValuesFromObjectWhere';
export default class DataFilter extends LightningElement {
    @api createRecordDisabled = false;
    @api editRecordDisabled = false;
    @api deleteRecordDisabled = false;
    @api resetSelectDisabled = false;
    @api fields;
    @api objectName;
    @api selectedId;
    @api selectedIds = [];

    confirmationMessage = "";
    isCreating = false;
    isEditing = false;
    isDeleting = false;

    operatorsOptions = [
        { label: '---Select Operator---', value: '---Select---' },
        { label: '<', value: 'LT' },
        { label: '>', value: 'GT' },
        { label: '<=', value: 'LTE' },
        { label: '>=', value: 'GTE' },
        { label: '=', value: 'EQ' }
    ];
    operatorsValue = '---Select---';
    fieldsOptions = [];
    fieldsValue = '---Select---';
    valueToCompare = undefined;

    connectedCallback() {
        loadStyle(this, MultiLineToast);
        if (this.fields)
        {
            this.loadTheFields();
        }
    }

    @api loadTheFields() {
        const fieldList = this.fields.split(",");
        this.fieldsOptions = [];
        for (const index in fieldList)
        {
            this.fieldsOptions = [...this.fieldsOptions, { label: fieldList[index], value: fieldList[index] }];
        }
        this.fieldsOptions.unshift({ label: '---Select Field---', value: '---Select---' });
        this.fieldsValue = '---Select---';
    }
    
    handleFieldsChange(event) {
        this.fieldsValue = event.target.value;
    }
    
    handleOperatorsChange(event) {
        this.operatorsValue = event.target.value;
    }

    handleValueChange(event){
        this.valueToCompare = event.target.value;
    }
    
    handleShowClick(){
        if(this.fieldsValue === '---Select---' || this.operatorsValue === '---Select---' || this.valueToCompare.length === 0 || this.valueToCompare === undefined){
            this.showError('Please provide field, operator and value to see filtered data !');
        }
        else{
            this.getValuesFromObject();    
        }
    }
    
    async getValuesFromObject(){
        const result = await getValuesFromObjectWhere({objectName: this.objectName, fields: this.fields.split(","), field: this.fieldsValue, value: this.valueToCompare, operation: this.operatorsValue});
        const myEvent = new CustomEvent("filter", {detail: result});
        this.dispatchEvent(myEvent);
    }
    
    handleCreateClick() {
        this.isCreating = true;
    }
        
    handleRecordCreated(event) {
        const recId = event.detail;
        this.showMessage(recId + ' created successfully');
        this.isCreating = false;
        const myevent = new CustomEvent('created');
        this.dispatchEvent(myevent);
    }

    handleCancelClicked() {
        this.isCreating = false;
    }

    handleEditClick() {
        this.isEditing = true;
    }

    handleRecordEdited(event) {
        const recId = event.detail;
        this.isEditing = false;
        this.showMessage(recId + ' updated successfully');
        const myevent = new CustomEvent('edited');
        this.dispatchEvent(myevent);
    }

    handleCloseClicked() {
        this.isEditing = false;
    }

    showMessage(message) {
        const evt = new ShowToastEvent({
            title: 'SUCCESS',
            message: message,
            variant: 'success',
        });
        this.dispatchEvent(evt);
    }

    showError(message) {
        const evt = new ShowToastEvent({
            title: 'ERROR',
            message: message,
            variant: 'error',
        });
        this.dispatchEvent(evt);
    }

    handleDeleteClick() {
        let message = "Are you sure you want to delete following " + this.selectedIds.length + " records - \n";
        // const recIds = this.selectedIds.split(",");
        console.log('MSG === >' + message);
        for (const rids of this.selectedIds)
        {
            message += rids + "\n";
        }
        console.log('MSG === >' + message);
        this.confirmationMessage = message;
        this.isDeleting = true;
    }

    handleYes() {
        this.isDeleting = false;
        deleteTheseRecords({ objectName: this.objectName, objectRecordIds: this.selectedIds })
        .then(result=>{
            let message = "";
            let s = "Following records deleted successfully - \n";
            let e = "Following records can't be deleted - \n";
            for (const rids of this.selectedIds)
            {
                message += rids + "\n";
            }
            if (result === true)
            {
                this.showMessage(s+message);
                const myEvent = new CustomEvent("deleted");
                this.dispatchEvent(myEvent);
            }
            else{
                this.showError(e+message);
            }
        })
        .catch(error=>{
            console.log(error); 
            console.log(JSON.stringify(error)); 
            this.showError('Unable to delete records ['+error+']. Please contact Administrator!');
        });
        
    }

    handleNo() {
        this.isDeleting = false;
    }
    
    
}