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
