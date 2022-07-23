module Web.View.Static.Welcome where

import Web.View.Prelude

data WelcomeView = WelcomeView

instance View WelcomeView where
  html WelcomeView =
    [hsx|
      <section>
        <h1>{showUsername}</h1>
      </section>
      <section>
      </section>
      <section>
      </section>
    |]

showUsername :: Html
showUsername =
  case currentUserOrNothing of
    Just currentUser ->
      [hsx|
         Hello {get #displayName currentUser}!
      |]
    Nothing -> [hsx||]
