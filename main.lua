local gameKit = require("plugin.gamekit")
local json = require("json")

--scalers
local scale0X= ((display.actualContentWidth- display.contentWidth)*.5)
local scale0Y= ((display.actualContentHeight- display.contentHeight)*.5)

local myPlayerId = ""
local myGamecenterName = ""
local otherPlayerId = ""
local otherGamecenterName = ""
local gameCenterLogined = false
local myPlayerNum =0
math.randomseed(os.time()) 
myPlayerNum = math.random(214748364)
print( myPlayerNum )
local otherPlayerNum = 0
local triggerMultiplayer
local quitMultiplayer
local sendMyData
local playerLetterText
local updateBoard
local sceneGroup = display.newGroup( )
local currentBoard = {}
local gameTable= {}
gameTable.id= 0
gameTable.board = {}
--left to right and top to bottem
gameTable.board[1] = ""
gameTable.board[2] = ""
gameTable.board[3] = ""
gameTable.board[4] = ""
gameTable.board[4] = ""
gameTable.board[5] = ""
gameTable.board[6] = ""
gameTable.board[7] = ""
gameTable.board[8] = ""
gameTable.board[9] = ""
gameTable.winner = ""
local canPlay = false
local myType = "O" -- set to player two default
local function handleGamekit( event )
	print("run set up")
	print(event.type)
	if (event.type == "authenticated") then
		gameCenterLogined = true
		myPlayerId = event.localPlayerId
		myGamecenterName = event.localPlayerAlias
		triggerMultiplayer()
	elseif event.type == "showSignInUI" then
		gameKit.show("gameCenterSignInUI")
	end
	return true
end
--display the game
sceneGroup.alpha = 1 -- start hidden
local background= display.newRect( sceneGroup, display.contentCenterX, display.contentCenterY, display.actualContentWidth, display.actualContentHeight )
local line1 = display.newLine(sceneGroup,  scale0X*-1, 0, display.contentWidth, 0 )
line1.x, line1.y = display.contentCenterX-(display.actualContentWidth *.5), display.contentCenterY-100
line1:setStrokeColor( .5 )
line1.strokeWidth = 8
local line2 = display.newLine(sceneGroup,  scale0X*-1, 0, display.contentWidth, 0 )
line2.x, line2.y = display.contentCenterX-(display.actualContentWidth *.5), display.contentCenterY+100
line2:setStrokeColor( .5 )
line2.strokeWidth = 8
local line3 = display.newLine(sceneGroup,  0, scale0Y*-1, 0, display.contentHeight )
line3.x, line3.y = display.contentCenterX-58, display.contentCenterY-(display.contentHeight *.5)
line3:setStrokeColor( .5 )
line3.strokeWidth = 8
local line4 = display.newLine(sceneGroup,  0, scale0Y*-1, 0, display.contentHeight )
line4.x, line4.y = display.contentCenterX+58, display.contentCenterY-(display.contentHeight *.5)
line4:setStrokeColor( .5 )
line4.strokeWidth = 8
local tiles = {}
local myIndex = 1

local function tilesTouch( event )
	if (event.phase =="began") then
		local tile = event.target
		if (canPlay == true and tile.currentType == nil and gameTable.board[tile.index] == "") then
			gameTable.board[tile.index]= myType
			tile.currentType = myType
			sendMyData()
			updateBoard()
			canPlay = false
		end
	end
