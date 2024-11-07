extends Control

# text probably needs an annotation but i'm unsure which one would be most appropriate
var text_data 
var char_per_line:int = 50


var player_cursor:int = 0
var player_line = 0:
	set(new):
		player_line=new
		text_set()
		
func text_set():
	$TextInterface/TextDisplay.text = text_data[player_line][1] # text for uncompleted letters
	$TextInterface/CPUText.text 	= text_data[player_line][1] # text to show enemy ahead
	$TextInterface/PlayerText.text  = text_data[player_line][1] # text to show player ahead
	$TextInterface/SharedText.text  = text_data[player_line][1] # text completed by both enemy and player

var computer_cursor:int = 0
var computer_line = 0
var WPM_delay_accumulator:float = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text_data = Utility.lyrics_from_lrc_file("res://Songs/EverybodyLovesMyBaby/everybody_loves_my_baby.lrc")
	text_set()
	sync_text_elements()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	update_CPU_cursor(delta)
	update_text_interface_single_line()

func sync_text_elements() -> void:
	pass #TODO format of all text elements needs to be identical or else display will not function properly.

func _input(event):
	if event is InputEventKey and event.is_pressed:
		if player_line>=len(text_data):
			return #TODO what if you win
		# Enter doesn't work with the other method. also having more than one correct input for return characters might make the gameplay flow better.
		if event.is_action_pressed("ui_accept"):
			if player_cursor>=text_data[player_line][1].length(): # and "\n".unicode_at(0) == text_data[player_line][1].unicode_at(player_cursor):
				player_cursor = 0
				player_line += 1
		var key = event.unicode
		if not key:
			return
		# TODO remove this debug print
		print("DEBUG: KeyPressed: ",String.chr(key)) 
		if player_cursor<text_data[player_line][1].length() and key == text_data[player_line][1].unicode_at(player_cursor):
			player_cursor += 1
		

func update_text_interface_single_line() -> void:
	#guard cases
	if player_line>len(text_data) or computer_line>len(text_data):
		return
	# if enemy is on same line as player background is default, leader is themselves, loser is shared
	if computer_line == player_line:
		$TextInterface/TextDisplay.visible_characters = -1
		if player_cursor<computer_cursor:
			$TextInterface/CPUText.visible_characters = computer_cursor
			$TextInterface/SharedText.visible_characters = player_cursor
		else:
			$TextInterface/PlayerText.visible_characters = player_cursor
			$TextInterface/SharedText.visible_characters = computer_cursor
	# else if enemy is ahead, background is enemy and player is shared
	elif computer_line>player_line:
		$TextInterface/CPUText.visible_characters = -1
		$TextInterface/SharedText.visible_characters = player_cursor
	# else enemy is behind so background is default and player is player
	else:
		$TextInterface/TextDisplay.visible_characters = -1
		$TextInterface/PlayerText.visible_characters = player_cursor

func update_CPU_cursor(delta):
	match GlobalGameSettings.cpu_cursor_mode:
		GlobalGameSettings.CPUPlayerMode.WPM:
			if computer_line>=len(text_data):
				return
			WPM_delay_accumulator += delta
			if WPM_delay_accumulator > GlobalGameSettings._char_delay:
				WPM_delay_accumulator -= GlobalGameSettings._char_delay
				computer_cursor += 1
				if computer_cursor>=text_data[computer_line][1].length()-1:
					computer_cursor = 0
					computer_line+=1
		GlobalGameSettings.CPUPlayerMode.Disabled:
			pass
		GlobalGameSettings.CPUPlayerMode.SongSync:
			pass # TODO make me work
