//===------ unittest/AST/Language.cpp - AST unit test support -------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
//  This file defines language options for AST unittests.
//
//===----------------------------------------------------------------------===//

#include "Language.h"
#include "llvm/Support/ErrorHandling.h"

namespace clang {

std::vector<std::string> getCommandLineArgsForTesting(TestLanguage Lang) {
  std::vector<std::string> Args;
  // Test with basic arguments.
  switch (Lang) {
  case Lang_C:
    Args = {"-x", "c", "-std=c99"};
    break;
  case Lang_C89:
    Args = {"-x", "c", "-std=c89"};
    break;
  case Lang_CXX:
    Args = {"-std=c++98", "-frtti"};
    break;
  case Lang_CXX11:
    Args = {"-std=c++11", "-frtti"};
    break;
  case Lang_CXX14:
    Args = {"-std=c++14", "-frtti"};
    break;
  case Lang_CXX17:
    Args = {"-std=c++17", "-frtti"};
    break;
  case Lang_CXX2a:
    Args = {"-std=c++2a", "-frtti"};
    break;
  case Lang_OBJCXX:
    Args = {"-x", "objective-c++", "-frtti"};
    break;
  case Lang_OpenCL:
    llvm_unreachable("Not implemented yet!");
  }
  return Args;
}

} // end namespace clang
