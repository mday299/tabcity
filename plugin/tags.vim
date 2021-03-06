function! tags#Open_tag_in_new_tab()
" opens a tag according to the following:
"   1) Tag does not exist:  do nothing
"   2) Tag exists in the current file:  go to the tag in the current tab
"   3) Tag exists in another file:
"           if the other file is already open in another tab then go to that tab
"           otherwise, open a new tab
"
"to go back afterwards, use <leader>R

    " record original position so that <leader>R can go back
    call pos#Set_current_pos()

    " get the current file and line
    let orig_fname = expand('%:p')      "file name
    let orig_line_num = line(".")       "line number

    try
        " jump to the tag
        let w = expand("<cword>")           "get the current word
        execute "tag " . w
    catch
        echo "tag not found"
        return
    endtry

    " get the jumped to file name and line
    let tag_fname = expand('%:p')   " get filename and path
    let line_num = line(".")    " get line number of jump

    " go back to the original file
    pop

    if tag_fname ==# orig_fname

        "no reason to open a new tab if in same file, so just use the normal
        "tag jump
        execute "tag " . w

    elseif tags#Look_for_matching_tab(tag_fname, 1)

        "if there is already a matching tab open, then go to the appropriate line
        execute "normal! gg" . line_num . "G"

    else

        "otherwise, open a new tab and jump to it
        tabnew! %
        execute "tag " . w

    end

endfunction
