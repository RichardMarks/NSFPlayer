package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.ByteArray;
	import nsf.NSFFile;

	/**
	 * ...
	 * @author Richard Marks
	 */
	[Frame(factoryClass="Preloader")]
	public class Main extends Sprite 
	{
		
		[Embed(source = "../assets/test.nsf", mimeType = "application/octet-stream")] static private const TEST_NSF:Class;
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}

		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			var file:NSFFile = NSFFile.Load(TEST_NSF);
		}
	}
}