package lzm.starling.swf.tool.utils
{
   import flash.system.ApplicationDomain;
   import flash.utils.ByteArray;

   public class SwfUtil
   {


      public var imageNames:Array;

      public var spriteNames:Array;

      public var movieClipNames:Array;

      public var buttonNames:Array;

      public var s9Names:Array;

      public var shapeImgNames:Array;

      public var componentNames:Array;

      public var particleNames:Array;

      public var imageDatas:Object;

      public var spriteDatas:Object;

      public var movieClipDatas:Object;

      public var buttonDatas:Object;

      public var s9Datas:Object;

      public var shapeImgDatas:Object;

      public var componentDatas:Object;

      public var particleDatas:Object;

      public var exportImages:Array;

      private var _appDomain:ApplicationDomain;

      public function SwfUtil()
      {
         exportImages = [];
         super();
      }

      public static function getChildType(param1:String) : String
      {
         var index:int = 0;
         var linkClsTypeArr:Array = ["img","spr","mc","btn","s9","bat","flash.text::TextField","text","btn","s9","shapeImg","comp","particle"];
         var linkClsTypeMapArr:Array = ["img","spr","mc","btn","s9","bat","text","text","btn","s9","shapeImg","comp","particle"];
         index = 0;
         while(index < linkClsTypeArr.length)
         {
            if(param1.indexOf(linkClsTypeArr[index]) == 0)
            {
               return linkClsTypeMapArr[index];
            }
            index++;
         }
         return null;
      }

      private function init() : void
      {
         imageNames = [];
         spriteNames = [];
         movieClipNames = [];
         buttonNames = [];
         s9Names = [];
         shapeImgNames = [];
         componentNames = [];
         particleNames = [];
         imageDatas = {};
         spriteDatas = {};
         movieClipDatas = {};
         buttonDatas = {};
         s9Datas = {};
         shapeImgDatas = {};
         componentDatas = {};
         particleDatas = {};
         exportImages = [];
         _appDomain = null;
      }

      public function parse(appDomain:ApplicationDomain) : void
      {
         var linkClsName:String = null;
         var linkClsType:String = null;
         var linkClsNameVecIndex:int = 0;
         init();
         _appDomain = appDomain;
         var linkClssNameVec:Vector.<String> = _appDomain.getQualifiedDefinitionNames();
         var linkClsNameVecLen:int = linkClssNameVec.length;
         linkClsNameVecIndex = 0;
         while(linkClsNameVecIndex < linkClsNameVecLen)
         {
            linkClsName = linkClssNameVec[linkClsNameVecIndex];
            linkClsType = getChildType(linkClsName);
            if(linkClsType == "img")
            {
               imageNames.push(linkClsName);
               imageDatas[linkClsName] = ImageUtil.getImageInfo(getClass(linkClsName));
            }
            else if(linkClsType == "spr")
            {
               spriteNames.push(linkClsName);
               spriteDatas[linkClsName] = SpriteUtil.getSpriteInfo(linkClsName,getClass(linkClsName));
            }
            else if(linkClsType == "mc")
            {
               movieClipNames.push(linkClsName);
               movieClipDatas[linkClsName] = MovieClipUtil.getMovieClipInfo(linkClsName,getClass(linkClsName));
            }
            else if(linkClsType == "btn")
            {
               buttonNames.push(linkClsName);
               buttonDatas[linkClsName] = SpriteUtil.getSpriteInfo(linkClsName,getClass(linkClsName));
            }
            else if(linkClsType == "s9")
            {
               s9Names.push(linkClsName);
               s9Datas[linkClsName] = Scale9Util.getScale9Info(getClass(linkClsName));
            }
            else if(linkClsType == "shapeImg")
            {
               shapeImgNames.push(linkClsName);
               shapeImgDatas[linkClsName] = [];
            }
            else if(linkClsType == "comp")
            {
               componentNames.push(linkClsName);
               componentDatas[linkClsName] = SpriteUtil.getSpriteInfo(linkClsName,getClass(linkClsName));
            }
            else if(linkClsType == "particle")
            {
               particleNames.push(linkClsName);
               particleDatas[linkClsName] = ParticleUtil.getParticlefo(getClass(linkClsName));
            }
            linkClsNameVecIndex++;
         }
         exportImages = exportImages.concat(imageNames,s9Names,shapeImgNames);
      }

      public function getClass(clsName:String) : Class
      {
         return _appDomain.getDefinition(clsName) as Class;
      }

      public function getSwfData(platform:String = "Starling") : ByteArray
      {
         var jsonData:String = JSON.stringify({
            "img":imageDatas,
            "spr":spriteDatas,
            "mc":movieClipDatas,
            "btn":buttonDatas,
            "s9":s9Datas,
            "shapeImg":shapeImgDatas,
            "comp":componentDatas,
            "particle":particleDatas
         });
          trace(jsonData);
        //  var _loc3_:Object = JSON.parse(jsonData);

         var byte:ByteArray = new ByteArray();
         byte.writeMultiByte(jsonData,"utf-8");
         if(platform == "Starling")
         {
            byte.compress();
         }
         return byte;
      }
   }
}
