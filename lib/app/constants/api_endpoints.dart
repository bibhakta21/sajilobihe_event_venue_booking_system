// class ApiEndpoints {
//   ApiEndpoints._();

//   static const Duration connectionTimeout = Duration(seconds: 1000);
//   static const Duration receiveTimeout = Duration(seconds: 5000);
//   // Use your backend’s base URL (for Android emulator, 10.0.2.2 is common)
//   static const String baseUrl = "http://10.0.2.2:3000/api/";
//   static const String staticBaseUrl =
//       "http://10.0.2.2:3000"; // for static files like images

//   // ====================== Auth Routes =========================
//   // Note: adjust the endpoint names to match your backend
//   static const String login = "users/login";
//   static const String register = "users/signup";
//   // If needed, update other endpoints too
//   static const String getAllUsers = "users/get-all-users";
//   static const String uploadImage = "users/uploadImage";

//   // New endpoint for fetching the current user profile
//   static const String profile = "users/me";

//   static const String submitContact = "http://10.0.2.2:3000/api/contact/submit";

//   // Venue Endpoints
//   // Venue endpoints
//   static const String getAllVenues = "${baseUrl}venues";
//    static const String getAllVenue = "venues";
//   static const String venues = "${baseUrl}venues";

//   // GET: /api/contact (Admin only)
//   static const String getAllContacts = "${baseUrl}contact";
//   // DELETE: /api/contact/:id (Admin only)
//   static const String deleteContact = "${baseUrl}contact";

//     // Booking endpoints
//   static const String bookings = "${baseUrl}bookings";
//   static const String userBookings = "${baseUrl}bookings/my-bookings";
//   // For cancel, approve, delete, we'll append '/:id/cancel', '/:id/approve' or use DELETE on bookings/:id.
// }

//for mobile un comment
class ApiEndpoints {
  ApiEndpoints._();

  static const Duration connectionTimeout = Duration(seconds: 1000);
  static const Duration receiveTimeout = Duration(seconds: 5000);

  // Replace 10.0.2.2 with your local IP address 192.168.101.4
  static const String baseUrl = "http://192.168.101.11:3000/api/";
  static const String staticBaseUrl =
      "http://192.168.101.11:3000"; // for static files like images

  // ====================== Auth Routes =========================
  static const String login = "users/login";
  static const String register = "users/signup";
  static const String getAllUsers = "users/get-all-users";
  static const String uploadImage = "users/uploadImage";

  // Endpoint for fetching the current user profile
  static const String profile = "users/me";

  static const String submitContact =
      "http://192.168.101.11:3000/api/contact/submit";

  // Venue Endpoints
  static const String getAllVenues = "${baseUrl}venues";
  static const String getAllVenue = "venues";
  static const String venues = "${baseUrl}venues";

  // GET: /api/contact (Admin only)
  static const String getAllContacts = "${baseUrl}contact";
  // DELETE: /api/contact/:id (Admin only)
  static const String deleteContact = "${baseUrl}contact";

  // Booking endpoints
  static const String bookings = "${baseUrl}bookings";
  static const String userBookings = "${baseUrl}bookings/my-bookings";
}
