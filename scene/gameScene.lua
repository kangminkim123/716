-- game scene

-- place all the require statements here
local composer = require( "composer" )
local physics = require("physics")
local json = require( "json" )
local tiled = require( "com.ponywolf.ponytiled" )
 
local scene = composer.newScene()
 
 local map = nil
 local ninjaBoy = nil
 local rightArrow = nil
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------



local function onRightArrowTouch( event )
   if ( event.phase == "began" ) then
 	   if ninjaBoy.sequence ~= "run" then
 			ninjaBoy.sequence = "run"
 			ninjaBoy:setSequence( "run" )
 			ninjaBoy:play()
 	   end   
   elseif ( event.phase == "ended" ) then
       if ninjaBoy.sequence ~= "idle" then
        	ninjaBoy.sequence = "idle"
        	ninjaBoy:setSequence( "idle" )
        	ninjaBoy:play()
       end
   end
   return true
end
 
local moveninjaBoy = function( event )
    if ninjaBoy.sequence == "run" then
       transition.moveBy( ninjaBoy, {
           x = 10,
           y = 0,
           time = 0
     	   } )
    end
end 

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
 
-- create()
function scene:create( event )
 
    local sceneGroup = self.view
    -- start physics
    physics.start()
    physics.setGravity(0, 32)
    physics.setDrawMode("normal")
    
    local filename = "assets/maps/level0.json"
    local mapData = json.decodeFile( system.pathForFile( filename, system.ResourceDirectory ) )
    map = tiled.new( mapData, "assets/maps" )

    sceneGroup:insert( map )
     
    local sheetOptionsIdle = require("assets.spritesheets.ninjaBoy.ninjaBoyIdle")
    local sheetIdleninjaBoy = graphics.newImageSheet( "./assets/spritesheets/ninjaBoy/ninjaBoyIdle.png", sheetOptionsIdle:getSheet() )

    local sheetOptionsRun = require("assets.spritesheets.ninjaBoy.ninjaBoyRun")
    local sheetRunningninjaBoy = graphics.newImageSheet( "./assets/spritesheets/ninjaBoy/ninjaBoyRun.png", sheetOptionsRun:getSheet() )

    local sequence_data = {

        {
            name = "idle",
            start = 1,
            count = 10,
            time = 800,
            loopCount = 0,
            sheet = sheetIdleninjaBoy
        },
        {
            name = "run",
            start = 1,
            count = 10,
            time = 1000,
            loopCount = 1,
            sheet = sheetRunningninjaBoy
        },
    }
    ninjaBoy = display.newSprite( sheetIdleninjaBoy, sequence_data )
    physics.addBody( ninjaBoy, "dynamic", { density = 3, bounce = 0, friction = 1.0 } )
    ninjaBoy.isFixedRotation = true
    ninjaBoy.x = display.contentWidth * .5
    ninjaBoy.y = 0
    ninjaBoy:setSequence( "idle" )
    ninjaBoy.sequence = "idle"
    ninjaBoy:play()
    
    rightArrow = display.newImage( "./assets/sprites/rightButton.png")
    rightArrow.x = 260
    rightArrow.y = display.contentHeight - 200
    rightArrow.id = "right arrow"
    rightArrow.Alpha = 0.5
    sceneGroup:insert( map )
    sceneGroup:insert( ninjaBoy )
    sceneGroup:insert( rightArrow )

    end

-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
    
    if ( phase == "will" ) then
    	
    	rightArrow:addEventListener( "touch", onRightArrowTouch )
 
    elseif ( phase == "did" ) then
    	Runtime:addEventListener( "enterFrame", moveninjaBoy )
    end
end
 
 
-- hide()
function scene:hide( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)

 
    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen
        rightArrow:removeEventListener( "touch", onRightArrowTouch )
        Runtime:removeEventListener( "enterFrame", moveninjaBoy )
    end
end
 
 
-- destroy()
function scene:destroy( event )
 
    local sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view
 
end
 
 
-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------
 
return scene