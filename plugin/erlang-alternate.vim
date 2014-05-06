function! ErlangGetAlternateFilePath(filepath)
  let baseDir = fnamemodify(a:filepath, ":p:h:h")

  let fileName = fnamemodify(a:filepath, ":t")
  let dirName = fnamemodify(a:filepath, ":p:h:t")

  if dirName == "src"
    if fileName !~ "\.erl$"
      return ""
    end
    " EUnit
    let eunitName = split(fileName, "\.erl$")[0] . "_tests.erl"
    let alternateFilePath = baseDir . "/test/" . eunitName
    if filereadable(alternateFilePath)
      return alternateFilePath
    end
    " etest
    let etestName = split(fileName, "\.erl$")[0] . "_test.erl"
    let alternateFilePath = baseDir . "/test/" . etestName
    if filereadable(alternateFilePath)
      return alternateFilePath
    end
    " can't detect
    return ""
  elseif dirName == "test"
    " EUnit
    if fileName =~ "_tests\.erl$"
      let srcName = split(fileName, "_tests\.erl$")[0] . ".erl"
      let alternateFilePath = baseDir . "/src/" . srcName
      return alternateFilePath
    end
    " etest
    if fileName =~ "_test\.erl$"
      let srcName = split(fileName, "_test\.erl$")[0] . ".erl"
      let alternateFilePath = baseDir . "/src/" . srcName
      return alternateFilePath
    end
    " can't detect
    return ""
  end

  return ""
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
