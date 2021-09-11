public  class samleparent {
        public static string Name='mani';
        public static integer a=20;
        public  integer b;
        public  integer c;
      //methods
    public samleparent(){
        system.debug('....con....'+Name);
        Name='manju';
        system.debug('....con' +Name);
    }
    
    public  samleparent(string st,integer s){
        system.debug('....par con....'+Name);
        Name='st';
        b=s;
        system.debug('....con par....'+Name);
    }
    public void addmthd(integer K){
        system.debug('....name....'+Name);
        system.debug('....a....'+a);
        system.debug('....b....'+b);
        system.debug('....c....'+c);
        b=k;
        
        c=a+b;
        system.debug('....a....'+a);
        system.debug('....b....'+b);
        system.debug('....c....'+c);
    }
    public integer show(){
        system.debug('....name....'+Name);
        system.debug('....a....'+a);
        system.debug('....b....'+b);
        system.debug('....c....'+c);
        Name='sujesh';
        addmthd(32);
        system.debug('....Name....'+Name);
        return a;
    }   
}