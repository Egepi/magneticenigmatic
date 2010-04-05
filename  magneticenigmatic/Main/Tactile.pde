void startTactile() {
   if ( connectToTacTile){
      //ALTERNATIVE: constructor to setup the connection on TacTile
      //tacTile = new TouchAPI( this );

      //Create connection to Touch Server
      tacTile = new TouchAPI( this, dataPort, msgPort, tacTileMachine);
      
      tacTile.log_on(true);
      
      //System.out.println(tacTile.log);
      //size of the screen
      size( screen.width, screen.height );

  } else {
      //ALTERNATIVE: constructor to setup the connection LOCALLY on your machine
      //tacTile = new TouchAPI( this, 7000);

      //Create connection to Touch Server
      tacTile = new TouchAPI( this, dataPort, msgPort, localMachine);

      //size of the screen
      size( screen.width, screen.height );
  }
}

