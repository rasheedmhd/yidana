// This file is auto-generated by ./bin/rails stimulus:manifest:update
// Run that command whenever you add a new controller or create them with
// ./bin/rails generate stimulus controllerName

import { application } from "./application"

import ColorModesController from "./color_modes_controller"
application.register("color-modes", ColorModesController)

import HelloController from "./hello_controller"
application.register("hello", HelloController)

import ToastController from "./toast_controller"
application.register("toast", ToastController)

import TooltipController from "./tooltip_controller"
application.register("tooltip", TooltipController)
