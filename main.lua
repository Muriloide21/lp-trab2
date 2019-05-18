function lines_from(file)
    lines = {}
    for line in io.lines(file) do
        lines[#lines + 1] = line
    end
    return lines
end

function createPoint(id, line)
	local newpoint = {}
	newpoint["id"] = id
	newpoint.coordenadas = {}
	n = 0
	for coordenada in string.gmatch(line, "%S+") do
		n = n+1
		newpoint.coordenadas[n] = tonumber(coordenada)
	end
	return newpoint
end

function storePoints(fileName) 
	-- if file then
	-- 	file:close()
	-- 	print("Erro: não foi possível abrir o arquivo")
	-- 	return nil
	-- end
	lines = lines_from(fileName)
	vecPoints = {}

	for k,v in pairs(lines) do
		point = createPoint(k,v)
		-- for j = 1, #point.coordenadas do
		-- 	print(point.coordenadas[j])
		-- end
		vecPoints[#vecPoints+1] = point
	end
	return vecPoints
end

function lider(vecPoints, limit, dim) 
	groups = {}
	for j = 1, #vecPoints do
		point = vecPoints[j]
		lider = true
		for i = 1,#groups do
			ptl = groups[i][1]
			dist = getDistance(point, ptl, dim)
			-- print(dist)
			if(dist <= limit) then
				groups[i][#groups[i]+1] = point
				lider = false
				break
			end
		end
		if (lider) then
			groups[#groups+1] = {}
			groups[#groups] = {}
			groups[#groups][1] = point
		end
	end
	-- printGroups(groups)
	return groups
end

function calcSSE(groups, dim)
	sse = 0
	for i = 1, #groups do
		centro = calcCentroid(groups[i], dim)
		for j = 1, #groups[i] do
			point = groups[i][j]
			x = getDistance(centro, point, dim)
			-- //fmt.Println(x)
			sse = sse + x*x
		end
	end
	return sse	
end

function calcCentroid(group, dim)
	n = #group
	local centro = {}
	centro.coordenadas = {}
	for j = 1, dim do
		centro.coordenadas[j] = group[1].coordenadas[j]
	end
	for i = 2, n do
		for j = 1, dim do
			centro.coordenadas[j] = centro.coordenadas[j] + group[i].coordenadas[j]
		end
	end
	for j = 1, dim do
		centro.coordenadas[j] = centro.coordenadas[j] / (n)
	end
	-- //fmt.Println(c)
	return centro
end

function getDistance(pt1, pt2, dim)
	local soma = 0
	for i = 1, dim do
		soma = soma + ((pt1.coordenadas[i] - pt2.coordenadas[i])*(pt1.coordenadas[i] - pt2.coordenadas[i]))
	end
	-- print(soma)
	distancia = math.sqrt(soma)
	return distancia
end

function printGroups(groups)
	for i = 1,#groups do
		print("Grupo", i)
		printPoints(groups[i])
	end
end

function getLimit(fileName)
	dist = 0
    for line in io.lines(fileName) do
        dist = tonumber(line)
        break
    end
    return dist
end

function printPoints(points) 
	for i = 1, #points do
		print(points[i].id)
	end
end

function printOutput(groups)
	local output = io.open("saida.txt", "w")
	for i = 1, #groups do
		for j = 1, #groups[i] do
			output:write(groups[i][j].id)
			if j ~= #groups[i] then
				output:write(" ")
			end
		end
		if i ~= #groups then
			output:write("\n\n")
		end
	end
	output:close()
end

function printResult(sse)
	local file = io.open("result.txt", "w")
	file:write(string.format("%.4f", sse))
	file:close()
end

function main() 
	limit = getLimit("distancia.txt")
	-- print(limit)
	vecPoints = storePoints("entrada.txt")
	-- printPoints(vecPoints)
	--fmt.Println(dim)
	--printSlice(vecPoint)
	--fmt.Println(vecPoint[0])
	dim = #vecPoints[1].coordenadas
	groups = lider(vecPoints, limit, dim)
	sse = calcSSE(groups, dim)
	-- print(sse)
	printOutput(groups)
	printResult(sse)
end

main()