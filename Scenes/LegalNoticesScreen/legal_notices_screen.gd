extends MarginContainer


@onready var third_party_licenses := Engine.get_license_info()
@onready var third_party_license_item_list: ItemList = $"VBoxContainer/TabContainer/Godot third-party component licenses/ItemList"
@onready var third_party_license_text_box: TextEdit = $"VBoxContainer/TabContainer/Godot third-party component licenses/TextBoxForLegalNotices"


func _ready() -> void:
	var tab_container := $VBoxContainer/TabContainer
	
	var readme: RichTextLabel = tab_container.get_node("README")
	readme.text = readme.text.format({
		"game_name": ProjectSettings.get_setting_with_override("application/config/name"),
		"godot_version": Engine.get_version_info().string
	})
	
	var license_file: FileAccess = FileAccess.open("res://LICENSE", FileAccess.READ)
	tab_container.get_node("Song Typing license").text = license_file.get_as_text()
	
	tab_container.get_node("Godot license").text = Engine.get_license_text()
	
	var third_party_component_list_text := ""
	for piece_of_copyright_info: Dictionary in Engine.get_copyright_info():
		third_party_component_list_text += "%s:\n" % [piece_of_copyright_info["name"]]
		for part_i: int in len(piece_of_copyright_info["parts"]):
			third_party_component_list_text += "\tPart %s:\n" % [part_i]
			var part: Dictionary = piece_of_copyright_info["parts"][part_i]
			third_party_component_list_text += "\t\tFiles:\n"
			for file: String in part["files"]:
				third_party_component_list_text += "\t\t\t• %s\n" % file
			third_party_component_list_text += "\t\tCopyright notices:\n"
			for copyright_notice: String in part["copyright"]:
				third_party_component_list_text += "\t\t\t© %s\n" % copyright_notice
			third_party_component_list_text += "\t\tLicense ID:\n"
			third_party_component_list_text += "\t\t\t%s\n" % [part["license"]]
		third_party_component_list_text += "\n"
	tab_container.get_node("Godot third-party component list").text = third_party_component_list_text
	
	for license_id: String in third_party_licenses:
		third_party_license_item_list.add_item(license_id)


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/MainMenu/main_menu.tscn")


func _on_readme_meta_clicked(meta: Variant) -> void:
	OS.shell_open(str(meta))


func _on_item_list_item_selected(index: int) -> void:
	var license_id: String = third_party_license_item_list.get_item_text(index)
	third_party_license_text_box.text = third_party_licenses[license_id]
