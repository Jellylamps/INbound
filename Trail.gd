extends Line2D

var queue : Array

func _process(_delta):
	var pos = get_parent().position
	queue.push_front(pos)
	if queue.size() > 50:
		queue.pop_back()
	clear_points()
	for point in queue:
		add_point(point)

func clear():
	queue.clear()
