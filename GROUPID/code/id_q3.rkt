#lang racket/base
;; S1: binary tree traversals.
;; A tree is either () (the empty tree) or a three-element list
;; (value left right), where left and right are trees and value is a
;; number or a one-character symbol.

;; (node-value tree) -> value
;; The value stored at the root of a non-empty tree.
;; Reading: a node is (value left right), so its value is the first element.
(define (node-value tree)
  (car tree))

;; (node-left tree) -> tree
;; The left subtree of a non-empty tree.
;; Reading: the left subtree is the second element of (value left right).
(define (node-left tree)
  (cadr tree))

;; (node-right tree) -> tree
;; The right subtree of a non-empty tree.
;; Reading: the right subtree is the third element of (value left right).
(define (node-right tree)
  (caddr tree))

;; (inorder tree) -> list
;; Returns the values of tree in inorder: left subtree, node, right subtree.
;; Reading: (walk t acc) gives the inorder values of t followed by acc.
;; Walking () gives acc unchanged. Walking a node first walks the right
;; subtree onto acc, puts the node's value in front of that, and then walks
;; the left subtree onto the result, so the left values come out first.
;; acc holds the values that come after t in the output. The outer call to
;; walk is a tail call, and no append is needed.
(define (inorder tree)
  (let walk ([t tree] [acc '()])
    (if (null? t)
        acc
        (walk (node-left t)
              (cons (node-value t) (walk (node-right t) acc))))))

;; (preorder tree) -> list
;; Returns the values of tree in preorder: node, left subtree, right subtree.
;; Reading: (walk t acc) gives the preorder values of t followed by acc.
;; Walking () gives acc unchanged. Walking a node first walks the right
;; subtree onto acc, then walks the left subtree onto that, and finally puts
;; the node's value in front, so the node comes out before both subtrees.
;; acc holds the values that come after t in the output. The last step is
;; the cons, so neither call to walk is a tail call; the recursion only goes
;; as deep as the tree is tall, and no append is needed.
(define (preorder tree)
  (let walk ([t tree] [acc '()])
    (if (null? t)
        acc
        (cons (node-value t)
              (walk (node-left t) (walk (node-right t) acc))))))

;; (postorder tree) -> list
;; Returns the values of tree in postorder: left subtree, right subtree, node.
;; Reading: (walk t acc) gives the postorder values of t followed by acc.
;; Walking () gives acc unchanged. Walking a node first puts the node's
;; value in front of acc, then walks the right subtree onto that, and then
;; walks the left subtree onto the result, so the node comes out after both
;; subtrees. acc holds the values that come after t in the output. The
;; outer call to walk is a tail call, and no append is needed.
(define (postorder tree)
  (let walk ([t tree] [acc '()])
    (if (null? t)
        acc
        (walk (node-left t)
              (walk (node-right t) (cons (node-value t) acc))))))

;; (print-inorder tree) -> prints one line
;; S1.a: prints the inorder list of tree with display, then a newline.
;; Reading: not recursive itself; inorder builds the list and this function
;; only prints it. (newline) is the last expression, so the function
;; returns nothing and a top-level call prints nothing extra.
(define (print-inorder tree)
  (display (inorder tree))
  (newline))

;; (print-all-traversals tree) -> prints three lines
;; S1.b: prints the inorder, preorder and postorder lists of tree, in that
;; order, each with display and followed by a newline.
;; Reading: not recursive itself; the three traversal helpers build the
;; lists and this function only prints them one per line. (newline) is the
;; last expression, so a top-level call prints nothing extra.
(define (print-all-traversals tree)
  (display (inorder tree))
  (newline)
  (display (preorder tree))
  (newline)
  (display (postorder tree))
  (newline))
