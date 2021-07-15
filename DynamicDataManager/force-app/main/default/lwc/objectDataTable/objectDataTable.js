/**
 * @description       : 
 * @author            : Amit Kumar
 * @group             : 
 * @last modified on  : 07-15-2021
 * @last modified by  : Amit Kumar
 * Modifications Log 
 * Ver   Date         Author       Modification
 * 1.0   06-25-2021   Amit Kumar   Initial Version
**/
import { LightningElement, api, wire } from 'lwc';
import getFieldTypeForFields from '@salesforce/apex/ObjectDataTableCtrl.getFieldTypeForFields';
import getValuesFrom from '@salesforce/apex/ObjectDataTableCtrl.getValuesFrom';

export default class ObjectDataTable extends LightningElement {
    @api objectName;
    @api fieldList;
    @api filteredData;
    
    oldData;
    listOfFields = [];
    columnsList = [];
    dataList = [];
    isDataLoading = false;
    dataTableHeight = "height:250px";
    wiredObjectResult;
    
    connectedCallback() {
        if (this.objectName && this.fieldList)
        {
            this.getFieldTypes();
        }
    }

    @api getFieldTypes() {
        this.isDataLoading = true;
        this.listOfFields = this.fieldList.split(",");
        if(!this.listOfFields.includes('Id')){
            this.listOfFields.unshift('Id');
        }
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
                        console.log('DATA ===> ' + JSON.stringify(res));
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
        console.log(rows);
        let rowIds = [];
        for(const index in rows){
            rowIds = [...rowIds, rows[index].Id];
        }
        const eventLoad = {length: rows.length, recordIds: rowIds};
        const myevent = new CustomEvent('selectionchanged', {detail: eventLoad});
        this.dispatchEvent(myevent);
    }
    
    @api filterTheData(){
        this.oldData = this.dataList;
        this.dataList = this.filteredData;
        console.log(JSON.stringify(this.dataList));    
    }
    
}