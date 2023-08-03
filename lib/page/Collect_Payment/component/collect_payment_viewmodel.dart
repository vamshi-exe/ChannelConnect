import 'package:channel_connect/app/app_repo.dart';
import 'package:channel_connect/app/locator.dart';
import 'package:channel_connect/model/report_response_data.dart';
import 'package:channel_connect/network/api_service.dart';
import 'package:channel_connect/util/utility.dart';
import 'package:flutter/material.dart';

class CollectPaymentViewModel extends ChangeNotifier {
  late DateTime _selectedDateTime;
  final _apiService = locator<ApiService>();

  String selectedType = "Booking Date";
  DateTime? selectedFromDate;
  DateTime? selectedToDate;
  String? selectedGuestName;
  String? selectedBookingNo;

  late DateTime defaultStartDate, defaultEndDate;

  bool _loading = false;
  bool _isError = false;
  late AppRepo _appRepo;
  List<HotelReservation> _reportList = [];

  bool get loading => _loading;
  bool get error => _isError;

  intiData(BuildContext context, AppRepo repo) {
    this._appRepo = repo;
    final datetime = DateTime.now();
    defaultStartDate = DateTime(datetime.year, datetime.month, 1);
    defaultEndDate = DateTime(datetime.year, datetime.month + 1, 1 - 1);
    fetchReportData();
  }

  List<HotelReservation> get reportList => _reportList;

  fetchReportData() async {
    try {
      _loading = true;
      _isError = false;
      notifyListeners();
      final isBooking = selectedType == "Booking Date";
      final start = Utility.formattedServerDateForRequest(
          selectedFromDate ?? defaultStartDate);
      final end = Utility.formattedServerDateForRequest(
          selectedToDate ?? defaultEndDate);
      final response = await _apiService.fetchReportList(
          _appRepo.selectedProperty.hotelId.toString(),
          start,
          end,
          selectedGuestName ?? "",
          selectedBookingNo ?? "",
          isBooking);
      _reportList =
          response.oTAHotelResNotifRS!.hotelReservations!.hotelReservation!;

      _loading = false;
      _isError = false;
      notifyListeners();
    } catch (e) {
      _loading = false;
      _isError = true;
      print("report error is " + e.toString());
      notifyListeners();
    }
  }

  void applyClicked(
      String type, DateTime from, DateTime to, String guest, String booking) {
    selectedType = type;
    selectedFromDate = from;
    selectedToDate = to;
    selectedGuestName = guest;
    selectedBookingNo = booking;
    notifyListeners();
    fetchReportData();
  }

  void resetClicked() {
    selectedType = "Booking Date";
    selectedFromDate = null;
    selectedToDate = null;
    selectedGuestName = "";
    selectedBookingNo = "";
    notifyListeners();
    fetchReportData();
  }

  String getFromToDateFormatedText(DateTime start, DateTime end) {
    // "(13th Feb, 2022 - 14th Feb, 2022)",
    final startText = Utility.formattedServerDate(start);
    final endText = Utility.formattedServerDate(end);
    return "( $startText - $endText )";
  }
}
