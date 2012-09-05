@isTest
private class testIdeaForward {
    static testMethod void testIdeaForward() {
        Idea_Shadow__c shadow = new Idea_Shadow__c(Name = 'Test');
        insert shadow;
        ApexPages.StandardController controller = new ApexPages.StandardController(shadow);
        IdeaForward i = new IdeaForward(controller);
        i.redirURL();
    }
}