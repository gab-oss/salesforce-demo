/**
 * Created by gossowska on 05.07.2022.
 */

public with sharing class ContactsDeactivator {
    public static void deactivate(List<Account> accounts) {
        List<Contact> contactsToDeactivate = new List<Contact>();
        for (Account account : accounts) {
            if(!account.Active_checkbox__c) {
                List<Contact> contacts = [SELECT isActive__c, Title FROM Contact WHERE AccountId = :account.Id];
                for (Contact contact : contacts) {
                    contact.Title = account.Description.substring(0,128);
                    contact.isActive__c = false;
                    contactsToDeactivate.add(contact);
                }
            }
        }
        update contactsToDeactivate;
    }
}