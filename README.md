## Elm Sortable List

An small example app demonstrating a list that you can
reorder using drag and drop.

The example uses subscriptions to `Mouse.moves` and `Mouse.ups`
to track the drag movement in the vertical axis.

The basic drag function is an adaption from the drag example on  
http://elm-lang.org/examples/drag

Combined with css styles for animation,
and a helper function to move the dragged item to the new position.

For readability of the main app, the styles have been placed in 
a separate Styles.elm file. 
