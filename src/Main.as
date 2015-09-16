package 
{
	import flash.display.Sprite;
	
	public class Main extends Sprite
	{
		public function Main():void
		{
			var x:ExternalInterfaceExample = new ExternalInterfaceExample();
			this.addChild(x);
			x.init();
		}
	}
}