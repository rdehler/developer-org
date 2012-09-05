@isTest
private class NewTestExamples {
    private static TestMethod void testDisallowAccountsInTX() {
        Account acct = new Account();
        acct.name = 'testDisallowAccountsInTX()';
        acct.billingState = 'TX';
        insert acct;
        System.assert(acct.id != null, 'New accounts must have ids');
    }
}