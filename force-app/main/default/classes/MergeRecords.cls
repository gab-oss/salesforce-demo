/**
 * Created by gossowska on 05.07.2022.
 */

public with sharing class MergeRecords {
    public static void mergeRecords(SObject sobjectTo, SObject sobjectFrom) {
        if (sobjectTo.getSObjectType() != sobjectFrom.getSObjectType()) {
            return;
        }
        Map<String, Object> fieldsToCopy = sobjectFrom.getPopulatedFieldsAsMap();
        for (String field : fieldsToCopy.keySet()) {
            sobjectTo.put(field, fieldsToCopy.get(field));
            update sobjectTo;
            // delete sobjectFrom;
        }
    }
}