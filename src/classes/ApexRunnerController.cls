public class ApexRunnerController {
    
  public Apex_Example__c example = null;
  private String example_name = null;
    
  public ApexRunnerController() {
  }
    
  public PageReference init() {
    String requested_name = ApexPages.currentPage().getParameters().get('name');
    String example_name = (requested_name == null || requested_name == '') ? 'HelloWorld' : requested_name;
    List<Apex_Example__c> loex = [select name, objective__c, code__c from Apex_Example__c where name = :example_name limit 1];
    if (loex.size() != 1) {
      example = new Apex_Example__c( name = 'NewExample_' + Datetime.now(), objective__c = 'Copy goes here...', code__c = 'SHOW( 2 + 2 );');    
    } else {
      example = loex[0];    
    }
    return null;
  }  
    
  public String getName() {
    return example.name;
  }  
    
  public String getCode() {
    return example.code__c;
  }
  
  public void setCode(String newCode) {
    example.code__c = newCode;
  }
  
  public String getObjective() {
    return example.objective__c;
  } 
  
  public String getUrl() {
    return example_name;
  }
  
  public PageReference save() {
    Apex_Example__c target = null;
    if (example.id != null) {
     target = new Apex_Example__c( name = 'NewExample_' + Datetime.now(), objective__c = example.objective__C, code__c = example.code__c);
    } else {
     target = example;
    }
    insert target;
    return null;
  }
  
  public static TestMethod void TestController() {
  
    ApexRunnerController cntlr = new ApexRunnerController();
    cntlr.init();
    System.assert(cntlr.getName() != null);
    System.assert(cntlr.getUrl() == null);
    System.assert(cntlr.getObjective() != null);
    cntlr.setCode('// Test');
    System.assert(cntlr.getCode() == '// Test');
    
    PageReference ref = cntlr.save();
    System.assertEquals(ref,null); 
  }
  
  public static TestMethod void TestControllerWithName() {  
    // With a parameter...
    
    String testName = 'AutomatedTest_Example_123';
    Apex_Example__c example = new Apex_Example__c( name =  testName, objective__c = 'Copy goes here...', code__c = 'SHOW( 2 + 2 );');
    insert example;
    
    ApexPages.currentPage().getParameters().put('name', testName);
    ApexRunnerController cntlr = new ApexRunnerController();
    cntlr.init();
    System.assert(cntlr.getName() == testName);
  }
  
 
}