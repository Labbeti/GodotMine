extends Panel


# Declare member variables here. Examples:
var count = 0
# var b = "text"


func _init():
	pass

func _ready():
	# This function is called after _enter_tree, but it ensures
	# that all children nodes have also entered the Scene Tree,
	# and became active.
	
	# add_to_group("enemies")
	# get_tree().call_group("enemies", "player_was_discovered")
	get_node("Button").connect("pressed", self, "_on_Button_button_down")
	get_node("Label").text = str(self.count)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Button_button_down():
	self.count += 1
	get_node("Label").text = str(self.count)


func _enter_tree():
	# When the node enters the Scene Tree, it becomes active
	# and  this function is called. Children nodes have not entered
	# the active scene yet. In general, it's better to use _ready()
	# for most cases.
	pass

func _exit_tree():
	# When the node exits the Scene Tree, this function is called.
	# Children nodes have all exited the Scene Tree at this point
	# and all became inactive.
	pass

func _process(delta):
	# This function is called every frame.
	pass

func _physics_process(delta):
	# This is called every physics frame.
	pass
