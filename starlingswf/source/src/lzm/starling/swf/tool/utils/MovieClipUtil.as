package lzm.starling.swf.tool.utils
{
   import flash.display.DisplayObject;
   import flash.display.FrameLabel;
   import flash.text.TextField;
   import flash.utils.getQualifiedClassName;

   import lzm.starling.swf.tool.Starup;
   import lzm.starling.swf.tool.asset.Assets;
   import flash.display.MovieClip;


    public class MovieClipUtil
   {


      public function MovieClipUtil()
      {
         super();
      }

      public static function getMovieClipInfo(linkName:String, cls:Class) : Object
      {
         var mcData:Object={};
         var mcObj:MovieClip = null;
         var totalFrames:int = 0;
         var framesData:Array = null;
         var objCount:Object = null;
         var objArr:Object = null;
         var curFrame:int = 0;
         var numChildren:int = 0;
         var resultData:Array = null;
         var itemData:Array = null;
         var displayObj:DisplayObject = null;
         var className:String = null;
         var type:String = null;
         var objNu:Object = null;
         var curChildIndex:int = 0;
         var frameLabelArr:Array = null;
         var frameLabelLength:int = 0;
         var frameLabel:FrameLabel = null;
         var labels:Array = null;
         var frameEvents:* = null;
         var frameIndex:int = 0;
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
                        var clsNRise:* = objNu[tempClsN] + 1;
                        objNu[tempClsN] = clsNRise;
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
            //    var _loc31_:int = 0;
               var tempObjNu:* = objNu;
               for(className in objNu)
               {
                  objCount[className] = objArr[className].length;
               }
               curFrame++;
            }
            // var _loc33_:int = 0;
            // var _loc32_:* = objCount;
            for(var key:* in objCount)
            {
               objCount[key] = [SwfUtil.getChildType(key),objCount[key]];
            }
            frameLabelArr = mcObj.currentLabels;
            frameLabelLength = frameLabelArr.length;
            labels = [];
            frameEvents = {};
            frameIndex = 0;
            while(frameIndex < frameLabelLength)
            {
               frameLabel = frameLabelArr[frameIndex];
               mcObj.gotoAndStop(frameLabel.name);
               labels.push([frameLabel.name,frameLabel.frame - 1]);
               if(frameLabel.name.indexOf("@") == 0)
               {
                  frameEvents[frameLabel.frame - 1] = frameLabel.name;
               }
               if(frameIndex > 0)
               {
                  (labels[frameIndex - 1] as Array).push(frameLabel.frame - 2);
               }
               if(frameIndex == frameLabelLength - 1)
               {
                  (labels[frameIndex] as Array).push(mcObj.totalFrames - 1);
               }
               frameIndex++;
            }
            Starup.tempContent.removeChild(mcObj);
            mcData = {
               "frames":framesData,
               "labels":labels,
               "frameEvents":frameEvents,
               "objCount":objCount,
               "loop":(Assets.getTempData(linkName) == null?true:Assets.getTempData(linkName))
            };
            return mcData;
         }
         catch(error:Error)
         {
            trace(error.getStackTrace());
         }
         return null;
      }
   }
}
