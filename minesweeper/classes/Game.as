﻿
﻿package classes

{
	import flash.events.MouseEvent;
	import flash.events.Event;
	import classes.Board;
	import classes.BoardPiece;
	import flash.display.MovieClip;

    public class Game extends MovieClip
    {
        public function Game( myBoard:Board ) //initialize private variables, set clicks, call isEmpty function for left click, setFlag for right click
        {
			board = myBoard;
			rowSize = myBoard.getRows();
			colSize = myBoard.getCols();
			counter = 0;
			flagCount = 0;
			firstClick = true;
			for (var i:int = 0; i < rowSize; i++) {
				for (var j:int = 0; j < colSize; j++) {
					myBoard.getBoardPiece(i, j).addEventListener(MouseEvent.CLICK, handleClick);
					myBoard.getBoardPiece(i, j).buttonMode = true;
				}
			}
        }

		public function handleClick(evt:MouseEvent):void {


			if(evt.shiftKey == true){

				if (evt.currentTarget.currentFrame == 11){
					evt.currentTarget.gotoAndStop(10);
					flagCount--;
					return;
				}
				if (flagCount < board.getMines()) {
					if (evt.currentTarget.currentFrame == 10) {
						flagCount++;
						evt.currentTarget.gotoAndStop(11);
					}
				}
			}
			else if (evt.currentTarget.currentFrame >= 1 && evt.currentTarget.currentFrame <= 8) {
				if (countFlags(evt.currentTarget.currentFrame,evt.currentTarget.getRow(), evt.currentTarget.getCol()) == evt.currentTarget.currentFrame) {
					clearSurrounding(evt.currentTarget.getRow(), evt.currentTarget.getCol());
				}
			}
			else if (evt.currentTarget.currentFrame == 10) {
				if (firstClick) {
					firstClick = false;
					board.setBoardMines(evt.currentTarget.getRow(), evt.currentTarget.getCol());
				}
				isEmpty(evt.currentTarget.getRow(), evt.currentTarget.getCol());
				if (endCheck()) {
					for (var i:int = 0; i < rowSize; i++) {
						for (var j:int = 0; j < colSize; j++) {
							if (board.getBoardPiece(i,j).checkForMine()) {
								board.getBoardPiece(i,j).gotoAndStop(11);
							}
						}
					}					
					endGame();
				}
			}
		}
		
		public function endGame():void {
			for (var i:int = 0; i < rowSize; i++) {
				for (var j:int = 0; j < colSize; j++) {
					board.getBoardPiece(i, j).removeEventListener(MouseEvent.CLICK, handleClick);
				}
			}			
		}

		public function clearSurrounding(row:int, col:int):void {
			if (row-1>=0)
			{
				if(board.getBoardPiece(row-1,  col).currentFrame == 10)//checks left-down
				{
					isEmpty(row-1,  col);
				}

				if(col+1<colSize)
				{
					if(board.getBoardPiece(row-1,  col+1).currentFrame == 10)//checks left-down
					{
					isEmpty(row-1,  col+1);
					}
				}
				if(col-1>=0)
				{
					if(board.getBoardPiece(row-1,  col-1).currentFrame == 10)//checks left-down
					{
					isEmpty(row-1,  col-1);
					}

				}
			}

			if(col+1<colSize)
			{
				if(board.getBoardPiece(row,  col+1).currentFrame == 10)//checks left-down
				{
					isEmpty(row,  col+1);
				}
			}
			if(col-1>=0)
			{
				if(board.getBoardPiece(row,  col-1).currentFrame == 10)//checks left-down
				{
					isEmpty(row,  col-1);
				}
			}
			if (row+1<rowSize)
			{
				if(board.getBoardPiece(row+1,  col).currentFrame == 10)//checks left-down
				{
					isEmpty(row+1,  col);
				}
				if(col+1<colSize)
				{
					if(board.getBoardPiece(row+1,  col+1).currentFrame == 10)//checks left-down
					{
						isEmpty(row+1,  col+1);
					}
				}
				if(col-1>=0)
				{
					if(board.getBoardPiece(row+1,  col-1).currentFrame == 10)//checks left-down
					{
					isEmpty(row+1,  col-1);
					}
				}
			}
		}

		public function countFlags(x:int,row:int,col:int):int {
			var count:int = 0;
			if (row-1>=0)
			{
				if((board.getBoardPiece(row-1, col)).currentFrame == 11)//checks left-down
				{
					count++;
				}

				if(col+1<colSize)
				{
					if((board.getBoardPiece(row-1, col+1)).currentFrame == 11)//checks left-down
					{
					count++;
					}
				}
				if(col-1>=0)
				{
					if((board.getBoardPiece(row-1, col-1)).currentFrame == 11)//checks left-down
					{
					count++;
					}

				}
			}

			if(col+1<colSize)
			{
				if((board.getBoardPiece(row, col+1)).currentFrame == 11)//checks left-down
				{
					count++;
				}
			}
			if(col-1>=0)
			{
				if((board.getBoardPiece(row, col-1)).currentFrame == 11)//checks left-down
				{
					count++;
				}
			}
			if (row+1<rowSize)
			{
				if((board.getBoardPiece(row+1, col)).currentFrame == 11)//checks left-down
				{
					count++;
				}
				if(col+1<colSize)
				{
					if((board.getBoardPiece(row+1, col+1)).currentFrame == 11)//checks left-down
					{
						count++;
					}
				}
				if(col-1>=0)
				{
					if((board.getBoardPiece(row+1, col-1)).currentFrame == 11)//checks left-down
					{
					count++;
					}
				}
			}
			return count;
		}

		public function endCheck():Boolean{
			var count:int = 0;
			for (var i:int = 0; i < rowSize; i++) {
				for (var j:int = 0; j < colSize; j++) {
					if (!board.getBoardPiece(i, j).checkForMine() && board.getBoardPiece(i, j).currentFrame != 10) {
						count++;
					}
				}
			}
			if (count == rowSize*colSize - board.getMines()) {
				return true;
			}
			return false;
		}


		public function isEmpty( row:int, col:int ):Boolean //returns false if there's a bomb, true if it's an empty space
		{
			if((board.getBoardPiece(row, col)).checkForMine()==false)
			{
				Checker(row, col);
				return true;
			}
			else
			{
				revealMines();
				board.getBoardPiece(row,col).gotoAndStop(13);
				endGame();
				return false; //Bomb explodes
			}
		}

		public function revealMines():void {
			for (var i:int = 0; i < rowSize; i++) {
				for (var j:int = 0; j < colSize; j++) {
					if (board.getBoardPiece(i, j).checkForMine()) {
						board.getBoardPiece(i, j).gotoAndStop(12);
					}
				}
			}
		}

		public function changeFlag( row:int,col:int ):void
		{

		}
		public function Checker( row:int, col:int ):Boolean //recursive function that checks around the selected spot
		{
			if(row>=rowSize || col>=colSize || row<0 || col<0)
			{
				return true;
			}
			else
			{
				if(row-1>=0){
					if((board.getBoardPiece(row-1, col)).checkForMine())//checks up
					{
						counter = counter+1;
					}

					if(col+1<colSize){
						if((board.getBoardPiece(row-1, col+1)).checkForMine())//checks right-up
						{
							counter = counter+1;
						}

					}

					if(col-1>=0){
						if((board.getBoardPiece(row-1, col-1)).checkForMine())//check left-up
						{
							counter = counter+1;
						}

					}
				}
				if(col+1<colSize){
					if((board.getBoardPiece(row, col+1)).checkForMine())//checks right
					{
						counter = counter+1;
					}
				}
				if(col-1>=0){
						if((board.getBoardPiece(row, col-1)).checkForMine())//checks left
						{
							counter = counter+1;
						}

				}

				if(row+1<rowSize){
					if((board.getBoardPiece(row+1, col)).checkForMine())//checks down
					{
						counter = counter+1;
					}
					if (col+1<colSize)
					{
						if((board.getBoardPiece(row+1, col+1)).checkForMine())//check right-down
						{
							counter = counter+1;
						}
					}
					if (col-1>=0)
					{
						if((board.getBoardPiece(row+1, col-1)).checkForMine())//checks left-down
						{
							counter = counter+1;
						}
					}
				}

				if(counter==0)
				{
					(board.getBoardPiece(row, col)).gotoAndStop(9); //switch frame to empty
					if (row-1>=0)
					{
						if((board.getBoardPiece(row-1, col)).currentFrame == 10)//checks left-down
						{
							Checker(row-1, col);
						}

						if(col+1<colSize)
						{
							if((board.getBoardPiece(row-1, col+1)).currentFrame == 10)//checks left-down
							{
							Checker(row-1, col+1);
							}
						}
						if(col-1>=0)
						{
							if((board.getBoardPiece(row-1, col-1)).currentFrame == 10)//checks left-down
							{
							Checker(row-1, col-1);
							}

						}
					}

					if(col+1<colSize)
					{
						if((board.getBoardPiece(row, col+1)).currentFrame == 10)//checks left-down
						{
							Checker(row, col+1);
						}
					}
					if(col-1>=0)
					{
						if((board.getBoardPiece(row, col-1)).currentFrame == 10)//checks left-down
						{
							Checker(row, col-1);
						}
					}




					if (row+1<rowSize)
					{
						if((board.getBoardPiece(row+1, col)).currentFrame == 10)//checks left-down
						{
							Checker(row+1, col);
						}
						if(col+1<colSize)
						{
							if((board.getBoardPiece(row+1, col+1)).currentFrame == 10)//checks left-down
							{
								Checker(row+1, col+1);
							}
						}
						if(col-1>=0)
						{
							if((board.getBoardPiece(row+1, col-1)).currentFrame == 10)//checks left-down
							{
							Checker(row+1, col-1);
							}
						}
					}
					return true;
				}
				if(counter!=0)
				{
					(board.getBoardPiece(row, col)).gotoAndStop(counter); //switch frame to counter
					counter=0;
					return true;
				}

			}
			return false;
		}
		//private var m_array:Array;
		private var board:Board;
		private var rowSize:int;
		private var colSize:int;
		private var counter:int;
		private var flagCount:int;
		private var firstClick:Boolean;

    }
}
