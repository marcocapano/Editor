#  PEAK Coding Exercise

The app features two screens:

1) Editor screen with
        
        - 3 buttons to add shapes(one for each shape type) and the possibility to undo the adding
        - the possibility to long press a shape and delete it (also undoable)
        - a stats button that brings the user to the stats screen
        - an undo button

2) Stats screen with
            
        - a list of types of shape, with the count of displayed shapes
        - a delete all button to delete all shapes(undoable in the editor)
        - the possibility of deleting all shapes of one type by swiping on the correct cell (undoable in the editor)
        
        
The project features Unit and UI tests.
The UI is done in code because it's the way I prefer for reusability and testability reasons, hope my choice is not a problem.
As for the patters, I chose to use simple view controllers because I think MVC can be a really good pattern if used carefully and if we forget the idea that a screen should be just one massive view controller, in favor of smaller, more reusables components.


I'll take this file as a chance to thank you for the opportunity! It was a fun project🚀

