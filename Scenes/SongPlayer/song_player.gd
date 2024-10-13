extends Control

enum LineMode{
	SingleLine,
	N_Line,
	H_Scrolling,
	V_Scrolling_N_Line,
	V_Scrolling_unlimited,
}
enum CPUPlayerMode{
	WPM,
	SongSync,
	Disabled,
}

@export var line_mode:LineMode = LineMode.SingleLine
@export var cpu_player_mode:CPUPlayerMode = CPUPlayerMode.Disabled

# text probably needs an annotation but i'm unsure which one would be most appropriate
var text:String = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor\
 incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation \
ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in \
voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non \
proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
var char_per_line:int = 50


var player_cursor:int = 0
var computer_cursor:int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sync_text_elements()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	update_text_interface_single_line()

func sync_text_elements() -> void:
	pass #TODO format of all text elements needs to be identical or else display will not function properly.

func _input(event):
	if event is InputEventKey and event.is_pressed:
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

# TODO remove debug timer
func _on_debug_timer_timeout() -> void:
	computer_cursor += 1
	
