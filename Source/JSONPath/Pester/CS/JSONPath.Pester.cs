using System;

namespace JSONPath.Pester
{
    public class Root
    {
        public string StringSingle{get;set;}
        public string[] StringArray{get;set;}

        public int IntSingle{get;set;}
        public int[] IntArray{get;set;}

        public Type1 Type1Single{get;set;}
        public Type1[] Type1Array{get;set;}

    }
    public class Type1
    {
        public string StringSingle{get;set;}
        public string[] StringArray{get;set;}

        public int IntSingle{get;set;}
        public int[] IntArray{get;set;}

        public Type2 Type2Single{get;set;}
        public Type2[] Type2Array{get;set;}
    }
    public class Type2
    {
        public string StringSingle{get;set;}
        public string[] StringArray{get;set;}
        
        public int IntSingle{get;set;}
        public int[] IntArray{get;set;}
    }    
}