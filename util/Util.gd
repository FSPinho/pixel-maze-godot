extends Node

func sigmoid(n, _min = 0, _max = 1, smoothness = 0.004):
	var E = 2.718281
	return max(
		_min, 
		(_max - _min) * 2 / (1 + pow(E, -1 * smoothness * (n - _min))) - 
		(_max - _min) + _min
	)


func animate(n: float, from: float, to: float, speed: float, delta: float, loop: bool = false):
	var res = min(n + speed * delta, to)
	
	if loop and abs(res - to) < 0.01:
		res = from
	
	return res


func zero_matrix(nX, nY):
	var matrix = []
	for x in range(nX):
		matrix.append([])
		for y in range(nY):
			matrix[x].append(0)
	return matrix


func multiply(a, b):
	var matrix = zero_matrix(a.size(), b[0].size())
	for i in range(a.size()):
		for j in range(b[0].size()):
			for k in range(a[0].size()):
				matrix[i][j] = matrix[i][j] + a[i][k] * b[k][j]
	return matrix


func to_vector_array(matrix):
	var _matrix = []
	for vec in matrix:
		_matrix.append([vec.x, vec.y])
	
	return _matrix


func interpolate_segment(points, t, s = 0.5):
	points = to_vector_array(points)
	if points.size() == 4:
		var sc = [[pow(t, 3), pow(t, 2), t, 1]];
		var cr = [
		  [-s,     2 - s,  s - 2,       s],
		  [2 * s,  s - 3,  3 - 2 * s,  -s],
		  [-s,     0,      s,           0],
		  [0,      1,      0,           0]
		];
		var pt = points;
		var p = Util.multiply(Util.multiply(sc, cr), pt);
		return Vector2(p[0][0], p[0][1]);  
	return Vector2(0, 0);
	
	
func interpolate(points: Array, step = 0.1):
	if points.size() >= 2:
		var ps = []
		
		for i in range(points.size()):
			var p1 = points[i] if i == 0 else points[i - 1]
			var p2 = points[i]
			var p3 = points[i] if i == points.size() - 1 else points[i + 1]
			var p4 = null if i >= points.size() - 1 else points[i + 1] if i >= points.size() - 2 else points[i + 2]
			
			if p1 != null and p2 != null and p3 != null and p4 != null:
				var t = 0.0
				while t <= 1.0:
					ps.append(interpolate_segment([p1, p2, p3, p4], t))
					t += step
		
		return ps
	return points
	
	
func interpolate_point(interpolation: Array, t: float):
	t = min(max(t, 0), 1)
	var index = round((interpolation.size() - 1) * t)
	return interpolation[index]
	

func draw_interpolation(node: Node2D, interpolation: Array):
	var last_point = null
	for point in interpolation:
		if last_point:
			node.draw_line(last_point - node.position, point - node.position, Color.red, 1, true)
		
		node.draw_circle(point - node.position, 10, Color.blue)
		last_point = point
