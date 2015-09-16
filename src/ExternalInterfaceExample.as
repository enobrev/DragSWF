package {
    import flash.display.Sprite;
    import flash.events.*;
    import flash.external.ExternalInterface;
	import flash.geom.Rectangle;
    import flash.text.TextField;
    import flash.utils.Timer;
    import flash.text.TextFieldType;
    import flash.text.TextFieldAutoSize;

    public class ExternalInterfaceExample extends Sprite {
        private var output:TextField;
		private var items:Array;
		private var dragging:MyButton;

        public function init():void {
			this.items = new Array;
			
            this.output = new TextField();
            this.output.width = 150;
            this.output.height = 100;
            this.output.multiline = true;
            this.output.wordWrap = true;
            this.output.border = true;
            this.output.text = "Initializing...\n";
            this.addChild(this.output);

            if (ExternalInterface.available) {
                try {
                    ExternalInterface.addCallback("sendToActionScript", receivedFromJavaScript);
                    if (checkJavaScriptReady()) {
                        this.output.appendText("JavaScript is ready.\n");
						this.sendToJavaScript('Actionscript is ready');
                    } else {
                        this.output.appendText("JavaScript is not ready, creating timer.\n");
                        var readyTimer:Timer = new Timer(100);
                        readyTimer.addEventListener(TimerEvent.TIMER, timerHandler);
                        readyTimer.start();
                    }
                } catch (error:SecurityError) {
                    this.output.appendText("A SecurityError occurred: " + error.message + "\n");
                } catch (error:Error) {
                    this.output.appendText("An Error occurred: " + error.message + "\n");
                }
            } else {
                this.output.appendText("External interface is not available for this container.");
				this.receivedFromJavaScript('Test');
            }
        }
		
        private function receivedFromJavaScript(value:String):void {
            this.output.appendText("JavaScript says: " + value + "\n");
			this.sendToJavaScript('Recieved Item ' + value);
			
			var item:MyButton = new MyButton(value);
            this.addChild(item);
			item.init();
						
			if (this.items.length) {
				var lastItem:MyButton = this.items[this.items.length - 1];
				item.x = lastItem.x;
				item.y = lastItem.y + lastItem.height + 5;
			} else {
				item.x = 0;
				item.y = this.output.y + this.output.height + 5;
			}
			
			item.addEventListener(MouseEvent.MOUSE_DOWN, this.dragItem);
			item.addEventListener(MouseEvent.MOUSE_UP, this.dropItem);
			
			this.items.push(item);
        }
		
		private function dragItem(event:MouseEvent):void {
			event.target.startDrag();
			event.target.addEventListener(MouseEvent.MOUSE_MOVE, this.dragEvent);
		}
		
		private function dropItem(event:MouseEvent):void {
			event.target.removeEventListener(MouseEvent.MOUSE_MOVE, this.dragEvent);
			event.target.stopDrag();
		}
		
		private function dragEvent(event:MouseEvent):void {
			if (event.currentTarget.y + event.currentTarget.height > this.stage.stageHeight) {
				this.dragToJavaScript(event.currentTarget.myText.text);
				event.currentTarget.removeEventListener(MouseEvent.MOUSE_MOVE, this.dragEvent);
				event.currentTarget.stopDrag();
				
				for (var i:String in this.items) {
					if (items[i].myText.text == event.currentTarget.myText.text) {
						this.removeChild(items[i]);
						this.items.splice(i, 1);
						break;
					}
				}
			}
		}
		
        private function checkJavaScriptReady():Boolean {
            var isReady:Boolean = ExternalInterface.call("isReady");
            return isReady;
        }
		
        private function timerHandler(event:TimerEvent):void {
            this.output.appendText("Checking JavaScript status...\n");
            var isReady:Boolean = checkJavaScriptReady();
            if (isReady) {
                output.appendText("JavaScript is ready.\n");
                Timer(event.target).stop();
            }
        }
		
        private function dragToJavaScript(value:String):void {
            if (ExternalInterface.available) {
                ExternalInterface.call("dragToJavaScript", value);
            }
        }
		
        private function sendToJavaScript(value:String):void {
            if (ExternalInterface.available) {
                ExternalInterface.call("sendToJavaScript", value);
            }
        }
    }
}