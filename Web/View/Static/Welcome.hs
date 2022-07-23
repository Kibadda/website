module Web.View.Static.Welcome where

import Web.View.Prelude

data WelcomeView = WelcomeView

instance View WelcomeView where
  html WelcomeView =
    [hsx|
      <section>
        <h1><i class="fa-solid fa-copyright"></i> Michael Strobel</h1>
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
         <p>Hello {get #displayName currentUser}!</p>   
      |]
    Nothing -> [hsx||]
