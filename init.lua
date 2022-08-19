function showWindowHints()
  hs.hints.style = 'vimperator'
  hs.hints.windowHints()
end


require('aurora')
require('window-manager')

hs.hotkey.bind({'shift'}, 'F12', showWindowHints)
hs.hotkey.bind({'cmd', 'shift'}, 'r', hs.reload)
