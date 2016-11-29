module Styles exposing (..)
{-| Static styles used in elm-sortable-table
-}

type alias StyleList = List (String, String)


-- for page container (root element)
pageContainer : StyleList
pageContainer =
    [ ("width","360px")
    , ("margin","auto")
    , ("padding","0 0 8px 0")
    , ("backgroundColor","#fafafa")
    , ("fontFamily","sans-serif")
    ]

-- for list header (with title and toggle button)
listHeader : StyleList
listHeader =
    [("display","flex")
    ,("padding","8px")
    ,("margin","8px 0")
    ] 

-- for title in header
headerTitle : StyleList
headerTitle =
    [ ("flex","1 0 auto")
    , ("margin","0")
    ]

-- for list container (ul)
listContainer : StyleList
listContainer =
    [ ("transformStyle","preserve-3d")
    , ("padding","0")
    , ("margin","8px 0")
    ]

-- for list item (li)
listItem : StyleList
listItem =
  [ ("listStyleType","none")
  , ("margin","8px")
  , ("padding","8px")
  , ("height","24px")
  , ("backgroundColor", "white")
  , ("border","1px solid rgba(0,0,0,.27)")
  , ("border-radius","2px")
  , ("box-shadow", "0 1px 2px rgba(0,0,0,0.24)")
  , ("display","flex")
  ]

-- for text in list item container
itemText : StyleList
itemText =
    [ ("flex","1 0 auto")
    , ("display","inline-block") 
    ]