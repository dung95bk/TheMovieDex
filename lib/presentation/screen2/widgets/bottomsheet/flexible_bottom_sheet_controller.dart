// Copyright (c) 2019-present,  SurfStudio LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.


import 'package:flutter/material.dart';
import 'package:themoviedex/presentation/screen2/widgets/bottomsheet/flexible_bottom_sheet_owner.dart';

/// Default controller of showing bottom sheet that can resize and scroll.
class FlexibleBottomSheetController {
  FlexibleBottomSheetController(
    this._context, {
    this.owner,
  });

  final BuildContext _context;
  final FlexibleBottomSheetOwner owner;

  /// Show registered bottom sheet.
  Future<T> show<T>(
    Object type, {
    BottomSheetData data,
  }) {
    return owner.registeredBottomSheetShowers[type](
      _context,
      data: data,
    ) as Future<T>;
  }
}
