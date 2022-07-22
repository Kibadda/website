module Web.Routes where

import Generated.Types
import IHP.RouterPrelude
import Web.Types

-- Generator Marker
instance AutoRoute StaticController

instance AutoRoute UsersController

instance AutoRoute LoginController where
  allowedMethodsForAction = \case
    "LoginOrSignupAction" -> [GET, HEAD]
    "CreateSessionAction" -> [POST]
    "LogoutAction" -> [POST]
    _ -> error "instance AutoRoute LoginController: impossible"
