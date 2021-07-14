import { LightningElement, api} from 'lwc';

export default class DeleteConfirmModal extends LightningElement {
    @api objectName;
    @api isDeleting;
    @api message;
    handleCancelClick(){
        this.dispatchEvent(new CustomEvent('no'));
    }
    handleConfirmClick(){
        this.dispatchEvent(new CustomEvent('yes'));
    }
}