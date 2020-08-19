module Styles exposing (..)

{-| Static styles used in elm-sortable-table
-}

import Html exposing (Attribute)
import Html.Attributes exposing (..)


type alias StyleList msg =
    List (Attribute msg)



-- for page container (root element)


pageContainer : StyleList msg
pageContainer =
    [ style "width" "360px"
    , style "margin" "auto"
    , style "padding" "0 0 8px 0"
    , style "backgroundColor" "#fafafa"
    , style "fontFamily" "sans-serif"
    ]



-- for list header (with title and toggle button)


listHeader : StyleList msg
listHeader =
    [ style "display" "flex"
    , style "padding" "8px"
    , style "margin" "8px 0"
    ]



-- for title in header


headerTitle : StyleList msg
headerTitle =
    [ style "flex" "1 0 auto"
    , style "margin" "0"
    ]



-- for list container (ul)


listContainer : StyleList msg
listContainer =
    [ style "transformStyle" "preserve-3d"
    , style "padding" "0"
    , style "margin" "8px 0"
    ]



-- for list item (li)


listItem : StyleList msg
listItem =
    [ style "listStyleType" "none"
    , style "margin" "8px"
    , style "padding" "8px"
    , style "height" "24px"
    , style "backgroundColor" "white"
    , style "border" "1px solid rgba(0,0,0,.27)"
    , style "border-radius" "2px"
    , style "box-shadow" "0 1px 2px rgba(0,0,0,0.24)"
    , style "display" "flex"
    ]



-- for text in list item container


itemText : StyleList msg
itemText =
    [ style "flex" "1 0 auto"
    , style "display" "inline-block"
    ]
