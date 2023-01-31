// This file is auto-generated by ./bin/rails stimulus:manifest:update
// Run that command whenever you add a new controller or create them with
// ./bin/rails generate stimulus controllerName

import { application } from "./application"

import CodeController from "./code_controller"
application.register("code", CodeController)

import EmailController from "./email_controller"
application.register("email", EmailController)

import EmailsController from "./emails_controller"
application.register("emails", EmailsController)

import NameController from "./name_controller"
application.register("name", NameController)

import PasswordController from "./password_controller"
application.register("password", PasswordController)

import PhoneController from "./phone_controller"
application.register("phone", PhoneController)

import PhoneNumbersController from "./phone_numbers_controller"
application.register("phone-numbers", PhoneNumbersController)

import ShowController from "./show_controller"
application.register("show", ShowController)
