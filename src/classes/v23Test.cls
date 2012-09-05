@isTest
private class v23Test {
	private static void createListSettings() {
		List<ListSetting__c> listSettings = new List<ListSetting__c>();
		listSettings.add(new ListSetting__c(name='test'));
		insert listSettings;
	}
	
	static testMethod void testListSettingWithoutCreating() {
		Map<String, ListSetting__c> listSettings = ListSetting__c.getAll();
		System.assertNotEquals(0, listSettings.size());
	}
	
	static testMethod void testListSettingWithCreating() {
		createListSettings();
		testListSettingWithoutCreating();
	}
	
	@isTest(SeeAllData=true)
	static void testListSettingWithSeeAllData() {
		testListSettingWithoutCreating();
	} 
}