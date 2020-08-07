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
      
      public static function getMovieClipInfo(linkName:String, cls:Class) : Object
      {
         var mcObj:* = null;
         var totalFrames:int = 0;
         var framesData:* = null;
         var objCount:* = null;
         var objArr:* = null;
         var curFrame:int = 0;
         var numChildren:int = 0;
         var resultData:* = null;
         var itemData:* = null;
         var displayObj:* = null;
         var className:* = null;
         var type:* = null;
         var objNu:* = null;
         var curChildIndex:int = 0;
         var _loc9_:* = null;
         var _loc14_:int = 0;
         var _loc23_:* = null;
         var _loc18_:* = null;
         var _loc11_:* = null;
         var _loc22_:int = 0;
         try
         {
            mcObj = new cls();
            Starup.tempContent.addChild(mcObj);
            totalFrames = mcObj.totalFrames;
            framesData = [];
            objCount = {};
            objArr = {};
            curFrame = 1;
            while(curFrame <= totalFrames)
            {
               mcObj.gotoAndStop(curFrame);
               numChildren = mcObj.numChildren;
               resultData = [];
               objNu = {};
               curChildIndex = 0;
               while(curChildIndex < numChildren)
               {
                  displayObj = mcObj.getChildAt(curChildIndex) as DisplayObject;
                  className = getQualifiedClassName(displayObj);
                  type = SwfUtil.getChildType(className);
                  if(!(type == null || type == "comp"))
                  {
                     if(type == "text")
                     {
                        className = type;
                     }
                     if(objNu[className])
                     {
                        var tempClsN:* = className;
                        var _loc29_:* = objNu[tempClsN] + 1;
                        objNu[tempClsN] = _loc29_;
                     }
                     else
                     {
                        objNu[className] = 1;
                     }
                     if(objArr[className])
                     {
                        if((objArr[className] as Array).indexOf(displayObj) == -1)
                        {
                           (objArr[className] as Array).push(displayObj);
                        }
                     }
                     else
                     {
                        objArr[className] = [displayObj];
                     }
                     itemData = [className,type,displayObj.x * Util.swfScale,displayObj.y * Util.swfScale,displayObj.scaleX,displayObj.scaleY,displayObj.transform.matrix == null?0:Number(MatrixUtils.getSkewX(displayObj.transform.matrix)),displayObj.transform.matrix == null?0:Number(MatrixUtils.getSkewY(displayObj.transform.matrix)),displayObj.alpha];
                     if(displayObj.name.indexOf("instance") == -1)
                     {
                        itemData.push(displayObj.name);
                     }
                     else
                     {
                        itemData.push("");
                     }
                     itemData.push((objArr[className] as Array).indexOf(displayObj));
                     if(type == "s9" || type == "shapeImg")
                     {
                        itemData.push(Util.formatNumber(displayObj.width * Util.swfScale));
                        itemData.push(Util.formatNumber(displayObj.height * Util.swfScale));
                     }
                     else if(type == "text")
                     {
                        itemData.push((displayObj as TextField).width);
                        itemData.push((displayObj as TextField).height);
                        itemData.push((displayObj as TextField).defaultTextFormat.font);
                        itemData.push((displayObj as TextField).defaultTextFormat.color);
                        itemData.push((displayObj as TextField).defaultTextFormat.size);
                        itemData.push((displayObj as TextField).defaultTextFormat.align);
                        itemData.push((displayObj as TextField).defaultTextFormat.italic);
                        itemData.push((displayObj as TextField).defaultTextFormat.bold);
                        itemData.push((displayObj as TextField).text);
                     }
                     if(displayObj.blendMode == "normal")
                     {
                        itemData.push("auto");
                     }
                     else
                     {
                        itemData.push(displayObj.blendMode);
                     }
                     resultData.push(itemData);
                  }
                  curChildIndex++;
               }
               framesData.push(resultData);
               var _loc31_:int = 0;
               var tempObjNu:* = objNu;
               for(className in objNu)
               {
                  objCount[className] = objArr[className].length;
               }
               curFrame++;
            }
            var _loc33_:int = 0;
            var _loc32_:* = objCount;
            for(var _loc16_:* in objCount)
            {
               objCount[_loc16_] = [SwfUtil.getChildType(_loc16_),objCount[_loc16_]];
            }
            _loc9_ = mcObj.currentLabels;
            _loc14_ = _loc9_.length;
            _loc18_ = [];
            _loc11_ = {};
            _loc22_ = 0;
            while(_loc22_ < _loc14_)
            {
               _loc23_ = _loc9_[_loc22_];
               mcObj.gotoAndStop(_loc23_.name);
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
                  (_loc18_[_loc22_] as Array).push(mcObj.totalFrames - 1);
               }
               _loc22_++;
            }
            Starup.tempContent.removeChild(mcObj);
            _loc29_ = {
               "frames":framesData,
               "labels":_loc18_,
               "frameEvents":_loc11_,
               "objCount":objCount,
               "loop":(Assets.getTempData(linkName) == null?true:Assets.getTempData(linkName))
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
