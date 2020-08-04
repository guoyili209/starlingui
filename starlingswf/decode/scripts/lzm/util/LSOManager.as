package lzm.util
{
   import flash.events.NetStatusEvent;
   import flash.net.SharedObject;
   
   public final class LSOManager
   {
      
      public static var NAME:String = "LSODB";
      
      public static const PATH:String = "/";
      
      private static var dbObj:Object;
      
      private static var shareObj:SharedObject;
      
      private static var pendingObj:Object;
       
      
      public function LSOManager()
      {
         super();
      }
      
      private static function init() : void
      {
         if(shareObj == null)
         {
            try
            {
               shareObj = SharedObject.getLocal(NAME,"/");
               dbObj = shareObj.data;
               return;
            }
            catch(err:Error)
            {
               dbObj = {};
               return;
            }
         }
      }
      
      public static function get(param1:*) : *
      {
         return getSO()[param1];
      }
      
      public static function put(param1:*, param2:*) : *
      {
         var _loc3_:* = getSO()[param1];
         getSO()[param1] = param2;
         saveSO();
         return _loc3_;
      }
      
      public static function has(param1:*) : Boolean
      {
         return getSO().hasOwnProperty(param1);
      }
      
      public static function del(param1:*) : Boolean
      {
         var _loc2_:Object = getSO();
         var _loc3_:* = delete _loc2_[param1];
         if(_loc3_)
         {
            saveSO();
         }
         return _loc3_;
      }
      
      private static function getSO() : Object
      {
         init();
         return dbObj;
      }
      
      public static function saveSO() : void
      {
         var _loc1_:* = null;
         init();
         try
         {
            _loc1_ = shareObj.flush();
            if(_loc1_ == "pending")
            {
               pendingObj = shareObj;
               shareObj.addEventListener("netStatus",onStatus);
            }
            else if(_loc1_ == "flushed")
            {
            }
            return;
         }
         catch(e:Error)
         {
            trace("LSOManager.saveSo\n",e.getStackTrace());
            return;
         }
      }
      
      private static function onStatus(param1:NetStatusEvent) : void
      {
         shareObj.removeEventListener("netStatus",onStatus);
         if(param1.info.code == "SharedObject.Flush.Success")
         {
            if(pendingObj != null)
            {
               saveSO();
               pendingObj = null;
            }
         }
         else if(param1.info.code == "SharedObject.Flush.Failed")
         {
         }
      }
   }
}
