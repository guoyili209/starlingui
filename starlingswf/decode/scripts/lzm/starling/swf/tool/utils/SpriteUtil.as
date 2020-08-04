package lzm.starling.swf.tool.utils
{
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import flash.utils.getQualifiedClassName;
   import lzm.starling.swf.filter.SwfFilter;
   import lzm.starling.swf.tool.Starup;
   import lzm.starling.swf.tool.asset.Assets;
   
   public class SpriteUtil
   {
       
      
      public function SpriteUtil()
      {
         super();
      }
      
      public static function getSpriteInfo(param1:String, param2:Class) : Array
      {
         var _loc3_:* = null;
         var _loc10_:* = null;
         var _loc4_:* = null;
         var _loc7_:* = null;
         var _loc14_:* = null;
         var _loc8_:* = null;
         var _loc5_:* = null;
         var _loc9_:int = 0;
         var _loc6_:int = 0;
         var _loc11_:MovieClip = new param2();
         Starup.tempContent.addChild(_loc11_);
         var _loc12_:int = _loc11_.numChildren;
         var _loc13_:Array = [];
         _loc9_ = 0;
         while(_loc9_ < _loc12_)
         {
            _loc10_ = _loc11_.getChildAt(_loc9_) as DisplayObject;
            _loc4_ = getQualifiedClassName(_loc10_);
            _loc7_ = SwfUtil.getChildType(_loc4_);
            if(_loc7_ != null)
            {
               _loc3_ = [_loc4_,_loc7_,Util.formatNumber(_loc10_.x * Util.swfScale),Util.formatNumber(_loc10_.y * Util.swfScale),Util.formatNumber(_loc10_.scaleX),Util.formatNumber(_loc10_.scaleY),_loc10_.transform.matrix == null?0:Number(MatrixUtil.getSkewX(_loc10_.transform.matrix)),_loc10_.transform.matrix == null?0:Number(MatrixUtil.getSkewY(_loc10_.transform.matrix)),_loc10_.alpha];
               if(_loc10_.name.indexOf("instance") == -1)
               {
                  _loc3_.push(_loc10_.name);
               }
               else
               {
                  _loc3_.push("");
               }
               if(_loc7_ == "s9" || _loc7_ == "shapeImg")
               {
                  _loc3_.push(Util.formatNumber(_loc10_.width * Util.swfScale));
                  _loc3_.push(Util.formatNumber(_loc10_.height * Util.swfScale));
               }
               else if(_loc7_ == "text")
               {
                  var _loc15_:* = _loc7_;
                  _loc3_[0] = _loc15_;
                  _loc4_ = _loc15_;
                  _loc3_.push((_loc10_ as TextField).width);
                  _loc3_.push((_loc10_ as TextField).height);
                  _loc3_.push((_loc10_ as TextField).defaultTextFormat.font);
                  _loc3_.push((_loc10_ as TextField).defaultTextFormat.color);
                  _loc3_.push((_loc10_ as TextField).defaultTextFormat.size);
                  _loc3_.push((_loc10_ as TextField).defaultTextFormat.align);
                  _loc3_.push((_loc10_ as TextField).defaultTextFormat.italic);
                  _loc3_.push((_loc10_ as TextField).defaultTextFormat.bold);
                  _loc3_.push((_loc10_ as TextField).text);
                  _loc14_ = _loc10_.filters;
                  _loc8_ = {};
                  _loc6_ = 0;
                  while(_loc6_ < _loc14_.length)
                  {
                     _loc5_ = getQualifiedClassName(_loc14_[_loc6_]);
                     if(SwfFilter.filters.indexOf(_loc5_) != -1)
                     {
                        _loc8_[_loc5_] = _loc14_[_loc6_].clone();
                     }
                     _loc6_++;
                  }
                  _loc3_.push(_loc8_);
               }
               else if(_loc7_ == "comp")
               {
                  _loc3_.push(Assets.getTempData(param1 + "-" + _loc9_ + _loc4_));
               }
               if(_loc7_ != "text")
               {
                  _loc14_ = _loc10_.filters;
                  if(_loc14_.length > 0)
                  {
                     _loc5_ = getQualifiedClassName(_loc14_[0]);
                     _loc8_ = {};
                     _loc8_[_loc5_] = _loc14_[0].clone();
                     _loc3_.push(_loc8_);
                  }
                  else
                  {
                     _loc3_.push(null);
                  }
               }
               _loc3_.push(_loc10_.blendMode);
               _loc13_.push(_loc3_);
            }
            _loc9_++;
         }
         Starup.tempContent.removeChild(_loc11_);
         return _loc13_;
      }
   }
}
