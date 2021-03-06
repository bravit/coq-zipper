module Tree where

import qualified Prelude

data Nat =
   O
 | S Nat

nth_error :: (([]) a1) -> Nat -> Prelude.Maybe a1
nth_error l n =
  case n of {
   O -> case l of {
         ([]) -> Prelude.Nothing;
         (:) x _ -> Prelude.Just x};
   S n0 -> case l of {
            ([]) -> Prelude.Nothing;
            (:) _ l0 -> nth_error l0 n0}}

fold_left :: (a1 -> a2 -> a1) -> (([]) a2) -> a1 -> a1
fold_left f l a0 =
  case l of {
   ([]) -> a0;
   (:) b t -> fold_left f t (f a0 b)}

type T = Prelude.Int

type A = Prelude.Int

tree_rect :: a1 -> (A -> (([]) tree) -> a1) -> tree -> a1
tree_rect f f0 t =
  case t of {
   t_nil -> f;
   t_tree x x0 -> f0 x x0}

tree_rec :: a1 -> (A -> (([]) tree) -> a1) -> tree -> a1
tree_rec =
  tree_rect

context_rect :: (Nat -> A -> (([]) tree) -> a1) -> cntx -> a1
context_rect f c =
  case c of {
   move x x0 x1 -> f x x0 x1}

context_rec :: (Nat -> A -> (([]) tree) -> a1) -> cntx -> a1
context_rec =
  context_rect

type ZipperTree = (,) tree (([]) cntx)

treeToZipper :: tree -> ZipperTree
treeToZipper t =
  (,) t ([])

type Direction = Nat

type T0 = tree

type A0 = tree

nth_remove :: Nat -> (([]) A0) -> ([]) A0
nth_remove n l =
  case n of {
   O -> case l of {
         ([]) -> ([]);
         (:) _ t -> t};
   S n' -> case l of {
            ([]) -> ([]);
            (:) h t -> (:) h (nth_remove n' t)}}

nth_insert :: Nat -> (([]) A0) -> A0 -> ([]) A0
nth_insert n l x =
  case n of {
   O -> (:) x l;
   S n' -> case l of {
            ([]) -> ([]);
            (:) h t -> (:) h (nth_insert n' t x)}}

moveTopAction :: tree -> cntx -> tree
moveTopAction t zop =
  case zop of {
   move n a l -> t_tree a (nth_insert n l t)}

moveTop :: ZipperTree -> ZipperTree
moveTop z =
  case case z of {
        (,) _ y -> y} of {
   ([]) -> z;
   (:) h t -> (,) (moveTopAction (case z of {
                                   (,) x _ -> x}) h) t}

moveDown :: Direction -> ZipperTree -> ZipperTree
moveDown d z =
  case case z of {
        (,) x _ -> x} of {
   t_nil -> z;
   t_tree a l ->
    case nth_error l d of {
     Prelude.Just t -> (,) t ((:) (move d a (nth_remove d l))
      (case z of {
        (,) _ y -> y}));
     Prelude.Nothing -> z}}

nodesOf :: tree -> ([]) tree
nodesOf t =
  case t of {
   t_nil -> ([]);
   t_tree _ l -> l}

modify :: ZipperTree -> (tree -> tree) -> ZipperTree
modify z f =
  (,) (f (case z of {
           (,) x _ -> x})) (case z of {
                             (,) _ y -> y})

zipperToTree :: ZipperTree -> tree
zipperToTree z =
  fold_left moveTopAction (case z of {
                            (,) _ y -> y}) (case z of {
                                             (,) x _ -> x})

rootSubtree :: Nat -> tree -> Prelude.Maybe tree
rootSubtree n t =
  case t of {
   t_nil -> Prelude.Nothing;
   t_tree _ l -> nth_error l n}

