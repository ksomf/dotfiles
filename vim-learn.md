# tpope/vim-surround

### <surround>

- '
- "
- <q>
- ] ([ for space)
- } ({ for space)
- ) (( for space)


```
cs<surround_match><surround_replace>
ds<surround_match>
ys<visual sequence><surround_set>
<visual>S<surround_set>
```

# tpope/vim-unimpaired

- `]q` -> :cnext (`[q` -> :cprevious)
- `]<space>` -> newline after
- `]f` -> new file in dir

# tpope/vim-commentary

- `gcc` -> toggle line comment
- `gc<visual sequence>`
- `visual -> gc`

# tpope/vim-fugitive

- `:Git` -> status defaulted git plug
	- Remember <c-R><c-W> during command copies word under cursor

# junegunn/fzf

- `:Files`
