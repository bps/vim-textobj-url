function! s:extract_url(line)
  " Regexp borrowed from: <https://github.com/jwhitley/vim-open-url/blob/113979f1931db70c7d1e8c498f825663dbe29fe5/plugin/open_url.vim#L6>
  let mx = '\c\v%(<|>)(%([a-z][[:alnum:]-]+:%(/{1,3}|[a-z0-9%])|www\d{0,3}[.]|[a-z0-9.\-]+[.][a-z]{2,4}/)%([^[:space:]()<>]+|\(([^[:space:]()<>]+|(\([^[:space:]()<>]+\)))*\))+%(\(([^[:space:]()<>]+|(\([^[:space:]()<>]+\)))*\)|[^[:space:]`!()\[\]{};:''".,<>?«»“”‘’]))'
  let pos1 = getpos('.')
  let pos2 = copy(pos1)
  let cpos = pos1[2]
  let [mpos, mlen, spos] = [0, 0, 0]
  while 1
    let mpos = match(a:line, mx, spos)
    if mpos == -1
      throw "don't match"
    endif
    let mlen = len(matchstr(a:line[(mpos == 0 ? 0 : mpos-1):], mx))
    if mpos <= cpos && cpos <= mpos + mlen
      break
    endif
    let spos = mpos + mlen
  endwhile
  let pos1[2] = mpos + 1
  let pos2[2] = mpos + mlen
  return [pos1, pos2]
endfunction

function! textobj#url#select_a()
  try
    let line = getline('.')
    let [head_pos, tail_pos] = s:extract_url(line)
    if tail_pos[2] == len(line)
      let tail_pos[2] += 1
    endif
    return ['v', head_pos, tail_pos]
  catch
    return 0
  endtry
endfunction

function! textobj#url#select_i()
  try
    let line = getline('.')
    let [head_pos, tail_pos] = s:extract_url(line)
    let non_blank_char_exists_p = line[head_pos[2] - 1] !~# '\s'
    return non_blank_char_exists_p ? ['v', head_pos, tail_pos] : 0
  catch
    return 0
  endtry
endfunction
