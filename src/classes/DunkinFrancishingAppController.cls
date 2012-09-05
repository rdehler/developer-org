/**************************************************************************************
    Name  : DunkinFrancishingAppController
    Author: Appirio Offshore (Yogesh) / Appirio (Tony Ros)
    Date  : March 31, 2010 
    Description : Used as controller class for Home site page to submit information
                  and create new Lead.
    Requester: Tony Ros [PR-04234] 
    Modifications : 
    April 15, 2010 : Modified for PR-04356 
    7/25/2011: Jon Cohen - Change will allow applicants to apply for a county if one or both brands are available
    
**************************************************************************************/
public class DunkinFrancishingAppController extends BaseController {
  public Lead CurrentLead {get;set;}
  public Application_Partner__c CurrentPA {get;set;}
  public County__c county {get; set;}
  public County__c secondaryCounty {get; set;}
  public County__c tertiaryCounty {get; set;}
  public List<ApplicationPartner> listApplicationPartners {get; set;}
  public List<SiteSubInterest> lstWrapperInterests;
  public List<Application_Partner__c> listPartners;
  public List<SelectOption> states {get; set;}
  public List<SelectOption> listBrandInterests {get; set;}
  public List<SelectOption> listSiteTypeInterests {get; set;}
  public List<SelectOption> listHowDidHearAboutus {get; set;}
  public List<SelectOption> listCounties {get; set;}
  public List<SelectOption> listSecondaryCounties {get; set;}
  public List<SelectOption> listTertiaryCounties {get; set;}
  public Integer removeIndex{get; set;}
  public String primaryCountyError {get; set;}
  public String documentId {get; set;}
  public String documentName {get; set;}
  public String confirmEmail {get; set;}
  public String selectedSiteInterests {get; set;}
  public String selectedPrimaryCounty {get; set;}
  public String selectedState {get; set;}
  public String selectedCity {get; set;}
  public String selectedSecondaryState {get; set;}
  public String selectedSecondaryCity {get; set;}
  public String selectedTertiaryState {get; set;}
  public String selectedTertiaryCity {get; set;}
  public String selectedNonPCState{get; set;}
  public String primaryCountyMsg {get; set;}
  public String secCountyMsg {get; set;}
  public String terCountyMsg {get; set;}
  public String errorMessage {get; set;}
  public String closedCountyMsg {get; set;}
  public Boolean showCompleteForm {get; set;}
  public Boolean countyError {get; set;}
  public Boolean isError{get; set;}
  public Boolean isErrorPC{get; set;}
  public Boolean isEmailMatchError {get; set;}
  public Boolean isValidDOB {get; set;}
  public Boolean showPartner {get; set;}
  public Boolean isPartnerFormError {get; set;}
  public Boolean hideSCounty {get; set;}
  public Boolean hideTCounty {get; set;}
  public Boolean errorOnPage2 {get; set;}
  public Boolean isGeneralError{get;set;}
  public Boolean isPrimaryPhoneRequiredError{get;set;}
  public Boolean defaultDisplay {get; set;}
  public Boolean showPartnerInfoSection {get; set;}
  public String[] selectedBrandInterests {get; set;}
  public String[] selectedHowDidHearAboutus {get; set;}
  public String havePCNumber {get; set;}
  private String referalLeadId;
  private String partnerId;
  private Map<String, County__c> mapClosedCounties;
  public String selectedCampaign {get; set;}
  
