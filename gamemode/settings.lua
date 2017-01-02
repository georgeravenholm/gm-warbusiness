// Settings menu
local settings = settings or {}
function openSettings()
     // Sgit
     settings = vgui.Create("DFrame")
     settings:SetSize(500,500)
     settings:Center()
     settings:SetDraggable(true)
     settings:SetTitle("Settings")
     settings.Paint = function(self,w,h)
          draw.RoundedBox(0,0,0,w,h,Color(50,50,50,240))
          draw.RoundedBox(0,0,0,w,25,Color(25,25,25,240))
     end
     settings:MakePopup()

     // scroll bar
     local scroll = vgui.Create("DScrollPanel",settings)
     --scroll:SetPos( 0 , 25 )
     --scroll:SetSize( settings:GetWide() , settings:GetTall()-25 )
     scroll:Dock(FILL)

     // Create a list layout for the different options panels
     local list = vgui.Create("DListLayout",scroll)
     list:Dock(FILL)

     // music settings
     local music = vgui.Create("DPanel",list)
          music:SetSize(list:GetWide(),50)
          music:SetPaintBackground(false)

          local musictitle = vgui.Create("DLabel",music)
          musictitle:SetFont("DermaLarge")
          musictitle:SetText("Music:")
          musictitle:SetWidth(100)

          local musicenable = vgui.Create( "DCheckBoxLabel",music ) // Create the checkbox
          musicenable:SetPos( 25, 25 )						// Set the position
          musicenable:SetText( "Disable | wb_cl_disablemusic" )					// Set the text next to the box
          musicenable:SetConVar( "wb_cl_disablemusic" )			 // Change a ConVar when the box it ticked/unticked
          musicenable:SetValue( GetConVar("wb_cl_disablemusic"):GetInt() )			 // Initial value ( will determine whether the box is ticked too )
          musicenable:SizeToContents()


     list:Add(music)

     local hitsound = vgui.Create("DPanel",list)
          hitsound:SetSize(list:GetWide(),200)
          hitsound:SetPaintBackground(false)

          local hstitle = vgui.Create("DLabel",hitsound)
          hstitle:SetFont("DermaLarge")
          hstitle:SetText("Hitsounds:")
          hstitle:SetWidth(200)

          local hsrate = vgui.Create( "DNumSlider", hitsound )
          hsrate:SetPos( 25, 25 )
          hsrate:SetSize(400,15)
          hsrate:SetText( "HitsoundRate (def .5)" )	// Set the text above the slider
          hsrate:SetMin( 0.1 )				// Set the minimum number you can slide to
          hsrate:SetMax( 1 )				// Set the maximum number you can slide to
          hsrate:SetDecimals( 2 )			// Decimal places - zero for whole number
          hsrate:SetValue( GetConVar("wb_hitsoundrate"):GetInt() )
          hsrate:SetConVar( "wb_hitsoundrate" ) // Changes the ConVar when you slide



     list:Add(hitsound)
end
concommand.Add("wb_options",openSettings)
