
--CheckJH()  -- 鸡胡    什么牌都可以胡，可吃碰杠
--CheckPH()    -- 平胡    全部都是顺子没有刻子
--CheckPPH()   -- 碰碰胡  全部是刻子没有顺子
--CheckHYS()     -- 混一色   整副牌由字牌及另外单一花色（筒、条或万）组成
--CheckQYS()   -- 清一色  整副牌由同一花色组成
--CheckHP()    -- 碰混    混一色 + 碰碰胡
--CheckQP()    --清碰   清一色 + 碰碰胡
--CheckHYJ()   --混幺九  由幺九牌和字牌组成的牌型
--CheckXSY()   --小三元  拿齐中、发、白三种三元牌，但其中一种是将
--CheckXSX()   --小四喜  胡牌者完成东、南、西、北其中三组刻子，一组对子
--CheckZYS()   --字一色  由字牌组合成的刻子牌型
--checkQYJ()   --清幺九  只由幺九两种牌组成的刻子牌型
--checkDSX()   --大三元  胡牌时，有中、发、白三组刻子
--CheckDSX()   --大四喜  胡牌者完成东、南、西、北四组刻子
--checkJLBD()  --九莲宝灯 同种牌形成 1112345678999 ，在摸到该种牌任何一张即可胡牌，不计清一色
--CheckSSY()   --十三幺  1 、 9 万筒索，东、南、西、北、中、发、白；以上牌型任意一张牌作将


local MJ_WAN       = 1      --万
local MJ_TIAO      = 2    --条
local MJ_BING      = 3    --饼
local MJ_FENG      = 4    --东南西北(1357)
local MJ_ZFB     = 5    --中发白(135)

local Pai_MING    =0    --明
local Pai_AN    =1    --暗

local Pai_My    =0    --手牌组
local Pai_Chi   =1    --吃牌组
local Pai_Peng    =2    --碰牌组
local Pai_Gang    =3    --杠牌组
local Pai_Ting    =4      --听牌组



local function CheckSinglePaiMingAn(pai)
  --检查牌的明暗或者空
  return math.floor(pai%10000/1000)
end

local function CheckSinglePaiGroup(pai)
  --检查单张牌所属牌组
  return math.floor(pai%1000/100)
end

local function CheckSinglePaiType(pai)
  --检查单张牌的类型，万饼筒条
  return math.floor(pai%100/10)
end

local function CheckSinglePaiNum(pai)
  --检查单张牌的数值
  return math.floor(pai%10)
end

local function GetPaiTypeNum(pai)
  --返回标准牌型数值(包括牌型与数字)
  return math.floor(pai%100)
end

local function SortByType(userpai)

  -- 将用户的手牌分成 万，条，饼，风，中发白四组并排序返回
  local sort_pai = {
            ["My"]={
                [MJ_WAN] = {},
                [MJ_TIAO] = {},
                [MJ_BING] = {},
                [MJ_FENG] = {},
                [MJ_ZFB] = {}
                }
          }
  for i = 1,#userpai,1 do
    if CheckSinglePaiGroup(userpai[i]) == Pai_My then

      type = CheckSinglePaiType(userpai[i])
      table.insert(sort_pai["My"][type],userpai[i])
    end
  end

  for i = 1,5,1 do
    table.sort(sort_pai["My"][i])
  end

  return sort_pai
end



--检测一对
local function CheckAAPai(iValue1,iValue2)
    if iValue1 == iValue2 then return true
    else return false
    end
end

--检测三连张
local function CheckABCPai(iValue1,iValue2,iValue3)
    if (iValue1 == iValue2-1)and(iValue2 == iValue3-1) then return true
    else return false
    end
end

--检测三重张
local function CheckAAAPai(iValue1,iValue2,iValue3)
    local p12 = CheckAAPai(iValue1,iValue2)
    local p23 = CheckAAPai(iValue2,iValue3)
    if p12 and p23 then return true
    else return false
    end
end


--检测四重张
local function CheckAAAAPai(iValue1,iValue2,iValue3,iValue4)
    local p123 = CheckAAAPai(iValue1,iValue2,iValue3)
    local p34 = CheckAAPai(iValue3,iValue4)
    if p123 and p34 then return true
    else return false
    end
end

--检测三连对
local function CheckAABBCCPai(iValue1,iValue2,iValue3,iValue4,iValue5,iValue6)
    local p12 = CheckAAPai(iValue1,iValue2)
    local p34 = CheckAAPai(iValue3,iValue4)
    local p56 = CheckAAPai(iValue5,iValue6)
    if p12 and p34 and p56 and iValue1 == iValue3-1 and iValue3 == iValue5-1
    then
      return true
    else
      return false
    end
end
--检测二连刻
local function CheckAAABBBPai(iValue1,iValue2,iValue3,iValue4,iValue5,iValue6)
  return CheckAAAPai(iValue1,iValue2,iValue3) and CheckAAAPai(iValue4,iValue5,iValue6)
end
--检测三连刻
local function  CheckAAABBBCCCPai(iValue1,iValue2,iValue3,iValue4,iValue5,iValue6,iValue7,iValue8,iValue9)
    local p123 = CheckAAAPai(iValue1,iValue2,iValue3)
    local p456 = CheckAAAPai(iValue4,iValue5,iValue6)
    local p789 = CheckAAAPai(iValue7,iValue8,iValue9)
    if p123 and p456 and p789 then return true
    else return false
    end
end

--检测三连杠
local function CheckAAAABBBBCCCCPai(iValue1,iValue2,iValue3,iValue4,iValue5,iValue6,iValue7,iValue8,iValue9,iValue10,iValue11,iValue12)
    local p1234 = CheckAAAAPai(iValue1,iValue2,iValue3,iValue4)
    local p5678 = CheckAAAAPai(iValue5,iValue6,iValue7,iValue8)
    local p9101112 = CheckAAAAPai(iValue9,iValue10,iValue11,iValue12)
    if p1234 and p5678 and p9101112 then return true
    else return false
    end
