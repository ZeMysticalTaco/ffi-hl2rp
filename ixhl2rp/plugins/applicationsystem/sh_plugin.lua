local PLUGIN = PLUGIN
PLUGIN.name = "Application System"
PLUGIN.author = "ZeMysticalTaco"
PLUGIN.description = "Adds an immersive and realistic IC application system."

ix.command.Add("ViewApplications", {
	syntax = "<none>",
	description = "DEBUG.",
	adminOnly = true,
	OnRun = function(self, client)
		local query = mysql:Select("ix_applications")

		query:Callback(function(results)
			netstream.Start(client, "SyncApplicationDataCP", {results})
		end)
		query:Execute()
	end
})

if CLIENT then
	netstream.Hook("SyncApplicationDataCP", function(data)
		local ui = vgui.Create("CPApplicationMenu")
		ui.sqldata = data[1]
	end)

	netstream.Hook("OpenApplicationMenu", function(ply)
		vgui.Create("CPApplicationIntro")
	end)

	netstream.Hook("ApplicationPlayerResponse", function(data)
		--if tobool(data[5]) then return end
		print("data 1" .. data[1])
		print("data 2" .. tostring(data[2]))
		print("data 3" .. tostring(data[3]))
		print("data 4" .. data[4])
		print("data 5" .. data[5])
		print()

		if data[2] == false and data[1] == "!true" then
			--Derma_Message("Response: " .. data[1], "Your application has received a response!", "I have read this message.")
			local frame = vgui.Create("DFrame")
			frame:SetSize(ScrW() / 4, ScrH() / 3)
			frame:Center()
			frame:MakePopup()
			frame:SetBackgroundBlur(true)
			frame:ShowCloseButton(false)
			frame.TitleText = frame:Add("DLabel")
			frame.TitleText:Dock(TOP)
			frame.TitleText:SetContentAlignment(5)
			frame.TitleText:SetFont("ixBigFont")
			frame.TitleText:SetText("A Passing Letter.")
			frame.TitleText:SizeToContents()
			frame.EventText = frame:Add("DLabel")
			frame.EventText:Dock(TOP)
			frame.EventText:SetWrap(true)
			frame.EventText:SetAutoStretchVertical(true)
			frame.EventText:SetText("It's been awhile since you submitted your application, time goes by and you wonder really, What is going to happen? Your mind races with the possibilites from the best, to the worst. As you are walking along skulking to yourself in anxiety about whether or not the results are positive, a courier from the Civil Workers' Union approaches you, he asks you, 'You're " .. data[4] .. " right? I have a letter for you, from the Union, marked priority mail, just got it in today. Good luck on whatever's inside, friend.")
			frame.EventText:SetFont("ixSmallFont")
			frame.PanelList = frame:Add("DPanelList")
			frame.PanelList:Dock(FILL)
			frame.PanelList:EnableVerticalScrollbar(true)
			--\n Before you can say a word the Courier rushes off, you stare at the letter, deciding to open it. Inside is a piece of paper, folded in standard letter stock format. It reads: 'Hello " .. data[4] .. " and thank you for applying for the Combine Civil Authority, we have reviewed your application thoroughly and have come to a conclusion. With your skills, experience and expertise, we have decided to pass you for stage 1 of the application process. The next step is a face-to-face interview with a senior officer. Please take this letter to the nearest Officer and they will escort you inside The Nexus to speak with them. \nThank you for your interest in applying. \n~Combine Civil Authority Command"
			frame.EventText2 = frame:Add("DLabel")
			frame.EventText2:Dock(TOP)
			frame.EventText2:SetWrap(true)
			frame.EventText2:SetAutoStretchVertical(true)
			frame.EventText2:SetText("\n Before you can say a word the Courier rushes off, you stare at the letter, deciding to open it. Inside is a piece of paper, folded in standard letter stock format. It reads: 'Hello " .. data[4] .. " and thank you for applying for the Combine Civil Authority, we have reviewed your application thoroughly and have come to a conclusion. With your skills, experience and expertise, we have decided to pass you for stage 1 of the application process. The next step is a face-to-face interview with a senior officer. Please take this letter to the nearest Officer and they will escort you inside The Nexus to speak with them. \nThank you for your interest in applying. \n~Combine Civil Authority Command")
			frame.EventText2:SetFont("ixSmallFont")
			frame.PanelList:AddItem(frame.EventText)
			frame.PanelList:AddItem(frame.EventText2)
			frame.AcceptButton = frame:Add("DButton")
			frame.AcceptButton:SetText("...Is this really happening?")
			frame.AcceptButton:Dock(BOTTOM)

			function frame.AcceptButton:DoClick()
				self:GetParent():Close()
				netstream.Start("ApplicationSeen", {"cp", true, data[5], data[4]})
			end
		end

		if not data[2] and data[1] ~= "!true" then
			local frame = vgui.Create("DFrame")
			frame:SetSize(ScrW() / 4, ScrH() / 3)
			frame:Center()
			frame:MakePopup()
			frame:SetBackgroundBlur(true)
			frame:ShowCloseButton(false)
			frame.TitleText = frame:Add("DLabel")
			frame.TitleText:Dock(TOP)
			frame.TitleText:SetContentAlignment(5)
			frame.TitleText:SetFont("ixBigFont")
			frame.TitleText:SetText("A Passing Letter.")
			frame.TitleText:SizeToContents()
			frame.EventText = frame:Add("DLabel")
			frame.EventText:Dock(TOP)
			frame.EventText:SetWrap(true)
			frame.EventText:SetAutoStretchVertical(true)
			frame.EventText:SetText("It's been awhile since you submitted your application, time goes by and you wonder really, What is going to happen? Your mind races with the possibilites from the best, to the worst. As you are walking along skulking to yourself in anxiety about whether or not the results are positive, a courier from the Civil Workers' Union approaches you, he asks you, 'You're " .. data[4] .. " right? I have a letter for you, from the Union, marked priority mail, just got it in today. Good luck on whatever's inside, friend.")
			frame.EventText:SetFont("ixSmallFont")
			frame.PanelList = frame:Add("DPanelList")
			frame.PanelList:Dock(FILL)
			frame.PanelList:EnableVerticalScrollbar(true)
			--\n Before you can say a word the Courier rushes off, you stare at the letter, deciding to open it. Inside is a piece of paper, folded in standard letter stock format. It reads: 'Hello " .. data[4] .. " and thank you for applying for the Combine Civil Authority, we have reviewed your application thoroughly and have come to a conclusion. With your skills, experience and expertise, we have decided to pass you for stage 1 of the application process. The next step is a face-to-face interview with a senior officer. Please take this letter to the nearest Officer and they will escort you inside The Nexus to speak with them. \nThank you for your interest in applying. \n~Combine Civil Authority Command"
			frame.EventText2 = frame:Add("DLabel")
			frame.EventText2:Dock(TOP)
			frame.EventText2:SetWrap(true)
			frame.EventText2:SetAutoStretchVertical(true)
			frame.EventText2:SetText("\n Before you can say a word the Courier rushes off, you stare at the letter, deciding to open it. Inside is a piece of paper, folded in standard letter stock format. It reads: 'Hello " .. data[4] .. " and thank you for applying for the Combine Civil Authority, we have reviewed your application thoroughly and have come to a conclusion. At this time you do not fit the expectations of an officer of the CCA, as such we have terminated your application and it has been denied for the reason: '" .. data[1] .. "', we apologize for the inconvenience. \nThank you for your interest in applying. \n~Combine Civil Authority Command")
			frame.EventText2:SetFont("ixSmallFont")
			frame.PanelList:AddItem(frame.EventText)
			frame.PanelList:AddItem(frame.EventText2)
			frame.AcceptButton = frame:Add("DButton")
			frame.AcceptButton:SetText("...Is this really happening?")
			frame.AcceptButton:Dock(BOTTOM)

			function frame.AcceptButton:DoClick()
				self:GetParent():Close()
				netstream.Start("ApplicationSeen", {"cp", false, data[5], data[4]})
			end
		end

		if data[2] and data[1] == "!true" then
			local frame = vgui.Create("DFrame")
			frame:SetSize(ScrW() / 4, ScrH() / 3)
			frame:Center()
			frame:MakePopup()
			frame:SetBackgroundBlur(true)
			frame:ShowCloseButton(false)
			frame.TitleText = frame:Add("DLabel")
			frame.TitleText:Dock(TOP)
			frame.TitleText:SetContentAlignment(5)
			frame.TitleText:SetFont("ixBigFont")
			frame.TitleText:SetText("A Passing Letter.")
			frame.TitleText:SizeToContents()
			frame.EventText = frame:Add("DLabel")
			frame.EventText:Dock(TOP)
			frame.EventText:SetWrap(true)
			frame.EventText:SetAutoStretchVertical(true)
			frame.EventText:SetText("It's been awhile since you submitted your application, but the day is finally here, in your hands you clutch the letter, the response. Not another bill like all the other letters have been, this is it. You hold in your hand a standard letter, with a UU Logo and a stamp marked 'Priority Mail' on it. You've been walking around with it in your hand but you decide now is the time to open it.\nYou carefully open the letter, careful not to damage it's casing. You think to yourself about taking the letter and putting it on a shelf.\nInside is a small letter-sized piece of paper, folded into three creases as all letter-stock papers are. You unfold it, and read:\n")
			frame.EventText:SetFont("ixSmallFont")
			frame.PanelList = frame:Add("DPanelList")
			frame.PanelList:Dock(FILL)
			frame.PanelList:EnableVerticalScrollbar(true)
			--\n Before you can say a word the Courier rushes off, you stare at the letter, deciding to open it. Inside is a piece of paper, folded in standard letter stock format. It reads: 'Hello " .. data[4] .. " and thank you for applying for the Combine Civil Authority, we have reviewed your application thoroughly and have come to a conclusion. With your skills, experience and expertise, we have decided to pass you for stage 1 of the application process. The next step is a face-to-face interview with a senior officer. Please take this letter to the nearest Officer and they will escort you inside The Nexus to speak with them. \nThank you for your interest in applying. \n~Combine Civil Authority Command"
			frame.EventText2 = frame:Add("DLabel")
			frame.EventText2:Dock(TOP)
			frame.EventText2:SetWrap(true)
			frame.EventText2:SetAutoStretchVertical(true)
			frame.EventText2:SetText("Hello " .. data[4] .. " Thank you for your interest in applying for the Combine Civil Authority, we have reviewed your application thoroughly and have come to a conclusion. With your skills, experience and expertise, we have decided to pass you for stage 1 of the application process. The next step is a face-to-face interview with a senior officer. Please take this letter to the nearest Officer and they will escort you inside The Nexus to speak with them. \nThank you for your interest in applying. \n~Combine Civil Authority Command")
			frame.EventText2:SetFont("ixSmallFont")
			frame.PanelList:AddItem(frame.EventText)
			frame.PanelList:AddItem(frame.EventText2)
			frame.AcceptButton = frame:Add("DButton")
			frame.AcceptButton:SetText("...Is this really happening?")
			frame.AcceptButton:Dock(BOTTOM)

			function frame.AcceptButton:DoClick()
				self:GetParent():Close()
				netstream.Start("ApplicationSeen", {"cp", true, data[5], data[4]})
			end
		end

		if data[2] and data[1] ~= "!true" then
			local frame = vgui.Create("DFrame")
			frame:SetSize(ScrW() / 4, ScrH() / 3)
			frame:Center()
			frame:MakePopup()
			frame:SetBackgroundBlur(true)
			frame:ShowCloseButton(false)
			frame.TitleText = frame:Add("DLabel")
			frame.TitleText:Dock(TOP)
			frame.TitleText:SetContentAlignment(5)
			frame.TitleText:SetFont("ixBigFont")
			frame.TitleText:SetText("A Passing Letter.")
			frame.TitleText:SizeToContents()
			frame.EventText = frame:Add("DLabel")
			frame.EventText:Dock(TOP)
			frame.EventText:SetWrap(true)
			frame.EventText:SetAutoStretchVertical(true)
			frame.EventText:SetText("It's been awhile since you submitted your application, but the day is finally here, in your hands you clutch the letter, the response. Not another bill like all the other letters have been, this is it. You hold in your hand a standard letter, with a UU Logo and a stamp marked 'Priority Mail' on it. You've been walking around with it in your hand but you decide now is the time to open it.\nYou carefully open the letter, careful not to damage it's casing. You think to yourself about taking the letter and putting it on a shelf.\nInside is a small letter-sized piece of paper, folded into three creases as all letter-stock papers are. You unfold it, and read:\n")
			frame.EventText:SetFont("ixSmallFont")
			frame.PanelList = frame:Add("DPanelList")
			frame.PanelList:Dock(FILL)
			frame.PanelList:EnableVerticalScrollbar(true)
			--\n Before you can say a word the Courier rushes off, you stare at the letter, deciding to open it. Inside is a piece of paper, folded in standard letter stock format. It reads: 'Hello " .. data[4] .. " and thank you for applying for the Combine Civil Authority, we have reviewed your application thoroughly and have come to a conclusion. With your skills, experience and expertise, we have decided to pass you for stage 1 of the application process. The next step is a face-to-face interview with a senior officer. Please take this letter to the nearest Officer and they will escort you inside The Nexus to speak with them. \nThank you for your interest in applying. \n~Combine Civil Authority Command"
			frame.EventText2 = frame:Add("DLabel")
			frame.EventText2:Dock(TOP)
			frame.EventText2:SetWrap(true)
			frame.EventText2:SetAutoStretchVertical(true)
			frame.EventText2:SetText("Hello " .. data[4] .. " Thank you for your interest in applying for the Combine Civil Authority, we have reviewed your application thoroughly and have come to a conclusion. At this time you do not fit the expectations of an officer of the CCA, as such we have terminated your application and it has been denied for the reason: '" .. data[1] .. "', we apologize for the inconvenience. \nThank you for your interest in applying. \n~Combine Civil Authority Command")
			frame.EventText2:SetFont("ixSmallFont")
			frame.PanelList:AddItem(frame.EventText)
			frame.PanelList:AddItem(frame.EventText2)
			frame.AcceptButton = frame:Add("DButton")
			frame.AcceptButton:SetText("...Is this really happening?")
			frame.AcceptButton:Dock(BOTTOM)

			function frame.AcceptButton:DoClick()
				self:GetParent():Close()
				netstream.Start("ApplicationSeen", {"cp", false, data[5], data[4]})
			end
		end
	end)
end

ix.util.Include("cl_panels.lua")
ix.util.Include("sv_plugin.lua")