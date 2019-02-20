import UIKit

class ShapesViewController: UIViewController {
    typealias ShapeInfo = (view: UIImageView, type: Shape)
    
    ///Keeps track of added shapes
    var shapes = [ShapeInfo]()
    
    ///Keeps track of consecutive positions of a shape, so that undo is possible even after multiple draggings
    var consecutivePositions = [UIView: [CGPoint]]()
    
    override func viewDidLoad() {
        view.backgroundColor = .white
    }

    
    /// Adds a shape to the editor and registers the related undo operation.
    ///
    /// - Parameter shape: The shape to be added
    func add(_ shape: ShapeInfo) {
        view.addSubview(shape.view)
        shapes.append(shape)

        shape.view.frame.size = CGSize(width: 44, height: 44)
        shape.view.center = view.center
        shape.view.isUserInteractionEnabled = true
        
        let draggingRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handle(_:)))
        shape.view.addGestureRecognizer(draggingRecognizer)
        
        //Register the undo operation, which should remove the added shape
        undoManager?.registerUndo(withTarget: self, handler: { [weak self] (editor) in
            self?.remove(shape)
        })
        
        let deleteRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(promptDeletion(_:)))
        shape.view.addGestureRecognizer(deleteRecognizer)
    }
    
    
    /// Removes a shape from the editor.
    ///
    /// - Parameter shape: The shape to be removed.
    func remove(_ shape: ShapeInfo?) {
        shapes.removeAll(where: { $0.view === shape?.view })
        shape?.view.removeFromSuperview()
    }
    
    ///Prompts the user about deleting the long-pressed shape.
    @objc private func promptDeletion(_ recognizer: UILongPressGestureRecognizer) {
        guard let tappedView = recognizer.view else { return }
        
        let alert = UIAlertController(title: "Do you want do delete this shape?", message: "The action can be undone later", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { [weak self] _ in
            guard let self = self, let shape = self.shapes.first(where: { $0.view === tappedView }) else { return }
            
            //Remove and register the undo operation
            self.remove(shape)
            self.undoManager?.registerUndo(withTarget: self, handler: { (editor) in
                editor.add(shape)
            })
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    ///Handles the dragging of shapes. When the gesture begins it stores the original position
    ///to make undo possible. Then it moves the shape around and registers an undo operation
    ///when dragging ends.
    @objc func handle(_ gesture: UIPanGestureRecognizer) {
        guard let draggedView = gesture.view else { return }
        
        switch gesture.state {
        case .began:
            if consecutivePositions[draggedView] == nil {
                consecutivePositions[draggedView] = [draggedView.center]
            } else {
                consecutivePositions[draggedView]?.append(draggedView.center)
            }
        case .changed:
            //Making sure the view is visible
            view.bringSubviewToFront(draggedView)
            
            //Move the view accordingly
            let translation = gesture.translation(in: view)
            draggedView.center = CGPoint(x: draggedView.center.x + translation.x, y: draggedView.center.y + translation.y)
            gesture.setTranslation(CGPoint.zero, in: view)
        case .ended:
            guard var positions = consecutivePositions[draggedView] else { return }
            let lastPosition = positions.removeLast()
            
            //Register undo operation to bring the shape back into position
            undoManager?.registerUndo(withTarget: self, handler: { (editor) in
                draggedView.center = lastPosition
            })
            
        default: break
        }
    }
    
}
