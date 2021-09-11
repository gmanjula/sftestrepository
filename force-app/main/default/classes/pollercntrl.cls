public with sharing class pollercntrl {
    public String name { get; set; } 
    public PageReference lname() {
         name= 'Lname Manikanta';
        return null;
    }


    public PageReference fname() {
       name= 'Fname sujesh';
        return null;
    }
    public string getname(){
      string name1='manju';
      return name1;
    }
    
    
    /*public pollercntrl(){
       name= 'manju';
    }*/

    
}