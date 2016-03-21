class 'marioPlayer'

function marioPlayer:__init(plr_obj)
    self.plr_obj = plr_obj
    if(self.plr_obj.stateID==1)then
        self.plr_obj.health = 1
    elseif(self.plr_obj.stateID>=2)then
        self.plr_obj.health = 2
    end
end

function marioPlayer:onLoop(tickTime)
    if(Settings.isDebugInfoShown())then
        Renderer.printText("It's me, Mario!", 100, 230, 0, 15, 0xFFFF0055)
        Renderer.printText("Player x: "..tostring(self.plr_obj.x), 100, 260, 0, 15, 0xFFFF0055)
        Renderer.printText("Player y: "..tostring(self.plr_obj.y), 100, 300, 0, 15, 0xFFFF0055)
    end
    if(self.plr_obj.stateID==4)then
        if(self.plr_obj:getKeyState(KEY_ALT_JUMP))then
            self.plr_obj.speedY = -6
            self.plr_obj:setAnimation(16, 128)
        end
    end
end

function marioPlayer:onHarm(harmEvent)
    processPlayerHarm(self.plr_obj, harmEvent)
end

function marioPlayer:onTakeNpc(npcObj)
    ProcessPlayerPowerUP(self.plr_obj, npcObj)
end

return marioPlayer

