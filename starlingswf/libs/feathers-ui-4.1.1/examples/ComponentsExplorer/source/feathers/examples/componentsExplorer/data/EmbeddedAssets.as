package feathers.examples.componentsExplorer.data
{
	import starling.textures.Texture;

	public class EmbeddedAssets
	{
		[Embed(source="/../assets/images/skull.png")]
		private static const SKULL_ICON_DARK_EMBEDDED:Class;

		[Embed(source="/../assets/images/skull-white.png")]
		private static const SKULL_ICON_LIGHT_EMBEDDED:Class;

		public static var SKULL_ICON_DARK:Texture;

		public static var SKULL_ICON_LIGHT:Texture;
		
		public static function initialize():void
		{
			//we can't create these textures until Starling is ready
			SKULL_ICON_DARK = Texture.fromEmbeddedAsset(SKULL_ICON_DARK_EMBEDDED, false, false, 2);
			SKULL_ICON_LIGHT = Texture.fromEmbeddedAsset(SKULL_ICON_LIGHT_EMBEDDED, false, false, 2);
		}
	}
}