  /**
   * Default Constructor
   */
  public DunkinFrancishingAppController(){
    referalLeadId = Apexpages.currentPage().getParameters().get('ReferringLeadID');
    partnerId = Apexpages.currentPage().getParameters().get('PA_ID');
    
    if(!IsNullOrEmpty(referalLeadId) && !IsNullOrEmpty(referalLeadId)){
      showPartnerInfoSection = false;
    }else{
      showPartnerInfoSection = true;
    }
    
    CurrentLead = new Lead();
    CurrentPA = new Application_Partner__c();
    county = new County__c();
    secondaryCounty = new County__c();
    tertiaryCounty = new County__c();
    mapClosedCounties = new Map<String, County__c>();
    selectedBrandInterests = new String[]{};
    selectedSiteInterests = '';//new String[]{};
    selectedHowDidHearAboutus = new String[]{};
    listApplicationPartners = new List<ApplicationPartner>();
    listPartners = new List<Application_Partner__c>();
    confirmEmail = null;
    isError = false;
    isEmailMatchError = false;
    isPartnerFormError = false;
    isPrimaryPhoneRequiredError = false;
    countyError = false;
    hideSCounty = true;
    hideTCounty = true;
    defaultDisplay = false;
    listCounties = new List<Selectoption>();
    listCounties.add(new SelectOption('', '--Select One--'));
    listSecondaryCounties = new List<Selectoption>();
    listSecondaryCounties.add(new SelectOption('', '--Select One--'));
    listTertiaryCounties = new List<Selectoption>();
    listTertiaryCounties.add(new SelectOption('', '--Select One--'));
    CurrentLead.Will_you_have_partners__c = 'No';
    CurrentLead.Applying_as_part_of_a_corporation__c = 'No';
    CurrentLead.Are_you_an_existing_franchisee__c = 'No';
    //CurrentLead.Campaign_Code__c = 'N/A';
    describePicklistValues();
    errorOnPage2 = false;
    showCompleteForm = false;
    isValidDOB = true;
    documentName = 'None';
    selectedCampaign = null;
  }
  
  /**
   * Describe picklist values
   */
  private void describePicklistValues(){
    listSiteTypeInterests = new List<SelectOption>();
    listbrandInterests = new List<SelectOption>();
    listHowDidHearAboutus = new List<SelectOption>(); 
    lstWrapperInterests = new List<SiteSubInterest>();
    
    Schema.DescribeFieldResult subSiteTypeInterest = Lead.Sub_Site_Type_Interest__c.getDescribe();
    Schema.DescribeFieldResult brandInterest = Lead.Brand_Interest__c.getDescribe();
    Schema.Describefieldresult howdidhear = Lead.How_did_you_hear_about_us__c.getDescribe();
    
    for(Schema.PicklistEntry val : subSiteTypeInterest.getPicklistValues()){
      lstWrapperInterests.add(new SiteSubInterest(val.getValue()));
      listSiteTypeInterests.add(new SelectOption(val.getValue(), val.getLabel()));
    }
    
    for(Schema.PicklistEntry val2 : brandInterest.getPicklistValues()){
      listbrandInterests.add(new SelectOption(val2.getValue(), val2.getLabel()));
    }
    
    for(Schema.PicklistEntry val3 : howdidhear.getPicklistValues()){
      listHowDidHearAboutus.add(new SelectOption(val3.getValue(), val3.getLabel()));
    }
  }
  
  /**
   * Getter Method
   * @return lstWrapperInterests
   */
  public List<SiteSubInterest> getlstWrapperInterests (){
    return lstWrapperInterests;
  }
  
  /**
   * Method : page2 -- thismethod let the user to go on Application2 page
   * @return PageReference (Application2)
   */
  public PageReference page2(){
    PageReference pr;
    pr=Page.Application2;
    return pr;
  }
  
  /**
   * Method Cancel
   * @return PageReference(Starting Page i.e. Application)
   */
  public PageReference cancel(){
    PageReference pr;
    pr = Page.Application;
    pr.setRedirect(true);
    return pr;
  }
  
