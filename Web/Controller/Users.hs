module Web.Controller.Users where

import Data.Text (strip)
import qualified IHP.AuthSupport.Controller.Sessions as Sessions
import Web.Controller.Prelude
import Web.View.Sessions.LoginOrSignup
import Web.View.Users.Edit
import Web.View.Users.Show

instance Sessions.SessionsControllerConfig User => Controller UsersController where
  action ShowUserAction {userId} = do
    user <- fetch userId
    render ShowView {..}
  action EditUserAction {userId} = do
    user <- fetch userId
    render EditView {..}
  action UpdateUserAction {userId} = do
    user <- fetch userId
    user
      |> buildUser
      |> ifValid \case
        Left user -> render EditView {..}
        Right user -> do
          user <- user |> updateRecord
          setSuccessMessage "User updated"
          redirectTo EditUserAction {..}
  action CreateUserAction = do
    let user = newRecord @User
    user
      |> buildUser
      |> modify #displayName strip
      |> validateField #email isEmail
      |> validateField #passwordHash nonEmpty
      |> validateField #handle (matchesRegex "^[a-zA-Z0-9_-]{1,64}$")
      |> (\u -> if get #displayName u == "" then u |> set #displayName (get #handle u) else u)
      |> ifValid \case
        Left user ->
          render
            LoginOrSignupView
              { loginUser = newRecord @User,
                signupUser = user
              }
        Right user -> do
          hashed <- hashPassword (get #passwordHash user)
          user <-
            user
              |> set #passwordHash hashed
              |> createRecord
          login user
          redirectUrl <- getSessionAndClear "IHP.LoginSupport.redirectAfterLogin"
          redirectToPath (fromMaybe (Sessions.afterLoginRedirectPath @User) redirectUrl)
  action DeleteUserAction {userId} = do
    user <- fetch userId
    deleteRecord user
    setSuccessMessage "User deleted"
    redirectToPath "/"

buildUser user =
  user
    |> fill @["email", "handle", "displayName", "passwordHash", "failedLoginAttempts"]
