/**
 * @description       : 
 * @author            : Amit Kumar
 * @group             : 
 * @last modified on  : 06-26-2021
 * @last modified by  : Amit Kumar
 * Modifications Log 
 * Ver   Date         Author       Modification
 * 1.0   06-26-2021   Amit Kumar   Initial Version
**/
import { LightningElement, api } from 'lwc';

export default class DataFilter extends LightningElement {
    @api createRecordDisabled=false;
    @api editRecordDisabled=false;
    @api deleteRecordDisabled=false;
    @api resetSelectDisabled=false;
    @api fields;
    
    operatorsOptions = [
        {label: '---Select Operator---', value: '---Select---'},
        {label: '<', value: 'LT'},
        {label: '>', value: 'GT'},
        {label: '<=', value: 'LTE'},
        {label: '>=', value: 'GTE'},
        {label: '=', value: 'EQ'}
    ];
    operatorsValue = '---Select---';
    fieldsOptions = [];
    fieldsValue = '---Select---';
    
    connectedCallback(){
        if(this.fields){
            this.loadTheFields();
        }
    }
    
    @api loadTheFields(){
        const fieldList = this.fields.split(",");
        this.fieldsOptions = [];
        for(const index in fieldList){
            this.fieldsOptions = [...this.fieldsOptions, {label: fieldList[index], value: fieldList[index]}];
        }
        this.fieldsOptions.unshift({label:'---Select Field---', value: '---Select---'});
        this.fieldsValue = '---Select---';
    }
    
    handleFieldsChange(event){
        
    }
    
    handleOperatorsChange(event){
        
    }
}