import 'package:flutter/foundation.dart';
import 'samples/calendar/appointment_editor/manager_appointment_editor.dart';
import 'samples/calendar/appointment_editor/employee_appointment_editor.dart';
import 'samples/calendar/special_regions/special_regions.dart';
import 'samples/calendar/shift_scheduler/shift_scheduler.dart';

/// Contains the output widget of sample
/// appropriate key and output widget mapped
Map<String, Function> getSampleWidget() {
  return <String, Function>{
    // Calendar Samples
    'appointment_editor_manager': (Key key) => ManagerAppointmentEditor(key),
    'appointment_editor_employee': (Key key) => EmployeeAppointmentEditor(key),
    'special_regions_calendar': (Key key) => SpecialRegionsCalendar(key),
    'shift_scheduler': (Key key) => ShiftScheduler(key)
  };
}
