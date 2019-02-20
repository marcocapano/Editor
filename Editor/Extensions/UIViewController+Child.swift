import UIKit

extension UIViewController {
    
    /// Adds a view controller as a child, embedding its view in a container view.
    ///
    /// - Parameters:
    ///   - child: The child to add
    ///   - containerView: The container view to add the child's view to.
    func addChildViewController(_ child: UIViewController, toContainerView containerView: UIView) {
        addChild(child)
        containerView.addSubview(child.view)
        child.didMove(toParent: self)
    }
    
    ///Removes both the controller and its view from the parent view controller.
    func removeViewAndControllerFromParentViewController() {
        guard parent != nil else { return }
        
        willMove(toParent: nil)
        removeFromParent()
        view.removeFromSuperview()
    }
}
