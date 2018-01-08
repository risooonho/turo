extends Node2D

onready var PreParto = get_node("PreParto")
onready var Kamero = get_node("Kamero")
onready var Fono = get_node("Fono")
onready var V_rulumilo = get_node("Kanvaso/V_rulumilo")
onready var vido_Materialo = get_node("Kanvaso/vido_Materialo")
onready var Partoj = get_node("Partoj")
onready var Materialoj = get_node("Materialoj")
onready var C3_spiccato = get_node("C3_spiccato")
onready var C5_spiccato = get_node("C5_spiccato")
onready var E3_spiccato = get_node("E3_spiccato")
onready var E5_spiccato = get_node("E5_spiccato")
onready var G3_spiccato = get_node("G3_spiccato")
onready var G5_spiccato = get_node("G5_spiccato")
onready var C3_pizzicato = get_node("C3_pizzicato")
onready var C5_pizzicato = get_node("C5_pizzicato")
onready var Kreski_sono  = get_node("Kreski_sono")
onready var Materialo1_sono  = get_node("Materialo1_sono")
onready var Materialo2_sono  = get_node("Materialo2_sono")
onready var Materialo3_sono  = get_node("Materialo3_sono")
onready var Materialo4_sono  = get_node("Materialo4_sono")
onready var Materialo5_sono  = get_node("Materialo5_sono")
#onready var FPS = get_node("Kanvaso/FPS")
onready var Parto = preload("res://Parto.tscn")
onready var Materialo = preload("res://Materialo.tscn")
onready var Celo = preload("res://Celo.tscn")

var Celo_ = null

var alto = 0

var oktavo = 3

var fonkoloroj = ["E53935", "FB8C00", "FDD835",
					"7CB342", "039BE5", "8E24AA"
				]

func _ready():
	T.Radiko = self
	T.materialo = 100
	if T.modo == 0:
		var Senfinfino = get_node("Senfinfino")
		Senfinfino.set_global_pos(Vector2(0,-101300))
		Senfinfino.show()
		V_rulumilo.set_min(-101000)
		for i in range(-101000, 0, 250):
			randomize()
			var Materialo_ = Materialo.instance()
			var materialo = int(rand_range(50,200))
			Materialo_.materialo = materialo/2.5
			Materialo_.set_scale(Vector2(materialo/50, materialo/50))
			Materialo_.set_global_pos(
				Vector2(rand_range(300-materialo,300+materialo),
				i
			))
			Materialoj.add_child(Materialo_)
	else:
		V_rulumilo.hide()
		Kamero.set_offset(Vector2(Kamero.get_offset().x,-600))
		Fono.set_global_pos(Kamero.get_offset()+Vector2(-300,-500))
		Fono.set_color(fonkoloroj[T.nivelo%6])
		Celo_ = Celo.instance()
		Celo_.set_global_pos(Vector2(300,-950))
		add_child(Celo_)
		for i in range(-800, -200, 50):
			for j in range(2):
				randomize()
				var Materialo_ = Materialo.instance()
				var materialo = int(rand_range(50,100))
				Materialo_.materialo = materialo/2.5
				Materialo_.set_scale(Vector2(materialo/50, materialo/50))
				Materialo_.set_global_pos(
					Vector2(rand_range(300-materialo,300+materialo),
					i+rand_range(0,100)
				))
				Materialoj.add_child(Materialo_)
	set_process_input(true)
	set_fixed_process(true)
#	set_process(true)

func _input(evento):
	if evento.type == InputEvent.MOUSE_BUTTON:
		if evento.button_index == BUTTON_LEFT:
			if evento.pos.y > 70 and (T.modo == 1 or evento.pos.x < 570):
				if evento.is_pressed() and T.materialo > 0:
					PreParto.set_scale(Vector2(1,1))
					PreParto.set_global_pos(get_global_mouse_pos())
					PreParto.show()
					Kreski_sono.stop()
					Kreski_sono.set("stream/play", T.Agordejo.get_value("Agordoj", "Sonoj", true))
				elif PreParto.is_visible():
					PreParto.hide()
					Kreski_sono.stop()
					if oktavo == 3:
						if alto < 1000:
							C3_spiccato.set("stream/play", T.Agordejo.get_value("Agordoj", "Sonoj", true))
						elif alto >= 4000:
							G3_spiccato.set("stream/play", T.Agordejo.get_value("Agordoj", "Sonoj", true))
						elif alto >= 1000:
							E3_spiccato.set("stream/play", T.Agordejo.get_value("Agordoj", "Sonoj", true))
						oktavo = 5
					elif oktavo == 5:
						if alto < 1000:
							C5_spiccato.set("stream/play", T.Agordejo.get_value("Agordoj", "Sonoj", true))
						elif alto >= 4000:
							G5_spiccato.set("stream/play", T.Agordejo.get_value("Agordoj", "Sonoj", true))
						elif alto >= 1000:
							E5_spiccato.set("stream/play", T.Agordejo.get_value("Agordoj", "Sonoj", true))
						oktavo = 3
					var Parto_ = Parto.instance()
					Parto_.set_global_pos(PreParto.get_global_pos())
					var Formo_ = RectangleShape2D.new()
					Formo_.set_extents(Vector2(10,10)*PreParto.get_scale())
					Parto_.add_shape(Formo_)
					Parto_.set_mass(PreParto.get_scale().x/100)
					Parto_.set_sleeping(false)
					Partoj.add_child(Parto_)
					Parto_.Aspekto.set_scale(PreParto.get_scale())
		
		elif evento.button_index == BUTTON_WHEEL_UP and T.modo == 0:
			V_rulumilo.set_value(V_rulumilo.get_value()-100)
		elif evento.button_index == BUTTON_WHEEL_DOWN and T.modo == 0:
			V_rulumilo.set_value(V_rulumilo.get_value()+100)
	elif evento.type == InputEvent.MOUSE_MOTION:
		if evento.pos.y > 70 and (T.modo == 1 or evento.pos.x < 570):
			PreParto.set_global_pos(get_global_mouse_pos())

func _fixed_process(delta):
	if PreParto.is_visible() and T.materialo > 0:
		var faktoro = PreParto.get_scale().x
		faktoro += 1/faktoro
#		PreParto.set_scale(PreParto.get_scale()+Vector2(0.1,0.1))
		PreParto.set_scale(Vector2(faktoro,faktoro))
		T.materialo -= 1
	elif T.materialo <= 0:
		Kreski_sono.stop()

#func _process(delta):
#	FPS.set_text(str(int(1.0/delta)))

func _on_H_rulumilo_value_changed( valoro ):
	Kamero.set_offset(Vector2(valoro,Kamero.get_offset().y))
	Fono.set_global_pos(Kamero.get_offset()+Vector2(-300,-500))

func _on_V_rulumilo_value_changed( valoro ):
	Kamero.set_offset(Vector2(Kamero.get_offset().x,valoro))
	Fono.set_global_pos(Kamero.get_offset()+Vector2(-300,-500))

func _on_Rekomencu_pressed():
	get_tree().reload_current_scene()

func _on_T200_timeout():
	for Parto_ in Partoj.get_children():
		if Parto_.get_layer_mask_bit(0):
			Parto_.get_linear_velocity().x

func _on_Reen_pressed():
	get_tree().change_scene("res://Menuo.tscn")