function! ErlangGetAlternateFilePath(filepath)
  let alternateFilePath = ""

  let baseDir = fnamemodify(a:filepath, ":p:h:h")

  let fileName = fnamemodify(a:filepath, ":t")
  let dirName = fnamemodify(a:filepath, ":p:h:t")

  if dirName == "src"
    let testName = split(fileName, ".erl$")[0] . "_tests.erl"
    let alternateFilePath = baseDir . "/test/" . testName
  elseif dirName == "test"
    let srcName = split(fileName, "_tests.erl$")[0] . ".erl"
    let alternateFilePath = baseDir . "/src/" . srcName
  end

  return alternateFilePath
endfunction

function! ErlangEditCommand(command)
  if a:command == "A"
    return "edit"
  elseif a:command == "AS"
    return "split"
  elseif a:command == "AV"
    return "vsplit"
  elseif a:command == "AT"
    return "tabedit"
  endif
endfunction

function! ErlangAlternateFile(command)
  let currentFilePath = expand(bufname("%"))
  let alternateFilePath = ErlangGetAlternateFilePath(currentFilePath)

  if alternateFilePath == ""
    echoerr "can't detect alternate file"
  elseif filereadable(alternateFilePath)
    exec(":" . ErlangEditCommand(a:command). " " . alternateFilePath)
  else
    echoerr "couldn't find file " . alternateFilePath
  endif
endfunction
