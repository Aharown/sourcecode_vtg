// Import and register all your controllers from the importmap via controllers/**/*_controller
import { application } from "controllers/application"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
import AddToCartController from "./add_to_cart_controller"
import CartController from "./cart_controller"
application.register("cart", CartController)
eagerLoadControllersFrom("controllers", application)
application.register("add-to-cart", AddToCartController)
