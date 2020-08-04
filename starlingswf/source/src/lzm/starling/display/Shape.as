package lzm.starling.display
{
    import starling.display.DisplayObjectContainer;
	
	public class Shape extends DisplayObjectContainer
	{
//		private var _graphics :Graphics;
		
		public function Shape()
		{
//			_graphics = new Graphics(this);
		}
		
		public function get graphics():*
		{
			return null;
		}
		
	/*	override public function dispose() : void
		{
			if ( _graphics != null )
			{
				_graphics.dispose();
				_graphics = null;
			}
			super.dispose();
		} */
	}
}