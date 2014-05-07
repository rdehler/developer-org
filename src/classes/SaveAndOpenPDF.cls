public with sharing class SaveAndOpenPDF {
  public String recordId {
    get {
      return ApexPages.currentPage().getParameters().get('Id');
    }
  }

  // this is to make testing a lot easier -- simply append renderAs=html
  // to the url parameters to test
  public String renderAs {
    get {
      if (String.isBlank(ApexPages.currentPage().getParameters().get('renderAs'))) {
        return 'pdf';
      } else {
        return ApexPages.currentPage().getParameters().get('renderAs');
      }
    }
  }

  public PageReference saveAndOpenPDF() {
    if (String.isBlank(ApexPages.currentPage().getParameters().get('displayOnly'))) {
      Id attachmentId = savePDF();
      return openPDF(attachmentId);
    } else {
      return null;
    }
  }

  public Id savePDF() {
    Attachment attachment = new Attachment();
    attachment.ParentId = recordId;
    attachment.name = 'PDF_'+String.valueof(Datetime.now())+'.pdf';
    PageReference pdf = Page.SaveAndOpenPDF;
    pdf.getParameters().put('Id', recordId);
    pdf.getParameters().put('displayOnly', '1');
    pdf.setRedirect(true);
    try {
      attachment.Body = pdf.getContent();
    }
    catch (VisualForceException e) {
      attachment.Body = Blob.valueof('There was an error.');
    }
    attachment.ContentType = 'application/pdf';
    insert attachment;
    return attachment.Id;
  }

  public PageReference openPDF(Id attachmentId) {
    PageReference ret = new PageReference('/servlet/servlet.FileDownload?file=' + attachmentId);
    ret.setRedirect(true);
    return ret;
  }
}