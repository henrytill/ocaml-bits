(* Notes:
   https://github.com/ocaml/ocaml/pull/8900#issuecomment-539530661
   https://okmij.org/ftp/ML/#hlist *)

type _ t =
  | HNil  : unit t
  | HCons : 'a * 'b t -> ('a * 'b) t

type (_, _) index =
  | Z : ('x * 'xs, 'x) index
  | S : ('xs, 'x) index -> ('y * 'xs, 'x) index

let rec get : type tys ty. (tys, ty) index -> tys t -> ty =
  fun index l -> match index, l with
    | Z  , HCons (h, _) -> h
    | S e, HCons (_, t) -> get e t
    | _  , HNil         -> .

let rec length : type tys. tys t -> int = function
  | HNil         -> 0
  | HCons (_, t) -> 1 + length t

let hhead = function
  | HCons (h, _) -> h

let htail = function
  | HCons (_, t) -> t