end


--检测3张（三连对三重张）
local function Check3Pai(iValue1,iValue2,iValue3)
    if CheckAAAPai(iValue1,iValue2,iValue3) then return true end
    if CheckABCPai(iValue1,iValue2,iValue3) then return true end
    return false
end

--检测5张
local function Check5Pai(iValue1,iValue2,iValue3,iValue4,iValue5)
    --2+3
    if CheckAAPai(iValue1,iValue2) and Check3Pai(iValue3,iValue4,iValue5) then return true end
    --ABBBC
    if CheckAAAPai(iValue2,iValue3,iValue4) and CheckABCPai(iValue1,iValue4,iValue5) then return true end
    --3+2
    if CheckAAPai(iValue4,iValue5) and Check3Pai(iValue1,iValue2,iValue3) then return true end
    return false
end

--检测6张
local function Check6Pai(iValue1,iValue2,iValue3,iValue4,iValue5,iValue6)
    --3+3
    if Check3Pai(iValue1,iValue2,iValue3) and Check3Pai(iValue4,iValue5,iValue6) then return true end
    --AABBCC
    if CheckAABBCCPai(iValue1,iValue2,iValue3,iValue4,iValue5,iValue6) then return true end
    --ABBBBC
    if CheckAAAAPai(iValue2,iValue3,iValue4,iValue5) and CheckABCPai(iValue1,iValue2,iValue6) then return true end
    return false
end

--检测8张
local function Check8Pai(iValue1,iValue2,iValue3,iValue4,iValue5,iValue6,iValue7,iValue8)
  --2+3+3
  if CheckAAPai(iValue1,iValue2) and Check6Pai(iValue3,iValue4,iValue5,iValue6,iValue7,iValue8)
  then return true
  end
  --3+2+3
  if CheckAAPai(iValue4,iValue5) and Check3Pai(iValue1,iValue2,iValue3) and Check3Pai(iValue6,iValue7,iValue8)
  then return true
  end
  --3+3+2
  if CheckAAPai(iValue7,iValue8) and Check6Pai(iValue1,iValue2,iValue3,iValue4,iValue5,iValue6)
  then return true
  end
  return false
end

--检测9张
local function Check9Pai(iValue1,iValue2,iValue3,iValue4,iValue5,iValue6,iValue7,iValue8,iValue9)
  --3+6
  if Check3Pai(iValue1,iValue2,iValue3) and Check6Pai(iValue4,iValue5,iValue6,iValue7,iValue8,iValue9)
  then return true
  end
  --6+3
  if Check3Pai(iValue7,iValue8,iValue9) and Check6Pai(iValue1,iValue2,iValue3,iValue4,iValue5,iValue6)
  then return true
  end
  return false
end

--检测11张
local function Check11Pai(iValue1,iValue2,iValue3,iValue4,iValue5,iValue6,iValue7,iValue8,iValue9,iValue10,iValue11)
  --2+9
  if CheckAAPai(iValue1,iValue2) and Check9Pai(iValue3,iValue4,iValue5,iValue6,iValue7,iValue8,iValue9,iValue10,iValue11)
  then return true
  end
  --3+2+6
  if CheckAAPai(iValue4,iValue5) and Check3Pai(iValue1,iValue2,iValue3) and Check6Pai(iValue6,iValue7,iValue8,iValue9,iValue10,iValue11)
  then return true
  end
  --6+2+3
  if CheckAAPai(iValue7,iValue8) and Check6Pai(iValue1,iValue2,iValue3,iValue4,iValue5,iValue6) and Check3Pai(iValue9,iValue10,iValue11)
  then return true
  end
  --9+2
  if CheckAAPai(iValue10,iValue11) and Check9Pai(iValue1,iValue2,iValue3,iValue4,iValue5,iValue6,iValue7,iValue8,iValue9)
  then return true
  end
  return false
end

--检测12张
local function Check12Pai(iValue1,iValue2,iValue3,iValue4,iValue5,iValue6,iValue7,iValue8,iValue9,iValue10,iValue11,iValue12)
  --3+9
  if Check3Pai(iValue1,iValue2,iValue3) and Check9Pai(iValue4,iValue5,iValue6,iValue7,iValue8,iValue9,iValue10,iValue11,iValue12)
  then return true
  end
  --9+3
  if Check3Pai(iValue10,iValue11,iValue12) and Check9Pai(iValue1,iValue2,iValue3,iValue4,iValue5,iValue6,iValue7,iValue8,iValue9)
  then return true
  end
  --6+6
  if Check6Pai(iValue1,iValue2,iValue3,iValue4,iValue5,iValue6) and Check6Pai(iValue7,iValue8,iValue9,iValue10,iValue11,iValue12)
  then return true
  end
  return false
end

--检测14张
local function Check14Pai(iValue1,iValue2,iValue3,iValue4,iValue5,iValue6,iValue7,iValue8,iValue9,iValue10,iValue11,iValue12,iValue13,iValue14)
  --2+12
  if CheckAAPai(iValue1,iValue2)
  then
    if Check12Pai(iValue3,iValue4,iValue5,iValue6,iValue7,iValue8,iValue9,iValue10,iValue11,iValue12,iValue13,iValue14)
    then return true
    end
  end
  --3+2+9
  if CheckAAPai(iValue4,iValue5)
  then
    if Check3Pai(iValue1,iValue2,iValue3) and Check9Pai(iValue6,iValue7,iValue8,iValue9,iValue10,iValue11,iValue12,iValue13,iValue14)
    then return true
    end
  end
  --6+2+6
  if CheckAAPai(iValue7,iValue8)
  then
    if Check6Pai(iValue1,iValue2,iValue3,iValue4,iValue5,iValue6) and Check6Pai(iValue9,iValue10,iValue11,iValue12,iValue13,iValue14)
    then return true
    end
  end
  --9+2+3
  if CheckAAPai(iValue10,iValue11)
  then
    if Check9Pai(iValue1,iValue2,iValue3,iValue4,iValue5,iValue6,iValue7,iValue8,iValue9) and Check3Pai(iValue12,iValue13,iValue14)
    then return true
    end
  end
  --12+2
  if CheckAAPai(iValue13,iValue14)
  then
    if Check12Pai(iValue1,iValue2,iValue3,iValue4,iValue5,iValue6,iValue7,iValue8,iValue9,iValue10,iValue11,iValue12)
    then return true
    end
  end
  return false
