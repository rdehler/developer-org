@isTest
private class testShadowIdeaTrigger {
    static testMethod void testShadowIdea() {
        Idea i = new Idea(Title='Title', Body = 'Body', CommunityId = [select id from community limit 1].get(0).id);
        insert i;
        
        i.Body = 'New Body';
        update i;
    }
}