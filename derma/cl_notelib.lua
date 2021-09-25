local PLUGIN = PLUGIN

local PANEL = {}
function PANEL:Init()
	self:SetSize(600, 700)
	self:MakePopup()
	self:Center()
	self:SetDraggable(false)
	self:ShowCloseButton(false)

	if ix.gui.menu and IsValid(ix.gui.menu) then
		ix.gui.menu:Remove()
	end

	local titlepanel_bg = self:Add("DPanel")
	titlepanel_bg:Dock(TOP)
	titlepanel_bg.Paint = function(_, w, h)
		surface.SetDrawColor(255, 255, 255)
		surface.DrawRect(0, 0, w, h)
	end

	self.titlepanel = titlepanel_bg:Add("DTextEntry")
	self.titlepanel:SetEditable(false)
	self.titlepanel:SetDrawBackground(false)
	self.titlepanel:SetFont("ixNoteLibFont")
	self.titlepanel:SetTextColor(Color(0, 0, 0, 255))
	self.titlepanel:Dock(FILL)
	self.titlepanel:SetTall(25)
	self.titlepanel:SetDisabled(true)

	local textpanel_bg = self:Add("DPanel")
	textpanel_bg:DockMargin(0, 3, 0, 0)
	textpanel_bg:Dock(FILL)
	textpanel_bg.Paint = function(_, w, h)
		surface.SetDrawColor(255, 255, 255)
		surface.DrawRect(0, 0, w, h)
	end

	self.textpanel = textpanel_bg:Add("DTextEntry")
	self.textpanel:SetDrawBackground(false)
	self.textpanel:SetVerticalScrollbarEnabled(true)
	self.textpanel:SetFont("ixNoteLibFontMin")
	self.textpanel:SetTextColor(Color(0, 0, 0))
	self.textpanel:SetMultiline(true)
	self.textpanel:Dock(FILL)
	self.textpanel:SetDisabled(true)

	local bottom_panel = self:Add("DPanel")
	bottom_panel:Dock(BOTTOM)

	self.next_page = bottom_panel:Add("DButton")
	self.next_page:SetText("Next page")
	self.next_page:SizeToContents()
	self.next_page:SetDisabled(true)
	self.next_page:Dock(RIGHT)
	self.next_page.DoClick = function()
		self:ChangePage(self.data.page + 1)
	end

	self.back_page = bottom_panel:Add("DButton")
	self.back_page:DockMargin(0, 0, 5, 0)
	self.back_page:SetText("Previous page")
	self.back_page:SizeToContents()
	self.back_page:Dock(RIGHT)
	self.back_page.DoClick = function()
		self:ChangePage(self.data.page - 1)
	end

	local close_button = bottom_panel:Add("DButton")
	close_button:SetText("Close")
	close_button:SizeToContents()
	close_button:Dock(LEFT)
	close_button.DoClick = function()
		self:Remove()
	end

	self.edit_button = bottom_panel:Add("DButton")
	self.edit_button:DockMargin(5, 0, 0, 0)
	self.edit_button:SetText("Change notebook")
	self.edit_button:SizeToContents()
	self.edit_button:Dock(LEFT)
	self.edit_button:SetDisabled(true)
	self.edit_button.DoClick = function()
		self:Remove()
		netstream.Start("EditNoteLib", self.data.itemid)
	end
end

function PANEL:SetInfo(data)
	if not data then return end

	self.data = data

	local clientIsOwner = data.editors[LocalPlayer():SteamID()]
	if clientIsOwner then
		self.edit_button:SetDisabled(false)
	end

	self:ChangePage(data.page)
end

function PANEL:ChangePage(data)
	if not data then return end

	self.data.page = data

	self:SetTitle("[Page №" .. self.data.page .. "] " .. self.data.title)

	if self.data.maxpage > self.data.page then
		self.next_page:SetDisabled(false)
	else
		self.next_page:SetDisabled(true)
	end

	if self.data.page > 1 then
		self.back_page:SetDisabled(false)
	else
		self.back_page:SetDisabled(true)
	end

	self.titlepanel:SetValue(self.data.pages[self.data.page].title)
	self.textpanel:SetValue(self.data.pages[self.data.page].name)