end
tiles[myIndex] = display.newRect( sceneGroup, 50, 68, 100, 136 )
tiles[myIndex]:setFillColor( 1,0,0,.5 )
tiles[myIndex].index = myIndex
tiles[myIndex]:addEventListener( "touch", tilesTouch )
myIndex = myIndex+1
tiles[myIndex] = display.newRect( sceneGroup, 160, 68, 110, 136 )
tiles[myIndex]:setFillColor( 1,0,0,.5 )
tiles[myIndex].index = myIndex
tiles[myIndex]:addEventListener( "touch", tilesTouch )
myIndex = myIndex+1
tiles[myIndex] = display.newRect( sceneGroup, 270, 68, 100, 136 )
tiles[myIndex]:setFillColor( 1,0,0,.5 )
tiles[myIndex].index = myIndex
tiles[myIndex]:addEventListener( "touch", tilesTouch )
myIndex = myIndex+1
tiles[myIndex] = display.newRect( sceneGroup, 50, 240, 100, 200 )
tiles[myIndex]:setFillColor( 1,0,0,.5 )
tiles[myIndex].index = myIndex
tiles[myIndex]:addEventListener( "touch", tilesTouch )
myIndex = myIndex+1
tiles[myIndex] = display.newRect( sceneGroup, 160, 240, 110, 200 )
tiles[myIndex]:setFillColor( 1,0,0,.5 )
tiles[myIndex].index = myIndex
tiles[myIndex]:addEventListener( "touch", tilesTouch )
myIndex = myIndex+1
tiles[myIndex] = display.newRect( sceneGroup, 270, 240, 100, 200 )
tiles[myIndex]:setFillColor( 1,0,0,.5 )
tiles[myIndex].index = myIndex
tiles[myIndex]:addEventListener( "touch", tilesTouch )
myIndex = myIndex+1
tiles[myIndex] = display.newRect( sceneGroup, 50, 435, 100, 183 )
tiles[myIndex]:setFillColor( 1,0,0,.5 )
tiles[myIndex].index = myIndex
tiles[myIndex]:addEventListener( "touch", tilesTouch )
myIndex = myIndex+1
tiles[myIndex] = display.newRect( sceneGroup, 160, 435, 110, 183 )
tiles[myIndex]:setFillColor( 1,0,0,.5 )
tiles[myIndex].index = myIndex
tiles[myIndex]:addEventListener( "touch", tilesTouch )
myIndex = myIndex+1
tiles[myIndex] = display.newRect( sceneGroup, 270, 435, 100, 183 )
tiles[myIndex]:setFillColor( 1,0,0,.5 )
tiles[myIndex].index = myIndex
tiles[myIndex]:addEventListener( "touch", tilesTouch )
myIndex = myIndex+1
--refresh board
function updateBoard(  )
	for i=1,9 do
		if (gameTable.board[i]~= "" and currentBoard[i] == nil) then
			currentBoard[i] = display.newText( sceneGroup, gameTable.board[i], tiles[i].x, tiles[i].y, native.systemFont, 100 )
		end
	end
	
	local isWinner = false
	local function checkWinner( )
		if (gameTable.board[1] == myType and gameTable.board[2] == myType and gameTable.board[3] == myType) then -- row 1
			return true
		elseif (gameTable.board[4] == myType and gameTable.board[5] == myType and gameTable.board[6] == myType) then -- row 2
			return true
		elseif (gameTable.board[7] == myType and gameTable.board[8] == myType and gameTable.board[9] == myType) then -- row 3
			return true
		elseif (gameTable.board[1] == myType and gameTable.board[4] == myType and gameTable.board[7] == myType) then -- col 1
			return true
		elseif (gameTable.board[2] == myType and gameTable.board[5] == myType and gameTable.board[8] == myType) then -- col 2
			return true
		elseif (gameTable.board[3] == myType and gameTable.board[6] == myType and gameTable.board[9] == myType) then -- col 3
			return true
		elseif (gameTable.board[1] == myType and gameTable.board[5] == myType and gameTable.board[9] == myType) then -- dig 1
			return true
		elseif (gameTable.board[3] == myType and gameTable.board[5] == myType and gameTable.board[7] == myType) then -- dig 2
			return true
		else
			return false
		end
	end
	isWinner=checkWinner()
	print( isWinner )
	if (isWinner == true) then
		canPlay = false
		gameTable.winner = myType
		sendMyData()
		playerLetterText.text = "you win, reset app to play again"
	end
end
--multiplayer started
function triggerMultiplayer( )
	sceneGroup.alpha = 1
	local function handleRealtime( event )
		print("realtime:"..event.type)
		if( event.type == "matchStarted" ) then
			gameKit.sendRealTimeDataToAllPlayers({data= tostring(myPlayerNum), dataMode="Reliable", successCallback=true})
	    end
	    if( event.type == "playerAddedToMatch" ) then
        end
        if event.type == "success" then
        	gameKit.show( "gameCenterRealTimeMatchUI", { minPlayers=2, maxPlayers=2, defaultNumPlayers=2 } )
        end
	end
	local function dataHandle( event )
		if( event.type == "matchData" ) then
			print( "data:"..event.data.." myNum:"..myPlayerNum )
	    	if (tonumber(event.data )) then -- handle
	    		if (event.fromPlayerID ~= myPlayerId) then -- not my data
	        		otherPlayerNum = tonumber(event.data)
	        	end
	        	if (otherPlayerNum < myPlayerNum) then
	        		myType = "X"
	    			canPlay= true
	        	end
	        	display.remove( playerLetterText )
	        	playerLetterText = display.newText( sceneGroup, myType, display.contentCenterX, 20, native.systemFontBold, 15 )
	        else -- is table data
	        	if (event.fromPlayerID ~= myPlayerId) then -- not my data
	        		gameTable = json.decode( event.data )
	        		updateBoard()
	        		canPlay= true
	        		if (gameTable.winner and gameTable.winner ~= "") then
	        			canPlay = false
	        			playerLetterText.text = "you lose, reset app to play again"
	        		end
	        	else -- my data
	        		gameTable = json.decode( event.data )
	        		updateBoard()
	        	end
	    	end
        end
        if( event.type == "playerStateDisconnected" ) then
        	if (playerLetterText) then
        		playerLetterText.text = "Player left"
        	end
        end
	end
	gameKit.request( "registerRealTimeListener", { listener=dataHandle } )
	gameKit.request("registerRealTimeMatchmakerListener", { listener=handleRealtime })
end
function sendMyData( )
	gameKit.sendRealTimeDataToAllPlayers({data=json.encode( gameTable ), dataMode="Reliable", successCallback=true})
end
--start game
timer.performWithDelay( 300, function (  )
	gameKit.init(handleGamekit)
end )