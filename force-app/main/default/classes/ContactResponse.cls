/**
 * Created by gossowska on 15.07.2022.
 */

public with sharing class ContactResponse {
    public static HttpResponse getContact(String endpointString, String body) {
        HttpRequest req = new HttpRequest();
        req.setMethod('GET');

        req.setEndpoint(endpointString);

        req.setBody(body);

        Http http = new Http();
        HttpResponse res;

        try {
            res = http.send(req);
        } catch(System.CalloutException e) {
            System.debug(e);
        }
        return res;
    }
}