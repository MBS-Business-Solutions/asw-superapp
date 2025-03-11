String currentLanguage = 'th';
Map<String, String> getHeader({String? token}) {
  return {
    'Accept': 'application/json',
    if (token != null) 'Authorization': 'Bearer $token',
    'Accept-Language': currentLanguage,
    'Content-Language': currentLanguage,
  };
}
