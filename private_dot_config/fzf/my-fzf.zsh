#### the order of each segment matters!

## some custom env vars
export FZF_DEFAULT_OPTS="
--layout=reverse
--info=inline
--height=80%
--multi
--color='hl:148,hl+:154,pointer:032,marker:010,bg+:237,gutter:008'
--pointer='▶'
--marker='✓'
--bind '?:toggle-preview'
--bind 'ctrl-a:select-all'
--bind 'ctrl-e:execute(${EDITOR} {+} >/dev/tty)'
--bind 'ctrl-v:execute(code {+})'
--bind 'alt-h:toggle,alt-l:toggle'
--bind 'alt-j:down,alt-k:up'
--bind 'tab:down'"

## default zsh config
source <(fzf --zsh)

## my custom history widegt with timestamp
fzf-history-widget() {
  local selected
  setopt localoptions noglobsubst noposixbuiltins pipefail no_aliases noglob nobash_rematch 2> /dev/null

  ## read history data including timestamp
  selected="$(awk -F ';' '
    BEGIN {
      OFS="\t"
    }
    /^:/ {
      split($1, timeinfo, ":");
      cmdtime = strftime("%Y-%m-%d %H:%M:%S", timeinfo[2]);
      cmd = $2;
      if (!seen[cmd]++) {
        print cmdtime, cmd
      }
    }
  ' ~/.zsh_history | tac |
  FZF_DEFAULT_OPTS=$(__fzf_defaults "" "--header='Press ENTER to select' --delimiter='\t' --with-nth=1,2 --bind=ctrl-r:toggle-sort +m") \
  FZF_DEFAULT_OPTS_FILE='' $(__fzfcmd))"

  local ret=$?
  if [ -n "$selected" ]; then
    # only put history cmd data into buffer
    LBUFFER="${selected#*$'\t'}"
  fi
  zle reset-prompt
  return $ret
}
zle     -N            fzf-history-widget
bindkey -M emacs '^R' fzf-history-widget
bindkey -M vicmd '^R' fzf-history-widget
bindkey -M viins '^R' fzf-history-widget


