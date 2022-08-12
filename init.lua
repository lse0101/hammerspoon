function showWindowHints()
  hs.hints.style = 'vimperator'
  hs.hints.windowHints()
end

function getScreenIdx(displays, screen)
  for i = 1, #displays do
    if(displays[i] == screen) then
      return i 
    end
  end

end

function moveWindow(direction)
  return function() 
    local win = hs.window.focusedWindow()
    local moveUnit = 30

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
        local displays = hs.screen.allScreens()
        local win = hs.window.focusedWindow()
        local curIdx = getScreenIdx(displays, win:screen())
        local nextIdx = (direction == 'left') and curIdx - 1 or curIdx + 1
        local nextScreen = nil

        if(direction == 'left') then
          nextScreen = (nextIdx < 1) and displays[#displays] or displays[nextIdx]
        else
          nextScreen = (nextIdx > #displays) and displays[1] or displays[nextIdx]
        end

        win:moveToScreen(nextScreen, false, true)
    end
end

hs.hotkey.bind({'shift'}, 'F12', showWindowHints)
hs.hotkey.bind({'cmd', 'shift'}, 'r', hs.reload)
hs.hotkey.bind({'cmd', 'shift', 'alt'}, 'l', moveToDisplay('right'))
hs.hotkey.bind({'cmd', 'shift', 'alt'}, 'h', moveToDisplay('left'))
hs.hotkey.bind({'cmd', 'ctrl', 'alt'}, 'h', nil, nil, moveWindow('left'))
hs.hotkey.bind({'cmd', 'ctrl', 'alt'}, 'l', nil, nil, moveWindow('right'))
hs.hotkey.bind({'cmd', 'ctrl', 'alt'}, 'j', nil, nil, moveWindow('down'))
hs.hotkey.bind({'cmd', 'ctrl', 'alt'}, 'k', nil, nil, moveWindow('up'))