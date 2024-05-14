function initUi()
  app.registerUi({["menu"] = "Show ToolBox", ["callback"] = "show_toolbox", ["accelerator"] = "<Alt><Shift>t"});
end

function show_toolbox()
  app.uiAction({["action"]="ACTION_TOOL_FLOATING_TOOLBOX", ["enabled"]=true})
end
