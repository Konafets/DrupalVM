name "base"
description "Base role applied to all nodes"

run_list(
	"recipe[postfix]",
	"recipe[git]",
	"recipe[vim]",
	"recipe[zsh]",
	"recipe[curl]"
)