end








function CheckChiPai(userPai,prePai)
  --吃牌，用上家牌与自身牌遍历对比
  local paiGroup = {
            ["My"] = {
                  [MJ_WAN] = {},
                  [MJ_TIAO] = {},
                  [MJ_BING] = {},
                  [MJ_FENG] = {},
                  [MJ_ZFB] = {}
                  } --手牌组
          }
  local attribute = {["Chi"]={}}
  for i=1,#userPai
  do
    if CheckSinglePaiGroup(userPai[i]) == Pai_My
    then
      if CheckSinglePaiType(userPai[i]) == MJ_WAN
      then
        table.insert(paiGroup["My"][MJ_WAN],userPai[i])
      elseif CheckSinglePaiType(userPai[i]) == MJ_TIAO
      then
        table.insert(paiGroup["My"][MJ_TIAO],userPai[i])
      elseif CheckSinglePaiType(userPai[i]) == MJ_BING
      then
        table.insert(paiGroup["My"][MJ_BING],userPai[i])
      elseif CheckSinglePaiType(userPai[i]) == MJ_FENG
      then
        table.insert(paiGroup["My"][MJ_FENG],userPai[i])
      elseif CheckSinglePaiType(userPai[i]) == MJ_ZFB
      then
        table.insert(paiGroup["My"][MJ_ZFB],userPai[i])
      end
    end
  end

  for i=1,5
  do
    table.sort( paiGroup["My"][i], function (a,b) return a<b end )
  end

  local paiType = CheckSinglePaiType(prePai)
  if(#paiGroup["My"][paiType])
  then
    for i=1,#(paiGroup["My"][paiType])-1
    do
      --if CheckSinglePaiType(paiGroup["My"][i]) == CheckSinglePaiType(paiGroup["My"][i+1]) and CheckSinglePaiType(paiGroup["My"][i]) == CheckSinglePaiType(prePai)
        --上家牌在顺子最左
        if (paiGroup["My"][paiType][i] == prePai+1) and (paiGroup["My"][paiType][i+1] == prePai+2)
        then
          local shunzi = {paiGroup["My"][paiType][i],paiGroup["My"][paiType][i+1]}
          table.insert(attribute["Chi"],shunzi)
        end
        --上家牌在顺子中间
        if (paiGroup["My"][paiType][i] == prePai-1) and (paiGroup["My"][paiType][i+1] == prePai+1)
        then
          local shunzi = {paiGroup["My"][paiType][i],paiGroup["My"][paiType][i+1]}
          table.insert(attribute["Chi"],shunzi)
        --下面这块是用在出现AB**BC时吃B的情况
        elseif (paiGroup["My"][paiType][i] ==prePai-1) and (paiGroup["My"][paiType][i+1] == prePai)
        then
          for k=i+1,#(paiGroup["My"][paiType])
          do
            if (paiGroup["My"][paiType][k] == prePai+1)
            then
              local shunzi = {paiGroup["My"][paiType][i],paiGroup["My"][paiType][k]}
              table.insert(attribute["Chi"],shunzi)
            end
          end
        end
        --上家牌在顺子最右
        if (paiGroup["My"][paiType][i] == prePai-2) and (paiGroup["My"][paiType][i+1] == prePai-1)
        then
          local shunzi = {paiGroup["My"][paiType][i],paiGroup["My"][paiType][i+1]}
          table.insert(attribute["Chi"],shunzi)
        end
    end
  end

  --转换至userPai的绝对位置
  for i=1,#attribute["Chi"]
  do
    for j=1,2
    do
      for k=1,#userPai
      do
        if attribute["Chi"][i][j] == userPai[k]
        then
          attribute["Chi"][i][j] = k
        end
      end
    end
  end

  return attribute["Chi"]
end


function CheckPengPai(userPai,prePai)
  --碰牌
  local paiGroup = SortByType(userPai)

  local attribute = {["Peng"]={}}

  local paiType = CheckSinglePaiType(prePai)
  if(#paiGroup["My"][paiType])
  then
    for i=1,#(paiGroup["My"][paiType])-1
    do
      if paiGroup["My"][paiType][i] == prePai and paiGroup["My"][paiType][i+1] == prePai
      then
        local kezi = {paiGroup["My"][paiType][i],paiGroup["My"][paiType][i+1]}
        table.insert(attribute["Peng"],kezi)
      end
    end
  end

  -- 转换成对应userPai中的绝对位置
  for i=1,#attribute["Peng"]
  do
    for k=1,#userPai
    do
      if attribute["Peng"][i][1] == userPai[k] and attribute["Peng"][i][2] == userPai[k+1]
      then
        attribute["Peng"][i][1] = k
        attribute["Peng"][i][2] = k+1
      end
    end
  end

  return attribute["Peng"]
end



function CheckGangPai(userPai,prePai,isNotZiMo)
  --杠牌
  local paiGroup = {
            ["My"]  =  {
                  [MJ_WAN] = {},
                  [MJ_TIAO] = {},
                  [MJ_BING] = {},
                  [MJ_FENG] = {},
                  [MJ_ZFB] = {}
                  },--手牌组
            ["Peng"] = {
                  [MJ_WAN] = {},
                  [MJ_TIAO] = {},
                  [MJ_BING] = {},
                  [MJ_FENG] = {},
                  [MJ_ZFB] = {}
                  },--碰牌组

          }
  for i=1,#userPai
  do
    if CheckSinglePaiGroup(userPai[i]) == Pai_My
    then
      if CheckSinglePaiType(userPai[i]) == MJ_WAN
      then
        table.insert(paiGroup["My"][MJ_WAN],userPai[i])
      elseif CheckSinglePaiType(userPai[i]) == MJ_TIAO
      then
        table.insert(paiGroup["My"][MJ_TIAO],userPai[i])
      elseif CheckSinglePaiType(userPai[i]) == MJ_BING
      then
        table.insert(paiGroup["My"][MJ_BING],userPai[i])
      elseif CheckSinglePaiType(userPai[i]) == MJ_FENG
      then
        table.insert(paiGroup["My"][MJ_FENG],userPai[i])
      elseif CheckSinglePaiType(userPai[i]) == MJ_ZFB
      then
        table.insert(paiGroup["My"][MJ_ZFB],userPai[i])
      end
    end
    if CheckSinglePaiGroup(userPai[i]) == Pai_Peng
    then
      if CheckSinglePaiType(userPai[i]) == MJ_WAN
      then
        table.insert(paiGroup["Peng"][MJ_WAN],userPai[i])
      elseif CheckSinglePaiType(userPai[i]) == MJ_TIAO
      then
        table.insert(paiGroup["Peng"][MJ_TIAO],userPai[i])
      elseif CheckSinglePaiType(userPai[i]) == MJ_BING
      then
        table.insert(paiGroup["Peng"][MJ_BING],userPai[i])
      elseif CheckSinglePaiType(userPai[i]) == MJ_FENG
      then
        table.insert(paiGroup["Peng"][MJ_FENG],userPai[i])
      elseif CheckSinglePaiType(userPai[i]) == MJ_ZFB
      then
        table.insert(paiGroup["Peng"][MJ_ZFB],userPai[i])
      end
    end
  end

  for i=1,5
  do
    table.sort( paiGroup["My"][i], function (a,b) return a<b end )
    table.sort( paiGroup["Peng"][i], function (a,b) return a<b end )
  end

  local attribute = {["Gang"]={}}

  local paiType = CheckSinglePaiType(prePai)
  if(#paiGroup["My"][paiType])
  then
    if isNotZiMo ~= 0
    then
      for i=1,#(paiGroup["My"][paiType])-2
      do
        if (paiGroup["My"][paiType][i] == prePai) and (paiGroup["My"][paiType][i+1] == prePai) and (paiGroup["My"][paiType][i+2] == prePai)
        then
          local gang = {paiGroup["My"][paiType][i],paiGroup["My"][paiType][i+1],paiGroup["My"][paiType][i+2]}
          table.insert(attribute["Gang"],gang)
        end
      end
    --加杠
    else
      prePai = GetPaiTypeNum(prePai)
      for i=1,#(paiGroup["Peng"][paiType])
      do
        if GetPaiTypeNum(paiGroup["Peng"][paiType][i]) == prePai and GetPaiTypeNum(paiGroup["Peng"][paiType][i+1]) == prePai and GetPaiTypeNum(paiGroup["Peng"][paiType][i+2]) == prePai
        then
          local gang = {GetPaiTypeNum(paiGroup["Peng"][paiType][i]),GetPaiTypeNum(paiGroup["Peng"][paiType][i+1]),GetPaiTypeNum(paiGroup["Peng"][paiType][i+2])}
          table.insert(attribute["Gang"],gang)
        end
      end
    end
  end

  -- 转换成对应userPai中的绝对位置
  for i=1,#attribute["Gang"]
  do
    for k=1,#userPai
    do
      if attribute["Gang"][i][1] == userPai[k] and attribute["Gang"][i][2] == userPai[k+1] and attribute["Gang"][i][3] == userPai[k+2]
      then
        attribute["Gang"][i][1] = k
        attribute["Gang"][i][2] = k+1
        attribute["Gang"][i][3] = k+2
      end
    end
  end


  return attribute["Gang"]
end


function CheckTingPai(paiGroup,attribute)
  -- 检查听牌

end

local function CheckKe(userpai,i,n)

  -- 小于三张不可能刻
  if i > n then return true end
  if n - i < 2 then return false end
  if CheckAAAPai(userpai[i],userpai[i+1],userpai[i+2]) and CheckKe(userpai,i+4,n) then
    return true
  else
    return false end
end

local function CheckShun(userpai,i,n)

  -- 小于三张不可能刻
  if i > n then return true end
  if n - i < 2 then return false end

  if CheckABCPai(userpai[i],userpai[i+1],userpai[i+2]) and CheckShun(userpai,i+4,n) then
    return true
  else
    return false end
end

local function Deletejiang(userpai)
  -- 删除传进来的牌中的将牌
  local count = 0
  local last_pai = 0
  for i = 1,#userpai do
    local cur_pai = userpai[i]
    if cur_pai ~= last_pai then
      last_pai = cur_pai
      if count == 1 then
        table.remove(userpai,i-1)
        table.remove(userpai,i-2)
      end
      count = 0
    else
      count = count + 1
      last_pai = cur_pai
    end
  end

  -- 检测末尾部分
  if count == 1 then
    table.remove(userpai)
    table.remove(userpai)
  end
end
local function CheckPH(userPai)

  -- 拷贝数组
  local t_pai = {}
  for i = 1,#userPai do
    table.insert(t_pai,userPai[i])
  end

  -- 删除将牌
  Deletejiang(t_pai)

  -- 保证只有一组将牌被删除,多组则返回
  if #t_pai ~= ( #userPai - 2 ) and (#t_pai ~= userPai) then return false end


  -- --检查剩下的牌是否只由顺子组成
    local sort_pai = SortByType(t_pai)
  for i = 1,#sort_pai["My"] do
    if #sort_pai["My"][i] ~= 0 then
      if CheckShun(sort_pai["My"][i],1,#sort_pai["My"][i]) == false then return false end
    end
  end

  return true

end

local function CheckPPH(userPai)
  -- 检查碰碰胡
  -- 无顺子即可
  -- 拷贝数组
  local t_pai = {}
  for i = 1,#userPai do
    table.insert(t_pai,userPai[i])
  end

  -- 删除将牌
  Deletejiang(t_pai)

  -- 保证只有一组将牌被删除,多组则返回
  if #t_pai ~= ( #userPai - 2 ) and (#t_pai ~= userPai) then return false end

  local sort_pai = SortByType(t_pai)

  --检查剩下的牌是否只由刻组成
  for i = 1,#sort_pai["My"] do
    if #sort_pai["My"][i] ~= 0 then
      if CheckKe(sort_pai["My"][i],1,#sort_pai["My"][i]) == false then return false end
    end
  end

  return true

end


local function CheckHYS(userPai)
  -- 检测混一色
  local sort_pai = SortByType(userPai)
  local count_wan  = #sort_pai["My"][MJ_WAN]
  local count_bing = #sort_pai["My"][MJ_BING]
  local count_tiao = #sort_pai["My"][MJ_TIAO]
  local count_feng = #sort_pai["My"][MJ_FENG]
  local count_zfb  = #sort_pai["My"][MJ_ZFB]
  -- 保证有字牌
  if count_feng == 0 and count_zfb == 0 then return false end
  -- 保证单花色
  if count_wan ~= 0 and count_tiao == 0 and count_bing == 0 then return true end
  if count_wan == 0 and count_tiao ~= 0 and count_bing == 0 then return true end
  if count_wan == 0 and count_tiao == 0 and count_bing ~= 0 then return true end

  return false
end
local function CheckHP(userPai)
  -- 检查混碰
  if CheckHYS(userPai) and CheckPPH(userPai) then return true end
  return false
end


local function CheckHYJ(userPai)
  --检测混幺九
  -- 对 （万，饼，条 ）满足 幺九
  for i = 1,#userPai do
    local paitype = CheckSinglePaiType(userPai[i])
    local num     = CheckSinglePaiNum(userPai[i])

    if paitype == MJ_WAN or paitype == MJ_BING or paitype == MJ_TIAO then
      if num ~= 1 and num ~= 9  then
        return false
      end
    end
  end

  -- 检查是否有字牌，如果先检查 清幺九，则可以省去这步
  local found = false
  for i = 1,#userPai do
    if CheckSinglePaiType(userPai[i]) == MJ_FENG or CheckSinglePaiType(userPai[i]) == MJ_ZFB then
      found = true
    end
  end

  return found
end


local function CheckXSY(userPai)
  -- 小三元
  local zhong = 0
  local fa    = 0
  local bai   = 0
  for i = 1,#userPai do
    local paitype = CheckSinglePaiType(userPai[i])
    if paitype == MJ_ZFB then
      if CheckSinglePaiNum(userPai[i]) == 1 then
        zhong = zhong + 1
      elseif CheckSinglePaiNum(userPai[i]) == 3 then
        fa    = fa  + 1
      elseif CheckSinglePaiNum(userPai[i]) == 5 then
        bai   = bai + 1
      end
    end
  end
  if zhong == 2 and fa >= 3 and bai >= 3 then return true end
  if zhong >= 3 and fa == 2 and bai >= 3 then return true end
  if zhong >= 3 and fa >= 3 and bai == 2 then return true end
  return false
end

local function CheckQYS(userPai)

  -- 清一色
  local paitype = CheckSinglePaiType(userPai[1])
  if paitype == MJ_WAN or paitype == MJ_TIAO or paitype == MJ_BING then
    for i = 2,#userPai do
      if CheckSinglePaiType(userPai[i]) ~= paiType then
        return false
      end
    end
  elseif paitype == MJ_FENG or paitype == MJ_ZFB then
    for i = 2,#userPai do
      if CheckSinglePaiType(userPai[i]) ~= MJ_FENG and CheckSinglePaiType(userPai[i]) ~= MJ_ZFB then
        return false
      end
    end
  end

  return true
end

local function CheckQP(userPai)
  -- 检查清碰
  if CheckQYS(userPai) and CheckPPH(userPai) then return true end
  return false
end

local function CheckXSX(userPai)
  --　小四喜
  local dong = 0
  local nan  = 0
  local xi   = 0
  local bei  = 0
  for i = 1,#userPai do
    if CheckSinglePaiType(userPai[i]) == MJ_FENG then
      if CheckSinglePaiNum(userPai[i]) == 1 then
        dong = dong + 1
      elseif  CheckSinglePaiNum(userPai[i]) == 3 then
        nan  = nan + 1
      elseif CheckSinglePaiNum(userPai[i]) == 5 then
        xi   = xi  + 1
      elseif CheckSinglePaiNum(userPai[i]) == 7 then
        bei  = bei + 1
      end
    end
  end
  if dong == 2 and nan == 3 and xi == 3 and bei == 3 then return true end
  if dong == 3 and nan == 2 and xi == 3 and bei == 3 then return true end
  if dong == 3 and nan == 3 and xi == 2 and bei == 3 then return true end
  if dong == 3 and nan == 3 and xi == 3 and bei == 2 then return true end
  return false
end

local function CheckZYS(userPai)
  -- 字一色
  for i = 1,#userPai do
    local paitype = CheckSinglePaiType(userPai[i])
    if paitype ~= MJ_ZFB and paitype ~= MJ_FENG then
      return false
    end
  end
  return true
end
local function CheckQYJ(userPai)
  -- 清幺九
  for i = 1,#userPai do
    local paitype = CheckSinglePaiType(userPai[i])
    local num = CheckSinglePaiNum(userPai[i])
    -- 遇到字牌返回
    if paitype == MJ_FENG or paitype == MJ_ZFB then return false end
    -- 非字牌遇到非 1 9 ，返回
    if num ~= 1 and num ~= 9 then return false end
  end
  return true
end

local function checkJLBD(userPai)
  -- 穷举法
  local JLBD_list = {
   --{11,11,11,12,13,14,15,16,17,18,19,19,19},
   {11,11,11,11,12,13,14,15,16,17,18,19,19,19},{11,11,11,12,12,13,14,15,16,17,18,19,19,19},
   {11,11,11,12,13,13,14,15,16,17,18,19,19,19},{11,11,11,12,13,14,14,15,16,17,18,19,19,19},
   {11,11,11,12,13,14,15,15,16,17,18,19,19,19},{11,11,11,12,13,14,15,16,16,17,18,19,19,19},
   {11,11,11,12,13,14,15,16,17,17,18,19,19,19},{11,11,11,12,13,14,15,16,17,18,18,19,19,19},
   {11,11,11,12,13,14,15,16,17,18,19,19,19,19},{21,21,21,21,22,23,24,25,26,27,28,29,29,29},
   {21,21,21,22,22,23,24,25,26,27,28,29,29,29},{21,21,21,22,23,23,24,25,26,27,28,29,29,29},
   {21,21,21,22,23,24,24,25,26,27,28,29,29,29},{21,21,21,22,23,24,25,25,26,27,28,29,29,29},
   {21,21,21,22,23,24,25,26,26,27,28,29,29,29},{21,21,21,22,23,24,25,26,27,27,28,29,29,29},
   {21,21,21,22,23,24,25,26,27,28,28,29,29,29},{21,21,21,22,23,24,25,26,27,28,29,29,29,29},
   {31,31,31,31,32,33,34,35,36,37,38,39,39,39},{31,31,31,32,32,33,34,35,36,37,38,39,39,39},
   {31,31,31,32,33,33,34,35,36,37,38,39,39,39},{31,31,31,32,33,34,34,35,36,37,38,39,39,39},
   {31,31,31,32,33,34,35,35,36,37,38,39,39,39},{31,31,31,32,33,34,35,36,36,37,38,39,39,39},
   {31,31,31,32,33,34,35,36,37,37,38,39,39,39},{31,31,31,32,33,34,35,36,37,38,38,39,39,39},
   {31,31,31,32,33,34,35,36,37,38,39,39,39,39}}

   local found = false
   local n = #userPai
   local count = 0
   for i = 1,#JLBD_list do
    for j = 1,#userPai do
      if userPai[j] == JLBD_list[i][j] then
        count = count + 1
      else count = 0 end
      if count == n then return true end
    end
   end
   return false
end

local function CheckDSY(userPai)
  -- 大三元
  --从CheckHuScore传入的userPai包含自摸牌
  local zhong = 0
  local fa = 0
  local bai = 0
  for i=1,#userPai
  do
    if CheckSinglePaiType(userPai[i]) == MJ_ZFB
    then
      if CheckSinglePaiNum(userPai[i]) == 1
      then
        zhong = zhong+1
      end
      if CheckSinglePaiNum(userPai[i]) == 3
      then
        fa = fa+1
      end
      if CheckSinglePaiNum(userPai[i]) == 5
      then
        bai = bai+1
      end
    end
  end
  if zhong<3 or fa<3 or bai<3
  then
    return false
  else
    return true
  end
end

local function CheckDSX(userPai)
  --大四喜
  --从CheckHuScore传入的userPai包含自摸牌
  local dong = 0
  local nan = 0
  local xi = 0
  local bei = 0

  for i=1,#userPai
  do
    if CheckSinglePaiType(userPai[i]) == MJ_FENG
    then
      --东
      if CheckSinglePaiNum(userPai[i]) == 1
      then
        dong = dong + 1
      end
      --南
      if CheckSinglePaiNum(userPai[i]) == 3
      then
        nan = nan + 1
      end
      --西
      if CheckSinglePaiNum(userPai[i]) == 5
      then
        xi = xi + 1
      end
      --北
      if CheckSinglePaiNum(userPai[i]) == 7
      then
        bei = bei + 1
      end
    end
  end

  if dong<3 or xi<3 or nan<3 or bei<3
  then
    return false
  else
    return true
  end
end

local function CheckSSY(userPai)
  --十三幺
  -- （万筒索）1，9各一张， (东、南、西、北、中、发、白) 其中一个为两张，其余为一张
  --  典型  11 19 21 29 31 39 41 43 45 47 51 53 55 55

  local sort_pai = SortByType(userPai)

  if CheckSinglePaiNum(sort_pai["My"][MJ_WAN][1])  ~= 1 or CheckSinglePaiNum(sort_pai["My"][MJ_WAN][2])   ~= 9 then return false end
  if CheckSinglePaiNum(sort_pai["My"][MJ_TIAO][1]) ~= 1 or CheckSinglePaiNum(sort_pai["My"][MJ_TIAO][2]) ~= 9 then return false end
  if CheckSinglePaiNum(sort_pai["My"][MJ_BING][1]) ~= 1 or CheckSinglePaiNum(sort_pai["My"][MJ_BING][2])  ~= 9 then return false end

  local dong  = 0
  local nan   = 0
  local xi    = 0
  local bei   = 0
  local zhong = 0
  local fa    = 0
  local bai   = 0

  -- 统计 ( 东南西北 )数目
  for i = 1,#sort_pai["My"][MJ_FENG] do
    local pai = sort_pai["My"][MJ_FENG][i]
    local num = CheckSinglePaiNum(pai)
    if num == 1 then dong = dong + 1 end
    if num == 3 then nan  = nan  + 1 end
    if num == 5 then xi   = xi   + 1 end
    if num == 7 then bei  = bei  + 1 end
  end
  --统计 ( 中发白 )数目
  for i = 1,#sort_pai["My"][MJ_ZFB] do
    local pai = sort_pai["My"][MJ_ZFB][i]
    local num = CheckSinglePaiNum(pai)
    if num == 1 then zhong = zhong + 1 end
    if num == 3 then fa    = fa    + 1 end
    if num == 5 then bai   = bai   + 1 end
  end

  -- 东南西北中发白，每种一个，其中一个为将牌
  if dong and nan and xi and bei and zhong and fa and bai and (dong + nan + xi + bei + zhong + fa + bai  == 8) then
    return true
  else return false end

end

function CheckAll(userPai,aPai,flag)
  -- 检查所有吃、碰、杠、听、胡
  --flag参数指定第二个参数：0-自摸牌，1-上家牌，2-其他用户牌
  --自摸牌不包含在userPai

  --临时属性表(用于返回可操作牌型)
  local attribute = {
            ["Peng"] = {},--填每组能碰的牌，用表表示，以1开始，如第三第四张能碰，则填“{3,4}”
                    ["Chi"]  = {},--填每组能吃的牌，同上
                    ["Gang"] = {},--同上，填个三个数，如{7,8,9}
                    ["Ting"] = {},--填可以扔掉的牌，一位数，如{9}
                    ["Hu"]   = 0  --0表示不能胡，1表示能胡
            }

  --只有是上家牌才能吃
  if flag == 1
  then
    --吃
    attribute["Chi"] = CheckChiPai(userPai,aPai)
  end
  --不是自摸才能碰
  if flag ~= 0
  then
    --碰
    attribute["Peng"] = CheckPengPai(userPai,aPai)
  end

  --听
  --
  --胡(自摸)
  if flag == 0
  then
    if CheckHu(userPai,aPai) == true
    then
      attribute["Hu"] = 1
    end
  end

  --杠(判断胡牌后再判断自摸加杠)
  attribute["Gang"] = CheckGangPai(userPai,aPai,flag)


  return attribute
end



function CheckHuScore(userPai)
  -- 计算番数
  -- 此处用户牌userPai包含自摸牌
  if CheckDSX(userPai) == true
  then
    print("DSX")
  end
  if CheckDSY(userPai) == true
  then
    print("DSY")
  end
end


local function CheckHu(userPai,zimoPai)
  --测试胡牌
  --IN:用户牌，自摸牌
  --OUT：true-胡，false-不能胡


  local paiGroup = SortByType(userPai)
  --插入自摸牌
  local type = CheckSinglePaiType(zimoPai)
  table.insert(paiGroup["My"][type],zimoPai)
  table.sort( paiGroup["My"][type], function(a,b) return a<b end)

  -- 先检测特殊牌型 (十三幺 和 九莲宝灯), 要求传入原始的14张牌
  local t_pai = {}
  for i = 1,#userPai do
    table.insert(t_pai,userPai[i])
  end
  table.insert(t_pai,zimoPai)

  if CheckSSY(t_pai) or CheckJLBD(t_pai) then return true end
  -- 非十三幺，检测普通牌型

  local jiangPaiNum = 0   --通过将牌的测试判断胡
  for i=1,5
  do
    if #(paiGroup["My"][i]) == 2
    then
      if CheckAAPai(paiGroup["My"][i][1],paiGroup["My"][i][2]) == false
      then
        return false
      else
        jiangPaiNum=jiangPaiNum+1
      end
    elseif #(paiGroup["My"][i]) == 3
    then
      if Check3Pai(paiGroup["My"][i][1],paiGroup["My"][i][2],paiGroup["My"][i][3]) == false
      then
        return false
      end
    elseif #(paiGroup["My"][i]) == 5
    then
      if Check5Pai(paiGroup["My"][i][1],paiGroup["My"][i][2],paiGroup["My"][i][3],paiGroup["My"][i][4],paiGroup["My"][i][5]) == false
      then
        return false
      else
        jiangPaiNum=jiangPaiNum+1
      end
    elseif #(paiGroup["My"][i]) == 6
    then
      if Check6Pai(paiGroup["My"][i][1],paiGroup["My"][i][2],paiGroup["My"][i][3],paiGroup["My"][i][4],paiGroup["My"][i][5],paiGroup["My"][i][6]) == false
      then
        return false
      end
    elseif #(paiGroup["My"][i]) == 8
    then
      if Check8Pai(paiGroup["My"][i][1],paiGroup["My"][i][2],paiGroup["My"][i][3],paiGroup["My"][i][4],paiGroup["My"][i][5],paiGroup["My"][i][6],paiGroup["My"][i][7],paiGroup["My"][i][8]) == false
      then
        return false
      else
        jiangPaiNum=jiangPaiNum+1
      end
    elseif #(paiGroup["My"][i]) == 9
    then
      if Check9Pai(paiGroup["My"][i][1],paiGroup["My"][i][2],paiGroup["My"][i][3],paiGroup["My"][i][4],paiGroup["My"][i][5],paiGroup["My"][i][6],paiGroup["My"][i][7],paiGroup["My"][i][8],paiGroup["My"][i][9]) == false
      then
        return false
      end
    elseif #(paiGroup["My"][i]) == 11
    then
      if Check11Pai(paiGroup["My"][i][1],paiGroup["My"][i][2],paiGroup["My"][i][3],paiGroup["My"][i][4],paiGroup["My"][i][5],paiGroup["My"][i][6],paiGroup["My"][i][7],paiGroup["My"][i][8],paiGroup["My"][i][9],paiGroup["My"][i][10],paiGroup["My"][i][11]) == false
      then
        return false
      else
        jiangPaiNum=jiangPaiNum+1
      end
    elseif #(paiGroup["My"][i]) == 12
    then
      if Check12Pai(paiGroup["My"][i][1],paiGroup["My"][i][2],paiGroup["My"][i][3],paiGroup["My"][i][4],paiGroup["My"][i][5],paiGroup["My"][i][6],paiGroup["My"][i][7],paiGroup["My"][i][8],paiGroup["My"][i][9],paiGroup["My"][i][10],paiGroup["My"][i][11],paiGroup["My"][i][12]) == false
      then
        return false
      end
    elseif #(paiGroup["My"][i]) == 14
    then
      if Check14Pai(paiGroup["My"][i][1],paiGroup["My"][i][2],paiGroup["My"][i][3],paiGroup["My"][i][4],paiGroup["My"][i][5],paiGroup["My"][i][6],paiGroup["My"][i][7],paiGroup["My"][i][8],paiGroup["My"][i][9],paiGroup["My"][i][10],paiGroup["My"][i][11],paiGroup["My"][i][12],paiGroup["My"][i][13],paiGroup["My"][i][14]) == false
      then
        return false
      else
        jiangPaiNum=jiangPaiNum+1
      end
    end
  end

  if jiangPaiNum == 1
  then
    return true
  else
    return false
  end
end

local function PrintPai(userpai)
  for i = 1,#userpai do
    io.write(userpai[i],",")
  end
end
local function CheckHu_p(userPai)

  local t_pai = {}
  for i = 1,#userPai do
    table.insert(t_pai,userPai[i])
  end
  local zimopai = table.remove(t_pai)

  return CheckHu(t_pai,zimopai)

end

local function CheckPaiXing(userpai)

  if CheckHu_p(userpai) == false then return false end
  PrintPai(userpai)
  if CheckSSY(userpai)  == true then print("十三幺")  return true end
  if checkJLBD(userpai) == true then print("九莲宝灯") return true end
  if CheckDSX(userpai)  == true then print("大四喜") return true end
  if CheckDSY(userpai)  == true then print("大三元") return true end
  if CheckQYJ(userpai)  == true then print("清幺九") return true end
  if CheckZYS(userpai)  == true then print("字一色") return true end
  if CheckXSX(userpai)  == true then print("小三元") return true end
  if CheckHYJ(userpai)  == true then print("混幺九") return true end
  if CheckQP(userpai)   == true then print("清碰") return true end
  if CheckHP(userpai)   == true then print("混碰") return true end
  if CheckQYS(userpai)  == true then print("清一色") return true end
  if CheckHYS(userpai)  == true then print("混一色") return true end
  if CheckPPH(userpai)  == true then print("碰碰胡") return true end
  if CheckPH(userpai)   == true then print("平胡") return true end
  print("鸡胡")
end



local list = {
  {11,19,21,29,31,39,41,43,45,47,51,53,55,55},
--  {11,12,13,14,15,16,22,22,22,22,33,33,35,35},
--  -- 十三幺 成功
--  --{11,19,21,29,31,39, 41,43,45,47, 51,53,55}
--  {11,19,21,29,31,39,41,41,43,45,47,51,53,55},
--  {11,19,21,29,31,39,41,43,43,45,47,51,53,55},
--  {11,19,21,29,31,39,41,43,45,45,47,51,53,55},
--  {11,19,21,29,31,39,41,43,45,47,47,51,53,55},
--  {11,19,21,29,31,39,41,43,45,47,51,51,53,55},
--  {11,19,21,29,31,39,41,43,45,47,51,53,53,55},
--  {11,19,21,29,31,39,41,43,45,47,51,53,55,55},
--  -- 十三幺 失败
--  {11,11,19,21,29,31,39,41,43,45,47,51,53,55},
--  {11,19,19,21,29,31,39,41,43,45,47,51,53,55},
--  {11,19,21,21,29,31,39,41,43,45,47,51,53,55},
--  {11,19,21,29,29,31,39,41,43,45,47,51,53,55},
--  {11,19,21,29,31,31,39,41,43,45,47,51,53,55},
--  {11,19,21,29,31,39,39,41,43,45,47,51,53,55},

}

for i = 1,#list do
  CheckPaiXing(list[i])
end

-- --------------以下函数作测试用------------
-- temp = {0051,0051,0051,0053,0053,0053,0055,0055,0055,0045,0045,0045,0024}
-- atemp = {0011,0012,0012,0012,0013,0021,0022,0023,0031,0032,0033,0041,0042}
-- for i=1,#temp
-- do
--     print(temp[i])
-- end
-- print("")


-- att = CheckAll(temp,0024,0)

-- if #att["Peng"] ~= 0
-- then
--  print("peng")
--  for i=1,#att["Peng"]
--  do
--    print(string.format("group%d",i))
--    for j=1,#att["Peng"][i] do
--      print(att["Peng"][i][j])
--    end
--  end
-- else
--  print("no peng")
-- end

-- if #att["Chi"] ~= 0
-- then
--  print("chi")
--  for i=1,#att["Chi"]
--  do
--    print(string.format("group%d",i))
--    for j=1,#att["Chi"][i] do
--      print(att["Chi"][i][j])
--    end
--  end
-- else
--  print("no chi")
-- end

-- if #att["Gang"] ~= 0
-- then
--  print("gang")
--  for i=1,#att["Gang"]
--  do
--    print(string.format("group%d",i))
--    for j=1,#att["Gang"][i] do
--      print(att["Gang"][i][j])
--    end
--  end
-- else
--  print("no gang")
-- end

-- if att["Hu"] == 1
-- then
--  print("hu")
--  table.insert(temp,0024)
--  CheckHuScore(temp)
-- else
--  print("no hu")
-- end