  /**
   * Do Validation stuffs and if all is correct redirects to the Application3 page.
   * @return PageReference(Application3)
   */
  public PageReference page3(){
    errorOnPage2 = false;
    isError = false;
    isErrorPC = false;
    isGeneralError = false;
    isEmailMatchError = false;
    isPrimaryPhoneRequiredError = false;
    countyError = false;
    currentLead.Brand_Interest__c = '';
    currentLead.How_did_you_hear_about_us__c = '';
    currentLead.Sub_Site_Type_Interest__c = '';
    currentLead.Campaign_Code__c = '';
    
    List<Restaurant__c> lstRest = [Select Name From Restaurant__c where PC_NUM__c = :CurrentLead.Profit_Center__c];
    
    if((CurrentLead.Build_or_Buy__c == 'Purchasing an existing restaurant') && (lstRest.size() == null || lstRest.size()==0)) {
      isErrorPC = true;
    }
    
    for(String brand : selectedBrandInterests){
      currentLead.Brand_Interest__c = (currentLead.Brand_Interest__c == null? '' : currentLead.Brand_Interest__c) + brand + ';';
      if(CurrentLead.Country_Interest__c == 'Canada' && brand.contains('Dunkin\' Donuts')){
        //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Dunkin Donuts is not available in Canada.'));
        isError = true;
        //break;
      }
    }
    //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'How many units =  ' +currentLead.How_many_units_do_you_plan_to_develop__c));
    
    if(currentLead.Email != null && currentLead.Email != confirmEmail){
      //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Emails do not match.'));
      isEmailMatchError = true;
    }
    
    /*
    for(String siteInterest : selectedSiteInterests){
      currentLead.Sub_Site_Type_Interest__c = (currentLead.Sub_Site_Type_Interest__c == null ? '' : currentLead.Sub_Site_Type_Interest__c) + siteInterest + ';';
    }
    */
    
    currentLead.Sub_Site_Type_Interest__c = selectedSiteInterests;
    
    for(String hearAbout : selectedHowDidHearAboutus){
      currentLead.How_did_you_hear_about_us__c = (currentLead.How_did_you_hear_about_us__c == null ? '' : currentLead.How_did_you_hear_about_us__c) + hearAbout + ';';
    }
    
    if((CurrentLead.Build_or_Buy__c == 'Building a new restaurant' && IsNullOrEmpty(CurrentLead.Country_Interest__c)) 
        || (CurrentLead.Build_or_Buy__c == 'Building a new restaurant' && CurrentLead.Country_Interest__c == 'United States' && IsNullOrEmpty(CurrentLead.Brand_Interest__c))
        || IsNullOrEmpty(CurrentLead.How_many_units_do_you_plan_to_develop__c)
        || IsNullOrEmpty(currentLead.How_did_you_hear_about_us__c) || IsNullOrEmpty(CurrentLead.State_Province__c)
        || (currentLead.How_did_you_hear_about_us__c.contains('Referred by Existing Franchisee') && IsNullOrEmpty(CurrentLead.Who_referred_you__c))){
      
      errorOnPage2 = true;
    }   
    
    if(!IsNULLOrEmpty(currentLead.Sub_Site_Type_Interest__c)){
      if(!(currentLead.Sub_Site_Type_Interest__c.contains('Other - Not listed')) && (IsNullOrEmpty(CurrentLead.How_much_liquid_assets_can_you_invest__c) || IsNullOrEmpty(CurrentLead.What_is_your_total_net_worth__c)) || validateAssests()){
        isGeneralError = true;
      }
    }
    else if(IsNullOrEmpty(CurrentLead.How_much_liquid_assets_can_you_invest__c) || IsNullOrEmpty(CurrentLead.What_is_your_total_net_worth__c) || validateAssests()){
      isGeneralError = true;
    }
    
    if(IsNullOrEmpty(currentLead.Primary_Phone__c)){
      isPrimaryPhoneRequiredError = true;
      errorMessage = 'You must enter a value';
    }else if((currentLead.Primary_Phone__c.equals('Office Phone')  && currentLead.Office_Phone__c == null) || (currentLead.Primary_Phone__c.equals('Cell Phone')  && currentLead.Cell_Phone__c == null) || (currentLead.Primary_Phone__c.equals('Home Phone')  && currentLead.Home_Phone__c == null)){
      isPrimaryPhoneRequiredError = true;
      errorMessage = CurrentLead.Primary_Phone__c + ' is required because it is selected in primary phone';
    }
    
    // First Area of Interest (Primary County) validation
    if(CurrentLead.Build_or_Buy__c != 'Purchasing an existing restaurant'){
      if(CurrentLead.Country_Interest__c == 'United States' && IsNullOrEmpty(CurrentLead.Primary_State_County_Interest__c)){
        countyError = true;
        primaryCountyError = 'Primary Area of Interest : Please select Primary County.';
      }else if(CurrentLead.Country_Interest__c == 'Canada') {
        if(listCounties.size() > 1)
          CurrentLead.Primary_State_County_Interest__c = listCounties[1].getValue();
        else{
          countyError = true;
          primaryCountyError = 'No County found for the selected Primary State/Province. Please choose different Primary State/Province.';
        }
      }
    }
    
    // Valid Date Of Birth Validation
    isValidDOB = validateDateOfBirth();
    
    if(isError || isEmailMatchError || isErrorPC || errorOnPage2 || isPrimaryPhoneRequiredError || isGeneralError || countyError || !isValidDOB){
      return null;
    }
    
    //setLeadCompany();
    if(CurrentLead.Primary_State_County_Interest__c != null){
      selectedPrimaryCounty = [select Name from County__c where id =: CurrentLead.Primary_State_County_Interest__c].Name;
    }
    
    PageReference pr;
    pr = Page.Application3;
    return pr;
  }
  
