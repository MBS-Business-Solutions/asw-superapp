String currentLanguage = 'th';
Map<String, String> getPostHeader({String? token}) {
  return {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    if (token != null) 'Authorization': 'Bearer $token',
    'Accept-Language': currentLanguage,
    'Content-Language': currentLanguage,
  };
}

Map<String, String> getHeader({String? token}) {
  return {
    'Accept': 'application/json',
    if (token != null) 'Authorization': 'Bearer $token',
    'Accept-Language': currentLanguage,
    'Content-Language': currentLanguage,
  };
}
