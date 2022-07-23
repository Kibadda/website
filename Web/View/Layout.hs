module Web.View.Layout (defaultLayout, Html) where

import Application.Helper.View
import Generated.Types
import IHP.Controller.RequestContext
import IHP.Environment
import IHP.ViewPrelude
import qualified Text.Blaze.Html5 as H
import qualified Text.Blaze.Html5.Attributes as A
import Web.Routes
import Web.Types

defaultLayout :: Html -> Html
defaultLayout inner =
  H.docTypeHtml ! A.lang "en" $
    [hsx|
      <head>
          {metaTags}

          {stylesheets}
          {scripts}

          <title>{pageTitleOrDefault "App"}</title>
      </head>
      <body>
          {header}
          <main class="container mt-4">
              {renderFlashMessages}
              {inner}
          </main>
          {footer}
      </body>
    |]

header :: Html
header =
  [hsx|
    <header>
      <nav class="navbar navbar-dark bg-dark navbar-expand-lg">
        <a class="navbar-brand" href="/"><i class="fa-solid fa-home"></i> Home</a>
        <ul class="navbar-nav mr-auto">
        </ul>
        {renderAuthButtons}
      </nav>
    </header>
  |]

footer :: Html
footer =
  [hsx|
    <footer>
    </footer>
  |]

-- <li class="nav-item">
--   <a class="nav-link" href="/">Test</a>
-- </li>

renderAuthButtons :: Html
renderAuthButtons =
  case currentUserOrNothing of
    Just currentUser ->
      [hsx|
        <form method="POST" action={LogoutAction}>
          <button class="btn btn-primary mr-auto ml-auto" type="submit">Logout</button>
        </form>
      |]
    Nothing ->
      [hsx|
        <a class="btn btn-primary mr-0 ml-auto" href={LoginOrSignupAction}>Login</a>
      |]

-- The 'assetPath' function used below appends a `?v=SOME_VERSION` to the static assets in production
-- This is useful to avoid users having old CSS and JS files in their browser cache once a new version is deployed
-- See https://ihp.digitallyinduced.com/Guide/assets.html for more details

stylesheets :: Html
stylesheets =
  [hsx|
    <link rel="stylesheet" href={assetPath "/vendor/bootstrap.min.css"}/>
    <link rel="stylesheet" href={assetPath "/vendor/flatpickr.min.css"}/>
    <link rel="stylesheet" href={assetPath "/lib/fontawesome.min.css"}/>
    <link rel="stylesheet" href={assetPath "/lib/solid.min.css"}/>
    <link rel="stylesheet" href={assetPath "/app.css"}/>
  |]

scripts :: Html
scripts =
  [hsx|
    {when isDevelopment devScripts}
    <script src={assetPath "/vendor/jquery-3.6.0.slim.min.js"}></script>
    <script src={assetPath "/vendor/timeago.js"}></script>
    <script src={assetPath "/vendor/popper.min.js"}></script>
    <script src={assetPath "/vendor/bootstrap.min.js"}></script>
    <script src={assetPath "/vendor/flatpickr.js"}></script>
    <script src={assetPath "/vendor/morphdom-umd.min.js"}></script>
    <script src={assetPath "/vendor/turbolinks.js"}></script>
    <script src={assetPath "/vendor/turbolinksInstantClick.js"}></script>
    <script src={assetPath "/vendor/turbolinksMorphdom.js"}></script>
    <script src={assetPath "/helpers.js"}></script>
    <script src={assetPath "/ihp-auto-refresh.js"}></script>
    <script src={assetPath "/app.js"}></script>
  |]

devScripts :: Html
devScripts =
  [hsx|
    <script id="livereload-script" src={assetPath "/livereload.js"} data-ws={liveReloadWebsocketUrl}></script>
  |]

metaTags :: Html
metaTags =
  [hsx|
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no"/>
    <meta property="og:title" content="App"/>
    <meta property="og:type" content="website"/>
    <meta property="og:url" content="TODO"/>
    <meta property="og:description" content="TODO"/>
    {autoRefreshMeta}
  |]
