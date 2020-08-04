package feathers.examples.transitionsExplorer.screens
{
	import feathers.controls.List;
	import feathers.controls.PanelScreen;
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ArrayCollection;
	import feathers.data.ListCollection;
	import feathers.events.FeathersEventType;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;

	import starling.events.Event;

	public class AllTransitionsScreen extends PanelScreen
	{
		public static const COLOR_FADE:String = "colorFade";
		public static const COVER:String = "cover";
		public static const CUBE:String = "cube";
		public static const FADE:String = "fade";
		public static const FLIP:String = "flip";
		public static const IRIS:String = "iris";
		public static const REVEAL:String = "reveal";
		public static const SLIDE:String = "slide";
		public static const WIPE:String = "wipe";

		public function AllTransitionsScreen()
		{
		}

		private var _list:List;

		public var savedVerticalScrollPosition:Number = 0;
		public var savedSelectedIndex:int = -1;

		override protected function initialize():void
		{
			//never forget to call super.initialize()
			super.initialize();

			this.title = "Transitions";

			this.layout = new AnchorLayout();

			this._list = new List();
			this._list.dataProvider = new ArrayCollection(
			[
				{ label: "Color Fade", event: COLOR_FADE },
				{ label: "Cover", event: COVER },
				{ label: "Fade", event: FADE },
				{ label: "Cube", event: CUBE },
				{ label: "Flip", event: FLIP },
				{ label: "Iris", event: IRIS },
				{ label: "Reveal", event: REVEAL },
				{ label: "Slide", event: SLIDE },
				{ label: "Wipe", event: WIPE },
			]);
			this._list.layoutData = new AnchorLayoutData(0, 0, 0, 0);
			this._list.clipContent = false;
			this._list.autoHideBackground = true;
			this._list.verticalScrollPosition = this.savedVerticalScrollPosition;
			this._list.selectedIndex = this.savedSelectedIndex;

			this._list.itemRendererFactory = this.createItemRenderer;

			this._list.addEventListener(Event.TRIGGERED, list_triggeredHandler);
			this.addChild(this._list);

			this.addEventListener(FeathersEventType.TRANSITION_IN_COMPLETE, transitionInCompleteHandler);
		}
		
		private function createItemRenderer():IListItemRenderer
		{
			var renderer:DefaultListItemRenderer = new DefaultListItemRenderer();
			renderer.styleNameList.add(DefaultListItemRenderer.ALTERNATE_STYLE_NAME_DRILL_DOWN);

			//enable the quick hit area to optimize hit tests when an item
			//is only selectable and doesn't have interactive children.
			renderer.isQuickHitAreaEnabled = true;

			renderer.labelField = "label";
			return renderer;
		};

		private function transitionInCompleteHandler(event:Event):void
		{
			this._list.selectedIndex = -1;
			this._list.revealScrollBars();
		}

		private function list_triggeredHandler(event:Event, item:Object):void
		{
			var eventType:String = item.event as String;
			this.dispatchEventWith(eventType, false,
			{
				//we're going to save the position of the list so that when the user
				//navigates back to this screen, they won't need to scroll back to
				//the same position manually
				savedVerticalScrollPosition: this._list.verticalScrollPosition,
				//we'll also save the selected index to temporarily highlight
				//the previously selected item when transitioning back
				savedSelectedIndex: this._list.selectedIndex
			});
		}
	}
}
