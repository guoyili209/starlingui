package lzm.starling
{
   import starling.display.Sprite;
   
   public class STLRootClass extends Sprite
   {
       
      
      private var _root:Sprite;
      
      public function STLRootClass()
      {
         super();
      }
      
      public function start(param1:Class) : void
      {
         _root = new param1();
         addChild(_root);
      }
   }
}
