(* This file is only generated once, but as long as it exists it
   will not be overwritten, you can safely write in it. To find
   examples for your scenarios, you can look at scenarios.example.ml *)

open Discovery_ocaml_interface
open Tzfunc.Rp
open Factori_types

let bob_default =
  {
    uri = Blockchain.ithaca_node;
    signature = Blockchain.bob_flextesa.sk;
    nonce = Z.zero;
    key = Blockchain.bob_flextesa.pkh;
  }

let discovery_storage =
  Literal [(Blockchain.alice_flextesa.pkh, (Z.zero, Blockchain.ithaca_node))]

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
  Format.printf "KT1:%s\n" discovery_kt1 ;
  (* call entrypoint in discovery contract *)
  (*let>? bob_op_hash =
    call__default
      ~node:Blockchain.ithaca_node
      ~from:Blockchain.bob_flextesa
      ~kt1:discovery_kt1
      bob_default
  in
  Format.printf "Bob calls discovery entrypoint:%s@" bob_op_hash ;*)
  (* transfer 1000 mutez from alice to bob *)
  let>? op_hash =
    Blockchain.make_transfer
      ~node:Blockchain.ithaca_node
      ~amount:1000L
      ~from:Blockchain.alice_flextesa
      ~dst:Blockchain.bob_flextesa.pkh
      ()
  in
  Format.printf "Transfer from alice to bob hash: %s\n" op_hash ;
  (* get balance *)
  let>? get_balance =
    Blockchain.get_balance ~addr:Blockchain.bob_flextesa.pkh ()
  in
  Format.printf "Balance of bob: %Li@" get_balance ;
  Lwt.return_ok ()

let _ = Lwt_main.run (main ())
