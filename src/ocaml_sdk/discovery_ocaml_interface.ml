open Discovery_code
open Factori_types
open Tzfunc.Proto

type _default = {
  uri : string;
  signature : signature;
  nonce : int_michelson;
  key : key;
}

let _default_encode arg =
  Mprim
    {
      prim = `Pair;
      args =
        [
          Mprim
            {
              prim = `Pair;
              args = [key_encode arg.key; int_michelson_encode arg.nonce];
              annots = [];
            };
          signature_encode arg.signature;
          string_encode arg.uri;
        ];
      annots = [];
    }

let _default_decode (m : micheline) : _default =
  let (key, nonce), signature, uri =
    (tuple3_decode
       (tuple2_decode key_decode int_michelson_decode)
       signature_decode
       string_decode)
      m
  in
  {uri : string; signature : signature; nonce : int_michelson; key : key}

let _default_micheline =
  Mprim
    {
      prim = `pair;
      args =
        [
          Mprim
            {
              prim = `pair;
              args = [key_micheline; int_michelson_micheline];
              annots = [];
            };
          signature_micheline;
          string_micheline;
        ];
      annots = [];
    }

let _default_generator () =
  {
    uri = string_generator ();
    signature = signature_generator ();
    nonce = int_michelson_generator ();
    key = key_generator ();
  }

let call__default ?(node = Blockchain.default_node) ?(debug = false)
    ?(amount = 0L) ~from ~kt1 (param : _default) =
  let param =
    {entrypoint = EPnamed "default"; value = Micheline (_default_encode param)}
  in
  Blockchain.call_entrypoint ~debug ~node ~amount ~from ~dst:kt1 param

type storage = (key_hash, int_michelson * string) big_map

let storage_encode : storage -> micheline =
  big_map_encode
    key_hash_encode
    (tuple2_encode int_michelson_encode string_encode)

let storage_decode =
  big_map_decode
    key_hash_decode
    (tuple2_decode int_michelson_decode string_decode)

let storage_micheline =
  big_map_micheline
    key_hash_micheline
    (tuple2_micheline int_michelson_micheline string_micheline)

let storage_generator () =
  (big_map_generator
     key_hash_generator
     (tuple2_generator int_michelson_generator string_generator))
    ()

let deploy ?(amount = 0L) ?(node = "https://tz.functori.com")
    ?(name = "No name provided") ?(from = Blockchain.bootstrap1) storage =
  let storage = storage_encode storage in
  Blockchain.deploy ~amount ~node ~name ~from ~code (Micheline storage)

let test_storage_download ~kt1 ~base () =
  let open Tzfunc.Rp in
  let open Blockchain in
  Lwt_main.run
  @@ let>? storage =
       get_storage ~base ~debug:(!Factori_types.debug > 0) kt1 storage_decode
     in
     let storage_reencoded = storage_encode storage in
     Lwt.return_ok @@ Factori_types.output_debug
     @@ Format.asprintf
          "Done downloading storage: %s."
          (Ezjsonm_interface.to_string
             (Json_encoding.construct micheline_enc.json storage_reencoded))
