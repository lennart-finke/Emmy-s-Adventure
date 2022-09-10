tool
extends StaticBody2D

onready var collision_polygon = $CollisionPolygon2D
onready var polygon = $Polygon2D
onready var expression = Expression.new()

func calculate_shape(command : String) -> String:
	# The polygon's shape is calculated based on the function lambda
	var error = expression.parse(command, ["x"])
	if error != OK:
		return expression.get_error_text()
		
	
	var array = [PoolVector2Array()]
	
	for i in range(200):
		var temp = expression.execute([10 * i], null)
		if temp == null:
			return "Invalid expression!"
		array.append(Vector2(10 * i, temp))
	
	array.append(Vector2(2000, max(expression.execute([2000], null) + 3000, expression.execute([0], null) + 3000)))
	array.append(Vector2(0, max(expression.execute([2000], null) + 3000, expression.execute([0], null) + 3000)))
	
	collision_polygon.set_polygon(array)
	polygon.set_polygon(array)
	
	return ""

