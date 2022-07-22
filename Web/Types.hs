module Web.Types where

import Generated.Types
import IHP.LoginSupport.Types
import IHP.ModelSupport
import IHP.Prelude

data WebApplication = WebApplication deriving (Eq, Show)

data StaticController = WelcomeAction deriving (Eq, Show, Data)

data UsersController
  = ShowUserAction {userId :: !(Id User)}
  | CreateUserAction
  | EditUserAction {userId :: !(Id User)}
  | UpdateUserAction {userId :: !(Id User)}
  | DeleteUserAction {userId :: !(Id User)}
  deriving (Eq, Show, Data)

data LoginController
  = LoginOrSignupAction
  | CreateSessionAction
  | LogoutAction
  deriving (Eq, Show, Data)

instance HasNewSessionUrl User where
  newSessionUrl _ = "/LoginOrSignup"

type instance CurrentUserRecord = User
