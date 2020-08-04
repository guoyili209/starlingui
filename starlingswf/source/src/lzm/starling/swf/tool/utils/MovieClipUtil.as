package lzm.starling.swf.tool.utils
{
   import flash.display.DisplayObject;
   import flash.display.FrameLabel;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import flash.utils.getQualifiedClassName;
   import lzm.starling.swf.tool.Starup;
   import lzm.starling.swf.tool.asset.Assets;

    
    public class MovieClipUtil
   {
       
      
      public function MovieClipUtil()
      {
         super();
      }
      
      public static function getMovieClipInfo(param1:String, param2:Class) : Object
      {
         var _loc13_:* = null;
         var _loc5_:int = 0;
         var _loc21_:* = null;
         var _loc20_:* = null;
         var _loc15_:* = null;
         var _loc19_:int = 0;
         var _loc12_:int = 0;
         var _loc25_:* = null;
         var _loc3_:* = null;
         var _loc10_:* = null;
         var _loc17_:* = null;
         var _loc7_:* = null;
         var _loc4_:* = null;
         var _loc24_:int = 0;
         var _loc9_:* = null;
         var _loc14_:int = 0;
         var _loc23_:* = null;
         var _loc18_:* = null;
         var _loc11_:* = null;
         var _loc22_:int = 0;
         try
         {
            _loc13_ = new param2();
            Starup.tempContent.addChild(_loc13_);
            _loc5_ = _loc13_.totalFrames;
            _loc21_ = [];
            _loc20_ = {};
            _loc15_ = {};
            _loc19_ = 1;
            while(_loc19_ <= _loc5_)
            {
               _loc13_.gotoAndStop(_loc19_);
               _loc12_ = _loc13_.numChildren;
               _loc25_ = [];
               _loc4_ = {};
               _loc24_ = 0;
               while(_loc24_ < _loc12_)
               {
                  _loc10_ = _loc13_.getChildAt(_loc24_) as DisplayObject;
                  _loc17_ = getQualifiedClassName(_loc10_);
                  _loc7_ = SwfUtil.getChildType(_loc17_);
                  if(!(_loc7_ == null || _loc7_ == "comp"))
                  {
                     if(_loc7_ == "text")
                     {
                        _loc17_ = _loc7_;
                     }
                     if(_loc4_[_loc17_])
                     {
                        var _loc28_:* = _loc17_;
                        var _loc29_:* = _loc4_[_loc28_] + 1;
                        _loc4_[_loc28_] = _loc29_;
                     }
                     else
                     {
                        _loc4_[_loc17_] = 1;
                     }
                     if(_loc15_[_loc17_])
                     {
                        if((_loc15_[_loc17_] as Array).indexOf(_loc10_) == -1)
                        {
                           (_loc15_[_loc17_] as Array).push(_loc10_);
                        }
                     }
                     else
                     {
                        _loc15_[_loc17_] = [_loc10_];
                     }
                     _loc3_ = [_loc17_,_loc7_,_loc10_.x * Util.swfScale,_loc10_.y * Util.swfScale,_loc10_.scaleX,_loc10_.scaleY,_loc10_.transform.matrix == null?0:Number(MatrixUtils.getSkewX(_loc10_.transform.matrix)),_loc10_.transform.matrix == null?0:Number(MatrixUtils.getSkewY(_loc10_.transform.matrix)),_loc10_.alpha];
                     if(_loc10_.name.indexOf("instance") == -1)
                     {
                        _loc3_.push(_loc10_.name);
                     }
                     else
                     {
                        _loc3_.push("");
                     }
                     _loc3_.push((_loc15_[_loc17_] as Array).indexOf(_loc10_));
                     if(_loc7_ == "s9" || _loc7_ == "shapeImg")
                     {
                        _loc3_.push(Util.formatNumber(_loc10_.width * Util.swfScale));
                        _loc3_.push(Util.formatNumber(_loc10_.height * Util.swfScale));
                     }
                     else if(_loc7_ == "text")
                     {
                        _loc3_.push((_loc10_ as TextField).width);
                        _loc3_.push((_loc10_ as TextField).height);
                        _loc3_.push((_loc10_ as TextField).defaultTextFormat.font);
                        _loc3_.push((_loc10_ as TextField).defaultTextFormat.color);
                        _loc3_.push((_loc10_ as TextField).defaultTextFormat.size);
                        _loc3_.push((_loc10_ as TextField).defaultTextFormat.align);
                        _loc3_.push((_loc10_ as TextField).defaultTextFormat.italic);
                        _loc3_.push((_loc10_ as TextField).defaultTextFormat.bold);
                        _loc3_.push((_loc10_ as TextField).text);
                     }
                     if(_loc10_.blendMode == "normal")
                     {
                        _loc3_.push("auto");
                     }
                     else
                     {
                        _loc3_.push(_loc10_.blendMode);
                     }
                     _loc25_.push(_loc3_);
                  }
                  _loc24_++;
               }
               _loc21_.push(_loc25_);
               var _loc31_:int = 0;
               var _loc30_:* = _loc4_;
               for(_loc17_ in _loc4_)
               {
                  _loc20_[_loc17_] = _loc15_[_loc17_].length;
               }
               _loc19_++;
            }
            var _loc33_:int = 0;
            var _loc32_:* = _loc20_;
            for(var _loc16_ in _loc20_)
            {
               _loc20_[_loc16_] = [SwfUtil.getChildType(_loc16_),_loc20_[_loc16_]];
            }
            _loc9_ = _loc13_.currentLabels;
            _loc14_ = _loc9_.length;
            _loc18_ = [];
            _loc11_ = {};
            _loc22_ = 0;
            while(_loc22_ < _loc14_)
            {
               _loc23_ = _loc9_[_loc22_];
               _loc13_.gotoAndStop(_loc23_.name);
               _loc18_.push([_loc23_.name,_loc23_.frame - 1]);
               if(_loc23_.name.indexOf("@") == 0)
               {
                  _loc11_[_loc23_.frame - 1] = _loc23_.name;
               }
               if(_loc22_ > 0)
               {
                  (_loc18_[_loc22_ - 1] as Array).push(_loc23_.frame - 2);
               }
               if(_loc22_ == _loc14_ - 1)
               {
                  (_loc18_[_loc22_] as Array).push(_loc13_.totalFrames - 1);
               }
               _loc22_++;
            }
            Starup.tempContent.removeChild(_loc13_);
            _loc29_ = {
               "frames":_loc21_,
               "labels":_loc18_,
               "frameEvents":_loc11_,
               "objCount":_loc20_,
               "loop":(Assets.getTempData(param1) == null?true:Assets.getTempData(param1))
            };
            return _loc29_;
         }
         catch(error:Error)
         {
            trace(error.getStackTrace());
         }
         return null;
      }
   }
}
