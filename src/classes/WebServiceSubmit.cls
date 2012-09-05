/*
 * Class to generate and submit XML for the OMS Web Service
 *
 * @author Ray Dehler 2011-02-11
 */
global class WebServiceSubmit {
    private XmlStreamWriter w;
    private Map<String, String> values;

    webservice static void WebServiceSubmit(Id opportunityId) {
        System.debug('XXX opp id: '+opportunityId);
        // TODO tie in values from Opportunity
        new WebServiceSubmit();
    }

    /* Default constructor, only for POC purposes */
    public WebServiceSubmit() {
        Map<String, String> values = new Map<String, String>();
        
        values.put('PRESENTTOCOMPANY-1', 'David Thein, DDS');
        values.put('COMPANYNAME', 'David Thein, DDS');
        values.put('DEALER_NUM', '57');
        values.put('CONTACTTYPE', 'presenting');
        values.put('FIRSTNAME', 'Timothy');
        values.put('MIDDLENAME', 'S');
        values.put('LASTNAME', 'Carlin');
        values.put('FULLNAME', 'Timothy S Carlin');
        values.put('CONTACT-COMPANYNAME', 'Edward Jones');
        values.put('CONTACT-ID-TYPE', 'AESEQNUM');
        values.put('ID', 'S');
        values.put('ADDRLINE-1', '7500 College Blvd Ste 710');
        values.put('CITY', 'Overland Park');
        values.put('STATEPROVN', 'KS');
        values.put('POSTALCODE', '66210-4035');
        values.put('COUNTRY', 'USA');
        values.put('PHONE', '913/469-0290');
        values.put('TPA-INDEX', '1');
        values.put('TPA-LOCKTPAFEESFLAG', 'Y');
        values.put('TPA-PPTPAFLAG', 'Y');
        values.put('TPA-PUBLISHATTRIBUTESFLAG', 'Y');
        values.put('TPA-TPAADDRESS1', '7300 W 110th St Ste 450');
        values.put('TPA-TPACITY', 'Overland Park');
        values.put('TPA-TPACOUNTRY', 'USA');
        values.put('TPA-TPAHOMEPAGE', 'www.eipcorp.com');
        values.put('TPA-TPAMAINPHONE', '913/385-2565');
        values.put('TPA-TPASTATE', 'KS');
        values.put('TPA-TPAZIP', '66210');
        values.put('TPA', 'EIP Corp');
        values.put('QUOTE-INCLUDE_TPA_FEESFLAG', 'N');
        values.put('QUOTE-INIT_STAT', 'TAKEOVER');
        values.put('QUOTE-NUM_ELIG_EMPL', '4');
        values.put('QUOTE-NUM_PARTIC', '4');
        values.put('QUOTE-PLAN_TYPE', '401-PROFIT-SHR');
        values.put('QUOTE-PRICING_TYPE', 'STD');
        values.put('QUOTE-RK_SOLUTION', 'DIRECT');
        values.put('QUOTE-SHARE_CLASS', 'R3');
        values.put('SELFDIRECTBROK-INDICATOR', 'false');
        values.put('ASSETS', '0');
        values.put('COMPANYSTOCK-INDICATOR', 'false');
        values.put('PLANASSETS', '450000');
        values.put('AVGACCTBAL', '112500');
        values.put('ONETIME', '0');
        values.put('STDONGOING', '0');
        values.put('ADDONGOING', '0');
        values.put('TOTALONGOING', '0');
        values.put('CREDIT', '0');
        values.put('ESTIMATEDNET', '0');
        values.put('SDBFEE', '0');
        values.put('ERSTOCKFEE', '0');
        values.put('CREATEDDATE', '2010-12-15');
        
        createOrder(values);
    }
    
    public String generateProposalXML() {
        String result = '';
        
        start('PROPOSAL');
        // XXX confirm value
        att('createdby', 'RIR');
        // XXX confirm value
        att('mergerOrSpinOff', '');
        
        simpleList('PROPOSALDATE');

        for (Integer i = 1; i <= 2; i++) {
            if (values.get('PRESENTTOCOMPANY-'+i) != null) {
                start('PRESENTTOCOMPANY');
                att('index', ''+i);
                chars(values.get('PRESENTTOCOMPANY-'+i));
                end();
            }
        }
        
        simpleList('COMPANYNAME');
        
        start('DEALERINFO');
        att('dealer_num', values.get('DEALER_NUM'));
        
        start('CONTACT');
        // XXX confirm value
        att('type', values.get('CONTACTTYPE'));
        
        simpleList(new List<String> { 
                'FIRSTNAME', 
                'MIDDLENAME', 
                'LASTNAME', 
                'FULLNAME', 
                'CONTACT-COMPANYNAME' });

        start('ID');
        // XXX confirm value
        att('type', values.get('CONTACT-ID-TYPE'));
        chars(values.get('ID'));
        end();
        
        start('ADDRESS');
        
        for (Integer i = 1; i <= 3; i++) {
            if (values.get('ADDRLINE-'+i) != null) {
                start('ADDRLINE');
                att('index', ''+i);
                chars(values.get('ADDRLINE-'+i));
                end();
            }
        }
        
        simpleList(new List<String> {
                'CITY',
                'STATEPROVN',
                'POSTALCODE',
                'COUNTRY' });

        end(); // end ADDRESS
        
        simpleList('PHONE');
        
        end(); // end CONTACT

        end(); // end DEALERINFO

        start('TPA');
        // XXX confirm values
        atts(new Map<String, String> {
                'code' => values.get('TPA-CODE'),
                'index' => values.get('TPA-INDEX'),
                'lockTPAFeesFlag' => values.get('TPA-LOCKTPAFEESFLAG'),
                'pptpaFlag' => values.get('TPA-PPTPAFLAG'),
                'publishAttributesFlag' => values.get('TPA-PUBLISHATTRIBUTESFLAG'),
                'tpaAddress1' => values.get('TPA-TPAADDRESS1'), 
                'tpaAddress2' => values.get('TPA-TPAADDRESS2'),
                'tpaCity' => values.get('TPA-TPACITY'),
                'tpaCountry' => values.get('TPA-TPACOUNTRY'), 
                'tpaHomePage' => values.get('TPA-TPAHOMEPAGE'),
                'tpaMainPhone' => values.get('TPA-TPAMAINPHONE'),
                'tpaState' => values.get('TPA-TPASTATE'),
                'tpaZip' => values.get('TPA-TPAZIP')});
        chars(values.get('TPA'));
        end();
        
        start('QUOTE');
        // XXX confirm values
        atts(new Map<String, String> {
                'include_TPA_FeesFlag' => values.get('QUOTE-INCLUDE_TPA_FEESFLAG'),
                'init_stat' => values.get('QUOTE-INIT_STAT'),
                'num_elig_empl' => values.get('QUOTE-NUM_ELIG_EMPL'),
                'num_partic' => values.get('QUOTE-NUM_PARTIC'),
                'plan_doc_type' => values.get('QUOTE-PLAN_DOC_TYPE'),
                'plan_type' => values.get('QUOTE-PLAN_TYPE'),
                'pricing_type' => values.get('QUOTE-PRICING_TYPE'),
                'quote_TPA_Name' => values.get('QUOTE-QUOTE_TPA_NAME'),
                'rk_solution' => values.get('QUOTE-RK_SOLUTION'),
                'share_class' => values.get('QUOTE-SHARE_CLASS')});
                
        start('SELFDIRECTBROK');
        // XXX confirm value
        att('indicator', values.get('SELFDIRECTBROK-INDICATOR'));
        
        simpleList('ASSETS');
        
        end(); // end SELFDIRECTBROK
        
        start('COMPANYSTOCK');
        // XXX confirm value
        att('indicator', values.get('COMPANYSTOCK-INDICATOR'));
        
        simpleList('ASSETS');
        
        end(); // end COMPANYSTOCK
                
        start('TAKEOVER');
        
        simpleList(new List<String> {
                'PLANASSETS', 
                'AVGACCTBAL'});
        
        end(); // end TAKEOVER
        
        start('FEES');
        
        start('FEETOTALS');
        
        simpleList(new List<String> {
                'ONETIME',
                'STDONGOING',
                'ADDONGOING',
                'TOTALONGOING',
                'CREDIT',
                'ESTIMATEDNET',
                'SDBFEE',
                'ERSTOCKFEE'});
        
        end(); // end FEETOTALS
        
        end(); // end FEES  
        
        simpleList('CREATEDDATE');  
                
        end(); // end QUOTE

        end(); // end PROPOSAL
        
        result = w.getXmlString();
        w.close();
        return result;      
    }
    
    public WebServiceSubmit(Map<String, String> values) {
        createOrder(values);
    }
    
    public List<Map<String, String>> findOrders(Map<String, String> criteria) {
        wwwCapgroupComOmsWebserviceOrder1.OrderServiceSoapPort o = new wwwCapgroupComOmsWebserviceOrder1.OrderServiceSoapPort();
        o.endpoint_x = 'http://raydehler.com/xml/xml.php?type=findOrders';
        wwwCapgroupComOmsWebserviceOrder1.OMSOrderSearchCriteriaType searchCriteria = new wwwCapgroupComOmsWebserviceOrder1.OMSOrderSearchCriteriaType();
        List<wwwCapgroupComOmsWebserviceOrder1.OMSOrderType> orders = o.FindOrders(searchCriteria);
        return new List<Map<String, String>>();
    }
    
    public Map<String, String> getOrder (Long param) {
        wwwCapgroupComOmsWebserviceOrder1.OrderServiceSoapPort o = new wwwCapgroupComOmsWebserviceOrder1.OrderServiceSoapPort();
        o.endpoint_x = 'http://raydehler.com/xml/xml.php?type=getOrder';
        wwwCapgroupComOmsWebserviceOrder1.GetOrderResponseType_element response = o.GetOrder(param);
        System.debug(response);
        return new Map<String, String>();
    }
    
    public void createOrder(Map<String, String> values) {
        this.values = values;
        this.w = new XmlStreamWriter();
        
        wwwCapgroupComOmsWebserviceOrder1.OrderServiceSoapPort o = new wwwCapgroupComOmsWebserviceOrder1.OrderServiceSoapPort();

        o.endpoint_x = 'http://raydehler.com/xml/xml.php?type=createOrder';

        wwwCapgroupComOmsWebserviceOrder1.OMSOrderType order = new wwwCapgroupComOmsWebserviceOrder1.OMSOrderType();
        // XXX filling in values
        order.createdBy = 'TestPage';
        order.mailDelivery = new wwwCapgroupComOmsWebserviceOrder1.OMSMailDeliveryType();
        order.mailDelivery.attentionTo = '';
        order.mailDelivery.deliveryStatus = 'S';
        order.mailDelivery.mailCode = '';
        order.mailDelivery.address1 = 'Morgan Stanley Smith Barney LLC';
        order.mailDelivery.address2 = '101 Park Ave Fl 24';
        order.mailDelivery.address3 = '';
        order.mailDelivery.address4 = '';
        order.mailDelivery.city = 'New York';
        order.mailDelivery.fullName = 'John J Finn';
        order.mailDelivery.phoneNumber = '5555031813';
        order.mailDelivery.postalCode = '10178';
        order.mailDelivery.state = 'NY';
        order.mailDelivery.firstName = 'John';
        order.mailDelivery.middleName = 'J';
        order.mailDelivery.lastName = 'Finn';
        order.mailDelivery.salutation = 'Mr.';
        order.mailDelivery.companyName = 'Morgan Stanley Smith Barney LLC';
        order.mailDelivery.country = 'USA';
        
        
        order.OrderItems = new List<wwwCapgroupComOmsWebserviceOrder1.OMSOrderItemType>();

        wwwCapgroupComOmsWebserviceOrder1.OMSOrderItemType orderItem = new wwwCapgroupComOmsWebserviceOrder1.OMSOrderItemType();
        orderItem.quantity = '1';
        orderItem.dataContent = getProposalData(generateProposalXML());
        orderItem.dataMimeType = 'text/plain';
        orderItem.itemType = 'PROPOSAL';
        orderItem.dataName = 'ProposalItem1.xml';
        order.OrderItems.add(orderItem);
        
        wwwCapgroupComOmsWebserviceOrder1.OMSOrderItemType orderItem2 = new wwwCapgroupComOmsWebserviceOrder1.OMSOrderItemType();
        orderItem2.quantity = '1';
        orderItem2.itemType = 'LIT_ORDER_ITEM';
        orderItem2.itemName = 'MFGEBR02010';
        orderItem2.itemDescription = 'WHAT MAKES AMER FUNDS DIFF2010';
        order.OrderItems.add(orderItem2);

        
        order.orderSource = 'Tester';
        order.orderType = 'PROPOSAL';
        order.recipientPersonId = '456';
        order.requiresReview = false;
        order.sourceOrderId = '1-7GZBQA';
        order.recipientPersonType = 'null';
        
        
        wwwCapgroupComOmsWebserviceOrder1.CreateOrderResponse_element response = o.CreateOrder(order);
        System.debug('XXX response: '+response);
    }

    public String getProposalData(String proposalXML) {
        return EncodingUtil.convertToHex(Blob.valueOf(proposalXML)).toUpperCase();
    }

    /* 
     * Sometimes null is not an acceptable String.  In this case, return '' instead
     */
    private String s(String key) {
        return key != null ? key : '';
    }
    
    /*
     * Helper method to start an element, without extra fluff.
     */
    private void start(String val) {
        w.writeStartElement(null, s(val), null);
    }
    
    /*
     * Helper method to write an attribute, without extra fluff.
     */
    private void att(String key, String val) {
        w.writeAttribute(null, null, key, s(val));
    }
    
    private void atts(Map<String, String> valueMap) {
        for (String key : valueMap.keyset()) {
            att(key, valueMap.get(key));
        }
    }
    
    private void chars(String key) {
        w.writeCharacters(s(key));
    }
    
    private void end() {
        w.writeEndElement();
    }

    private void simpleList(String key) {
        simpleList(new List<String>{ key });
    }

    private void simpleList(List<String> keys) {
        for (String key : keys) {
            start(key);
            chars(values.get(key));
            end();
        }   
    }
}