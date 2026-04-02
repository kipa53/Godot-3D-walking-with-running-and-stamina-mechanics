@tool
extends Control

func _draw() -> void:
	draw_circle(Vector2.ZERO, 1, Color.GREEN_YELLOW)
	draw_circle(Vector2.ZERO, 2, Color.GREEN)
	
	draw_line(Vector2(10,0),Vector2(14,0), Color.GREEN,2)
	draw_line(Vector2(-10,0),Vector2(-14,0), Color.GREEN,2)
	draw_line(Vector2(0,10),Vector2(0,14), Color.GREEN,2)
	draw_line(Vector2(0,-10),Vector2(0,-14), Color.GREEN,2)
