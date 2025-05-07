package
{
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.KeyboardEvent;
    import flash.ui.Keyboard;
    import flash.text.TextField;
    import flash.text.TextFormat;
    import flash.events.MouseEvent;

    public class Main extends Sprite
    {
        private var basket:Sprite;
        private var ball:Sprite;
        private var score:int = 0;
        private var missed:int = 0;
        private var speed:Number = 20;

        private var scoreText:TextField;
        private var missedText:TextField;
        private var gameOverText:TextField;

        private const MAX_MISSED:int = 5;
        private var isGameOver:Boolean = false;

        private var restartButton:Sprite;
        private var ballSpeed:Number = 5;

        public function Main()
        {
            stage ? init() : addEventListener(Event.ADDED_TO_STAGE, init);
        }

        private function init(e:Event = null):void
        {
            removeEventListener(Event.ADDED_TO_STAGE, init);

            createBasket();
            createBall();
            createTextFields();

            stage.addEventListener(Event.ENTER_FRAME, gameLoop);
            stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
        }

        private function createBall():void
        {
            ball = new Sprite();
            ball.graphics.beginFill(0xFF0000);
            ball.graphics.drawCircle(0, 0, 15);
            ball.graphics.endFill();
            ball.x = Math.random() * (stage.stageWidth - 30) + 15;
            ball.y = 0;
            addChild(ball);
        }

        private function gameLoop(e:Event):void
        {
            ball.y += ballSpeed;

            if (ball.hitTestObject(basket))
            {
                score++;
                trace("Score: " + score);
                resetBall(ball);

                updateText();

                if (score % 5 == 0)
                {
                    ballSpeed += 1;
                }
            }
            else if (ball.y > stage.stageHeight)
            {
                missed++;
                trace("Missed: " + missed);
                updateText();
                resetBall(ball);
                if (missed >= MAX_MISSED)
                {
                    endGame();
                }
            }
        }

        private function resetBall(ball:Sprite):void
        {
            ball.x = Math.random() * (stage.stageWidth - 30) + 15;
            ball.y = 0;
        }

        private function createBasket():void
        {
            basket = new Sprite();
            basket.graphics.beginFill(0x0000FF);
            basket.graphics.drawRect(0, 0, 80, 20);
            basket.graphics.endFill();
            basket.y = stage.stageHeight - 30;
            basket.x = stage.stageWidth / 2 - 40;
            addChild(basket);
        }

        private function createTextFields():void
        {
            var format:TextFormat = new TextFormat();
            format.size = 18;
            format.bold = true;

            scoreText = new TextField();
            scoreText.defaultTextFormat = format;
            scoreText.textColor = 0x00AA00;
            scoreText.width = 200;
            scoreText.text = "Caught: 0";
            addChild(scoreText);

            missedText = new TextField();
            missedText.defaultTextFormat = format;
            missedText.textColor = 0xAA0000;
            missedText.width = 200;
            missedText.y = 25;
            missedText.text = "Missed: 0";
            addChild(missedText);
        }

        private function updateText():void
        {
            scoreText.text = "Caught: " + score;
            missedText.text = "Missed: " + missed;
        }

        private function onKeyDown(e:KeyboardEvent):void
        {
            if (isGameOver)
                return;

            if (e.keyCode == Keyboard.LEFT)
            {
                if (basket.x > 0)
                {
                    basket.x -= speed;
                }
            }
            else if (e.keyCode == Keyboard.RIGHT)
            {
                if (basket.x + basket.width < stage.stageWidth)
                {
                    basket.x += speed;
                }
            }
        }

        private function endGame():void
        {
            isGameOver = true;
            stage.removeEventListener(Event.ENTER_FRAME, gameLoop);

            var format:TextFormat = new TextFormat();
            format.size = 28;
            format.bold = true;
            format.align = "center";

            gameOverText = new TextField();
            gameOverText.defaultTextFormat = format;
            gameOverText.width = stage.stageWidth;
            gameOverText.height = 50;
            gameOverText.y = stage.stageHeight / 2 - 60;
            gameOverText.textColor = 0xFF0000;
            gameOverText.text = "Game is over!";
            gameOverText.selectable = false;
            addChild(gameOverText);

            createRestartButton();
        }

        private function createRestartButton():void
        {
            restartButton = new Sprite();
            restartButton.graphics.beginFill(0x00AAFF);
            restartButton.graphics.drawRoundRect(0, 0, 180, 40, 10);
            restartButton.graphics.endFill();
            restartButton.x = stage.stageWidth / 2 - 90;
            restartButton.y = stage.stageHeight / 2;

            var label:TextField = new TextField();
            var format:TextFormat = new TextFormat();
            format.size = 16;
            format.bold = true;
            format.align = "center";

            label.defaultTextFormat = format;
            label.width = 180;
            label.height = 30;
            label.text = "Try Again";
            label.selectable = false;
            label.mouseEnabled = false;
            label.y = 5;

            restartButton.addChild(label);
            restartButton.buttonMode = true;
            restartButton.mouseChildren = false;
            restartButton.addEventListener(MouseEvent.CLICK, restartGame);

            addChild(restartButton);
        }

        private function restartGame(e:MouseEvent):void
        {
            isGameOver = false;
            score = 0;
            missed = 0;
            ballSpeed = 5;

            removeChild(ball);
            createBall();
            updateText();

            if (gameOverText && contains(gameOverText))
                removeChild(gameOverText);
            if (restartButton && contains(restartButton))
            {
                restartButton.removeEventListener(MouseEvent.CLICK, restartGame);
                removeChild(restartButton);
            }

            stage.addEventListener(Event.ENTER_FRAME, gameLoop);
        }
    }
}
