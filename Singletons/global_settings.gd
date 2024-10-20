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
var cpu_cursor_mode:CPUPlayerMode = CPUPlayerMode.WPM

var CPU_target_WPM:float = 60:
	set(value): 
		_char_delay = 60/(value*5)
		CPU_target_WPM = value
var _char_delay:float = 60/(CPU_target_WPM*5)
