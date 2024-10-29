extends Control

# text probably needs an annotation but i'm unsure which one would be most appropriate
var text_data 
var text
var char_per_line:int = 50


var player_cursor:int = 0
var computer_cursor:int = 0
var WPM_delay_accumulator:float = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text_data = Utility.lyrics_from_lrc_file("res://Songs/EverybodyLovesMyBaby/everybody_loves_my_baby.lrc")
	text = Utility.just_text_from_data(text_data)
	sync_text_elements()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	update_CPU_cursor(delta)
	update_text_interface_single_line()

func sync_text_elements() -> void:
	pass #TODO format of all text elements needs to be identical or else display will not function properly.

func _input(event):
	if event is InputEventKey and event.is_pressed:
		# Enter doesn't work with the other method. also having more than one correct input for return characters might make the gameplay flow better.
		if event.is_action_pressed("ui_accept"):
			if player_cursor<text.length() and "\n".unicode_at(0) == text.unicode_at(player_cursor):
				player_cursor += 1
		var key = event.unicode
		if not key:
			return
		# TODO remove this debug print
		print("DEBUG: KeyPressed: ",String.chr(key)) 
		if player_cursor<text.length() and key == text.unicode_at(player_cursor):
			player_cursor += 1
		

func update_text_interface_single_line() -> void:
	#guard cases
	if player_cursor>text.length() or computer_cursor>text.length():
		return
	#clear text
	$TextInterface/TextDisplay.text = "" # text for uncompleted letters
	$TextInterface/CPUText.text = ""	 # text to show enemy ahead
	$TextInterface/PlayerText.text = ""	 # text to show player ahead
	$TextInterface/SharedText.text = ""	 # text completed by both enemy and player
	#find line and char player is on
	var line_index:int = player_cursor/char_per_line
	var local_player_cursor:int = player_cursor%char_per_line;
	# get text for current line
	var line_text = text.substr(line_index*char_per_line,char_per_line)
	# find line enemy is on
	var enemy_line_index = computer_cursor/char_per_line
	# if enemy is on same line as player background is default, leader is themselves, loser is shared
	if enemy_line_index == line_index:
		$TextInterface/TextDisplay.text = line_text;
		var local_enemy_cursor = computer_cursor%char_per_line
		if local_player_cursor<local_enemy_cursor:
			$TextInterface/CPUText.text = line_text.substr(0,local_enemy_cursor)
			$TextInterface/SharedText.text = line_text.substr(0,local_player_cursor)
		else:
			$TextInterface/PlayerText.text = line_text.substr(0,local_player_cursor)
			$TextInterface/SharedText.text = line_text.substr(0,local_enemy_cursor);
	# else if enemy is ahead, background is enemy and player is shared
	elif enemy_line_index>line_index:
		$TextInterface/CPUText.text = line_text
		$TextInterface/SharedText.text = line_text.substr(0,local_player_cursor)
	# else enemy is behind so background is default and player is player
	else:
		$TextInterface/TextDisplay.text = line_text
		$TextInterface/PlayerText.text = line_text.substr(0,local_player_cursor)

func update_CPU_cursor(delta):
	match GlobalGameSettings.cpu_cursor_mode:
		GlobalGameSettings.CPUPlayerMode.WPM:
			WPM_delay_accumulator += delta
			if WPM_delay_accumulator > GlobalGameSettings._char_delay:
				WPM_delay_accumulator -= GlobalGameSettings._char_delay
				computer_cursor += 1
		GlobalGameSettings.CPUPlayerMode.Disabled:
			pass
		GlobalGameSettings.CPUPlayerMode.SongSync:
			pass # TODO make me work
