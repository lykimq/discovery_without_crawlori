(* This file is only generated once, but as long as it exists it
   will not be overwritten, you can safely write in it. To find
   examples for your scenarios, you can look at scenarios.example.ml *)

open Discovery_ocaml_interface
open Tzfunc.Rp
open Factori_types

let key_hash_0 = "tz1cQHF5EpGrGWt3fdYLJrWmNZBVw2oKqPwY"

let nonce = Z.zero

let uri = "http://localhost:4440"

let discovery_storage = Literal [(key_hash_0, (nonce, uri))]

let main () =
  let _ = Tzfunc.Node.set_silent true in
  Format.printf "Deploy discovery contract@." ;
  let>? discovery_kt1, _op_hash =
    (* alice deploys the discovery contract *)
    deploy
      ~node:Blockchain.ithaca_node
      ~name:"discovery"
      ~from:Blockchain.alice_flextesa
      ~amount:10000L
      discovery_storage
  in
  Format.printf "KT1:%s@" discovery_kt1 ;
  (* transfer 1000 mutez from alice to bob *)
  let>? op_hash =
    Blockchain.make_transfer
      ~node:Blockchain.ithaca_node
      ~amount:1000L
      ~from:Blockchain.alice_flextesa
      ~dst:"tz1aSkwEot3L2kmUvcoxzjMomb9mvBNuzFK6" (* to bob_flextesa *)
      ()
  in
  Format.printf "Transfer from alice to bob hash: %s" op_hash ;
  Lwt.return_ok ()

let _ = Lwt_main.run (main ())
