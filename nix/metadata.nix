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

  "cells-v5" = let
    version = "v5-dev";
    rev = "be8813d0bdaf6ee8a3fa8bdb298c4034572feaaa";
  in {
    inherit version;
    buildStamp = "2025-10-03T13:23:04Z";
    source = {
      owner = "pydio";
      repo = "cells";
      inherit rev;
      sha256 = "0m3n7qc0mqnmcak8v6prj4f4akaar01igrk9vx1sgjp808rbfdag";
    };
    vendorHashes = {
      cells = "sha256-4F6XbtpSojYqREenMMCxndxm7dQpsvbMwMxyyjDCF8M=";
    };
  };

  "cells-nightly" = let
    version = "5.0.0-nightly";
    rev = "be8813d0bdaf6ee8a3fa8bdb298c4034572feaaa";
  in {
    inherit version;
    buildStamp = "2025-10-03T13:23:04Z";
    source = {
      owner = "pydio";
      repo = "cells";
      inherit rev;
      sha256 = "0m3n7qc0mqnmcak8v6prj4f4akaar01igrk9vx1sgjp808rbfdag";
    };
    vendorHashes = {
      cells = "sha256-4F6XbtpSojYqREenMMCxndxm7dQpsvbMwMxyyjDCF8M=";
    };
  };
}
