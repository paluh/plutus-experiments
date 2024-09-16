{-# LANGUAGE TemplateHaskell #-}
{-# OPTIONS_GHC -Wno-orphans #-}

module PlutusExperiments.Hex where

import qualified Data.ByteString as BS
import Data.Char (chr)
import GHC.ByteOrder (ByteOrder (BigEndian))
import Language.Haskell.TH (Exp (SigE), Lit (StringL), Type (ConT), litE, lookupTypeName)
import Language.Haskell.TH.Quote (QuasiQuoter (..))
import PlutusTx.Builtins.Internal (BuiltinByteString (..))
import PlutusTx.Prelude as P
import qualified Prelude as H

{-# NOINLINE fromHex #-}
fromHex :: H.String -> P.BuiltinByteString
fromHex = \case
    (firstNibble : secondNibble : rest) -> do
        let firstNibble' = nibbleToHex firstNibble
        let secondNibble' = nibbleToHex secondNibble
        let byte = firstNibble' * 16 + secondNibble'
        P.integerToByteString BigEndian 1 byte <> fromHex rest
    _ -> ""
  where
    nibbleToHex :: H.Char -> Integer
    nibbleToHex nibble = case nibble of
        '0' -> 0
        '1' -> 1
        '2' -> 2
        '3' -> 3
        '4' -> 4
        '5' -> 5
        '6' -> 6
        '7' -> 7
        '8' -> 8
        '9' -> 9
        'a' -> 10
        'b' -> 11
        'c' -> 12
        'd' -> 13
        'e' -> 14
        'f' -> 15
        _ -> H.error $ "Invalid hex code point:" <> [nibble]

-- -- Assuming BuiltinByteString has a constructor that takes ByteString
-- instance Lift P.BuiltinByteString where
--     lift bs = [| P.BuiltinByteString (BS.pack $(liftList bs)) |]
--       where
--         liftList :: [Word8] -> Q Exp
--         liftList []     = [| [] |]
--         liftList (x:xs) = [| x : $(liftList xs) |]

_0x :: QuasiQuoter
_0x =
    QuasiQuoter
        { quoteExp = \hexStr -> do
            -- lift $  fromHex hexStr
            let BuiltinByteString byteString = fromHex hexStr
            let byteStringStr = map (chr . H.fromIntegral) $ BS.unpack byteString
            litStr <- litE (StringL byteStringStr)
            mName <- lookupTypeName "BuiltinByteString"
            case mName of
                Just name -> do
                    let typeExp = ConT name
                    let sigExp = SigE litStr typeExp
                    return sigExp
                Nothing -> H.fail "To use the _0x quoter, you must import PlutusTx.Prelude (BuiltinByteString)"
        , quotePat = H.error "_0xQuoter cannot be used in pattern context"
        , quoteType = H.error "_0xQuoter cannot be used in type context"
        , quoteDec = H.error "_0xQuoter cannot be used in declaration context"
        }
