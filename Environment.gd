extends Node
var skiing : bool = false
var finished : bool = false
var times_button_pressed : int = 0
var button_pressed_limit : int = 18
var latex_string : String = "-x"
var expression_string : String = "-x"
var history = [["", ""], ["-", "-"], [latex_string, expression_string]]

onready var UI = $UI
onready var latex = $LaTeX
onready var slope = $Slope
onready var animator = $EstablishingCamera/AnimationPlayer
onready var error_label = $UI/MarginContainer/VBoxContainer/HBoxContainer/ErrorLabel
onready var left_label = $UI/MarginContainer/VBoxContainer/HBoxContainer/LeftLabel
var skier = preload("res://Scenes/Skier.tscn")
var player
var player_head
var previous_pos = 0

func _ready():
	slope.calculate_shape("-(" + expression_string + ")")
	latex.LatexExpression = "f(x) = " + latex_string
	latex.Render()

func _process(_delta):
	if Input.is_action_just_pressed("ui_accept") and not skiing:
		skiing = true
		UI.visible = false
		animator.play("Pan")
	if Input.is_action_just_pressed("reset"):
		if not skiing:
			Redo()
		else:
			var _result = get_tree().reload_current_scene()
	
	if player_head != null:
		if player_head.position.x > 1950 or finished:
			var pos = player_head.position.x
			if abs(previous_pos - pos) > 1:
				previous_pos = pos
				latex.global_position = player_head.global_position + Vector2(0, -100)
				latex.LatexExpression = "\\text{You leaped }" + "%.1f" % (round((player_head.position.x) - 1950)/10) + "\\;\\text{m}!"
				latex.Render()

func start_skiing():
	var skier_instance = skier.instance()
	skier_instance.position.y = -50
	add_child(skier_instance)
	$CPUParticles2D.emitting = true
	$ParallaxBackground.get_node("AnimationPlayer").play("fadein")
	
	player = $Skier
	player_head = player.get_node("LowerLeg")
	latex.position = player_head.position + Vector2(0, -100)
	latex.scale = Vector2(0.5,0.5)
	latex.LatexExpression = ""
	latex.Render()

func end_skiing():
	finished = true
	skiing = false
	
	player.set_script(null)

func _on_SinButton_pressed():
	if not skiing and times_button_pressed < button_pressed_limit:
		latex_string = latex_string + "\\sin "
		expression_string = expression_string + "sin"
		Render()

func _on_XButton_pressed():
	if not skiing and times_button_pressed < button_pressed_limit:
		latex_string = latex_string + "x"
		expression_string = expression_string + "x"
		Render()

func _on_PlusButton_pressed():
	if not skiing and times_button_pressed < button_pressed_limit:
		latex_string = latex_string + "+"
		expression_string = expression_string + "+"
		Render()

func _on_MinusButton_pressed():
	if not skiing and times_button_pressed < button_pressed_limit:
		latex_string = latex_string + "-"
		expression_string = expression_string + "-"
		Render()


func _on_TwoButton_pressed():
	if not skiing and times_button_pressed < button_pressed_limit:
		latex_string = latex_string + "2"
		expression_string = expression_string + "2"
		Render()

func _on_BracketLeftButton_pressed():
	if not skiing and times_button_pressed < button_pressed_limit:
		latex_string = latex_string + "("
		expression_string = expression_string + "("
		Render()


func _on_BracketRightButton_pressed():
	if not skiing and times_button_pressed < button_pressed_limit:
		latex_string = latex_string + ")"
		expression_string = expression_string + ")"
		Render()


func _on_TimesButton_pressed():
	if not skiing and times_button_pressed < button_pressed_limit:
		latex_string = latex_string + "\\times "
		expression_string = expression_string + "*"
		Render()

func Redo():
	if len(history) == 1:
		return

	times_button_pressed -= 1
	left_label.text = "You have " + str(button_pressed_limit - times_button_pressed) + " keystroke(s) left."
	history.pop_back()
	var temp : Array = history.back()
	latex_string = temp[0]
	expression_string = temp[1]

	latex.LatexExpression = "f(x) = " + latex_string
	error_label.text = slope.calculate_shape("-(" + expression_string + ")")
	
	
	latex.Render()

func Render():
	times_button_pressed += 1
	left_label.text = "You have " + str(button_pressed_limit - times_button_pressed) + " keystroke(s) left."
	latex.LatexExpression = "f(x) = " + latex_string
	latex.Render()
	
	var error_text = slope.calculate_shape("-(" + expression_string + ")")
	error_label.text = error_text

	history.append([latex_string, expression_string])


func _on_Power2Button_pressed():
	if not skiing and times_button_pressed < button_pressed_limit:
		latex_string = "(" + latex_string + ")^2"
		expression_string = "pow(" + expression_string + ", 2)"
		Render()


func _on_NaughtButton_pressed():
	if not skiing and times_button_pressed < button_pressed_limit:
		latex_string = latex_string + "0"
		expression_string = expression_string + "0"
		Render()


func _on_PointButton_pressed():
	if not skiing and times_button_pressed < button_pressed_limit:
		latex_string = latex_string + "."
		expression_string = expression_string + "."
		Render()

func _on_Detector_body_entered(body):
	if skiing and body.name != "Ski":
		# The player has entered the detector
		end_skiing()


func _on_SevenButton_pressed():
	if not skiing and times_button_pressed < button_pressed_limit:
		latex_string = latex_string + "7"
		expression_string = expression_string + "7"
		Render()