  /**
   * Validate Net Assets and Liquid Assets
   * @return true if liquid assests > net assets
   */
  private Boolean validateAssests() {
    return CurrentLead.How_much_liquid_assets_can_you_invest__c > CurrentLead.What_is_your_total_net_worth__c;
  }
    
  /**
   * Validate Date Of Birth...
   * @return true if age > 18
   */
  private Boolean validateDateOfBirth(){
    Integer totalDays = CurrentLead.Date_of_Birth__c.daysBetween(System.today());
    Integer leapYearDays = 0;
    Integer birthYear = CurrentLead.Date_of_Birth__c.year();
    Integer tempYear = birthYear;
    Integer birthMonth = CurrentLead.Date_of_Birth__c.month();
    Integer currentMonth = System.today().month();
    Integer currentYear = System.today().year();
    Integer currentDay = System.today().day();
    for(Integer i=0; tempYear <= currentYear; i++){
      if(Date.isLeapYear(tempYear)){
        leapYearDays++;
        if((birthYear == tempYear && birthMonth > 2) || (currentYear == tempYear && currentMonth <= 2 && currentDay > 29)){
          leapYearDays--;
        }
      }
      tempYear = tempYear + 1;
    }
    
    Integer validDays = 365*18 + leapYearDays;
    
    return totalDays >= validDays;
  }
    
