module Main exposing (..)

{-| An example of a sortable list using drag and drop
See the README.md file for more information
-}

import Browser
import Browser.Events
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (on, onClick)
import Json.Decode as Decode
import Styles


main : Program () Model Msg
main =
    Browser.element
        { init = \_ -> init
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


init : ( Model, Cmd Msg )
init =
    ( { isReordering = False
      , data = initialList |> List.sort
      , drag = Nothing
      }
    , Cmd.none
    )


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


type alias Drag =
    { itemIndex : Int
    , startY : Int
    , currentY : Int
    }



-- UPDATE


type alias Position =
    { x : Int
    , y : Int
    }


type Msg
    = ToggleReorder
    | DragStart Int Position
    | DragAt Position
    | DragEnd Position


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ToggleReorder ->
            ( { model | isReordering = not model.isReordering }, Cmd.none )

        DragStart idx pos ->
            ( { model
                | drag =
                    Just <|
                        { itemIndex = idx
                        , startY = pos.y
                        , currentY = pos.y
                        }
              }
            , Cmd.none
            )

        DragAt pos ->
            let
                minimumY =
                    model.drag
                        |> Maybe.map (\drag -> drag.startY - drag.itemIndex * 50)
                        |> Maybe.withDefault 0

                maximumY =
                    model.drag
                        |> Maybe.map (\drag -> drag.startY + 50 * ((model.data |> List.length) - 1 - drag.itemIndex))
                        |> Maybe.withDefault 0

                clampedY =
                    pos.y
                        |> clamp minimumY maximumY
            in
            ( { model
                | drag =
                    Maybe.map (\drag -> { drag | currentY = clampedY }) model.drag
              }
            , Cmd.none
            )

        DragEnd pos ->
            case model.drag of
                Just { itemIndex, startY, currentY } ->
                    ( { model
                        | data =
                            moveItem
                                itemIndex
                                ((currentY
                                    - startY
                                    + (if currentY < startY then
                                        -20

                                       else
                                        20
                                      )
                                 )
                                    // 50
                                )
                                model.data
                        , drag = Nothing
                      }
                    , Cmd.none
                    )

                Nothing ->
                    ( { model
                        | drag = Nothing
                      }
                    , Cmd.none
                    )


moveItem : Int -> Int -> List a -> List a
moveItem fromPos offset list =
    let
        listWithoutMoved =
            List.take fromPos list ++ List.drop (fromPos + 1) list

        moved =
            List.take 1 <| List.drop fromPos list
    in
    List.take (fromPos + offset) listWithoutMoved
        ++ moved
        ++ List.drop (fromPos + offset) listWithoutMoved



-- VIEW


view : Model -> Html Msg
view model =
    div
        Styles.pageContainer
        [ div Styles.listHeader
            [ h3 Styles.headerTitle
                [ text "Sortable favorite movies" ]
            , toggleButton model
            ]
        , ul Styles.listContainer <|
            List.indexedMap (itemView model) model.data
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
                [ style "display" "inline-block" ]

            else
                [ style "display" "none" ]

        moveStyle =
            case model.drag of
                Just { itemIndex, startY, currentY } ->
                    if itemIndex == idx then
                        [ style "transform" ("translateY( " ++ String.fromInt (currentY - startY) ++ "px) translateZ(10px)")
                        , style "box-shadow" "0 3px 6px rgba(0,0,0,0.24)"
                        , style "willChange" "transform"
                        ]

                    else
                        []

                Nothing ->
                    []

        makingWayStyle =
            case model.drag of
                Just { itemIndex, startY, currentY } ->
                    if (idx < itemIndex) && (currentY - startY) < (idx - itemIndex) * 50 + 20 then
                        [ style "transform" "translateY(50px)"
                        , style "transition" "transform 200ms ease-in-out"
                        ]

                    else if (idx > itemIndex) && (currentY - startY) > (idx - itemIndex) * 50 - 20 then
                        [ style "transform" "translateY(-50px)"
                        , style "transition" "transform 200ms ease-in-out"
                        ]

                    else if idx /= itemIndex then
                        [ style "transition" "transform 200ms ease-in-out" ]

                    else
                        []

                Nothing ->
                    []
    in
    li (Styles.listItem ++ moveStyle ++ makingWayStyle)
        [ div Styles.itemText [ text item ]
        , button
            (buttonStyle ++ [ onMouseDown <| DragStart idx ])
            [ text "drag" ]
        ]



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    case model.drag of
        Nothing ->
            Sub.none

        Just _ ->
            Sub.batch
                [ Browser.Events.onMouseMove <| Decode.map DragAt mouseDecoder
                , Browser.Events.onMouseUp <| Decode.map DragEnd mouseDecoder
                ]


mouseDecoder : Decode.Decoder Position
mouseDecoder =
    Decode.map2 Position
        (Decode.at [ "clientX" ] Decode.int)
        (Decode.at [ "clientY" ] Decode.int)


onMouseDown : (Position -> msg) -> Attribute msg
onMouseDown msg =
    on "mousedown" (Decode.map msg mouseDecoder)
