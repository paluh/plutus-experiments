{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TemplateHaskell #-}
{-# OPTIONS_GHC -ddump-splices #-}
{-# OPTIONS_GHC -ddump-to-file #-}

module PlutusExperiments where

import PlutusExperiments.Hex (_0x)
import PlutusTx (
    CompiledCode,
    compile,
    liftCodeDef,
    unsafeApplyCode,
 )
import PlutusTx.Prelude (BuiltinByteString)

test :: BuiltinByteString
test = [_0x|ff|]

plutusFn :: () -> BuiltinByteString
plutusFn = const test

compiled :: () -> CompiledCode BuiltinByteString
compiled = unsafeApplyCode $$(compile [||plutusFn||]) . liftCodeDef
