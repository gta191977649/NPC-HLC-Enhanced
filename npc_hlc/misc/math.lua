local cos = math.cos
local sin = math.sin
local mathAtan2 = math.atan2
local degToPi = math.pi/180
local getElementPosition = getElementPosition
local getElementRotation = getElementRotation


function angleWrapping(x)
    x = x % 360
    if x < 0 then
        x = x + 360
	end
    return x
end
function getPercentageInLine(x,y,x1,y1,x2,y2)
	x,y = x-x1,y-y1
	local yx,yy = x2-x1,y2-y1
	return (x*yx+y*yy)/(yx*yx+yy*yy)
end

function getAngleInBend(x,y,x0,y0,x1,y1,x2,y2)
	x,y = x-x0,y-y0
	local yx,yy = x1-x0,y1-y0
	local xx,xy = x2-x0,y2-y0
	local rx = (x*yy-y*yx)/(xx*yy-xy*yx)
	local ry = (x*xy-y*xx)/(yx*xy-yy*xx)
	return mathAtan2(rx,ry)
end

function getPosFromBend(ang,x0,y0,x1,y1,x2,y2)
	local yx,yy = x1-x0,y1-y0
	local xx,xy = x2-x0,y2-y0
	local rx,ry = sin(ang),cos(ang)
	return
		rx*xx+ry*yx+x0,
		rx*xy+ry*yy+y0
end

--[[
function getPositionFromElementOffset(element,offX,offY,offZ)
    local m = getElementMatrix ( element )  -- Get the matrix
    local x = offX * m[1][1] + offY * m[2][1] + offZ * m[3][1] + m[4][1]  -- Apply transform
    local y = offX * m[1][2] + offY * m[2][2] + offZ * m[3][2] + m[4][2]
    local z = offX * m[1][3] + offY * m[2][3] + offZ * m[3][3] + m[4][3]
    return x, y, z                               -- Return the transformed point
end
--]]

function getPositionFromElementOffset(element,offx,offy,offz)
	local x,y,z = getElementPosition(element)
	local rx,ry,rz = getElementRotation(element)
    local rx,ry,rz = rx*degToPi,ry*degToPi,rz*degToPi
	local rxCos,ryCos,rzCos,rxSin,rySin,rzSin = cos(rx),cos(ry),cos(rz),sin(rx),sin(ry),sin(rz)
	m11,m12,m13,m21,m22,m23,m31,m32,m33 = rzCos*ryCos-rzSin*rxSin*rySin,ryCos*rzSin+rzCos*rxSin*rySin,-rxCos*rySin,-rxCos*rzSin,rzCos*rxCos,rxSin,rzCos*rySin+ryCos*rzSin*rxSin,rzSin*rySin-rzCos*ryCos*rxSin,rxCos*ryCos
	return offx*m11+offy*m21+offz*m31+x,offx*m12+offy*m22+offz*m32+y,offx*m13+offy*m23+offz*m33+z
end

function getPositionFromOffsetByPosRot(x,y,z,rx,ry,rz,offx,offy,offz)
    local rx,ry,rz = rx*degToPi,ry*degToPi,rz*degToPi
	local rxCos,ryCos,rzCos,rxSin,rySin,rzSin = cos(rx),cos(ry),cos(rz),sin(rx),sin(ry),sin(rz)
	m11,m12,m13,m21,m22,m23,m31,m32,m33 = rzCos*ryCos-rzSin*rxSin*rySin,ryCos*rzSin+rzCos*rxSin*rySin,-rxCos*rySin,-rxCos*rzSin,rzCos*rxCos,rxSin,rzCos*rySin+ryCos*rzSin*rxSin,rzSin*rySin-rzCos*ryCos*rxSin,rxCos*ryCos
	return offx*m11+offy*m21+offz*m31+x,offx*m12+offy*m22+offz*m32+y,offx*m13+offy*m23+offz*m33+z
end

function getRotationMatrix(rx,ry,rz)
    local rx,ry,rz = -rx*degToPi,-ry*degToPi,rz*degToPi
	local rxCos,ryCos,rzCos,rxSin,rySin,rzSin = cos(rx),cos(ry),cos(rz),sin(rx),sin(ry),sin(rz)
	return rzCos*ryCos-rzSin*rxSin*rySin,ryCos*rzSin+rzCos*rxSin*rySin,-rxCos*rySin,-rxCos*rzSin,rzCos*rxCos,rxSin,rzCos*rySin+ryCos*rzSin*rxSin,rzSin*rySin-rzCos*ryCos*rxSin,rxCos*ryCos
end

function getPositionFromOffsetByRotMatrix(x,y,z,offx,offy,offz,m11,m12,m13,m21,m22,m23,m31,m32,m33)
	return offx*m11+offy*m21+offz*m31+x,offx*m12+offy*m22+offz*m32+y,offx*m13+offy*m23+offz*m33+z
end

<<<<<<< HEAD:npc_hlc/vendor/math.lua
function findRotation( x1, y1, x2, y2 ) 
    local t = -math.deg( math.atan2( x2 - x1, y2 - y1 ) )
    return t < 0 and t + 360 or t
end
=======
>>>>>>> evenmov:npc_hlc/misc/math.lua
