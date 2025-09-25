local T, C, L, G = unpack(select(2, ...))

JST_API = {}

function JST_API:GetNickName(GUID)
	local info = T.GetGroupInfobyGUID(GUID)
	if info then	
		return info.nick_name
	end
end