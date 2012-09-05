public class IdeaForward{
    public IdeaForward(ApexPages.StandardController controller) {
        this.controller = controller;
    }
 
    public PageReference redirURL() {
        PageReference newPage;
        newPage = new PageReference('/ideas/viewIdea.apexp');
        List<Idea_shadow__c> i = [select idea__c from idea_shadow__c where id = :controller.getId()];
       	// there was an issue
        if (i.size() == 1) {
        	newPage.getParameters().put('id', i.get(0).idea__c);
       	}
        return newPage.setRedirect(true);
 
    }
 
    private final ApexPages.StandardController controller;
}