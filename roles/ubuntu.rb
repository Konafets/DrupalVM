name "ubuntu"
description "Role applied to all Ubuntu systems."

run_list(
	"recipe[ubuntu]",
	"role[base]"
)
