package lzm.starling.swf.tool.utils
{
   import flash.geom.Rectangle;
   
   public final class TextureUtil
   {
      
      private static const HIGHEST:uint = 4294967295;
       
      
      public function TextureUtil()
      {
         super();
      }
      
      public static function packTextures(param1:uint, param2:uint, param3:Object, param4:Boolean = false) : Rectangle
      {
         var _loc6_:Boolean = false;
         var _loc8_:int = 0;
         var _loc14_:int = 0;
         var _loc13_:* = null;
         var _loc7_:* = null;
         var _loc12_:* = null;
         var _loc5_:int = 0;
         var _loc10_:int = 0;
         var _loc21_:int = 0;
         var _loc20_:* = param3;
         for each(var _loc9_ in param3)
         {
         }
         if(!_loc9_)
         {
            return null;
         }
         var _loc17_:uint = 0;
         var _loc11_:Vector.<Rectangle> = new Vector.<Rectangle>();
         var _loc15_:int = 0;
         var _loc16_:int = 0;
         var _loc23_:int = 0;
         var _loc22_:* = param3;
         for each(_loc9_ in param3)
         {
            _loc17_ = _loc17_ + _loc9_.width * _loc9_.height;
            _loc11_.push(_loc9_);
            if(_loc16_ < _loc9_.width)
            {
               _loc16_ = _loc9_.width;
            }
            if(_loc15_ < _loc9_.height)
            {
               _loc15_ = _loc9_.height;
            }
         }
         _loc11_.sort(sortRectList);
         if(param1 == 0)
         {
            param1 = Math.sqrt(_loc17_);
         }
         param1 = getNearest2N(Math.max(int(_loc11_[0].width) + param2,param1));
         if(param1 < _loc15_)
         {
            param1 = param1 * 2;
         }
         if(param1 < _loc16_)
         {
            param1 = param1 * 2;
         }
         var _loc18_:* = 4294967295;
         var _loc19_:Vector.<Rectangle> = new Vector.<Rectangle>();
         _loc19_.push(new Rectangle(0,0,param1,_loc18_));
         do
         {
            _loc13_ = getHighestArea(_loc19_);
            _loc5_ = _loc19_.indexOf(_loc13_);
            _loc6_ = false;
            _loc10_ = 0;
            var _loc25_:int = 0;
            var _loc24_:* = _loc11_;
            for each(_loc9_ in _loc11_)
            {
               _loc8_ = int(_loc9_.width) + param2;
               _loc14_ = int(_loc9_.height) + param2;
               if(_loc13_.width >= _loc8_ && _loc13_.height >= _loc14_)
               {
                  _loc6_ = true;
                  break;
               }
               _loc10_++;
            }
            if(_loc6_)
            {
               _loc9_.x = _loc13_.x;
               _loc9_.y = _loc13_.y;
               _loc11_.splice(_loc10_,1);
               _loc19_.splice(_loc5_ + 1,0,new Rectangle(_loc13_.x + _loc8_,_loc13_.y,_loc13_.width - _loc8_,_loc13_.height));
               _loc13_.y = _loc13_.y + _loc14_;
               _loc13_.width = _loc8_;
               _loc13_.height = _loc13_.height - _loc14_;
            }
            else
            {
               if(_loc5_ == 0)
               {
                  _loc12_ = _loc19_[_loc5_ + 1];
               }
               else if(_loc5_ == _loc19_.length - 1)
               {
                  _loc12_ = _loc19_[_loc5_ - 1];
               }
               else
               {
                  _loc7_ = _loc19_[_loc5_ - 1];
                  _loc12_ = _loc19_[_loc5_ + 1];
                  _loc12_ = _loc7_.height <= _loc12_.height?_loc12_:_loc7_;
               }
               if(_loc13_.x < _loc12_.x)
               {
                  _loc12_.x = _loc13_.x;
               }
               _loc12_.width = _loc13_.width + _loc12_.width;
               _loc19_.splice(_loc5_,1);
            }
         }
         while(_loc11_.length > 0);
         
         _loc18_ = uint(getNearest2N(_loc18_ - getLowestArea(_loc19_).height));
         return new Rectangle(0,0,param1,_loc18_);
      }
      
      private static function sortRectList(param1:Rectangle, param2:Rectangle) : int
      {
         var _loc3_:uint = param1.width + param1.height;
         var _loc4_:uint = param2.width + param2.height;
         if(_loc3_ == _loc4_)
         {
            return param1.width > param2.width?-1:1;
         }
         return _loc3_ > _loc4_?-1:1;
      }
      
      private static function getNearest2N(param1:uint) : uint
      {
         return !!(param1 & param1 - 1)?1 << param1.toString(2).length:param1;
      }
      
      private static function getHighestArea(param1:Vector.<Rectangle>) : Rectangle
      {
         var _loc4_:* = null;
         var _loc3_:uint = 0;
         var _loc6_:int = 0;
         var _loc5_:* = param1;
         for each(var _loc2_ in param1)
         {
            if(_loc2_.height > _loc3_)
            {
               _loc3_ = _loc2_.height;
               _loc4_ = _loc2_;
            }
         }
         return _loc4_;
      }
      
      private static function getLowestArea(param1:Vector.<Rectangle>) : Rectangle
      {
         var _loc4_:* = null;
         var _loc3_:* = 4294967295;
         var _loc6_:int = 0;
         var _loc5_:* = param1;
         for each(var _loc2_ in param1)
         {
            if(_loc2_.height < _loc3_)
            {
               _loc3_ = uint(_loc2_.height);
               _loc4_ = _loc2_;
            }
         }
         return _loc4_;
      }
   }
}
