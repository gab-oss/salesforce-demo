/**
 * Created by gossowska on 06.07.2022.
 */

public with sharing class Webinar {

    // Webinars with a Cost below 100EUR are automatically approved
    public static void approveIfCostBelow100(List<Webinar__c> webinars) {
        for (Webinar__c webinar : webinars) {
            if (webinar.Cost__c < 100) {
                webinar.ApprovalStatus__c = 'Approved';
            } else {
                webinar.ApprovalStatus__c = 'Pending';
            }
        }
    }

    // Rejected webinars have status ‘Canceled’ set automatically
    public static void cancelRejected(List<Webinar__c> webinars) {
        for (Webinar__c webinar : webinars) {
            if (webinar.ApprovalStatus__c == 'Rejected') {
                webinar.Status__c = 'Canceled';
            }
        }
    }

    // The number of participants cannot exceed the seat number
    public static void checkIfEnoughSeats(List<Webinar__c> webinars) {
        for (Webinar__c webinar : webinars) {
            if (webinar.NumberOfParticipants__c != null && webinar.TotalNumberOfSeats__c != null) {
                if (webinar.NumberOfParticipants__c > webinar.TotalNumberOfSeats__c) {
                    webinar.addError('Not enough seats for participants');
                }
            }
        }
    }

    // The price per participant is calculated automatically
    public static void calculatePricePerParticipant(List<Webinar__c> webinars) {
        for (Webinar__c webinar : webinars) {
            if (webinar.NumberOfParticipants__c != null && webinar.Cost__c != null) {
                if (webinar.NumberOfParticipants__c == 0) {
                    webinar.addError('You need participants');
                }
                webinar.PricePerParticipant__c = webinar.Cost__c / webinar.NumberOfParticipants__c;
            }
        }
    }

    //As soon as the status changes the value from New to anything else (except for Canceled) the value of Approval Status cannot be Pending any longer
    public static void checkIfOldAndStillPending(Map<Id, Webinar__c> newMap, Map<Id, Webinar__c> oldMap) {
        List<String> pendSt = new List<String>{'New', 'Canceled'};
        for (Id webinarId : oldMap.keySet()) {
            if (oldMap.get(webinarId).Status__c == 'New'
                    && !pendSt.contains(newMap.get(webinarId).Status__c)
                    && newMap.get(webinarId).ApprovalStatus__c == 'Pending') {
                newMap.get(webinarId).addError('Approval cannot be pending for a not-new webinar');
            }
        }
    }

    public static void doPlatformEvent(List<Webinar__c> webinars) {
        List<WebinarEvent__e> events = new List<WebinarEvent__e>();
        for (Webinar__c webinar : webinars) {
            WebinarEvent__e we = new WebinarEvent__e();
            we.WebinarsSalesforceID__c = webinar.Id;
            events.add(we);
        }

        List<Database.SaveResult> result = EventBus.publish(events);
        System.debug(result);
        for (Database.SaveResult r : result) {
            List<Id> successIds = new List<Id>();
            System.debug(r);
            System.debug(r.isSuccess());
            if (r.isSuccess()) {
                System.debug('NEW EVENT IDS');
                successIds.add(r.id);
            }

//            List<WebinarEvent__e> addedEvents = [SELECT FIELDS(ALL) FROM WebinarEvent__e WHERE Id in :successIds];
        }
    }
}