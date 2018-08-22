#!/usr/bin/env bash
# Copyright (c) 2018 Trail of Bits, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

SCRIPTS_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
SRC_DIR=$( cd "$( dirname "${SCRIPTS_DIR}" )" && pwd )
CURR_DIR=$( pwd )
TEST_DIR=${CURR_DIR}/testfiles

function DownloadPeTestFiles
{
  [ -d ${TEST_DIR} ] || mkdir ${TEST_DIR}

  # Directly downloadable EXE's

  if [ ! -f ${TEST_DIR}/putty.exe ]; then
  curl -o ${TEST_DIR}/putty.exe -O https://the.earth.li/~sgtatham/putty/0.70/w32/putty.exe
  if [[ $? -ne 0 ]]; then
    printf "[x] Unable to download putty.exe\n"
  fi ; fi

  if [ ! -f ${TEST_DIR}/putty64.exe ]; then
  curl -o ${TEST_DIR}/putty64.exe -O https://the.earth.li/~sgtatham/putty/0.70/w64/putty.exe
  if [[ $? -ne 0 ]]; then
    printf "[x] Unable to download putty64.exe\n"
  fi ; fi


  # EXE's contained within ZIP files

  if [[ ! -f ${TEST_DIR}/handle.exe || ! -f ${TEST_DIR}/handle64.exe ]]; then
  curl -o ${TEST_DIR}/Handle.zip -O https://download.sysinternals.com/files/Handle.zip
  if [[ $? -ne 0 ]]; then
    printf "[x] Unable to download Handle.zip\n"
  fi
  unzip -d ${TEST_DIR} -o ${TEST_DIR}/Handle.zip handle.exe handle64.exe
  if [[ $? -ne 0 ]]; then
    printf "[x] Unable to extract handle.exe\n"
  fi
  rm -rf ${TEST_DIR}/Handle.zip
  fi

  if [ ! -f ${TEST_DIR}/Procmon.exe ]; then
  curl -o ${TEST_DIR}/ProcessMonitor.zip -O https://download.sysinternals.com/files/ProcessMonitor.zip
  if [[ $? -ne 0 ]]; then
    printf "[x] Unable to download ProcessMonitor.zip\n"
  fi
  unzip -d ${TEST_DIR} -o ${TEST_DIR}/ProcessMonitor.zip Procmon.exe
  if [[ $? -ne 0 ]]; then
    printf "[x] Unable to extract Procmon.exe\n"
  fi
  rm -rf ${TEST_DIR}/ProcessMonitor.zip
  fi

  if [[ ! -f ${TEST_DIR}/openssl64.exe || ! -f ${TEST_DIR}/libcrypto-1_1-x64.dll || ! -f ${TEST_DIR}/libssl-1_1-x64.dll ]]; then
  curl -o ${TEST_DIR}/openssl64.zip -O http://wiki.overbyte.eu/arch/openssl-1.1.0i-win64.zip
  if [[ $? -ne 0 ]]; then
    printf "[x] Unable to download openssl64.zip\n"
  fi
  unzip -d ${TEST_DIR} -o ${TEST_DIR}/openssl64.zip openssl.exe libcrypto-1_1-x64.dll libssl-1_1-x64.dll
  if [[ $? -ne 0 ]]; then
    printf "[x] Unable to extract openssl64\n"
  fi
  mv ${TEST_DIR}/openssl.exe ${TEST_DIR}/openssl64.exe
  rm -rf ${TEST_DIR}/openssl64.zip
  fi

  if [[ ! -f ${TEST_DIR}/openssl32.exe || ! -f ${TEST_DIR}/libcrypto-1_1.dll || ! -f ${TEST_DIR}/libssl-1_1.dll ]]; then
  curl -o ${TEST_DIR}/openssl32.zip -O http://wiki.overbyte.eu/arch/openssl-1.1.0i-win32.zip
  if [[ $? -ne 0 ]]; then
    printf "[x] Unable to download openssl32.zip\n"
  fi
  unzip -d ${TEST_DIR} -o ${TEST_DIR}/openssl32.zip openssl.exe libcrypto-1_1.dll libssl-1_1.dll
  if [[ $? -ne 0 ]]; then
    printf "[x] Unable to extract openssl32\n"
  fi
  mv ${TEST_DIR}/openssl.exe ${TEST_DIR}/openssl32.exe
  rm -rf ${TEST_DIR}/openssl32.zip
  fi

  # Double-check the success of gathering the executables

  if [[ -f ${TEST_DIR}/putty.exe && -f ${TEST_DIR}/putty64.exe &&
        -f ${TEST_DIR}/handle.exe && -f ${TEST_DIR}/handle64.exe &&
        -f ${TEST_DIR}/openssl32.exe && -f ${TEST_DIR}/openssl64.exe &&
        -f ${TEST_DIR}/libcrypto-1_1.dll && -f ${TEST_DIR}/libcrypto-1_1-x64.dll &&
        -f ${TEST_DIR}/libssl-1_1.dll && -f ${TEST_DIR}/libssl-1_1-x64.dll &&
        -f ${TEST_DIR}/Procmon.exe ]]; then
    printf "[+] Downloads completed successfully"
    return 0
  fi

  return 1
}

function main
{
  if ! (DownloadPeTestFiles); then
    printf "[x] One or more downloads failed. Test preparation aborted.\n"
  fi

  return $?
}

main $@
exit $?