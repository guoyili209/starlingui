package lzm.atf.tool.utils
{
   import flash.desktop.NativeProcess;
   import flash.desktop.NativeProcessStartupInfo;
   import flash.events.NativeProcessExitEvent;
   import flash.events.ProgressEvent;
   import flash.filesystem.File;
   
   public class png2atfUtil
   {
      
      private static var nativeProcess:NativeProcess;
       
      
      public function png2atfUtil()
      {
         super();
      }
      
      public static function converAtf(param1:String, param2:String, param3:String, param4:String, param5:Boolean, param6:Boolean, param7:int, param8:Function, param9:Function) : void
      {
         workPath = param1;
         sourceFile = param2;
         exportFile = param3;
         platform = param4;
         compress = param5;
         mips = param6;
         quality = param7;
         converCallBack = param8;
         logCallBack = param9;
         onExit = function(param1:NativeProcessExitEvent):void
         {
         };
         onData = function(param1:ProgressEvent):void
         {
         };
         onError = function(param1:ProgressEvent):void
         {
         };
         var workingDirectory:File = new File(workPath);
         if(OSUtil.isMac())
         {
            var executable:File = File.applicationDirectory.resolvePath("assets/atftool/png2atf");
         }
         else if(OSUtil.isWindows())
         {
            executable = File.applicationDirectory.resolvePath("assets/atftool/png2atf.exe");
         }
         var params:Vector.<String> = new Vector.<String>();
         params.push("-c");
         if(platform != "")
         {
            params.push(platform);
         }
         if(compress)
         {
            params.push("-r");
         }
         params.push("-q");
         params.push(quality);
         if(mips)
         {
            params.push("-n");
            params.push("0,");
         }
         else
         {
            params.push("-n");
            params.push("0,0");
         }
         params.push("-i");
         params.push(sourceFile);
         params.push("-o");
         params.push(exportFile);
         var info:NativeProcessStartupInfo = new NativeProcessStartupInfo();
         info.workingDirectory = workingDirectory;
         info.arguments = params;
         info.executable = executable;
         if(nativeProcess == null)
         {
            nativeProcess = new NativeProcess();
            nativeProcess.addEventListener("exit",onExit);
            nativeProcess.addEventListener("standardOutputData",onData);
            nativeProcess.addEventListener("standardErrorData",onError);
         }
         try
         {
            nativeProcess.start(info);
            return;
         }
         catch(error:Error)
         {
            logCallBack(error.getStackTrace() + "\n");
            return;
         }
      }
   }
}
