# Restaurant List App

## Demo
![](Demo.gif)

## Application architecture
Application is built base on MVVM-C + Dependencies Injection architecture to respect SOLID principle (ModelViewViewModel-Coordinator)

### Coordinator 
- Handles navigation
- Typically has a reference to a UINavigationController or a UITabBarController
- Instansiates ViewModels and ViewControllers. Injects dependencies into ViewModels.
- Instansiates child coordinators if needed.
- Typically each "tab" in the app has ints own Coordinator

### ViewModel 
- Handles data (talking to the api)
- Observes app and server events.
- Business logic
- Typically comes as a together with a ViewController
- Communicated "back" to the Coordinator using the delegate pattern.

### View
- Typically a UIViewController
- Handles the view
- Has a reference to the ViewModel and observes it.
- Informs the ViewModel about user interactions (buttons etc. are clicked)
- Typically comes as pair together the a ViewModel
- Typically each screen in the app has it's own ViewController (and ViewModel)

### Model
- Just data. No logic.
- Basically the api and the models passed to/from the api.
- The api does the data caching
