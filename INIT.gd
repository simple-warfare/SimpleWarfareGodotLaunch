@tool
extends Node


func _ready() -> void:
	var res = DirAccess.open("res://")
	if !res.file_exists("INITED"):
		extract_all_from_zip("assets/init_assets.zip","user://assets")
		extract_all_from_zip("assets/init_mods.zip","user://assets")
		var inited = FileAccess.open("res://INITED",FileAccess.WRITE)
		inited.store_8(0)
		
# 解压 ZIP 压缩包中的所有文件，保持目录结构。
# 功能类似于大多数归档文件管理器中的“全部解压”功能。
func extract_all_from_zip(zip_path:String,root_path:String):
	var reader = ZIPReader.new()
	reader.open(zip_path)

	# 解压文件的目标目录（解压前必须存在）。
	# 不是所有的 ZIP 压缩包都会把所有文件都放在根文件夹中，
	# 解压后 `root_dir` 中会创建若干文件/文件夹。
	var root_dir = DirAccess.open(root_path)

	var files = reader.get_files()
	for file_path in files:
		# 如果当前条目是目录。
		if file_path.ends_with("/"):
			root_dir.make_dir_recursive(file_path)
			continue

		# 写入文件内容，需要时自动创建文件夹。
		# 不是所有 ZIP 压缩包都遵循特定的顺序，这一步的作用是
		# 防止文件条目出现在文件夹条目之前。
		root_dir.make_dir_recursive(root_dir.get_current_dir().path_join(file_path).get_base_dir())
		var file = FileAccess.open(root_dir.get_current_dir().path_join(file_path), FileAccess.WRITE)
		var buffer = reader.read_file(file_path)
		file.store_buffer(buffer)
