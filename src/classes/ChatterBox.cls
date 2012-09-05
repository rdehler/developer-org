public  class ChatterBox {
    
    //      If the ParentID is a group, and the CreatedById is not a member of that group, we should auto-add them to that group
    //      before attempting a post
    //
    //      Give this function a list of posts, and it will return a list of CollaborationGroupMembers
    //      that need to be inserted before the posts are inserted.
    
    public static List<CollaborationGroupMember> newMembershipsIfNeeded(List<FeedItem> posts) {
         
        // Store list of newMembership records needed to be inserted
        List<CollaborationGroupMember> newMemberships = new List<CollaborationGroupMember>();
        
        // Build a map of groups to their set of needed members
        
        Map<ID,Set<ID>> mapGroupsToNeededMembers  = new Map<ID,Set<ID>>();
        
        for ( FeedItem post : posts ) {
            String hackString = (String)post.ParentID;
            if ( hackString.startsWith('0F9') ) {
                Set<ID> newMemberIDs;   
                if ( mapGroupsToNeededMembers.containsKey(post.ParentID)) {
                    newMemberIDs = mapGroupsToNeededMembers.get(post.ParentID);
                    
                }
                else {
                    newMemberIDs = new Set<ID>();
                }
                newMemberIDs.add(post.CreatedByID);
                mapGroupsToNeededMembers.put(post.ParentID,newMemberIDs);           
            }
        }
        
        Set<ID> groupIDs = mapGroupsToNeededMembers.keySet();
        
        // Build a map of groups to their existing members
        
        Map<ID,Set<ID>> mapGroupsToExistingMembers = new Map<ID,Set<ID>>();
        
        for ( List<CollaborationGroupMember> memberList : 
              [ Select MemberId, CollaborationGroupId From CollaborationGroupMember Where CollaborationGroupId in :groupIDs ] ) {
        
            for ( CollaborationGroupMember member : memberList ) {
                Set<ID> memberIDs;
                if ( mapGroupsToExistingMembers.containsKey(member.CollaborationGroupId)) {
                    memberIDs = mapGroupsToExistingMembers.get(member.CollaborationGroupId);
                }
                else {
                    memberIDs = new Set<ID>();
                }
                memberIDs.add(member.MemberId);
                mapGroupsToExistingMembers.put(member.CollaborationGroupId,memberIDs);
            }
        }
        
        //  For each group, remove the list of existing members from the list of required members
        
        for ( ID groupID : groupIDs ) {
            mapGroupsToNeededMembers.get(groupID).removeAll(mapGroupsToExistingMembers.get(groupID));
            
            // while we are looping, let's create the CollaborationGroupMember records
            for ( ID memberID : mapGroupsToNeededMembers.get(groupID)) {
                if ( memberID != null ) {
                    newMemberships.add( new CollaborationGroupMember(
                      CollaborationGroupId  = groupID,
                      MemberId              = memberID,
                      NotificationFrequency = 'N'  // spam is bad
                      ));
                }
            }
        }
        
        
        return newMemberships;
    }
    
    // In order to properly test this class, we'd need to create a group, then as a 
    // different user create a FeedItem and assert that the FeedItem creator has been
    // added to the group.  Because there are frequently validation rules and extra 
    // required fields on a user record specific to organizations, we've opted to not
    // include that specific test.  This test method gives you 89% coverage, and gives a 
    // great starting point for testing, but doesn't specifically test functionality.
    private static testMethod void testChatterBox() {
		CollaborationGroup cg = new CollaborationGroup();
		cg.Name = 'CG test';
		cg.CollaborationType = 'Public';
		insert cg;

    	FeedItem fi = new FeedItem();
    	fi.ParentID = cg.Id;
    	fi.Body = 'Test';
    	insert fi;
    	
    	ChatterBox.newMembershipsIfNeeded(new List<FeedItem> { fi });
    }
}