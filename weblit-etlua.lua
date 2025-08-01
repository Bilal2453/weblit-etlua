local etlua = require 'etlua'

---
---@param env table
---@param options {raise_error?: boolean, render_on_error?: boolean, error_message?: string}
---@return function
function createRenderer(env, options)
  local template_env = env or {}
  options = options or {}
  return function(req, res, go)
    -- do not allow rendering non-get requests
    -- doing otherwise might be potentially dangerous
    if req.method ~= 'GET' then
      go()
      return
    end

    -- handle the request first
    go()

    -- try to render the etlua template, as long as the response wasn't already cached
    if res.headers['Content-Type'] == 'text/html' and res.code ~= 304 then
      local ret, err = etlua.render(res.body, template_env)
      if ret then
        res.body = ret
      else
        if options.raise_error then
          return error('Could not render request: ' .. tostring(err))
        elseif options.render_on_error then
          return
        end
        res.body = options.error_message or 'Could not render HTML'
        res.code = 500
        res.ETag = nil -- do not cache errors
      end
    end
  end
end

return createRenderer
