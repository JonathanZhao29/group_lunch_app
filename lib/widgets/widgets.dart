import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:group_lunch_app/pages/authentication_page/auth_notifier.dart';
import 'package:group_lunch_app/services/firestore_service.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';
import 'dart:math';

import '../models/event_model.dart';
import '../services/locator.dart';

part 'authentication_form.dart';
part 'scale_slide_in_animation.dart';
part 'twist_in_animation.dart';
part 'event_list.dart';