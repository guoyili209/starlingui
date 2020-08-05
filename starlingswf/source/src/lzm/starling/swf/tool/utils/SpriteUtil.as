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
      
      public static function getSpriteInfo(name:String, linkClass:Class) : Array
      {
         var itemData:Array = null;
         var displayObj:DisplayObject = null;
         var className:String = null;
         var type:String = null;
         var filterArr:Array = null;
         var filterObj:Object = null;
         var filterClassName:* = null;
         var index:int = 0;
         var _loc6_:int = 0;
         var mc:MovieClip = new linkClass();
         Starup.tempContent.addChild(mc);
         var len:int = mc.numChildren;
         var dataArr:Array = [];
         index = 0;
         while(index < len)
         {
            displayObj = mc.getChildAt(index) as DisplayObject;
            className = getQualifiedClassName(displayObj);
            type = SwfUtil.getChildType(className);
            if(type != null)
            {
               itemData = [className,type,Util.formatNumber(displayObj.x * Util.swfScale),Util.formatNumber(displayObj.y * Util.swfScale),Util.formatNumber(displayObj.scaleX),Util.formatNumber(displayObj.scaleY),displayObj.transform.matrix == null?0:Number(MatrixUtils.getSkewX(displayObj.transform.matrix)),displayObj.transform.matrix == null?0:Number(MatrixUtils.getSkewY(displayObj.transform.matrix)),displayObj.alpha];
               if(displayObj.name.indexOf("instance") == -1)
               {
                  itemData.push(displayObj.name);
               }
               else
               {
                  itemData.push("");
               }
               if(type == "s9" || type == "shapeImg")
               {
                  itemData.push(Util.formatNumber(displayObj.width * Util.swfScale));
                  itemData.push(Util.formatNumber(displayObj.height * Util.swfScale));
               }
               else if(type == "text")
               {
                  var _loc15_:* = type;
                  itemData[0] = _loc15_;
                  className = _loc15_;
                  itemData.push((displayObj as TextField).width);
                  itemData.push((displayObj as TextField).height);
                  itemData.push((displayObj as TextField).defaultTextFormat.font);
                  itemData.push((displayObj as TextField).defaultTextFormat.color);
                  itemData.push((displayObj as TextField).defaultTextFormat.size);
                  itemData.push((displayObj as TextField).defaultTextFormat.align);
                  itemData.push((displayObj as TextField).defaultTextFormat.italic);
                  itemData.push((displayObj as TextField).defaultTextFormat.bold);
                  itemData.push((displayObj as TextField).text);
                  filterArr = displayObj.filters;
                  filterObj = {};
                  _loc6_ = 0;
                  while(_loc6_ < filterArr.length)
                  {
                     filterClassName = getQualifiedClassName(filterArr[_loc6_]);
                     if(SwfFilter.filters.indexOf(filterClassName) != -1)
                     {
                        filterObj[filterClassName] = filterArr[_loc6_].clone();
                     }
                     _loc6_++;
                  }
                  itemData.push(filterObj);
               }
               else if(type == "comp")
               {
                  itemData.push(Assets.getTempData(name + "-" + index + className));
               }
               if(type != "text")
               {
                  filterArr = displayObj.filters;
                  if(filterArr.length > 0)
                  {
                     filterClassName = getQualifiedClassName(filterArr[0]);
                     filterObj = {};
                     filterObj[filterClassName] = filterArr[0].clone();
                     itemData.push(filterObj);
                  }
                  else
                  {
                     itemData.push(null);
                  }
               }
               itemData.push(displayObj.blendMode);
               dataArr.push(itemData);
            }
            index++;
         }
         Starup.tempContent.removeChild(mc);
         return dataArr;
      }
   }
}
