/**
 * @description       : 
 * @author            : Amit Kumar
 * @group             : 
 * @last modified on  : 06-25-2021
 * @last modified by  : Amit Kumar
 * Modifications Log 
 * Ver   Date         Author       Modification
 * 1.0   06-24-2021   Amit Kumar   Initial Version
**/
import { LightningElement, wire, track } from 'lwc';
import NoHeader from '@salesforce/resourceUrl/NoHeader';
import { loadStyle, loadScript } from 'lightning/platformResourceLoader';
import getAllRequiredFieldsOfObject from '@salesforce/apex/DataManagerCtrl.getAllRequiredFieldsOfObject';
import getAllFieldsOfObject from '@salesforce/apex/DataManagerCtrl.getAllFieldsOfObject';

export default class DataManager extends LightningElement {

    allFields = [];
    requiredFields = [];
    selectedObjectValue = undefined;

    selectedFields = [];

    connectedCallback() {
        loadStyle(this, NoHeader);
    }

    handleObjectSelected(event) {
        this.selectedObjectValue = event.detail;
        this.getAllFieldsOfObject();
    }

    getAllFieldsOfObject() {
        getAllRequiredFieldsOfObject({ objectName: this.selectedObjectValue })
            .then(result => {
                this.requiredFields = [];
                for (const r in result)
                {
                    this.requiredFields = [...this.requiredFields, result[r] ];
                }
                getAllFieldsOfObject({ objectName: this.selectedObjectValue })
                    .then(res => {
                        this.allFields = [];
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
    
    handleFieldsChange(event){
        this.selectedFields = event.detail.value;    
        console.log(this.selectedFields);
    }
}