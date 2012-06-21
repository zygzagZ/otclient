Shaders = {}

local HOTKEY = 'Ctrl+X'
local MAP_SHADERS = {
  { name = 'Default', frag = 'shaders/default.frag' },
  { name = 'Bloom', frag = 'shaders/bloom.frag'},
  { name = 'Sepia', frag ='shaders/sepia.frag' },
  { name = 'Grayscale', frag ='shaders/grayscale.frag' },
  { name = 'Pulse', frag = 'shaders/pulse.frag' },
  { name = 'Old Tv', frag = 'shaders/oldtv.frag' },
  { name = 'Fog', frag = 'shaders/fog.frag', tex1 = 'images/clouds.png' },
  { name = 'Party', frag = 'shaders/party.frag' },
  { name = 'Radial Blur', frag ='shaders/radialblur.frag' },
  { name = 'Zomg', frag ='shaders/zomg.frag' },
  { name = 'Heat', frag ='shaders/heat.frag' },
  { name = 'Noise', frag ='shaders/noise.frag' },
}

local ITEM_SHADERS = {
  { name = 'Fake 3D', vert = 'shaders/fake3d.vert' }
}

local shadersPanel

function Shaders.init()
  importStyle 'shaders.otui'

  Keyboard.bindKeyDown(HOTKEY, Shaders.toggle)

  shadersPanel = createWidget('ShadersPanel', GameInterface.getMapPanel())
  shadersPanel:hide()

  local mapComboBox = shadersPanel:getChildById('mapComboBox')
  mapComboBox.onOptionChange = function(combobox, option)
    local map = GameInterface.getMapPanel()
    map:setMapShader(g_shaders.getShader(option))
  end

  if not g_graphics.canUseShaders() then return end

  for _i,opts in pairs(MAP_SHADERS) do
    local shader = g_shaders.createFragmentShader(opts.name, opts.frag)

    if opts.tex1 then
      shader:addMultiTexture(opts.tex1)
    end
    if opts.tex2 then
      shader:addMultiTexture(opts.tex2)
    end

    mapComboBox:addOption(opts.name)
  end

  local map = GameInterface.getMapPanel()
  map:setMapShader(g_shaders.getShader('Default'))
end

function Shaders.terminate()
  Keyboard.unbindKeyDown(HOTKEY)
  shadersPanel:destroy()
  shadersPanel = nil
end

function Shaders.toggle()
  shadersPanel:setVisible(not shadersPanel:isVisible())
end