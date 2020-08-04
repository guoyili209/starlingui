package lzm.starling.swf.filter
{
   import flash.utils.getDefinitionByName;
   import starling.filters.BlurFilter;
   import starling.filters.FragmentFilter;
   
   public class SwfFilter
   {
      
      public static const filters:Array = ["flash.filters::GlowFilter","flash.filters::DropShadowFilter","flash.filters::BlurFilter"];
       
      
      public function SwfFilter()
      {
         super();
      }
      
      public static function createFilter(param1:Object) : FragmentFilter
      {
         var _loc4_:* = null;
         var _loc3_:* = null;
         var _loc7_:* = null;
         var _loc6_:* = null;
         var _loc2_:* = null;
         var _loc5_:* = null;
         var _loc10_:int = 0;
         var _loc9_:* = param1;
         for(_loc4_ in param1)
         {
            _loc3_ = param1[_loc4_];
            var _loc8_:* = _loc4_;
            if(filters[0] !== _loc8_)
            {
               if(filters[1] !== _loc8_)
               {
                  if(filters[2] === _loc8_)
                  {
                     _loc5_ = new BlurFilter(_loc3_.blurX / 10,_loc3_.blurY / 10);
                     _loc7_ = _loc5_;
                  }
               }
               else
               {
                  _loc2_ = new BlurFilter(_loc3_.blurX / 10,_loc3_.blurY / 10);
                  _loc2_.offsetX = Math.cos(_loc3_.angle) * _loc3_.distance;
                  _loc2_.offsetY = Math.sin(_loc3_.angle) * _loc3_.distance;
                  _loc2_.mode = "below";
                  _loc2_.setUniformColor(true,_loc3_.color,_loc3_.alpha);
                  _loc7_ = _loc2_;
               }
            }
            else
            {
               _loc6_ = new BlurFilter(_loc3_.blurX / 10,_loc3_.blurY / 10);
               _loc6_.mode = "below";
               _loc6_.setUniformColor(true,_loc3_.color,_loc3_.alpha);
               _loc7_ = _loc6_;
            }
         }
         return _loc7_;
      }
      
      public static function createTextFieldFilter(param1:Object) : Array
      {
         var _loc4_:* = null;
         var _loc3_:* = null;
         var _loc2_:* = null;
         var _loc5_:Array = [];
         var _loc7_:int = 0;
         var _loc6_:* = param1;
         for(_loc3_ in param1)
         {
            _loc2_ = getDefinitionByName(_loc3_) as Class;
            _loc4_ = new _loc2_();
            setPropertys(_loc4_,param1[_loc3_]);
            _loc5_.push(_loc4_);
         }
         return _loc5_.length > 0?_loc5_:null;
      }
      
      private static function setPropertys(param1:Object, param2:Object) : void
      {
         var _loc5_:int = 0;
         var _loc4_:* = param2;
         for(var _loc3_ in param2)
         {
            if(param1.hasOwnProperty(_loc3_))
            {
               param1[_loc3_] = param2[_loc3_];
            }
         }
      }
   }
}
