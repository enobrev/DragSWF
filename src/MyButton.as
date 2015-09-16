package  {
	import flash.display.Sprite;
    import flash.text.TextField;
	public class MyButton extends Sprite {
		public var myText:TextField;
		
		public function MyButton(value:String) {
			this.myText = new TextField();
            this.myText.text = value;
		}
		
		public function init():void {
            this.myText.width = 200;
            this.myText.height = 50;
            this.myText.background = true;
			this.myText.backgroundColor = 0xCCCCFF;
            this.myText.border = true;
			this.myText.mouseEnabled = false;
			this.myText.borderColor = 0xAAAAFF;
			this.addChild(this.myText);
		}
	}
}