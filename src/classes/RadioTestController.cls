public class RadioTestController {
    public Radio_Test__c radioTest {get; set;}
    
    public RadioTestController() {
        radioTest = new Radio_Test__c();
    }
    
    public PageReference save() {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Dummy Error'));
        return null;
    }
}