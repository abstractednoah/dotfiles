SHELL = /bin/zsh

.PHONY = all xtras core mkdirs shell bash zsh vim wm wallpaper tmux luakit \
  uninstall mux_sample papis

DIRDEPS = $(HOME)/.vim $(HOME)/.config/i3 $(HOME)/.config/papis

fullpath = $$( readlink -f "$(1)" )
link = ln -fs
makelink = $(link) $(call fullpath,$<) "$@"
getshell = $$( awk -F: '$$1=="'"$$USER"'" {print $$7}' /etc/passwd )

all: core wm
core: mkdirs shell vim tmux papis
xtras: luakit

mkdirs: $(HOME)/.env.conf
	mkdir -p $(DIRDEPS)

$(HOME)/.env.conf: ./.
	[ $(call fullpath,$@) = $(call fullpath,$<) ] || $(makelink)

# shell
# ------------------------------------------------------------------------------
shell: zsh

bash: $(HOME)/.bashrc

$(HOME)/.bashrc: shell/bashrc
	$(makelink)

zsh: $(HOME)/.zshrc $(HOME)/.zshenv
	[ $(getshell) = $(SHELL) ] || chsh -s $(SHELL)

$(HOME)/.zshrc: shell/zshrc
	$(makelink)

$(HOME)/.zshenv: shell/zshenv
	$(makelink)
# ------------------------------------------------------------------------------

# vim
# ------------------------------------------------------------------------------
vim: $(HOME)/.vimrc $(HOME)/.vim/plugin

$(HOME)/.vimrc: vim/vimrc
	$(makelink)

$(HOME)/.vim/plugin: vim/plugin
	$(makelink)
# ------------------------------------------------------------------------------

# wm
# ------------------------------------------------------------------------------
wm: $(HOME)/.config/i3/config wallpaper $(HOME)/.i3status.conf

wallpaper: $(HOME)/.wallpaper $(HOME)/.wallpaperlock

$(HOME)/.config/i3/config: wm/i3wm.conf
	$(makelink)

$(HOME)/.wallpaper: wm/wallpaper-home.png
	$(makelink)

$(HOME)/.wallpaperlock: wm/wallpaper-lock.png
	$(makelink)

$(HOME)/.i3status.conf: wm/i3status.conf
	$(makelink)

# tmux
# ------------------------------------------------------------------------------
tmux: $(HOME)/.tmuxinator $(HOME)/.tmux.conf

$(HOME)/.tmuxinator: tmux/mux/projects
	$(makelink)

$(HOME)/.tmux.conf: tmux/tmux.conf
	$(makelink)

mux_sample: /usr/lib/ruby/vendor_ruby/tmuxinator/assets/sample.yml

/usr/lib/ruby/vendor_ruby/tmuxinator/assets/sample.yml: tmux/mux/sample.yml
	sudo $(makelink)
# ------------------------------------------------------------------------------

# browser
# ------------------------------------------------------------------------------
luakit: $(HOME)/.config/luakit /usr/local/bin/pinluakit

$(HOME)/.config/luakit: browser/luakit
	$(makelink)

/usr/local/bin/pinluakit: browser/luakit/pinluakit
	sudo $(makelink)
# ------------------------------------------------------------------------------

# fs
# ------------------------------------------------------------------------------
papis: $(HOME)/.config/papis/config

$(HOME)/.config/papis/config: fs/papis.config
	$(makelink)
# ------------------------------------------------------------------------------

# uninstall
# ------------------------------------------------------------------------------
uninstall:
	rm -vf $(HOME)/.env.config          # legacy
	rm -vf $(HOME)/.env.conf
	rm -vf $(HOME)/.bashrc
	rm -vf $(HOME)/.zshrc
	rm -vf $(HOME)/.zshenv
	rm -vf $(HOME)/.vimrc
	rm -vf $(HOME)/.vim/plugin
	rm -vf $(HOME)/.config/i3/config
	rm -vf $(HOME)/.i3status.conf
	rm -vf $(HOME)/.wallpaper
	rm -vf $(HOME)/.wallpaperlock
	rm -vf $(HOME)/.tmuxinator
	rm -vf $(HOME)/.tmux.conf
	rm -vf $(HOME)/.config/luakit -r
	rm -vf $(HOME)/.config/papis/config
# ------------------------------------------------------------------------------
