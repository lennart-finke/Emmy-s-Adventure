extends Node2D

onready var lower_leg = $LowerLeg
onready var upper_leg = $UpperLeg
onready var upper_arm = $UpperArm
onready var ski = $Ski

var v0
var acc
var connected = true

func _physics_process(delta):
	if Input.is_action_pressed("ui_down"):
		upper_leg.apply_torque_impulse(-5000 * delta)
		
	elif Input.is_action_pressed("ui_up"):
		upper_leg.apply_torque_impulse(5000 * delta)
		
	if Input.is_action_pressed("ui_left"):
		upper_arm.apply_torque_impulse(2000 * delta)
	elif Input.is_action_pressed("ui_right"):
		upper_arm.apply_torque_impulse(-2000 * delta)
	
	if v0:
		acc  = ((ski.linear_velocity  - v0) / delta).length()
	v0 = $Ski.linear_velocity
	
	
	if acc and connected:
		if 6000 < acc:
			connected = false
			ski.get_node("Clasp1").queue_free()
			ski.get_node("Clasp2").queue_free()
