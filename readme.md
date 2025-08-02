# weblit-etlua

This is a [weblit](https://github.com/creationix/weblit) middleware that integrates the [etlua](https://github.com/leafo/etlua/) templating library allowing Static Website Generation and Server Side Rendering.

This project is mostly for my own consumption.

## install

The following command will automatically install the etlua dependency. Weblit is not listed as an explicit dependency to allow the middleware to be used with other potentially similar solutions.

```bash
lit install Bilal2453/weblit-etlua
```

alternatively, if you have the git-impl branch of my Lit fork (works for dependencies as well):

```bash
lit install https://github.com/Bilal2453/weblit-etlua
```

## example

Serve etlua templates with weblit-static:

```lua
local app = weblit.app.bind({
  host = '0.0.0.0',
  port = 8080,
})

local pages_template = {
  navigation = {'main', 'blog', 'about us', 'contact us'},
  copyright = 'Copyright 2019-2020',
}
local renderer = weblitEtlua.createRenderer(pages_template)

app.route({
  path = '/pages/',
}, renderer)
app.route({
  path = '/pages/',
}, weblitStatic('./pages'))
```

## overview

### createRenderer(env[, options])

Creates and returns the middleware handler to be used by weblit's `router.use` or `router.route`.
options is a table with the following available optional fields:

- `continue_on_error`: `boolean` (default: `false`).
  Send the response anyways even if etlua fails to render it into valid HTML.
- `error_message`: `string` (default: `An error has occured`).
  The response body to send when etlua fails to render, can include HTML.
- `error_callback`: `function(err: string, req: WeblitRequest, res: WeblitResponse)`.
  A callback to be called when etlua fails to render a response.
  Note that this callback is called after the response has been reset to indicate the error, so you may not read previous response state, only set new states.

## potential todos

- A middleware that adds a method to the response object, allowing `res:render(...)`.

## license and credits

Feel free to fork and/or open pull requests.
Licensed under the MIT license, see [[LICENSE]] for more info.

This is a very simple middleware made possible by:

- [creationix](https://github.com/creationix)'s work on [weblit](https://github.com/creationix/weblit).
- [leafo](https://github.com/leafo)'s work on [etlua](https://github.com/leafo/etlua/).
