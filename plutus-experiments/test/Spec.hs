{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}
{-# OPTIONS_GHC -ddump-splices #-}
{-# OPTIONS_GHC -ddump-to-file #-}

module Main where

import Control.Monad (when)
import qualified Data.ByteString as BS
import Data.ByteString.Base16 as Base16
import Data.ByteString.Short (fromShort)
import qualified Data.ByteString.Short as Short
import qualified Data.List as L
import qualified Data.Text as T
import qualified Data.Text.Encoding as T
import PlutusExperiments (builtinByteStringConstant)
import PlutusExperiments.Hex (_0x)
import PlutusLedgerApi.V3 (serialiseCompiledCode)
import PlutusTx.Builtins.Internal (BuiltinByteString (BuiltinByteString))
import Test.Hspec

main :: IO ()
main = hspec $ do
    describe "Compiled code contains desired byte" $ do
        let bytes = serialiseCompiledCode builtinByteStringConstant
        it "contains the byte" $ do
            when
                (0xFF `L.notElem` Short.unpack bytes && [0xC3, 0xBF] `L.isInfixOf` Short.unpack bytes)
                ( fail $
                    "Byte not found in compiled code:" <> T.unpack (T.decodeUtf8 (Base16.encode (fromShort bytes))) ::
                    IO ()
                )

    describe "ByteString Literal Limitations" $ do
        it "BuiltinByteString handles `xFF` bytes correctly through character repr" $ do
            let bb = "ÿ" :: BuiltinByteString
                BuiltinByteString bs = bb
            bs `shouldBe` BS.pack [0xFF]

        it "BuiltinByteString handles `xFF` bytescorrectly through escape sequence" $ do
            let bb = "\xff" :: BuiltinByteString
                BuiltinByteString bs = bb
            bs `shouldBe` BS.pack [0xFF]

        it "BuiltinByteString does not encode `xFF` using UTF-8" $ do
            let bb = "\xff" :: BuiltinByteString
                BuiltinByteString bs = bb
            bs `shouldNotBe` BS.pack [0xC3, 0xBF]

        it "ByteString handles bytes correctly" $ do
            let bs = "ÿ" :: BS.ByteString
            bs `shouldBe` BS.pack [0xFF]

        it "ByteString handles byte correclty through escape sequence" $ do
            let bs = "\xff" :: BS.ByteString
            bs `shouldBe` BS.pack [0xFF]

        it "Quasi quoter handles byte correctly" $ do
            let bb = [_0x|ff|]
                BuiltinByteString bs = bb
            bs `shouldBe` BS.pack [0xFF]
