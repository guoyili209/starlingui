package lzm.starling.swf
{
	import flash.utils.Dictionary;
	
	import lzm.starling.swf.display.SwfButton;
	import lzm.starling.swf.display.SwfImage;
	import lzm.starling.swf.display.SwfMovieClip;
	import lzm.starling.swf.display.SwfParticleSyetem;
	import lzm.starling.swf.display.SwfScale9Image;
	import lzm.starling.swf.display.SwfShapeImage;
	import lzm.starling.swf.display.SwfSprite;
	
	import starling.utils.AssetManager;

	/**
	 * Swf资源集中管理工具 
	 * @author zmliu
	 * 
	 */	
	public class SwfAssetManager
	{
		
		protected var _verbose:Boolean = false;
		
		protected var _loadQueue:Array;
		protected var _loadQueueNames:Array;
		protected var _isLoading:Boolean;
		
		protected var _swfs:Dictionary;
		protected var _swfNames:Array;
		
		protected var _scaleFactor:Number;
		protected var _useMipmaps:Boolean;
		
		protected static const ______otherAssetsTag:String = "______otherAssetsTag";
		protected var _otherAssets:AssetManager;//用于加载其他资源
		protected var _otherQueue:Array;
		
		
		
		public function SwfAssetManager(scaleFactor:Number=1, useMipmaps:Boolean=false)
		{
			_loadQueue = [];
			_loadQueueNames = [];
			_isLoading = false;
			
			_swfs = new Dictionary();
			_swfNames = [];
			
			_scaleFactor = scaleFactor;
			_useMipmaps = useMipmaps;
			
			_otherAssets = new AssetManager(scaleFactor,useMipmaps);
			_otherQueue = [];
		}
		
		/**
		 * 添加一个swf到队列中 
		 * @param name		swf名字
		 * @param resource	swf所需的资源集合
		 * @param fps		swf创建之后的帧率
		 */		
		public function enqueue(name:String,resource:Array,fps:int=24):void{
			if(_isLoading){
				log("正在加载中。请稍后再试");
				return;
			}
			if(getSwf(name) != null){
				log("Swf已经存在");
				return;
			}
			if(_loadQueueNames.indexOf(name) == -1){
				_loadQueueNames.push(name);
				_loadQueue.push([name,resource,fps]);
			}else{
				log("加载队列中已经有：" + name + ",跳过!");
			}
			
		}
		
		/**
		 * 批量添加swf到加载队列 
		 * @param swfs	[[swf名字1,[swf资源1,swf资源2],swf帧率(可选)],[swf名字1,[swf资源1,swf资源2],swf帧率(可选)]]
		 */		
		public function enqueueWithArray(swfs:Array):void{
			if(_isLoading){
				log("正在加载中。请稍后再试");
				return;
			}
			var len:int = swfs.length;
			var swfAsset:Array;
			for (var i:int = 0; i < len; i++) {
				swfAsset = swfs[i];
				if(swfAsset.length == 3){
					enqueue(swfAsset[0],swfAsset[1],swfAsset[2]);
				}else{
					enqueue(swfAsset[0],swfAsset[1]);
				}
			}
		}
		
		/**
		 * 加载其他资源
		 * */
		public function enqueueOtherAssets(...rawAssets):void{
			if(_isLoading){
				log("正在加载中。请稍后再试");
				return;
			}
			for each (var rawAsset:Object in rawAssets) {
				_otherQueue.push(rawAsset);
			}
		}
		
		/** 将需要加载的资源推入队列 */
		protected function parseOtherAssets():void{
			if(_otherQueue.length > 0){
				enqueue(______otherAssetsTag,_otherQueue.slice());
			}
			_otherQueue = [];
		}
		
		/**
		 * 开始加载队列 
		 */		
		public function loadQueue(onProgress:Function):void{
			if(_isLoading){
				log("正在加载中。请稍后再试");
				return;
			}
			
			parseOtherAssets();
			
			_loadQueueNames = [];
			
			var swfAsset:Array;
			var numSwfAsset:int = _loadQueue.length;
			var currentRatio:Number = 0;
			var avgRatio:Number = 1 / numSwfAsset;
			
			if(numSwfAsset == 0){
				log("没有需要加载的Swf");
				onProgress(1);
				return;
			}
			
			_isLoading = true;
			
			loadNext();
			
			function loadNext():void{
				swfAsset = _loadQueue.shift();
				if(getSwf(swfAsset[0]) != null){
					loadNext();
				}else{
					load();
				}
			}
			
			function load():void{
				var swfName:String = swfAsset[0];
				var swfResource:Array = swfAsset[1];
				var swfFps:int = swfAsset[2];
				var assetManager:AssetManager = swfName == ______otherAssetsTag ? _otherAssets : new AssetManager(_scaleFactor,_useMipmaps);
				
				assetManager.verbose = verbose;
				
				for each (var assetObject:Object in swfResource) {
					assetManager.enqueue(assetObject);
				}
				
				assetManager.loadQueue(function(ratio:Number):void{
					if(ratio == 1){
						if(swfName != ______otherAssetsTag){
							addSwf(swfName,new Swf(assetManager.getByteArray(swfName),assetManager,swfFps));
						}
						loadComplete();
					}else{
						onProgress(currentRatio + avgRatio*ratio);
					}
				});
			}
			
			function loadComplete():void{
				currentRatio = _loadQueue.length ? 1.0 - (_loadQueue.length / numSwfAsset) : 1.0;
				
				if(currentRatio == 1){
					_isLoading = false;
				}else{
					loadNext();
				}
				
				onProgress(currentRatio);
			}
		}
		
		/**
		 * @param name	swf名字
		 * @return swf
		 */		
		public function getSwf(name:String):Swf{
			return _swfs[name];
		}
		
		/** 添加一个swf */
		public function addSwf(name:String,swf:Swf):Boolean{
			if(getSwf(name) != null){
				log("Swf已经存在");
				return false;
			}else{
				log("添加Swf:"+name);
				_swfs[name] = swf;
				_swfNames.push(name);
			}
			return true;
		}
		
		/** 删除一个swf */
		public function removeSwf(name:String,dispose:Boolean=false):void{
			var swf:Swf = getSwf(name);
			if(swf){
				log("移除Swf:" + name +"  dispose:" + dispose);
				if(dispose){
					swf.dispose(dispose);
				}
				delete _swfs[name];
				_swfNames.splice(_swfNames.indexOf(name),1);
			}
		}
		
		/** 清除所有swf */
		public function clearSwf():void{
			for each (var swf:Swf in _swfs) {
				swf.dispose(true);
			}
			_swfs = new Dictionary();
			_swfNames = [];
		}
		
		public function clearAll():void{
			clearSwf();
			_otherAssets.purge();
			_otherAssets.clearRuntimeLoadTexture();
		}
		
		/**
		 * 获取当前所有已经加载swf的名字
		 * */
		public function get swfNames():Array{
			return _swfNames.slice();
		}
		
		/** 创建Sprite */
		public function createSprite(name:String):SwfSprite{
			for each (var swf:Swf in _swfs) if(swf.hasSprite(name)) return swf.createSprite(name);
			return null;
		}
		/** 创建MovieClip */
		public function createMovieClip(name:String):SwfMovieClip{
			for each (var swf:Swf in _swfs) if(swf.hasMovieClip(name)) return swf.createMovieClip(name);
			return null;
		}
		/** 创建Image */
		public function createImage(name:String):SwfImage{
			for each (var swf:Swf in _swfs) if(swf.hasImage(name)) return swf.createImage(name);
			return null;
		}
		/** 创建Button */
		public function createButton(name:String):SwfButton{
			for each (var swf:Swf in _swfs) if(swf.hasButton(name)) return swf.createButton(name);
			return null;
		}
		/** 创建S9Image */
		public function createS9Image(name:String):SwfScale9Image{
			for each (var swf:Swf in _swfs) if(swf.hasS9Image(name)) return swf.createS9Image(name);
			return null;
		}
		/** 创建ShapeImage */
		public function createShapeImage(name:String):SwfShapeImage{
			for each (var swf:Swf in _swfs) if(swf.hasShapeImage(name)) return swf.createShapeImage(name);
			return null;
		}
		/** 创建Component */
		public function createComponent(name:String):*{
			for each (var swf:Swf in _swfs) if(swf.hasComponent(name)) return swf.createComponent(name);
			return null;
		}
		/** 创建粒子 */
		public function createParticle(name:String):SwfParticleSyetem{
			for each (var swf:Swf in _swfs) if(swf.hasParticle(name)) return swf.createParticle(name);
			return null;
		}
		
		public function get otherAssets():AssetManager{
			return _otherAssets;
		}
		
		public function get verbose():Boolean { return _verbose; }
		public function set verbose(value:Boolean):void { _verbose = value; }
		protected function log(message:String):void{
			if(_verbose){
				trace("SwfAssetManager:"+message);
			}
		}
	}
}