  /**
   * Submit Application with all the mention details
   * @return PageReference
   */
  public PageReference DoSubmit(){
    PageReference pr = null;
    
    try{
      // to turn the Assignment Rules on
      Database.DMLOptions dmo = new Database.DMLOptions();
      dmo.assignmentRuleHeader.useDefaultRule = true;
      CurrentLead.setOptions(dmo);
      
      CurrentLead.LeadSource ='Franchising Website';
      
      /** J.Cohen  10/6/2010 Allow Canadian Applications
      */
      //if(CurrentLead.Build_or_Buy__c == 'Purchasing an existing restaurant'){
        //CurrentLead.Country_Interest__c = 'United States';
      //}
      
      // Set City Of Interests
      CurrentLead.First_City_Of_Interest__c = selectedCity;
      CurrentLead.Second_City_Of_Interest__c = selectedSecondaryCity;
      CurrentLead.Third_City_Of_Interest__c = selectedTertiaryCity;
      // 4/14/2011 Jon Cohen Set Campaign Code
      CurrentLead.Campaign_Code__c = selectedCampaign;
      // Set Referal Lead Id
      if(!IsNullOrEmpty(referalLeadId)){
        CurrentLead.Referring_Lead__c = referalLeadId;
      }
      
      // Update Application Partner with Web App Completed = true
      if(!IsNullOrEmpty(partnerId)){
        Application_Partner__c applicationPartner = new Application_Partner__c(Id = partnerId);
        applicationPartner.Web_App_Completed__c = true;
        update applicationPartner;
        
        // set Application Partner Id
        CurrentLead.Application_Partner_Id__c = partnerId;
      }
      
      // Set the staus of lead to interested profile if a closed county is selected
      if(mapClosedCounties != null && mapClosedCounties.containsKey(CurrentLead.Primary_State_County_Interest__c)){
        CurrentLead.Status = 'Interest Profile';
      }
      
      CurrentLead.Do_you_have_a_PC_Number__c = havePCNumber;
      
      // Create new Lead
      insert CurrentLead;
      
      for(ApplicationPartner appPartner : listApplicationPartners){
        appPartner.partner.Lead__c = CurrentLead.Id;
        listPartners.add(appPartner.partner);
      }
      
      if(listPartners.size() > 0){
        insert listPartners;
      }
      
      if(documentId != '' && documentId != null) {
        Document doc = [select Name, Body from Document where Id =: documentId ];
        Attachment attach = new Attachment();
        attach.Body = doc.Body;//ResumeFile;
        attach.Name = doc.Name;//ResumeName;
        attach.ParentId = CurrentLead.Id;
        upsert attach;
        if(attach.Id != null){
          delete doc;
        }
      }
      
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Information has been submitted.'));
      
      // Reset lead object
      //CurrentLead = new Lead();
      pr = Page.Application4;
      //pr.setRedirect(true);
      return pr;
    } 
    catch(Exception ex){
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage())); 
    }
    return pr;
  }
  
  /**
   * Add Partner from the Application Partner List
   * @return PageReference
   */
  public PageReference addPartner() {
    if(IsNullOrEmpty(CurrentPA.Partner_Last_Name__c) || IsNullOrEmpty(CurrentPA.Partner_First_Name__c)
        || IsNullOrEmpty(CurrentPA.Partner_Email__c) || IsNullOrEmpty(CurrentPA.Primary_Phone__c)){
       
       isPartnerFormError = true;
       return null;
    }
    ApplicationPartner appPartner = new ApplicationPartner(CurrentPA);
    appPartner.Index = listApplicationPartners.size();
    listApplicationPartners.add(appPartner);
    CurrentPA = new Application_Partner__c();
    //setLeadCompany();
    showPartner = false;
    isPartnerFormError = false;
    return null;
  }
  
  /**
   * Remove Partner from the Application Partner List
   * @return PageReference
   */
  public PageReference removePartner() {
    listApplicationPartners.remove(removeIndex);
    for(ApplicationPartner appPart : listApplicationPartners){
      if(appPart.Index > removeIndex)
        appPart.Index = appPart.Index - 1;
    }
    //setLeadCompany();
    return null;
  }
  
  /**
   * Util method
   * Check Whether the object(passed as parameter) is null or not
   * @return Boolean(true if null or empty)
   */
  private Boolean IsNullOrEmpty(Object dbValue) {
    if(dbValue == null || String.valueOf(dbValue).trim() == '')
      return true;
    return false;    
  }
   
  /**
   * used to Render the form based on the values passed
   */
  public PageReference doNothing() {
    //setLeadCompany();
    renderForm();
    return null;
  }
  
  /**
   * Are you existing Franchise and Site Type Interest ((Development Type)) change
   * Need to filter counties based on changed values
   */
  public PageReference reQueryCountyInfo() {
    if(CurrentLead.Site_Type_Interest__c == 'Traditional Locations'){
      CurrentLead.Sub_Site_Type_Interest__c = null;
      selectedSiteInterests = '';
      for(SiteSubInterest sub : lstWrapperInterests){
        sub.checked = false;
      }
    }
    defaultDisplay = true;
    searchCounty();
    searchSecondaryCounty();
    searchTertiaryCounty();
    renderForm();
    return null;
  }
  
  /**
   * Country Of Interest Onchange eventhandler
   */
  public PageReference countryChange() {
    queryStates(CurrentLead.Country_Interest__c);
    if(CurrentLead.Country_Interest__c == 'Canada')
      CurrentLead.Brand_Interest__c = null;
    //renderForm();
    reQueryCountyInfo();
    return null;
  }
  
  /**
   * Primary County Onchange eventhandler
   */
  public PageReference primaryCountyChange() {
    String cnty = CurrentLead.Primary_State_County_Interest__c;
    primaryCountyMsg = '';
    
    if(!IsNullOrEmpty(cnty) && mapClosedCounties.containsKey(cnty)){
      primaryCountyMsg = mapClosedCounties.get(cnty).Name + ' -- has not yet been released for development. Want to be one of the first to learn when it is? Please fill out our interest profile.';
    }
    
    return null;
  }
  
  /**
   * Secondary County Onchange eventhandler
   */
  public PageReference secondaryCountyChange() {
    String cnty = CurrentLead.Secondary_State_County_Interest__c;
    secCountyMsg = '';
    
    if(!IsNullOrEmpty(cnty) && mapClosedCounties.containsKey(cnty)){
      secCountyMsg = mapClosedCounties.get(cnty).Name + ' -- has not yet been released for development. Want to be one of the first to learn when it is? Please fill out our interest profile.';
    }
    return null;
  }
  
  /**
   * Tertiary County Onchange eventhandler
   */
  public PageReference tertiaryCountyChange() {
    String cnty = CurrentLead.Tertiary_State_County_Interest__c;
    terCountyMsg = '';
    
    if(!IsNullOrEmpty(cnty) && mapClosedCounties.containsKey(cnty)){
      terCountyMsg = mapClosedCounties.get(cnty).Name + ' -- has not yet been released for development. Want to be one of the first to learn when it is? Please fill out our interest profile.';
    }
    return null;
  }
  
  /**
   * Building Onchange eventhandler
   */
  public PageReference buildOnChange() {
    if(CurrentLead.Build_or_Buy__c == 'Purchasing an existing restaurant'){
      queryStates('United States');
    }else{
      queryStates(CurrentLead.Country_Interest__c);
      havePCNumber = null;
    }
    renderForm();
    return null;
  }
  
  /**
   * Section 1 Onchange
   */
  public PageReference renderForm() {
    showCompleteForm = true;
    
    if(IsNullOrEmpty(CurrentLead.Build_or_Buy__c) || IsNullOrEmpty(CurrentLead.Are_you_an_existing_franchisee__c) 
        || (CurrentLead.Build_or_Buy__c == 'Building a new restaurant' && IsNullOrEmpty(CurrentLead.Country_Interest__c)) 
        || (CurrentLead.Build_or_Buy__c == 'Building a new restaurant' && IsNullOrEmpty(CurrentLead.Brand_Interest__c))
        || (IsNullOrEmpty(CurrentLead.How_many_units_do_you_plan_to_develop__c))
        || (CurrentLead.Build_or_Buy__c == 'Building a new restaurant' && CurrentLead.Country_Interest__c == 'United States' && IsNullOrEmpty(CurrentLead.Site_Type_Interest__c))){
      showCompleteForm = false;
    }
    
    if(CurrentLead.Build_or_Buy__c != 'Building a new restaurant' && havePCNumber != 'Yes') {
      showCompleteForm = false;
    }
    return null;
  }
  
  /* 
  private void setLeadCompany() {
    if(CurrentLead.Applying_as_part_of_a_corporation__c == 'No'){
        if(CurrentLead.Will_you_have_partners__c == 'No'){
            CurrentLead.Company = CurrentLead.FirstName + ' ' + CurrentLead.LastName;
        }else if(CurrentLead.Will_you_have_partners__c == 'Yes') {
            CurrentLead.Company = CurrentLead.LastName;
            for(ApplicationPartner appPartner : listApplicationPartners){
              if(appPartner.partner.Partner_Last_Name__c != null) {
                CurrentLead.Company += ', ' + appPartner.partner.Partner_Last_Name__c;
              }
            }
       }
     }
  }
  */
  
  /**
   * Search for County(Primary)
   */
  public PageReference searchCounty(){
    listCounties = new List<SelectOption>();
    listCounties.add(new SelectOption('', '--Select One--'));
    List<County__c> countyList = new List<County__c>();
    countyList = FilterCounties(selectedState);
    for(County__c county : countyList){
      String cities = county.Concatenated_List_Of_Cities__c;
      if(CurrentLead.Country_Interest__c == 'United States' && !IsNullOrEmpty(cities) && cities.toLowerCase().contains(selectedCity.toLowerCase())){
        listCounties.add(new SelectOption(county.Id, county.Name));
      }
      // In case of Canada
      else if(CurrentLead.Country_Interest__c == 'Canada'){
        listCounties.add(new SelectOption(county.Id, county.Name));
      }
    }
    
    primaryCountyChange();
    // MARKET RESERVED CHECK
    Integer totalCounties = listCounties.size() - 1;
    if(!IsNullOrEmpty(selectedState) && totalCounties == 0){
      primaryCountyMsg = Label.Reserved_County_Message;
    }
    
    return null;
  }
  
  /**
   * Search for County(Secondary)
   */
  public PageReference searchSecondaryCounty(){
    if(!defaultDisplay){
      hideSCounty = false;
      defaultDisplay = true;
    }
    listSecondaryCounties = new List<SelectOption>();
    listSecondaryCounties.add(new SelectOption('', '--Select One---'));
    List<County__c> countyList = new List<County__c>();
    countyList = FilterCounties(selectedSecondaryState);
    for(County__c county : countyList){
      String cities = county.Concatenated_List_Of_Cities__c;
      if(CurrentLead.Country_Interest__c == 'United States' && !IsNullOrEmpty(cities) && cities.toLowerCase().contains(selectedSecondaryCity.toLowerCase())){
        listSecondaryCounties.add(new SelectOption(county.Id, county.Name));
      }
      // In case of Canada
      else if(CurrentLead.Country_Interest__c == 'Canada'){
        listCounties.add(new SelectOption(county.Id, county.Name));
      }
    }
    
    secondaryCountyChange();
    // MARKET RESERVED CHECK
    Integer totalCounties = listSecondaryCounties.size() - 1;
    if(!IsNullOrEmpty(selectedSecondaryState) && totalCounties == 0){
      secCountyMsg = Label.Reserved_County_Message;
    }
    
    return null;
  }
  
  /**
   * Search for County(Tertiary)
   */
  public PageReference searchTertiaryCounty(){
    if(!defaultDisplay){
      hideTCounty = false;
      defaultDisplay = true;
    }
    listTertiaryCounties = new List<SelectOption>();
    listTertiaryCounties.add(new SelectOption('', '--Select One--'));
    List<County__c> countyList = new List<County__c>();
    countyList = FilterCounties(selectedTertiaryState);
    for(County__c county : countyList){
      String cities = county.Concatenated_List_Of_Cities__c;
      if(CurrentLead.Country_Interest__c == 'United States' && !IsNullOrEmpty(cities) && cities.toLowerCase().contains(selectedTertiaryCity.toLowerCase())){
        listTertiaryCounties.add(new SelectOption(county.Id, county.Name));
      }
      // In case of Canada
      else if(CurrentLead.Country_Interest__c == 'Canada'){
        listCounties.add(new SelectOption(county.Id, county.Name));
      }
    }
    
    tertiaryCountyChange();
    // MARKET RESERVED CHECK
    Integer totalCounties = listTertiaryCounties.size() - 1;
    if(!IsNullOrEmpty(selectedTertiaryState) && totalCounties == 0){
      terCountyMsg = Label.Reserved_County_Message;
    }
    
    return null;
  }
 
  /**
   * Query States for the selected country 
   */
  public void queryStates(String country){
    states = new List<SelectOption>();
    states.add(new SelectOption('','--None--'));
    if(!IsNullOrEmpty(country)){
      for(Country_State__c cs : [select State__c from Country_State__c where Country__c = : country order by State__c]){
        states.add(new SelectOption(cs.State__c, cs.State__c));
      }
    }
  }
  
  /**
   * Query Counties based on the conditions 
   * Modified condition For PR-04892
   * Added additional OR clause for each brand case i.e. (DD_Available_for_Application_T__c = "No (Not Available to Anyone)" etc..
   */
  private List<County__c> FilterCounties(String state) {
    List<County__c> lst = new List<County__c>();
    mapClosedCounties = new Map<String, County__c>();
    //mapReservedCounties = new Map<String, County__c>();
    
    String query = 'select id, Name, Concatenated_List_Of_Cities__c, BR_Available_for_Application_T__c, DD_Available_for_Application_T__c, BR_Available_for_Application_NT__c, DD_Available_for_Application_NT__c from County__c where State_Province__c = \'' + state + '\'';
    
    String brand = CurrentLead.Brand_Interest__c;
   
    if(!IsNullOrEmpty(brand)){
      
      if(CurrentLead.Are_you_an_existing_franchisee__c == 'Yes' || CurrentLead.Site_Type_Interest__c == 'Non-Traditional Locations'){
      
        if(brand.contains('Baskin-Robbins') && brand.contains('Dunkin\' Donuts')){
          query += ' AND (BR_Available_for_Application_NT__c != null OR DD_Available_for_Application_NT__c != null OR (BR_Available_for_Application_T__c = \'No (Not Available to Anyone)\' OR DD_Available_for_Application_T__c = \'No (Not Available to Anyone)\'))';
        }
        else if(brand.contains('Baskin-Robbins')){
          query += ' AND (BR_Available_for_Application_NT__c != null OR BR_Available_for_Application_T__c = \'No (Not Available to Anyone)\')';
        }
        else if(brand.contains('Dunkin\' Donuts')){
          query += ' AND (DD_Available_for_Application_NT__c != null OR DD_Available_for_Application_T__c = \'No (Not Available to Anyone)\')';
        }
      
      }else if(CurrentLead.Are_you_an_existing_franchisee__c == 'No'){
        
        if(brand.contains('Baskin-Robbins') && brand.contains('Dunkin\' Donuts')){
          query += ' AND (BR_Available_for_Application_T__c = \'Yes (Available to Anyone)\' OR DD_Available_for_Application_T__c = \'Yes (Available to Anyone)\' OR (BR_Available_for_Application_T__c = \'No (Not Available to Anyone)\' OR DD_Available_for_Application_T__c = \'No (Not Available to Anyone)\'))';
        }
        else if(brand.contains('Baskin-Robbins')){
          query += ' AND (BR_Available_for_Application_T__c = \'Yes (Available to Anyone)\' OR BR_Available_for_Application_T__c = \'No (Not Available to Anyone)\')';
        }
        else if(brand.contains('Dunkin\' Donuts')){
          query += ' AND (DD_Available_for_Application_T__c = \'Yes (Available to Anyone)\' OR DD_Available_for_Application_T__c = \'No (Not Available to Anyone)\')';
        }
     
      }
    }
    query += ' Order by Name';
    // Else If the selected country is canada.... 
    // so just query run simple query... without any conditions..
    lst = Database.Query(query);
    
    // Loop through List of Counties and put values in map in order to check if the user selects closed
    // county before submit
    /*
    Modified 7/25/2011 - Jon Cohen
    If a user selects both brands, both must be unavailable to return a negative. Previously, if one brand was unavailable, the 
    user was blocked from the county.
    
    Modified 11/1/2011 - Jon Cohen
    Corrected issue where user was selecting both brands, one Reserved and the other not available.  The interest profile wasn't getting
    assigned to the FM and the interest profile message wasn't being displayed.
    
    */
    
    for(County__c county : lst){
      Boolean closedCounty = false;
     if(!IsNullOrEmpty(brand)){
      if(CurrentLead.Site_Type_Interest__c == 'Traditional Locations'){
        if(brand.contains('Baskin-Robbins') && brand.contains('Dunkin\' Donuts')){
           if(county.BR_Available_for_Application_T__c == 'No (Not Available to Anyone)' && county.DD_Available_for_Application_T__c == 'No (Not Available to Anyone)'){
            closedCounty = true;
          }
          else if ((county.BR_Available_for_Application_T__c == 'No (Not Available to Anyone)' && county.DD_Available_for_Application_T__c.contains('Reserved')) || (county.DD_Available_for_Application_T__c == 'No (Not Available to Anyone)' && county.BR_Available_for_Application_T__c.contains('Reserved')) )
            closedCounty = true;
        }
        else if(brand.contains('Baskin-Robbins')){
          if(county.BR_Available_for_Application_T__c == 'No (Not Available to Anyone)'){
            closedCounty = true;
          }
        }
        else if(brand.contains('Dunkin\' Donuts')){
          if(county.DD_Available_for_Application_T__c == 'No (Not Available to Anyone)'){
            closedCounty = true;
          }
        }
      }else if(CurrentLead.Site_Type_Interest__c == 'Non-Traditional Locations'){
        if(brand.contains('Baskin-Robbins') && brand.contains('Dunkin\' Donuts')){
          if(county.BR_Available_for_Application_NT__c == 'No (Not Available to Anyone)' && county.DD_Available_for_Application_NT__c == 'No (Not Available to Anyone)'){
            closedCounty = true;
          }
           else if ((county.BR_Available_for_Application_T__c == 'No (Not Available to Anyone)' && county.DD_Available_for_Application_T__c.contains('Reserved')) || (county.DD_Available_for_Application_T__c == 'No (Not Available to Anyone)' && county.BR_Available_for_Application_T__c.contains('Reserved')) )
            closedCounty = true;
        }
        else if(brand.contains('Baskin-Robbins')){
          if(county.BR_Available_for_Application_NT__c == 'No (Not Available to Anyone)'){
            closedCounty = true;
          }
        }
        else if(brand.contains('Dunkin\' Donuts')){
          if(county.DD_Available_for_Application_NT__c == 'No (Not Available to Anyone)'){
            closedCounty = true;
          }
        }
      }
     }
      if(closedCounty){
        mapClosedCounties.put(county.Id, county);
      }
    }
    
    return lst;
  }
  
  /**
   * Show Partner Form
   */
  public PageReference showPartnerForm() {
    showPartner = true;
    return null;
  }
  
  /**
   * Hide partner form
   */
  public PageReference hidePartnerForm() {
    showPartner = false;
    return null;
  }
  
  /**
   * Check Whether Partnes exist or not
   */
  public Boolean getHasPartners(){
    return listApplicationPartners.size() > 0;
  }
  
  /**
   * Class to track partner informations
   */
  public class ApplicationPartner {
    public Integer Index{get; set;}
    public Application_Partner__c partner {get; set;}
    
    public ApplicationPartner(Application_Partner__c currentPartner){
      partner = currentPartner;
    }
  }
  
  /**
   * Wrapper class for customization of Sub Site Type Interest
   */
  public class SiteSubInterest {
    public Boolean checked {get; set;}
    public String interestLabel {get; set;}
    
    public SiteSubInterest(String val){
      interestLabel = val;
      checked = false;
    }
  }
}