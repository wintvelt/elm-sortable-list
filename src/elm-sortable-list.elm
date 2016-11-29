{-| An example of a sortable list using drag and drop
See the README.md file for more information
-}
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, on)
import Json.Decode as Decode
import Mouse exposing (Position)

import Styles

main =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }


-- MODEL

type alias Model =
  { isReordering : Bool
  , data : List String
  , drag : Maybe Drag
  }

init : (Model, Cmd Msg)
init = 
  { isReordering = False
  , data = initialList |> List.sort
  , drag = Nothing
  } ! []

type alias Drag =
    { itemIndex : Int
    , startY : Int
    , currentY : Int
    }

initialList =
  [ "Shawshank Redemption"
  , "Godfather"
  , "Dark Knight"
  , "12 Angry Men"
  , "Schindler’s List"
  , "Pulp Fiction"
  , "Lord of the Rings"
  , "The Good, the Bad and the Ugly"
  , "Fight Club"
  , "The Empire Strikes Back"
  ]




-- UPDATE

type Msg =
  ToggleReorder
  | Move Int Int
  | DragStart Int Position
  | DragAt Position
  | DragEnd Position


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of 
    ToggleReorder ->
      { model | isReordering = not model.isReordering } ! []
      
    Move fromPos offset ->
      { model | data = moveItem fromPos offset model.data } ! []

    DragStart idx pos ->
      { model 
      | drag = Just <| Drag idx pos.y pos.y
      } ! []

    DragAt pos ->
      { model 
      | drag = 
        Maybe.map (\{itemIndex, startY} -> Drag itemIndex startY pos.y) model.drag
      } ! []

    DragEnd pos ->
      case model.drag of
        Just {itemIndex, startY, currentY} ->
          { model
          | data = 
              moveItem 
                itemIndex 
                ((currentY - startY + if currentY < startY then -20 else 20) // 50)
                model.data
          , drag = Nothing
          } ! []
          
        Nothing ->
          { model 
          | drag = Nothing 
          } ! []




moveItem : Int -> Int -> List a -> List a
moveItem fromPos offset list =
  let
    listWithoutMoved = List.take fromPos list ++ List.drop (fromPos + 1) list
    moved = List.take 1 <| List.drop fromPos list
  in
    List.take (fromPos + offset) listWithoutMoved
    ++ moved
    ++ List.drop (fromPos + offset) listWithoutMoved



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  case model.drag of
    Nothing ->
      Sub.none

    Just _ ->
      Sub.batch [ Mouse.moves DragAt, Mouse.ups DragEnd ]



-- VIEW


view : Model -> Html Msg
view model =
  div 
    [ style Styles.pageContainer ]
    [ div 
      [ style Styles.listHeader ]
      [ h3
        [ style Styles.headerTitle ]
        [ text "Sortable favorite movies" ]
      , toggleButton model 
      ]
    , ul 
      [ style Styles.listContainer ]
      <| List.indexedMap (itemView model) model.data
    ]

toggleButton : Model -> Html Msg
toggleButton model =
  let
    buttonTxt =
      if model.isReordering then
        "Reordering"
      else
        "Click to reorder"
  in
    button [ onClick ToggleReorder ] [ text buttonTxt ]
    
itemView : Model -> Int -> String -> Html Msg
itemView model idx item =
  let
    buttonStyle =
      if model.isReordering then
        [("display","inline-block")]
      else
        [("display","none")]
        
    moveStyle =
      case model.drag of
        Just {itemIndex, startY, currentY} ->
          if itemIndex == idx then
            [ ("transform", "translateY( "++ toString (currentY - startY) ++"px) translateZ(10px)")
            , ("box-shadow", "0 3px 6px rgba(0,0,0,0.24)")
            , ("willChange","transform")
            ]
          else
            []
            
        Nothing ->
          []
         
    makingWayStyle =
      case model.drag of 
        Just {itemIndex, startY, currentY} ->
          if (idx < itemIndex) && (currentY - startY) < (idx - itemIndex) * 50 + 20 then
            [("transform","translateY(50px)")
            ,("transition","transform 200ms ease-in-out")
            ]
          else if (idx > itemIndex) && (currentY - startY) > (idx - itemIndex) * 50 - 20 then
            [("transform","translateY(-50px)")
            ,("transition","transform 200ms ease-in-out")
            ]
          else if idx /= itemIndex then
            [("transition","transform 200ms ease-in-out")]
          else
            []
              
        Nothing ->
          []
          
  in
    li [ style <| Styles.listItem ++ moveStyle ++ makingWayStyle ] 
      [ div [ style Styles.itemText ] [ text item ]
      , button 
        [ style buttonStyle, onMouseDown <| DragStart idx ]
        [ text "drag" ] 
      ]
      
getY : Model -> Int
getY model =
  case model.drag of
      Just {startY, currentY} ->
        currentY - startY
      Nothing ->
        0

onMouseDown : (Position -> msg) -> Attribute msg
onMouseDown msg =
  on "mousedown" (Decode.map msg Mouse.position)