@isTest
private class SaveAndOpenPDF_Tests {
  private static testMethod void testSaveAndOpenPDF() {
    Account a = new Account(Name = 'Test');
    insert a;

    ApexPages.currentPage().getParameters().put('Id', a.Id);
    SaveAndOpenPDF con = new SaveAndOpenPDF();
    con.savePDF();
    con.saveAndOpenPDF();
  }
}