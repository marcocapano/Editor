import UIKit

///A view with three buttons, displayed horizontally
class ButtonsView: UIView {
    let circleButton = UIButton(image: #imageLiteral(resourceName: "Oval.png"))
    let triangleButton = UIButton(image: #imageLiteral(resourceName: "Triangle.png"))
    let squareButton = UIButton(image: #imageLiteral(resourceName: "Rectangle.png"))
    
    init() {
        super.init(frame: .zero)
        
        backgroundColor = .white
        
        let stackView = UIStackView(arrangedSubviews: [circleButton,triangleButton,squareButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        
        stackView.arrangedSubviews.forEach({
            $0.layer.borderColor = UIColor.lightGray.cgColor
            $0.layer.borderWidth = 1
        })
        
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        stackView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        stackView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
