//  chatterMessage xml looks like this:
   //      <chatterMessage CreatedById="..." ParentId="...">Message Body</chatterMessage>
   //  or 
   //      <chatterMessage CreatedById="..." ParentId="..." LinkURL="..." Title="...">Message Body</chatterMessage>
   //  or 
   //      <chatterMessage CreatedById="..." ParentId="..." LinkURL="..." Title="..."><![CDATA[Message Body]]></chatterMessage>


global class chatbotEmail2Chatter implements Messaging.InboundEmailHandler {
    global Messaging.InboundEmailResult handleInboundEmail( 
        Messaging.inboundEmail email, 
        Messaging.InboundEnvelope env){

        Messaging.InboundEmailResult res = new Messaging.InboundEmailResult();

        List<FeedItem> posts = new List<FeedItem>();
        List<CollaborationGroupMember> newMemberships = new List<CollaborationGroupMember>();

                
        try { 
            //  Debug message added to the DebugLog chatter group
            posts.add( new FeedItem(
                ParentID     = [ Select ID From CollaborationGroup Where Name = 'Chatbot DebugLog' Limit 1 ].id,  // The group 
                Body         = 'Received inbound email2chatter from ' + env.FromAddress 
            ));
        }
        catch ( Exception ex ) { } 
        
        try {

            //  parse the email and create feedItem records
            posts.addAll(parseMessages(email.plainTextBody));

            //  If the parentId is a collaborationGroup, make sure the CreatedbyId is a member
            //  If not, add them
            newMemberships.addAll(ChatterBox.newMembershipsIfNeeded(posts));
            
            //  Insert memberships
            system.debug('DEBUG--->Inserting memberships. Memberships:');
            system.debug(newMemberships);
            insert newMemberships;
            
            //  Insert the feedItem records            
            system.debug('DEBUG--->Inserting posts.  Posts:');
            system.debug(posts);
            insert posts;
        }
        catch ( Exception ex ) {
            res.success = false;
            res.message = ex.getMessage();
            return res;
        }
        
        res.success = true;
        return res;
    }  

   
   //  chatterMessage xml looks like this:
   //      <chatterMessage CreatedById="..." ParentId="...">Message Body</chatterMessage>
   //  or 
   //      <chatterMessage CreatedById="..." ParentId="..." LinkURL="..." Title="...">Message Body</chatterMessage>
   
    List<FeedItem> parseMessages(String body) {
        
        List<FeedItem> posts = new List<FeedItem>();
        
        // Support for more than one chatterMessage
        // skip until first <chatterMessage tag ... this helps strip out the Force.com Sandbox message
        // that SF attaches to the beginning of emails that originate from a Sandbox
        
        String chatterMessage = body.substring(body.indexOf('<chatterMessage'));
         
            XmlStreamReader reader = new XmlStreamReader(chatterMessage);
            
            while ( reader.hasNext() ) {
                if ( reader.getEventType() == XmlTag.START_ELEMENT) { 
                    if ( 'chatterMessage' == reader.getLocalName() ) {
                        FeedItem post = parseMessage(reader);
                        posts.add(post);
                    }               
                }
                reader.next();
            }
        //}
        return posts;
    }
    
    FeedItem parseMessage(XmlStreamReader reader) {
        FeedItem post = new FeedItem();
        
        post.CreatedById = reader.getAttributeValue(null,'CreatedById');
        post.ParentId    = reader.getAttributeValue(null,'ParentId');
        post.LinkURL     = reader.getAttributeValue(null,'LinkURL');
        post.Title       = reader.getAttributeValue(null,'Title');
        post.body        = '';
        
        //post.CreatedDate = DateTime.newInstanceOf(reader.getAttributeValue(null,'CreatedDate'));
        
        // Optional parameters
        if ( post.LinkURL == '' ) { post.LinkURL = null; } 
        if ( post.Title   == '' ) { post.Title   = null; }

        while ( reader.hasNext()  ) {
            if ( reader.getEventType() == XmlTag.END_ELEMENT ) {
                break;
            }
            else if ( reader.getEventType() == XmlTag.CDATA ) {
                post.body += reader.getText();
            }
            else if ( reader.getEventType() == XmlTag.CHARACTERS ) {
                post.body += reader.getText();
            }
            reader.next();
        }
        return post;
    }
    
    // strategy: create an inbound email and assert that the feeditem was created
    private static testMethod void testChatbotEmail2Chatter() {
		CollaborationGroup cg = new CollaborationGroup();
		cg.Name = 'CG test';
		cg.CollaborationType = 'Public';
		insert cg;

		// create a new email and envelope object
		Messaging.InboundEmail email = new Messaging.InboundEmail() ;
		Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
		
		// setup the data for the email
		email.subject = 'Irrelevant Subject';
		email.fromname = 'Irrelevant FromName';
		email.plainTextBody =  '<chatterMessage ';
		email.plainTextBody += 'CreatedById="'+UserInfo.getUserId()+'" ParentId="'+cg.Id+'" LinkURL="http://notrelevant.com" ';
		email.plainTextBody += 'Title="test">test</chatterMessage>';
		env.fromAddress = 'someaddress@salesforce.com';
		
		// call the email service class and test it with the data in the testMethod
		chatbotEmail2Chatter emailProcess = new chatbotEmail2Chatter();

		Test.startTest();
		emailProcess.handleInboundEmail(email, env);
		Test.stopTest();
		
		// Ensure that a chatter post was created
		System.assertEquals(1, [select count() from feeditem where parentId = :cg.Id]);
    }

}