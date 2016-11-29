## Elm Sortable List

An small example app demonstrating a list that you can
reorder using drag and drop.

![gif](/img/looping.gif)


# Get started
- Make sure you have elm 0.18 installed
- The example also needs the Mouse package for elm
- Copy or clone the files from the /src folder
- You can run elm-sortable-table.elm in elm-reactor


# Summary
The example uses subscriptions to `Mouse.moves` and `Mouse.ups`
to track the drag movement in the vertical axis.

The basic drag function is an adaption from the drag example on  
http://elm-lang.org/examples/drag

Combined with styles for animation,
and a helper function to move the dragged item to the new position.

For readability of the main app, the styles have been placed in 
a separate Styles.elm module. 
  

# Main 