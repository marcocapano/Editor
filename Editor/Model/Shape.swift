import UIKit

enum Shape: CustomStringConvertible, CaseIterable {
    case triangle
    case square
    case circle
    
    var description: String {
        switch self {
        case .triangle:
            return "Triangle"
        case .square:
            return "Square"
        case .circle:
            return "Circle"
        }
    }
}