end

vgui.Register("NoteLibOpen", PANEL, "DFrame")




local PANEL = {}
function PANEL:Init()
	self:SetSize(600 + 200, 700)
	self:MakePopup()
	self:SetDraggable(false)
	self:ShowCloseButton(false)
	self:Center()

	if ix.gui.menu and IsValid(ix.gui.menu) then
		ix.gui.menu:Remove()
	end

	local fill_panel = self:Add("DPanel")
	fill_panel:Dock(FILL)

	local text_panel = fill_panel:Add("DPanel")
	text_panel:Dock(FILL)

	local titlepanel_bg = text_panel:Add("DPanel")
	titlepanel_bg:Dock(TOP)
	titlepanel_bg.Paint = function(_, w, h)
		surface.SetDrawColor(255, 255, 255)
		surface.DrawRect(0, 0, w, h)
	end

	self.titlepanel = titlepanel_bg:Add("DTextEntry")
	self.titlepanel:SetDrawBackground(false)
	self.titlepanel:SetFont("ixNoteLibFont")
	self.titlepanel:SetTextColor(Color(0, 0, 0, 255))
	self.titlepanel:Dock(FILL)
	self.titlepanel:SetTall(25)
	self.titlepanel:SetEditable(true)
	self.titlepanel:SetDisabled(false)

	local textpanel_bg = text_panel:Add("DPanel")
	textpanel_bg:DockMargin(0, 3, 0, 0)
	textpanel_bg:Dock(FILL)
	textpanel_bg.Paint = function(_, w, h)
		surface.SetDrawColor(255, 255, 255)
		surface.DrawRect(0, 0, w, h)
	end

	self.textpanel = textpanel_bg:Add("DTextEntry")
	self.textpanel:SetDrawBackground(false)
	self.textpanel:SetVerticalScrollbarEnabled(true)
	self.textpanel:SetFont("ixNoteLibFontMin")
	self.textpanel:SetTextColor(Color(0, 0, 0))
	self.textpanel:SetMultiline(true)
	self.textpanel:Dock(FILL)
	self.textpanel:SetEditable(true)
	self.textpanel:SetDisabled(false)

	local edit_menu = fill_panel:Add("DPanel")
	edit_menu:Dock(RIGHT)
	edit_menu:SetWide(200)

	local change_notepadtitle = edit_menu:Add("DButton")
	change_notepadtitle:SetText("Change title of the notebook")
	change_notepadtitle:SetContentAlignment(4)
	change_notepadtitle:DockMargin(5, 5, 5, 5)
	change_notepadtitle:Dock(TOP)
	change_notepadtitle.DoClick = function()
		Derma_StringRequest("Change title of the notebook", "Write the title of the notebook that will be visible when you hover over the item!", "", function(text)
			if utf8.len(text) <= 20 then
				netstream.Start("ChangeNoteLibName", self.data.itemid, text)
			else
				LocalPlayer():Notify("Notepad name is longer than 20 characters!")
			end
		end, nil, "Edit", "Close menu")
	end

	local change_notepaddescription = edit_menu:Add("DButton")
	change_notepaddescription:SetText("Change notepad description")
	change_notepaddescription:SetContentAlignment(4)
	change_notepaddescription:DockMargin(5, 0, 5, 5)
	change_notepaddescription:Dock(TOP)
	change_notepaddescription.DoClick = function()
		Derma_StringRequest("Change notepad description", "Write a description of the notebook that will be visible when you hover over the item!", "", function(text)
			if utf8.len(text) <= 64 then
				netstream.Start("ChangeNoteLibDescription", self.data.itemid, text)
			else
				LocalPlayer():Notify("Notepad description is longer than 64 characters!")
			end
		end, nil, "Edit", "Close menu")
	end

	self.change_editors = edit_menu:Add("DPanelList")
	self.change_editors:EnableVerticalScrollbar()
	self.change_editors:DockMargin(5, 0, 5, 5)
	self.change_editors:Dock(FILL)

	local change_logger = edit_menu:Add("DPanel")
	change_logger:DockMargin(5, 0, 5, 5)
	change_logger:Dock(BOTTOM)
	change_logger:SetTall(60)
	change_logger.Paint = function(_, w, h)
		draw.DrawText("Number of owners: " .. table.Count(self.data.editors) .. "/" .. PLUGIN.maxeditors, "DermaDefault", 0, h-60, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT)
		draw.DrawText("Number of pages: " .. self.data.maxpage .. "/" .. PLUGIN.maxpages, "DermaDefault", 0, h-45, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT)
		draw.DrawText("Title size: " .. utf8.len(self.titlepanel:GetValue()) .."/" .. PLUGIN.maxchar_title, "DermaDefault", 0, h-30, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT)
		draw.DrawText("Text size: " .. utf8.len(self.textpanel:GetValue()) .. "/" .. PLUGIN.maxchar_text, "DermaDefault", 0, h-15, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT)
	end

	local change_takeitem = edit_menu:Add("DButton")
	change_takeitem:SetText("Allow/Deny to take")
	change_takeitem:SetContentAlignment(4)
	change_takeitem:DockMargin(5, 0, 5, 5)
	change_takeitem:Dock(BOTTOM)
	change_takeitem.DoClick = function()
		netstream.Start("ChangeNoteLibTake", self.data.itemid)
	end

	local change_removepage = edit_menu:Add("DButton")
	change_removepage:SetText("Delete last page")
	change_removepage:SetContentAlignment(4)
	change_removepage:DockMargin(5, 0, 5, 5)
	change_removepage:Dock(BOTTOM)
	change_removepage.DoClick = function()
		if self.data.maxpage > 1 then
			self.data.pages[#self.data.pages] = nil

			self.data.maxpage = self.data.maxpage - 1

			if self.data.maxpage > self.data.page then
				self.next_page:SetDisabled(false)
			else
				self.next_page:SetDisabled(true)
			end

			if self.data.page > 1 then
				self.back_page:SetDisabled(false)
			else
				self.back_page:SetDisabled(true)
			end

			if self.data.page >= self.data.maxpage + 1 then
				self:ChangePage(self.data.maxpage)
			end

			LocalPlayer():Notify("You have successfully deleted the last page.")
		else
			LocalPlayer():Notify("You cannot delete the last page!")
		end
	end

	local change_addpage = edit_menu:Add("DButton")
	change_addpage:SetText("Add new page")
	change_addpage:SetContentAlignment(4)
	change_addpage:DockMargin(5, 0, 5, 5)
	change_addpage:Dock(BOTTOM)
	change_addpage.DoClick = function()
		if PLUGIN.maxpages > self.data.maxpage then
			self.data.pages[#self.data.pages + 1] = {
				title = "",
				name = ""
			}

			self.data.maxpage = self.data.maxpage + 1

			if self.data.maxpage > self.data.page then
				self.next_page:SetDisabled(false)
			else
				self.next_page:SetDisabled(true)
			end

			if self.data.page > 1 then
				self.back_page:SetDisabled(false)
			else
				self.back_page:SetDisabled(true)
			end

			LocalPlayer():Notify("You have successfully added a new page.")
		else
			LocalPlayer():Notify("You have exceeded the maximum number of pages (" .. PLUGIN.maxpages .. ")!")
		end
	end

	local change_addeditor = edit_menu:Add("DButton")
	change_addeditor:SetText("Add new editor")
	change_addeditor:SetContentAlignment(4)
	change_addeditor:DockMargin(5, 0, 5, 5)
	change_addeditor:Dock(BOTTOM)
	change_addeditor.DoClick = function()
		Derma_StringRequest("Add new Editor", "Write the SteamID of the person you want to add to the notebook owners!", "", function(text)
			if not text then return end

			if string.find(text, "STEAM_") then
				self.data.editors[text] = true

				local editors_button = self.change_editors:Add("DCheckBoxLabel")
				editors_button:Dock(TOP)
				editors_button.steamid = text
				editors_button:SetText(editors_button.steamid)
				editors_button:SetValue(true)
				editors_button.OnChange = function(panel, value)
					if not value then
						if LocalPlayer():SteamID() == panel.steamid then
							panel:SetValue(true)
							self.data.editors[panel.steamid] = true
							LocalPlayer():Notify("You cannot remove yourself from the Editors!")
						else
							self.data.editors[panel:GetText()] = nil
							panel:Remove()
						end
					else
						self.data.editors[panel:GetText()] = true
					end
				end

				self.change_editors:AddItem(editors_button)
			else
				LocalPlayer():Notify("Не валидный SteamID!")
			end
		end, nil, "Add", "Close menu")
	end

	local bottom_panel = text_panel:Add("DPanel")
	bottom_panel:Dock(BOTTOM)

	self.next_page = bottom_panel:Add("DButton")
	self.next_page:SetText("Next page")
	self.next_page:SizeToContents()
	self.next_page:SetDisabled(true)
	self.next_page:Dock(RIGHT)
	self.next_page.DoClick = function()
		self:ChangePage(self.data.page + 1)
	end

	self.back_page = bottom_panel:Add("DButton")
	self.back_page:DockMargin(0, 0, 5, 0)
	self.back_page:SetText("Previous page")
	self.back_page:SizeToContents()
	self.back_page:Dock(RIGHT)
	self.back_page.DoClick = function()
		self:ChangePage(self.data.page - 1)
	end

	local close_button = bottom_panel:Add("DButton")
	close_button:SetText("Close")
	close_button:SizeToContents()
	close_button:Dock(LEFT)
	close_button.DoClick = function()
		self:Remove()
	end

	self.read_button = bottom_panel:Add("DButton")
	self.read_button:DockMargin(5, 0, 0, 0)
	self.read_button:SetText("Close editor menu")
	self.read_button:SizeToContents()
	self.read_button:Dock(LEFT)
	self.read_button.DoClick = function()
		self:Remove()
		netstream.Start("OpenNoteLib", self.data.itemid)
	end

	local save_button = bottom_panel:Add("DButton")
	save_button:DockMargin(5, 0, 0, 0)
	save_button:SetText("Save changes")
	save_button:SizeToContents()
	save_button:Dock(LEFT)
	save_button.DoClick = function()
		local title_text = self.titlepanel:GetValue()
		local text_text = self.textpanel:GetValue()

		if utf8.len(title_text) > PLUGIN.maxchar_title then
			LocalPlayer():Notify("Title has more characters than available! (" .. PLUGIN.maxchar_title .. ")!")

			goto retrieval
		end

		if utf8.len(text_text) > PLUGIN.maxchar_text then
			LocalPlayer():Notify("Text has more characters than available! (" .. PLUGIN.maxchar_text .. ")!")

			goto retrieval
		end

		self.data.pages[self.data.page].title = title_text
		self.data.pages[self.data.page].name = text_text

		netstream.Start("SaveNoteLib", self.data.itemid, self.data)

		::retrieval::
	end
end

function PANEL:SetInfo(data)
	if not data then return end

	self.data = data
	self.read_button:SetDisabled(false)
	self:ChangePage(data.page)

	for k, v in pairs(self.data.editors) do
		local editors_button = self.change_editors:Add("DCheckBoxLabel")
		editors_button:Dock(TOP)
		editors_button.steamid = k
		editors_button:SetText(editors_button.steamid)
		editors_button:SetValue(v)
		editors_button.OnChange = function(panel, value)
			if not value then
				if LocalPlayer():SteamID() == panel.steamid then
					panel:SetValue(true)
					self.data.editors[panel.steamid] = true
					LocalPlayer():Notify("You cannot remove yourself from the Editors!")
				else
					self.data.editors[panel:GetText()] = nil
					panel:Remove()
				end
			else
				self.data.editors[panel:GetText()] = true
			end
		end

		self.change_editors:AddItem(editors_button)
	end
end

function PANEL:ChangePage(data)
	if not data then return end

	self.data.page = data

	self:SetTitle("[Page №" .. self.data.page .. "] " .. self.data.title)

	if self.data.maxpage > self.data.page then
		self.next_page:SetDisabled(false)
	else
		self.next_page:SetDisabled(true)
	end

	if self.data.page > 1 then
		self.back_page:SetDisabled(false)
	else
		self.back_page:SetDisabled(true)
	end

	self.titlepanel:SetValue(self.data.pages[self.data.page].title)
	self.textpanel:SetValue(self.data.pages[self.data.page].name)
end

vgui.Register("NoteLibEdit", PANEL, "DFrame")

-- SetSizeallPade1 = 500
-- SetSizeallPade2 = 650

-- local PANEL = {}

-- function PANEL:Init()
	-- self:SetSize(350, 100)	
	-- self:MakePopup()
	-- self:Center()
	-- self:SetTitle("Изменить максимальное количество страниц")

-- 	self.controls = self:Add("DPanel")
-- 	self.controls:Dock(BOTTOM)
-- 	self.controls:SetTall(30)
-- 	self.controls:DockMargin(0, 5, 0, 0)

-- 	self.contents = self:Add("DTextEntry")
-- 	self.contents:SetValue("1")
-- 	self.contents:Dock(FILL)
-- 	self.contents:SetMultiline(true)
-- 	self.contents:SetEditable(true)

-- 	self.test = self.controls:Add("DTextEntry")
	-- self.test:SetMultiline(true)
	-- self.test:SetSize(0,0)
	-- self.test:SetEditable(false)

-- 	self.confirm = self.controls:Add("DButton")
-- 	self.confirm:Dock(RIGHT)
-- 	self.confirm:SetSize( 80, 30)
-- 	self.confirm:SetDisabled(false)
-- 	self.confirm:SetText(L("Изменить"))

-- 	self.confirm.DoClick = function(this)
-- 		local text = self.contents:GetValue()
-- 		text = tonumber(text)
-- 		netstream.Start("library_max_page", library_this_id, text)
-- 		self:Close()
-- 		library_this_notepad:Close()
-- 	end

-- 	self.controls.Paint = function(this, w, h)
-- 		local text = self.contents:GetValue()
-- 		draw.SimpleText(Format("Можно установить не больше 20 страниц!", string.len(text)), "DermaDefault", 10, h/2, color_white, TEXT_ALIGN_LEFT, 1)
-- 	end
-- end

-- vgui.Register("library_max_page", PANEL, "DFrame")

-- local PANEL = {}

-- function PANEL:Init()
-- 	self:SetSize(350, 100)	
-- 	self:MakePopup()
-- 	self:Center()
-- 	self:SetTitle("Изменение названия")

-- 	self.controls = self:Add("DPanel")
-- 	self.controls:Dock(BOTTOM)
-- 	self.controls:SetTall(30)
-- 	self.controls:DockMargin(0, 5, 0, 0)

-- 	self.contents = self:Add("DTextEntry")
-- 	self.contents:Dock(FILL)
-- 	self.contents:SetMultiline(true)
-- 	self.contents:SetEditable(true)

-- 	self.test = self.controls:Add("DTextEntry")
-- 	self.test:SetMultiline(true)
-- 	self.test:SetSize(0,0)
-- 	self.test:SetEditable(false)

-- 	self.confirm = self.controls:Add("DButton")
-- 	self.confirm:Dock(RIGHT)
-- 	self.confirm:SetSize( 150, 30)
-- 	self.confirm:SetDisabled(false)
-- 	self.confirm:SetText(L("Сохранить"))

-- 	self.confirm.DoClick = function(this)
-- 		local text = self.contents:GetValue()
-- 		netstream.Start("library_save_name", library_this_id, text)
-- 		self:Close()
-- 		library_this_notepad:Close()
-- 	end

-- 	self.controls.Paint = function(this, w, h)
-- 		local text = self.contents:GetValue()
-- 		draw.SimpleText(Format("Вы написали: %s/50", string.len(text)), "DermaDefault", 10, h/2, color_white, TEXT_ALIGN_LEFT, 1)
-- 	end
-- end

-- vgui.Register("library_name", PANEL, "DFrame")

-- local PANEL = {}

-- function PANEL:Init()
-- 	self:SetSize(SetSizeallPade1, SetSizeallPade2)	
-- 	self:MakePopup()
-- 	self:Center()
-- 	library_this_notepad = self

-- 	self.controls = self:Add("DPanel")
-- 	self.controls:Dock(BOTTOM)
-- 	self.controls:SetTall(30)
-- 	self.controls:DockMargin(0, 5, 0, 0)

-- 	self.contents = self:Add("DTextEntry")
-- 	self.contents:Dock(FILL)
-- 	self.contents:SetMultiline(true)
-- 	self.contents:SetEditable(true)
-- 	self.contents:SetPaintBackground(false)

-- 	self.Paint = function(this, w, h)
-- 		surface.SetDrawColor( 240, 240, 240, 255 ) 
-- 		surface.SetMaterial( Material( "materials/2.png" ) )
-- 		surface.DrawTexturedRect( 0, 0, w, h ) 

-- 		surface.SetDrawColor( 155, 20, 121, 255 )
-- 		surface.DrawRect(0, 0, w, 25) -- вверх
-- 		surface.DrawRect(0, 0, 1, h) -- лево
-- 		surface.DrawRect(0, h-1, w, h) -- внизу
-- 		surface.DrawRect(w-1, 0, w, h) -- право

-- 		surface.SetDrawColor( 0, 0, 0, 200 )
-- 		surface.DrawRect(1, h-40, w-2, h-2)

-- 		surface.SetDrawColor( Color( 0, 0, 0, 255 ) )
-- 		surface.DrawOutlinedRect( 1, h-40, w-2, h-2 )
-- 	end

-- 	self.test = self.controls:Add("DTextEntry")
-- 	self.test:SetMultiline(true)
-- 	self.test:SetSize(0,0)
-- 	self.test:SetEditable(false)

-- 	self.confirm = self.controls:Add("DButton")
-- 	self.confirm:Dock(RIGHT)
-- 	self.confirm:SetSize( 100, 30)
-- 	self.confirm:SetDisabled(false)
-- 	self.confirm:SetText(L("Сохранить"))

-- 	self.confirm.DoClick = function(this)
-- 		local text = self.contents:GetValue()
-- 		netstream.Start("library_save_text", library_this_id, text, library_this_page)
-- 	end

-- 	self.confirm2 = self.controls:Add("DButton")
-- 	self.confirm2:Dock(RIGHT)
-- 	self.confirm2:SetSize( 100, 30 )
-- 	self.confirm2:SetDisabled(false)
-- 	self.confirm2:SetText(L("Закрыть"))

-- 	self.confirm2.DoClick = function(this)
-- 		self:Close()
-- 	end

-- 	self.controls.Paint = function(this, w, h)
-- 		local text = self.contents:GetValue()
-- 		draw.SimpleText(Format("Вы написали: %s/10000", string.len(text)), "DermaDefault", 10, h/2, color_white, TEXT_ALIGN_LEFT, 1)
-- 	end
-- end

-- function PANEL:GetAllInfo(id, text, page, namenotepad, max_page)
-- 	library_this_id = id
-- 	library_this_page = page
-- 	library_this_namenotepad = namenotepad
-- 	library_this_maxpage = max_page
-- 	self.contents:SetValue(text or "")
-- 	if page < library_this_maxpage then
-- 		self.page_right = self.controls:Add("DButton")
-- 		self.page_right:Dock(RIGHT)
-- 		self.page_right:SetSize( 30, 30 )
-- 		self.page_right:SetDisabled(false)
-- 		self.page_right:SetText(L("-->"))

-- 		self.page_right.DoClick = function(this)
-- 			netstream.Start("library_changepage", library_this_id, library_this_page + 1, library_this_namenotepad, "EDIT", library_this_maxpage)
-- 			self:Close()
-- 		end
-- 	end

-- 	if page >= 2 then
-- 		self.page_left = self.controls:Add("DButton")
-- 		self.page_left:Dock(RIGHT)
-- 		self.page_left:SetSize( 30, 30 )
-- 		self.page_left:SetDisabled(false)
-- 		self.page_left:SetText(L("<--"))

-- 		self.page_left.DoClick = function(this)
-- 			netstream.Start("library_changepage", library_this_id, library_this_page - 1, library_this_namenotepad, "EDIT", library_this_maxpage)
-- 			self:Close()
-- 		end
-- 	end

-- 	if page == 1 then
-- 		self.name_change = self.controls:Add("DButton")
-- 		self.name_change:Dock(RIGHT)
-- 		self.name_change:SetSize(60, 30 )
-- 		self.name_change:SetDisabled(false)
-- 		self.name_change:SetText(L("Название"))

-- 		self.name_change.DoClick = function(this)
-- 			vgui.Create("library_name")
-- 		end

-- 		self.max_page = self.controls:Add("DButton")
-- 		self.max_page:Dock(RIGHT)
-- 		self.max_page:SetSize(30, 30 )
-- 		self.max_page:SetDisabled(false)
-- 		self.max_page:SetText(L("Стр"))

-- 		self.max_page.DoClick = function(this)
-- 			vgui.Create("library_max_page")
-- 		end
-- 	end
-- end

-- vgui.Register("library_edit", PANEL, "DFrame")

-- local PANEL = {}

-- function PANEL:Init()
-- 	self:SetSize(SetSizeallPade1, SetSizeallPade2)	
-- 	self:MakePopup()
-- 	self:Center()
-- 	self:SetTitle("[Page 1] Блокнот")

-- 	self.controls = self:Add("DPanel")
-- 	self.controls:Dock(BOTTOM)
-- 	self.controls:SetTall(30)
-- 	self.controls:DockMargin(0, 5, 0, 0)

-- 	self.Paint = function(this, w, h)
-- 		surface.SetDrawColor( 240, 240, 240, 255 ) 
-- 		surface.SetMaterial( Material( "materials/2.png" ) )
-- 		surface.DrawTexturedRect( 0, 0, w, h ) 

-- 		surface.SetDrawColor( 155, 20, 121, 255 )
-- 		surface.DrawRect(0, 0, w, 25) -- вверх
-- 		surface.DrawRect(0, 0, 1, h) -- лево
-- 		surface.DrawRect(0, h-1, w, h) -- внизу
-- 		surface.DrawRect(w-1, 0, w, h) -- право

-- 		surface.SetDrawColor( 0, 0, 0, 200 )
-- 		surface.DrawRect(1, h-40, w-2, h-2)

-- 		surface.SetDrawColor( Color( 0, 0, 0, 255 ) )
-- 		surface.DrawOutlinedRect( 1, h-40, w-2, h-2 )
-- 	end

-- 	self.label = self:Add("DTextEntry");
-- 	self.label:SetMultiline(true);
-- 	self.label:SetValue("");
-- 	self.label:SetSize(SetSizeallPade1, SetSizeallPade2-50);
-- 	self.label:Dock(FILL)
-- 	self.label:SetDisabled(true);
-- 	self.label:SetDrawBorder(false);
-- 	self.label:SetDrawBackground(false);
-- 	self.label:SetVerticalScrollbarEnabled(true);

-- 	self.test = self.controls:Add("DTextEntry")
-- 	self.test:SetMultiline(true)
-- 	self.test:SetSize(0,0)
-- 	self.test:SetEditable(false)
-- end

-- function PANEL:GetAllInfo(id, text, page, namenotepad, max_page)
-- 	library_this_id = id
-- 	library_this_page = page
-- 	library_this_namenotepad = namenotepad
-- 	library_this_maxpage = max_page
-- 	self.label:SetValue(text or "")
-- 	if page < library_this_maxpage then
-- 		self.page_right = self.controls:Add("DButton")
-- 		self.page_right:Dock(RIGHT)
-- 		self.page_right:SetSize( 200, 30 )
-- 		self.page_right:SetDisabled(false)
-- 		self.page_right:SetText("Следующая Page")

-- 		self.page_right.DoClick = function(this)
-- 			netstream.Start("library_changepage", library_this_id, library_this_page + 1, library_this_namenotepad, "WRITE", library_this_maxpage)
-- 			self:Close()
-- 		end
-- 	end

-- 	if page >= 2 then
-- 		self.page_left = self.controls:Add("DButton")
-- 		self.page_left:Dock(LEFT)
-- 		self.page_left:SetSize( 200, 30 )
-- 		self.page_left:SetDisabled(false)
-- 		self.page_left:SetText("Предыдущая Page")

-- 		self.page_left.DoClick = function(this)
-- 			netstream.Start("library_changepage", library_this_id, library_this_page - 1, library_this_namenotepad, "WRITE", library_this_maxpage)
-- 			self:Close()
-- 		end
-- 	end
-- end

-- vgui.Register("library_write", PANEL, "DFrame")