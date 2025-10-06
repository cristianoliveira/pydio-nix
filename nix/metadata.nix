{
  cells = let
    version = "4.4.15";
  in {
    inherit version;
    buildStamp = "2025-06-17T07:14:26Z";
    source = {
      owner = "pydio";
      repo = "cells";
      rev = "v${version}";
      sha256 = "0mmhw1psi6kkfgi04wkcn74mbbsbyvshk2j7afwv2lvjvk3qh4kk";
    };
    vendorHashes = {
      cells = "sha256-v23Ep9mTyG8fe5xa9ay9T4/ZEBU9LQHj6keIPZmm5d0=";
      cells-fuse = "sha256-FKXoxGkhUuqYpzYTGzLKFPXU785QjCEKOGemxV+SRxY=";
      protoc-gen-go-client-stub = "sha256-exgsJovl52MpRUM8mNfEJu3opZZk58GnbTu9Ka5CxnA=";
      protoc-gen-go-enhanced-grpc = "sha256-exgsJovl52MpRUM8mNfEJu3opZZk58GnbTu9Ka5CxnA=";
    };
  };

  cells-client = let
    version = "4.3.1";
  in {
    inherit version;
    source = {
      owner = "pydio";
      repo = "cells-client";
      rev = "v${version}";
      sha256 = "1sfiagbmcamjq1iz2cx2c1y3y2rqp945img969pjsvm83ilcay4c";
    };
    vendorHash = "sha256-7duLwaSdMhSQL1+4mSI91Z5aNsVbt4s+hjbRRS4SQTI=";
  };
}
