-- Setup

require('luau')
packets = require('packets')
filter = {}

_addon.name = 'Notify'
_addon.author = 'Wunjo'
_addon.commands = {'Notify'}
_addon.version = '1.0.0.1'

windower.register_event('action',
    function (act)
        
        local actorinfo = player_info(act.actor_id)
		local targets = act.targets
        local name1 = player_info(targets[1].id).name
        
        -- https://github.com/Windower/Lua/wiki/Action-Event
        if act.category == 11 then          -- Finish TP move/NPC TP finish
            if act.param ~= 0 then
                -- Is it a monster WS/TP Move?
                if res.monster_abilities[act.param] then 
                    ability = res.monster_abilities[act.param]
                    name1 = player_info(targets[1].id).name
                    
                    if ability.name == 'Charm' and name1 then
                        windower.chat.input:schedule(1,'/p Charm used on '..name1)
                    elseif ability.name == 'Frond Fatale' and name1 then
                        windower.chat.input:schedule(1,'/p Frond Fatale(Charm) used on '..name1)
                    elseif ability.name == 'Doom' and name1 then
                        windower.chat.input:schedule(0,'/p Doom used on '..name1)
                    elseif ability.name == 'Death Sentence' and name1 then
                        windower.chat.input:schedule(0,'/p Death Sentence(Doom) used on '..name1)
                    end
                end
            end
        elseif act.category == 6 then          -- Use job ability
            if act.param ~= 0 then
                -- Is it a monster WS/TP Move?
                if res.monster_abilities[act.param] then 
                    ability = res.monster_abilities[act.param]
                    name1 = player_info(targets[1].id).name
                    
                    if ability.name == 'Charm' and name1 then
                        windower.chat.input:schedule(1,'/p Charm used on '..name1)
                    elseif ability.name == 'Frond Fatale' and name1 then
                        windower.chat.input:schedule(1,'/p Frond Fatale(Charm) used on '..name1)
                    elseif ability.name == 'Doom' and name1 then
                        windower.chat.input:schedule(0,'/p Doom used on '..name1)
                    elseif ability.name == 'Death Sentence' and name1 then
                        windower.chat.input:schedule(0,'/p Death Sentence(Doom) used on '..name1)
                    end
                end
            end
        end
    end
)
-- Borrowed from \addons\battlemod
function player_info(id)
    local player_table = windower.ffxi.get_mob_by_id(id)
    local typ,owner,filt
    
    if player_table == nil then
        return {name=nil,id=nil,is_npc=nil,type='debug',owner=nil,race=nil}
    end
    
    for i,v in pairs(windower.ffxi.get_party()) do
        if type(v) == 'table' and v.mob and v.mob.id == player_table.id then
            typ = i
            if i == 'p0' then
                filt = 'me'
            elseif i:sub(1,1) == 'p' then
                filt = 'party'
            else
                filt = 'alliance'
            end
        end
    end
    
    if not filt then
        if player_table.is_npc then
            if player_table.id%4096>2047 then
                typ = 'other_pets'
                filt = 'other_pets'
                owner = 'other'
                for i,v in pairs(windower.ffxi.get_party()) do
                    if type(v) == 'table' and v.mob and v.mob.pet_index and v.mob.pet_index == player_table.index then
                        if i == 'p0' then
                            typ = 'my_pet'
                            filt = 'my_pet'
                        end
                        owner = i
                        break
                    elseif type(v) == 'table' and v.mob and v.mob.fellow_index and v.mob.fellow_index == player_table.index then
                        if i == 'p0' then
                            typ = 'my_fellow'
                            filt = 'my_fellow'
                        end
                        owner = i
                        break
                    end
                end
            else
                typ = 'mob'
                filt = 'monsters'
                for i,v in pairs(windower.ffxi.get_party()) do
                    if type(v) == 'table' and nf(v.mob,'id') == player_table.claim_id and filter.enemies then
                        filt = 'enemies'
                    end
                end
            end
        else
            typ = 'other'
            filt = 'others'
        end
    end
    if not typ then typ = 'debug' end
    return {name=player_table.name,id=id,is_npc = player_table.is_npc,type=typ,filter=filt,owner=(owner or nil),race = player_table.race}
end
-- Borrowed from \addons\battlemod
function nf(field,subfield)
    if field ~= nil then
        return field[subfield]
    else
        return nil
    end
end
