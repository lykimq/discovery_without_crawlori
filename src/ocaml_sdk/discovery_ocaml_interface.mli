open Tzfunc.Proto
open Factori_types
(*Type definition for _default *)

type _default = {uri : string;signature : signature;nonce : int_michelson;key : key}


(** Encode elements of type _default into micheline *)
val _default_encode : _default -> micheline

(** Decode elements of type micheline as _default *)
val _default_decode : micheline -> _default

(** Generate random elements of type _default*)
val _default_generator : unit -> _default

(** The micheline type corresponding to type _default*)
val _default_micheline : micheline



(** Call entrypoint _default of the smart contract. *)
val call__default :   ?node:string -> ?debug:bool -> ?amount:int64 -> from:Blockchain.identity ->
                kt1:Tzfunc.Proto.A.contract ->
                _default -> (string, Tzfunc__.Rp.error) result Lwt.t

(*Type definition for storage *)
type storage = (key_hash,(int_michelson *
 string)) big_map

(** Encode elements of type storage into micheline *)
val storage_encode : storage -> micheline

(** Decode elements of type micheline as storage *)
val storage_decode : micheline -> storage

(** Generate random elements of type storage*)
val storage_generator : unit -> storage

(** The micheline type corresponding to type storage*)
val storage_micheline : micheline



(** A function to deploy the smart contract.
           - amount is the initial balance of the contract
           - node allows to choose on which chain we are deploying
           - name allows to choose a name for the contract you are deploying
           - from is the account which will originate the contract (and pay for its origination)
           The function returns a pair (kt1,op_hash) where kt1 is the address of the contract
           and op_hash is the hash of the origination operation
       *)
val deploy :             ?amount:int64 ->
                         ?node:string ->
                         ?name:string ->
                         ?from:Blockchain.identity ->
                         storage -> (string * string, Tzfunc__.Rp.error) result Lwt.t

(** Downloads and decodes the storage, and then reencodes it.
Allows to check the robustness of the encoding and decoding functions. *)
val test_storage_download :
kt1:Proto.A.contract -> base:EzAPI__Url.TYPES.base_url -> unit -> (unit, Tzfunc__.Rp.error) result