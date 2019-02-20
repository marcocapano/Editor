import UIKit

extension UIButton {
    convenience init(image: UIImage) {
        self.init()
        setImage(image, for: .normal)
    }
}
