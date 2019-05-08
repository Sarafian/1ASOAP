using System;

namespace SOAP.Pester.Set1ASOAPProxyMock
{
    public class Proxy
    {
        public SessionValue SessionValue{get;set;}
        public AMA_SecurityHostedUserValue AMA_SecurityHostedUserValue{get;set;}
    }
    public class SessionValue
    {
        public string TransactionStatusCode{get;set;}
    }
    public class AMA_SecurityHostedUserValue
    {
        public UserID UserID{get;set;}
    }    
    public class UserID
    {
        public string POS_Type{get;set;}
        public string RequestorType{get;set;}
        public string PseudoCityCode{get;set;}
        public string AgentDutyCode{get;set;}
        public RequestorID RequestorID{get;set;}
    }
    public class RequestorID
    {
        public CompanyName CompanyName{get;set;}
    }
    public class CompanyName
    {
        public string Value{get;set;}
    }
}