prevFrameSize = {}
allScreens = {'Built-in Retina Display', 'S27R35x', 'DELL P2422H'}

function getScreenIdx(name)
  for i = 1, #allScreens do
    if(allScreens[i] == name) then
      return i
    end
  end
end

function getScreen(name)
  local screens = hs.screen.allScreens()
  for i = 1, #screens do
    if(screens[i]:name() == name) then
      return screens[i]
    end
  end

end

function moveWindow(direction)
  return function() 
    local win = hs.window.focusedWindow()
    local moveUnit = 80

    if(win) then
      local frame = win:frame()

      if(direction == 'left') then
          frame.x = frame.x - moveUnit
      elseif(direction == 'right') then
          frame.x = frame.x + moveUnit
      elseif(direction == 'up') then
          frame.y = frame.y - moveUnit
      elseif(direction == 'down') then
          frame.y = frame.y + moveUnit
      end
      win:setFrame(frame);
    end

  end
end

function moveToDisplay(direction)
    return function()
        local win = hs.window.focusedWindow()
        local curIdx = getScreenIdx(win:screen():name())
        local nextIdx = (direction == 'left') and curIdx - 1 or curIdx + 1
        local nextScreen = nil

        if(direction == 'left') then
          nextScreen = (nextIdx < 1) and getScreen(allScreens[#allScreens]) or getScreen(allScreens[nextIdx])
        else
          nextScreen = (nextIdx > #allScreens) and getScreen(allScreens[1]) or getScreen(allScreens[nextIdx])
        end

        win:moveToScreen(nextScreen, false, true)
    end
end

function adjustWindowSize(action)
  local win = hs.window.focusedWindow()
  local sizeUnit = 50

  if(win) then
    local frame = win:frame()

    if(action == '+') then
      frame.w = frame.w + sizeUnit 
      frame.h = frame.h + sizeUnit 
    else 
      frame.w = frame.w - sizeUnit 
      frame.h = frame.h - sizeUnit 
    end

    win:setFrame(frame)
  end

end

function increaseWindowSize()
  adjustWindowSize('+')
end

function decreaseWindowSize()
  adjustWindowSize('-')
end

function maximizeWindow()
  local win = hs.window.focusedWindow()
  local winFrame = win:frame()
  
  prevFrameSize[win:id()] = hs.geometry.copy(winFrame)

  if(win) then
    hs.grid.maximizeWindow(win)
  end

end


function minimizeWindow()
  local win = hs.window.focusedWindow()
  local winFrame = win:frame()
  
  if(win) then
    win:setFrame(prevFrameSize[win:id()])
    prevFrameSize[win:id()] = nil
  end

end


hs.hotkey.bind({'cmd', 'shift', 'alt'}, 'l', moveToDisplay('right'))
hs.hotkey.bind({'cmd', 'shift', 'alt'}, 'h', moveToDisplay('left'))
hs.hotkey.bind({'cmd', 'ctrl', 'alt'}, 'h', moveWindow('left'), nil, moveWindow('left'))
hs.hotkey.bind({'cmd', 'ctrl', 'alt'}, 'l', moveWindow('right'), nil, moveWindow('right'))
hs.hotkey.bind({'cmd', 'ctrl', 'alt'}, 'j', moveWindow('down'), nil, moveWindow('down'))
hs.hotkey.bind({'cmd', 'ctrl', 'alt'}, 'k', moveWindow('up'), nil, moveWindow('up'))
hs.hotkey.bind({'cmd', 'ctrl', 'alt'}, ']', increaseWindowSize)
hs.hotkey.bind({'cmd', 'ctrl', 'alt'}, '[', decreaseWindowSize)
hs.hotkey.bind({'cmd', 'ctrl'}, 'm', maximizeWindow)
hs.hotkey.bind({'cmd', 'ctrl', 'shift'}, 'm', minimizeWindow)
