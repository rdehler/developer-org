trigger ShadowIdea on Idea (after insert, after update) {
    if (Trigger.isInsert) {
        List<Idea_Shadow__c> shadows = new List<Idea_Shadow__c>();
        Map<Idea, Idea_Shadow__c> ideaMap = new Map<Idea, Idea_Shadow__c>();
        for (Idea i : Trigger.new) {
            Idea_Shadow__c shadow = new Idea_Shadow__c(Idea__c = i.Id, Name=i.Title, Body__c = i.Body, Status__c = i.Status, Categories__c = i.Categories);
            ideaMap.put(i, shadow);
            shadows.add(shadow);
        }
        insert shadows;
        
        List<Idea> ideas = new List<Idea>();
        for (Idea i : ideaMap.keySet()) {
            Idea idea = new Idea(Id = i.Id, Idea_Shadow__c = ideaMap.get(i).Id);
            ideas.add(idea);
        }
        if (ideas.size() > 0) {
            update ideas;
        }
    }
    else if (Trigger.isUpdate) {
        List<Idea_Shadow__c> shadows = new List<Idea_Shadow__c>();
        List<Id> commentIds = new List<Id>();
        for (Idea i : Trigger.newMap.values()) {
            commentIds.add(i.LastCommentId);
        }
        
        Map<Id, IdeaComment> ideaCommentMap = new Map<Id, IdeaComment>();
        for (IdeaComment i : [select id, commentbody from ideacomment where id in :commentIds]) {
            ideaCommentMap.put(i.id, i);
        }
        
        for (Idea i : Trigger.newMap.values()) {
            if (i.Body != Trigger.oldMap.get(i.Id).Body || 
                    i.Status != Trigger.oldMap.get(i.Id).Status || 
                    i.Title != Trigger.oldMap.get(i.Id).Title || 
                    i.Categories != Trigger.oldMap.get(i.Id).Categories || 
                    i.LastCommentId != Trigger.oldMap.get(i.Id).LastCommentId) {
                Idea_Shadow__c shadow = new Idea_Shadow__c(Id = i.Idea_Shadow__c, Name = i.Title, Body__c = i.Body, Status__c = i.Status, Categories__c = i.Categories, Last_Comment__c = ideaCommentMap.get(i.LastCommentId) == null ? '' : ideaCommentMap.get(i.LastCommentId).CommentBody);
                shadows.add(shadow);
            }
        }
        
        if (shadows.size() > 0) {
            update shadows;
        }
    }

}