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
         var _loc4_:int = 0;
         var _loc3_:Array = ["img","spr","mc","btn","s9","bat","flash.text::TextField","text","btn","s9","shapeImg","comp","particle"];
         var _loc2_:Array = ["img","spr","mc","btn","s9","bat","text","text","btn","s9","shapeImg","comp","particle"];
         _loc4_ = 0;
         while(_loc4_ < _loc3_.length)
         {
            if(param1.indexOf(_loc3_[_loc4_]) == 0)
            {
               return _loc2_[_loc4_];
            }
            _loc4_++;
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
      
      public function parse(param1:ApplicationDomain) : void
      {
         var _loc3_:* = null;
         var _loc5_:* = null;
         var _loc6_:int = 0;
         init();
         _appDomain = param1;
         var _loc2_:Vector.<String> = _appDomain.getQualifiedDefinitionNames();
         var _loc4_:int = _loc2_.length;
         _loc6_ = 0;
         while(_loc6_ < _loc4_)
         {
            _loc3_ = _loc2_[_loc6_];
            _loc5_ = getChildType(_loc3_);
            if(_loc5_ == "img")
            {
               imageNames.push(_loc3_);
               imageDatas[_loc3_] = ImageUtil.getImageInfo(getClass(_loc3_));
            }
            else if(_loc5_ == "spr")
            {
               spriteNames.push(_loc3_);
               spriteDatas[_loc3_] = SpriteUtil.getSpriteInfo(_loc3_,getClass(_loc3_));
            }
            else if(_loc5_ == "mc")
            {
               movieClipNames.push(_loc3_);
               movieClipDatas[_loc3_] = MovieClipUtil.getMovieClipInfo(_loc3_,getClass(_loc3_));
            }
            else if(_loc5_ == "btn")
            {
               buttonNames.push(_loc3_);
               buttonDatas[_loc3_] = SpriteUtil.getSpriteInfo(_loc3_,getClass(_loc3_));
            }
            else if(_loc5_ == "s9")
            {
               s9Names.push(_loc3_);
               s9Datas[_loc3_] = Scale9Util.getScale9Info(getClass(_loc3_));
            }
            else if(_loc5_ == "shapeImg")
            {
               shapeImgNames.push(_loc3_);
               shapeImgDatas[_loc3_] = [];
            }
            else if(_loc5_ == "comp")
            {
               componentNames.push(_loc3_);
               componentDatas[_loc3_] = SpriteUtil.getSpriteInfo(_loc3_,getClass(_loc3_));
            }
            else if(_loc5_ == "particle")
            {
               particleNames.push(_loc3_);
               particleDatas[_loc3_] = ParticleUtil.getParticlefo(getClass(_loc3_));
            }
            _loc6_++;
         }
         exportImages = exportImages.concat(imageNames,s9Names,shapeImgNames);
      }
      
      public function getClass(param1:String) : Class
      {
         return _appDomain.getDefinition(param1) as Class;
      }
      
      public function getSwfData(param1:String = "Starling") : ByteArray
      {
         var _loc4_:String = JSON.stringify({
            "img":imageDatas,
            "spr":spriteDatas,
            "mc":movieClipDatas,
            "btn":buttonDatas,
            "s9":s9Datas,
            "shapeImg":shapeImgDatas,
            "comp":componentDatas,
            "particle":particleDatas
         });
         var _loc3_:Object = JSON.parse(_loc4_);
         var _loc2_:ByteArray = new ByteArray();
         _loc2_.writeMultiByte(_loc4_,"utf-8");
         if(param1 == "Starling")
         {
            _loc2_.compress();
         }
         return _loc2_;
      }
   }
}
