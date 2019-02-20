import UIKit

class EditorViewController: UIViewController {
    
    ///The view containing the buttons to add new shapes
    let buttonsView = ButtonsView()
    
    ///The "drawing sheet" where all the shapes should be added
    let container = UIView()
    
    ///The controller that manages the shapes content
    let shapesController = ShapesViewController()
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
        let safe = view.safeAreaLayoutGuide
        view.addSubview(buttonsView)
        buttonsView.anchor(leading: safe.leadingAnchor, bottom: safe.bottomAnchor, trailing: safe.trailingAnchor, heightConstant: 44)
        
        view.addSubview(container)
        container.anchor(top: safe.topAnchor, leading: safe.leadingAnchor, bottom: buttonsView.topAnchor, trailing: safe.trailingAnchor)
        
        addChildViewController(shapesController, toContainerView: container)
        shapesController.view.fillToSuperview()
    }
    
    override func viewDidLoad() {
        buttonsView.circleButton.addTarget(self, action: #selector(addCircle), for: .touchUpInside)
        buttonsView.triangleButton.addTarget(self, action: #selector(addTriangle), for: .touchUpInside)
        buttonsView.squareButton.addTarget(self, action: #selector(addSquare), for: .touchUpInside)
        
        let undoButton = UIBarButtonItem(title: "Undo", style: .plain, target: self, action: #selector(revert))
        navigationItem.rightBarButtonItem = undoButton
        
        let statsButton = UIBarButtonItem(title: "Stats", style: .plain, target: self, action: #selector(showStats))
        navigationItem.leftBarButtonItem = statsButton
    }
    
    ///Pushes the stats screen on the navigation stack
    @objc func showStats() {
        let stats = generateStats(from: shapesController.shapes)
        let statsVC = StatsViewController(stats: stats)
        
        statsVC.deleteAllBlock = { [weak self] in
            //Remove all shapes
            self?.shapesController.shapes.forEach({self?.shapesController.remove($0)})
            //Update stats
            statsVC.stats = self?.generateStats(from: self?.shapesController.shapes) ?? []
            statsVC.tableView.reloadData()
        }
        
        statsVC.deleteShapeType = { [weak self] type in
            //Remove all shapes of this type
            let shapesToRemove = self?.shapesController.shapes.filter({ $0.type == type })
            shapesToRemove?.forEach({ self?.shapesController.remove($0)})
            
            //Update stats
            statsVC.stats = self?.generateStats(from: self?.shapesController.shapes) ?? []
            statsVC.tableView.reloadData()
        }
        
        navigationController?.pushViewController(statsVC, animated: true)
    }
    
    @objc func revert() {
        shapesController.undoManager?.undo()
    }
    
    @objc func addTriangle() {
        let triangle = UIImageView(image: #imageLiteral(resourceName: "Triangle.png"))
        shapesController.add((view: triangle, type: .triangle))
    }
    
    @objc func addCircle() {
        let circle = UIImageView(image: #imageLiteral(resourceName: "Oval.png"))
        shapesController.add((view: circle, type: .circle))
    }
    
    @objc func addSquare() {
        let square = UIImageView(image: #imageLiteral(resourceName: "Rectangle.png"))
        shapesController.add((view: square, type: .square))
    }
    
    
    /// Generate the stats about the number and type of shapes in the editor
    ///
    /// - Parameter shapes: The shapes to generate the stats about.
    /// - Returns: The stats, in the form of array of tuples (type of shape, number of shapes)
    func generateStats(from shapes: [ShapesViewController.ShapeInfo]?) -> [StatsViewController.Stat] {
        var stats = [StatsViewController.Stat]()
        
        Shape.allCases.forEach { (shapeType) in
            let count = shapes?.filter({$0.type == shapeType}).count
            stats.append((type: shapeType, count: count ?? 0))
        }
        
        return stats
    }
}

