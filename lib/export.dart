//<Packages>
export 'dart:developer' show log;
export 'package:beamer/beamer.dart';
export 'package:cloud_firestore/cloud_firestore.dart';
export 'package:flutter/foundation.dart';
export 'package:flutter/material.dart';
export 'package:flutter_riverpod/flutter_riverpod.dart';
export 'package:get/get.dart';
export 'package:get_it/get_it.dart';
export "package:flash/flash.dart";
export 'package:firebase_auth/firebase_auth.dart';
export 'package:hive/hive.dart';
export 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
export 'package:google_sign_in/google_sign_in.dart';
export 'package:platform/platform.dart';
export 'package:flutter/services.dart';
export 'package:connectivity_plus/connectivity_plus.dart';
export 'package:firebase_core/firebase_core.dart';
export 'package:hive_flutter/hive_flutter.dart';
export "package:responsive_builder/responsive_builder.dart" hide WidgetBuilder;
//</Packages>
/**************/
//<Resources>
export 'resources/constants/api.dart';
export 'resources/constants/app_strings.dart';
export 'resources/constants/exceptions_messages.dart';
export "resources/constants/styles.dart";
export 'resources/exceptions/exceptions.dart';
export 'resources/exceptions/firebase_exception_codes.dart';
export 'resources/helper.dart';
export 'resources/util/widiget_utils.dart';
export "resources/extensions/widget_ext.dart";
export 'resources/global_variables.dart';
//</Resources>
/**************/
//<UI>
export 'main.dart';
export 'ui/app/app.dart';
export 'ui/auth_widget/auth_widget.dart';
export 'ui/login/login.dart';
export 'ui/signup/sign_up.dart';
export 'ui/add_todo_item/add_todo_item.dart';
//</UI>
/**************/
//<Domain>
export 'domain/services/add_todo_item_service/add_todo_item_service.dart';
export 'domain/model/user_type_match_model.dart';
export 'domain/model/user_account_model.dart';

export 'domain/services/network_service/network_service.dart';
export 'domain/model/user_account_model.dart';
//</Domain>
/**************/
//<Config&Pods>
export "config/init_setup.dart";
export "config/dynamic_link_setting/auth_link_setting.dart";
export 'config/routes/routes.dart';
export 'riverpods/pods.dart';
//</Config&Pods>