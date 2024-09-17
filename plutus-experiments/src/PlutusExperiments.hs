{-# LANGUAGE BangPatterns #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TemplateHaskell #-}
{-# OPTIONS_GHC -Wno-orphans #-}
{-# OPTIONS_GHC -ddump-splices #-}
{-# OPTIONS_GHC -ddump-to-file #-}
{-# OPTIONS_GHC -fno-omit-interface-pragmas #-}
{-# OPTIONS_GHC -fno-specialise #-}

module PlutusExperiments where

import PlutusTx (
    CompiledCode,
    compile,
 )
import PlutusTx.Prelude (BuiltinByteString)

builtinByteStringConstant :: CompiledCode BuiltinByteString
builtinByteStringConstant = $$(compile [||"\xff"||])
