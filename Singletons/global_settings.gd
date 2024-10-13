extends Node


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

var line_mode:LineMode = LineMode.SingleLine
var cpu_player_mode:CPUPlayerMode = CPUPlayerMode.Disabled

var CPU_target_WPM:float = 60:
	set(value): 
		_CPM_delay = 60/(value*5)
		CPU_target_WPM = value
var _CPM_delay:float = 60/(CPU_target_WPM*5)
