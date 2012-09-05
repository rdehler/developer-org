trigger AccountValidation on Account (before insert, before update) {
    for (Account acct : Trigger.new ) {
 
        if (acct.billingState == 'KY') {
            acct.addError('Cannot add for KY');
            acct.billingState.addError('No more accts in KY');
        }
        else {
            acct.billingState = 'IN';
        }
    }
}