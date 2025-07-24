// Import and register all your controllers from the importmap via controllers/**/*_controller
import { application } from "controllers/application"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
import AddToCartController from "./add_to_cart_controller"
import CartController from "./cart_controller"
application.register("cart", CartController)
eagerLoadControllersFrom("controllers", application)
application.register("add-to-cart", AddToCartController)
import SearchOverlayController from "./search_overlay_controller"
application.register("search-overlay", SearchOverlayController)
import CategoryOverlayController from "./category_overlay_controller"
application.register("category-overlay", CategoryOverlayController)
