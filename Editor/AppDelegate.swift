import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    let window = UIWindow(frame: UIScreen.main.bounds)

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let editor = EditorViewController()
        editor.title = "Editor"
        window.rootViewController = UINavigationController(rootViewController: editor)
        window.makeKeyAndVisible()
        
        return true
    }

}

