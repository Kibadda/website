module Web.FrontController where

import IHP.LoginSupport.Middleware
import IHP.RouterPrelude
import Web.Controller.Prelude
import Web.Controller.Sessions
-- Controller Imports

import Web.Controller.Static
import Web.Controller.Users
import Web.View.Layout (defaultLayout)

instance FrontController WebApplication where
  controllers =
    [ startPage WelcomeAction,
      -- Generator Marker
      parseRoute @UsersController,
      parseRoute @LoginController
    ]

instance InitControllerContext WebApplication where
  initContext = do
    initAuthentication @User
    setLayout defaultLayout
    initAutoRefresh
