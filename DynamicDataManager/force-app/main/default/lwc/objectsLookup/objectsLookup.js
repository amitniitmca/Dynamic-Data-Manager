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
import { LightningElement, wire } from 'lwc';
import getAllStandardObjects from '@salesforce/apex/DataSelectorCtrl.getAllStandardObjects';

export default class ObjectsLookup extends LightningElement {
    objectNameRecords = [];

    blurTimeout;
    searchObject;
    boxClass =
        "slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-has-focus";
    inputClass = "";
    records = [];

    @wire(getAllStandardObjects)
    wiredStandardObjects(data, error) {
        if (data)
        {
            const result = data.data;
            this.objectNameRecords = [];
            for (const i in result)
            {
                const record = { index: i, value: result[i] };
                this.objectNameRecords = [...this.objectNameRecords, record];
            }
        }
        if (error)
        {
            console.log(error.error);
        }
    }

    handlekeyUp(event) {
        const text = event.target.value;
        if(text.length === 1){
            event.target.value = text.toUpperCase();
        }
    }

    handleSelectClick() {
        this.searchObject = "";
        this.inputClass = "slds-has-focus";
        this.boxClass =
            "slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-has-focus slds-is-open";
        this.records = [];
    }

    onSelectBlur() {
        this.blurTimeout = setTimeout(() => {
            this.boxClass =
                "slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-has-focus";
        }, 300);
    }

    onSelectChange(event) {
        this.searchObject = event.target.value;
        console.log(this.searchObject);
        if (this.searchObject != "" && this.searchObject.length > 0)
        {
            this.searchObjectName();
        }
    }

    searchObjectName() {
        this.records =[];
        let index = 1;
        for (const res of this.objectNameRecords)
        {
            if (res.value.includes(this.searchObject))
            {
                this.records = [...this.records, res];
                index++;
                if (index === 5) break;
            }
        }
    }

    onSearchTermSelect(event) {
        let selectedId = event.currentTarget.dataset.id;
        let selectedName = event.currentTarget.dataset.name;
        this.searchObject = selectedName;
        if (this.blurTimeout)
        {
            clearTimeout(this.blurTimeout);
        }
        this.boxClass =
            "slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-has-focus";
        this.records = [];
        
        const myevent = new CustomEvent('selected', {detail: selectedName});
        this.dispatchEvent(myevent);
    }
}