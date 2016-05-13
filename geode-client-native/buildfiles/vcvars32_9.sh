#!/bin/bash -x
#This script is must be identical to vcvars_*_8.sh except for line below.
#This is done because you cannot get the path of a sourced script.
gf_arch_arg=32bit

function modern_vc_setup () {
  if [ -z "${VSINSTALLDIR:-}" ]; then
    if [ -d "`cygpath 'c:\Program Files\Microsoft Visual Studio 8'`" ]; then
      export VSINSTALLDIR=`cygpath -d 'c:\Program Files\Microsoft Visual Studio 8'`
    else
      echo "ERROR: Unable to determine Visual Studio version for env setup"
      exit -1
    fi  
  fi

  if [ "x$gf_arch_arg" == "x64bit" ]; then
    arch_bin="\\x86_amd64"
    arch_lib="\\amd64"
  elif [ "x$gf_arch_arg" == "x32bit" ]; then
    arch_bin=""
    arch_lib=""
  else
    echo "ERROR: Unable to determine Visual Studio version for env setup"
    exit -1
  fi
  # Compatible with Visual Studio 2008
  export VCINSTALLDIR="$VSINSTALLDIR\VC"
  export MSSDK=`cygpath -d 'c:\Program Files\Microsoft SDKs\Windows\v6.1'`

  if [ -d "$VCINSTALLDIR" ]; then
    echo Setting environment for using Microsoft Visual Studio 2008 tools.
    export VCVER=vc8 # intentionally left it as vc8
    export FrameworkDir="$SYSTEMROOT\\Microsoft.NET\\Framework"
    export FrameworkVersion=v3.5
    export FrameworkSDKDir="$VSINSTALLDIR\\SDK\\v3.5"
    export DevEnvDir="$VSINSTALLDIR\\Common7\\IDE"
  else
    echo "ERROR: Unable to determine Visual Studio version for env setup"
    exit -1
  fi

  VCPATH="$DevEnvDir;$VCINSTALLDIR\\BIN${arch_bin};$VSINSTALLDIR\\Common7\\Tools;$VCINSTALLDIR\\Common7\\Tools\\bin;$FrameworkSDKDir\\bin;$FrameworkDir\\$FrameworkVersion;$MSSDK\\Bin"
  export PATH="`cygpath -up "$VCPATH"`:$PATH"
  export INCLUDE="$VCINSTALLDIR\\ATLMFC\\INCLUDE\;$VCINSTALLDIR\\INCLUDE\;$VCINSTALLDIR\\PlatformSDK\\include\;$FrameworkSDKDir\\include;$MSSDK\\Include"
  export LIB="$VCINSTALLDIR\\ATLMFC\\LIB${arch_lib}\;$VCINSTALLDIR\\LIB${arch_lib}\;$VCINSTALLDIR\\PlatformSDK\\lib${arch_lib}\;$FrameworkSDKDir\\lib${arch_lib};;$MSSDK\\Lib"
}

modern_vc_setup