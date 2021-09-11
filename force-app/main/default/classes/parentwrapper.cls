public with sharing class parentwrapper {

    public list<childwrap> lstchild { get; set; }
    
    public class childwrap{
        public string itemname{get; set;}
        public string price{get; set;}
        public integer quantity{get; set;}
         public childwrap(string i, string p, integer q ){
          //childwrap ch = new childwrap('pen',30,300);
          itemname =i;
          price=p;
          quantity=q;
         }
    }
    //parent class constructor
    public parentwrapper(){
        lstchild= new list<childwrap>();
         lstchild.add(new childwrap('pen','30$',300));
        lstchild.add(new childwrap('book','10$',150));
        lstchild.add(new childwrap('pad','5$',50));
        lstchild.add(new childwrap('measurement tape','30$',300));
        lstchild.add(new childwrap('scale','50$',200));
        
    }
    
}