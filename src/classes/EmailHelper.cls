public class EmailHelper {

  public static void sendEmail(String to, 
                               String subject, 
                               String body) {
    
      Messaging.SingleEmailMessage mail = new
         Messaging.SingleEmailMessage();

      mail.setToAddresses( new String[]{to} );
      mail.setSubject(subject);
      mail.setPlainTextBody(body);

      Messaging.sendEmail( 
          new Messaging.SingleEmailMessage[]{mail} );

  }
}