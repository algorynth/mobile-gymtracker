{
description = "Flutter 3.13.x";

  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };


inputs = {
  nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  flake-utils.url = "github:numtide/flake-utils";
};
outputs = { nixpkgs, flake-utils, ... }:
  flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs {
        inherit system;
        config = {
          android_sdk.accept_license = true;
          allowUnfree = true;
        };
      };
      buildToolsVersion = "34.0.0";
      androidComposition = pkgs.androidenv.composeAndroidPackages {
        buildToolsVersions = [ buildToolsVersion "30.0.3" ];
        platformVersions = [ "29" "30" "31" "32" "33" "34" "35" "28" ];
        abiVersions = [ "armeabi-v7a" "arm64-v8a" ];
        cmakeVersions = [ "latest" "3.22.1" ];
      #   toolsVersion = "26.1.1";
      #   platformToolsVersion = "33.0.3";
      #   # buildToolsVersions = [ buildToolsVersionForAapt2 ];
        includeEmulator = true;
        emulatorVersion = "34.1.19";
      #   platformVersions = [ "28" "29" "30" "31" ];
      #   includeSources = false;
      #   includeSystemImages = false;
      #   systemImageTypes = [ "google_apis_playstore" ];
      #   abiVersions = [ "armeabi-v7a" "arm64-v8a" ];
      #   cmakeVersions = [ "3.10.2" ];
        includeNDK = true;
        ndkVersions = [ "22.0.7026061" "26.3.11579264" ];
      #   useGoogleAPIs = false;
        useGoogleTVAddOns = false;

        extraLicenses = [
          "android-googletv-license"
          "android-sdk-arm-dbt-license"
          "android-sdk-license"
          "android-sdk-preview-license"
          "google-gdk-license"
          "intel-android-extra-license"
          "intel-android-sysimage-license"
          "mips-android-sysimage-license"
       ];
      };
      androidSdk = androidComposition.androidsdk;
      # pubspecLock = pkgs.lib.importJSON ./pubspec.lock.json;

      gradleZip = pkgs.fetchurl {
        url = builtins.readFile (
          pkgs.runCommandLocal "distributionUrl"
            {
              nativeBuildInputs = with pkgs; [ coreutils ripgrep sd ];
            }
            ''
              rg -o --replace '$1' 'distributionUrl=(.+)' ${./android/gradle/wrapper/gradle-wrapper.properties} \
                | sd --fixed-strings '\:' ':' \
                | tr -d '\n' \
                > $out
              cat $out
            ''
        );
        hash = "sha256-uwmYL99ScY5MeyUCPRDfbTWl//lphgvfWlvSejqyep4=";
      };
        jdk = pkgs.lib.trivial.throwIfNot (pkgs.lib.versions.major pkgs.jdk.version == "21")
            "jdk updated to ${pkgs.lib.versions.major pkgs.jdk.version}, sync android/app/build.gradle versions"
            pkgs.jdk;
    in
    {
      devShell = pkgs.mkShell {
          ANDROID_SDK_ROOT = "${androidSdk}/libexec/android-sdk";
          CHROME_EXECUTABLE = "${pkgs.ungoogled-chromium}/bin/chromium";
          JAVA_HOME = "${pkgs.jdk.home}";

          GRADLE_OPTS = "-Dorg.gradle.project.android.aapt2FromMavenOverride=${androidSdk}/libexec/android-sdk/build-tools/34.0.0/aapt2";
          buildInputs = with pkgs; [
            flutter
            androidSdk
            jdk17
            ungoogled-chromium
            android-studio-full
          ];
        };
      packages.default = pkgs.stdenv.mkDerivation {
        pname = "aifred-apk";
        version = "1.0.0";
        src = ./.;
        buildInputs = [
          pkgs.flutter
          androidSdk
        ];

        ANDROID_SDK_ROOT = "${androidSdk}/libexec/android-sdk";
        GRADLE_OPTS = "-Dorg.gradle.project.android.aapt2FromMavenOverride=${androidSdk}/libexec/android-sdk/build-tools/34.0.0/aapt2";
        FLUTTER_SDK = "${pkgs.flutter}";

        buildPhase = ''
          echo hello
          echo $GRADLE_OPTS
          echo $ANDROID_SDK_ROOT
          echo NIX_BUILD_TOP
          echo $NIX_BUILD_TOP

          echo current folder
          pwd
          echo $HOME

          mkdir .pub-cache

          export PUB_CACHE="$(pwd)/.pub-cache"
          echo $PUB_CACHE

          flutter doctor -v
        '';
      };
      packages.apk-flutter = pkgs.flutter.buildFlutterApplication rec {
        pname = "aifred-apk";
        version = "1.0.0";
        src = ./.;
        targetFlutterPlatform = "universal";
        autoPubspecLock = src + "/pubspec.lock";
        ANDROID_HOME = "${androidSdk}/libexec/android-sdk";
        ANDROID_SDK_ROOT = "${androidSdk}/libexec/android-sdk";
        ANDROID_NDK_ROOT = "${ANDROID_HOME}/ndk-bundle";
        JAVA_HOME = jdk.home;
        GRADLE_OPTS = "-Dorg.gradle.project.android.aapt2FromMavenOverride=${ANDROID_HOME}/build-tools/${buildToolsVersion}/aapt2";
        gradleFlags = [ GRADLE_OPTS ];


            preBuild = ''
              set -x

              export HOME=$TMPDIR

              touch env.sh


              # Substitute the gradle-all zip URL by a local file to prevent downloads from happening while building an Android app
              ${pkgs.lib.getExe pkgs.sd} 'distributionUrl=.+' 'distributionUrl=file\://${gradleZip}' android/gradle/wrapper/gradle-wrapper.properties
              cat android/gradle/wrapper/gradle-wrapper.properties

              # sets up gradlew wrapper
              flutter build apk -v --config-only

              # add nix flags to gradlew
              local flagsArray=()
              concatTo flagsArray gradleFlags gradleFlagsArray

              local wrapperFlagsArray=()
              for flag in "''${flagsArray[@]}"; do
                wrapperFlagsArray+=("--add-flags" "$flag")
              done

              gradlewPath="$PWD/android/gradlew"
              wrapProgram "$gradlewPath" \
                --run 'set -x' \
                --add-flags '--info' \
                --add-flags '--debug' \
                "''${wrapperFlagsArray[@]}"

              gradle() {
                command "$gradlewPath" "$@"
              }
            '';

            buildPhase = ''
              runHook preBuild

              mkdir -p build/flutter_assets/fonts

              flutter build apk -v --split-debug-info="$debug" $flutterBuildFlags

              runHook postBuild
            '';

            installPhase = ''
              runHook preInstall

              cp -v ./build/app/outputs/flutter-apk/app-release.apk $out

              runHook postInstall
            '';
      };
      packages.web = pkgs.flutter.buildFlutterApplication rec {
        pname = "aifred-web";
        version = "1.0.0";
        src = ./.;
        targetFlutterPlatform = "web";
        # inherit pubspecLock;
        autoPubspecLock = src + "/pubspec.lock";
      };
    });
}
