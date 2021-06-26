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
import { LightningElement, api } from 'lwc';
import getFieldTypeForFields from '@salesforce/apex/ObjectDataTableCtrl.getFieldTypeForFields';
import getValuesFrom from '@salesforce/apex/ObjectDataTableCtrl.getValuesFrom';

export default class ObjectDataTable extends LightningElement {
    @api objectName;
    @api fieldList;
    listOfFields = [];
    columnsList = [];
    dataList = [];
    isDataLoading = false;
    dataTableHeight = "height:250px";
    connectedCallback() {
        if (this.objectName && this.fieldList)
        {
            this.getFieldTypes();
        }
    }

    @api getFieldTypes() {
        this.isDataLoading = true;
        this.listOfFields = this.fieldList.split(",");
        console.log(this.objectName+'::'+this.fieldList);
        getFieldTypeForFields({ objectName: this.objectName, fields: this.listOfFields })
            .then(result => {
                this.columnsList = [];
                for (const index in this.listOfFields)
                {
                    const record = { label: this.listOfFields[index], fieldName: this.listOfFields[index], type: result[index] };
                    this.columnsList = [...this.columnsList, record];
                }
                getValuesFrom({ objectName: this.objectName, fields: this.listOfFields })
                    .then(res => {
                        console.log('DATA ===> ' + res);
                        this.dataList = res;
                        this.isDataLoading = false;
                    })
                    .catch(err => {
                        console.log(JSON.stringify(err));
                    });
            })
            .catch(error => {
                console.log(JSON.stringify(error));
            });
    }
    
    handleRowSelection(event){
        const rows = event.target.getSelectedRows();
        const myevent = new CustomEvent('selectionchanged', {detail: rows.length});
        this.dispatchEvent(myevent);
    }
}