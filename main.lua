--type Point []float64

--type Group []Point

function file_exists(file)
    local f = io.open(file, "rb")
    if f then f:close() end
    return f ~= nil
end

function lines_from(file)
    lines = {}
    for line in io.lines(file) do
        lines[#lines + 1] = line
    end
    return lines
end

-- local file = "teste.txt"
-- local lines = lines_from(file)
-- for k,v in pairs(lines) do
--     print('line[' .. k .. ']', v)
-- end

function createPoint(id, line)
	local newpoint = {}
	newpoint["id"] = id
	newpoint["coordenadas"] = {}
	for coordenada in string.gmatch(line, "%S+") do
		newpoint[#newpoint.coordenadas+1] = tonumber(coordenada)
	end
	return newpoint
end

function storePoints(fileName) {
	local file = io.Open(fileName, "r") --Abrindo arquivo
	if file then
		file:close()
		print("Erro: não foi possível abrir o arquivo")
		return nil
	end
	lines = lines_from(file)
	vecPoints = {}

	for k,v in pairs(lines) do
		point = createPoint(k,v)
		vecPoints[point.id] = point
	end
	return vecPoints
end
	-- 	if i == 0 {
	-- 		firstline = scanner.Text()
	-- 		//fmt.Println(firstline)
	-- 		firstreader = strings.NewReader(firstline)
	-- 		for {
	-- 			_, err = fmt.Fscan(firstreader, &myfloat)
	-- 			if err != nil {
	-- 				break;
	-- 			}
	-- 			p = append(p, myfloat)
	-- 			dim++ 
	-- 		}
	-- 		p = append(p, float64(i+1)) // O último elemento representa a linha em que o ponto foi lido
	-- 		vecPoint = append(vecPoint, p)
	-- 		//fmt.Println(dim)
	-- 		//fmt.Println("Passou a primeira linha")
	-- 	}else {
	-- 		//fmt.Println("Próxima linha")
	-- 		line = scanner.Text()
	-- 		//fmt.Println(line)
	-- 		reader = strings.NewReader(line)
	-- 		p = nil
	-- 		for j = 0; j < dim; j++ {
	-- 			fmt.Fscan(reader, &myfloat)
	-- 			p = append(p,myfloat)
	-- 		}
	-- 		p = append(p, float64(i+1)) // O último elemento representa a linha em que o ponto foi lido
	-- 		vecPoint = append(vecPoint,p)
	-- 		//printSlice(vecPoint)
	-- 	}
	-- 	i++
	-- }
	-- return vecPoint, dim

function main() 
	local fileName1 = "distancia.txt"
	local fileName2 = "entrada.txt"

	limit = getLimit(fileName1)
	vecPoint = storePoints(fileName2)
	--fmt.Println(dim)
	--printSlice(vecPoint)
	--fmt.Println(vecPoint[0])
	groups = lider(vecPoint, limit, dim)
	sse = calcSSE(groups, dim)
	fmt.Println(sse)
end

function lider(vecPoint, limit, dim) 
	groups = {}
	for j = 1, #vecPoints do
		point = vecPoints[j]
		lider = true
		for i = 1,#groups do
			ptl = groups[i][1]
			dist = getDistance(point, ptl, dim)
			if(dist <= limit)
				groups[i][#groups[i]+1] = point
				lider = false
				break
			end
		end
		if (lider)
			groups[#groups+1] = {}
			groups[#groups] = {}
			groups[#groups][1] = point
		end
	end
	
	-- //fmt.Println("DENTRO DA LÍDER")
	-- //printGroups(groups, len(groups))
	return groups
}

func calcSSE(groups [][]Point, dim int) float64 {
	var sse float64
	for i = 0; i < len(groups); i++ {
		c = calcCentroid(groups[i], dim)
		for _, pt = range groups[i] {
			x = getDistance(c, pt, dim)
			//fmt.Println(x)
			sse = sse + x*x
		}
	}
	return sse	
}

func calcCentroid(group []Point, dim int) Point {
	n = len(group)
	var c Point
	for j = 0; j < dim; j++ {
		c = append(c,group[0][j])
	}
	for i = 1; i < n; i++ {
		for j = 0; j < dim; j++ {
			c[j] = c[j] + group[i][j]
		}
	}
	for j = 0; j < dim; j++ {
		c[j] = c[j] / float64(n)
	}
	//fmt.Println(c)
	return c
}

func makeGroup(lider Point) ([]Point) {
	return []Point{lider}
}

function getDistance(pt1, pt2)
	soma = 0
	for i = 0, #pt1.coordenadas do
		soma = soma + ((pt1[i] - pt2[i])*(pt1[i] - pt2[i]))
	end
	distancia = math.Sqrt(soma)
	return distancia
end

func printGroups(groups [][]Point, tam int){
	for i = 0; i < tam; i++ {
		printSlice(groups[i])
	} 
}

function getLimit(fileName)
	local file = io.Open(fileName, "r") --Abrindo arquivo
	if file then
		file:close()
		print("Erro: não foi possível abrir o arquivo")
		return nil
	end
	limit = tonumber(io.read())
	return limit
end


-- func printSlice(s []Point) {
-- 	fmt.Printf("len=%d cap=%d %v\n", len(s), cap(s), s)
-- }