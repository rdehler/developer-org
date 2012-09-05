public class VFRefController {
    public A__c account {get; set;}
    public Integer i {get; set;}
    
    public void clear() {
    	account = new A__c();
        account.Name = 'Sample ';    	
    }
    
    public VFRefController() {
    	Site.login('ray.dehler@appirio.com', 'appirio2', null);
    	i = 0;
        System.debug('instantiating');
    }
    
    public PageReference actionFunctionSample() {
        clear();
        account.Name = 'Sample appending '+(i++);
        return null;
    }
    
    public PageReference actionPollerSample() {
        clear();
        i = 9001;
		return null;    	
    }
}